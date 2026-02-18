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

{ #category : 'comparing' }
MateDecl >> = anObject [

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	
	^ type = anObject type
]

{ #category : 'comparing' }
MateDecl >> hash [

	^ type hash
]

{ #category : 'as yet unclassified' }
MateDecl >> heatColor: totalVisits [

	| ratio |
	
	(totalVisits = 0) ifTrue: [ ^ Color white ].
	self totalVisits = 0 ifTrue: [ ^ Color white ].
	
	ratio := self totalVisits / totalVisits.
	
	^ Color r: 1 g: (1 - ratio) b: (1 - ratio)
]

{ #category : 'initialization' }
MateDecl >> initialize [ 

	super initialize.
	rewards := Dictionary new.
	visits := Dictionary new.
]

{ #category : 'testing' }
MateDecl >> isRef [

	^ false
]

{ #category : 'as yet unclassified' }
MateDecl >> rewardAt: context [

	rewards at: (context key) ifAbsent: [ ^ 1 ].

	^ rewards at: (context key)

]

{ #category : 'as yet unclassified' }
MateDecl >> totalVisits [

	visits values ifEmpty: [ ^ 0 ].

	^ visits values sum
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
MateDecl >> updateMe: parent replacingChild: child by: newChild [

	| edgeName |

	edgeName := child declaration name.
	parent addEdge: newChild at: edgeName.
	parent instance instVarNamed: edgeName put: newChild instance
]

{ #category : 'as yet unclassified' }
MateDecl >> updateReward: improvement context: context [

	| key |

	key := context key.
	rewards at: key ifAbsentPut: [ 1 ].

	rewards at: key update: [ :reward | (reward + improvement) max: 1 ].
	
	"Propagate the feedback to the type ( in case it is an union type )"
	type ifNotNil: [
		type updateReward: improvement context: context from: self.
	].
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
