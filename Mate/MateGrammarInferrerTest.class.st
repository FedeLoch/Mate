Class {
	#name : 'MateGrammarInferrerTest',
	#superclass : 'TestCase',
	#category : 'Mate-Inference Tests',
	#package : 'Mate',
	#tag : 'Inference Tests'
}

{ #category : 'helpers' }
MateGrammarInferrerTest >> blocElement [

	^ BlElement new
		id: #B;
		position: 100 @ 0;
		extent: 100 @ 100;
		background: Color green;
		addChild: (BlElement new
			id: #BA;
			extent: 50 @ 50;
			background: Color blue;
			yourself)
]

{ #category : 'helpers' }
MateGrammarInferrerTest >> field: aName of: aClass in: aGrammar [

	^ (aGrammar typeDeclarations at: aClass) instanceVariableDeclarationNamed: aName
]

{ #category : 'helpers' }
MateGrammarInferrerTest >> inferrerFor: instances [

	^ MateGrammarInferrer new observeAll: instances; yourself
]

{ #category : 'helpers' }
MateGrammarInferrerTest >> players [

	| classes |

	classes := { Warrior. Rogue. Mage }.
	^ (1 to: 30) collect: [ :i |
		Player new
			name: 'player ', i printString;
			characterClass: (classes at: i \\ 3 + 1) new;
			level: i * 3;
			missingExperienceForNextLevel: i * 10;
			yourself ]
]

{ #category : 'helpers' }
MateGrammarInferrerTest >> referencePathsOf: aClass in: aGrammar [

	^ (aGrammar typeDeclarations at: aClass) selfReferences collect: [ :each | MateWriter new writeReferencePath: each ]
]

{ #category : 'helpers' }
MateGrammarInferrerTest >> spans [

	^ (1 to: 30) collect: [ :i |
		MateSpan from: i to: i + (i \\ 4) kind: (#( #open #closed #moved nil ) at: i \\ 4 + 1) ]
]

{ #category : 'tests - relationships' }
MateGrammarInferrerTest >> testDetectsBlocChildParentBackReference [

	| inferrer grammar |

	inferrer := self inferrerFor: { self blocElement }.
	grammar := inferrer grammar.

	self assert: (inferrer findings anySatisfy: [ :each |
		each kind = #backReference and: [ each type = BlBoundsCache and: [ each accepted not ] ] ]).
	self assert: ((self referencePathsOf: BlElement in: grammar) includes: 'boundsCache.element').
	self assert: ((self referencePathsOf: BlElement in: grammar) includes: 'children.array[ .parent ]').
	self assert: ((self referencePathsOf: BlElement in: grammar) includes: 'eventDispatcher.owner').
	self assert: ((self field: 'parent' of: BlElement in: grammar) isKindOf: MateInstRefVarDecl).
	self deny: ((self field: 'eventDispatcher' of: BlElement in: grammar) isKindOf: MateInstRefVarDecl).
	self deny: ((self field: 'boundsCache' of: BlElement in: grammar) isKindOf: MateInstRefVarDecl)
]

{ #category : 'tests - relationships' }
MateGrammarInferrerTest >> testGeneratedOwnersBuildTheirBackPointingParts [

	| grammar |

	grammar := (self inferrerFor: self owners) grammar.
	grammar seed: 4.

	20 timesRepeat: [ | owner part |
		owner := grammar gen: RefObject.
		part := owner instVarNamed: 'myLittleObject'.
		self assert: part class equals: ReferredObject.
		self assert: (part instVarNamed: 'ref') identicalTo: owner.
		self assert: (grammar parse: owner) notNil ]
]

{ #category : 'tests - relationships' }
MateGrammarInferrerTest >> testKeepsOnlyTheDownwardDirectionOfTwoWayReferences [

	| grammar |

	grammar := (self inferrerFor: self owners) grammar.

	self assert: (self referencePathsOf: RefObject in: grammar) asArray equals: #( 'myLittleObject.ref' ).
	self assert: (self referencePathsOf: ReferredObject in: grammar) isEmpty.
	self assert: ((self field: 'ref' of: ReferredObject in: grammar) isKindOf: MateInstRefVarDecl).
	self deny: ((self field: 'myLittleObject' of: RefObject in: grammar) isKindOf: MateInstRefVarDecl)
]

{ #category : 'tests - depth' }
MateGrammarInferrerTest >> testDepthLimitLeavesOutFieldsOfUnobservedClasses [

	| inferrer grammar |

	inferrer := MateGrammarInferrer new
		maxDepth: 1;
		observeAll: self ownersWithTrees;
		yourself.
	grammar := inferrer grammar.

	self deny: (inferrer observer observedClasses includes: MateSpan).
	self assert: (self field: 'label' of: MateTreeNode in: grammar) isNil.
	self assert: (self field: 'name' of: RefObject in: grammar) type equals: MateTreeNode.
	self assert: (inferrer findings anySatisfy: [ :each |
		each kind = #depthLimit and: [ each type = MateTreeNode and: [ each field = 'label' ] ] ])
]

{ #category : 'tests - depth' }
MateGrammarInferrerTest >> testDepthLimitKeepsFieldsOfClassesObservedCloser [

	| grammar children |

	grammar := (MateGrammarInferrer new
		maxDepth: 3;
		observeAll: self trees;
		yourself) grammar.
	children := self field: 'children' of: MateTreeNode in: grammar.

	self assert: children notNil.
	self assert: children elementType equals: MateTreeNode.
	self assert: ((self referencePathsOf: MateTreeNode in: grammar) includes: 'children[ .parent ]')
]

{ #category : 'tests - depth' }
MateGrammarInferrerTest >> testDepthLimitedGrammarsGenerateValidObjects [

	| grammar |

	grammar := (MateGrammarInferrer new
		maxDepth: 1;
		observeAll: self ownersWithTrees;
		yourself) grammar.
	grammar seed: 2.

	10 timesRepeat: [ | owner |
		owner := grammar gen: RefObject.
		self assert: (owner instVarNamed: 'name') class equals: MateTreeNode.
		self assert: ((owner instVarNamed: 'name') instVarNamed: 'label') isNil.
		self assert: (grammar parse: owner) notNil ]
]

{ #category : 'tests - depth' }
MateGrammarInferrerTest >> testObservationUsesShortestDepths [

	| deep shortcut observer |

	deep := MateTreeNode new.
	shortcut := RefObject new instVarNamed: 'name' put: deep; yourself.
	observer := MateObserver new maxDepth: 1; yourself.
	observer observeAll: { (MateTreeNode new addChild: (MateTreeNode new addChild: deep; yourself); yourself). shortcut }.

	self assert: (observer depthOf: deep) equals: 1.
	self assert: (observer isObserved: deep)
]

{ #category : 'tests - relationships' }
MateGrammarInferrerTest >> testShortcutsDoNotHideTheDownwardDirection [

	| trees grammar |

	trees := self trees.
	trees do: [ :each | each label: each children first children first ].

	grammar := (self inferrerFor: trees) grammar.

	self assert: ((self referencePathsOf: MateTreeNode in: grammar) includes: 'children[ .parent ]').
	self assert: ((self field: 'parent' of: MateTreeNode in: grammar) isKindOf: MateInstRefVarDecl)
]

{ #category : 'tests - relationships' }
MateGrammarInferrerTest >> testSampledRelationshipsAreVerifiedOnAllInstances [

	| trees grammar |

	trees := self trees.
	trees last children last parent: trees first.

	grammar := (MateGrammarInferrer new
		maxRelationshipSamples: 2;
		observeAll: trees;
		yourself) grammar.

	self assert: (self referencePathsOf: MateTreeNode in: grammar) isEmpty
]

{ #category : 'tests - relationships' }
MateGrammarInferrerTest >> testDetectsTreeBackReferenceThroughOrderedCollections [

	| grammar children |

	grammar := (self inferrerFor: self trees) grammar.

	self assert: (self referencePathsOf: MateTreeNode in: grammar) asArray equals: #( 'children[ .parent ]' ).
	self assert: ((self field: 'parent' of: MateTreeNode in: grammar) isKindOf: MateInstRefVarDecl).

	children := self field: 'children' of: MateTreeNode in: grammar.
	self assert: children collectionClass equals: OrderedCollection.
	self assert: children elementType equals: MateTreeNode.
	self assert: children minSize equals: 0.
	self assert: children maxSize equals: 2
]

{ #category : 'tests - unary' }
MateGrammarInferrerTest >> testDoesNotInferEnumerationsForManyDistinctValues [

	| inferrer grammar |

	inferrer := self inferrerFor: self players.
	grammar := inferrer grammar.

	self assert: (self field: 'name' of: Player in: grammar) type equals: ByteString.
	self assert: (inferrer findings anySatisfy: [ :each |
		each kind = #enumeration and: [ each field = 'name' and: [ each accepted not ] ] ])
]

{ #category : 'tests - generation' }
MateGrammarInferrerTest >> testGeneratedPlayersAreValidForTheInferredGrammar [

	| grammar |

	grammar := (self inferrerFor: self players) grammar.
	grammar seed: 3.

	50 timesRepeat: [ self assert: (grammar parse: (grammar gen: Player)) notNil ]
]

{ #category : 'tests - generation' }
MateGrammarInferrerTest >> testGeneratedSpansSatisfyTheInferredInvariant [

	| grammar |

	grammar := (self inferrerFor: self spans) grammar.
	grammar seed: 5.

	50 timesRepeat: [ | span |
		span := grammar gen: MateSpan.
		self assert: span start <= span stop.
		self assert: (span start between: 1 and: 30).
		self assert: (grammar parse: span) notNil ]
]

{ #category : 'tests - generation' }
MateGrammarInferrerTest >> testGeneratedTreesKeepTheirBackReferences [

	| grammar |

	grammar := (self inferrerFor: self trees) grammar.
	grammar seed: 9.
	grammar generator maxDerivationHeight: 5.

	20 timesRepeat: [ | tree |
		tree := grammar gen: MateTreeNode.
		self assert: tree children class equals: OrderedCollection.
		tree children do: [ :child | self assert: child parent identicalTo: tree ].
		self assert: (grammar parse: tree) notNil ]
]

{ #category : 'tests - language' }
MateGrammarInferrerTest >> testInferredGrammarsRoundTripThroughTheLanguage [

	{ self spans. self trees. self players } do: [ :instances | | grammar |
		grammar := (self inferrerFor: instances) grammar.
		(MateLanguageParser parse: grammar mateDefinition) do: [ :decl | | original |
			original := grammar typeDeclarations at: decl type.
			self assert: decl equals: original.
			self assert: decl invariants asArray equals: original invariants asArray.
			self assert: decl selfReferences asArray equals: original selfReferences asArray ] ]
]

{ #category : 'tests - unary' }
MateGrammarInferrerTest >> testInfersEnumerationsIncludingNil [

	| decl |

	decl := self field: 'kind' of: MateSpan in: (self inferrerFor: self spans) grammar.

	self assert: (decl isKindOf: MateInstOneOfVarDecl).
	self assert: decl options asSet equals: #( #open #closed #moved nil ) asSet
]

{ #category : 'tests - unary' }
MateGrammarInferrerTest >> testInfersNullableFields [

	| grammar decl |

	grammar := (self inferrerFor: (self players collect: [ :each |
		each level odd ifTrue: [ each name: nil ].
		each ])) grammar.
	decl := self field: 'name' of: Player in: grammar.

	self assert: decl nullable
]

{ #category : 'tests - unary' }
MateGrammarInferrerTest >> testInfersOnlyTheSignWithFewObservations [

	| inferrer grammar decl |

	inferrer := self inferrerFor: (self spans first: 3).
	grammar := inferrer grammar.
	decl := self field: 'start' of: MateSpan in: grammar.

	self assert: decl constraint equals: (MateConstraint greaterThan: 0).
	self assert: (inferrer findings anySatisfy: [ :each |
		each kind = #range and: [ each field = 'start' and: [ each accepted not ] ] ])
]

{ #category : 'tests - invariants' }
MateGrammarInferrerTest >> testInfersOrderingInvariants [

	| grammar |

	grammar := (self inferrerFor: self spans) grammar.

	self
		assert: (grammar typeDeclarations at: MateSpan) invariants asArray
		equals: { MateInvariant left: 'start' operator: '<=' right: 'stop' }
]

{ #category : 'tests - unary' }
MateGrammarInferrerTest >> testInfersRangesWithEnoughSupport [

	| grammar |

	grammar := (self inferrerFor: self players) grammar.

	self assert: (self field: 'level' of: Player in: grammar) constraint equals: (MateConstraint between: 3 and: 90).
	self assert: (self field: 'missingExperienceForNextLevel' of: Player in: grammar) constraint equals: (MateConstraint between: 10 and: 300)
]

{ #category : 'tests - unary' }
MateGrammarInferrerTest >> testInfersUnionsOfObservedClasses [

	| decl |

	decl := self field: 'characterClass' of: Player in: (self inferrerFor: self players) grammar.

	self assert: (decl acceptType: Warrior).
	self assert: (decl acceptType: Rogue).
	self assert: (decl acceptType: Mage).
	self deny: (decl acceptType: Player)
]

{ #category : 'tests - reporting' }
MateGrammarInferrerTest >> testReportListsAcceptedAndRejectedFindings [

	| report |

	report := (self inferrerFor: self players) report.

	self assert: (report includesSubstring: '[accepted] Player.level range').
	self assert: (report includesSubstring: '[rejected] Player.name enumeration')
]

{ #category : 'tests - relationships' }
MateGrammarInferrerTest >> testReportsSharedObjects [

	| shared inferrer |

	shared := ReferredObject new.
	inferrer := self inferrerFor: ((1 to: 3) collect: [ :i |
		RefObject new
			instVarNamed: 'name' put: 'ref ', i printString;
			instVarNamed: 'myLittleObject' put: shared;
			yourself ]).

	self assert: (inferrer findings anySatisfy: [ :each |
		each kind = #sharing and: [ each type = ReferredObject ] ])
]

{ #category : 'tests - unary' }
MateGrammarInferrerTest >> testSkipsUnsupportedFields [

	| inferrer grammar |

	inferrer := self inferrerFor: { RefObject new
		instVarNamed: 'name' put: 'ref';
		instVarNamed: 'myLittleObject' put: [ 1 ];
		yourself }.
	grammar := inferrer grammar.

	self assert: (self field: 'myLittleObject' of: RefObject in: grammar) isNil.
	self assert: (inferrer findings anySatisfy: [ :each |
		each kind = #unsupported and: [ each field = 'myLittleObject' ] ])
]

{ #category : 'tests - invariants' }
MateGrammarInferrerTest >> testValidationRejectsInvariantViolations [

	| grammar |

	grammar := (self inferrerFor: self spans) grammar.

	self should: [ grammar parse: (MateSpan from: 20 to: 10 kind: #open) ] raise: Error
]

{ #category : 'helpers' }
MateGrammarInferrerTest >> owners [

	^ (1 to: 12) collect: [ :i | | owner |
		owner := RefObject new.
		owner instVarNamed: 'name' put: 'owner ', i printString.
		owner instVarNamed: 'myLittleObject' put: (ReferredObject new
			instVarNamed: 'value' put: i;
			instVarNamed: 'ref' put: owner;
			yourself).
		owner ]
]

{ #category : 'helpers' }
MateGrammarInferrerTest >> ownersWithTrees [

	^ (1 to: 12) collect: [ :i | | node |
		node := MateTreeNode new.
		node label: (MateSpan from: i to: i + 1 kind: #open).
		RefObject new
			instVarNamed: 'name' put: node;
			instVarNamed: 'myLittleObject' put: (ReferredObject new instVarNamed: 'value' put: i; yourself);
			yourself ]
]

{ #category : 'helpers' }
MateGrammarInferrerTest >> trees [

	^ (1 to: 12) collect: [ :i | | root |
		root := MateTreeNode new label: (#( #a #b #c ) atWrap: i); yourself.
		1 to: 2 do: [ :j | | child |
			child := root addChild: (MateTreeNode new label: (#( #a #b #c ) atWrap: i + j); yourself).
			child addChild: (MateTreeNode new label: (#( #a #b #c ) atWrap: i + j + 1); yourself) ].
		root ]
]
