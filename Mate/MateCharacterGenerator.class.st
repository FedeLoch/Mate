Class {
	#name : 'MateCharacterGenerator',
	#superclass : 'MateBuiltInGenerator',
	#instVars : [
		'stringGenerator'
	],
	#category : 'Mate-Generation',
	#package : 'Mate',
	#tag : 'Generation'
}

{ #category : 'translating' }
MateCharacterGenerator >> generate: aRandom [

	^ stringGenerator characterFor: aRandom
]

{ #category : 'initialization' }
MateCharacterGenerator >> initialize [ 
	
	super initialize.
	stringGenerator := MateByteStringGenerator new type: WideString
]
