Class {
	#name : 'MateGenerationLoopTest',
	#superclass : 'TestCase',
	#category : 'Mate-Generation Tests',
	#package : 'Mate',
	#tag : 'Generation Tests'
}

{ #category : 'helpers' }
MateGenerationLoopTest >> allTreeNodesOf: aNode [

	^ { aNode } , (aNode children asArray flatCollect: [ :each | self allTreeNodesOf: each ])
]

{ #category : 'helpers' }
MateGenerationLoopTest >> bushyGrammarBetween: min and: max height: height objects: objects [

	| grammar |

	grammar := self grammarFrom: 'MateTreeNode -> {
		label: SmallInteger,
		children: { type: [ MateTreeNode ], collection: OrderedCollection, sizeBetween: ', min printString, ' and: ', max printString, ' } }'.
	grammar generator
		maxDerivationHeight: height;
		maxObjects: objects.
	^ grammar
]

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
MateGenerationLoopTest >> testDepthCutKeepsRecursiveGrammarsWithinTheBounds [

	| grammar |

	grammar := self grammarFrom: 'ReferredObject -> { value: SmallInteger, ref: ReferredObject }'.
	grammar generator maxObjects: grammar generator maxDerivationHeight + 2.

	self assert: (grammar gen: ReferredObject) class equals: ReferredObject
]

{ #category : 'tests' }
MateGenerationLoopTest >> testDerivationGenerationIsGuarded [

	| grammar |

	grammar := self runawayGrammar.
	grammar generator maxObjects: 100.

	self should: [ grammar gen: ReferredObject from: MateContext new ] raise: MateGenerationLoop
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
MateGenerationLoopTest >> testNilOptionEndsChainsOfSingleFields [

	| grammar |

	grammar := self grammarFrom: 'MateTreeNode -> {
		label: SmallInteger,
		parent: MateTreeNode | nil,
		children: { type: [ MateTreeNode ], collection: OrderedCollection, sizeBetween: 0 and: 3 } }'.

	20 timesRepeat: [ self assert: (grammar gen: MateTreeNode) class equals: MateTreeNode ]
]

{ #category : 'tests' }
MateGenerationLoopTest >> testOverflowingCollectionsAreTruncated [

	| grammar tree |

	grammar := self bushyGrammarBetween: 0 and: 8 height: 100 objects: 5000.

	tree := grammar gen: MateTreeNode.

	self assert: tree class equals: MateTreeNode.
	self assert: grammar generator truncations > 0.
	self assert: (self allTreeNodesOf: tree) size < 5000
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

{ #category : 'tests' }
MateGenerationLoopTest >> testSingleFieldLoopsAreNotTruncated [

	| grammar |

	grammar := self runawayGrammar.
	grammar generator maxObjects: 200.

	self should: [ grammar gen: ReferredObject ] raise: MateGenerationLoop.
	self assert: grammar generator truncations equals: 0
]

{ #category : 'tests' }
MateGenerationLoopTest >> testSoftLimitDefaultsBelowTheHardLimit [

	| generator |

	generator := MateBlocGrammar new generator.

	self assert: generator softMaxObjects equals: generator maxObjects // 10
]

{ #category : 'tests' }
MateGenerationLoopTest >> testTruncatedCollectionsKeepTheirMinimumSize [

	| grammar tree |

	grammar := self bushyGrammarBetween: 2 and: 6 height: 16 objects: 20000.

	tree := grammar gen: MateTreeNode.

	self assert: grammar generator truncations > 0.
	self assert: ((self allTreeNodesOf: tree) allSatisfy: [ :each |
		each children isEmpty or: [ each children size between: 2 and: 6 ] ])
]

{ #category : 'tests' }
MateGenerationLoopTest >> testTruncationIsDeterministic [

	| sizes |

	sizes := (1 to: 2) collect: [ :i |
		(self allTreeNodesOf: ((self bushyGrammarBetween: 0 and: 8 height: 100 objects: 5000) gen: MateTreeNode)) size ].

	self assert: sizes first equals: sizes last
]
