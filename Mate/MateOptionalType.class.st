Class {
	#name : 'MateOptionalType',
	#superclass : 'Object',
	#instVars : [
		'optionTypes',
		'rewards',
		'visits',
		'explorationConstant'
	],
	#category : 'Mate-Custom Types',
	#package : 'Mate',
	#tag : 'Custom Types'
}

{ #category : 'accessing' }
MateOptionalType class >> options: classes [

	^ self new options: classes
]

{ #category : 'accessing' }
MateOptionalType class >> typesOf: aType [

	aType ifNil: [ ^ #() ].

	^ (aType isKindOf: MateOptionalType)
		ifTrue: [ aType types asArray ]
		ifFalse: [ { aType } ]
]

{ #category : 'accessing' }
MateOptionalType class >> union: aType with: anotherType [

	| types |
	
	aType ifNil: [ ^ anotherType ].
	anotherType ifNil: [ ^ aType ].
	
	types := Set new.
	types addAll: (self typesOf: aType); addAll: (self typesOf: anotherType).
	
	types size = 1 ifTrue: [ ^ types anyOne ].

	^ self options: types
]

{ #category : 'comparing' }
MateOptionalType >> = anObject [

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	
	^ optionTypes = anObject types
]

{ #category : 'visiting' }
MateOptionalType >> acceptType: aType [

	^ optionTypes anySatisfy: [ :each | aType includesBehavior: each ]
]

{ #category : 'as yet unclassified' }
MateOptionalType >> getBestRewardedType: context [

	| bestType bestScore totalVisits contextRewards contextVisits |
	
	bestType := nil.
	bestScore := Float negativeInfinity.
	contextVisits := visits at: context key.
	contextRewards := rewards at: context key.
	
	totalVisits := contextVisits values sum.
	
	self orderedTypes do: [ :type | | typeVisits typeReward score |
		typeVisits := contextVisits at: type.
		typeReward := contextRewards at: type ifAbsent: [ 1 ].
		
		score := (typeReward / typeVisits) + (explorationConstant * ((totalVisits ln / typeVisits) sqrt)).
		
		score > bestScore ifTrue: [ bestScore := score. bestType := type ].
	].

	^ bestType ifNil: [ self getOne: context random ]
]

{ #category : 'as yet unclassified' }
MateOptionalType >> getOne [

	^ self getOne: SharedRandom globalGenerator
]

{ #category : 'as yet unclassified' }
MateOptionalType >> getOne: aRandom [

	^ self orderedTypes atRandom: aRandom
]

{ #category : 'as yet unclassified' }
MateOptionalType >> getOneFrom: context [

	| selected |
	
	selected := self selectAtype: context.
	self updateVisits: context selecting: selected.
	
	^ selected
]

{ #category : 'comparing' }
MateOptionalType >> hash [

	^ self class hash
]

{ #category : 'rendering' }
MateOptionalType >> heatColorFor: type [

	| ratio visitsForType totalVisits |
	
	totalVisits := self totalVisits.

	totalVisits = 0 ifTrue: [ ^ Color white ].
	visitsForType := self totalVisitsFor: type.
	visitsForType = 0 ifTrue: [ ^ Color white ].

	ratio := visitsForType / totalVisits.

	^ Color r: 1 g: 1 - ratio b: 1 - ratio
]

{ #category : 'initialization' }
MateOptionalType >> initialize [ 

	super initialize.
	optionTypes := Set new.
	rewards := Dictionary new.
	visits := Dictionary new.
	explorationConstant := 2.
]

{ #category : 'accessing' }
MateOptionalType >> name [
	
	^ (self orderedTypes collect: #name) joinUsing: ' | '
]

{ #category : 'accessing' }
MateOptionalType >> optionFor: anInstance [

	^ self orderedTypes
		detect: [ :each | anInstance class includesBehavior: each ]
		ifNone: [ anInstance class ]
]

{ #category : 'accessing' }
MateOptionalType >> options: options [ 
	
	options do: [ :each | optionTypes addAll: (self class typesOf: each) ]
]

{ #category : 'accessing' }
MateOptionalType >> orderedTypes [

	^ (optionTypes asSortedCollection: [ :a :b | a name <= b name ]) asArray
]

{ #category : 'rendering' }
MateOptionalType >> renderShapes: totalVisits parent: parentNode [

	^ self orderedTypes collect: [ :type | | node label box color composite visitsForType |
		visitsForType := self totalVisitsFor: type.
		
		node := MateGrammarRenderNode new.
		node declaration: self.
		node label: type name.
		node totalVisits: visitsForType.
		parentNode ifNotNil: [ 
			node parent: parentNode.
			parentNode children add: node 
		].
		
		label := RSLabel new text: type name; color: Color black.
		color := self heatColorFor: type.
		
		box := RSBox new 
			extent: (label extent + (16@8));
			cornerRadius: 4;
			color: color;
			border: (visitsForType = 0
				ifTrue: [ RSBorder new color: (Color red alpha: 0.5); width: 1; dashArray: #(4 3) ]
				ifFalse: [ RSBorder new color: (Color gray: 0.6); width: 1; dashArray: #(2 2) ]).
			
		composite := RSComposite new model: node; shapes: { box . label }; yourself.
			
		composite @ (RSPopup new text: [ :n | 
			String streamContents: [ :s |
				s nextPutAll: 'Option: '; nextPutAll: n label; cr.
				s nextPutAll: 'Visits: '; print: n totalVisits.
				self totalVisits > 0 ifTrue: [
					s cr; nextPutAll: 'Share: '; 
					  print: ((n totalVisits / self totalVisits * 100) asFloat round: 1); nextPutAll: '%'
				]
			]
		]).
		composite
	]
]

{ #category : 'accessing' }
MateOptionalType >> rewards [

	^ rewards
]

{ #category : 'as yet unclassified' }
MateOptionalType >> selectAtype: context [
	
	| contextVisits differenceAtLevel |

	visits at: context key ifAbsent: [ ^ self getOne: context random ].
	
	contextVisits := visits at: context key.
	
	differenceAtLevel := self orderedTypes reject: [ :each | contextVisits includesKey: each ].
	differenceAtLevel ifNotEmpty: [ ^ differenceAtLevel first ].
	
	rewards at: context key ifAbsent: [ ^ self getOne: context random ].

	^ self getBestRewardedType: context
]

{ #category : 'as yet unclassified' }
MateOptionalType >> totalVisits [

	visits values ifEmpty: [ ^ 0 ].

	^ (visits values collect: [ :dict | dict values sum ]) sum
]

{ #category : 'rendering' }
MateOptionalType >> totalVisitsFor: type [

	| typeVisits |
	
	typeVisits := (visits collect: [ :dict | (dict at: type ifPresent: [ :t | t ] ifAbsent: [ 0 ])]).

	^ typeVisits ifEmpty: [ 0 ] ifNotEmpty: [ typeVisits sum ]
]

{ #category : 'visiting' }
MateOptionalType >> types [

	^ optionTypes
]

{ #category : 'as yet unclassified' }
MateOptionalType >> updateReward: improvement context: context from: decl [
	
	| key optionToReward |

	key := context key.
	optionToReward := self optionFor: (context parentNode edges at: decl name) instance.
	
	rewards at: key ifAbsentPut: [ Dictionary new ].
	rewards at: key at: optionToReward ifAbsentPut: [ 1 ].
	
	(rewards at: key) at: optionToReward update: [ :reward | (reward + improvement) max: 1 ].
]

{ #category : 'reward' }
MateOptionalType >> updateVisits: context selecting: selected [

	| key |
	
	key := context key.
	visits at: key ifAbsentPut: [ Dictionary new ].
	visits at: key at: selected ifAbsentPut: [ 0 ].
	
	(visits at: key) at: selected update: [ :v | v + 1 ]
]

{ #category : 'accessing' }
MateOptionalType >> visits [

	^ visits
]

{ #category : 'logical operations' }
MateOptionalType >> | aType [ 

	optionTypes addAll: (self class typesOf: aType)
]
