Class {
	#name : 'MatePointGenerator',
	#superclass : 'MateBuiltInGenerator',
	#instVars : [
		'integerGenerator',
		'floatGenerator'
	],
	#category : 'Mate-Generation',
	#package : 'Mate',
	#tag : 'Generation'
}

{ #category : 'translating' }
MatePointGenerator >> coordinateFor: aRandom [

	^ aRandom next < 0.8
		ifTrue: [ integerGenerator generateBetween: -10000 and: 10000 random: aRandom ]
		ifFalse: [ floatGenerator generateBetween: -10000 and: 10000 random: aRandom ]
]

{ #category : 'translating' }
MatePointGenerator >> generate: aRandom [

	^ (self coordinateFor: aRandom) @ (self coordinateFor: aRandom)
]

{ #category : 'initialization' }
MatePointGenerator >> initialize [ 
	
	super initialize.
	integerGenerator := MateIntegerGenerator new type: SmallInteger.
	floatGenerator := MateFloatGenerator new type: Float
]
