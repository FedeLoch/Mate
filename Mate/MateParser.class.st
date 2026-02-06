Class {
	#name : 'MateParser',
	#superclass : 'MateGrammarVisitor',
	#category : 'Mate-Parsing',
	#package : 'Mate',
	#tag : 'Parsing'
}

{ #category : 'parsing' }
MateParser >> parse: obj [ 

	^ self parse: obj class from: MateContext new
]

{ #category : 'parsing' }
MateParser >> parse: type from: context [

	| decl |
	
	decl := (grammar typeDeclarations at: type).

	^ decl visit: self from: context constraint: nil
]
