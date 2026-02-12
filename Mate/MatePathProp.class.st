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

{ #category : 'instance creation' }
MatePathProp >> from: object [ 
	
	^ object instVarNamed: prop 
]

{ #category : 'derivation' }
MatePathProp >> fromDerivation: derivationNode [ 

	derivationNode ifNil: [ ^ nil ].

	^ derivationNode edges at: prop ifAbsent: [ nil ]
]

{ #category : 'spec protocol' }
MatePathProp >> insert: instance at: where [ 

	| instancesToUpdate |
	
	instancesToUpdate := where isCollection ifTrue: [ where ] ifFalse: [ { where } ].
	
	instancesToUpdate do: [ :toInsert | toInsert instVarNamed: prop put: instance ]
]

{ #category : 'derivation' }
MatePathProp >> insertDerivation: instance atDerivation: aNode [ 

	| nodes |
	
	nodes := aNode isCollection ifTrue: [ aNode ] ifFalse: [ { aNode } ].
	
	nodes do: [ :node | (node edges at: prop) instance: instance ]
]

{ #category : 'accessing' }
MatePathProp >> prop: propName [

	prop := propName
]
