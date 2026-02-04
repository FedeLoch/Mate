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
	
	1 halt.

	self assert: (obj class) equals: BlElement.
]

{ #category : 'tests' }
MateBlocGrammarTest >> testGrammarCanGenerateABlTriangleGeometry [

	| gen |
	
	gen := grammar gen: BlTriangleGeometry.

	self assert: (gen class) equals: BlTriangleGeometry.
	self assert: ({ #top . #right . #left . #bottom } includes: (gen orientation))
]
