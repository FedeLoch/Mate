Class {
	#name : 'MateInstOneOfVarDecl',
	#superclass : 'MateInstVarDecl',
	#instVars : [
		'options',
		'explorationConstant'
	],
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'comparing' }
MateInstOneOfVarDecl >> = anObject [

	super = anObject ifFalse: [ ^ false ].
	
	^ options asArray = anObject options asArray
]

{ #category : 'as yet unclassified' }
MateInstOneOfVarDecl >> acceptOption: option [
	
	^ options includes: option
]

{ #category : 'as yet unclassified' }
MateInstOneOfVarDecl >> getBestRewardedOption: context [ 

	"TODO: I am doing the same in MateOptionalType, maybe a can find an abstraction here"
	| bestOption bestScore totalVisits contextRewards contextVisits |
	
	bestOption := nil.
	bestScore := Float negativeInfinity.
	contextVisits := visits at: context key.
	contextRewards := rewards at: context key.
	
	totalVisits := contextVisits values sum.
	
	options do: [ :option | | typeVisits typeReward score |
		typeVisits := contextVisits at: option.
		typeReward := contextRewards at: option ifAbsent: [ 1 ].
		
		"UCT = (reward(rule) / visits(rule)) + C * sqrt(log(total_visits) / visits(rule)))"
		score := (typeReward / typeVisits) + (explorationConstant * ((totalVisits ln / typeVisits) sqrt)).
		
		score > bestScore ifTrue: [ bestScore := score. bestOption := option ].
	].

	^ bestOption ifNil: [ self getOne ]
]

{ #category : 'as yet unclassified' }
MateInstOneOfVarDecl >> getOne [
	
	^ options atRandom
]

{ #category : 'as yet unclassified' }
MateInstOneOfVarDecl >> getOne: context [ 

	| selected |
	
	selected := self selectAnOption: context.
	self updateVisits: context selecting: selected.
	
	^ selected
]

{ #category : 'comparing' }
MateInstOneOfVarDecl >> hash [

	^ super hash bitXor: options hash
]

{ #category : 'initialization' }
MateInstOneOfVarDecl >> initialize [ 

	super initialize.
	explorationConstant := 2.
]

{ #category : 'accessing' }
MateInstOneOfVarDecl >> options [

	^ options
]

{ #category : 'accessing' }
MateInstOneOfVarDecl >> options: someOptions [

	options := someOptions
]

{ #category : 'as yet unclassified' }
MateInstOneOfVarDecl >> rewardAt: context [

	rewards at: (context key) ifAbsentPut: [ Dictionary new ].
	(rewards at: (context key)) at: context object ifAbsent: [ ^ 1 ].

	^ (rewards at: (context key)) at: context object

]

{ #category : 'as yet unclassified' }
MateInstOneOfVarDecl >> selectAnOption: context [
	
	| contextVisits differenceAtLevel |
	
	"Case where the context was not explored before"
	visits at: context key ifAbsent: [ ^ self getOne ].
	
	contextVisits := visits at: context key.
	
	"Case where in the context, there are options unexplored yet"
	differenceAtLevel := (options difference: contextVisits keys).
	differenceAtLevel ifNotEmpty: [ ^ differenceAtLevel asArray first ].
	
	"Case where there is no reward, so, random"
	rewards at: context key ifAbsent: [ ^ self getOne ].

	"Case where we can choose an option by using previous reward information"
	^ self getBestRewardedOption: context
]

{ #category : 'reward' }
MateInstOneOfVarDecl >> totalVisits [

	| total |
	
	total := (visits keys collect: [ :key | (visits at: key) values sum ]).
	
	total ifEmpty: [ ^ 0 ].

	^ total sum
]

{ #category : 'as yet unclassified' }
MateInstOneOfVarDecl >> updateReward: improvement context: context [

	| key option |

	key := context key.
	option := (context parentNode edges at: self name) instance.

	rewards at: key ifAbsentPut: [ Dictionary new ].
	(rewards at: key) at: option ifAbsentPut: [ 1 ].
	
	(rewards at: key) at: option update: [ :reward | (reward + improvement) max: 1 ]
]

{ #category : 'as yet unclassified' }
MateInstOneOfVarDecl >> updateVisits: context [

	"Do nothing"
]

{ #category : 'reward' }
MateInstOneOfVarDecl >> updateVisits: context selecting: option [ 
	
	| key |
	
	key := context key.
	visits at: key ifAbsentPut: [ Dictionary new ].
	visits at: key at: option ifAbsentPut: [ 0 ].
	
	(visits at: key) at: option update: [ :v | v + 1 ]
]

{ #category : 'visiting' }
MateInstOneOfVarDecl >> visiting: aVisitor from: context constraint: aConstraint [

	^ aVisitor visitOneOfDecl: self from: context 
]
