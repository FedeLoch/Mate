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

	self assert: (grammar mateDefinition: MateAge) equals: 'MateAge -> {
	value: SmallInteger
}'.
	
	self assert: (grammar mateDefinition: MatePerson) equals: 'MatePerson -> {
	age: MateAge
}'
]
