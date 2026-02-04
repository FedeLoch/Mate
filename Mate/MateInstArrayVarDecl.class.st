Class {
	#name : 'MateInstArrayVarDecl',
	#superclass : 'MateInstVarDecl',
	#instVars : [
		'elementType',
		'minSize',
		'maxSize'
	],
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'accessing' }
MateInstArrayVarDecl >> elementType: aType [

	elementType := aType
]

{ #category : 'accessing' }
MateInstArrayVarDecl >> size: value [
	
	minSize := value.
	maxSize := value.
]

{ #category : 'accessing' }
MateInstArrayVarDecl >> sizeBetween: value and: anotherValue [
	
	minSize := value.
	maxSize := anotherValue.
]

{ #category : 'visiting' }
MateInstArrayVarDecl >> visiting: generator from: context [

	1 halt.
]
