Class {
	#name : 'MatePersonGrammar',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Examples',
	#package : 'Mate',
	#tag : 'Grammar Examples'
}

{ #category : 'accessing' }
MatePersonGrammar >> initialize [ 
	
	super initialize.
	
	self addTypeDeclaration: (MateInstDecl new type: MatePerson; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'age'; type: MateAge 
	}).
	self addTypeDeclaration: (MateInstDecl new type: MateAge; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'value'; type: SmallInteger 
	}).
]
