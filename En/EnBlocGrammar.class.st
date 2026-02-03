Class {
	#name : 'EnBlocGrammar',
	#superclass : 'EnOGGrammar',
	#category : 'En-Grammar Tests',
	#package : 'En',
	#tag : 'Grammar Tests'
}

{ #category : 'accessing' }
EnBlocGrammar >> defineGrammar [ 

	^ '
		Element -> {
			name: String,
			characterClass: Warrior | Rogue | Mage,
			level: { type: SmallInteger, constraint: between: 0 and: 99 },
			missingExperienceForNextLevel: { type: SmallInteger, constraint: greaterThan: 0 }
		}.
	'
]

{ #category : 'accessing' }
EnBlocGrammar >> initialize [ 

	super initialize.
	
	"self addTypeDeclaration: (EnInstanceDeclaration new type: Player; instanceVariableDeclarations: {
		EnInstanceVariableDeclaration new name: 'name'; type: String.
		EnInstanceVariableDeclaration new name: 'characterClass'; type: (Warrior | Rogue | Mage).
		EnInstanceVariableDeclaration new name: 'level'; type: SmallInteger; constraint: (EnConstraint between: 0 and: 99).
		EnInstanceVariableDeclaration new name: 'missingExperienceForNextLevel'; type: SmallInteger; constraint: (EnConstraint greaterThan: 0).
	})."
]
