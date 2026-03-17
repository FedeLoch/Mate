Class {
	#name : 'MateHandMadePlayerGrammarTest',
	#superclass : 'MateHandMadeGrammarTest',
	#category : 'Mate-Generation Tests',
	#package : 'Mate',
	#tag : 'Generation Tests'
}

{ #category : 'running' }
MateHandMadePlayerGrammarTest >> newGrammar [

	^ MatePlayerGrammar new.
]

{ #category : 'tests' }
MateHandMadePlayerGrammarTest >> testGrammarCanGenerateAPlayer [

	"Generalize test with a doTest grammar -> obj -> derivation -> obj"
	| player |
	
	player := grammar gen: Player.
	
	self assert: (player class) equals: Player.
	self assert: ({ Rogue . Warrior . Mage } includes: player characterClass class).
]

{ #category : 'tests' }
MateHandMadePlayerGrammarTest >> testGrammarCanGenerateAPlayerAndValidatesItsConstraints [

	"Generalize test with a doTest grammar -> obj -> derivation -> obj"
	| player |
	
	player := grammar gen: Player.

	self assert: (player class) equals: Player.
	self assert: player name class equals: ByteString.
	self assert: ({ Rogue . Warrior . Mage } includes: player characterClass class).
	self assert: ((0 to: 99) includes: player level).
	self assert: (player missingExperienceForNextLevel >= 0).
]

{ #category : 'tests' }
MateHandMadePlayerGrammarTest >> testGrammarSaveRewardOnCharacterClassProduction [

	| playerDerivation |
	
	playerDerivation := grammar generator gen: Player from: MateContext new.
	
	grammar backpropagate: playerDerivation improvement: 42.

]
