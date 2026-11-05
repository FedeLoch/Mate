Class {
	#name : 'MateParser',
	#superclass : 'MateGrammarVisitor',
	#instVars : [
		'visiting'
	],
	#category : 'Mate-Parsing',
	#package : 'Mate',
	#tag : 'Parsing'
}

{ #category : 'visiting' }
MateParser >> checkConstraint: aConstraint of: instance in: decl [

	aConstraint ifNil: [ ^ self ].
	(aConstraint includes: instance) ifFalse: [
		self error: 'Value ', instance printString, ' of type ', decl name asString, ' violates ', aConstraint printString ]
]

{ #category : 'accessing' }
MateParser >> declarationFor: aType [

	| declarations |

	declarations := grammar typeDeclarations.

	declarations at: aType ifPresent: [ :decl | ^ decl ].

	aType allSuperclasses do: [ :superclass |
		declarations at: superclass ifPresent: [ :decl | decl isBuiltIn ifFalse: [ ^ decl ] ] ].

	^ self emptyInstanceDeclaration: aType
]

{ #category : 'initialization' }
MateParser >> initialize [

	super initialize.
	visiting := IdentitySet new
]

{ #category : 'visiting' }
MateParser >> nilNode: decl from: context [

	^ MateOGInstanceNode new declaration: decl; context: context; instance: nil
]

{ #category : 'parsing' }
MateParser >> parse: obj [

	visiting := IdentitySet new.

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

	array ifNil: [ ^ self nilNode: decl from: context ].

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

	(array isKindOf: decl collectionClass) ifFalse: [
		self error: 'Expected ', decl collectionClass name, ' in field ', decl name, ' but got ', array class name ].

	array asArray doWithIndex: [ :item :index | | specificContext itemNode |
		specificContext := childContext copy.
		specificContext object: item.

		itemNode := item
			ifNil: [ self nilNode: decl from: specificContext ]
			ifNotNil: [
				(decl elementType acceptType: item class) ifFalse: [
					self error: 'Expected an element of ', decl elementType name, ' in field ', decl name, ' but it was ', item class name ].
				(self declarationFor: item class) visit: self from: specificContext constraint: nil ].
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

	self checkConstraint: aConstraint of: instance in: decl.

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

	| instance node type |

	instance := context object.

	instance ifNil: [ ^ self nilNode: instVarDecl from: context ].

	type := instance class.

	(instVarDecl acceptType: type) ifFalse: [
		self error: 'Expected an instance of ', instVarDecl types asString, ' in field ', instVarDecl name, ' but it was ', type name
	].

	node := (self declarationFor: type) visit: self from: context constraint: instVarDecl constraint.

	^ node declaration: instVarDecl
]

{ #category : 'visiting' }
MateParser >> visitInstanceDeclaration: decl from: context [

	| instance childContext node |

	instance := context object.

	(instance isKindOf: decl type) ifFalse: [
		self error: 'Expected instance of ', decl type name, ' but got ', instance class name.
	].

	node := MateOGInstanceNode new declaration: decl; context: context; instance: instance.

	(visiting includes: instance) ifTrue: [ ^ node ].
	visiting add: instance.

	childContext := context copy.
	childContext push: decl.
	childContext parentNode: node.

	[
		decl instanceVariableDeclarations do: [ :instVarDecl | | edge specificContext |
			specificContext := childContext copy.
			specificContext object: (instance instVarNamed: instVarDecl name).

			edge := instVarDecl visit: self from: specificContext constraint: nil.
			node addEdge: edge at: instVarDecl name.
		] ] ensure: [ visiting remove: instance ].

	decl selfReferences do: [ :reference |
		(reference isSatisfiedBy: instance) ifFalse: [
			self error: 'Self reference ', reference printString, ' is not satisfied by ', instance printString ] ].

	decl invariants do: [ :invariant |
		(invariant holdsFor: instance) ifFalse: [
			self error: 'Invariant ', invariant printString, ' is not satisfied by ', instance printString ] ].

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
