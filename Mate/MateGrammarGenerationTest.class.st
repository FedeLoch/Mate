Class {
	#name : 'MateGrammarGenerationTest',
	#superclass : 'TestCase',
	#instVars : [
		'grammar'
	],
	#category : 'Mate-Generation Tests',
	#package : 'Mate',
	#tag : 'Generation Tests'
}

{ #category : 'running' }
MateGrammarGenerationTest >> newGrammar [

	self subclassResponsibility 
]

{ #category : 'running' }
MateGrammarGenerationTest >> setUp [
	super setUp.
	grammar := self newGrammar
]
