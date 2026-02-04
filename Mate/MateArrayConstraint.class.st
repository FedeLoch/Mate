Class {
	#name : 'MateArrayConstraint',
	#superclass : 'MateConstraint',
	#instVars : [
		'minSize',
		'maxSize'
	],
	#classInstVars : [
		'minSize'
	],
	#category : 'Mate-Constraints',
	#package : 'Mate',
	#tag : 'Constraints'
}

{ #category : 'as yet unclassified' }
MateArrayConstraint class >> sizeBetween: aNumber and: anotherNumber [

	^ self new minSize: aNumber; maxSize: anotherNumber
]

{ #category : 'accessing' }
MateArrayConstraint >> initialize [ 

	super initialize.
	minSize := 0.
	maxSize := SmallInteger maxVal.
]

{ #category : 'accessing' }
MateArrayConstraint >> maxSize: aNumber [

	maxSize := aNumber
]

{ #category : 'accessing' }
MateArrayConstraint >> minSize: aNumber [

	minSize := aNumber
]
