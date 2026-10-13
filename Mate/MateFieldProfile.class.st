Class {
	#name : 'MateFieldProfile',
	#superclass : 'Object',
	#instVars : [
		'name',
		'values',
		'observer'
	],
	#category : 'Mate-Inference',
	#package : 'Mate',
	#tag : 'Inference'
}

{ #category : 'instance creation' }
MateFieldProfile class >> name: aName values: aCollection observer: anObserver [

	^ self new setName: aName values: aCollection observer: anObserver
]

{ #category : 'testing' }
MateFieldProfile >> allNil [

	^ self nonNilValues isEmpty
]

{ #category : 'accessing' }
MateFieldProfile >> collectionClasses [

	^ (self nonNilValues collect: #class) asSet
]

{ #category : 'accessing' }
MateFieldProfile >> distinctValues [

	^ self nonNilValues asSet
]

{ #category : 'accessing' }
MateFieldProfile >> elements [

	^ self nonNilValues flatCollect: [ :each | observer elementsOf: each ]
]

{ #category : 'testing' }
MateFieldProfile >> isClassValued [

	^ self nonNilValues allSatisfy: #isBehavior
]

{ #category : 'testing' }
MateFieldProfile >> isCollectionValued [

	^ self nonNilValues allSatisfy: [ :each | observer isCollectionValue: each ]
]

{ #category : 'testing' }
MateFieldProfile >> isEnumerable [

	^ self nonNilValues allSatisfy: [ :each | each isString or: [ each isCharacter ] ]
]

{ #category : 'testing' }
MateFieldProfile >> isNumeric [

	^ self nonNilValues allSatisfy: [ :each |
		each isNumber and: [ each isFloat not or: [ each isFinite ] ] ]
]

{ #category : 'testing' }
MateFieldProfile >> isUnsupported [

	^ self nonNilValues anySatisfy: [ :each | observer isUnsupported: each ]
]

{ #category : 'accessing' }
MateFieldProfile >> max [

	^ self nonNilValues inject: self nonNilValues first into: [ :result :each | result max: each ]
]

{ #category : 'accessing' }
MateFieldProfile >> min [

	^ self nonNilValues inject: self nonNilValues first into: [ :result :each | result min: each ]
]

{ #category : 'accessing' }
MateFieldProfile >> name [

	^ name
]

{ #category : 'accessing' }
MateFieldProfile >> nilCount [

	^ values count: #isNil
]

{ #category : 'accessing' }
MateFieldProfile >> nonNilValues [

	^ values reject: #isNil
]

{ #category : 'accessing' }
MateFieldProfile >> observationCount [

	^ values size
]

{ #category : 'initialization' }
MateFieldProfile >> setName: aName values: aCollection observer: anObserver [

	name := aName.
	values := aCollection asArray.
	observer := anObserver
]

{ #category : 'accessing' }
MateFieldProfile >> sizes [

	^ self nonNilValues collect: #size
]
