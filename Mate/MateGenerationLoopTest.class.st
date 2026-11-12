Class {
	#name : 'MateGenerationLoopTest',
	#superclass : 'TestCase',
	#category : 'Mate-Generation Tests',
	#package : 'Mate',
	#tag : 'Generation Tests'
}

{ #category : 'helpers' }
MateGenerationLoopTest >> explodingGrammar [

	^ self grammarFrom: 'MateTreeNode -> {
		label: SmallInteger,
		children: { type: [ MateTreeNode ], collection: OrderedCollection, sizeBetween: 5 and: 8 } }'
]

{ #category : 'helpers' }
MateGenerationLoopTest >> grammarFrom: aString [

	^ MateOGGrammar new
		addTypeDeclarations: (MateLanguageParser parse: aString);
		seed: 41;
		yourself
]

{ #category : 'helpers' }
MateGenerationLoopTest >> loopErrorFrom: aBlock [

	^ aBlock
		on: MateGenerationLoop
		do: [ :error | error return: error ]
]

{ #category : 'helpers' }
MateGenerationLoopTest >> runawayGrammar [

	| grammar |

	grammar := self grammarFrom: 'ReferredObject -> { value: SmallInteger, ref: ReferredObject }'.
	grammar generator maxDerivationHeight: 100000.
	^ grammar
]

{ #category : 'tests' }
MateGenerationLoopTest >> testBudgetIsCountedPerGeneration [

	| grammar |

	grammar := MatePersonGrammar new.
	grammar generator maxObjects: 5.

	50 timesRepeat: [ self assert: (grammar gen: MatePerson) class equals: MatePerson ]
]

{ #category : 'tests' }
MateGenerationLoopTest >> testCollectionElementsShareTheBudgetOfTheirRoot [

	| grammar error |

	grammar := self explodingGrammar.
	grammar generator maxObjects: 2000.

	error := self loopErrorFrom: [ grammar gen: MateTreeNode ].

	self assert: (error isKindOf: MateGenerationLoop).
	self assert: error objectCount equals: 2001.
	self assert: error rootType equals: MateTreeNode.
	self assert: (error messageText includesSubstring: 'more than 2000 objects were generated')
]

{ #category : 'tests' }
MateGenerationLoopTest >> testDefaultBoundsLetNormalGrammarsGenerate [

	| grammar |

	grammar := MateBlocGrammar new.
	grammar seed: 3.

	10 timesRepeat: [ self assert: (grammar gen: BlElement) class equals: BlElement ].
	self assert: grammar generator maxObjects equals: 1000000.
	self assert: grammar generator maxNesting > grammar generator maxDerivationHeight
]

{ #category : 'tests' }
MateGenerationLoopTest >> testDerivationGenerationIsGuarded [

	| grammar |

	grammar := self runawayGrammar.
	grammar generator maxObjects: 100.

	self should: [ grammar gen: ReferredObject from: MateContext new ] raise: MateGenerationLoop
]

{ #category : 'tests' }
MateGenerationLoopTest >> testDepthCutKeepsRecursiveGrammarsWithinTheBounds [

	| grammar |

	grammar := self grammarFrom: 'ReferredObject -> { value: SmallInteger, ref: ReferredObject }'.
	grammar generator maxObjects: grammar generator maxDerivationHeight + 2.

	self assert: (grammar gen: ReferredObject) class equals: ReferredObject
]

{ #category : 'tests' }
MateGenerationLoopTest >> testGeneratorRecoversAfterALoop [

	| grammar |

	grammar := self runawayGrammar.
	grammar generator maxObjects: 50.

	self should: [ grammar gen: ReferredObject ] raise: MateGenerationLoop.

	grammar generator maxDerivationHeight: 12.
	self assert: (grammar gen: ReferredObject) class equals: ReferredObject
]

{ #category : 'tests' }
MateGenerationLoopTest >> testLoopsAreErrors [

	| grammar |

	grammar := self runawayGrammar.
	grammar generator maxObjects: 50.

	self should: [ grammar gen: ReferredObject ] raise: Error
]

{ #category : 'tests' }
MateGenerationLoopTest >> testNestingBeyondTheBoundIsReported [

	| grammar error |

	grammar := self runawayGrammar.
	grammar generator maxNesting: 20.

	error := self loopErrorFrom: [ grammar gen: ReferredObject ].

	self assert: (error isKindOf: MateGenerationLoop).
	self assert: error path size equals: 21.
	self assert: (error messageText includesSubstring: 'nested more than 20 levels deep').
	self assert: (error messageText includesSubstring: '... > ReferredObject > ReferredObject')
]

{ #category : 'tests' }
MateGenerationLoopTest >> testRunawayRecursionIsReported [

	| grammar error |

	grammar := self runawayGrammar.
	grammar generator maxObjects: 200.

	error := self loopErrorFrom: [ grammar gen: ReferredObject ].

	self assert: (error isKindOf: MateGenerationLoop).
	self assert: error rootType equals: ReferredObject.
	self assert: error objectCount equals: 201.
	self assert: (error messageText beginsWith: 'Generation of ReferredObject does not terminate: more than 200 objects were generated')
]
