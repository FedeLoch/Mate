Class {
	#name : 'EnClassDeclaration',
	#superclass : 'EnTypeDeclaration',
	#category : 'En-Grammar',
	#package : 'En',
	#tag : 'Grammar'
}

{ #category : 'visiting' }
EnClassDeclaration >> visiting: aVisitor from: context [

	^ aVisitor visitClassDeclaration: self from: context 
]
