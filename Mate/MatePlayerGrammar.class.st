Class {
	#name : 'MatePlayerGrammar',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Examples',
	#package : 'Mate',
	#tag : 'Grammar Examples'
}

{ #category : 'accessing' }
MatePlayerGrammar >> defineGrammar [ 

	^ '
		Player -> {
			name: ByteString,
			characterClass: Warrior | Rogue | Mage,
			level: { type: SmallInteger, between: 0 and: 99 },
			missingExperienceForNextLevel: { type: SmallInteger, greaterThan: 0 }
		}
	'
]

{ #category : 'accessing' }
MatePlayerGrammar >> initialize [ 

	super initialize.
	
	self addTypeDeclaration: (MateInstDecl new type: Player; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'name'; type: ByteString.
		MateInstVarDecl new name: 'characterClass'; type: (Warrior | Rogue | Mage).
		MateInstVarDecl new name: 'level'; type: SmallInteger; constraint: (MateConstraint between: 0 and: 99).
		MateInstVarDecl new name: 'missingExperienceForNextLevel'; type: SmallInteger; constraint: (MateConstraint greaterThan: 0).
	}).
]
