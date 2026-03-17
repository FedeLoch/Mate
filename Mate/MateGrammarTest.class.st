Class {
	#name : 'MateGrammarTest',
	#superclass : 'TestCase',
	#instVars : [
		'grammar'
	],
	#category : 'Mate-Grammar Tests',
	#package : 'Mate',
	#tag : 'Grammar Tests'
}

{ #category : 'running' }
MateGrammarTest >> newGrammar [

	self subclassResponsibility 
]

{ #category : 'running' }
MateGrammarTest >> setUp [

	super setUp.
	grammar := self newGrammar
]
