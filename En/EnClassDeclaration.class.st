Class {
	#name : 'EnClassDeclaration',
	#superclass : 'EnTypeDeclaration',
	#category : 'En-Grammar',
	#package : 'En',
	#tag : 'Grammar'
}

{ #category : 'visiting' }
EnClassDeclaration >> visiting: generator from: context [

	^ generator visitClassDeclaration: self from: context 
]
