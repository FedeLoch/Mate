Class {
	#name : 'MateColorGenerator',
	#superclass : 'MateBuiltInGenerator',
	#category : 'Mate-BuiltIn Generators',
	#package : 'Mate',
	#tag : 'BuiltIn Generators'
}

{ #category : 'translating' }
MateColorGenerator >> generate [

	^ Color random
	 
]
