Class {
	#name : 'MateViolationTest',
	#superclass : 'TestCase',
	#category : 'Mate-Violation Tests',
	#package : 'Mate',
	#tag : 'Violation Tests'
}

{ #category : 'helpers' }
MateViolationTest >> derivationWith: kind in: grammar of: aClass [

	50 timesRepeat: [ | derivation |
		derivation := grammar gen: aClass from: MateContext new validity: 0 violating: { kind }.
		derivation isValid ifFalse: [ ^ derivation ] ].

	^ self fail: 'No ', kind, ' violation could be injected'
]

{ #category : 'helpers' }
MateViolationTest >> grammarFrom: aString [

	^ MateOGGrammar new
		addTypeDeclarations: (MateLanguageParser parse: aString);
		seed: 17;
		yourself
]

{ #category : 'helpers' }
MateViolationTest >> numbersGrammar [

	^ self grammarFrom: 'BlChildrenArray -> { array: { type: [ SmallInteger ], sizeBetween: 1 and: 3 } }'
]

{ #category : 'helpers' }
MateViolationTest >> playerGrammar [

	^ MatePlayerGrammar new seed: 17; yourself
]

{ #category : 'helpers' }
MateViolationTest >> spanGrammar [

	^ self grammarFrom: 'MateSpan -> {
		start: { type: SmallInteger, between: 0 and: 50 },
		stop: { type: SmallInteger, between: 0 and: 100 },
		kind: { oneOf: { #open . #closed } },
		invariants: { start <= stop } }'
]

{ #category : 'helpers' }
MateViolationTest >> treeGrammar [

	| grammar |

	grammar := self grammarFrom: 'MateTreeNode -> {
		label: { oneOf: { #a . #b } },
		children: { type: [ MateTreeNode ], collection: OrderedCollection, sizeBetween: 0 and: 2 },
		parent: { refType: MateTreeNode },
		selfReferences: { children[ .parent ] } }'.
	grammar generator maxDerivationHeight: 4.
	^ grammar
]

{ #category : 'helpers' }
MateViolationTest >> assertKind: kind isInjectedIn: grammar of: aClass [

	| derivation |

	derivation := self derivationWith: kind in: grammar of: aClass.

	self assert: derivation violations size equals: 1.
	self assert: derivation violations first kind equals: kind.
	self should: [ grammar parse: derivation instance strict: true ] raise: Error
]

{ #category : 'tests - kinds' }
MateViolationTest >> testElementViolationsAreDetected [

	self assertKind: #element isInjectedIn: self numbersGrammar of: BlChildrenArray
]

{ #category : 'tests - kinds' }
MateViolationTest >> testInvariantViolationsAreDetected [

	self assertKind: #invariant isInjectedIn: self spanGrammar of: MateSpan
]

{ #category : 'tests - kinds' }
MateViolationTest >> testNilViolationsAreOnlyDetectedByStrictValidation [

	| grammar derivation |

	grammar := self playerGrammar.
	derivation := self derivationWith: #nil in: grammar of: Player.

	self assert: derivation violations first after isNil.
	self assert: (grammar parse: derivation instance) notNil.
	self should: [ grammar parse: derivation instance strict: true ] raise: Error
]

{ #category : 'tests - kinds' }
MateViolationTest >> testOneOfViolationsAreDetected [

	self assertKind: #oneOf isInjectedIn: self spanGrammar of: MateSpan
]

{ #category : 'tests - kinds' }
MateViolationTest >> testRangeViolationsAreJustOutsideTheBounds [

	| grammar derivation violation |

	grammar := self playerGrammar.
	derivation := self derivationWith: #range in: grammar of: Player.
	violation := derivation violations first.

	self assert: (#( 'level' 'missingExperienceForNextLevel' ) includes: violation field).
	self assert: (#( -1 100 0 ) includes: violation after).
	self should: [ grammar parse: derivation instance ] raise: Error
]

{ #category : 'tests - kinds' }
MateViolationTest >> testReferenceViolationsAreDetected [

	| grammar derivation |

	grammar := self treeGrammar.
	derivation := self derivationWith: #reference in: grammar of: MateTreeNode.

	self assert: derivation violations first field equals: 'parent'.
	self should: [ grammar parse: derivation instance ] raise: Error
]

{ #category : 'tests - kinds' }
MateViolationTest >> testSizeViolationsAreDetected [

	| grammar derivation size |

	grammar := self numbersGrammar.
	derivation := self derivationWith: #size in: grammar of: BlChildrenArray.
	size := derivation instance array size.

	self assert: (size = 0 or: [ size = 4 ]).
	self should: [ grammar parse: derivation instance ] raise: Error
]

{ #category : 'tests - kinds' }
MateViolationTest >> testTypeViolationsAreDetected [

	self assertKind: #type isInjectedIn: self playerGrammar of: Player
]

{ #category : 'tests - generation' }
MateViolationTest >> testFullValidityNeverInjects [

	| grammar |

	grammar := self playerGrammar.

	50 timesRepeat: [ | derivation |
		derivation := grammar gen: Player from: MateContext new validity: 1.
		self assert: derivation isValid.
		self assert: (grammar parse: derivation instance strict: true) notNil ]
]

{ #category : 'tests - generation' }
MateViolationTest >> testGenWithoutValidityIsAlwaysValid [

	| grammar |

	grammar := self spanGrammar.

	50 timesRepeat: [ self assert: (grammar parse: (grammar gen: MateSpan) strict: true) notNil ]
]

{ #category : 'tests - generation' }
MateViolationTest >> testKindsWithoutSitesLeaveTheObjectValid [

	| derivation |

	derivation := self playerGrammar gen: Player from: MateContext new validity: 0 violating: #( #invariant ).

	self assert: derivation isValid
]

{ #category : 'tests - generation' }
MateViolationTest >> testPartialValidityMixesValidAndInvalidObjects [

	| grammar invalid |

	grammar := self playerGrammar.
	invalid := (1 to: 200) count: [ :i |
		(grammar gen: Player from: MateContext new validity: 0.7) isValid not ].

	self assert: (invalid between: 30 and: 90)
]

{ #category : 'tests - generation' }
MateViolationTest >> testSeedReproducesTheSameViolations [

	| run |

	run := [ | grammar |
		grammar := self playerGrammar.
		(1 to: 20) collect: [ :i |
			(grammar gen: Player from: MateContext new validity: 0.5) violations printString ] ].

	self assert: run value equals: run value
]

{ #category : 'tests - generation' }
MateViolationTest >> testShortcutReturnsTheInstance [

	self assert: (self playerGrammar gen: Player validity: 0) class equals: Player
]

{ #category : 'tests - generation' }
MateViolationTest >> testUnknownKindsAreRejected [

	self should: [ self playerGrammar gen: Player validity: 0 violating: #( #nonsense ) ] raise: Error
]

{ #category : 'tests - generation' }
MateViolationTest >> testValidityMustBeAProbability [

	self should: [ self playerGrammar gen: Player validity: 1.5 ] raise: Error
]

{ #category : 'tests - generation' }
MateViolationTest >> testViolationsPerObjectTouchDistinctFields [

	| grammar derivation |

	grammar := self playerGrammar.
	grammar generator violationsPerObject: 3.
	derivation := grammar gen: Player from: MateContext new validity: 0.

	self assert: derivation violations size equals: 3.
	self assert: (derivation violations collect: #field) asSet size equals: 3
]

{ #category : 'tests - rewards' }
MateViolationTest >> testRewardsFlowToViolationKinds [

	| grammar player kind |

	grammar := self playerGrammar.
	player := grammar gen: Player validity: 0 violating: #( #range ).
	kind := (grammar generator invalidDerivationOf: player) violations first kind.

	grammar backPropagate: 10 from: player.

	self assert: (grammar generator injector rewards at: kind) equals: 10
]

{ #category : 'tests - validation' }
MateViolationTest >> testStrictValidationAcceptsNullableAndReferenceNils [

	| grammar |

	grammar := self grammarFrom: 'MateSpan -> { start: SmallInteger?, stop: SmallInteger, kind: { refType: MateSpan } }'.

	self assert: (grammar parse: (MateSpan from: nil to: 3 kind: nil) strict: true) notNil.
	self should: [ grammar parse: (MateSpan from: 1 to: nil kind: nil) strict: true ] raise: Error.
	self assert: (grammar parse: (MateSpan from: 1 to: nil kind: nil)) notNil
]
