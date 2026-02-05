Class {
	#name : 'MateArray',
	#superclass : 'Object',
	#instVars : [
		'elementType'
	],
	#category : 'Mate-Custom Types',
	#package : 'Mate',
	#tag : 'Custom Types'
}

{ #category : 'instance creation' }
MateArray class >> of: elementType [

	^ self new elementType: elementType
]

{ #category : 'accessing' }
MateArray >> elementType: anElementType [

	elementType := anElementType
]

{ #category : 'as yet unclassified' }
MateArray >> getOneFrom: context [ 
	
	^ self class
]
