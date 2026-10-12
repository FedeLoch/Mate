Class {
	#name : 'MateColorGenerator',
	#superclass : 'MateBuiltInGenerator',
	#category : 'Mate-Generation',
	#package : 'Mate',
	#tag : 'Generation'
}

{ #category : 'translating' }
MateColorGenerator >> generate: aRandom [

	^ Color r: aRandom next g: aRandom next b: aRandom next
]
