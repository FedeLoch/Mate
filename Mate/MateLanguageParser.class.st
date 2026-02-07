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

	| decl arrayDef typeList |
	
	decl := MateInstArrayVarDecl new.
	arrayDef := dict at: 'array'. 
	
	typeList := arrayDef at: 'type'.
	
	decl elementType: (self resolveClass: typeList first).
	
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
		decl elementType: (self resolveClass: typeSpec first).
		
		(dict includesKey: 'sizeBetween') ifTrue: [
			decl sizeBetween: (dict at: 'sizeBetween') and: (dict at: 'and').
		].
		^ decl
	].

	decl := MateInstVarDecl new type: (self resolveClass: typeSpec).
	
	(dict includesKey: 'between') ifTrue: [
		decl constraint: (MateConstraint between: (dict at: 'between') and: (dict at: 'and')).
	].
	
	(dict includesKey: 'greaterThan') ifTrue: [
		decl constraint: (MateConstraint greaterThan: (dict at: 'greaterThan')).
	].
	
	^ decl
]

{ #category : 'parsing' }
MateLanguageParser >> createUnion: type1 with: type2 [
	
	"Assuming type2 is already a decl or union type object"
	"If type2 is MateInstVarDecl, extract its type"
	| t2 |
	t2 := (type2 isKindOf: MateInstVarDecl) ifTrue: [ type2 type ] ifFalse: [ type2 ].
	
	^ MateInstVarDecl new type: (self getUnion: type1 with: t2)
]

{ #category : 'parsing' }
MateLanguageParser >> expect: string from: stream [

	^ self match: string from: stream
]

{ #category : 'parsing' }
MateLanguageParser >> getUnion: t1 with: t2 [

	^ t2 | t1
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

	| decls |
	
	(self match: '{' from: stream) ifFalse: [ self error: 'Expected {' ].
	
	decls := OrderedCollection new.
	
	[ self skipWhitespace: stream. (self match: '}' from: stream) ] whileFalse: [
		decls add: (self parseField: stream).
		self skipWhitespace: stream.
		self match: ',' from: stream. "Optional comma?"
	].

	^ decls
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
MateLanguageParser >> parseRule: stream [

	| className definition type |
	
	className := self parseIdentifier: stream.
	self skipWhitespace: stream.
	
	(self expect: '->' from: stream) ifFalse: [ self error: 'Expected ->' ].
	self skipWhitespace: stream.
	
	definition := self parseDefinition: stream.
	self skipWhitespace: stream.
	
	type := self resolveClass: className.
	
	^ MateInstDecl new type: type; instanceVariableDeclarations: definition asArray
]

{ #category : 'parsing' }
MateLanguageParser >> parseSimpleType: stream [
	
	| typeName type |
	
	typeName := self parseIdentifier: stream.
	self skipWhitespace: stream.
	
	(self match: '|' from: stream) ifTrue: [
		| otherType |
		self skipWhitespace: stream.
		otherType := self parseTypeDescription: stream.
		type := self resolveClass: typeName.
		^ (self createUnion: type with: otherType)
	].

	type := self resolveClass: typeName.

	^ MateInstVarDecl new type: type
]

{ #category : 'parsing' }
MateLanguageParser >> parseSymbol: stream [

	stream next.

	^ (self parseIdentifier: stream) asSymbol
]

{ #category : 'parsing' }
MateLanguageParser >> parseTypeDescription: stream [

	| char |
	
	char := stream peek.
	
	char = ${ ifTrue: [ 
		^ self parseComplexType: stream 
	].
	
	char = $( ifTrue: [ 
		^ self parseUnionType: stream 
	].
	
	^ self parseSimpleType: stream
]

{ #category : 'parsing' }
MateLanguageParser >> parseUnionType: stream [
	
	| type |
	
	self match: '(' from: stream.
	self skipWhitespace: stream.
	
	type := self parseTypeDescription: stream.
	
	self skipWhitespace: stream.
	self match: ')' from: stream.
	
	^ type
]

{ #category : 'parsing' }
MateLanguageParser >> parseValue: stream [
	
	| char |
	
	self skipWhitespace: stream.
	char := stream peek.
	
	char isDigit ifTrue: [ ^ self parseNumber: stream ].
	char = $# ifTrue: [ ^ self parseSymbol: stream ].
	char = $[ ifTrue: [ ^ self parseList: stream ].
	char = ${ ifTrue: [ ^ self parseComplexContent: stream ]. 
	
	^ self parseIdentifier: stream
]

{ #category : 'resolving' }
MateLanguageParser >> resolveClass: aClass [

	^ self class environment at: aClass asSymbol ifAbsent: [ 
		self error: 'Class not found: ', aClass
	]
]

{ #category : 'parsing' }
MateLanguageParser >> skipWhitespace: stream [

	[ stream atEnd not and: [ stream peek <= 32 asCharacter ] ] whileTrue: [ stream next ]
]
