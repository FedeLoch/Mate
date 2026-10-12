Class {
	#name : 'MatePerson',
	#superclass : 'Object',
	#instVars : [
		'age'
	],
	#category : 'Mate-Testing Models',
	#package : 'Mate',
	#tag : 'Testing Models'
}

{ #category : 'accessing' }
MatePerson >> age [
	
	^ age value
]

{ #category : 'accessing' }
MatePerson >> age: aNumber [

	age := aNumber 
]
