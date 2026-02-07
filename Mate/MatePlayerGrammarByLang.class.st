Class {
	#name : 'MatePlayerGrammarByLang',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Examples',
	#package : 'Mate',
	#tag : 'Grammar Examples'
}

{ #category : 'accessing' }
MatePlayerGrammarByLang >> defineObjectGraph [

	^ '
		Player -> {
			name: ByteString,
			characterClass: Warrior | Rogue | Mage,
			level: { type: SmallInteger, between: 0 and: 99 },
			missingExperienceForNextLevel: { type: SmallInteger, greaterThan: 0 }
		}
	'
]
