Class {
	#name : 'MateConstraint',
	#superclass : 'Object',
	#instVars : [
		'universe'
	],
	#category : 'Mate-Constraints',
	#package : 'Mate',
	#tag : 'Constraints'
}

{ #category : 'comparing' }
MateConstraint >> = anObject [

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	
	^ universe = anObject universe
]

{ #category : 'comparing' }
MateConstraint >> hash [

	^ universe hash
]

{ #category : 'comparing' }
MateConstraint class >> between: aValue and: otherValue [
	
	^ self new universe: (aValue to: otherValue)
]

{ #category : 'comparing' }
MateConstraint class >> greaterThan: aValue [

	^ self new universe: (aValue to: aValue class maxVal)

]

{ #category : 'as yet unclassified' }
MateConstraint class >> oneOf: array [

	^ self new universe: array
]

{ #category : 'as yet unclassified' }
MateConstraint >> universe [ 

	^ universe
]

{ #category : 'as yet unclassified' }
MateConstraint >> universe: aUniverse [ 

	universe := aUniverse
]
