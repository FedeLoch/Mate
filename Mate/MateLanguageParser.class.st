Class {
	#name : 'MateLanguageParser',
	#superclass : 'Object',
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'parsing' }
MateLanguageParser class >> parse: aMateDescription [

	^ self new parse: aMateDescription
]

{ #category : 'creation' }
MateLanguageParser >> createArrayDeclFrom: dict [

	| decl arrayDef typeList elementType |
	
	decl := MateInstArrayVarDecl new.
	arrayDef := dict at: 'array'. 
	
	typeList := arrayDef at: 'type'.
	elementType := typeList first.
	
	decl elementType: (self resolveType: elementType).
	
	(arrayDef includesKey: 'sizeBetween') ifTrue: [
		decl sizeBetween: (arrayDef at: 'sizeBetween') and: (arrayDef at: 'and').
	].
	
	^ decl
]

{ #category : 'creation' }
MateLanguageParser >> createConstrainedDeclFrom: dict [

	| decl typeSpec |
	
	typeSpec := dict at: 'type'.
	
	(typeSpec isCollection and: [ typeSpec isString not ]) ifTrue: [ 
		decl := MateInstArrayVarDecl new.
		decl elementType: (self resolveType: typeSpec first).
		
		(dict includesKey: 'sizeBetween') ifTrue: [
			decl sizeBetween: (dict at: 'sizeBetween') and: (dict at: 'and').
		].
		^ decl
	].

	decl := MateInstVarDecl new type: (self resolveType: typeSpec).
	
	(dict includesKey: 'between') ifTrue: [
		decl constraint: (MateConstraint between: (dict at: 'between') and: (dict at: 'and')).
	].
	
	(dict includesKey: 'greaterThan') ifTrue: [
		decl constraint: (MateConstraint greaterThan: (dict at: 'greaterThan')).
	].
	
	^ decl
]

{ #category : 'parsing' }
MateLanguageParser >> expect: string from: stream [

	^ self match: string from: stream
]

{ #category : 'parsing' }
MateLanguageParser >> match: string from: stream [
	| pos |
	pos := stream position.
	string do: [ :char | 
		stream atEnd ifTrue: [ stream position: pos. ^ false ].
		(stream next = char) ifFalse: [ stream position: pos. ^ false ]
	].
	^ true
]

{ #category : 'accessing' }
MateLanguageParser >> parse: aString [

	| stream declarations |
	
	stream := aString readStream.
	declarations := OrderedCollection new.
	
	[ stream atEnd ] whileFalse: [ 
		self skipWhitespace: stream.
		stream atEnd ifFalse: [ 
			declarations add: (self parseRule: stream) 
		]
	].

	^ declarations 
]

{ #category : 'parsing' }
MateLanguageParser >> parseArrayElementProp: stream [

	| propName |
	
	stream next.
	self skipWhitespace: stream.
	self match: '.' from: stream.
	propName := self parseIdentifier: stream.
	self skipWhitespace: stream.
	self match: ']' from: stream.

	^ MatePathEachProp from: propName
]

{ #category : 'parsing' }
MateLanguageParser >> parseComplexContent: stream [
	
	| pos isDict collection dict |
	
	self match: '{' from: stream.
	self skipWhitespace: stream.
	
	pos := stream position.
	
	(self match: '}' from: stream) ifTrue: [ ^ Dictionary new ].
	
	self parseIdentifier: stream.
	self skipWhitespace: stream.
	isDict := (stream peek = $:).
	
	stream position: pos.
	
	isDict ifTrue: [ 
		dict := Dictionary new.
		[ self skipWhitespace: stream. (self match: '}' from: stream) ] whileFalse: [ | key val |
			key := self parseIdentifier: stream.
			self skipWhitespace: stream.
			self expect: ':' from: stream.
			self skipWhitespace: stream.
			val := self parseValue: stream.
			dict at: key put: val.
			self skipWhitespace: stream.
			self match: ',' from: stream.
		].
		
		(dict includesKey: 'array') ifTrue: [ ^ self createArrayDeclFrom: dict ].
		(dict includesKey: 'oneOf') ifTrue: [ ^ MateInstOneOfVarDecl new options: (dict at: 'oneOf') ].
		(dict includesKey: 'refType') ifTrue: [ ^ MateInstRefVarDecl new type: (self resolveClass: (dict at: 'refType')) ].
		(dict includesKey: 'type') ifTrue: [ ^ self createConstrainedDeclFrom: dict ].
		
		^ dict
	] ifFalse: [
		collection := OrderedCollection new.
		[ self skipWhitespace: stream. (self match: '}' from: stream) ] whileFalse: [
			collection add: (self parseValue: stream).
			self skipWhitespace: stream.
			self match: '.' from: stream.
			self match: ',' from: stream.
		].
		^ collection asArray
	]
]

{ #category : 'parsing' }
MateLanguageParser >> parseComplexType: stream [

	^ self parseComplexContent: stream
]

{ #category : 'parsing' }
MateLanguageParser >> parseDefinition: stream [

	| decls selfRefs pos name |
	
	(self match: '{' from: stream) ifFalse: [ self error: 'Expected {' ].
	
	decls := OrderedCollection new.
	selfRefs := OrderedCollection new.
	
	[ self skipWhitespace: stream. (self match: '}' from: stream) ] whileFalse: [
		pos := stream position.
		name := self parseIdentifier: stream.
		stream position: pos.
		
		name = 'selfReferences' ifTrue: [
			selfRefs addAll: (self parseSelfReferences: stream).
		] ifFalse: [
			decls add: (self parseField: stream).
		].
		self skipWhitespace: stream.
		self match: ',' from: stream.
	].

	^ { decls. selfRefs }
]

{ #category : 'parsing' }
MateLanguageParser >> parseField: stream [

	| name typeDesc |
	
	name := self parseIdentifier: stream.
	self skipWhitespace: stream.
	
	(self expect: ':' from: stream) ifFalse: [ self error: 'Expected :' ].
	self skipWhitespace: stream.
	
	typeDesc := self parseTypeDescription: stream.
	
	typeDesc name: name.
	
	^ typeDesc
]

{ #category : 'parsing' }
MateLanguageParser >> parseIdentifier: stream [

	^ String streamContents: [ :s |
		[ stream peek isAlphaNumeric ] whileTrue: [ s nextPut: stream next ]
	]
]

{ #category : 'parsing' }
MateLanguageParser >> parseList: stream [

	| collection |
	
	self match: '[' from: stream.
	collection := OrderedCollection new.
	
	[ self skipWhitespace: stream. (self match: ']' from: stream) ] whileFalse: [
		collection add: (self parseValue: stream).
		self skipWhitespace: stream.
		self match: ',' from: stream.
	].

	^ collection asArray
]

{ #category : 'parsing' }
MateLanguageParser >> parseNumber: stream [
	
	| numStr |
	
	numStr := String streamContents: [ :s |
		[ stream peek isDigit ] whileTrue: [ s nextPut: stream next ]
	].

	^ numStr asNumber
]

{ #category : 'parsing' }
MateLanguageParser >> parseProp: stream [

	| propName |
	
	self match: '.' from: stream.
	propName := self parseIdentifier: stream.
	
	^ MatePathProp from: propName
]

{ #category : 'parsing' }
MateLanguageParser >> parseReferencePath: stream [

	| pathParts |
	pathParts := OrderedCollection new.

	[
		self skipWhitespace: stream.
		stream atEnd not and: [
			stream peek ~= $} and: [ stream peek ~= $, ] ] ] whileTrue: [
			pathParts add: (stream peek = $[
					 ifTrue: [ self parseArrayElementProp: stream ]
					 ifFalse: [ self parseProp: stream ]) ].

	^ MateReferencePath new: pathParts asArray
]

{ #category : 'parsing' }
MateLanguageParser >> parseRule: stream [

	| className result definition selfRefs type |
	
	className := self parseIdentifier: stream.
	self skipWhitespace: stream.
	
	(self expect: '->' from: stream) ifFalse: [ self error: 'Expected ->' ].
	self skipWhitespace: stream.
	
	result := self parseDefinition: stream.
	self skipWhitespace: stream.
	
	definition := result first.
	selfRefs := result second.
	
	type := self resolveClass: className.
	
	^ MateInstDecl new type: type; instanceVariableDeclarations: definition asArray; selfReferences: selfRefs asArray
]

{ #category : 'parsing' }
MateLanguageParser >> parseSelfReferences: stream [

	| refs |
	
	self parseIdentifier: stream.
	self skipWhitespace: stream.
	self expect: ':' from: stream.
	self skipWhitespace: stream.
	self expect: '{' from: stream.
	
	refs := OrderedCollection new.
	
	[ self skipWhitespace: stream. (self match: '}' from: stream) ] whileFalse: [
		refs add: (self parseReferencePath: stream).
		self skipWhitespace: stream.
		self match: ',' from: stream.
	].
	
	^ refs
]

{ #category : 'parsing' }
MateLanguageParser >> parseSymbol: stream [

	stream next.

	^ (self parseIdentifier: stream) asSymbol
]

{ #category : 'parsing' }
MateLanguageParser >> parseType: stream [
	"Parses a type expression and returns the resolved type (a Class or a union).
	 Handles: simple identifiers, unions with |, and parenthesized types with ().
	 This is the single entry point for type resolution."
	
	| char |
	
	char := stream peek.
	
	char = $( ifTrue: [
		| type |
		self match: '(' from: stream.
		self skipWhitespace: stream.
		type := self parseType: stream.
		self skipWhitespace: stream.
		self match: ')' from: stream.
		^ type
	].
	
	^ self parseSimpleTypeExpression: stream
]

{ #category : 'parsing' }
MateLanguageParser >> parseSimpleTypeExpression: stream [
	"Parses an identifier optionally followed by | and more types.
	 Returns the resolved type (a Class or a union)."
	
	| typeName type |
	
	typeName := self parseIdentifier: stream.
	type := self resolveClass: typeName.
	self skipWhitespace: stream.
	
	(self match: '|' from: stream) ifTrue: [
		| otherType |
		self skipWhitespace: stream.
		otherType := self parseType: stream.
		^ otherType | type
	].

	^ type
]

{ #category : 'parsing' }
MateLanguageParser >> parseTypeDescription: stream [
	"Parses a type description for instance variable declarations.
	 Returns a MateInstVarDecl (or subclass) wrapping the resolved type.
	 Delegates to parseType: for type resolution and wraps the result."

	| char |
	
	char := stream peek.
	
	char = ${ ifTrue: [ 
		^ self parseComplexType: stream 
	].
	
	^ MateInstVarDecl new type: (self parseType: stream)
]

{ #category : 'parsing' }
MateLanguageParser >> parseValue: stream [
	"Parses a general value. Returns raw values: numbers, symbols, arrays, dicts,
	 or resolved types (Class or union) when encountering type expressions."
	
	| char |
	
	self skipWhitespace: stream.
	char := stream peek.
	
	char isDigit ifTrue: [ ^ self parseNumber: stream ].
	char = $# ifTrue: [ ^ self parseSymbol: stream ].
	char = $[ ifTrue: [ ^ self parseList: stream ].
	char = ${ ifTrue: [ ^ self parseComplexContent: stream ].
	char = $( ifTrue: [ ^ self parseType: stream ].
	
	^ self parseSimpleValue: stream
]

{ #category : 'parsing' }
MateLanguageParser >> parseSimpleValue: stream [
	"Parses an identifier, checking for | to handle union types.
	 If a union is found, resolves types and returns the union.
	 Otherwise returns the raw string identifier."
	
	| name |
	
	name := self parseIdentifier: stream.
	self skipWhitespace: stream.
	
	(self match: '|' from: stream) ifTrue: [
		| otherType type |
		self skipWhitespace: stream.
		otherType := self parseValue: stream.
		type := self resolveClass: name.
		^ (self resolveType: otherType) | type
	].
	
	^ name
]

{ #category : 'resolving' }
MateLanguageParser >> resolveClass: aClassName [
	"Resolves a class name string to the actual class object."

	^ self class environment at: aClassName asSymbol ifAbsent: [ 
		self error: 'Class not found: ', aClassName
	]
]

{ #category : 'resolving' }
MateLanguageParser >> resolveType: aTypeOrString [
	"Resolves a type that may be either a string (class name) or an already resolved type.
	 If it is a string, resolves it to the class. Otherwise returns it as-is."

	^ aTypeOrString isString 
		ifTrue: [ self resolveClass: aTypeOrString ] 
		ifFalse: [ aTypeOrString ]
]

{ #category : 'parsing' }
MateLanguageParser >> skipWhitespace: stream [

	[ stream atEnd not and: [ stream peek <= 32 asCharacter ] ] whileTrue: [ stream next ]
]
