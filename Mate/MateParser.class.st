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
MateParser >> visitInstanceDeclaration: decl from: context [

	| instance childContext node |
	
	instance := context object.
	
	(instance isKindOf: decl type) ifFalse: [
		self error: 'Expected instance of ', decl type name, ' but got ', instance class name.
	].

	1 halt.
	"Not sure how to define this"

	childContext := context copy.
	childContext push: decl.
	
	node := MateOGInstanceNode new declaration: decl; context: context; instance: instance.
	childContext parentNode: node.
	
	decl instanceVariableDeclarations do: [ :instVarDecl | | edge |
		edge := instVarDecl visit: self from: childContext constraint: nil.
		node addEdge: edge at: instVarDecl name.
	].
	
	^ node
]
