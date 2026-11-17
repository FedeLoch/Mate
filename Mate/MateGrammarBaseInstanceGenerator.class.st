Class {
	#name : 'MateGrammarBaseInstanceGenerator',
	#superclass : 'Object',
	#category : 'Mate-Generation',
	#package : 'Mate',
	#tag : 'Generation'
}

{ #category : 'visiting' }
MateGrammarBaseInstanceGenerator >> existingInstanceFor: decl random: aRandom closing: isClosing [

	^ nil
]

{ #category : 'visiting' }
MateGrammarBaseInstanceGenerator >> fill: anInstance from: node [

	node edges keysAndValuesDo: [ :edgeName :edge |
		anInstance instVarNamed: edgeName put: edge instance ].

	^ anInstance
]

{ #category : 'visiting' }
MateGrammarBaseInstanceGenerator >> newInstanceFor: decl [

	^ decl type mateNew
]

{ #category : 'visiting' }
MateGrammarBaseInstanceGenerator >> objectInstance: node constraint: constraint [

	^ self fill: (self newInstanceFor: node declaration) from: node
]

{ #category : 'cleaning' }
MateGrammarBaseInstanceGenerator >> reset [
]
