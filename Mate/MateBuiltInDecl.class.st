Class {
	#name : 'MateBuiltInDecl',
	#superclass : 'MateTypeDecl',
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'visiting' }
MateBuiltInDecl >> visiting: aVisitor from: context [

	^ aVisitor visitBuiltinDeclaration: self from: context 
]
