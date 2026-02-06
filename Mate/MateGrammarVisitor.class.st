Class {
	#name : 'MateGrammarVisitor',
	#superclass : 'Object',
	#instVars : [
		'grammar'
	],
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'accessing' }
MateGrammarVisitor >> grammar [

	^ grammar
]

{ #category : 'accessing' }
MateGrammarVisitor >> grammar: aGrammar [

	grammar := aGrammar 
]

{ #category : 'visiting' }
MateGrammarVisitor >> visitArrayDecl: decl from: context [

	self subclassResponsibility 
]

{ #category : 'visiting' }
MateGrammarVisitor >> visitBuiltinDeclaration: decl from: context [

	self subclassResponsibility 
]

{ #category : 'visiting' }
MateGrammarVisitor >> visitBuiltinDeclaration: decl from: context constraint: aConstraint [

	self subclassResponsibility 
]

{ #category : 'visiting' }
MateGrammarVisitor >> visitClassDeclaration: decl from: context [ 

	self subclassResponsibility 
]

{ #category : 'visiting' }
MateGrammarVisitor >> visitInstVarDecl: instVarDecl from: context [

	self subclassResponsibility 
]

{ #category : 'visiting' }
MateGrammarVisitor >> visitInstanceDeclaration: decl from: context [

	self subclassResponsibility 
]

{ #category : 'visiting' }
MateGrammarVisitor >> visitOneOfDecl: decl from: context [

	self subclassResponsibility 
]
