Class {
	#name : 'PlayerParserTest',
	#superclass : 'MateParserTest',
	#category : 'Mate-Parsing Tests',
	#package : 'Mate',
	#tag : 'Parsing Tests'
}

{ #category : 'tests' }
PlayerParserTest >> newGrammar [

	^ MatePlayerGrammar new
]

{ #category : 'tests' }
PlayerParserTest >> testGivenAGeneratedPlayerItCanGiveTheGrammarDerivation [

	self doTest: (grammar gen: Player)
]

{ #category : 'tests' }
PlayerParserTest >> testGivenAPersonItCanGiveTheGrammarDerivation [

	self doTest: (Player new
		name: 'Fede';
		level: 42;
		characterClass: (Rogue new);
		missingExperienceForNextLevel: 0)
]
