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
	
	^ self visitBuiltinDeclaration: decl from: context constraint: nil

]

{ #category : 'visiting' }
EnGenerator >> visitBuiltinDeclaration: decl from: context constraint: aConstraint [
	
	^ EnOGBuiltInNode new 
		declaration: decl; 
		context: context;
		constraint: aConstraint

]

{ #category : 'visiting' }
EnGenerator >> visitClassDeclaration: decl from: context [ 

	self error: 'Class declarations not yet implemented'.
]

{ #category : 'visiting' }
EnGenerator >> visitInstanceDeclaration: decl from: context [ 

	| childContext node |
	
	"Create a new context with this declaration in the path"
	childContext := context copy.
	childContext push: decl.
	
	node := EnOGInstanceNode new declaration: decl; context: childContext.
	
	decl instanceVariableDeclarations do: [ :instVarDecl |
		node addEdge: (self visitInstanceVariableDeclaration: instVarDecl from: childContext) at: instVarDecl name.
	].

	^ node
]

{ #category : 'visiting' }
EnGenerator >> visitInstanceVariableDeclaration: instVarDecl from: context [

	| type declaration |
	
	type := instVarDecl chooseOneTypeFrom: context.
	
	declaration := grammar typeDeclarations at: type ifPresent: [ :decl | decl ] ifAbsent: [
		self emptyInstanceDeclaration: type
	].
	
	"Pass constraint through for built-in types"
	"TODO: review this, don't use if"
	(declaration isKindOf: EnBuiltInDeclaration) ifTrue: [
		^ self visitBuiltinDeclaration: declaration from: context constraint: instVarDecl constraint
	].
	
	^ declaration visit: self from: context
]
