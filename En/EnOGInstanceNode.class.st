Class {
	#name : 'EnOGInstanceNode',
	#superclass : 'EnOGDerivationNode',
	#category : 'En-Parsing',
	#package : 'En',
	#tag : 'Parsing'
}

{ #category : 'as yet unclassified' }
EnOGInstanceNode >> getInstance [

	^ edges keys inject: declaration type new into: [ :inst :edgeName |
		inst instVarNamed: edgeName put: (edges at: edgeName) instantiate.
		inst
	]
]

{ #category : 'as yet unclassified' }
EnOGInstanceNode >> recursiveBackPropagate: improvement from: aContext seen: set [
	"Instance nodes propagate to their edges (instance variable values)"

	(set includes: self) ifTrue: [ ^ self ].
	set add: self.
	
	"Update this declaration's reward"
	declaration updateReward: improvement context: aContext.
	
	"Propagate to all child edges (instance variable values)"
	edges valuesDo: [ :childNode |
		childNode recursiveBackPropagate: improvement from: aContext seen: set.
	].
]
