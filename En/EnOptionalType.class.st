Class {
	#name : 'EnOptionalType',
	#superclass : 'Object',
	#instVars : [
		'optionTypes',
		'rewards',
		'visits'
	],
	#category : 'En-Grammar',
	#package : 'En',
	#tag : 'Grammar'
}

{ #category : 'accessing' }
EnOptionalType class >> options: classes [

	^ self new options: classes
]

{ #category : 'as yet unclassified' }
EnOptionalType >> getOne [
	"Fallback random selection without context"
	
	^ optionTypes atRandom 
]

{ #category : 'as yet unclassified' }
EnOptionalType >> getOneFrom: context [
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
EnOptionalType >> initialize [ 

	super initialize.
	optionTypes := Set new.
	rewards := Dictionary new.
	visits := Dictionary new.
]

{ #category : 'accessing' }
EnOptionalType >> options: options [ 
	
	optionTypes addAll: options
]

{ #category : 'accessing' }
EnOptionalType >> rewards [

	^ rewards
]

{ #category : 'reward' }
EnOptionalType >> updateReward: improvement for: type [

	rewards at: type ifAbsentPut: [ 0 ].
	rewards at: type update: [ :r | r + improvement ].
]

{ #category : 'reward' }
EnOptionalType >> updateVisits: type [

	visits at: type ifAbsentPut: [ 0 ].
	visits at: type update: [ :v | v + 1 ].
]

{ #category : 'accessing' }
EnOptionalType >> visits [

	^ visits
]

{ #category : 'logical operations' }
EnOptionalType >> | aClass [ 

	optionTypes add: aClass 
]
