Class {
	#name : 'MateGenerator',
	#superclass : 'MateGrammarVisitor',
	#instVars : [
		'builtInGenerators',
		'maxDerivationHeight',
		'random',
		'nilProbability'
	],
	#category : 'Mate-Generation',
	#package : 'Mate',
	#tag : 'Generation'
}

{ #category : 'accessing' }
MateGenerator class >> defaultBuiltInGenerators [

	^ {
		SmallInteger -> (MateIntegerGenerator new type: SmallInteger).
		LargePositiveInteger -> (MateIntegerGenerator new type: LargePositiveInteger).
		LargeNegativeInteger -> (MateIntegerGenerator new type: LargeNegativeInteger).
		Float -> (MateFloatGenerator new type: Float).
		SmallFloat64 -> (MateFloatGenerator new type: SmallFloat64).
		BoxedFloat64 -> (MateFloatGenerator new type: BoxedFloat64).
		Boolean -> (MateBooleanGenerator new type: Boolean).
		ByteString -> (MateByteStringGenerator new type: ByteString).
		WideString -> (MateByteStringGenerator new type: WideString).
		ByteSymbol -> (MateByteSymbolGenerator new type: ByteSymbol).
		Character -> (MateCharacterGenerator new type: Character).
		Color -> (MateColorGenerator new type: Color).
		Point -> (MatePointGenerator new type: Point).
		Object -> (MateObjectGenerator new type: Object).
		UndefinedObject -> (MateNilGenerator new type: UndefinedObject).
	} asDictionary
]

{ #category : 'visiting' }
MateGenerator >> builtInInstance: decl constraint: aConstraint from: context [

	^ (builtInGenerators at: decl type) generateWithConstraint: aConstraint random: context random
]

{ #category : 'visiting' }
MateGenerator >> cutDerivation: instVarDecl from: context [

	| terminals type |

	terminals := instVarDecl types select: [ :each | (self declarationFor: each) isBuiltIn ].
	terminals ifEmpty: [ ^ self nilNode: instVarDecl from: context ].

	type := (terminals asSortedCollection: [ :a :b | a name <= b name ]) asArray atRandom: context random.

	^ ((self declarationFor: type) visit: self from: context constraint: instVarDecl constraint) declaration: instVarDecl
]

{ #category : 'visiting' }
MateGenerator >> enforce: invariant of: decl on: node from: context [

	| attempts |

	attempts := 0.
	[ (invariant holdsFor: node instance) or: [ attempts >= self invariantAttempts ] ] whileFalse: [
		attempts := attempts + 1.
		self
			regenerate: (decl instanceVariableDeclarationNamed: (attempts odd ifTrue: [ invariant right ] ifFalse: [ invariant left ]))
			on: node
			from: context ].

	(invariant holdsFor: node instance) ifTrue: [ ^ self ].

	invariant operator = '=' ifTrue: [
		self set: invariant right to: (node instance instVarNamed: invariant left) on: node ].
	invariant operator = '<=' ifTrue: [ | leftValue rightValue |
		leftValue := node instance instVarNamed: invariant left.
		rightValue := node instance instVarNamed: invariant right.
		self set: invariant left to: rightValue on: node.
		self set: invariant right to: leftValue on: node ]
]

{ #category : 'visiting' }
MateGenerator >> enforceInvariantsOf: decl on: node from: context [

	2 timesRepeat: [
		decl invariants do: [ :invariant | self enforce: invariant of: decl on: node from: context ] ]
]

{ #category : 'accessing' }
MateGenerator >> gen: type [

	^ (self gen: type from: self newContext) instance
]

{ #category : 'accessing' }
MateGenerator >> gen: type from: context [

	context ensureRandom: random.

	^ (self declarationFor: type) visit: self from: context constraint: nil
]

{ #category : 'accessing' }
MateGenerator >> genVariant: derivation [

	derivation context ensureRandom: random.

	^ derivation declaration visit: self from: derivation context constraint: nil
]

{ #category : 'initialization' }
MateGenerator >> initialize [

	super initialize.
	maxDerivationHeight := 12.
	nilProbability := 0.1.
	random := Random new.
	builtInGenerators := self class defaultBuiltInGenerators
]

{ #category : 'visiting' }
MateGenerator >> insert: node path: path [

	path insertReference: node instance
]

{ #category : 'accessing' }
MateGenerator >> invariantAttempts [

	^ 30
]

{ #category : 'testing' }
MateGenerator >> isTerminal: aType [

	^ (MateOptionalType typesOf: aType) allSatisfy: [ :each | (self declarationFor: each) isBuiltIn ]
]

{ #category : 'accessing' }
MateGenerator >> maxDerivationHeight [

	^ maxDerivationHeight
]

{ #category : 'accessing' }
MateGenerator >> maxDerivationHeight: height [

	maxDerivationHeight := height
]

{ #category : 'accessing' }
MateGenerator >> newContext [

	^ MateContext new random: random
]

{ #category : 'accessing' }
MateGenerator >> nilNode: decl from: context [

	^ MateOGBuiltInNode new declaration: decl; instance: nil; context: context
]

{ #category : 'accessing' }
MateGenerator >> nilProbability [

	^ nilProbability
]

{ #category : 'accessing' }
MateGenerator >> nilProbability: aProbability [

	nilProbability := aProbability
]

{ #category : 'visiting' }
MateGenerator >> objectInstance: node constraint: constraint [

	^ node edges keys inject: node declaration type new into: [ :inst :edgeName |
		inst instVarNamed: edgeName put: (node edges at: edgeName) instance.
		inst
	]
]

{ #category : 'accessing' }
MateGenerator >> random [

	^ random
]

{ #category : 'visiting' }
MateGenerator >> regenerate: instVarDecl on: node from: context [

	| edge |

	instVarDecl ifNil: [ ^ self ].

	edge := instVarDecl visit: self from: context constraint: nil.
	node addEdge: edge at: instVarDecl name.
	node instance instVarNamed: instVarDecl name put: edge instance
]

{ #category : 'accessing' }
MateGenerator >> seed: anInteger [

	random := Random seed: anInteger
]

{ #category : 'visiting' }
MateGenerator >> set: fieldName to: aValue on: node [

	node instance instVarNamed: fieldName put: aValue.
	(node edges at: fieldName ifAbsent: [ nil ]) ifNotNil: [ :edge | edge instance: aValue ]
]

{ #category : 'visiting' }
MateGenerator >> visitArrayDecl: decl from: context [

	| node size edges childContext |

	childContext := context copy.
	childContext push: decl.

	size := ((childContext level >= maxDerivationHeight) and: [ (self isTerminal: decl elementType) not ])
		ifTrue: [ 0 ]
		ifFalse: [ (decl minSize to: decl maxSize) atRandom: context random ].

	node := MateOGDerivationNode new declaration: decl; context: childContext.

	edges := (1 to: size) collect: [ :i | | type edge |
		type := decl chooseOneElementTypeFrom: childContext.
		edge := self gen: type from: childContext.
		node addEdge: edge at: i.
		edge
	].

	^ node instance: (decl collectionFrom: (edges collect: #instance))
]

{ #category : 'visiting' }
MateGenerator >> visitBuiltinDeclaration: decl from: context [

	^ self visitBuiltinDeclaration: decl from: context constraint: nil
]

{ #category : 'visiting' }
MateGenerator >> visitBuiltinDeclaration: decl from: context constraint: aConstraint [

	| instance |

	instance := self builtInInstance: decl constraint: aConstraint from: context.

	^ MateOGBuiltInNode new declaration: decl; instance: instance; context: context
]

{ #category : 'visiting' }
MateGenerator >> visitClassDeclaration: decl from: context [

	self error: 'Class declarations not yet implemented'.
]

{ #category : 'visiting' }
MateGenerator >> visitInstRefDecl: decl from: context [

	^ MateOGBuiltInNode new declaration: decl; instance: nil; context: context
]

{ #category : 'visiting' }
MateGenerator >> visitInstVarDecl: instVarDecl from: context [

	| type derivation |

	(instVarDecl nullable and: [ context random next < nilProbability ])
		ifTrue: [ ^ self nilNode: instVarDecl from: context ].

	context level >= maxDerivationHeight
		ifTrue: [ ^ self cutDerivation: instVarDecl from: context ].

	type := instVarDecl chooseOneTypeFrom: context.

	derivation := (self declarationFor: type) visit: self from: context constraint: instVarDecl constraint.

	^ derivation declaration: instVarDecl
]

{ #category : 'visiting' }
MateGenerator >> visitInstanceDeclaration: decl from: context [

	| childContext node |

	childContext := context copy.
	childContext push: decl.

	node := MateOGInstanceNode new declaration: decl; context: context.
	childContext parentNode: node.

	decl instanceVariableDeclarations do: [ :instVarDecl | | edge |
		edge := instVarDecl visit: self from: childContext constraint: nil.
		node addEdge: edge at: instVarDecl name.
	].

	node instance: (self objectInstance: node constraint: nil).

	self enforceInvariantsOf: decl on: node from: childContext.

	decl selfReferences do: [ :path |
		self insert: node path: path.
		path updateDerivation: node withInstance: node instance.
	].

	^ node
]

{ #category : 'visiting' }
MateGenerator >> visitOneOfDecl: decl from: context [

	| instance |

	instance := decl getOne: context.

	^ MateOGBuiltInNode new declaration: decl; instance: instance; context: context
]
