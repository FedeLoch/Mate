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
MateLanguageParser >> applySize: dict to: decl [

	(dict includesKey: 'sizeBetween') ifTrue: [
		decl sizeBetween: (dict at: 'sizeBetween') and: (self at: 'and' in: dict for: 'sizeBetween') ].

	(dict includesKey: 'size') ifTrue: [ decl size: (dict at: 'size') ].

	decl minSize > decl maxSize ifTrue: [
		self error: 'Invalid array size range ', decl minSize printString, '..', decl maxSize printString ].

	^ decl
]

{ #category : 'creation' }
MateLanguageParser >> at: key in: dict for: ownerKey [

	^ dict at: key ifAbsent: [ self error: ownerKey, ': requires ', key, ':' ]
]

{ #category : 'creation' }
MateLanguageParser >> constraintFrom: dict [

	| constraint |

	constraint := MateConstraint new.

	(dict includesKey: 'between') ifTrue: [
		constraint atLeast: (dict at: 'between'); atMost: (self at: 'and' in: dict for: 'between') ].
	(dict includesKey: 'atLeast') ifTrue: [ constraint atLeast: (dict at: 'atLeast') ].
	(dict includesKey: 'atMost') ifTrue: [ constraint atMost: (dict at: 'atMost') ].
	(dict includesKey: 'greaterThan') ifTrue: [ constraint greaterThan: (dict at: 'greaterThan') ].
	(dict includesKey: 'lessThan') ifTrue: [ constraint lessThan: (dict at: 'lessThan') ].
	(dict includesKey: 'in') ifTrue: [ constraint options: (dict at: 'in') ].

	^ constraint isUnconstrained ifTrue: [ nil ] ifFalse: [ constraint ]
]

{ #category : 'creation' }
MateLanguageParser >> createArrayDeclFrom: dict [

	| definition |

	definition := dict at: 'array'.
	(definition isKindOf: MateInstArrayVarDecl) ifTrue: [ ^ definition ].

	^ self createInstArrayVarDecl: definition
]

{ #category : 'creation' }
MateLanguageParser >> createConstrainedDeclFrom: dict [

	| decl typeSpec |

	typeSpec := dict at: 'type'.

	(typeSpec isCollection and: [ typeSpec isString not ]) ifTrue: [ ^ self createInstArrayVarDecl: dict ].

	decl := MateInstVarDecl new type: (self resolveType: typeSpec).
	decl constraint: (self constraintFrom: dict).
	decl nullable: (dict at: 'nullable' ifAbsent: [ false ]).

	^ decl
]

{ #category : 'creation' }
MateLanguageParser >> createInstArrayVarDecl: dict [

	| decl typeSpec elementType |

	typeSpec := dict at: 'type'.
	typeSpec ifEmpty: [ self error: 'Array type requires at least one element type' ].

	elementType := typeSpec allButFirst
		inject: (self resolveType: typeSpec first)
		into: [ :union :each | MateOptionalType union: union with: (self resolveType: each) ].

	decl := MateInstArrayVarDecl new.
	decl elementType: elementType.

	^ self applySize: dict to: decl
]

{ #category : 'creation' }
MateLanguageParser >> declarationFrom: value [

	(value isKindOf: MateInstVarDecl) ifFalse: [
		self error: 'Expected a field description but got ', value printString ].

	^ value
]

{ #category : 'parsing' }
MateLanguageParser >> error: message at: stream [

	^ self error: message, ' at position ', stream position printString
]

{ #category : 'parsing' }
MateLanguageParser >> expect: string from: stream [

	(self match: string from: stream) ifFalse: [ self error: 'Expected ', string at: stream ].
	^ true
]

{ #category : 'parsing' }
MateLanguageParser >> expectNotAtEnd: stream [

	stream atEnd ifTrue: [ self error: 'Unexpected end of input' at: stream ]
]

{ #category : 'testing' }
MateLanguageParser >> isIdentifierCharacter: aCharacter [

	^ aCharacter notNil and: [ aCharacter isAlphaNumeric or: [ aCharacter = $_ ] ]
]

{ #category : 'parsing' }
MateLanguageParser >> match: string from: stream [

	| pos |

	pos := stream position.

	string do: [ :char |
		stream atEnd ifTrue: [ stream position: pos . ^ false ].
		(stream next = char) ifFalse: [ stream position: pos . ^ false ]
	].

	^ true
]

{ #category : 'accessing' }
MateLanguageParser >> parse: aString [

	| stream declarations |

	stream := aString readStream.
	declarations := OrderedCollection new.

	[ self skipWhitespace: stream. stream atEnd ] whileFalse: [
		declarations add: (self parseRule: stream)
	].

	^ declarations
]

{ #category : 'parsing' }
MateLanguageParser >> parseArrayElementProp: stream [

	| propName |

	self expect: '[' from: stream.
	self skipWhitespace: stream.
	self expect: '.' from: stream.
	propName := self requireIdentifier: stream.
	self skipWhitespace: stream.
	self expect: ']' from: stream.

	^ MatePathEachProp from: propName
]

{ #category : 'parsing' }
MateLanguageParser >> parseClassSuffix: aClass from: stream [

	| pos suffix |

	pos := stream position.
	self skipWhitespace: stream.
	suffix := self parseIdentifier: stream.

	suffix = 'class' ifTrue: [ ^ aClass class ].
	suffix = 'classTrait' ifTrue: [ ^ aClass classTrait ].

	stream position: pos.
	^ aClass
]

{ #category : 'parsing' }
MateLanguageParser >> parseComplexContent: stream [

	| pos isDict collection dict |

	self expect: '{' from: stream.
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
			self expectNotAtEnd: stream.
			key := self requireIdentifier: stream.
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
		(dict includesKey: 'refType') ifTrue: [ ^ MateInstRefVarDecl new type: (self resolveType: (dict at: 'refType')) ].
		(dict includesKey: 'type') ifTrue: [ ^ self createConstrainedDeclFrom: dict ].

		^ dict
	] ifFalse: [
		collection := OrderedCollection new.
		[ self skipWhitespace: stream. (self match: '}' from: stream) ] whileFalse: [
			self expectNotAtEnd: stream.
			collection add: (self parseValue: stream).
			self skipWhitespace: stream.
			self match: '.' from: stream.
			self skipWhitespace: stream.
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

	self expect: '{' from: stream.

	decls := OrderedCollection new.
	selfRefs := OrderedCollection new.

	[ self skipWhitespace: stream. (self match: '}' from: stream) ] whileFalse: [
		self expectNotAtEnd: stream.
		pos := stream position.
		name := self requireIdentifier: stream.
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

	name := self requireIdentifier: stream.
	self skipWhitespace: stream.
	self expect: ':' from: stream.
	self skipWhitespace: stream.

	typeDesc := self parseTypeDescription: stream.

	typeDesc name: name.

	^ typeDesc
]

{ #category : 'parsing' }
MateLanguageParser >> parseIdentifier: stream [

	^ String streamContents: [ :s |
		[ self isIdentifierCharacter: stream peek ] whileTrue: [ s nextPut: stream next ]
	]
]

{ #category : 'parsing' }
MateLanguageParser >> parseList: stream [

	| collection |

	self expect: '[' from: stream.
	collection := OrderedCollection new.

	[ self skipWhitespace: stream. (self match: ']' from: stream) ] whileFalse: [
		self expectNotAtEnd: stream.
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
		stream peek = $- ifTrue: [ s nextPut: stream next ].
		self readDigitsFrom: stream into: s.
		(stream peek = $. and: [ (self peekSecond: stream) notNil and: [ (self peekSecond: stream) isDigit ] ]) ifTrue: [
			s nextPut: stream next.
			self readDigitsFrom: stream into: s ].
		(stream peek = $e and: [ (self peekSecond: stream) notNil and: [ (self peekSecond: stream) isDigit or: [ (self peekSecond: stream) = $- ] ] ]) ifTrue: [
			s nextPut: stream next.
			stream peek = $- ifTrue: [ s nextPut: stream next ].
			self readDigitsFrom: stream into: s ] ].

	(numStr isEmpty or: [ numStr last isDigit not ]) ifTrue: [ self error: 'Expected a number' at: stream ].

	^ Number readFrom: numStr
]

{ #category : 'parsing' }
MateLanguageParser >> parseProp: stream [

	| propName |

	self match: '.' from: stream.
	propName := self requireIdentifier: stream.

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

	pathParts ifEmpty: [ self error: 'Empty reference path' at: stream ].

	^ MateReferencePath new: pathParts asArray
]

{ #category : 'parsing' }
MateLanguageParser >> parseRule: stream [

	| className result definition selfRefs type |

	className := self requireIdentifier: stream.
	self skipWhitespace: stream.

	self expect: '->' from: stream.
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

	self requireIdentifier: stream.
	self skipWhitespace: stream.
	self expect: ':' from: stream.
	self skipWhitespace: stream.
	self expect: '{' from: stream.

	refs := OrderedCollection new.

	[ self skipWhitespace: stream. (self match: '}' from: stream) ] whileFalse: [
		self expectNotAtEnd: stream.
		refs add: (self parseReferencePath: stream).
		self skipWhitespace: stream.
		self match: ',' from: stream.
	].

	^ refs
]

{ #category : 'parsing' }
MateLanguageParser >> parseSimpleValue: stream [

	| pos name |

	pos := stream position.
	name := self requireIdentifier: stream.

	name = 'true' ifTrue: [ ^ true ].
	name = 'false' ifTrue: [ ^ false ].
	name = 'nil' ifTrue: [ ^ nil ].

	stream position: pos.
	^ self parseType: stream
]

{ #category : 'parsing' }
MateLanguageParser >> parseString: stream [

	^ String streamContents: [ :s |
		self expect: '''' from: stream.
		[
			self expectNotAtEnd: stream.
			(stream peek = $' and: [ (self peekSecond: stream) = $' ])
				ifTrue: [ stream next. s nextPut: stream next. true ]
				ifFalse: [ stream peek = $'
					ifTrue: [ stream next. false ]
					ifFalse: [ s nextPut: stream next. true ] ] ] whileTrue ]
]

{ #category : 'parsing' }
MateLanguageParser >> parseSymbol: stream [

	| symbol |

	self expect: '#' from: stream.

	stream peek = $' ifTrue: [ ^ (self parseString: stream) asSymbol ].

	symbol := String streamContents: [ :s |
		[ (self isIdentifierCharacter: stream peek) or: [ stream peek = $: ] ] whileTrue: [ s nextPut: stream next ] ].

	symbol ifEmpty: [ self error: 'Expected a symbol' at: stream ].

	^ symbol asSymbol
]

{ #category : 'parsing' }
MateLanguageParser >> parseType: stream [

	| type |

	self skipWhitespace: stream.
	self expectNotAtEnd: stream.

	stream peek = $(
		ifTrue: [
			self expect: '(' from: stream.
			type := self parseType: stream.
			self skipWhitespace: stream.
			self expect: ')' from: stream ]
		ifFalse: [ type := self parseTypeName: stream ].

	self skipWhitespace: stream.
	(self match: '|' from: stream) ifTrue: [
		^ MateOptionalType union: type with: (self parseType: stream) ].

	^ type
]

{ #category : 'parsing' }
MateLanguageParser >> parseTypeDescription: stream [

	| decl |

	stream peek = ${ ifTrue: [ ^ self declarationFrom: (self parseComplexType: stream) ].

	decl := MateInstVarDecl new type: (self parseType: stream).

	self skipWhitespace: stream.
	(self match: '?' from: stream) ifTrue: [ decl nullable: true ].

	^ decl
]

{ #category : 'parsing' }
MateLanguageParser >> parseTypeName: stream [

	^ self parseClassSuffix: (self resolveClass: (self requireIdentifier: stream)) from: stream
]

{ #category : 'parsing' }
MateLanguageParser >> parseValue: stream [

	| char |

	self skipWhitespace: stream.
	self expectNotAtEnd: stream.
	char := stream peek.

	(char isDigit or: [ char = $- ]) ifTrue: [ ^ self parseNumber: stream ].
	char = $# ifTrue: [ ^ self parseSymbol: stream ].
	char = $' ifTrue: [ ^ self parseString: stream ].
	char = $[ ifTrue: [ ^ self parseList: stream ].
	char = ${ ifTrue: [ ^ self parseComplexContent: stream ].
	char = $( ifTrue: [ ^ self parseType: stream ].
	(self isIdentifierCharacter: char) ifTrue: [ ^ self parseSimpleValue: stream ].

	^ self error: 'Unexpected character ', char printString at: stream
]

{ #category : 'parsing' }
MateLanguageParser >> peekSecond: stream [

	| pos second |

	pos := stream position.
	stream atEnd ifTrue: [ ^ nil ].
	stream next.
	second := stream peek.
	stream position: pos.
	^ second
]

{ #category : 'parsing' }
MateLanguageParser >> readDigitsFrom: stream into: aWriteStream [

	[ stream peek notNil and: [ stream peek isDigit ] ] whileTrue: [ aWriteStream nextPut: stream next ]
]

{ #category : 'parsing' }
MateLanguageParser >> requireIdentifier: stream [

	| identifier |

	identifier := self parseIdentifier: stream.
	identifier ifEmpty: [
		self error: 'Expected an identifier', (stream atEnd
			ifTrue: [ ' but reached the end of input' ]
			ifFalse: [ ' but found ', stream peek printString ]) at: stream ].

	^ identifier
]

{ #category : 'resolving' }
MateLanguageParser >> resolveClass: aClassName [

	aClassName isString ifFalse: [ ^ aClassName ].

	^ self class environment at: aClassName asSymbol ifAbsent: [
		self error: 'Class not found: ', aClassName
	]
]

{ #category : 'resolving' }
MateLanguageParser >> resolveType: typeOrIdentifier [

	^ typeOrIdentifier isString
		ifTrue: [ self resolveClass: typeOrIdentifier ]
		ifFalse: [ typeOrIdentifier ]
]

{ #category : 'parsing' }
MateLanguageParser >> skipWhitespace: stream [

	[ stream atEnd not and: [ stream peek asInteger <= 32 or: [ stream peek = $" ] ] ] whileTrue: [
		stream peek = $"
			ifTrue: [
				stream next.
				[ self expectNotAtEnd: stream. stream next = $" ] whileFalse ]
			ifFalse: [ stream next ] ]
]
