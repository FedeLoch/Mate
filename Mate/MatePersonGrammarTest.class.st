Class {
	#name : 'MatePersonGrammarTest',
	#superclass : 'MateHandMadeGrammarTest',
	#category : 'Mate-Grammar Tests',
	#package : 'Mate',
	#tag : 'Grammar Tests'
}

{ #category : 'running' }
MatePersonGrammarTest >> newGrammar [

	^ MatePersonGrammar new.
]

{ #category : 'tests' }
MatePersonGrammarTest >> testGrammarCanGenerateAPerson [

	self assert: (grammar gen: Person) class equals: Person.
	self assert: (grammar gen: Person) age class equals: SmallInteger
]

{ #category : 'tests' }
MatePersonGrammarTest >> testGrammarCanGenerateAnAge [

	self assert: (grammar gen: Age) class equals: Age.
	self assert: (grammar gen: Age) value class equals: SmallInteger
]
