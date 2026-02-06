Class {
	#name : 'Age',
	#superclass : 'Object',
	#instVars : [
		'value'
	],
	#category : 'Mate-Testing Models',
	#package : 'Mate',
	#tag : 'Testing Models'
}

{ #category : 'evaluating' }
Age >> value [ 

	^ value
]

{ #category : 'accessing' }
Age >> value: anAge [
	
	value := anAge 
]
