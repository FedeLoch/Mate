Class {
	#name : 'EnBooleanGenerator',
	#superclass : 'EnBuiltInGenerator',
	#category : 'En-BuiltIn Generators',
	#package : 'En',
	#tag : 'BuiltIn Generators'
}

{ #category : 'translating' }
EnBooleanGenerator >> generate [

	^ { true . false } atRandom
]
