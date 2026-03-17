Class {
	#name : 'MatePlayerGrammarTest',
	#superclass : 'MateGrammarTest',
	#category : 'Mate-Grammar Tests',
	#package : 'Mate',
	#tag : 'Grammar Tests'
}

{ #category : 'running' }
MatePlayerGrammarTest >> newGrammar [

	^ MatePlayerGrammar new
]

{ #category : 'running' }
MatePlayerGrammarTest >> testPersonGrammarKnowHowToCalculateItLanguageDefinition [

	self assert: grammar mateDefinition equals: (MatePlayerGrammarByLang new defineObjectGraph)
]
