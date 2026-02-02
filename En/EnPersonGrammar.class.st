Class {
	#name : 'EnPersonGrammar',
	#superclass : 'EnOGGrammar',
	#category : 'En-Grammar Tests',
	#package : 'En',
	#tag : 'Grammar Tests'
}

{ #category : 'accessing' }
EnPersonGrammar >> defineGrammar [ 

	^ '
	 	Person -> { age: Age }.
	 	Age -> { value: SmallInteger }.
	'
]

{ #category : 'accessing' }
EnPersonGrammar >> initialize [ 
	
	super initialize.
	
	self addTypeDeclaration: (EnInstanceDeclaration new type: Person; instanceVariableDeclarations: {
		EnInstanceVariableDeclaration new name: 'age'; type: Age 
	}).
	self addTypeDeclaration: (EnInstanceDeclaration new type: Age; instanceVariableDeclarations: {
		EnInstanceVariableDeclaration new name: 'value'; type: SmallInteger 
	}).
	
		"
		Person -> { age: Age }.
		Age -> { value: SmallInteger }
	"
]
