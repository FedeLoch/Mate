Class {
	#name : 'MateWriter',
	#superclass : 'MateGrammarVisitor',
	#category : 'Mate-Writing',
	#package : 'Mate',
	#tag : 'Writing'
}

{ #category : 'as yet unclassified' }
MateWriter >> definition: type decl: decl [

	^  decl visit: self from: nil constraint: nil
]

{ #category : 'as yet unclassified' }
MateWriter >> mateDefinition [

	| defs |

	defs := grammar typeDeclarations keysDo: [ :type |
		self definition: type decl: (grammar typeDeclarations at: type)
	].

1 halt.
]
