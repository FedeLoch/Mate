Class {
	#name : 'MateInstRefVarDecl',
	#superclass : 'MateInstVarDecl',
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'testing' }
MateInstRefVarDecl >> isRef [

	^ true
]

{ #category : 'visiting' }
MateInstRefVarDecl >> visiting: aVisitor from: context constraint: aConstraint [

	^ aVisitor visitInstRefDecl: self from: context
]
