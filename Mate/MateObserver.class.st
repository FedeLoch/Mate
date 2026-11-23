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

{ #category : 'testing' }
MateObserver >> covers: aValue [

	aValue ifNil: [ ^ true ].
	(self isLeaf: aValue) ifTrue: [ ^ true ].
	(self isUnsupported: aValue) ifTrue: [ ^ true ].

	(self isCollectionValue: aValue) ifTrue: [
		^ (self elementsOf: aValue) allSatisfy: [ :each | self covers: each ] ].

	^ (self instancesOf: aValue class) notEmpty
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

{ #category : 'depths' }
MateObserver >> neighboursOf: anObject [

	^ (self valuesOf: anObject) select: [ :each | each notNil and: [ visited includes: each ] ]
]

{ #category : 'observing' }
MateObserver >> observe: anObject [

	self observeAll: { anObject }
]

{ #category : 'observing' }
MateObserver >> observeAll: aCollection [

	| queue |

	depths := nil.
	queue := OrderedCollection new.

	aCollection do: [ :each |
		(roots identityIncludes: each) ifFalse: [ roots add: each ].
		queue add: each -> 0 ].

	[ queue isEmpty ] whileFalse: [ | entry object depth |
		entry := queue removeFirst.
		object := entry key.
		depth := entry value.
		(self shouldVisit: object at: depth) ifTrue: [
			visited add: object.
			(self isCollectionValue: object) ifFalse: [
				(instancesByClass at: object class ifAbsentPut: [ OrderedCollection new ]) add: object ].
			(self valuesOf: object) do: [ :each | queue add: each -> (depth + 1) ] ] ]
]

{ #category : 'accessing' }
MateObserver >> observedClasses [

	^ (instancesByClass keys asSortedCollection: [ :a :b | a name <= b name ]) asArray
]

{ #category : 'observing' }
MateObserver >> shouldVisit: anObject at: depth [

	(maxDepth notNil and: [ depth > maxDepth ]) ifTrue: [ ^ false ].
	(self isLeaf: anObject) ifTrue: [ ^ false ].
	(self isUnsupported: anObject) ifTrue: [ ^ false ].

	^ (visited includes: anObject) not
]

{ #category : 'accessing' }
MateObserver >> unsupportedClasses [

	^ { BlockClosure. CompiledCode. Context. Process. SystemDictionary. Semaphore. Mutex }
]

{ #category : 'observing' }
MateObserver >> valuesOf: anObject [

	^ (self isCollectionValue: anObject)
		ifTrue: [ self elementsOf: anObject ]
		ifFalse: [ anObject class allInstVarNames collect: [ :each | anObject instVarNamed: each ] ]
]
