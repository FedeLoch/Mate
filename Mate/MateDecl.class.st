Class {
	#name : 'MateDecl',
	#superclass : 'Object',
	#instVars : [
		'rewards',
		'visits',
		'type'
	],
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'initialization' }
MateDecl >> initialize [ 

	super initialize.
	rewards := Dictionary new.
	visits := Dictionary new.
]

{ #category : 'accessing' }
MateDecl >> type [

	^ type
]

{ #category : 'accessing' }
MateDecl >> type: aType [

	type := aType 
]

{ #category : 'as yet unclassified' }
MateDecl >> updateReward: improvement context: context [

	rewards at: context ifAbsentPut: [ 1 ].
	
	rewards at: context update: [ :reward | (reward + improvement) max: 1 ]
]

{ #category : 'as yet unclassified' }
MateDecl >> updateVisits: context [

	visits at: context ifAbsentPut: [ 0 ].
	
	visits at: context update: [ :visit | visit + 1 ]
]

{ #category : 'visiting' }
MateDecl >> visit: generator from: context [

	self updateVisits: context.

	^ self visiting: generator from: context
]

{ #category : 'visiting' }
MateDecl >> visiting: generator from: context [

	self subclassResponsibility 
]
