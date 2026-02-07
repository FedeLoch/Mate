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

{ #category : 'comparing' }
MateInstDecl >> = anObject [

	super = anObject ifFalse: [ ^ false ].
	
	^ instanceVariableDeclarations asArray = anObject instanceVariableDeclarations asArray
]

{ #category : 'comparing' }
MateInstDecl >> hash [

	^ super hash bitXor: instanceVariableDeclarations hash
]

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
MateInstDecl >> visiting: aVisitor from: context constraint: aConstraint [

	^ aVisitor visitInstanceDeclaration: self from: context 
]
