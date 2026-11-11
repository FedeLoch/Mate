Class {
	#name : 'MateSealed',
	#superclass : 'Object',
	#instVars : [
		'value'
	],
	#category : 'Mate-Testing Models',
	#package : 'Mate',
	#tag : 'Testing Models'
}

{ #category : 'instance creation' }
MateSealed class >> new [

	^ self error: 'Use value: instead'
]

{ #category : 'instance creation' }
MateSealed class >> value: aValue [

	^ self basicNew setValue: aValue
]

{ #category : 'initialization' }
MateSealed >> setValue: aValue [

	value := aValue
]

{ #category : 'accessing' }
MateSealed >> value [

	^ value
]
