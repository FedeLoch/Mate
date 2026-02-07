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

{ #category : 'accessing' }
MateLanguageParser >> parse: aString [

	| stream grammar |
	
	stream := aString readStream.
	grammar := MateOGGrammar new.
	
	[ stream atEnd ] whileFalse: [ 
		self skipWhitespace: stream.
		stream atEnd ifFalse: [ 
			self parseRule: stream into: grammar 
		]
	].

	^ grammar
]

{ #category : 'parsing' }
MateLanguageParser >> parseRule: stream into: grammar [

	| className definition type |
	
	className := self parseIdentifier: stream.
	self skipWhitespace: stream.
	
	(self expect: '->' from: stream) ifFalse: [ self error: 'Expected ->' ].
	self skipWhitespace: stream.
	
	definition := self parseDefinition: stream.
	self skipWhitespace: stream.
	
	(self expect: '.' from: stream) ifFalse: [ self error: 'Expected .' ].
	
	type := self resolveClass: className.
	grammar addTypeDeclaration: (MateInstDecl new 
		type: type;
		instanceVariableDeclarations: definition).
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
MateLanguageParser >> parseSimpleType: stream [
	
	| typeName type |
	
	typeName := self parseIdentifier: stream.
	self skipWhitespace: stream.
	
	(self match: '|' from: stream) ifTrue: [
		| otherType |
		self skipWhitespace: stream.
		otherType := self parseTypeDescription: stream.
		"TODO: Handle top-level union properly if needed, but usually unions are in ()"
		"For Warrior | Rogue | Mage, if not in parens, it's tricky without precedence."
		"Assuming simple type is just one class for now, or unions are parenthesized."
		"But wait, example: characterClass: Warrior | Rogue | Mage,"
		"This means '|' has lower precedence than ':'"
		"So parseSimpleType should actually parse a sequence of types separated by |"
		type := self resolveClass: typeName.
		^ (self createUnion: type with: otherType)
	].

	type := self resolveClass: typeName.
	^ MateInstVarDecl new type: type
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
MateLanguageParser >> createUnion: type1 with: type2 [
	
	"Assuming type2 is already a decl or union type object"
	"If type2 is MateInstVarDecl, extract its type"
	| t2 |
	t2 := (type2 isKindOf: MateInstVarDecl) ifTrue: [ type2 type ] ifFalse: [ type2 ].
	
	^ MateInstVarDecl new type: (getUnion: type1 with: t2)
]

{ #category : 'parsing' }
MateLanguageParser >> getUnion: t1 with: t2 [
	"Helper to create union of types - assuming | is implemented on Class/Type"
	^ t1 | t2
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
	"Identifier or Type"
	^ self parseIdentifier: stream
]

{ #category : 'parsing' }
MateLanguageParser >> parseComplexContent: stream [
	"Parses { ... } content. Can be a Dictionary (key: val) or a List (val, val)."
	
	| pos isDict collection dict |
	
	self match: '{' from: stream.
	self skipWhitespace: stream.
	
	pos := stream position.
	
	"Check if it's empty"
	(self match: '}' from: stream) ifTrue: [ ^ Dictionary new ].
	
	"Check first element to decide if Dict or List"
	"If identifier followed by :, it's a Dict"
	
	self parseIdentifier: stream.
	self skipWhitespace: stream.
	isDict := (stream peek = $:).
	
	stream position: pos. "Backtrack"
	
	isDict ifTrue: [ 
		dict := Dictionary new.
		[ self skipWhitespace: stream. (self match: '}' from: stream) ] whileFalse: [
			| key val |
			key := self parseIdentifier: stream.
			self skipWhitespace: stream.
			self expect: ':' from: stream.
			self skipWhitespace: stream.
			val := self parseValue: stream.
			dict at: key put: val.
			self skipWhitespace: stream.
			self match: ',' from: stream.
		].
		
		"If this dict represents a decl, convert it"
		(dict includesKey: 'array') ifTrue: [ ^ self createArrayDeclFrom: dict ].
		(dict includesKey: 'oneOf') ifTrue: [ ^ MateInstOneOfVarDecl new options: (dict at: 'oneOf') ].
		(dict includesKey: 'type') ifTrue: [ ^ self createConstrainedDeclFrom: dict ].
		
		^ dict "Return raw dict if just structure, e.g. nested constraint params"
	] ifFalse: [
		collection := OrderedCollection new.
		[ self skipWhitespace: stream. (self match: '}' from: stream) ] whileFalse: [
			collection add: (self parseValue: stream).
			self skipWhitespace: stream.
			self match: '.' from: stream. "Smalltalk array syntax uses ."
			self match: ',' from: stream. "Or comma? Example uses ."
		].
		^ collection asArray
	]
]

{ #category : 'parsing' }
MateLanguageParser >> parseComplexType: stream [
	"Alias for consistency, but logic moved to parseComplexContent to handle ambiguity"
	^ self parseComplexContent: stream
]

{ #category : 'parsing' }
MateLanguageParser >> parseList: stream [
	"Parse [ ... ] - usually list of types"
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

{ #category : 'creation' }
MateLanguageParser >> createArrayDeclFrom: dict [

	| decl arrayDef typeList |
	
	decl := MateInstArrayVarDecl new.
	arrayDef := dict at: 'array'. 
	"arrayDef is the inner dict: { type: [ BlElement ], sizeBetween: 0 and: 10 }"
	
	typeList := arrayDef at: 'type'.
	"typeList is [ 'BlElement' ] (strings) or [ BlElement ] (classes via resolve?)"
	"parseValue returns identifier strings for types usually."
	
	decl elementType: (self resolveClass: typeList first).
	
	(arrayDef includesKey: 'sizeBetween') ifTrue: [
		decl sizeBetween: (arrayDef at: 'sizeBetween') and: (arrayDef at: 'and').
	].
	
	^ decl
]

{ #category : 'creation' }
MateLanguageParser >> createConstrainedDeclFrom: dict [
	| decl typeName type |
	typeName := dict at: 'type'.
	type := self resolveClass: typeName.
	
	decl := MateInstVarDecl new type: type.
	
	(dict includesKey: 'between') ifTrue: [
		"between: 0 and: 99 - this needs 'and' key in dict? No."
		"Grammar: between: 0 and: 99"
		"My parser sees: key 'between', val 0. key 'and', val 99."
		decl constraint: (MateConstraint between: (dict at: 'between') and: (dict at: 'and')).
	].
	
	(dict includesKey: 'greaterThan') ifTrue: [
		decl constraint: (MateConstraint greaterThan: (dict at: 'greaterThan')).
	].
	
	^ decl
]
