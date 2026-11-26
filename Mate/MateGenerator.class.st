Class {
	#name : 'MateGenerator',
	#superclass : 'MateGrammarVisitor',
	#instVars : [
		'builtInGenerators',
		'maxDerivationHeight',
		'random',
		'nilProbability',
		'injector',
		'violationsPerObject',
		'invalidDerivations',
		'maxObjects',
		'maxNesting',
		'objectCount',
		'rootType',
		'softMaxObjects',
		'closing',
		'truncations',
		'instanceGeneator',
		'heapLimit',
		'derivedSizes',
		'finishableTypes'
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

{ #category : 'depth limit' }
MateGenerator >> canFinish: aType [
	"Whether some option of aType can be built with finitely many objects."

	^ self type: aType finishesWith: self finishableTypes
]

{ #category : 'looping' }
MateGenerator >> checkLoopAt: context [

	rootType ifNil: [ ^ self ].

	objectCount := objectCount + 1.

	objectCount > maxObjects ifTrue: [
		MateGenerationLoop
			signalFor: rootType
			objects: objectCount
			path: context path
			reason: 'more than ', maxObjects printString, ' objects were generated' ].

	context level > self maxNesting ifTrue: [
		MateGenerationLoop
			signalFor: rootType
			objects: objectCount
			path: context path
			reason: 'objects are nested more than ', self maxNesting printString, ' levels deep' ].

	closing ifTrue: [ ^ self ].

	objectCount > self softMaxObjects ifTrue: [
		closing := true.
		MateGenerationOverflow new signal ]
]

{ #category : 'depth limit' }
MateGenerator >> computeFinishableTypes [
	"The declared types that have a finite instance: a least fixed point over the grammar."

	| finishable changed |

	finishable := IdentitySet new.
	[
		changed := false.
		grammar typeDeclarations keysAndValuesDo: [ :type :decl |
			((finishable includes: type) not and: [ self declaration: decl finishesWith: finishable ]) ifTrue: [
				finishable add: type.
				changed := true ] ].
		changed ] whileTrue.
	^ finishable
]

{ #category : 'visiting' }
MateGenerator >> cutDerivation: instVarDecl from: context [

	| terminals type |

	terminals := instVarDecl types reject: [ :each | context includes: (self declarationFor: each) ].
	terminals ifEmpty: [ ^ self nilNode: instVarDecl from: context ].

	type := (terminals asSortedCollection: [ :a :b | a name <= b name ]) asArray atRandom: context random.

	^ ((self declarationFor: type) visit: self from: context constraint: instVarDecl constraint) declaration: instVarDecl
]

{ #category : 'depth limit' }
MateGenerator >> declaration: decl finishesWith: finishable [

	decl isBuiltIn ifTrue: [ ^ true ].
	(decl respondsTo: #instanceVariableDeclarations) ifFalse: [ ^ true ].
	^ decl instanceVariableDeclarations allSatisfy: [ :field | self field: field finishesWith: finishable ]
]

{ #category : 'invariants' }
MateGenerator >> deriveSizeOf: instVarDecl in: decl on: node from: context [
	"When a size invariant constrains this collection field, compute its size from the fields already built.
	A size outside the bounds of the collection regenerates the field the invariant starts from."

	| invariant attempts size |

	invariant := decl invariants
		detect: [ :each | each isSizeInvariant and: [ each field = instVarDecl name ] ]
		ifNone: [ ^ self ].

	attempts := 0.
	[
		size := invariant sizeFrom: [ :name | (node edges at: name ifAbsent: [ nil ]) ifNotNil: [ :edge | edge instance ] ].
		size isNil or: [ size isInteger and: [ instVarDecl acceptSize: size ] ] ] whileFalse: [
			attempts >= self invariantAttempts ifTrue: [
				^ self error: 'Cannot satisfy ', invariant printString, ' in ', decl type name, ': ', size printString, ' is not an allowed size of ', instVarDecl name ].
			attempts := attempts + 1.
			self regenerateField: invariant sourceField of: decl on: node from: context ].

	size ifNotNil: [ derivedSizes at: instVarDecl put: size ]
]

{ #category : 'visiting' }
MateGenerator >> enforce: invariant of: decl on: node from: context [

	| attempts |

	"Size invariants hold by construction (see deriveSizeOf:in:on:from:)."
	invariant isSizeInvariant ifTrue: [ ^ self ].

	attempts := invariant operator = '=' ifTrue: [ self invariantAttempts ] ifFalse: [ 0 ].
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

{ #category : 'depth limit' }
MateGenerator >> field: field finishesWith: finishable [

	(field isKindOf: MateInstRefVarDecl) ifTrue: [ ^ true ].
	(field isKindOf: MateInstOneOfVarDecl) ifTrue: [ ^ true ].
	(field isKindOf: MateInstArrayVarDecl) ifTrue: [
		^ field minSize = 0 or: [ self type: field elementType finishesWith: finishable ] ].
	^ field nullable or: [ self type: field type finishesWith: finishable ]
]

{ #category : 'visiting' }
MateGenerator >> fill: decl size: size from: context [

	| node edges |

	node := MateOGDerivationNode new declaration: decl; context: context.
	edges := (1 to: size) collect: [ :i | | edge |
		edge := self gen: (self typeOf: decl elementType at: context ifNotClosing: [ decl chooseOneElementTypeFrom: context ]) from: context.
		node addEdge: edge at: i.
		edge ].

	node instance: (decl collectionFrom: (edges collect: #instance)).
	^ node
]

{ #category : 'depth limit' }
MateGenerator >> finishableTypes [

	^ finishableTypes ifNil: [ finishableTypes := self computeFinishableTypes ]
]

{ #category : 'accessing' }
MateGenerator >> gen: type [

	instanceGeneator reset.

	^ (self gen: type from: self newContext) instance
]

{ #category : 'accessing' }
MateGenerator >> gen: type from: context [

	context ensureRandom: random.

	^ self guard: [ (self declarationFor: type) visit: self from: context constraint: nil ] for: type
]

{ #category : 'accessing' }
MateGenerator >> gen: type from: context validity: aValidity violating: kinds [

	| derivation |

	(aValidity between: 0 and: 1) ifFalse: [ self error: 'Validity must be between 0 and 1' ].

	derivation := self gen: type from: context.

	context random next >= aValidity ifTrue: [
		derivation violations: (self injector inject: violationsPerObject into: derivation kinds: kinds random: context random).
		derivation isValid ifFalse: [ invalidDerivations at: derivation instance put: derivation ] ].

	^ derivation
]

{ #category : 'accessing' }
MateGenerator >> gen: type validity: aValidity violating: kinds [

	^ (self gen: type from: self newContext validity: aValidity violating: kinds) instance
]

{ #category : 'accessing' }
MateGenerator >> genVariant: derivation [

	derivation context ensureRandom: random.

	^ self
		guard: [ derivation declaration visit: self from: derivation context constraint: nil ]
		for: derivation declaration type
]

{ #category : 'looping' }
MateGenerator >> guard: aBlock for: aType [

	rootType ifNotNil: [ ^ aBlock value ].

	rootType := aType.
	objectCount := 0.
	closing := false.
	derivedSizes removeAll.
	finishableTypes := nil.
	^ [ heapLimit
			ifNil: [ aBlock value ]
			ifNotNil: [ (MateHeapGuard limit: heapLimit) run: aBlock ] ]
		ensure: [ rootType := nil ]
]

{ #category : 'accessing' }
MateGenerator >> heapLimit [

	^ heapLimit
]

{ #category : 'accessing' }
MateGenerator >> heapLimit: bytes [

	heapLimit := bytes
]

{ #category : 'initialization' }
MateGenerator >> initialize [

	super initialize.
	maxDerivationHeight := 12.
	nilProbability := 0.1.
	maxObjects := 1000000.
	closing := false.
	truncations := 0.
	random := Random new.
	violationsPerObject := 1.
	invalidDerivations := WeakIdentityKeyDictionary new.
	instanceGeneator := MateGrammarBaseInstanceGenerator new.
	derivedSizes := IdentityDictionary new.
	builtInGenerators := self class defaultBuiltInGenerators
]

{ #category : 'accessing' }
MateGenerator >> injector [

	^ injector ifNil: [ injector := MateViolationInjector new generator: self; yourself ]
]

{ #category : 'visiting' }
MateGenerator >> insert: node path: path [

	path insertReference: node instance
]

{ #category : 'accessing' }
MateGenerator >> instanceGenerator [

	^ instanceGeneator
]

{ #category : 'accessing' }
MateGenerator >> invalidDerivationOf: anInstance [

	^ invalidDerivations at: anInstance ifAbsent: [ nil ]
]

{ #category : 'accessing' }
MateGenerator >> invariantAttempts [

	^ 30
]

{ #category : 'testing' }
MateGenerator >> isRecursive: instVarDecl from: context [

	^ instVarDecl types anySatisfy: [ :each | context includes: (self declarationFor: each) ]
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
MateGenerator >> maxNesting [

	^ maxNesting ifNil: [ maxDerivationHeight + (2 * (grammar typeDeclarations size + 1)) ]
]

{ #category : 'accessing' }
MateGenerator >> maxNesting: anInteger [

	maxNesting := anInteger
]

{ #category : 'accessing' }
MateGenerator >> maxObjects [

	^ maxObjects
]

{ #category : 'accessing' }
MateGenerator >> maxObjects: anInteger [

	maxObjects := anInteger
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

	^ instanceGeneator objectInstance: node constraint: constraint
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

{ #category : 'invariants' }
MateGenerator >> regenerateField: fieldName of: decl on: node from: context [
	"Generate a field again while its owner is being built (its instance is not filled yet)."

	| fieldDecl |

	fieldDecl := decl instanceVariableDeclarationNamed: fieldName.
	node addEdge: (fieldDecl visit: self from: context constraint: nil) at: fieldName
]

{ #category : 'accessing' }
MateGenerator >> seed: anInteger [

	random := Random seed: anInteger
]

{ #category : 'as yet unclassified' }
MateGenerator >> selectRandomExistingInstanceWithProb: prob [

	instanceGeneator := MateRandomExistingInstanceGenerator new selectionExistingProbability: prob
]

{ #category : 'visiting' }
MateGenerator >> set: fieldName to: aValue on: node [

	node instance instVarNamed: fieldName put: aValue.
	(node edges at: fieldName ifAbsent: [ nil ]) ifNotNil: [ :edge | edge instance: aValue ]
]

{ #category : 'visiting' }
MateGenerator >> sizeOf: decl from: context [

	"A size computed from a size invariant of the owner wins, even at the depth limit."
	derivedSizes at: decl ifPresent: [ :size |
		derivedSizes removeKey: decl.
		^ size ].

	"At the depth limit, collections of composite elements take their minimum size when their elements
	can be finished (a minimum of 0 still ends the recursion), and are left empty otherwise:
	a type that needs at least one element of itself cannot be finished at any depth."
	(context level >= maxDerivationHeight and: [ (self isTerminal: decl elementType) not ]) ifTrue: [
		^ (self canFinish: decl elementType) ifTrue: [ decl minSize ] ifFalse: [ 0 ] ].
	closing ifTrue: [ ^ decl minSize ].

	^ (decl minSize to: decl maxSize) atRandom: context random
]

{ #category : 'accessing' }
MateGenerator >> softMaxObjects [

	^ softMaxObjects ifNil: [ maxObjects // 10 ]
]

{ #category : 'accessing' }
MateGenerator >> softMaxObjects: anInteger [

	softMaxObjects := anInteger
]

{ #category : 'accessing' }
MateGenerator >> truncations [

	^ truncations
]

{ #category : 'depth limit' }
MateGenerator >> type: aType finishesWith: finishable [

	^ (MateOptionalType typesOf: aType) anySatisfy: [ :each |
		(grammar typeDeclarations at: each ifAbsent: [ nil ])
			ifNil: [ true ]
			ifNotNil: [ :decl | decl isBuiltIn or: [ finishable includes: each ] ] ]
]

{ #category : 'depth limit' }
MateGenerator >> typeOf: aType at: context ifNotClosing: aBlock [
	"Past the depth limit, a union with built-in options (values, nil) takes one of them, so the derivation ends;
	otherwise the option is chosen as usual."

	| leaves |

	context level >= maxDerivationHeight ifFalse: [ ^ aBlock value ].
	leaves := (MateOptionalType typesOf: aType) select: [ :each | self isTerminal: each ].
	(leaves isEmpty or: [ leaves size = (MateOptionalType typesOf: aType) size ]) ifTrue: [ ^ aBlock value ].
	^ leaves atRandom: context random
]

{ #category : 'accessing' }
MateGenerator >> violationsPerObject [

	^ violationsPerObject
]

{ #category : 'accessing' }
MateGenerator >> violationsPerObject: anInteger [

	violationsPerObject := anInteger
]

{ #category : 'visiting' }
MateGenerator >> visitArrayDecl: decl from: context [

	| size count childContext derived |

	childContext := context copy.
	childContext push: decl.
	self checkLoopAt: childContext.

	derived := derivedSizes includesKey: decl.
	size := self sizeOf: decl from: childContext.
	count := objectCount.

	^ [ self fill: decl size: size from: childContext ]
		on: MateGenerationOverflow
		do: [ :overflow |
			"A derived size cannot shrink without breaking its invariant."
			(derived not and: [ size > decl minSize ]) ifFalse: [ overflow pass ].
			objectCount := count.
			truncations := truncations + 1.
			overflow return: (self fill: decl size: decl minSize from: childContext) ]
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

"	(context level >= maxDerivationHeight and: [ self isRecursive: instVarDecl from: context ])
		ifTrue: [ ^ self cutDerivation: instVarDecl from: context ]."

	type := self typeOf: instVarDecl type at: context ifNotClosing: [ instVarDecl chooseOneTypeFrom: context ].

	derivation := (self declarationFor: type) visit: self from: context constraint: instVarDecl constraint.

	^ derivation declaration: instVarDecl
]

{ #category : 'visiting' }
MateGenerator >> visitInstanceDeclaration: decl from: context [

	| childContext node instance |

	node := MateOGInstanceNode new declaration: decl; context: context.

	(instanceGeneator
		existingInstanceFor: decl
		random: context random
		closing: (closing or: [ context level >= maxDerivationHeight ]))
			ifNotNil: [ :existing | ^ node instance: existing; yourself ].

	childContext := context copy.
	childContext push: decl.
	self checkLoopAt: childContext.

	instance := instanceGeneator newInstanceFor: decl.
	childContext parentNode: node.

	decl instanceVariableDeclarations do: [ :instVarDecl | | edge |
		self deriveSizeOf: instVarDecl in: decl on: node from: childContext.
		edge := instVarDecl visit: self from: childContext constraint: nil.
		node addEdge: edge at: instVarDecl name.
	].

	node instance: (instanceGeneator fill: instance from: node).

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
