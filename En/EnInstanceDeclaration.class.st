Class {
	#name : 'EnInstanceDeclaration',
	#superclass : 'EnTypeDeclaration',
	#instVars : [
		'instanceVariableDeclarations'
	],
	#category : 'En-Grammar',
	#package : 'En',
	#tag : 'Grammar'
}

{ #category : 'accessing' }
EnInstanceDeclaration >> instanceVariableDeclarations [

	^ instanceVariableDeclarations
]

{ #category : 'accessing' }
EnInstanceDeclaration >> instanceVariableDeclarations: decls [ 

	instanceVariableDeclarations := decls
]

{ #category : 'visiting' }
EnInstanceDeclaration >> visiting: generator from: context [

	^ generator visitInstanceDeclaration: self from: context 
]
