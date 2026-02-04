Class {
	#name : 'EnOGDerivationNode',
	#superclass : 'Object',
	#instVars : [
		'declaration',
		'edges',
		'context',
		'instance'
	],
	#category : 'En-Parsing',
	#package : 'En',
	#tag : 'Parsing'
}

{ #category : 'initialization' }
EnOGDerivationNode >> addEdge: anEdge at: key [

	edges at: key put: anEdge
]

{ #category : 'accessing' }
EnOGDerivationNode >> context [

	^ context
]

{ #category : 'accessing' }
EnOGDerivationNode >> context: aContext [

	context := aContext 
]

{ #category : 'accessing' }
EnOGDerivationNode >> declaration [

	^ declaration
]

{ #category : 'accessing' }
EnOGDerivationNode >> declaration: anEnInstanceDeclaration [ 

	declaration := anEnInstanceDeclaration
]

{ #category : 'accessing' }
EnOGDerivationNode >> edges [

	^ edges
]

{ #category : 'initialization' }
EnOGDerivationNode >> initialize [ 
	
	super initialize.
	edges := Dictionary new.
]

{ #category : 'as yet unclassified' }
EnOGDerivationNode >> instance [

	^ instance
]

{ #category : 'accessing' }
EnOGDerivationNode >> instance: anInstance [

	instance := anInstance 
]

{ #category : 'as yet unclassified' }
EnOGDerivationNode >> recursiveBackPropagate: improvement from: aContext seen: set [
	"Update this node's declaration and recursively propagate to children.
	 The 'seen' set prevents infinite loops in cyclic graphs."

	(set includes: self) ifTrue: [ ^ self ].
	set add: self.
	
	"Update this declaration's reward"
	declaration updateReward: improvement context: aContext.
	
	"Propagate to all child edges"
	edges valuesDo: [ :childNode |
		childNode recursiveBackPropagate: improvement from: aContext seen: set.
	].
]
