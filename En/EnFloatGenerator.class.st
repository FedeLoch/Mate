Class {
	#name : 'EnFloatGenerator',
	#superclass : 'EnBuiltInGenerator',
	#category : 'En-BuiltIn Generators',
	#package : 'En',
	#tag : 'BuiltIn Generators'
}

{ #category : 'translating' }
EnFloatGenerator >> generate [

	"TODO: review this"
	^ (Random new next * 1000.0) - 500.0
]

{ #category : 'translating' }
EnFloatGenerator >> generateWithConstraint: aConstraint [

	aConstraint ifNil: [ ^ self generate ].
	
	| min max |
	min := aConstraint universe first.
	max := aConstraint universe last.
	
	^ min + (Random new next * (max - min))
]
