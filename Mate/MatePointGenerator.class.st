Class {
	#name : 'MatePointGenerator',
	#superclass : 'MateBuiltInGenerator',
	#category : 'Mate-BuiltIn Generators',
	#package : 'Mate',
	#tag : 'BuiltIn Generators'
}

{ #category : 'translating' }
MatePointGenerator >> generate [

	^ 	100 atRandom @ 100 atRandom
]
