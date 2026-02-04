Class {
	#name : 'MateOptionalType',
	#superclass : 'Object',
	#instVars : [
		'optionTypes',
		'rewards',
		'visits'
	],
	#category : 'Mate-Custom Types',
	#package : 'Mate',
	#tag : 'Custom Types'
}

{ #category : 'accessing' }
MateOptionalType class >> options: classes [

	^ self new options: classes
]

{ #category : 'as yet unclassified' }
MateOptionalType >> getOne [
	"Fallback random selection without context"
	
	^ optionTypes atRandom 
]

{ #category : 'as yet unclassified' }
MateOptionalType >> getOneFrom: context [
	"Select a type using UCB1 algorithm based on rewards and visits"
	
	| totalVisits bestType bestScore |
	
	"If not enough data, use random selection"
	totalVisits := visits ifEmpty: [ 0 ] ifNotEmpty: [ visits values sum ].
	totalVisits < (optionTypes size * 2) ifTrue: [ ^ self getOne ].
	
	bestType := nil.
	bestScore := Float negativeInfinity.
	
	optionTypes do: [ :type |
		| typeVisits typeReward ucbScore |
		typeVisits := visits at: type ifAbsent: [ 1 ].
		typeReward := rewards at: type ifAbsent: [ 1 ].
		
		"UCB1 formula: average reward + exploration bonus"
		ucbScore := (typeReward / typeVisits) + (2 * ((totalVisits ln / typeVisits) sqrt)).
		
		ucbScore > bestScore ifTrue: [
			bestScore := ucbScore.
			bestType := type.
		].
	].
	
	^ bestType ifNil: [ self getOne ]
]

{ #category : 'initialization' }
MateOptionalType >> initialize [ 

	super initialize.
	optionTypes := Set new.
	rewards := Dictionary new.
	visits := Dictionary new.
]

{ #category : 'accessing' }
MateOptionalType >> options: options [ 
	
	optionTypes addAll: options
]

{ #category : 'accessing' }
MateOptionalType >> rewards [

	^ rewards
]

{ #category : 'reward' }
MateOptionalType >> updateReward: improvement for: type [

	rewards at: type ifAbsentPut: [ 0 ].
	rewards at: type update: [ :r | r + improvement ].
]

{ #category : 'reward' }
MateOptionalType >> updateVisits: type [

	visits at: type ifAbsentPut: [ 0 ].
	visits at: type update: [ :v | v + 1 ].
]

{ #category : 'accessing' }
MateOptionalType >> visits [

	^ visits
]

{ #category : 'logical operations' }
MateOptionalType >> | aClass [ 

	optionTypes add: aClass 
]
