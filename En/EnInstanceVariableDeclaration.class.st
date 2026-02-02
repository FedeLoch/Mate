Class {
	#name : 'EnInstanceVariableDeclaration',
	#superclass : 'EnDeclaration',
	#instVars : [
		'name',
		'constraint'
	],
	#category : 'En-Grammar',
	#package : 'En',
	#tag : 'Grammar'
}

{ #category : 'as yet unclassified' }
EnInstanceVariableDeclaration >> chooseOneType [

	^ type getOne
]

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
