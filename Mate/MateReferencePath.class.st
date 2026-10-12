Class {
	#name : 'MateReferencePath',
	#superclass : 'Object',
	#instVars : [
		'path'
	],
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'instance creation' }
MateReferencePath class >> new: path [

	^ self new path: path
]

{ #category : 'comparing' }
MateReferencePath >> = anObject [

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].

	^ path asArray = anObject path asArray
]

{ #category : 'comparing' }
MateReferencePath >> hash [

	^ path asArray hash
]

{ #category : 'as yet unclassified' }
MateReferencePath >> insertReference: instance [ 

	path last insert: instance into: (self targetsFrom: instance)
]

{ #category : 'testing' }
MateReferencePath >> isSatisfiedBy: instance [

	^ path last holds: instance in: (self targetsFrom: instance)
]

{ #category : 'accessing' }
MateReferencePath >> targetsFrom: instance [

	^ path allButLast inject: { instance } into: [ :objects :prop | prop valuesFrom: objects ]
]

{ #category : 'accessing' }
MateReferencePath >> path [

	^ path
]

{ #category : 'accessing' }
MateReferencePath >> path: aPath [ 

	path := aPath
]

{ #category : 'derivation' }
MateReferencePath >> updateDerivation: derivationNode withInstance: instance [ 

	| current |

	current := path allButLast inject: derivationNode into: [ :inst :prop | prop fromDerivation: inst ].
	
	current ifNil: [ ^ nil ].
	
	path last insertDerivation: instance atDerivation: current
]
