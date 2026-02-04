Class {
	#name : 'MateArrayDecl',
	#superclass : 'MateTypeDecl',
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'visiting' }
MateArrayDecl >> visiting: aVisitor from: context [

	^ aVisitor visitArrayDeclaration: self from: context 
]
