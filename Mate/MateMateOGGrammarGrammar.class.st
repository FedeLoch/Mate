Class {
	#name : 'MateMateOGGrammarGrammar',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Examples',
	#package : 'Mate',
	#tag : 'Grammar Examples'
}

{ #category : 'accessing' }
MateMateOGGrammarGrammar >> defineObjectGraph [

	^ '
		MateOGGrammar -> {
			typeDeclarations: { type: [ MateInstDecl ], sizeBetween: 0 and: 10 },
			builtInTypeDeclarations: { type: [ MateBuiltInDecl ], sizeBetween: 0 and: 10 },
			selfReferences: { builtInTypeDeclarations[ .grammar ] }
		}
		
		MateInstDecl -> {
			instanceVariableDeclarations: { type: [ MateInstVarDecl ], sizeBetween: 0 and: 10 }
		}
		
		MateInstVarDecl -> {
			name: String,
			constraint: MateConstraint
		}
		
		MateBuiltInDecl -> {
			grammar: { refType: MateOGGrammar }
		}
	'
]
