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
MatePlayerGrammarTest >> testPersonGrammarKnowHowToCalculatePlayerLanguageDefinition [

	self assert: (grammar mateDefinition: Player) equals: 'Player -> {
	name: ByteString,
	characterClass: Mage | Rogue | Warrior,
	level: { type: SmallInteger, between: 0 and: 99 },
	missingExperienceForNextLevel: { type: SmallInteger, atLeast: 1 }
}'
]
