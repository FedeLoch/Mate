Class {
	#name : 'MateRandomExistingInstanceGenerator',
	#superclass : 'MateGrammarBaseInstanceGenerator',
	#instVars : [
		'instances',
		'selectionExistingProbability'
	],
	#category : 'Mate-Generation',
	#package : 'Mate',
	#tag : 'Generation'
}

{ #category : 'initialization' }
MateRandomExistingInstanceGenerator >> initialize [

	super initialize.
	instances := Dictionary new.
	selectionExistingProbability := 0.5.
]

{ #category : 'visiting' }
MateRandomExistingInstanceGenerator >> objectInstance: node constraint: constraint [

	| type obj |
	
	type := node declaration type.

	(self shouldSelectAnExistant: type)  ifTrue: [
		^ (instances at: type) atRandom.
	].

	obj := type mateNew.
	instances at: type ifPresent: [
		(instances at: type) add: obj ] ifAbsentPut: [
		OrderedCollection newFrom: { obj }
	].
	
	^ node edges keys inject: obj into: [ :inst :edgeName |
		inst instVarNamed: edgeName put: (node edges at: edgeName) instance.
		inst
	]
]

{ #category : 'initialization' }
MateRandomExistingInstanceGenerator >> reset [

	instances := Dictionary new.
]

{ #category : 'accessing' }
MateRandomExistingInstanceGenerator >> selectionExistingProbability [

	^ selectionExistingProbability
]

{ #category : 'accessing' }
MateRandomExistingInstanceGenerator >> selectionExistingProbability: prob [

	selectionExistingProbability := prob
]

{ #category : 'visiting' }
MateRandomExistingInstanceGenerator >> shouldSelectAnExistant: type [

	(instances includesKey: type) ifFalse: [ ^ false ].
	

	^ ((0 to: 100) atRandom) <= (selectionExistingProbability * 100)
]
