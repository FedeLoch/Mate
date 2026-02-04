Class {
	#name : 'Player',
	#superclass : 'Object',
	#instVars : [
		'name',
		'characterClass',
		'level',
		'missingExperienceForNextLevel'
	],
	#category : 'Mate-Testing Models',
	#package : 'Mate',
	#tag : 'Testing Models'
}

{ #category : 'accessing' }
Player >> characterClass [

	^ characterClass
]

{ #category : 'accessing' }
Player >> characterClass: aCharacterClass [

	characterClass := aCharacterClass 
]

{ #category : 'accessing' }
Player >> level [

	^ level
]

{ #category : 'accessing' }
Player >> level: aLevel [

	level := aLevel
]

{ #category : 'accessing' }
Player >> missingExperienceForNextLevel [

	^ missingExperienceForNextLevel
]

{ #category : 'accessing' }
Player >> missingExperienceForNextLevel: aMissingExperience [

	missingExperienceForNextLevel := aMissingExperience
]

{ #category : 'accessing' }
Player >> model [
	
	"	Player -> {
			name: String,
			characterClass: Warrior | Rogue | Mage,
			level: { type: SmallInteger, constraints: { between: 0 and: 99 } },
			missingExperienceForNextLevel: { type: SmallInteger, constraints: { greaterThan: 0 } }
		}.
	"
]

{ #category : 'accessing' }
Player >> name [

	^ name
]

{ #category : 'accessing' }
Player >> name: aName [

	name := aName 
]
