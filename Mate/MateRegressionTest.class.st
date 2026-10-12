Class {
	#name : 'MateRegressionTest',
	#superclass : 'TestCase',
	#category : 'Mate-Regression Tests',
	#package : 'Mate',
	#tag : 'Regression Tests'
}

{ #category : 'helpers' }
MateRegressionTest >> grammarFrom: aString [

	^ MateOGGrammar new
		addTypeDeclarations: (MateLanguageParser parse: aString);
		yourself
]

{ #category : 'helpers' }
MateRegressionTest >> parseWithoutHanging: aString [

	^ [ MateLanguageParser parse: aString ]
		valueWithin: 2 seconds
		onTimeout: [ self fail: 'Parser did not terminate for ', aString printString ]
]

{ #category : 'tests - generation' }
MateRegressionTest >> testArrayReplacementUsesEdgeIndex [

	| grammar node arrayNode child variant |

	grammar := self grammarFrom: 'BlChildrenArray -> { array: { type: [ Boolean ], size: 6 } }'.
	node := grammar gen: BlChildrenArray from: MateContext new.
	arrayNode := node edges at: 'array'.
	arrayNode instance at: 1 put: true; at: 6 put: true.
	child := arrayNode edges at: 6.
	child instance: true.
	variant := MateOGBuiltInNode new declaration: child declaration; instance: #replaced; context: child context.

	arrayNode declaration updateMe: arrayNode replacingChild: child by: variant.

	self assert: (arrayNode instance at: 1) equals: true.
	self assert: (arrayNode instance at: 6) equals: #replaced
]

{ #category : 'tests - generation' }
MateRegressionTest >> testArrayWithoutSizeHasDefaultBounds [

	| grammar instance |

	grammar := self grammarFrom: 'BlChildrenArray -> { array: { type: [ SmallInteger ] } }'.
	grammar seed: 1.

	20 timesRepeat: [
		instance := grammar gen: BlChildrenArray.
		self assert: (instance array size between: 0 and: 10) ]
]

{ #category : 'tests - constraints' }
MateRegressionTest >> testConstraintBoundsAreExclusiveForGreaterThanAndLessThan [

	self deny: ((MateConstraint greaterThan: 0) includes: 0).
	self assert: ((MateConstraint greaterThan: 0) includes: 1).
	self deny: ((MateConstraint greaterThan: 0.5) includes: 0.5).
	self assert: ((MateConstraint greaterThan: 0.5) includes: 0.6).
	self deny: ((MateConstraint lessThan: 10) includes: 10).
	self assert: ((MateConstraint between: -5 and: 5) includes: -5).
	self deny: ((MateConstraint between: -5 and: 5) includes: Float nan)
]

{ #category : 'tests - coverage' }
MateRegressionTest >> testExplorationPercentageIgnoresUnreachableBuiltIns [

	| grammar |

	grammar := MatePlayerGrammar new.
	grammar gen: Player.

	self assert: (grammar explorationPercentageFrom: Player) equals: 1
]

{ #category : 'tests - coverage' }
MateRegressionTest >> testExplorationPercentageOfDeclarationsWithoutInstanceVariables [

	self assert: (MateOGGrammar from: Warrior new) explorationPercentage equals: 0
]

{ #category : 'tests - coverage' }
MateRegressionTest >> testExplorationPercentageWithArraysAndOneOfs [

	| grammar percentage |

	grammar := MateBlocGrammar new.
	grammar seed: 3.
	5 timesRepeat: [ grammar gen: BlElement ].

	percentage := grammar explorationPercentage.

	self assert: (percentage between: 0 and: 1).
	self assert: percentage > 0
]

{ #category : 'tests - generation' }
MateRegressionTest >> testFloatGeneratorRespectsDeclaredClass [

	| generator random values |

	random := Random seed: 7.
	generator := MateFloatGenerator new type: SmallFloat64.
	500 timesRepeat: [ self assert: ((generator generate: random) isKindOf: SmallFloat64) ].

	generator := MateFloatGenerator new type: Float.
	values := (1 to: 500) collect: [ :i | generator generate: random ].
	self assert: (values anySatisfy: [ :each | each isNaN or: [ each isInfinite ] ])
]

{ #category : 'tests - generation' }
MateRegressionTest >> testFloatGeneratorRespectsGreaterThan [

	| generator random constraint |

	random := Random seed: 7.
	generator := MateFloatGenerator new type: Float.
	constraint := MateConstraint greaterThan: 0.5.

	200 timesRepeat: [ self assert: (generator generateWithConstraint: constraint random: random) > 0.5 ]
]

{ #category : 'tests - inference' }
MateRegressionTest >> testInferredArraysMergeElementTypes [

	| first second grammar decl |

	first := BlChildrenArray new instVarNamed: 'array' put: { 1 }; yourself.
	second := BlChildrenArray new instVarNamed: 'array' put: { 'x' . 'y' }; yourself.

	grammar := MateOGGrammar fromObjects: { first . second }.
	decl := (grammar typeDeclarations at: BlChildrenArray) instanceVariableDeclarations first.

	self assert: (decl elementType acceptType: SmallInteger).
	self assert: (decl elementType acceptType: ByteString).
	self assert: decl minSize equals: 0.
	self assert: decl maxSize equals: 2
]

{ #category : 'tests - inference' }
MateRegressionTest >> testInferredBooleanArraysGenerate [

	| sample grammar generated |

	sample := BlChildrenArray new instVarNamed: 'array' put: { true . false . true }; yourself.
	grammar := MateOGGrammar from: sample.

	generated := grammar gen: BlChildrenArray.

	self assert: (generated array allSatisfy: [ :each | each isKindOf: Boolean ])
]

{ #category : 'tests - inference' }
MateRegressionTest >> testInferredClassValuedFieldsBecomeOneOfAndRoundTrip [

	| sample grammar decl reparsed |

	sample := RefObject new instVarNamed: 'name' put: OrderedCollection; yourself.
	grammar := MateOGGrammar from: sample.
	decl := (grammar typeDeclarations at: RefObject) instanceVariableDeclarations first.

	self assert: (decl isKindOf: MateInstOneOfVarDecl).
	self assert: decl options equals: { OrderedCollection }.

	reparsed := MateLanguageParser parse: grammar mateDefinition.
	self assert: reparsed first equals: (grammar typeDeclarations at: RefObject).
	self assert: ((grammar gen: RefObject) instVarNamed: 'name') equals: OrderedCollection
]

{ #category : 'tests - generation' }
MateRegressionTest >> testIntegerGeneratorProducesBoundaryAndSmallValues [

	| generator random values |

	random := Random seed: 42.
	generator := MateIntegerGenerator new type: SmallInteger.
	values := (1 to: 1000) collect: [ :i | generator generate: random ].

	self assert: (values includes: 0).
	self assert: (values includes: SmallInteger maxVal).
	self assert: (values includes: SmallInteger minVal).
	self assert: (values count: [ :each | each abs <= 128 ]) > 200.
	self assert: (values allSatisfy: [ :each | each isKindOf: SmallInteger ])
]

{ #category : 'tests - generation' }
MateRegressionTest >> testIntegerGeneratorRespectsConstraint [

	| generator random constraint |

	random := Random seed: 42.
	generator := MateIntegerGenerator new type: SmallInteger.
	constraint := MateConstraint between: -5 and: 5.

	500 timesRepeat: [ self assert: ((generator generateWithConstraint: constraint random: random) between: -5 and: 5) ]
]

{ #category : 'tests - generation' }
MateRegressionTest >> testNullableFieldsCanGenerateNil [

	| grammar |

	grammar := self grammarFrom: 'MateAge -> { value: SmallInteger? }'.
	grammar generator nilProbability: 1.

	self assert: (grammar gen: MateAge) value isNil
]

{ #category : 'tests - rewards' }
MateRegressionTest >> testOneOfNodesKnowTheirCurrentReward [

	| grammar root node |

	grammar := self grammarFrom: 'MateAge -> { value: { oneOf: { #a . #b } } }'.
	root := grammar gen: MateAge from: MateContext new.
	node := root edges at: 'value'.

	self assert: node currentReward equals: 1.
	grammar backpropagate: root improvement: 5.
	self assert: node currentReward equals: 6
]

{ #category : 'tests - language' }
MateRegressionTest >> testParserRejectsMalformedInputInsteadOfHanging [

	#( 'MateAge'
	   'MateAge -> { value: @ }'
	   'MateAge -> { value: SmallInteger'
	   'MateAge -> { value: { oneOf: { ''a } } }'
	   'MateAge -> { value: SmallInteger } "unterminated'
	   'MateAge -> { value: { type: SmallInteger, between: 1 } }'
	   'MateAge -> { value: SmallInteger } Unknown -> { }' ) do: [ :source |
		self should: [ self parseWithoutHanging: source ] raise: Error ]
]

{ #category : 'tests - language' }
MateRegressionTest >> testParserSupportsComments [

	| decls |

	decls := self parseWithoutHanging: '"ages" MateAge -> { "the value" value: SmallInteger } "done"'.

	self assert: decls first instanceVariableDeclarations first type equals: SmallInteger
]

{ #category : 'tests - language' }
MateRegressionTest >> testParserSupportsLiteralOptions [

	| decls |

	decls := self parseWithoutHanging: 'MateAge -> { value: { oneOf: { ''a'' . #b . #at:put: . 3 . -2 . 0.5 . true . nil } } }'.

	self
		assert: decls first instanceVariableDeclarations first options
		equals: { 'a' . #b . #at:put: . 3 . -2 . 0.5 . true . nil }
]

{ #category : 'tests - language' }
MateRegressionTest >> testParserSupportsMetaclassTypes [

	| decls |

	decls := self parseWithoutHanging: 'MateAge -> { value: OrderedCollection class | Set class }'.

	self assert: (decls first instanceVariableDeclarations first acceptType: OrderedCollection class).
	self assert: (decls first instanceVariableDeclarations first acceptType: Set class)
]

{ #category : 'tests - language' }
MateRegressionTest >> testParserSupportsNegativeAndFloatBounds [

	| decls constraint |

	decls := self parseWithoutHanging: 'MateAge -> { value: { type: SmallInteger, between: -5 and: 5 } }
		Player -> { level: { type: Float, between: 0.5 and: 1.5e2 } }'.

	constraint := decls first instanceVariableDeclarations first constraint.
	self assert: constraint min equals: -5.
	self assert: constraint max equals: 5.

	constraint := decls second instanceVariableDeclarations first constraint.
	self assert: constraint min equals: 0.5.
	self assert: constraint max equals: 150.0
]

{ #category : 'tests - language' }
MateRegressionTest >> testParserSupportsNullableFields [

	| decls |

	decls := self parseWithoutHanging: 'MateAge -> { value: (SmallInteger | ByteString)?, other_value: { type: SmallInteger, atLeast: 0, nullable: true } }'.

	self assert: decls first instanceVariableDeclarations first nullable.
	self assert: decls first instanceVariableDeclarations second nullable.
	self assert: decls first instanceVariableDeclarations second name equals: 'other_value'
]

{ #category : 'tests - generation' }
MateRegressionTest >> testRecursiveFieldsTerminate [

	| grammar instance depth |

	grammar := self grammarFrom: 'ReferredObject -> { value: SmallInteger, ref: ReferredObject }'.

	instance := [ grammar gen: ReferredObject ] valueWithin: 5 seconds onTimeout: [ self fail: 'Generation did not terminate' ].

	depth := 0.
	[ instance notNil ] whileTrue: [ depth := depth + 1. instance := instance instVarNamed: 'ref' ].
	self assert: depth <= (grammar generator maxDerivationHeight + 1)
]

{ #category : 'tests - generation' }
MateRegressionTest >> testGrammarsInferredFromCyclesTerminate [

	| first second grammar |

	first := ReferredObject new.
	second := ReferredObject new.
	first instVarNamed: 'value' put: 1; instVarNamed: 'ref' put: second.
	second instVarNamed: 'value' put: 2; instVarNamed: 'ref' put: first.

	grammar := MateOGGrammar from: first.

	self assert: ([ grammar gen: ReferredObject ] valueWithin: 5 seconds onTimeout: [ nil ]) class equals: ReferredObject.
	self assert: ([ grammar parse: first ] valueWithin: 5 seconds onTimeout: [ nil ]) notNil
]

{ #category : 'tests - generation' }
MateRegressionTest >> testSeedMakesGenerationReproducible [

	| generate |

	generate := [ | grammar |
		grammar := MatePlayerGrammar new.
		grammar seed: 1234.
		(1 to: 5) collect: [ :i | | player |
			player := grammar gen: Player.
			{ player name . player level . player missingExperienceForNextLevel . player characterClass class } ] ].

	self assert: generate value equals: generate value
]

{ #category : 'tests - types' }
MateRegressionTest >> testUnionsAreFlattenedAndAcceptSubclasses [

	| union |

	union := (SmallInteger | ByteString) | (Float | ByteString).

	self assert: union types size equals: 3.
	self deny: (union types anySatisfy: [ :each | each isKindOf: MateOptionalType ]).
	self assert: (union acceptType: SmallFloat64).
	self assert: (union optionFor: 0.5) equals: Float.
	self assert: union name equals: 'ByteString | Float | SmallInteger'
]

{ #category : 'tests - validation' }
MateRegressionTest >> testValidationAcceptsUnionArrayElements [

	| grammar sample |

	grammar := self grammarFrom: 'BlChildrenArray -> { array: { type: [ SmallInteger | ByteString ], sizeBetween: 0 and: 5 } }'.
	sample := BlChildrenArray new instVarNamed: 'array' put: { 1 . 'a' }; yourself.

	self assert: (grammar parse: sample) instance equals: sample.

	sample instVarNamed: 'array' put: { #symbol }.
	self should: [ grammar parse: sample ] raise: Error
]

{ #category : 'tests - validation' }
MateRegressionTest >> testValidationAcceptsSubclassesOfDeclaredType [

	| grammar |

	grammar := self grammarFrom: 'MateAge -> { value: Float }'.

	self assert: (grammar parse: (MateAge new value: 0.5)) instance value equals: 0.5
]

{ #category : 'tests - validation' }
MateRegressionTest >> testValidationChecksConstraints [

	| grammar player |

	grammar := MatePlayerGrammar new.
	player := grammar gen: Player.
	player instVarNamed: 'level' put: 5000.

	self should: [ grammar parse: player ] raise: Error
]

{ #category : 'tests - validation' }
MateRegressionTest >> testValidationDoesNotMutateTheInput [

	| grammar element child stranger |

	grammar := MateBlocGrammar new.
	grammar seed: 11.
	[ element := grammar gen: BlElement. element children isEmpty ] whileTrue.
	child := element children first.
	stranger := BlElement new.
	child instVarNamed: 'parent' put: stranger.

	self should: [ grammar parse: element ] raise: Error.
	self assert: (child instVarNamed: 'parent') identicalTo: stranger
]

{ #category : 'tests - language' }
MateRegressionTest >> testWriterDoesNotCountVisits [

	| grammar |

	grammar := MatePlayerGrammar new.
	grammar mateDefinition.

	self assert: grammar totalVisitsAcrossDeclarations equals: 0
]

{ #category : 'tests - language' }
MateRegressionTest >> testWriterOutputParsesBackToTheSameGrammar [

	{ MatePlayerGrammar new. MatePersonGrammar new. MateBlocGrammarByLang new. MateBlocGrammar new } do: [ :grammar |
		(MateLanguageParser parse: grammar mateDefinition) do: [ :decl |
			self assert: decl equals: (grammar typeDeclarations at: decl type) ] ]
]

{ #category : 'tests - language' }
MateRegressionTest >> testWriterRoundTripsLiteralOptions [

	| grammar reparsed |

	grammar := self grammarFrom: 'MateAge -> { value: { oneOf: { 1 . -2 . ''text'' . #sym . #at:put: } } }'.
	reparsed := MateLanguageParser parse: grammar mateDefinition.

	self
		assert: reparsed first instanceVariableDeclarations first options
		equals: { 1 . -2 . 'text' . #sym . #at:put: }
]
