Class {
	#name : 'MateASTGrammar',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Examples',
	#package : 'Mate',
	#tag : 'Grammar Examples'
}

{ #category : 'accessing' }
MateASTGrammar >> defineObjectGraph [

	^ '"A selector: unary, binary, or 1 to 3 keywords (methods take at most 3 arguments in this grammar)."
AnySelector = { type: ByteSymbol, matching: ''[a-zA-Z_][a-zA-Z0-9_]*|[a-zA-Z_][a-zA-Z0-9_]*\:([a-zA-Z_][a-zA-Z0-9_]*\:)?([a-zA-Z_][a-zA-Z0-9_]*\:)?|[-+*/\\<>=~@%|&?,]+'' }

Interval -> {
	start: { type: SmallInteger, between: 0 and: 30229 },
	stop: { type: SmallInteger, between: 0 and: 30482 },
	step: { type: SmallInteger, between: 0 and: 1 },
	invariants: { start < stop }
}

OCArrayNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	left: { type: SmallInteger, between: 0 and: 9503 },
	right: { type: SmallInteger, between: 0 and: 30484 },
	statements: { type: [ OCArrayNode | OCAssignmentNode | OCBlockNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCReturnNode | OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 10 },
	periods: { type: [ SmallInteger ], collection: OrderedCollection, sizeBetween: 0 and: 1228 },
	invariants: { left < right },
	selfReferences: { statements[ .parent ] }
}

OCAssignmentNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	variable: OCVariableNode,
	assignment: { type: SmallInteger, between: 0 and: 12430 },
	value: OCArrayNode | OCAssignmentNode | OCBlockNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCVariableNode,
	selfReferences: { value.parent, variable.parent }
}

OCBlockNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	left: { type: SmallInteger, between: 0 and: 12510 },
	right: { type: SmallInteger, between: 0 and: 12674 },
	colons: { type: [ SmallInteger ], collection: OrderedCollection, sizeBetween: 0 and: 7 },
	arguments: { type: [ OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 7 },
	bar: { type: SmallInteger, between: 0 and: 12515, nullable: true },
	body: OCSequenceNode,
	invariants: { left < right },
	selfReferences: { body.parent, arguments[ .parent ] }
}

OCCascadeNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	messages: { type: [ OCMessageNode ], collection: OrderedCollection, sizeBetween: 2 and: 10 },
	semicolons: { type: [ SmallInteger ], collection: OrderedCollection, sizeBetween: 1 and: 103 },
	selfReferences: { messages[ .parent ] }
}

OCCommentNode -> {
	parent: { refType: OCProgramNode },
	contents: ByteString | WideString,
	start: { type: SmallInteger, between: 0 and: 30489 },
	stop: { type: SmallInteger, between: 0 and: 172187 },
	invariants: { start < stop }
}

OCLiteralArrayNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	start: { type: SmallInteger, between: 0 and: 30453 },
	stop: { type: SmallInteger, between: 0 and: 811164 },
	isByteArray: { oneOf: { false } },
	contents: { type: [ OCLiteralValueNode | OCLiteralArrayNode ], collection: OrderedCollection, sizeBetween: 0 and: 5 },
	openerSize: { type: SmallInteger, between: 0 and: 2 },
	invariants: { start < stop },
	selfReferences: { contents[ .parent ] }
}

OCLiteralValueNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	start: { type: SmallInteger, between: 0 and: 811163 },
	stop: { type: SmallInteger, between: 0 and: 811163 },
	value: (Boolean | BoxedFloat64 | ByteString | ByteSymbol | Character | LargeNegativeInteger | LargePositiveInteger | ScaledDecimal | SmallFloat64 | SmallInteger | WideString | WideSymbol)?,
	sourceText: ByteString?,
	invariants: { start <= stop }
}

OCMessageNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 2 },
	receiver: OCArrayNode | OCAssignmentNode | OCBlockNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCVariableNode,
	selector: OCSelectorNode,
	arguments: { type: [ OCArrayNode | OCVariableNode | OCLiteralArrayNode | OCLiteralValueNode | OCBlockNode | OCMessageNode ], collection: OrderedCollection, sizeBetween: 0 and: 3 },
	keywordsPositions: IntegerArray,
	"A message takes as many arguments as its selector declares."
	invariants: { selector value numArgs = arguments size },
	selfReferences: { selector.parent, receiver.parent, arguments[ .parent ] }
}

OCMethodNode -> {
	properties: SmallDictionary?,
	selector: AnySelector,
	keywordsPositions: IntegerArray,
	arguments: { type: [ OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 3 },
	pragmas: { type: [ OCPragmaNode ], collection: OrderedCollection, sizeBetween: 0 and: 2 },
	body: OCSequenceNode,
	source: ByteString | WideString,
	replacements: SortedCollection,
	nodeReplacements: IdentityDictionary,
	"A method takes as many arguments as its selector declares."
	invariants: { selector numArgs = arguments size },
	selfReferences: { arguments[ .parent ], pragmas[ .parent ], body.parent }
}

OCPragmaNode -> {
	parent: { refType: OCProgramNode },
	"Pragmas that Opal interprets (primitives) need specific arguments, so they are left out."
	selector: { type: ByteSymbol, matching: ''[a-zA-Z_][a-zA-Z0-9_]*|[a-zA-Z_][a-zA-Z0-9_]*\:([a-zA-Z_][a-zA-Z0-9_]*\:)?([a-zA-Z_][a-zA-Z0-9_]*\:)?|[-+*/\\<>=~@%|&?,]+'',
		except: { #primitive: . #primitive:module: . #primitive:error: . #primitive:module:error: . #primitive:error:module: } },
	keywordsPositions: IntegerArray,
	arguments: { type: [ OCLiteralValueNode ], sizeBetween: 0 and: 3 },
	left: { type: SmallInteger, between: 0 and: 1902 },
	right: { type: SmallInteger, between: 0 and: 1960 },
	invariants: { left < right, selector numArgs = arguments size },
	selfReferences: { arguments[ .parent ] }
}

OCReturnNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	value: OCArrayNode | OCAssignmentNode | OCBlockNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCVariableNode,
	start: { type: SmallInteger, between: 3 and: 30612 },
	selfReferences: { value.parent }
}

OCSelectorNode -> {
	parent: { refType: OCProgramNode },
	"Any well-formed selector except the ones Opal inlines, which require literal blocks as arguments."
	value: { type: ByteSymbol, matching: ''[a-zA-Z_][a-zA-Z0-9_]*|[a-zA-Z_][a-zA-Z0-9_]*\:([a-zA-Z_][a-zA-Z0-9_]*\:)?([a-zA-Z_][a-zA-Z0-9_]*\:)?|[-+*/\\<>=~@%|&?,]+'',
		except: { #ifTrue: . #ifFalse: . #ifTrue:ifFalse: . #ifFalse:ifTrue: . #and: . #or: . #ifNil: . #ifNotNil: . #ifNil:ifNotNil: . #ifNotNil:ifNil: .
			#whileTrue: . #whileFalse: . #whileTrue . #whileFalse . #to:do: . #to:by:do: . #timesRepeat: . #repeat . #caseOf: . #caseOf:otherwise: } }
}

OCSequenceNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	leftBar: { type: SmallInteger, between: 0 and: 7291, nullable: true },
	rightBar: { type: SmallInteger, between: 0 and: 7295, nullable: true },
	statements: { type: [ OCArrayNode | OCAssignmentNode | OCBlockNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCReturnNode | OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 10 },
	periods: { type: [ SmallInteger ], collection: OrderedCollection, sizeBetween: 0 and: 177 },
	temporaries: { type: [ OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 10 },
	selfReferences: { statements[ .parent ] }
}

OCVariableNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 2 },
	name: ByteSymbol | ByteString,
	variable: OCUnresolvedVariable | ArgumentVariable | UndeclaredVariable | TemporaryVariable | CopiedLocalVariable,
	start: { type: SmallInteger, between: 0 and: 30614 }
}

ArgumentVariable -> {
	name: ByteSymbol | ByteString,
	escaping: Boolean | ByteSymbol,
	usage: { oneOf: { #read . #write . nil } }
}

CopiedLocalVariable -> {
	name: ByteSymbol | ByteString,
	escaping: Boolean | ByteSymbol,
	usage: { oneOf: { #read . #write . nil } },
	originalVar: (ArgumentVariable | TemporaryVariable)
}

OCWarningNotice -> {
	messageText: { oneOf: { ''Use a proper symbol literal'' } },
	node: OCLiteralValueNode
}

"ScaledDecimal literals must have their fields set: without a declaration, Mate creates them empty and
 compiling fails (ScaledDecimal >> isLiteral computes 10 raisedTo: scale)."
ScaledDecimal -> {
	numerator: SmallInteger,
	denominator: { type: SmallInteger, between: 1 and: 1000 },
	scale: { type: SmallInteger, between: 0 and: 10 }
}'
]
