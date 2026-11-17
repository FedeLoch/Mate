Class {
	#name : 'MateGrammarBaseInstanceGenerator',
	#superclass : 'Object',
	#category : 'Mate-Generation',
	#package : 'Mate',
	#tag : 'Generation'
}

{ #category : 'visiting' }
MateGrammarBaseInstanceGenerator >> objectInstance: node constraint: constraint [

	^ node edges keys inject: node declaration type mateNew into: [ :inst :edgeName |
		inst instVarNamed: edgeName put: (node edges at: edgeName) instance.
		inst
	]
]

{ #category : 'cleaning' }
MateGrammarBaseInstanceGenerator >> reset [

	"do nothing"
]
