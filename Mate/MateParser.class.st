Class {
	#name : 'MateParser',
	#superclass : 'MateGrammarVisitor',
	#category : 'Mate-Parsing',
	#package : 'Mate',
	#tag : 'Parsing'
}

{ #category : 'parsing' }
MateParser >> parse: obj [ 

	^ self parse: obj class from: (MateParsingContext from: obj)
]

{ #category : 'parsing' }
MateParser >> parse: type from: context [

	| decl |

	decl := grammar typeDeclarations at: type ifAbsent: [ 
		self error: 'No declaration found for ', type name 
	].

	^ decl visit: self from: context constraint: nil
]

{ #category : 'visiting' }
MateParser >> visitBuiltinDeclaration: decl from: context constraint: aConstraint [

	| instance |
	
	instance := context object.
	
	(instance isKindOf: decl type) ifFalse: [
		self error: 'Expected instance of ', decl type name, ' but got ', instance class name.
	].
	
	^ MateOGBuiltInNode new declaration: decl; instance: instance; context: context
]

{ #category : 'visiting' }
MateParser >> visitInstVarDecl: instVarDecl from: context [

	| instance declaration node type |
	
	instance := context object.
	type := instance class.
	
	(instVarDecl acceptType: type) ifFalse: [
		self error: 'Expected an instance of: ', instVarDecl types asString, ' in field: ', instVarDecl name, 'but it was:', type name
	].
	
	declaration := grammar typeDeclarations at: type ifPresent: #yourself ifAbsent: [
		self emptyInstanceDeclaration: type
	].
	
	node := declaration visit: self from: context constraint: nil.
	
	^ node declaration: instVarDecl
]

{ #category : 'visiting' }
MateParser >> visitInstanceDeclaration: decl from: context [

	| instance childContext node |
	
	instance := context object.
	
	(instance isKindOf: decl type) ifFalse: [
		self error: 'Expected instance of ', decl type name, ' but got ', instance class name.
	].

	childContext := context copy.
	childContext push: decl.
	
	node := MateOGInstanceNode new declaration: decl; context: context; instance: instance.
	childContext parentNode: node.
	
	decl instanceVariableDeclarations do: [ :instVarDecl | | edge specificContext |
		specificContext := childContext copy.
		specificContext object: (instance instVarNamed: instVarDecl name).

		edge := instVarDecl visit: self from: specificContext constraint: nil.
		node addEdge: edge at: instVarDecl name.
	].
	
	^ node
]
