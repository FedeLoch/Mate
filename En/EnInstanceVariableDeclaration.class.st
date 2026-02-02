Class {
	#name : 'EnInstanceVariableDeclaration',
	#superclass : 'Object',
	#instVars : [
		'name',
		'type',
		'constraint'
	],
	#category : 'En-Grammar',
	#package : 'En',
	#tag : 'Grammar'
}

{ #category : 'accessing' }
EnInstanceVariableDeclaration >> constraint: aConstraint [

	constraint := aConstraint 
]

{ #category : 'accessing' }
EnInstanceVariableDeclaration >> name [

	^ name
]

{ #category : 'accessing' }
EnInstanceVariableDeclaration >> name: instanceVariableName [

	name := instanceVariableName 
]

{ #category : 'accessing' }
EnInstanceVariableDeclaration >> type [

	^ type
]

{ #category : 'accessing' }
EnInstanceVariableDeclaration >> type: instanceVariableType [

	type := instanceVariableType 
]
