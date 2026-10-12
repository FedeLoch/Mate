Class {
	#name : 'MateBooleanGenerator',
	#superclass : 'MateBuiltInGenerator',
	#category : 'Mate-Generation',
	#package : 'Mate',
	#tag : 'Generation'
}

{ #category : 'translating' }
MateBooleanGenerator >> generate: aRandom [

	^ aRandom next < 0.5
]
