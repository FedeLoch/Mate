Class {
	#name : 'MateGenerator',
	#superclass : 'MateGrammarVisitor',
	#instVars : [
		'builtInGenerators',
		'maxDerivationHeight'
	],
	#category : 'Mate-Generation',
	#package : 'Mate',
	#tag : 'Generation'
}

{ #category : 'visiting' }
MateGenerator >> builInInstance: decl constraint: aConstraint [

	^ (builtInGenerators at: decl type) generateWithConstraint: aConstraint
]

{ #category : 'as yet unclassified' }
MateGenerator >> emptyInstanceDeclaration: aClass [

	^ MateInstDecl new type: aClass
]

{ #category : 'accessing' }
MateGenerator >> gen: type [

	^ (self gen: type from: MateContext new) instance
]

{ #category : 'accessing' }
MateGenerator >> gen: type from: context [

	| decl |
	
	decl := (grammar typeDeclarations at: type).

	^ decl visit: self from: context constraint: nil

]

{ #category : 'accessing' }
MateGenerator >> initialize [ 

	super initialize.
	maxDerivationHeight := 10.
	builtInGenerators := {
		SmallInteger -> MateSmallIntegerGenerator new.
		Float -> MateFloatGenerator new.
		Boolean -> MateBooleanGenerator new.
		String -> MateStringGenerator new.
		Color -> MateColorGenerator new.
		Point -> MatePointGenerator new
	} asDictionary.
]

{ #category : 'accessing' }
MateGenerator >> maxDerivationHeight [

	^ maxDerivationHeight
]

{ #category : 'accessing' }
MateGenerator >> maxDerivationHeight: height [

	maxDerivationHeight := height 
]

{ #category : 'visiting' }
MateGenerator >> objectInstance: node constraint: constraint [

	^ node edges keys inject: node declaration type new into: [ :inst :edgeName |
		inst instVarNamed: edgeName put: (node edges at: edgeName) instance.
		inst
	]
]

{ #category : 'visiting' }
MateGenerator >> visitArrayDecl: decl from: context [

	| node size edges childContext |
	
	childContext := context copy.
	childContext push: decl.

	"Check if we've exceeded max derivation height"
	size := (childContext level >= maxDerivationHeight) ifTrue: [ 0 ]
		ifFalse: [ (decl minSize to: decl maxSize) atRandom ].
	
	node := MateOGDerivationNode new declaration: decl; context: childContext.

	edges := (1 to: size) collect: [ :i | | edge |
		edge := self gen: decl elementType from: childContext.
		node addEdge: edge at: i.
		edge
	].

	^ node instance: (edges collect: #instance)
]

{ #category : 'visiting' }
MateGenerator >> visitBuiltinDeclaration: decl from: context [
	
	^ self visitBuiltinDeclaration: decl from: context constraint: nil

]

{ #category : 'visiting' }
MateGenerator >> visitBuiltinDeclaration: decl from: context constraint: aConstraint [

	| instance |
	
	instance := self builInInstance: decl constraint: aConstraint.

	^ MateOGBuiltInNode new declaration: decl; instance: instance; context: context

]

{ #category : 'visiting' }
MateGenerator >> visitClassDeclaration: decl from: context [ 

	self error: 'Class declarations not yet implemented'.
]

{ #category : 'visiting' }
MateGenerator >> visitInstVarDecl: instVarDecl from: context [

	| type declaration derivation |
	
	type := instVarDecl chooseOneTypeFrom: context.
	
	declaration := grammar typeDeclarations at: type ifPresent: #yourself ifAbsent: [
		self emptyInstanceDeclaration: type
	].

	derivation := declaration visit: self from: context constraint: instVarDecl constraint.

	^ derivation declaration: instVarDecl
]

{ #category : 'visiting' }
MateGenerator >> visitInstanceDeclaration: decl from: context [

	| childContext node |
	
	"Create a new context with this declaration in the path"
	childContext := context copy.
	childContext push: decl.
	
	node := MateOGInstanceNode new declaration: decl; context: context.
	childContext parentNode: node.
	
	"Check if we've exceeded max derivation height"
	(childContext level >= maxDerivationHeight) ifFalse: [
		decl instanceVariableDeclarations do: [ :instVarDecl | | edge |
			edge := instVarDecl visit: self from: childContext constraint: nil.
			node addEdge: edge at: instVarDecl name.
		]
	].

	node instance: (self objectInstance: node constraint: nil).

	^ node
]

{ #category : 'visiting' }
MateGenerator >> visitOneOfDecl: decl from: context [

	| instance |
	"TODO: Delete MateOGBuiltInNode and use only one node type?"
	instance := decl getOne: context.

	^ MateOGBuiltInNode new declaration: decl; instance: instance; context: context
]
