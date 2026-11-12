Class {
	#name : 'MateAliasTest',
	#superclass : 'TestCase',
	#category : 'Mate-Grammar Tests',
	#package : 'Mate',
	#tag : 'Grammar Tests'
}

{ #category : 'helpers' }
MateAliasTest >> field: aName of: aClass in: aGrammar [

	^ (aGrammar typeDeclarations at: aClass) instanceVariableDeclarationNamed: aName
]

{ #category : 'helpers' }
MateAliasTest >> grammarFrom: aString [

	^ MateOGGrammar new
		addTypeDeclarations: (MateLanguageParser parse: aString);
		seed: 31;
		yourself
]

{ #category : 'helpers' }
MateAliasTest >> lines: someLines [

	^ String cr join: someLines
]

{ #category : 'tests - errors' }
MateAliasTest >> testAliasCannotBeDefinedTwice [

	self
		should: [ MateLanguageParser parse: 'MateShape = MateAge MateShape = ReferredObject RefObject -> { name: MateShape }' ]
		raise: Error
]

{ #category : 'tests - errors' }
MateAliasTest >> testAliasCannotBeNullableInItsDefinition [

	self
		should: [ MateLanguageParser parse: 'MateShape = MateAge? RefObject -> { name: MateShape }' ]
		raise: Error
]

{ #category : 'tests - errors' }
MateAliasTest >> testAliasCyclesAreRejected [

	self
		should: [ MateLanguageParser parse: 'MateLoopA = MateLoopB | MateAge MateLoopB = MateLoopA RefObject -> { name: MateLoopA }' ]
		raise: Error.
	self
		should: [ MateLanguageParser parse: 'MateLoopA = MateLoopA | MateAge RefObject -> { name: MateAge }' ]
		raise: Error
]

{ #category : 'tests - errors' }
MateAliasTest >> testAliasNameCannotBeAnExistingClass [

	self
		should: [ MateLanguageParser parse: 'MateAge = SmallInteger RefObject -> { name: MateAge }' ]
		raise: Error
]

{ #category : 'tests - errors' }
MateAliasTest >> testFieldAliasesCannotBeUsedInsideOtherTypes [

	self
		should: [ MateLanguageParser parse: 'MateBound = { type: SmallInteger, between: 0 and: 9 } MateSpan -> { start: MateBound | MateAge }' ]
		raise: Error.
	self
		should: [ MateLanguageParser parse: 'MateBound = { type: SmallInteger, between: 0 and: 9 } BlChildrenArray -> { array: { type: [ MateBound ], size: 2 } }' ]
		raise: Error
]

{ #category : 'tests - errors' }
MateAliasTest >> testUnknownAliasesAreReportedAsMissingClasses [

	self
		should: [ MateLanguageParser parse: 'RefObject -> { name: MateUndefinedAlias }' ]
		raise: Error
]

{ #category : 'tests - generation' }
MateAliasTest >> testAliasesCanBeDefinedAfterTheirUse [

	| grammar |

	grammar := self grammarFrom: 'RefObject -> { name: MateShape } MateShape = MateAge | ReferredObject'.

	10 timesRepeat: [
		self assert: ({ MateAge. ReferredObject } includes: ((grammar gen: RefObject) instVarNamed: 'name') class) ]
]

{ #category : 'tests - generation' }
MateAliasTest >> testAliasesCanUseOtherAliases [

	| grammar |

	grammar := self grammarFrom: 'MateLeaf = MateAge MateShape = MateLeaf | ReferredObject RefObject -> { name: MateShape }'.

	self assert: (self field: 'name' of: RefObject in: grammar) types asSet equals: { MateAge. ReferredObject } asSet.
	self assert: (self field: 'name' of: RefObject in: grammar) type name equals: 'MateShape'
]

{ #category : 'tests - generation' }
MateAliasTest >> testAliasesInsideArrayElementTypes [

	| grammar holder |

	grammar := self grammarFrom: 'MateShape = MateAge | ReferredObject BlChildrenArray -> { array: { type: [ MateShape | MateSpan ], size: 9 } }'.
	holder := grammar gen: BlChildrenArray.

	self assert: (holder array collect: #class) asSet equals: { MateAge. ReferredObject. MateSpan } asSet.
	self assert: (grammar parse: holder) notNil
]

{ #category : 'tests - generation' }
MateAliasTest >> testArrayAndOneOfAliases [

	| grammar |

	grammar := self grammarFrom: 'MateKinds = { oneOf: { #open . #closed } }
		MateNumbers = { type: [ SmallInteger ], sizeBetween: 1 and: 3 }
		MateSpan -> { kind: MateKinds }
		BlChildrenArray -> { array: MateNumbers }'.

	10 timesRepeat: [ | numbers |
		self assert: (#( #open #closed ) includes: (grammar gen: MateSpan) kind).
		numbers := (grammar gen: BlChildrenArray) array.
		self assert: (numbers size between: 1 and: 3).
		self assert: (numbers allSatisfy: #isInteger) ]
]

{ #category : 'tests - generation' }
MateAliasTest >> testEachUseOfAnAliasLearnsSeparately [

	| grammar first second start stop |

	grammar := self grammarFrom: 'MateShape = MateAge | ReferredObject
		MateBound = { type: SmallInteger, between: 0 and: 9 }
		RefObject -> { name: MateShape, myLittleObject: MateShape }
		MateSpan -> { start: MateBound, stop: MateBound }'.
	first := (self field: 'name' of: RefObject in: grammar) type.
	second := (self field: 'myLittleObject' of: RefObject in: grammar) type.
	start := self field: 'start' of: MateSpan in: grammar.
	stop := self field: 'stop' of: MateSpan in: grammar.

	10 timesRepeat: [ grammar gen: RefObject ].
	grammar gen: MateSpan.

	self deny: first identicalTo: second.
	self deny: first visits identicalTo: second visits.
	self deny: first rewards identicalTo: second rewards.
	self assert: first visits notEmpty.
	self assert: second visits notEmpty.
	self deny: start identicalTo: stop.
	self assert: start alias identicalTo: stop alias.
	self assert: start totalVisits equals: 1.
	self assert: stop totalVisits equals: 1
]

{ #category : 'tests - generation' }
MateAliasTest >> testFieldAliasCarriesItsConstraint [

	| grammar |

	grammar := self grammarFrom: 'MateBound = { type: SmallInteger, between: 0 and: 9 } MateSpan -> { start: MateBound, stop: MateBound }'.

	20 timesRepeat: [ | span |
		span := grammar gen: MateSpan.
		self assert: (span start between: 0 and: 9).
		self assert: (span stop between: 0 and: 9) ].
	self should: [ grammar parse: (MateSpan from: 3 to: 10 kind: nil) ] raise: Error
]

{ #category : 'tests - generation' }
MateAliasTest >> testFieldsCanMakeAnAliasNullable [

	| grammar span |

	grammar := self grammarFrom: 'MateShape = MateAge | ReferredObject
		MateBound = { type: SmallInteger, between: 0 and: 9 }
		MateSpan -> { start: MateBound?, stop: MateBound, kind: MateShape? }'.
	grammar generator nilProbability: 1.
	span := grammar gen: MateSpan.

	self assert: span start isNil.
	self assert: span kind isNil.
	self assert: span stop notNil
]

{ #category : 'tests - generation' }
MateAliasTest >> testTypeAliasGeneratesOneOfItsTypes [

	| grammar classes |

	grammar := self grammarFrom: 'MateShape = MateAge | ReferredObject RefObject -> { name: MateShape, myLittleObject: MateShape | MateSpan }'.
	classes := Set new.

	20 timesRepeat: [ | object |
		object := grammar gen: RefObject.
		self assert: ({ MateAge. ReferredObject } includes: (object instVarNamed: 'name') class).
		classes add: (object instVarNamed: 'myLittleObject') class.
		self assert: (grammar parse: object) notNil ].

	self assert: classes equals: { MateAge. ReferredObject. MateSpan } asSet
]

{ #category : 'tests - writing' }
MateAliasTest >> testGrammarsWithoutAliasesAreWrittenWithoutAliasSection [

	self
		assert: (MatePersonGrammar new mateDefinition: MateAge)
		equals: (self lines: #( 'MateAge -> {' '	value: SmallInteger' '}' )).
	self deny: (MatePlayerGrammar new mateDefinition includesSubstring: ' = ')
]

{ #category : 'tests - writing' }
MateAliasTest >> testWriterKeepsAliasNamesAndRoundTrips [

	| grammar text reparsed |

	grammar := self grammarFrom: 'RefObject -> { name: MateShape, myLittleObject: (MateShape | MateSpan)? }
		MateSpan -> { start: MateBound, stop: MateBound?, kind: { type: MateLeaf, nullable: true } }
		MateShape = MateLeaf | ReferredObject
		MateLeaf = MateAge
		MateBound = { type: SmallInteger, between: 0 and: 9 }'.
	text := grammar mateDefinition.

	self assert: text equals: (self lines: #(
		'MateBound = { type: SmallInteger, between: 0 and: 9 }'
		'MateLeaf = MateAge'
		'MateShape = MateLeaf | ReferredObject'
		''
		'MateSpan -> {'
		'	start: MateBound,'
		'	stop: MateBound?,'
		'	kind: MateLeaf?'
		'}'
		''
		'RefObject -> {'
		'	name: MateShape,'
		'	myLittleObject: (MateShape | MateSpan)?'
		'}' )).

	reparsed := self grammarFrom: text.
	(reparsed typeDeclarations values reject: #isBuiltIn) do: [ :decl |
		self assert: decl equals: (grammar typeDeclarations at: decl type) ].
	self assert: reparsed mateDefinition equals: text
]
