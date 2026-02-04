Class {
	#name : 'EnBlocGrammarTest',
	#superclass : 'EnHandMadeGrammarTest',
	#category : 'En-Grammar Tests',
	#package : 'En',
	#tag : 'Grammar Tests'
}

{ #category : 'running' }
EnBlocGrammarTest >> newGrammar [

	^ EnBlocGrammar new.
]

{ #category : 'tests' }
EnBlocGrammarTest >> testGrammarCanGenerateABlElement [

	| obj |
	
	obj := grammar gen: BlElement.

	self assert: (obj class) equals: BlElement.
]
