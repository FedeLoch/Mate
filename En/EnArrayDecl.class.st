Class {
	#name : 'EnArrayDecl',
	#superclass : 'EnTypeDecl',
	#category : 'En-Grammar',
	#package : 'En',
	#tag : 'Grammar'
}

{ #category : 'visiting' }
EnArrayDecl >> visiting: aVisitor from: context [

	^ aVisitor visitArrayDeclaration: self from: context 
]
