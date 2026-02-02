Class {
	#name : 'EnPlayerGrammarTest',
	#superclass : 'EnHandMadeGrammarTest',
	#category : 'En-Grammar Tests',
	#package : 'En',
	#tag : 'Grammar Tests'
}

{ #category : 'running' }
EnPlayerGrammarTest >> newGrammar [

	^ EnPlayerGrammar new.
]

{ #category : 'tests' }
EnPlayerGrammarTest >> testGrammarCanGenerateAPerson [

	"Generalize test with a doTest grammar -> obj -> derivation -> obj"
	| player |
	
	player := grammar gen: Player.

	self assert: (player class) equals: Player.
	self assert: ({ Rogue . Warrior . Mage } includes: player characterClass class).
]

{ #category : 'tests' }
EnPlayerGrammarTest >> testGrammarCanGenerateAPersonAndValidatesItsConstraints [

	"Generalize test with a doTest grammar -> obj -> derivation -> obj"
	| player |
	
	player := grammar gen: Player.

	self assert: (player class) equals: Player.
	self assert: player name class equals: ByteString.
	self assert: ({ Rogue . Warrior . Mage } includes: player characterClass class).
	self assert: ((0 to: 99) includes: player level).
	self assert: (player missingExperienceForNextLevel >= 0).
]
