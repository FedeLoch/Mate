Class {
	#name : 'MateParser',
	#superclass : 'MateGrammarVisitor',
	#category : 'Mate-Parsing',
	#package : 'Mate',
	#tag : 'Parsing'
}

{ #category : 'visiting' }
MateParser >> nilNode: decl from: context [

	^ MateOGInstanceNode new declaration: decl; context: context; instance: nil
]

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
MateParser >> visitArrayDecl: decl from: context [

	| array node childContext |
	
	array := context object.
	
	(array isCollection) ifFalse: [ 
		self error: 'Expected collection in field ', decl name, ' but got ', array class name 
	].

	(decl acceptSize: array size) ifFalse: [
		self error: 'Array size ', array size asString, ' not between ', decl minSize asString, ' and ', decl maxSize asString.
	].

	childContext := context copy.
	childContext push: decl.
	
	node := MateOGInstanceNode new declaration: decl; context: context; instance: array.
	childContext parentNode: node.
	
	array doWithIndex: [ :item :index | | specificContext itemNode |
		specificContext := childContext copy.
		specificContext object: item.

		itemNode := self parse: decl elementType from: specificContext.
		node addEdge: itemNode at: index.
	].

	^ node
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
MateParser >> visitInstRefDecl: decl from: context [ 

	| instance |
	
	instance := context object.
	
	instance ifNil: [ ^ self nilNode: decl from: context ].
	
	(instance isKindOf: decl type) ifFalse: [
		self error: 'Expected reference to ', decl type name, ' but got ', instance class name.
	].
	
	^ MateOGInstanceNode new declaration: decl; instance: instance; context: context
]

{ #category : 'visiting' }
MateParser >> visitInstVarDecl: instVarDecl from: context [

	| instance declaration node type |
	
	instance := context object.
	type := instance class.
	
	instance ifNil: [ ^ self nilNode: instVarDecl from: context ].
		
	(instVarDecl acceptType: type) ifFalse: [
		self error: 'Expected an instance of ', instVarDecl types asString, ' in field ', instVarDecl name, ' but it was ', type name
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

	decl selfReferences do: [ :reference | reference insertReference: instance ].
	
	^ node
]

{ #category : 'visiting' }
MateParser >> visitOneOfDecl: decl from: context [

	| instance |
	
	instance := context object.

	(decl acceptOption: instance) ifFalse: [
		self error: 'Expected one option of ', decl options asString, ' but got ', instance asString.
	].

	^ MateOGBuiltInNode new declaration: decl; instance: instance; context: context
]
