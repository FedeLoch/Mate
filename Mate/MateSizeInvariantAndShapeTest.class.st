"
Tests for size invariants (a collection sized by a path, such as `selector numArgs = arguments size`),
for string shapes (`matching:` a regular expression, `except:` some values),
and for the minimum sizes kept at the depth limit.
"
Class {
	#name : 'MateSizeInvariantAndShapeTest',
	#superclass : 'TestCase',
	#category : 'Mate-Generation Tests',
	#package : 'Mate',
	#tag : 'Generation Tests'
}

{ #category : 'helpers' }
MateSizeInvariantAndShapeTest >> allTreeNodesOf: aNode [

	^ { aNode } , (aNode children asArray select: [ :each | each isKindOf: MateTreeNode ] thenCollect: [ :each | self allTreeNodesOf: each ]) flattened
]

{ #category : 'helpers' }
MateSizeInvariantAndShapeTest >> grammarFrom: aString [

	^ MateOGGrammar new
		addTypeDeclarations: (MateLanguageParser parse: aString);
		seed: 17;
		yourself
]

{ #category : 'helpers' }
MateSizeInvariantAndShapeTest >> recursiveSendGrammar [

	^ self grammarFrom: 'MateSend -> {
		selector: { type: ByteSymbol, matching: ''[a-z]+|[a-z]+\:|[a-z]+\:[a-z]+\:|[-+*]'' },
		arguments: { type: [ MateSend | SmallInteger ], collection: OrderedCollection, sizeBetween: 0 and: 2 },
		invariants: { selector numArgs = arguments size } }'
]

{ #category : 'helpers' }
MateSizeInvariantAndShapeTest >> sendGrammar [

	^ self grammarFrom: 'MateSend -> {
		selector: { type: ByteSymbol, matching: ''[a-z]+|[a-z]+\:|[a-z]+\:[a-z]+\:|[-+*]'' },
		arguments: { type: [ SmallInteger ], collection: OrderedCollection, sizeBetween: 0 and: 2 },
		invariants: { selector numArgs = arguments size } }'
]

{ #category : 'helpers' }
MateSizeInvariantAndShapeTest >> sendsOf: aSend [

	^ { aSend } , ((aSend arguments select: [ :each | each isKindOf: MateSend ]) flatCollect: [ :each | self sendsOf: each ])
]

{ #category : 'tests - generation' }
MateSizeInvariantAndShapeTest >> testDepthLimitKeepsTheMinimumSizeOfFinishableElements [

	| grammar |

	grammar := self grammarFrom: 'MateTreeNode -> {
		label: SmallInteger,
		children: { type: [ MateTreeNode | SmallInteger ], collection: OrderedCollection, sizeBetween: 2 and: 3 } }'.
	grammar generator maxDerivationHeight: 4.

	10 timesRepeat: [
		(self allTreeNodesOf: (grammar gen: MateTreeNode)) do: [ :each |
			self assert: (each children size between: 2 and: 3) ] ]
]

{ #category : 'tests - generation' }
MateSizeInvariantAndShapeTest >> testDepthLimitStillEndsTypesThatCannotBeFinished [

	| grammar tree |

	grammar := self grammarFrom: 'MateTreeNode -> {
		label: SmallInteger,
		children: { type: [ MateTreeNode ], collection: OrderedCollection, sizeBetween: 2 and: 3 } }'.
	grammar generator maxDerivationHeight: 4.

	tree := grammar gen: MateTreeNode.

	self assert: ((self allTreeNodesOf: tree) anySatisfy: [ :each | each children isEmpty ])
]

{ #category : 'tests - generation' }
MateSizeInvariantAndShapeTest >> testDerivedSizesHoldAtTheDepthLimit [

	| grammar |

	grammar := self recursiveSendGrammar.
	grammar generator maxDerivationHeight: 3.

	20 timesRepeat: [
		(self sendsOf: (grammar gen: MateSend)) do: [ :each |
			self assert: each arguments size equals: each selector numArgs ] ]
]

{ #category : 'tests - shapes' }
MateSizeInvariantAndShapeTest >> testExceptRemovesValuesThatMatch [

	| grammar |

	grammar := self grammarFrom: 'MateSpan -> {
		start: SmallInteger,
		stop: SmallInteger,
		kind: { type: ByteSymbol, matching: ''[ab]'', except: { #a } } }'.

	30 timesRepeat: [ self assert: (grammar gen: MateSpan) kind equals: #b ].
	self should: [ grammar parse: (MateSpan from: 1 to: 2 kind: #a) ] raise: Error
]

{ #category : 'tests - generation' }
MateSizeInvariantAndShapeTest >> testGeneratedArgumentsMatchTheSelectorArity [

	| grammar arities |

	grammar := self sendGrammar.
	arities := Set new.

	50 timesRepeat: [ | send |
		send := grammar gen: MateSend.
		self assert: send arguments size equals: send selector numArgs.
		arities add: send selector numArgs ].

	self assert: arities size > 1
]

{ #category : 'tests - shapes' }
MateSizeInvariantAndShapeTest >> testGeneratedSymbolsMatchTheirExpression [

	| grammar |

	grammar := self sendGrammar.

	50 timesRepeat: [
		self assert: ((grammar gen: MateSend) selector matchesRegex: '[a-z]+|[a-z]+\:|[a-z]+\:[a-z]+\:|[-+*]') ]
]

{ #category : 'tests - inference' }
MateSizeInvariantAndShapeTest >> testInferenceOrdersTheSourceBeforeTheCollection [

	| sends grammar decl |

	sends := (1 to: 30) collect: [ :i | | selector |
		selector := #( #yourself #at: #at:put: ) at: i \\ 3 + 1.
		MateSpanSend
			span: (MateSpan from: i to: i + 1 kind: selector)
			arguments: ((1 to: selector numArgs) asOrderedCollection) ].

	grammar := (MateGrammarInferrer new observeAll: sends; yourself) grammar.
	decl := grammar typeDeclarations at: MateSpanSend.

	self assert: (decl invariants includes: (MateSizeInvariant path: #( 'span' 'kind' 'numArgs' ) field: 'arguments')).
	self assert: (decl instanceVariableDeclarations collect: [ :each | each name ]) asArray equals: #( 'span' 'arguments' ).
	10 timesRepeat: [ | send |
		send := grammar gen: MateSpanSend.
		self assert: send arguments size equals: send span kind numArgs ]
]

{ #category : 'tests - inference' }
MateSizeInvariantAndShapeTest >> testInfersSizeInvariantsAndSymbolShapes [

	| sends grammar decl selector |

	sends := (1 to: 30) collect: [ :i | | symbol |
		symbol := #( #size #at: #at:put: #+ #inject:into: #value ) at: i \\ 6 + 1.
		MateSend selector: symbol arguments: (1 to: symbol numArgs) asOrderedCollection ].

	grammar := (MateGrammarInferrer new observeAll: sends; maxEnumerationSize: 2; yourself) grammar.
	decl := grammar typeDeclarations at: MateSend.
	selector := decl instanceVariableDeclarationNamed: 'selector'.

	self assert: (decl invariants includes: (MateSizeInvariant path: #( 'selector' 'numArgs' ) field: 'arguments')).
	self assert: selector constraint pattern equals: (MateGrammarInferrer symbolShapes detect: [ :each | each key = 'selector' ]) value.
	10 timesRepeat: [ | send |
		send := grammar gen: MateSend.
		self assert: send arguments size equals: send selector numArgs ]
]

{ #category : 'tests - parsing' }
MateSizeInvariantAndShapeTest >> testParsesSizeInvariantsOnEitherSide [

	| decls invariant |

	decls := MateLanguageParser parse: 'MateSend -> {
		selector: ByteSymbol,
		arguments: { type: [ SmallInteger ], sizeBetween: 0 and: 3 },
		invariants: { selector numArgs = arguments size, arguments size = selector numArgs } }'.
	invariant := decls first invariants first.

	self assert: invariant isSizeInvariant.
	self assert: invariant path equals: #( 'selector' 'numArgs' ).
	self assert: invariant field equals: 'arguments'.
	self assert: invariant printString equals: 'selector numArgs = arguments size'.
	self assert: decls first invariants second equals: invariant
]

{ #category : 'tests - parsing' }
MateSizeInvariantAndShapeTest >> testParsingRejectsCollectionsDeclaredBeforeTheirSource [

	self should: [ MateLanguageParser parse: 'MateSend -> {
		arguments: { type: [ SmallInteger ], sizeBetween: 0 and: 3 },
		selector: ByteSymbol,
		invariants: { selector numArgs = arguments size } }' ] raise: Error
]

{ #category : 'tests - parsing' }
MateSizeInvariantAndShapeTest >> testParsingRejectsInvalidExpressions [

	self should: [ MateLanguageParser parse: 'MateSend -> {
		selector: { type: ByteSymbol, matching: ''[a-z'' },
		arguments: SmallInteger }' ] raise: Error
]

{ #category : 'tests - parsing' }
MateSizeInvariantAndShapeTest >> testParsingRejectsSizeInvariantsOnSingleValues [

	self should: [ MateLanguageParser parse: 'MateSend -> {
		selector: ByteSymbol,
		arguments: SmallInteger,
		invariants: { selector numArgs = arguments size } }' ] raise: Error
]

{ #category : 'tests - shapes' }
MateSizeInvariantAndShapeTest >> testRegexGeneratorMatchesItsExpression [

	| random |

	random := Random seed: 3.
	#( '[a-z]+' 'a|bc|def' '\d\d' '[^a-z]x?' '(ab)*c' '[[:alpha:]_][\w]*\:' '.+' '[-+*/\\<>=~@%|&?,]+' ) do: [ :pattern |
		20 timesRepeat: [ | string |
			string := MateRegexGenerator generate: pattern random: random.
			self assert: (string matchesRegex: pattern) description: string printString, ' does not match ', pattern ] ]
]

{ #category : 'tests - validation' }
MateSizeInvariantAndShapeTest >> testSizeInvariantsThroughNestedFields [

	| grammar |

	grammar := self grammarFrom: 'MateSpan -> {
		start: SmallInteger,
		stop: SmallInteger,
		kind: { type: ByteSymbol, matching: ''[a-z]+|[a-z]+\:'' } }
	MateSpanSend -> {
		span: MateSpan,
		arguments: { type: [ SmallInteger ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
		invariants: { span kind numArgs = arguments size } }'.

	20 timesRepeat: [ | send |
		send := grammar gen: MateSpanSend.
		self assert: send arguments size equals: send span kind numArgs ].

	self should: [
		grammar parse: (MateSpanSend span: (MateSpan from: 1 to: 2 kind: #at:) arguments: OrderedCollection new) ] raise: Error
]

{ #category : 'tests - validation' }
MateSizeInvariantAndShapeTest >> testValidationChecksArityAndShape [

	| grammar |

	grammar := self sendGrammar.

	self assert: (grammar parse: (MateSend selector: #at: arguments: (OrderedCollection with: 1))) notNil.
	self should: [ grammar parse: (MateSend selector: #at:put: arguments: (OrderedCollection with: 1)) ] raise: Error.
	self should: [ grammar parse: (MateSend selector: #At arguments: OrderedCollection new) ] raise: Error
]

{ #category : 'tests - writing' }
MateSizeInvariantAndShapeTest >> testWritingRoundTripsSizeInvariantsAndShapes [

	| grammar reread |

	grammar := self grammarFrom: 'MateSend -> {
		selector: { type: ByteSymbol, matching: ''[a-z]+\:'', except: { #at: . #''+'' } },
		arguments: { type: [ SmallInteger ], collection: OrderedCollection, sizeBetween: 0 and: 2 },
		invariants: { selector numArgs = arguments size } }'.

	reread := MateLanguageParser parse: grammar mateDefinition.

	self assert: reread first equals: (grammar typeDeclarations at: MateSend).
	self assert: reread first invariants asArray equals: (grammar typeDeclarations at: MateSend) invariants asArray
]
