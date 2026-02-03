Class {
	#name : 'EnBuiltInDecl',
	#superclass : 'EnTypeDecl',
	#category : 'En-Grammar',
	#package : 'En',
	#tag : 'Grammar'
}

{ #category : 'visiting' }
EnBuiltInDecl >> visiting: aVisitor from: context [

	^ aVisitor visitBuiltinDeclaration: self from: context 
]
