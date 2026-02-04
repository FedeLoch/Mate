Class {
	#name : 'MateBooleanGenerator',
	#superclass : 'MateBuiltInGenerator',
	#category : 'Mate-BuiltIn Generators',
	#package : 'Mate',
	#tag : 'BuiltIn Generators'
}

{ #category : 'translating' }
MateBooleanGenerator >> generate [

	^ { true . false } atRandom
]
