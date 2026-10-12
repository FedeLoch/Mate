Class {
	#name : 'MateIntegerGenerator',
	#superclass : 'MateBuiltInGenerator',
	#category : 'Mate-Generation',
	#package : 'Mate',
	#tag : 'Generation'
}

{ #category : 'translating' }
MateIntegerGenerator >> generate: aRandom [

	^ self generateBetween: self minimum and: self maximum random: aRandom
]

{ #category : 'translating' }
MateIntegerGenerator >> generateBetween: low and: high random: aRandom [

	| choice candidates |
	
	low > high ifTrue: [ ^ self error: 'Empty integer range ', low printString, '..', high printString ].
	
	choice := aRandom next.
	
	choice < 0.3 ifTrue: [
		candidates := self interestingValuesBetween: low and: high.
		candidates ifNotEmpty: [ ^ candidates atRandom: aRandom ] ].
	
	(choice < 0.6 and: [ low <= 128 and: [ high >= -128 ] ]) ifTrue: [
		^ self uniformBetween: (low max: -128) and: (high min: 128) random: aRandom ].

	^ self uniformBetween: low and: high random: aRandom
]

{ #category : 'translating' }
MateIntegerGenerator >> generateWithin: aConstraint random: aRandom [

	^ self
		generateBetween: ((aConstraint min ifNil: [ self minimum ]) max: self minimum) ceiling
		and: ((aConstraint max ifNil: [ self maximum ]) min: self maximum) floor
		random: aRandom
]

{ #category : 'accessing' }
MateIntegerGenerator >> interestingValuesBetween: low and: high [

	| values |
	
	values := #( 0 1 -1 2 -2 7 8 15 16 31 32 63 64 127 128 -128 -129 255 256 1023 1024 32767 32768 -32768 -32769 65535 65536 2147483647 2147483648 -2147483648 -2147483649 4294967295 4294967296 ) asOrderedCollection.
	values addAll: {
		low. low + 1. high - 1. high.
		SmallInteger maxVal. SmallInteger maxVal + 1.
		SmallInteger minVal. SmallInteger minVal - 1.
		(2 raisedTo: 64). (2 raisedTo: 64) negated }.

	^ (values select: [ :each | (each between: low and: high) and: [ each isKindOf: type ] ]) asSet asArray sort
]

{ #category : 'accessing' }
MateIntegerGenerator >> maximum [

	type = LargeNegativeInteger ifTrue: [ ^ SmallInteger minVal - 1 ].
	type = LargePositiveInteger ifTrue: [ ^ 2 raisedTo: 128 ].
	^ SmallInteger maxVal
]

{ #category : 'accessing' }
MateIntegerGenerator >> minimum [

	type = LargeNegativeInteger ifTrue: [ ^ (2 raisedTo: 128) negated ].
	type = LargePositiveInteger ifTrue: [ ^ SmallInteger maxVal + 1 ].
	^ SmallInteger minVal
]

{ #category : 'translating' }
MateIntegerGenerator >> uniformBetween: low and: high random: aRandom [

	^ low + (aRandom nextInteger: high - low + 1) - 1
]
