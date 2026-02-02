Class {
	#name : 'EnTypeDeclaration',
	#superclass : 'Object',
	#instVars : [
		'type',
		'grammar',
		'rewards',
		'visits'
	],
	#category : 'En-Grammar',
	#package : 'En',
	#tag : 'Grammar'
}

{ #category : 'accessing' }
EnTypeDeclaration >> grammar: aGrammar [

	grammar := aGrammar 
]

{ #category : 'initialization' }
EnTypeDeclaration >> initialize [ 

	super initialize.
	rewards := Dictionary new.
	visits := Dictionary new.
]

{ #category : 'accessing' }
EnTypeDeclaration >> type [

	^ type
]

{ #category : 'accessing' }
EnTypeDeclaration >> type: aType [

	type := aType 
]

{ #category : 'as yet unclassified' }
EnTypeDeclaration >> updateReward: improvement context: context [

	rewards at: context ifAbsentPut: [ 1 ].
	
	rewards at: context update: [ :reward | (reward + improvement) max: 1 ]
]

{ #category : 'as yet unclassified' }
EnTypeDeclaration >> updateVisits: context [

	visits at: context ifAbsentPut: [ 0 ].
	
	visits at: context update: [ :visit | visit + 1 ]
]

{ #category : 'visiting' }
EnTypeDeclaration >> visit: generator from: context [

	self updateVisits: context.
	^ self visiting: generator from: context
]

{ #category : 'visiting' }
EnTypeDeclaration >> visiting: generator from: context [

	self subclassResponsibility 
]
