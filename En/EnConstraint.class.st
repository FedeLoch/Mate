Class {
	#name : 'EnConstraint',
	#superclass : 'Object',
	#instVars : [
		'universe'
	],
	#category : 'En-Constraints',
	#package : 'En',
	#tag : 'Constraints'
}

{ #category : 'comparing' }
EnConstraint class >> between: aValue and: otherValue [
	
	^ self new universe: (aValue to: otherValue)
]

{ #category : 'comparing' }
EnConstraint class >> greaterThan: aValue [

	^ self new universe: (aValue to: aValue class maxVal)

]

{ #category : 'as yet unclassified' }
EnConstraint class >> oneOf: array [

	^ self new universe: array
]

{ #category : 'as yet unclassified' }
EnConstraint >> universe [ 

	^ universe
]

{ #category : 'as yet unclassified' }
EnConstraint >> universe: aUniverse [ 

	universe := aUniverse
]
