Class {
	#name : 'MatePlayerGrammarByLangTest',
	#superclass : 'MateGrammarByLangTest',
	#category : 'Mate-Generation Tests',
	#package : 'Mate',
	#tag : 'Generation Tests'
}

{ #category : 'running' }
MatePlayerGrammarByLangTest >> newGrammar [

	^ MatePlayerGrammarByLang new
]

{ #category : 'tests' }
MatePlayerGrammarByLangTest >> testGrammarPlayerDeclarationsMatch [

	self testDecl: Player expects: (MateInstDecl new type: Player; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'name'; type: ByteString.
		MateInstVarDecl new name: 'characterClass'; type: (Warrior | Rogue | Mage).
		MateInstVarDecl new name: 'level'; type: SmallInteger; constraint: (MateConstraint between: 0 and: 99).
		MateInstVarDecl new name: 'missingExperienceForNextLevel'; type: SmallInteger; constraint: (MateConstraint greaterThan: 0).
	})
]
