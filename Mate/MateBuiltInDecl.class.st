Class {
	#name : 'MateBuiltInDecl',
	#superclass : 'MateTypeDecl',
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'accessing' }
MateBuiltInDecl >> feed: decl [

	^ self
]

{ #category : 'testing' }
MateBuiltInDecl >> isBuiltIn [

	^ true
]

{ #category : 'visiting' }
MateBuiltInDecl >> visiting: aVisitor from: context constraint: aConstraint [

	^ aVisitor visitBuiltinDeclaration: self from: context constraint: aConstraint
]
