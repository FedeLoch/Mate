Class {
	#name : 'MateParsingContext',
	#superclass : 'MateContext',
	#instVars : [
		'object'
	],
	#category : 'Mate-Parsing',
	#package : 'Mate',
	#tag : 'Parsing'
}

{ #category : 'instance creation' }
MateParsingContext class >> from: obj [

	^ self new object: obj
]

{ #category : 'accessing' }
MateParsingContext >> object [

	^ object
]

{ #category : 'accessing' }
MateParsingContext >> object: obj [

	object := obj
]
