Class {
	#name : 'MatePersonGrammar',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Tests',
	#package : 'Mate',
	#tag : 'Grammar Tests'
}

{ #category : 'accessing' }
MatePersonGrammar >> defineGrammar [ 

	^ '
	 	Person -> { age: Age }.
	 	Age -> { value: SmallInteger }.
	'
]

{ #category : 'accessing' }
MatePersonGrammar >> initialize [ 
	
	super initialize.
	
	self addTypeDeclaration: (MateInstDecl new type: Person; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'age'; type: Age 
	}).
	self addTypeDeclaration: (MateInstDecl new type: Age; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'value'; type: SmallInteger 
	}).
]
