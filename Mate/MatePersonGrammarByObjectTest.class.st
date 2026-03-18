Class {
	#name : 'MatePersonGrammarByObjectTest',
	#superclass : 'MateGrammarByObjectTest',
	#category : 'Mate-Generation Tests',
	#package : 'Mate',
	#tag : 'Generation Tests'
}

{ #category : 'running' }
MatePersonGrammarByObjectTest >> objectInstance [

	^ MatePersonGrammar new gen: MatePerson 
]

{ #category : 'tests' }
MatePersonGrammarByObjectTest >> testGrammarAgeDeclarationsMatch [
	
	self testDecl: MateAge expects: (MateInstDecl new type: MateAge; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'value'; type: SmallInteger 
	})
]

{ #category : 'tests' }
MatePersonGrammarByObjectTest >> testGrammarPersonDeclarationsMatch [

	self testDecl: MatePerson expects: (MateInstDecl new type: MatePerson; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'age'; type: MateAge 
	})
]
