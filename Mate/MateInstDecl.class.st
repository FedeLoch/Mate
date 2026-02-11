Class {
	#name : 'MateInstDecl',
	#superclass : 'MateTypeDecl',
	#instVars : [
		'instanceVariableDeclarations',
		'selfReferences'
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
	selfReferences := OrderedCollection new.
]

{ #category : 'accessing' }
MateInstDecl >> instanceVariableDeclarations [

	^ instanceVariableDeclarations
]

{ #category : 'accessing' }
MateInstDecl >> instanceVariableDeclarations: decls [ 

	instanceVariableDeclarations := decls
]

{ #category : 'accessing' }
MateInstDecl >> selfReferences [

	^ selfReferences
]

{ #category : 'accessing' }
MateInstDecl >> selfReferences: references [ 

	selfReferences := references
]

{ #category : 'visiting' }
MateInstDecl >> visiting: aVisitor from: context constraint: aConstraint [

	^ aVisitor visitInstanceDeclaration: self from: context 
]
