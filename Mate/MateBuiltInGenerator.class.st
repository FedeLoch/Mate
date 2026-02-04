Class {
	#name : 'MateBuiltInGenerator',
	#superclass : 'Object',
	#category : 'Mate-BuiltIn Generators',
	#package : 'Mate',
	#tag : 'BuiltIn Generators'
}

{ #category : 'translating' }
MateBuiltInGenerator >> generate [

	self subclassResponsibility 
]

{ #category : 'translating' }
MateBuiltInGenerator >> generateWithConstraint: aConstraint [
	"TODO: Subclasses override it."

	^ self generate
]
