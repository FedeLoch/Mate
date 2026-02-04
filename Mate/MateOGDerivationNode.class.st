Class {
	#name : 'MateOGDerivationNode',
	#superclass : 'Object',
	#instVars : [
		'declaration',
		'edges',
		'context',
		'instance'
	],
	#category : 'Mate-Parsing',
	#package : 'Mate',
	#tag : 'Parsing'
}

{ #category : 'initialization' }
MateOGDerivationNode >> addEdge: anEdge at: key [

	edges at: key put: anEdge
]

{ #category : 'accessing' }
MateOGDerivationNode >> context [

	^ context
]

{ #category : 'accessing' }
MateOGDerivationNode >> context: aContext [

	context := aContext 
]

{ #category : 'accessing' }
MateOGDerivationNode >> declaration [

	^ declaration
]

{ #category : 'accessing' }
MateOGDerivationNode >> declaration: anEnInstanceDeclaration [ 

	declaration := anEnInstanceDeclaration
]

{ #category : 'accessing' }
MateOGDerivationNode >> edges [

	^ edges
]

{ #category : 'initialization' }
MateOGDerivationNode >> initialize [ 
	
	super initialize.
	edges := Dictionary new.
]

{ #category : 'as yet unclassified' }
MateOGDerivationNode >> instance [

	^ instance
]

{ #category : 'accessing' }
MateOGDerivationNode >> instance: anInstance [

	instance := anInstance 
]

{ #category : 'as yet unclassified' }
MateOGDerivationNode >> recursiveBackPropagate: improvement from: aContext seen: set [
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
