Class {
	#name : 'MateASTGrammar',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Examples',
	#package : 'Mate',
	#tag : 'Grammar Examples'
}

{ #category : 'accessing' }
MateASTGrammar >> defineObjectGraph [

	^ 'Interval -> {
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
	statements: { type: [ OCArrayNode | OCAssignmentNode | OCBlockNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCReturnNode | OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 1229 },
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
	messages: { type: [ OCMessageNode ], collection: OrderedCollection, sizeBetween: 2 and: 104 },
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
	"TEMPORARY: every message takes exactly 1 argument, because the grammar cannot yet say that
	 the number of arguments equals the selector''s arity (selector value numArgs = arguments size).
	 Remove once Mate supports that invariant."
	arguments: { type: [ OCArrayNode | OCVariableNode | OCLiteralArrayNode | OCLiteralValueNode | OCBlockNode | OCMessageNode ], collection: OrderedCollection, size: 1 },
	keywordsPositions: IntegerArray,
	selfReferences: { selector.parent, receiver.parent, arguments[ .parent ] }
}

OCMethodNode -> {
	properties: SmallDictionary?,
	"TEMPORARY: a fixed 1-argument selector and exactly 1 argument, because the grammar cannot yet say that
	 the number of arguments equals the selector''s arity (selector numArgs = arguments size).
	 TEMPORARY: a hardcoded selector, because Mate cannot yet generate strings of a given shape (regex)."
	selector: { oneOf: { #fuzzed: } },
	keywordsPositions: IntegerArray,
	arguments: { type: [ OCVariableNode ], collection: OrderedCollection, size: 1 },
	pragmas: { type: [ OCPragmaNode ], collection: OrderedCollection, sizeBetween: 0 and: 2 },
	body: OCSequenceNode,
	source: ByteString | WideString,
	replacements: SortedCollection,
	nodeReplacements: IdentityDictionary,
	selfReferences: { arguments[ .parent ], pragmas[ .parent ], body.parent }
}

OCPragmaNode -> {
	parent: { refType: OCProgramNode },
	"TEMPORARY: hardcoded unary pragmas, because Mate cannot yet generate selectors of a given shape (regex),
	 and pragma arguments would need the arity invariant."
	selector: { oneOf: { #generated . #fuzzed . #mate } },
	keywordsPositions: IntegerArray,
	left: { type: SmallInteger, between: 0 and: 1902 },
	right: { type: SmallInteger, between: 0 and: 1960 },
	invariants: { left < right }
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
	"TEMPORARY: hardcoded 1-argument selectors (binary and one-keyword), because Mate cannot yet generate
	 selectors of a given shape (regex), nor match the selector''s arity to the number of arguments.
	 Selectors that Opal inlines (ifTrue:, and:, whileTrue:, ...) are left out: they require literal blocks."
	value: { oneOf: { #''+'' . #''-'' . #''*'' . #''='' . #''=='' . #''<'' . #''>'' . #'','' . #''@'' . #''->'' . #at: . #add: . #value: . #includes: . #remove: . #printOn: } }
}

OCSequenceNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	leftBar: { type: SmallInteger, between: 0 and: 7291, nullable: true },
	rightBar: { type: SmallInteger, between: 0 and: 7295, nullable: true },
	statements: { type: [ OCArrayNode | OCAssignmentNode | OCBlockNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCReturnNode | OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 178 },
	periods: { type: [ SmallInteger ], collection: OrderedCollection, sizeBetween: 0 and: 177 },
	temporaries: { type: [ OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 36 },
	selfReferences: { statements[ .parent ] }
}

OCVariableNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 2 },
	name: ByteSymbol | ByteString,
	variable: OCUnresolvedVariable,
	start: { type: SmallInteger, between: 0 and: 30614 }
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
