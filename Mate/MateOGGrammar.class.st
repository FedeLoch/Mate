Class {
	#name : 'MateOGGrammar',
	#superclass : 'Object',
	#instVars : [
		'typeDeclarations',
		'builtInTypeDeclarations',
		'generator',
		'parser'
	],
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'accessing' }
MateOGGrammar >> addTypeDeclaration: decl [

	decl grammar: self.
	typeDeclarations at: decl type put: decl
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
	parser := MateParser new grammar: self.
	self feedByGraphDescription.
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

	| canvas |
	
	canvas := RSCanvas new.
	canvas addAll: self renderShapes.

	RSLineBuilder arrowedLine
		withBorderAttachPoint;
		canvas: canvas;
		connectFrom: [ :e | 1 halt ].

	RSRadialTreeLayout new
		horizontalGap: 50;
		verticalGap: 30;
		on: canvas nodes.

	canvas @ RSCanvasController.
	canvas @ RSZoomToFitCanvasInteraction.

	^ canvas
]

{ #category : 'rendering' }
MateOGGrammar >> renderShapes [

	^ typeDeclarations flatCollect: #renderShapes
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

{ #category : 'accessing' }
MateOGGrammar >> typeDeclarations [

	^ typeDeclarations
]
