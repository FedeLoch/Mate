Class {
	#name : 'MateOGGrammar',
	#superclass : 'Object',
	#instVars : [
		'typeDeclarations',
		'builtInTypeDeclarations',
		'generator',
		'parser',
		'writer',
		'blackList'
	],
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'instance creation' }
MateOGGrammar class >> collectInstancesFrom: test [

	^ [
		test setUp.
		[ | result |
			result := test perform: test selectorTest.
			((test allInstanceVariables, { result }) reject: #isNil) asOrderedCollection
		] ensure: [ test tearDown ]
	] on: Error, TestFailure do: [ :e | e return: OrderedCollection new ]
]

{ #category : 'instance creation' }
MateOGGrammar class >> collectTestSuiteInstances: testSuite [

	^ testSuite tests flatCollect: [ :test | self collectInstancesFrom: test ]
]

{ #category : 'instance creation' }
MateOGGrammar class >> from: instance [
	
	^ self new feedByObjectInstance: instance seen: IdentitySet new
	
]

{ #category : 'instance creation' }
MateOGGrammar class >> fromFile: aFilePath [

	| grammarDef |

	grammarDef := aFilePath asFileReference contents.
	
	^ self new addTypeDeclarations: (MateLanguageParser parse: grammarDef)
]

{ #category : 'instance creation' }
MateOGGrammar class >> fromObjects: collection [
	
	| seen |
	
	seen := IdentitySet new.
	
	^ collection inject: self new into: [ :grammar :instance |
		grammar feedByObjectInstance: instance seen: seen.
		grammar
	]
]

{ #category : 'instance creation' }
MateOGGrammar class >> fromObjects: collection maxDepth: maxDepth [
	
	| seen |
	
	seen := IdentitySet new.
	
	^ collection inject: self new into: [ :grammar :instance |
		grammar feedByObjectInstance: instance seen: seen maxDepth: maxDepth.
		grammar
	]
]

{ #category : 'instance creation' }
MateOGGrammar class >> fromTest: aTestClass [

	^ self fromObjects: (self collectTestSuiteInstances: aTestClass suite)
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

	^ MateGenerator defaultBuiltInGenerators keys inject: Dictionary new into: [ :dict :type |
		dict at: type put: (MateBuiltInDecl new type: type; grammar: self).
		dict
	]
]

{ #category : 'accessing' }
MateOGGrammar >> defineObjectGraph [

	^ nil
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> explorationPercentage [

	^ self explorationPercentageOf: (self reachableDeclarationsFrom: (typeDeclarations values reject: #isBuiltIn))
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> explorationPercentageFrom: aType [

	^ self explorationPercentageOf: (self reachableDeclarationsFrom: { typeDeclarations at: aType })
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> explorationPercentageOf: declarations [

	declarations ifEmpty: [ ^ 0 ].

	^ (declarations collect: #explorationPercentage) sum / declarations size
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

	^ self feedByObjectInstance: instance seen: IdentitySet new
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> feedByObjectInstance: instance seen: seen [

	^ self feedByObjectInstance: instance seen: seen maxDepth: SmallInteger maxVal
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> feedByObjectInstance: instance seen: seen maxDepth: maxDepth [

	| decl |
	
	(maxDepth = 0) ifTrue: [ ^ nil ]. 
	
	instance ifNil: [ ^ nil ].
	
	(blackList includes: instance class) ifTrue: [ ^ nil ].
	
	instance isClass ifTrue: [ ^ nil ].
	
	(seen includes: instance) ifTrue: [ ^ nil ].
	
	decl := self typeDeclarationBy: instance.

	self addTypeDeclaration: decl.
	
	seen add: instance.
	
	decl instanceVariableDeclarations do: [ :instDecl |
		self feedByObjectInstance: (instance instVarNamed: instDecl name) seen: seen maxDepth: (maxDepth -1)
	].

	instance isArray ifTrue: [
		instance do: [ :element | self feedByObjectInstance: element seen: seen maxDepth: (maxDepth - 1) ]
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
	blackList := {
		             CompiledMethod.
		             SystemEnvironment.
		             ConstantBlockClosure.
		             FullBlockClosure.
		             CleanBlockClosure.
		             OCMethodSemanticScope.
		             CompiledBlock } asSet.
	self feedByGraphDescription
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> instArrayVar: name by: array [

	| elementType filteredArray |
	
	filteredArray := array reject: #isNil.
	
	elementType := filteredArray ifEmpty: [ nil ] ifNotEmpty: [
		filteredArray allButFirst
			inject: (self typeOf: filteredArray first)
			into: [ :type :element | MateOptionalType union: type with: (self typeOf: element) ]
	].

	^ MateInstArrayVarDecl new name: name; elementType: elementType; sizeBetween: 0 and: filteredArray size.
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> instanceVarDeclaration: name by: var [

	var isBehavior ifTrue: [ ^ MateInstOneOfVarDecl new name: name; options: { var } ].

	^ MateInstVarDecl new name: name; type: (self typeOf: var)
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

{ #category : 'as yet unclassified' }
MateOGGrammar >> reachableDeclarationsFrom: roots [

	| reached pending |
	
	reached := IdentitySet new.
	pending := OrderedCollection withAll: roots.
	
	[ pending isEmpty ] whileFalse: [ | decl |
		decl := pending removeFirst.
		(reached includes: decl) ifFalse: [
			reached add: decl.
			decl reachableTypes do: [ :type |
				typeDeclarations at: type ifPresent: [ :next | pending add: next ] ] ] ].

	^ reached asArray
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
	
	variant replaceRefDeclarationsFrom: node.

	parent ifNotNil: [
		parent replaceChild: node by: variant.
		variant rootParent updateAllReferences
	]
]

{ #category : 'accessing' }
MateOGGrammar >> seed: anInteger [

	generator seed: anInteger
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

{ #category : 'as yet unclassified' }
MateOGGrammar >> typeOf: anObject [

	^ (anObject class includesBehavior: Boolean)
		ifTrue: [ Boolean ]
		ifFalse: [ anObject class ]
]

{ #category : 'accessing' }
MateOGGrammar >> typeDeclarations [

	^ typeDeclarations
]
