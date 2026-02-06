Class {
	#name : 'MateParserTest',
	#superclass : 'TestCase',
	#instVars : [
		'grammar',
		'parser'
	],
	#category : 'Mate-Parsing Tests',
	#package : 'Mate',
	#tag : 'Parsing Tests'
}

{ #category : 'running' }
MateParserTest >> doTest: obj [

	| derivation |
	
	derivation := parser parse: obj.
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
	grammar := self newGrammar.
	parser := grammar parser
]
