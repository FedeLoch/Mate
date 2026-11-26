Class {
	#name : 'MateASTWithoutConstraintsGrammar',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Examples',
	#package : 'Mate',
	#tag : 'Grammar Examples'
}

{ #category : 'accessing' }
MateASTWithoutConstraintsGrammar >> defineObjectGraph [

	^ 'Interval -> {
	start: SmallInteger,
	stop: SmallInteger,
	step: SmallInteger
}

OCArrayNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	left: SmallInteger,
	right: SmallInteger,
	statements: { type: [ OCArrayNode | OCAssignmentNode | OCBlockNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCReturnNode | OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 10 },
	periods: { type: [ SmallInteger ], collection: OrderedCollection, sizeBetween: 0 and: 1228 },
	selfReferences: { statements[ .parent ] }
}

OCAssignmentNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	variable: OCVariableNode,
	assignment: SmallInteger,
	value: OCArrayNode | OCAssignmentNode | OCBlockNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCVariableNode,
	selfReferences: { value.parent, variable.parent }
}

OCBlockNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	left: SmallInteger,
	right: SmallInteger,
	colons: { type: [ SmallInteger ], collection: OrderedCollection, sizeBetween: 0 and: 7 },
	arguments: { type: [ OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 7 },
	bar: SmallInteger,
	body: OCSequenceNode,
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
	start: SmallInteger,
	stop: SmallInteger
}

OCLiteralArrayNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	start: SmallInteger,
	stop: SmallInteger,
	isByteArray: { oneOf: { false } },
	contents: { type: [ OCLiteralValueNode | OCLiteralArrayNode ], collection: OrderedCollection, sizeBetween: 0 and: 5 },
	openerSize: SmallInteger,
	selfReferences: { contents[ .parent ] }
}

OCLiteralValueNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	start: SmallInteger,
	stop: SmallInteger,
	value: (Boolean | BoxedFloat64 | ByteString | ByteSymbol | Character | LargeNegativeInteger | LargePositiveInteger | ScaledDecimal | SmallFloat64 | SmallInteger | WideString | WideSymbol)?,
	sourceText: ByteString?
}

OCMessageNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 2 },
	receiver: OCArrayNode | OCAssignmentNode | OCBlockNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCVariableNode,
	selector: OCSelectorNode,
	arguments: { type: [ OCArrayNode | OCVariableNode | OCLiteralArrayNode | OCLiteralValueNode | OCBlockNode | OCMessageNode ], collection: OrderedCollection, sizeBetween: 0 and: 3 },
	keywordsPositions: IntegerArray,
	selfReferences: { selector.parent, receiver.parent, arguments[ .parent ] }
}

OCMethodNode -> {
	properties: SmallDictionary?,
	selector: ByteSymbol,
	keywordsPositions: IntegerArray,
	arguments: { type: [ OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 3 },
	pragmas: { type: [ OCPragmaNode ], collection: OrderedCollection, sizeBetween: 0 and: 2 },
	body: OCSequenceNode,
	source: ByteString | WideString,
	replacements: SortedCollection,
	nodeReplacements: IdentityDictionary,
	selfReferences: { arguments[ .parent ], pragmas[ .parent ], body.parent }
}

OCPragmaNode -> {
	parent: { refType: OCProgramNode },
	selector: ByteSymbol,
	keywordsPositions: IntegerArray,
	arguments: { type: [ OCLiteralValueNode ], sizeBetween: 0 and: 3 },
	left: SmallInteger,
	right: SmallInteger,
	selfReferences: { arguments[ .parent ] }
}

OCReturnNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	value: OCArrayNode | OCAssignmentNode | OCBlockNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCVariableNode,
	start: SmallInteger,
	selfReferences: { value.parent }
}

OCSelectorNode -> {
	parent: { refType: OCProgramNode },
	value: ByteSymbol
}

OCSequenceNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	leftBar: SmallInteger,
	rightBar: SmallInteger,
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
	start: SmallInteger
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

ScaledDecimal -> {
	numerator: SmallInteger,
	denominator: SmallInteger,
	scale: SmallInteger
}'
]
