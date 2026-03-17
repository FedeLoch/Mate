Class {
	#name : 'MatePersonGrammarTest',
	#superclass : 'MateGrammarTest',
	#category : 'Mate-Grammar Tests',
	#package : 'Mate',
	#tag : 'Grammar Tests'
}

{ #category : 'running' }
MatePersonGrammarTest >> newGrammar [

	^ MatePersonGrammar new
]

{ #category : 'running' }
MatePersonGrammarTest >> testPersonGrammarKnowHowToCalculateItLanguageDefinition [

	self assert: grammar mateDefinition equals: (MatePersonGrammarByLang new defineObjectGraph)
]
