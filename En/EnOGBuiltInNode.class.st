Class {
	#name : 'EnOGBuiltInNode',
	#superclass : 'EnOGDerivationNode',
	#instVars : [
		'constraint'
	],
	#category : 'En-Parsing',
	#package : 'En',
	#tag : 'Parsing'
}

{ #category : 'accessing' }
EnOGBuiltInNode >> constraint [

	^ constraint
]

{ #category : 'accessing' }
EnOGBuiltInNode >> constraint: aConstraint [

	constraint := aConstraint
]

{ #category : 'as yet unclassified' }
EnOGBuiltInNode >> getInstance [
	
	^ declaration generator generateWithConstraint: constraint
]

{ #category : 'as yet unclassified' }
EnOGBuiltInNode >> recursiveBackPropagate: improvement from: aContext seen: set [

	"Leaf node - just update my declaration's reward"
	(set includes: self) ifTrue: [ ^ self ].
	set add: self.
	
	declaration updateReward: improvement context: aContext.
]
