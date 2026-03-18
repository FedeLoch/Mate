Class {
	#name : 'MatePlayerGrammarByObjectTest',
	#superclass : 'MateGrammarByObjectTest',
	#category : 'Mate-Generation Tests',
	#package : 'Mate',
	#tag : 'Generation Tests'
}

{ #category : 'running' }
MatePlayerGrammarByObjectTest >> mage [

	^ Player new name: 'player 3'; characterClass: Mage new; level: 10; missingExperienceForNextLevel: 100
]

{ #category : 'running' }
MatePlayerGrammarByObjectTest >> objectInstance [

	^ self rogue
	
]

{ #category : 'running' }
MatePlayerGrammarByObjectTest >> rogue [

	^ Player new name: 'player 1'; characterClass: Rogue new; level: 42; missingExperienceForNextLevel: 0
]

{ #category : 'tests' }
MatePlayerGrammarByObjectTest >> testGrammarPlayerDeclarationsMatch [

	self testDecl: Player expects: (MateInstDecl new type: Player; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'name'; type: ByteString.
		MateInstVarDecl new name: 'characterClass'; type: Rogue.
		MateInstVarDecl new name: 'level'; type: SmallInteger.
		MateInstVarDecl new name: 'missingExperienceForNextLevel'; type: SmallInteger.
	})
]

{ #category : 'tests' }
MatePlayerGrammarByObjectTest >> testGrammarPlayerDeclarationsMatchWithMultipleInstances [

	grammar feedByObjectInstance: self warrior.
	grammar feedByObjectInstance: self rogue.
	grammar feedByObjectInstance: self mage.

	self testDecl: Player expects: (MateInstDecl new type: Player; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'name'; type: ByteString.
		MateInstVarDecl new name: 'characterClass'; type: (Mage | Warrior | Rogue).
		MateInstVarDecl new name: 'level'; type: SmallInteger.
		MateInstVarDecl new name: 'missingExperienceForNextLevel'; type: SmallInteger.
	})
]

{ #category : 'running' }
MatePlayerGrammarByObjectTest >> warrior [

	^ Player new name: 'player 1'; characterClass: Warrior new; level: 50; missingExperienceForNextLevel: 0
]
