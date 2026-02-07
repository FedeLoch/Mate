Class {
	#name : 'MateGrammarByLangTest',
	#superclass : 'MateGrammarTest',
	#category : 'Mate-Generation Tests',
	#package : 'Mate',
	#tag : 'Generation Tests'
}

{ #category : 'tests' }
MateGrammarByLangTest >> testDecl: type expects: expectedDecl [

	self assert: (grammar typeDeclarations at: type) equals: expectedDecl.
]
