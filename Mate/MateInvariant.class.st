Class {
	#name : 'MateInvariant',
	#superclass : 'Object',
	#instVars : [
		'left',
		'operator',
		'right'
	],
	#category : 'Mate-Constraints',
	#package : 'Mate',
	#tag : 'Constraints'
}

{ #category : 'instance creation' }
MateInvariant class >> left: leftField operator: anOperator right: rightField [

	(#( '<' '<=' '=' ) includes: anOperator) ifTrue: [
		^ self new setLeft: leftField operator: anOperator right: rightField ].
	anOperator = '>' ifTrue: [ ^ self new setLeft: rightField operator: '<' right: leftField ].
	anOperator = '>=' ifTrue: [ ^ self new setLeft: rightField operator: '<=' right: leftField ].

	^ self error: 'Unknown invariant operator ', anOperator
]

{ #category : 'comparing' }
MateInvariant >> = anObject [

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].

	^ left = anObject left and: [ operator = anObject operator and: [ right = anObject right ] ]
]

{ #category : 'testing' }
MateInvariant >> accepts: leftValue with: rightValue [

	(leftValue isNil or: [ rightValue isNil ]) ifTrue: [ ^ true ].
	(leftValue isNumber and: [ rightValue isNumber ]) ifFalse: [ ^ false ].

	operator = '<' ifTrue: [ ^ leftValue < rightValue ].
	operator = '<=' ifTrue: [ ^ leftValue <= rightValue ].
	^ leftValue = rightValue
]

{ #category : 'comparing' }
MateInvariant >> hash [

	^ (left hash bitXor: operator hash) bitXor: right hash
]

{ #category : 'testing' }
MateInvariant >> holdsFor: anObject [

	^ self accepts: (anObject instVarNamed: left) with: (anObject instVarNamed: right)
]

{ #category : 'accessing' }
MateInvariant >> left [

	^ left
]

{ #category : 'accessing' }
MateInvariant >> operator [

	^ operator
]

{ #category : 'printing' }
MateInvariant >> printOn: aStream [

	aStream nextPutAll: left; space; nextPutAll: operator; space; nextPutAll: right
]

{ #category : 'accessing' }
MateInvariant >> right [

	^ right
]

{ #category : 'initialization' }
MateInvariant >> setLeft: leftField operator: anOperator right: rightField [

	left := leftField.
	operator := anOperator.
	right := rightField
]
