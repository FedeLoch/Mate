Class {
	#name : 'MateOGGrammar',
	#superclass : 'Object',
	#instVars : [
		'typeDeclarations',
		'builtInTypeDeclarations',
		'generator',
		'parser'
	],
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'accessing' }
MateOGGrammar >> addTypeDeclaration: decl [

	decl grammar: self.
	typeDeclarations at: decl type put: decl
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> backpropagate: node improvement: improvement from: context [

	node recursiveBackPropagate: improvement from: context seen: Set new
]

{ #category : 'accessing' }
MateOGGrammar >> builtInTypeDeclarations [

	| builtInTypes |

	builtInTypes := { SmallInteger. Float . Boolean . String }.

	^ builtInTypes inject: Dictionary new into: [ :dict :type |
		dict at: type put: (MateBuiltInDecl new type: type; grammar: self).
		dict
	]
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> gen: type [

	^ generator gen: type
]

{ #category : 'as yet unclassified' }
MateOGGrammar >> gen: declarationObject from: context [

	^ generator gen: declarationObject from: context
]

{ #category : 'accessing' }
MateOGGrammar >> initialize [

	super initialize.
	typeDeclarations := self builtInTypeDeclarations.
	generator := MateGenerator new grammar: self.
	parser := MateParser new grammar: self.
]

{ #category : 'accessing' }
MateOGGrammar >> typeDeclarations [

	^ typeDeclarations
]

{ #category : 'accessing' }
MateOGGrammar >> typeDeclarations: declarations [

	declarations do: [ :decl | self addTypeDeclaration: decl ]
]
