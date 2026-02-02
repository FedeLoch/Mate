Class {
	#name : 'EnGenerator',
	#superclass : 'Object',
	#instVars : [
		'grammar'
	],
	#category : 'En-Parsing',
	#package : 'En',
	#tag : 'Parsing'
}

{ #category : 'as yet unclassified' }
EnGenerator >> emptyInstanceDeclaration: aClass [

	^ EnInstanceDeclaration new type: aClass
]

{ #category : 'accessing' }
EnGenerator >> gen: type [

	^ (self gen: (grammar typeDeclarations at: type) from: EnContext new) instantiate
]

{ #category : 'accessing' }
EnGenerator >> gen: declarationObject from: context [

	^ declarationObject visit: self from: context

]

{ #category : 'accessing' }
EnGenerator >> grammar [

	^ grammar	
]

{ #category : 'accessing' }
EnGenerator >> grammar: aGrammar [

	grammar := aGrammar
]

{ #category : 'visiting' }
EnGenerator >> visitBuiltinDeclaration: decl from: context [
	
	^ EnOGBuiltInNode new declaration: decl; context: context

]

{ #category : 'visiting' }
EnGenerator >> visitClassDeclaration: decl from: context [ 

	1 halt.
]

{ #category : 'visiting' }
EnGenerator >> visitInstanceDeclaration: decl from: context [ 

	^ decl instanceVariableDeclarations inject: (EnOGInstanceNode new declaration: decl; context: context) into: [ :node :instVarDecl |
		node addEdge: (self visitInstanceVariableDeclaration: instVarDecl from: context) at: instVarDecl name.
		node.
	]
]

{ #category : 'visiting' }
EnGenerator >> visitInstanceVariableDeclaration: instVarDecl from: context [

	| type declaration |
	
	type := instVarDecl chooseOneType.
	
	declaration := grammar typeDeclarations at: type ifPresent: [ :decl | decl ] ifAbsent: [
		self emptyInstanceDeclaration: type
	].
	
	^ declaration visit: self from: context
]
