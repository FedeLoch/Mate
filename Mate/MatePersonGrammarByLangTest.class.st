Class {
	#name : 'MatePersonGrammarByLangTest',
	#superclass : 'MateGrammarByLangTest',
	#category : 'Mate-Generation Tests',
	#package : 'Mate',
	#tag : 'Generation Tests'
}

{ #category : 'running' }
MatePersonGrammarByLangTest >> newGrammar [

	^ MatePersonGrammarByLang new
]

{ #category : 'tests' }
MatePersonGrammarByLangTest >> testGrammarAgeDeclarationsMatch [
	
	self testDecl: Age expects: (MateInstDecl new type: Age; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'value'; type: SmallInteger 
	})
]

{ #category : 'tests' }
MatePersonGrammarByLangTest >> testGrammarPersonDeclarationsMatch [

	self testDecl: Person expects: (MateInstDecl new type: Person; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'age'; type: Age 
	})
]
