Class {
	#name : 'EnDeclaration',
	#superclass : 'Object',
	#instVars : [
		'rewards',
		'visits',
		'type'
	],
	#category : 'En-Grammar',
	#package : 'En',
	#tag : 'Grammar'
}

{ #category : 'initialization' }
EnDeclaration >> initialize [ 

	super initialize.
	rewards := Dictionary new.
	visits := Dictionary new.
]

{ #category : 'accessing' }
EnDeclaration >> type [

	^ type
]

{ #category : 'accessing' }
EnDeclaration >> type: aType [

	type := aType 
]

{ #category : 'as yet unclassified' }
EnDeclaration >> updateReward: improvement context: context [

	rewards at: context ifAbsentPut: [ 1 ].
	
	rewards at: context update: [ :reward | (reward + improvement) max: 1 ]
]

{ #category : 'as yet unclassified' }
EnDeclaration >> updateVisits: context [

	visits at: context ifAbsentPut: [ 0 ].
	
	visits at: context update: [ :visit | visit + 1 ]
]

{ #category : 'visiting' }
EnDeclaration >> visit: generator from: context [

	self updateVisits: context.
	^ self visiting: generator from: context
]

{ #category : 'visiting' }
EnDeclaration >> visiting: generator from: context [

	self subclassResponsibility 
]
