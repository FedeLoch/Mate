Class {
	#name : 'MateTypeDecl',
	#superclass : 'MateDecl',
	#instVars : [
		'grammar'
	],
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'accessing' }
MateTypeDecl >> grammar: aGrammar [

	grammar := aGrammar 
]

{ #category : 'accessing' }
MateTypeDecl >> name [

	^ type name 
]

{ #category : 'rendering' }
MateTypeDecl >> renderShapes [

	1 halt.
]
