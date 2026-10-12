Class {
	#name : 'MateFloatGenerator',
	#superclass : 'MateBuiltInGenerator',
	#category : 'Mate-Generation',
	#package : 'Mate',
	#tag : 'Generation'
}

{ #category : 'testing' }
MateFloatGenerator >> accepts: aValue between: low and: high [

	(aValue isKindOf: type) ifFalse: [ ^ false ].
	low ifNotNil: [ (aValue >= low) ifFalse: [ ^ false ] ].
	high ifNotNil: [ (aValue <= high) ifFalse: [ ^ false ] ].
	^ true
]

{ #category : 'translating' }
MateFloatGenerator >> candidateBetween: low and: high random: aRandom [

	| choice candidates magnitude |
	
	choice := aRandom next.
	
	choice < 0.3 ifTrue: [
		candidates := self interestingValuesBetween: low and: high.
		candidates ifNotEmpty: [ ^ candidates atRandom: aRandom ] ].
	
	(low notNil and: [ high notNil ]) ifTrue: [ ^ (low + (aRandom next * (high - low))) asFloat ].
	
	magnitude := (aRandom next * (10 raisedTo: (aRandom nextInteger: 41) - 21)) asFloat.
	
	low ifNotNil: [ ^ low asFloat + magnitude ].
	high ifNotNil: [ ^ high asFloat - magnitude ].
	
	^ aRandom next < 0.5 ifTrue: [ magnitude ] ifFalse: [ magnitude negated ]
]

{ #category : 'translating' }
MateFloatGenerator >> generate: aRandom [

	^ self generateBetween: nil and: nil random: aRandom
]

{ #category : 'translating' }
MateFloatGenerator >> generateBetween: low and: high random: aRandom [

	1000 timesRepeat: [ | value |
		value := self candidateBetween: low and: high random: aRandom.
		(self accepts: value between: low and: high) ifTrue: [ ^ value ] ].

	^ self error: 'Unable to generate a ', type name, ' between ', low printString, ' and ', high printString
]

{ #category : 'translating' }
MateFloatGenerator >> generateWithin: aConstraint random: aRandom [

	^ self generateBetween: aConstraint min and: aConstraint max random: aRandom
]

{ #category : 'accessing' }
MateFloatGenerator >> interestingValuesBetween: low and: high [

	| values |
	
	values := OrderedCollection withAll: {
		0.0. -0.0. 1.0. -1.0. 0.5. -0.5. 0.1. 1.0e15. -1.0e15. 1.0e-15.
		Float machineEpsilon. Float fminNormalized. Float fminDenormalized.
		Float fmax. Float fmax negated. Float infinity. Float negativeInfinity. Float nan }.
	low ifNotNil: [ values add: low asFloat; add: low asFloat successor ].
	high ifNotNil: [ values add: high asFloat; add: high asFloat predecessor ].

	^ (values select: [ :each | self accepts: each between: low and: high ]) asArray
]
