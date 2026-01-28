Class {
	#name : 'Person',
	#superclass : 'Object',
	#instVars : [
		'age'
	],
	#category : 'En-Example',
	#package : 'En',
	#tag : 'Example'
}

{ #category : 'accessing' }
Person >> age [

	^ age age 
]

{ #category : 'accessing' }
Person >> age: anAge [

	age := anAge
]
