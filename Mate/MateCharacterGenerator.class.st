Class {
	#name : 'MateCharacterGenerator',
	#superclass : 'MateBuiltInGenerator',
	#category : 'Mate-Generation',
	#package : 'Mate',
	#tag : 'Generation'
}

{ #category : 'translating' }
MateCharacterGenerator >> generate [

	^ ($a to: $z) atRandom
	 
]
