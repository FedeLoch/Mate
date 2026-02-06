Class {
	#name : 'PersonParserTest',
	#superclass : 'MateParserTest',
	#category : 'Mate-Parsing Tests',
	#package : 'Mate',
	#tag : 'Parsing Tests'
}

{ #category : 'tests' }
PersonParserTest >> newGrammar [

	^ MatePersonGrammar new
]

{ #category : 'tests' }
PersonParserTest >> testGivenAPersonItCanGiveTheGrammarDerivation [

	self doTest: (Person new age: (Age new value: 42))
]

{ #category : 'tests' }
PersonParserTest >> testGivenAnAgeItCanGiveTheGrammarDerivation [

	self doTest: (Age new value: 42)
]
