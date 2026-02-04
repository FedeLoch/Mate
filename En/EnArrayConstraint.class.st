Class {
	#name : 'EnArrayConstraint',
	#superclass : 'EnConstraint',
	#instVars : [
		'minSize',
		'maxSize'
	],
	#classInstVars : [
		'minSize'
	],
	#category : 'En-Constraints',
	#package : 'En',
	#tag : 'Constraints'
}

{ #category : 'as yet unclassified' }
EnArrayConstraint class >> sizeBetween: aNumber and: anotherNumber [

	^ self new minSize: aNumber; maxSize: anotherNumber
]

{ #category : 'accessing' }
EnArrayConstraint >> initialize [ 

	super initialize.
	minSize := 0.
	maxSize := SmallInteger maxVal.
]

{ #category : 'accessing' }
EnArrayConstraint >> maxSize: aNumber [

	maxSize := aNumber
]

{ #category : 'accessing' }
EnArrayConstraint >> minSize: aNumber [

	minSize := aNumber
]
