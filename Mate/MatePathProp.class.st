Class {
	#name : 'MatePathProp',
	#superclass : 'Object',
	#instVars : [
		'prop'
	],
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'instance creation' }
MatePathProp class >> from: propName [

	^ self new prop: propName
]

{ #category : 'comparing' }
MatePathProp >> = anObject [

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].

	^ prop = anObject prop
]

{ #category : 'instance creation' }
MatePathProp >> from: object [ 
	
	^ object instVarNamed: prop 
]

{ #category : 'derivation' }
MatePathProp >> fromDerivation: derivationNode [ 

	derivationNode ifNil: [ ^ nil ].

	^ derivationNode edges at: prop ifAbsent: [ nil ]
]

{ #category : 'comparing' }
MatePathProp >> hash [

	^ self class hash bitXor: prop hash
]

{ #category : 'testing' }
MatePathProp >> holds: instance in: targets [

	^ (self ownersIn: targets) allSatisfy: [ :owner | (owner instVarNamed: prop) == instance ]
]

{ #category : 'spec protocol' }
MatePathProp >> insert: instance into: targets [ 

	(self ownersIn: targets) do: [ :owner | owner instVarNamed: prop put: instance ]
]

{ #category : 'derivation' }
MatePathProp >> insertDerivation: instance atDerivation: aNode [ 

	| nodes |
	
	nodes := aNode isCollection ifTrue: [ aNode ] ifFalse: [ { aNode } ].
	
	nodes do: [ :node | (node edges at: prop) instance: instance ]
]

{ #category : 'testing' }
MatePathProp >> isEach [

	^ false
]

{ #category : 'accessing' }
MatePathProp >> ownersIn: targets [

	^ targets reject: #isNil
]

{ #category : 'accessing' }
MatePathProp >> prop [

	^ prop
]

{ #category : 'accessing' }
MatePathProp >> prop: propName [

	prop := propName
]

{ #category : 'accessing' }
MatePathProp >> valuesFrom: objects [

	^ (self ownersIn: objects) collect: [ :owner | owner instVarNamed: prop ]
]
