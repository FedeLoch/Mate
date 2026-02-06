Class {
	#name : 'MateParserTest',
	#superclass : 'TestCase',
	#instVars : [
		'grammar'
	],
	#category : 'Mate-Parsing Tests',
	#package : 'Mate',
	#tag : 'Parsing Tests'
}

{ #category : 'running' }
MateParserTest >> doTest: obj [

	| derivation |
	
	derivation := grammar parser parse: obj.
	self assert: derivation instance equals: obj.
	1 halt.
]

{ #category : 'running' }
MateParserTest >> newGrammar [

	self subclassResponsibility 
]

{ #category : 'running' }
MateParserTest >> setUp [
	super setUp.
	grammar := self newGrammar
]
