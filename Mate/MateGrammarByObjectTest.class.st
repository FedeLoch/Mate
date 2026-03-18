Class {
	#name : 'MateGrammarByObjectTest',
	#superclass : 'MateGrammarGenerationTest',
	#category : 'Mate-Generation Tests',
	#package : 'Mate',
	#tag : 'Generation Tests'
}

{ #category : 'running' }
MateGrammarByObjectTest >> newGrammar [ 

	^ MateOGGrammar from: self objectInstance 
]

{ #category : 'running' }
MateGrammarByObjectTest >> objectInstance [

	self subclassResponsibility 
]

{ #category : 'tests' }
MateGrammarByObjectTest >> testDecl: type expects: expectedDecl [

	self assert: (grammar typeDeclarations at: type) equals: expectedDecl.
]
