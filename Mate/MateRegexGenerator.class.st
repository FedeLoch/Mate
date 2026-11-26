"
I generate strings that match a regular expression, by walking the parse tree that RxParser builds for it.

    (MateRegexGenerator generate: '[a-z]+:' random: Random new) "" 'abc:' ""

An alternation chooses one of its branches, a sequence concatenates its pieces, a repetition chooses how many times its atom appears (at most maxRepetitions beyond its minimum when it is unbounded, as with * and +), and a character class chooses one of its characters. Character classes defined by predicates (\w, \d, [:alpha:], negated classes, .) choose among printable ASCII characters. Anchors and word boundaries produce nothing.
"
Class {
	#name : 'MateRegexGenerator',
	#superclass : 'Object',
	#instVars : [
		'random',
		'stream',
		'maxRepetitions'
	],
	#category : 'Mate-Generation',
	#package : 'Mate',
	#tag : 'Generation'
}

{ #category : 'generating' }
MateRegexGenerator class >> generate: aPattern random: aRandom [

	^ self new
		random: aRandom;
		generate: aPattern
]

{ #category : 'private' }
MateRegexGenerator >> choose: aCollection [

	aCollection ifEmpty: [ ^ self error: 'The regular expression has an empty character class' ].
	stream nextPut: (aCollection asArray atRandom: random)
]

{ #category : 'generating' }
MateRegexGenerator >> generate: aPattern [

	stream := WriteStream on: String new.
	(RxParser parse: aPattern) dispatchTo: self.
	^ stream contents
]

{ #category : 'initialization' }
MateRegexGenerator >> initialize [

	super initialize.
	maxRepetitions := 8
]

{ #category : 'accessing' }
MateRegexGenerator >> maxRepetitions: anInteger [
	"Bound for the repetitions of * and +, beyond their minimum."

	maxRepetitions := anInteger
]

{ #category : 'private' }
MateRegexGenerator >> printableCharacters [

	^ (32 to: 126) collect: [ :code | Character value: code ]
]

{ #category : 'accessing' }
MateRegexGenerator >> random: aRandom [

	random := aRandom
]

{ #category : 'visiting' }
MateRegexGenerator >> syntaxAny [

	self choose: self printableCharacters
]

{ #category : 'visiting' }
MateRegexGenerator >> syntaxBeginningOfLine [
]

{ #category : 'visiting' }
MateRegexGenerator >> syntaxBeginningOfWord [
]

{ #category : 'visiting' }
MateRegexGenerator >> syntaxBranch: aBranch [

	aBranch piece dispatchTo: self.
	aBranch branch ifNotNil: [ :rest | rest dispatchTo: self ]
]

{ #category : 'visiting' }
MateRegexGenerator >> syntaxCharSet: aCharSet [

	| enumerable predicates |

	enumerable := aCharSet enumerableSetIgnoringCase: false.
	predicates := aCharSet predicates.

	aCharSet isNegated ifTrue: [
		^ self choose: (self printableCharacters reject: [ :each |
			(enumerable includes: each) or: [ predicates anySatisfy: [ :predicate | predicate value: each ] ] ]) ].

	self choose: (enumerable asArray , (self printableCharacters select: [ :each |
		(enumerable includes: each) not and: [ predicates anySatisfy: [ :predicate | predicate value: each ] ] ]))
]

{ #category : 'visiting' }
MateRegexGenerator >> syntaxCharacter: aCharacterNode [

	stream nextPut: aCharacterNode character
]

{ #category : 'visiting' }
MateRegexGenerator >> syntaxEndOfLine [
]

{ #category : 'visiting' }
MateRegexGenerator >> syntaxEndOfWord [
]

{ #category : 'visiting' }
MateRegexGenerator >> syntaxEpsilon [
]

{ #category : 'visiting' }
MateRegexGenerator >> syntaxNonWordBoundary [
]

{ #category : 'visiting' }
MateRegexGenerator >> syntaxPiece: aPiece [

	| max count |

	max := aPiece max ifNil: [ aPiece min + maxRepetitions ].
	count := aPiece min + (random nextInteger: max - aPiece min + 1) - 1.
	count timesRepeat: [ aPiece atom dispatchTo: self ]
]

{ #category : 'visiting' }
MateRegexGenerator >> syntaxPredicate: aPredicate [

	self choose: (self printableCharacters select: [ :each | aPredicate value: each ])
]

{ #category : 'visiting' }
MateRegexGenerator >> syntaxRegex: aRegex [

	| alternatives node |

	alternatives := OrderedCollection new.
	node := aRegex.
	[ node notNil ] whileTrue: [
		alternatives add: node branch.
		node := node regex ].

	(alternatives atRandom: random) ifNotNil: [ :branch | branch dispatchTo: self ]
]

{ #category : 'visiting' }
MateRegexGenerator >> syntaxWordBoundary [
]
