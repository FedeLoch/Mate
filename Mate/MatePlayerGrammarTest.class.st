Class {
	#name : 'MatePlayerGrammarTest',
	#superclass : 'MateHandMadeGrammarTest',
	#category : 'Mate-Grammar Tests',
	#package : 'Mate',
	#tag : 'Grammar Tests'
}

{ #category : 'running' }
MatePlayerGrammarTest >> newGrammar [

	^ MatePlayerGrammar new.
]

{ #category : 'tests' }
MatePlayerGrammarTest >> testGrammarCanGenerateAPerson [

	"Generalize test with a doTest grammar -> obj -> derivation -> obj"
	| player |
	
	player := grammar gen: Player.

	self assert: (player class) equals: Player.
	self assert: ({ Rogue . Warrior . Mage } includes: player characterClass class).
]

{ #category : 'tests' }
MatePlayerGrammarTest >> testGrammarCanGenerateAPersonAndValidatesItsConstraints [

	"Generalize test with a doTest grammar -> obj -> derivation -> obj"
	| player |
	
	player := grammar gen: Player.

	self assert: (player class) equals: Player.
	self assert: player name class equals: ByteString.
	self assert: ({ Rogue . Warrior . Mage } includes: player characterClass class).
	self assert: ((0 to: 99) includes: player level).
	self assert: (player missingExperienceForNextLevel >= 0).
]
