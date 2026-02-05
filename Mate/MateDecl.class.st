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

	| key |
	
	key := context key.
	rewards at: key ifAbsentPut: [ 1 ].

	rewards at: key update: [ :reward | (reward + improvement) max: 1 ]
]

{ #category : 'as yet unclassified' }
MateDecl >> updateVisits: context [

	| key |
	
	key := context key.
	visits at: key ifAbsentPut: [ 0 ].
	
	visits at: key update: [ :visit | visit + 1 ]
]

{ #category : 'visiting' }
MateDecl >> visit: generator from: context constraint: aConstraint [

	self updateVisits: context.

	^ self visiting: generator from: context constraint: aConstraint
]

{ #category : 'visiting' }
MateDecl >> visiting: generator from: context constraint: aConstraint [

	self subclassResponsibility 
]
