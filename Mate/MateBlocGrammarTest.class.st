Class {
	#name : 'MateBlocGrammarTest',
	#superclass : 'MateHandMadeGrammarTest',
	#category : 'Mate-Grammar Tests',
	#package : 'Mate',
	#tag : 'Grammar Tests'
}

{ #category : 'running' }
MateBlocGrammarTest >> newGrammar [

	^ MateBlocGrammar new.
]

{ #category : 'tests' }
MateBlocGrammarTest >> testGrammarCanGenerateABlElement [

	| obj |
	
	obj := grammar gen: BlElement.

	self assert: (obj class) equals: BlElement.
]
