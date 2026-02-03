Class {
	#name : 'EnBuiltInGenerator',
	#superclass : 'Object',
	#category : 'En-BuiltIn Generators',
	#package : 'En',
	#tag : 'BuiltIn Generators'
}

{ #category : 'translating' }
EnBuiltInGenerator >> generate [

	self subclassResponsibility 
]

{ #category : 'translating' }
EnBuiltInGenerator >> generateWithConstraint: aConstraint [
	"TODO: Subclasses override it."

	^ self generate
]
