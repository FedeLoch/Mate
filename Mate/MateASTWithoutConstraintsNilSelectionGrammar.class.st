Class {
	#name : 'MateASTWithoutConstraintsNilSelectionGrammar',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Examples',
	#package : 'Mate',
	#tag : 'Grammar Examples'
}

{ #category : 'accessing' }
MateASTWithoutConstraintsNilSelectionGrammar >> defineObjectGraph [

	^ 'Interval -> {
	start: SmallInteger,
	stop: SmallInteger,
	step: SmallInteger
}

OCArrayNode -> {
	parent: OCProgramNode | nil,
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	left: SmallInteger,
	right: SmallInteger,
	statements: { type: [ OCArrayNode | OCAssignmentNode | OCBlockNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCReturnNode | OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 10 },
	periods: { type: [ SmallInteger ], collection: OrderedCollection, sizeBetween: 0 and: 1228 }
}

OCAssignmentNode -> {
	parent: OCProgramNode | nil,
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	variable: OCVariableNode,
	assignment: SmallInteger,
	value: OCArrayNode | OCAssignmentNode | OCBlockNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCVariableNode
}

OCBlockNode -> {
	parent: OCProgramNode | nil,
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	left: SmallInteger,
	right: SmallInteger,
	colons: { type: [ SmallInteger ], collection: OrderedCollection, sizeBetween: 0 and: 7 },
	arguments: { type: [ OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 7 },
	bar: SmallInteger,
	body: OCSequenceNode
}

OCCascadeNode -> {
	parent: OCProgramNode | nil,
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	messages: { type: [ OCMessageNode ], collection: OrderedCollection, sizeBetween: 2 and: 10 },
	semicolons: { type: [ SmallInteger ], collection: OrderedCollection, sizeBetween: 1 and: 103 }
}

OCCommentNode -> {
	parent: OCProgramNode | nil,
	contents: ByteString | WideString,
	start: SmallInteger,
	stop: SmallInteger
}

OCLiteralArrayNode -> {
	parent: OCProgramNode | nil,
	properties: SmallDictionary?,
	start: SmallInteger,
	stop: SmallInteger,
	isByteArray: { oneOf: { false } },
	contents: { type: [ OCLiteralValueNode | OCLiteralArrayNode ], collection: OrderedCollection, sizeBetween: 0 and: 5 },
	openerSize: SmallInteger
}

OCLiteralValueNode -> {
	parent: OCProgramNode | nil,
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	start: SmallInteger,
	stop: SmallInteger,
	value: (Boolean | BoxedFloat64 | ByteString | ByteSymbol | Character | LargeNegativeInteger | LargePositiveInteger | ScaledDecimal | SmallFloat64 | SmallInteger | WideString | WideSymbol)?,
	sourceText: ByteString?
}

OCMessageNode -> {
	parent: OCProgramNode | nil,
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 2 },
	receiver: OCArrayNode | OCAssignmentNode | OCBlockNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCVariableNode,
	selector: OCSelectorNode,
	arguments: { type: [ OCArrayNode | OCVariableNode | OCLiteralArrayNode | OCLiteralValueNode | OCBlockNode | OCMessageNode ], collection: OrderedCollection, sizeBetween: 0 and: 3 },
	keywordsPositions: IntegerArray
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
	nodeReplacements: IdentityDictionary
}

OCPragmaNode -> {
	parent: OCProgramNode | nil,
	selector: ByteSymbol,
	keywordsPositions: IntegerArray,
	arguments: { type: [ OCLiteralValueNode ], sizeBetween: 0 and: 3 },
	left: SmallInteger,
	right: SmallInteger
}

OCReturnNode -> {
	parent: OCProgramNode | nil,
	properties: SmallDictionary?,
	value: OCArrayNode | OCAssignmentNode | OCBlockNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCVariableNode,
	start: SmallInteger
}

OCSelectorNode -> {
	parent: OCProgramNode | nil,
	value: ByteSymbol
}

OCSequenceNode -> {
	parent: OCProgramNode | nil,
	properties: SmallDictionary?,
	leftBar: SmallInteger,
	rightBar: SmallInteger,
	statements: { type: [ OCArrayNode | OCAssignmentNode | OCBlockNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCReturnNode | OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 10 },
	periods: { type: [ SmallInteger ], collection: OrderedCollection, sizeBetween: 0 and: 177 },
	temporaries: { type: [ OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 10 }
}

OCVariableNode -> {
	parent: OCProgramNode | nil,
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
