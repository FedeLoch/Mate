Class {
	#name : 'MateInstanceGeneratorTest',
	#superclass : 'TestCase',
	#category : 'Mate-Generation Tests',
	#package : 'Mate',
	#tag : 'Generation Tests'
}

{ #category : 'helpers' }
MateInstanceGeneratorTest >> chainFrom: anObject [

	| chain current |

	chain := OrderedCollection new.
	current := anObject.
	[ current notNil and: [ (chain identityIncludes: current) not ] ] whileTrue: [
		chain add: current.
		current := current instVarNamed: 'ref' ].
	^ chain
]

{ #category : 'helpers' }
MateInstanceGeneratorTest >> grammarFrom: aString [

	^ MateOGGrammar new
		addTypeDeclarations: (MateLanguageParser parse: aString);
		seed: 13;
		yourself
]

{ #category : 'helpers' }
MateInstanceGeneratorTest >> recursiveGrammar [

	^ self grammarFrom: 'ReferredObject -> { value: SmallInteger, ref: ReferredObject }'
]

{ #category : 'helpers' }
MateInstanceGeneratorTest >> treeGrammar [

	| grammar |

	grammar := self grammarFrom: 'MateTreeNode -> {
		label: SmallInteger,
		children: { type: [ MateTreeNode ], collection: OrderedCollection, sizeBetween: 0 and: 3 } }'.
	grammar generator maxDerivationHeight: 6.
	^ grammar
]

{ #category : 'tests' }
MateInstanceGeneratorTest >> testClosingForcesReuseOfExistingInstances [

	| grammar chain |

	grammar := self recursiveGrammar.
	grammar generator
		selectRandomExistingInstanceWithProb: 0;
		maxDerivationHeight: 1000;
		maxNesting: 2000;
		softMaxObjects: 20.

	chain := self chainFrom: (grammar gen: ReferredObject).

	self assert: (chain size between: 20 and: 22).
	self assert: (chain last instVarNamed: 'ref') notNil
]

{ #category : 'tests' }
MateInstanceGeneratorTest >> testDepthLimitForcesReuseOfExistingInstances [

	| grammar chain |

	grammar := self recursiveGrammar.
	grammar generator
		selectRandomExistingInstanceWithProb: 0;
		maxDerivationHeight: 5.

	chain := self chainFrom: (grammar gen: ReferredObject).

	self assert: chain size equals: 5.
	self assert: (chain includes: (chain last instVarNamed: 'ref'))
]

{ #category : 'tests' }
MateInstanceGeneratorTest >> testDefaultStrategyNeverReusesInstances [

	| grammar nodes |

	grammar := self treeGrammar.
	nodes := IdentitySet new.

	20 timesRepeat: [ | pending |
		pending := OrderedCollection with: (grammar gen: MateTreeNode).
		[ pending isEmpty ] whileFalse: [ | node |
			node := pending removeFirst.
			self deny: (nodes includes: node).
			nodes add: node.
			pending addAll: node children ] ]
]

{ #category : 'tests' }
MateInstanceGeneratorTest >> testExistingInstancesAreReusedBeforeTheirSubtreeIsGenerated [

	| grammar chain |

	grammar := self recursiveGrammar.
	grammar generator selectRandomExistingInstanceWithProb: 0.5.

	20 timesRepeat: [
		chain := self chainFrom: (grammar gen: ReferredObject).
		self assert: (chain includes: (chain last instVarNamed: 'ref')).
		self assert: chain size < 40 ]
]

{ #category : 'tests' }
MateInstanceGeneratorTest >> testPoolIsResetForEachGeneration [

	| grammar first second |

	grammar := self recursiveGrammar.
	grammar generator selectRandomExistingInstanceWithProb: 0.9.

	first := self chainFrom: (grammar gen: ReferredObject).
	second := self chainFrom: (grammar gen: ReferredObject).

	self deny: (second anySatisfy: [ :each | first identityIncludes: each ])
]

{ #category : 'tests' }
MateInstanceGeneratorTest >> testRecursiveFieldsNeverEndWithoutTheStrategy [

	| grammar |

	grammar := self recursiveGrammar.
	grammar generator maxNesting: 50.

	self should: [ grammar gen: ReferredObject ] raise: MateGenerationLoop
]

{ #category : 'tests' }
MateInstanceGeneratorTest >> testReuseIsReproducibleWithASeed [

	| run |

	run := [ | grammar |
		grammar := self recursiveGrammar.
		grammar seed: 77.
		grammar generator selectRandomExistingInstanceWithProb: 0.5.
		(1 to: 10) collect: [ :i | (self chainFrom: (grammar gen: ReferredObject)) collect: [ :each | each instVarNamed: 'value' ] ] ].

	self assert: run value equals: run value
]

{ #category : 'tests' }
MateInstanceGeneratorTest >> testReusedTreesShareNodes [

	| grammar shared |

	grammar := self treeGrammar.
	grammar generator selectRandomExistingInstanceWithProb: 0.5.

	shared := (1 to: 20) count: [ :i | | seen pending sharing |
		seen := IdentitySet new.
		sharing := false.
		pending := OrderedCollection with: (grammar gen: MateTreeNode).
		[ pending isEmpty ] whileFalse: [ | node |
			node := pending removeFirst.
			(seen includes: node)
				ifTrue: [ sharing := true ]
				ifFalse: [
					seen add: node.
					pending addAll: node children ] ].
		sharing ].

	self assert: shared > 0
]

{ #category : 'tests' }
MateInstanceGeneratorTest >> testRandomReferenceSelectionGrammarTerminates [

	| grammar |

	grammar := MateBlocWithRandomReferenceSelectionGrammar new.
	grammar seed: 5.
	grammar generator softMaxObjects: 2000.

	5 timesRepeat: [
		self assert: ([ grammar gen: BlElement ] valueWithin: 60 seconds onTimeout: [ nil ]) class equals: BlElement ]
]
