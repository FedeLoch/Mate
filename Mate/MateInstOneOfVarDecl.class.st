Class {
	#name : 'MateInstOneOfVarDecl',
	#superclass : 'MateInstVarDecl',
	#instVars : [
		'options'
	],
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'as yet unclassified' }
MateInstOneOfVarDecl >> getOne: aMateContext [ 

	"TODO: use the rewards here"
	^ options atRandom.
]

{ #category : 'accessing' }
MateInstOneOfVarDecl >> options [

	^ options
]

{ #category : 'accessing' }
MateInstOneOfVarDecl >> options: someOptions [

	options := someOptions
]

{ #category : 'as yet unclassified' }
MateInstOneOfVarDecl >> updateReward: improvement context: context [

	1 halt.
]

{ #category : 'visiting' }
MateInstOneOfVarDecl >> visiting: aVisitor from: context constraint: aConstraint [

	^ aVisitor visitOneOfDecl: self from: context 
]
