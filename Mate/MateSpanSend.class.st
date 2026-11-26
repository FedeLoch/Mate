"
A send whose selector is reached through another object (its span's kind), for testing size invariants over nested paths.
Its arguments are declared before its span, so an inferred grammar has to reorder them.
"
Class {
	#name : 'MateSpanSend',
	#superclass : 'Object',
	#instVars : [
		'arguments',
		'span'
	],
	#category : 'Mate-Testing Models',
	#package : 'Mate',
	#tag : 'Testing Models'
}

{ #category : 'instance creation' }
MateSpanSend class >> span: aSpan arguments: aCollection [

	^ self new setSpan: aSpan arguments: aCollection
]

{ #category : 'accessing' }
MateSpanSend >> arguments [

	^ arguments
]

{ #category : 'initialization' }
MateSpanSend >> setSpan: aSpan arguments: aCollection [

	span := aSpan.
	arguments := aCollection
]

{ #category : 'accessing' }
MateSpanSend >> span [

	^ span
]
