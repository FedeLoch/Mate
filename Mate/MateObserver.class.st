Class {
	#name : 'MateObserver',
	#superclass : 'Object',
	#instVars : [
		'instancesByClass',
		'visited',
		'maxDepth',
		'roots',
		'depths'
	],
	#category : 'Mate-Inference',
	#package : 'Mate',
	#tag : 'Inference'
}

{ #category : 'accessing' }
MateObserver >> collectionClasses [

	^ { Array. OrderedCollection. Set. IdentitySet. Bag }
]

{ #category : 'depths' }
MateObserver >> computeDepths [

	| queue |

	depths := IdentityDictionary new.
	queue := OrderedCollection new.

	roots do: [ :each |
		(depths includesKey: each) ifFalse: [
			depths at: each put: 0.
			queue add: each ] ].

	[ queue isEmpty ] whileFalse: [ | current depth |
		current := queue removeFirst.
		depth := depths at: current.
		(self neighboursOf: current) do: [ :each |
			(depths includesKey: each) ifFalse: [
				depths at: each put: depth + 1.
				queue add: each ] ] ]
]

{ #category : 'depths' }
MateObserver >> depthOf: anObject [

	depths ifNil: [ self computeDepths ].
	^ depths at: anObject ifAbsent: [ SmallInteger maxVal ]
]

{ #category : 'accessing' }
MateObserver >> elementsOf: elements [

	^ elements asArray
]

{ #category : 'initialization' }
MateObserver >> initialize [

	super initialize.
	instancesByClass := Dictionary new.
	visited := IdentitySet new.
	roots := OrderedCollection new
]

{ #category : 'accessing' }
MateObserver >> instancesOf: aClass [

	^ instancesByClass at: aClass ifAbsent: [ #() ]
]

{ #category : 'testing' }
MateObserver >> isCollectionValue: anObject [

	^ anObject notNil and: [ self collectionClasses includes: anObject class ]
]

{ #category : 'testing' }
MateObserver >> isLeaf: object [

	object ifNil: [ ^ true ].
	object isBehavior ifTrue: [ ^ true ].

	^ self leafClasses anySatisfy: [ :each | object isKindOf: each ]
]

{ #category : 'testing' }
MateObserver >> isObserved: anObject [

	^ anObject notNil and: [ (visited includes: anObject) and: [ (self isCollectionValue: anObject) not ] ]
]

{ #category : 'testing' }
MateObserver >> isUnsupported: anObject [

	^ self unsupportedClasses anySatisfy: [ :each |
		  anObject isKindOf: each
	]
]

{ #category : 'accessing' }
MateObserver >> leafClasses [

	^ { Number . String . Character . Boolean . Point . Color }
]

{ #category : 'accessing' }
MateObserver >> maxDepth: anInteger [

	maxDepth := anInteger
]

{ #category : 'observing' }
MateObserver >> observe: anObject [

	depths := nil.
	(roots identityIncludes: anObject) ifFalse: [ roots add: anObject ].
	self observe: anObject depth: 0
]

{ #category : 'observing' }
MateObserver >> observe: anObject depth: depth [

	(maxDepth notNil and: [ depth > maxDepth ]) ifTrue: [ ^ self ].
	(self isLeaf: anObject) ifTrue: [ ^ self ].
	(self isUnsupported: anObject) ifTrue: [ ^ self ].
	(visited includes: anObject) ifTrue: [ ^ self ].

	visited add: anObject.

	(self isCollectionValue: anObject) ifTrue: [
		(self elementsOf: anObject) do: [ :each | self observe: each depth: depth + 1 ].
		^ self ].

	(instancesByClass at: anObject class ifAbsentPut: [ OrderedCollection new ]) add: anObject.

	anObject class allInstVarNames do: [ :name |
		self observe: (anObject instVarNamed: name) depth: depth + 1 ]
]

{ #category : 'depths' }
MateObserver >> neighboursOf: anObject [

	| values |

	values := (self isCollectionValue: anObject)
		ifTrue: [ self elementsOf: anObject ]
		ifFalse: [ anObject class allInstVarNames collect: [ :each | anObject instVarNamed: each ] ].

	^ values select: [ :each | each notNil and: [ visited includes: each ] ]
]

{ #category : 'observing' }
MateObserver >> observeAll: aCollection [

	aCollection do: [ :each | self observe: each ]
]

{ #category : 'accessing' }
MateObserver >> observedClasses [

	^ (instancesByClass keys asSortedCollection: [ :a :b | a name <= b name ]) asArray
]

{ #category : 'accessing' }
MateObserver >> unsupportedClasses [

	^ { BlockClosure. CompiledCode. Context. Process. SystemDictionary. Semaphore. Mutex }
]
