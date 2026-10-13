Class {
	#name : 'MateObserver',
	#superclass : 'Object',
	#instVars : [
		'instancesByClass',
		'visited',
		'maxDepth'
	],
	#category : 'Mate-Inference',
	#package : 'Mate',
	#tag : 'Inference'
}

{ #category : 'accessing' }
MateObserver >> collectionClasses [

	^ { Array. OrderedCollection. Set. IdentitySet. Bag }
]

{ #category : 'accessing' }
MateObserver >> elementsOf: aCollection [

	^ aCollection asArray
]

{ #category : 'initialization' }
MateObserver >> initialize [

	super initialize.
	instancesByClass := Dictionary new.
	visited := IdentitySet new
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
MateObserver >> isLeaf: anObject [

	anObject ifNil: [ ^ true ].
	anObject isBehavior ifTrue: [ ^ true ].

	^ self leafClasses anySatisfy: [ :each | anObject isKindOf: each ]
]

{ #category : 'testing' }
MateObserver >> isObserved: anObject [

	^ anObject notNil and: [ (instancesByClass at: anObject class ifAbsent: [ #() ]) identityIncludes: anObject ]
]

{ #category : 'testing' }
MateObserver >> isUnsupported: anObject [

	^ self unsupportedClasses anySatisfy: [ :each | anObject isKindOf: each ]
]

{ #category : 'accessing' }
MateObserver >> leafClasses [

	^ { Number. String. Character. Boolean. Point. Color }
]

{ #category : 'accessing' }
MateObserver >> maxDepth: anInteger [

	maxDepth := anInteger
]

{ #category : 'observing' }
MateObserver >> observe: anObject [

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
