Class {
	#name : 'MateInstVarDecl',
	#superclass : 'MateDecl',
	#instVars : [
		'name',
		'constraint'
	],
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'comparing' }
MateInstVarDecl >> = anObject [

	super = anObject ifFalse: [ ^ false ].
	
	^ name = anObject name and: [ constraint = anObject constraint ]
]

{ #category : 'as yet unclassified' }
MateInstVarDecl >> acceptType: aType [

	^ type acceptType: aType
]

{ #category : 'as yet unclassified' }
MateInstVarDecl >> chooseOneTypeFrom: context [

	^ type getOneFrom: context
]

{ #category : 'accessing' }
MateInstVarDecl >> constraint [

	^ constraint
]

{ #category : 'accessing' }
MateInstVarDecl >> constraint: aConstraint [

	constraint := aConstraint
]

{ #category : 'comparing' }
MateInstVarDecl >> hash [

	^ (super hash bitXor: name hash) bitXor: constraint hash
]

{ #category : 'accessing' }
MateInstVarDecl >> name [

	^ name
]

{ #category : 'accessing' }
MateInstVarDecl >> name: instanceVariableName [

	name := instanceVariableName 
]

{ #category : 'accessing' }
MateInstVarDecl >> types [

	^ type types
]

{ #category : 'visiting' }
MateInstVarDecl >> visiting: aVisitor from: context constraint: aConstraint [

	^ aVisitor visitInstVarDecl: self from: context
]
