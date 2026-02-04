Class {
	#name : 'MateHandMadeGrammarTest',
	#superclass : 'TestCase',
	#instVars : [
		'grammar'
	],
	#category : 'Mate-Grammar Tests',
	#package : 'Mate',
	#tag : 'Grammar Tests'
}

{ #category : 'running' }
MateHandMadeGrammarTest >> newGrammar [

	self subclassResponsibility 
]

{ #category : 'running' }
MateHandMadeGrammarTest >> setUp [
	super setUp.
	grammar := self newGrammar
]
