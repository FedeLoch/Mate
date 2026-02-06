Class {
	#name : 'PersonParserTest',
	#superclass : 'MateParserTest',
	#category : 'Mate-Parsing Tests',
	#package : 'Mate',
	#tag : 'Parsing Tests'
}

{ #category : 'tests' }
PersonParserTest >> newGrammar [

	^ MatePersonGrammar new
]

{ #category : 'tests' }
PersonParserTest >> testGivenAPersonItCanGiveTheGrammarDerivation [

	self doTest: (Person new age: (Age new value: 42))
]

{ #category : 'tests' }
PersonParserTest >> testGivenAnAgeItCanGiveTheGrammarDerivation [

	self doTest: (Age new value: 42)
]

{ #category : 'tests' }
PersonParserTest >> testParseInvalidClass [

	self should: [ parser parse: Player new ] raise: Error
]

{ #category : 'tests' }
PersonParserTest >> testParseSimplePerson [

	| person derivation |

	person := Person new age: (Age new value: 42).
	
	derivation := parser parse: person.
	self assert: derivation class equals: MateOGInstanceNode.
	self assert: derivation declaration type equals: Person.
	self assert: derivation instance equals: person.
	
	self assert: derivation edges size equals: 1.
	self assert: (derivation edges includesKey: 'age').
	
	derivation := derivation edges at: 'age'.
	self assert: derivation class equals: MateOGInstanceNode. 
	self assert: derivation declaration type equals: Age.
	self assert: derivation instance value equals: 42.
	
	derivation := derivation edges at: 'value'.
	self assert: derivation class equals: MateOGBuiltInNode.
	self assert: derivation instance equals: 42.
]
