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

{ #category : 'initialization' }
EnInstanceDeclaration >> initialize [ 
	
	super initialize.
	instanceVariableDeclarations := OrderedCollection new.
]

{ #category : 'accessing' }
EnInstanceDeclaration >> instanceVariableDeclarations [

	^ instanceVariableDeclarations
]

{ #category : 'accessing' }
EnInstanceDeclaration >> instanceVariableDeclarations: decls [ 

	instanceVariableDeclarations := decls
]

{ #category : 'visiting' }
EnInstanceDeclaration >> visiting: aVisitor from: context [

	^ aVisitor visitInstanceDeclaration: self from: context 
]
