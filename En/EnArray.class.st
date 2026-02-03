Class {
	#name : 'EnArray',
	#superclass : 'Object',
	#instVars : [
		'elementType'
	],
	#category : 'En-Custom Types',
	#package : 'En',
	#tag : 'Custom Types'
}

{ #category : 'instance creation' }
EnArray class >> of: elementType [

	^ self new elementType: elementType
]

{ #category : 'accessing' }
EnArray >> elementType: anElementType [

	elementType := anElementType
]

{ #category : 'as yet unclassified' }
EnArray >> getOneFrom: anEnContext [ 
	
	^ self class
]
