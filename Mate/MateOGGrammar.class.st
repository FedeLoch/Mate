Class {
	#name : 'MateOGGrammar',
	#superclass : 'Object',
	#instVars : [
		'typeDeclarations',
		'builtInTypeDeclarations',
		'generator',
		'parser',
		'writer'
	],
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'instance creation' }
MateOGGrammar class >> from: instance [
	
	^ self new feedByObjectInstance: instance seen: Set new
	
]

{ #category : 'instance creation' }
MateOGGrammar class >> fromObjects: collection [
	
	| seen |
	
	seen := Set new.
	
	^ collection inject: self new into: [ :grammar :instance |
		grammar feedByObjectInstance: instance seen: seen
	]
]

{ #category : 'accessing' }
MateOGGrammar >> addTypeDeclaration: decl [

	typeDeclarations at: decl type ifPresent: [
		(typeDeclarations at: decl type) feed: decl
	] ifAbsent: [
		decl grammar: self.
		typeDeclarations at: decl type put: decl
	]
]

{ #category : 'accessing' }
MateOGGrammar >> addTypeDeclarations: declarations [

	declarations do: [ :decl | self addTypeDeclaration: decl ]
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> backpropagate: node improvement: improvement [

	node recursiveBackPropagate: improvement seen: Set new
]

{ #category : 'accessing' }
MateOGGrammar >> builtInTypeDeclarations [

	| builtInTypes |

	builtInTypes := { SmallInteger. Float . SmallFloat64 . Boolean . ByteString . Color . Point }.

	^ builtInTypes inject: Dictionary new into: [ :dict :type |
		dict at: type put: (MateBuiltInDecl new type: type; grammar: self).
		dict
	]
]

{ #category : 'accessing' }
MateOGGrammar >> defineObjectGraph [

	^ nil
]

{ #category : 'accessing' }
MateOGGrammar >> feedByGraphDescription [

	| description |
		
	description := self defineObjectGraph.
	description ifNil: [ ^ nil ].
	
	self addTypeDeclarations: (MateLanguageParser parse: description)
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> feedByObjectInstance: instance [ 

	^ self feedByObjectInstance: instance seen: Set new
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> feedByObjectInstance: instance seen: seen [

	| decl |

	(seen includes: instance) ifTrue: [ ^ nil ].
	
	decl := self typeDeclarationBy: instance.

	self addTypeDeclaration: decl.
	
	seen add: instance.
	
	decl instanceVariableDeclarations do: [ :instDecl |
		self feedByObjectInstance: (instance instVarNamed: instDecl name) seen: seen
	]
	
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> gen: type [

	^ generator gen: type
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> gen: type from: context [

	^ generator gen: type from: context
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> genVariant: derivation [

	^ generator genVariant: derivation
]

{ #category : 'accessing' }
MateOGGrammar >> generator [

	^ generator 
]

{ #category : 'accessing' }
MateOGGrammar >> initialize [

	super initialize.
	typeDeclarations := self builtInTypeDeclarations.
	generator := MateGenerator new grammar: self.
	writer := MateWriter new grammar: self.
	parser := MateParser new grammar: self.
	self feedByGraphDescription.
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> instArrayVar: name by: array [

	| elementType filteredArray |
	
	filteredArray := array reject: #isNil.
	
	elementType :=  filteredArray ifEmpty: [ Object ] ifNotEmpty: [
		filteredArray allButFirst inject: filteredArray first class into: [ :class :element | class | element class ]
	].

	^ MateInstArrayVarDecl new name: name; elementType: elementType; sizeBetween: 0 and: 10.
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> instanceVarDeclaration: name by: var [

	| type |
	
	type := (Boolean acceptType: var class) ifTrue: [ Boolean ] ifFalse: [ var class ].

	^ MateInstVarDecl new name: name; type: type
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> instanceVariable: name by: var [

	^ (var isArray) ifTrue: [ self instArrayVar: name by: var ] ifFalse: [
		self instanceVarDeclaration: name by: var
	]
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> mateDefinition [

	^ writer mateDefinition
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> mateDefinition: type [

	^ writer mateDefinition: type
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> parse: object [

	^ parser parse: object
]

{ #category : 'accessing' }
MateOGGrammar >> parser [

	 ^ parser
]

{ #category : 'rendering' }
MateOGGrammar >> render [

	| canvas shapes totalVisits |
	
	totalVisits := self totalVisitsAcrossDeclarations.
	shapes := self renderShapes: totalVisits.
	
	canvas := RSCanvas new.
	canvas addAll: shapes.

	RSLineBuilder arrowedLine
		withBorderAttachPoint;
		color: (Color gray alpha: 0.5);
		canvas: canvas;
		connectFrom: [ :node | node parent ].

	RSTreeLayout new
		horizontalGap: 30;
		verticalGap: 50;
		on: canvas nodes.

	canvas @ RSCanvasController.
	canvas @ RSZoomToFitCanvasInteraction.

	^ canvas
]

{ #category : 'rendering' }
MateOGGrammar >> renderShapes: totalVisits [

	^ typeDeclarations values flatCollect: [ :decl | decl renderShapes: totalVisits parent: nil ]
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> replace: node by: variant [

	| parent |
	
	parent := node context parentNode.

	parent ifNotNil: [
		parent replaceChild: node by: variant
	].
	
	variant replaceRefDeclarationsFrom: node.
]

{ #category : 'rendering' }
MateOGGrammar >> totalVisitsAcrossDeclarations [

	^ typeDeclarations values sum: [ :decl | decl totalVisits ]
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> typeDeclarationBy: instance [

	| instanceVarDecls |
	
	instanceVarDecls := instance class allInstVarNames inject: OrderedCollection new into: [ :acc :name | | var |
		var := instance instVarNamed: name.
		(var class = UndefinedObject) ifFalse: [
			acc add: (self instanceVariable: name by: var)
		].
	
		acc
	].

	 ^ MateInstDecl new type: instance class; instanceVariableDeclarations: instanceVarDecls asArray
]

{ #category : 'accessing' }
MateOGGrammar >> typeDeclarations [

	^ typeDeclarations
]
