Class {
	#name : 'MateHandMadePersonGrammarTest',
	#superclass : 'MateHandMadeGrammarTest',
	#category : 'Mate-Generation Tests',
	#package : 'Mate',
	#tag : 'Generation Tests'
}

{ #category : 'running' }
MateHandMadePersonGrammarTest >> newGrammar [

	^ MatePersonGrammar new.
]

{ #category : 'tests' }
MateHandMadePersonGrammarTest >> testGrammarCanGenerateAPerson [

	self assert: (grammar gen: MatePerson) class equals: MatePerson.
	self assert: (grammar gen: MatePerson) age class equals: SmallInteger
]

{ #category : 'tests' }
MateHandMadePersonGrammarTest >> testGrammarCanGenerateAnAge [

	self assert: (grammar gen: MateAge) class equals: MateAge.
	self assert: (grammar gen: MateAge) value class equals: SmallInteger
]
