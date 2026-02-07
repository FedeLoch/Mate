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

{ #category : 'comparing' }
MateInstArrayVarDecl >> = anObject [

	super = anObject ifFalse: [ ^ false ].
	
	^ elementType = anObject elementType and: [ 
		minSize = anObject minSize and: [ 
			maxSize = anObject maxSize ] ]
]

{ #category : 'visiting' }
MateInstArrayVarDecl >> acceptSize: size [ 
	
	^ size between: minSize and: maxSize 
]

{ #category : 'accessing' }
MateInstArrayVarDecl >> elementType [

	^ elementType
]

{ #category : 'accessing' }
MateInstArrayVarDecl >> elementType: aType [

	elementType := aType
]

{ #category : 'comparing' }
MateInstArrayVarDecl >> hash [

	^ ((super hash bitXor: elementType hash) bitXor: minSize hash) bitXor: maxSize hash
]

{ #category : 'accessing' }
MateInstArrayVarDecl >> maxSize [

	^ maxSize
]

{ #category : 'accessing' }
MateInstArrayVarDecl >> minSize [

	^ minSize
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
MateInstArrayVarDecl >> visiting: aVisitor from: context constraint: aConstraint [

	^ aVisitor visitArrayDecl: self from: context
]
