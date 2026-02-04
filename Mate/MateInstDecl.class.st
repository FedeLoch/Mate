Class {
	#name : 'MateInstDecl',
	#superclass : 'MateTypeDecl',
	#instVars : [
		'instanceVariableDeclarations'
	],
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'initialization' }
MateInstDecl >> initialize [ 
	
	super initialize.
	instanceVariableDeclarations := OrderedCollection new.
]

{ #category : 'accessing' }
MateInstDecl >> instanceVariableDeclarations [

	^ instanceVariableDeclarations
]

{ #category : 'accessing' }
MateInstDecl >> instanceVariableDeclarations: decls [ 

	instanceVariableDeclarations := decls
]

{ #category : 'visiting' }
MateInstDecl >> visiting: aVisitor from: context [

	^ aVisitor visitInstanceDeclaration: self from: context 
]
