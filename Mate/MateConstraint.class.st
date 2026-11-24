Class {
	#name : 'MateConstraint',
	#superclass : 'Object',
	#instVars : [
		'min',
		'max',
		'options',
		'pattern',
		'excluded'
	],
	#category : 'Mate-Constraints',
	#package : 'Mate',
	#tag : 'Constraints'
}

{ #category : 'instance creation' }
MateConstraint class >> atLeast: aValue [

	^ self new atLeast: aValue
]

{ #category : 'instance creation' }
MateConstraint class >> atMost: aValue [

	^ self new atMost: aValue
]

{ #category : 'instance creation' }
MateConstraint class >> between: aValue and: otherValue [

	^ self new atLeast: aValue; atMost: otherValue; yourself
]

{ #category : 'instance creation' }
MateConstraint class >> greaterThan: aValue [

	^ self new greaterThan: aValue
]

{ #category : 'instance creation' }
MateConstraint class >> lessThan: aValue [

	^ self new lessThan: aValue
]

{ #category : 'instance creation' }
MateConstraint class >> matching: aString [

	^ self new matching: aString
]

{ #category : 'instance creation' }
MateConstraint class >> oneOf: aCollection [

	^ self new options: aCollection
]

{ #category : 'comparing' }
MateConstraint >> = anObject [

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].

	^ min = anObject min and: [
		  max = anObject max and: [
			  options = anObject options and: [
				  pattern = anObject pattern and: [ excluded = anObject excluded ] ] ] ]
]

{ #category : 'accessing' }
MateConstraint >> atLeast: aValue [

	min := aValue
]

{ #category : 'accessing' }
MateConstraint >> atMost: aValue [

	max := aValue
]

{ #category : 'accessing' }
MateConstraint >> greaterThan: aValue [

	min := aValue isInteger
		ifTrue: [ aValue + 1 ]
		ifFalse: [ aValue asFloat successor ]
]

{ #category : 'testing' }
MateConstraint >> hasOptions [

	^ options notNil
]

{ #category : 'comparing' }
MateConstraint >> hash [

	^ (((min hash bitXor: max hash) bitXor: options hash) bitXor: pattern hash) bitXor: excluded hash
]

{ #category : 'testing' }
MateConstraint >> includes: aValue [

	(excluded notNil and: [ excluded includes: aValue ]) ifTrue: [ ^ false ].
	options ifNotNil: [ ^ options includes: aValue ].
	pattern ifNotNil: [ (aValue isString and: [ aValue matchesRegex: pattern ]) ifFalse: [ ^ false ] ].
	(min isNil and: [ max isNil ]) ifTrue: [ ^ true ].
	aValue isNumber ifFalse: [ ^ false ].
	(min notNil and: [ (aValue >= min) not ]) ifTrue: [ ^ false ].
	(max notNil and: [ (aValue <= max) not ]) ifTrue: [ ^ false ].
	^ true
]

{ #category : 'testing' }
MateConstraint >> isUnconstrained [

	^ min isNil and: [ max isNil and: [ options isNil and: [ pattern isNil and: [ excluded isNil ] ] ] ]
]

{ #category : 'accessing' }
MateConstraint >> lessThan: aValue [

	max := aValue isInteger
		ifTrue: [ aValue - 1 ]
		ifFalse: [ aValue asFloat predecessor ]
]

{ #category : 'accessing' }
MateConstraint >> max [

	^ max
]

{ #category : 'accessing' }
MateConstraint >> min [

	^ min
]

{ #category : 'accessing' }
MateConstraint >> options [

	^ options
]

{ #category : 'accessing' }
MateConstraint >> options: aCollection [

	options := aCollection asArray
]

{ #category : 'printing' }
MateConstraint >> printOn: aStream [

	aStream nextPutAll: 'MateConstraint('.
	options ifNotNil: [ aStream nextPutAll: 'in: '; print: options ].
	pattern ifNotNil: [ aStream nextPutAll: ' matching: '; print: pattern ].
	excluded ifNotNil: [ aStream nextPutAll: ' except: '; print: excluded ].
	min ifNotNil: [ aStream nextPutAll: ' min: '; print: min ].
	max ifNotNil: [ aStream nextPutAll: ' max: '; print: max ].
	aStream nextPut: $)
]

{ #category : 'accessing' }
MateConstraint >> except: aCollection [
	"Values that the constrained value must never take, even when they match the rest of the constraint."

	excluded := aCollection asArray
]

{ #category : 'accessing' }
MateConstraint >> excluded [

	^ excluded
]

{ #category : 'testing' }
MateConstraint >> hasPattern [

	^ pattern notNil
]

{ #category : 'accessing' }
MateConstraint >> matching: aString [
	"A regular expression that the whole string or symbol must match."

	pattern := aString
]

{ #category : 'accessing' }
MateConstraint >> pattern [

	^ pattern
]
