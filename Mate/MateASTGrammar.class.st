Class {
	#name : 'MateASTGrammar',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Examples',
	#package : 'Mate',
	#tag : 'Grammar Examples'
}

{ #category : 'accessing' }
MateASTGrammar >> defineObjectGraph [

	^ 'IdentityDictionary -> {
	tally: { type: SmallInteger, between: 0 and: 0 },
	array: { type: [ nil ], sizeBetween: 5 and: 5 }
}

Interval -> {
	start: { type: SmallInteger, between: 6 and: 30229 },
	stop: { type: SmallInteger, between: 17 and: 30482 },
	step: { type: SmallInteger, between: 1 and: 1 },
	invariants: { start < stop }
}

OCArrayNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	left: { type: SmallInteger, between: 8 and: 9503 },
	right: { type: SmallInteger, between: 11 and: 30484 },
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
	assignment: { type: SmallInteger, between: 11 and: 12430 },
	value: OCArrayNode | OCAssignmentNode | OCBlockNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCVariableNode,
	selfReferences: { value.parent, variable.parent }
}

OCBlockNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	left: { type: SmallInteger, between: 7 and: 12510 },
	right: { type: SmallInteger, between: 14 and: 12674 },
	colons: { type: [ SmallInteger ], collection: OrderedCollection, sizeBetween: 0 and: 7 },
	arguments: { type: [ OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 7 },
	bar: { type: SmallInteger, between: 18 and: 12515, nullable: true },
	body: OCSequenceNode,
	invariants: { left < right },
	selfReferences: { body.parent, arguments[ .parent ] }
}

OCCascadeNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	messages: { type: [ OCMessageNode ], collection: OrderedCollection, sizeBetween: 1 and: 104 },
	semicolons: { type: [ SmallInteger ], collection: OrderedCollection, sizeBetween: 1 and: 103 },
	selfReferences: { messages[ .parent ] }
}

OCCommentNode -> {
	parent: { refType: OCProgramNode },
	contents: ByteString | WideString,
	start: { type: SmallInteger, between: 4 and: 30489 },
	stop: { type: SmallInteger, between: 14 and: 172187 },
	invariants: { start < stop }
}

OCLiteralArrayNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	start: { type: SmallInteger, between: 9 and: 30453 },
	stop: { type: SmallInteger, between: 12 and: 811164 },
	isByteArray: Boolean,
	contents: { type: [ OCPatternVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 5 }
	openerSize: { type: SmallInteger, between: 1 and: 2 },
	invariants: { start < stop },
	selfReferences: { contents[ .parent ] }
}

OCLiteralValueNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 1 },
	start: { type: SmallInteger, between: 5 and: 811163 },
	stop: { type: SmallInteger, between: 7 and: 811163 },
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
	arguments: { type: [ OCArrayNode | OCVariableNode | OCLiteralArrayNode | OCLiteralValueNode | OCBlockNode | OCMessageNode | OCPatternVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 2 }
	keywordsPositions: IntegerArray,
	selfReferences: { selector.parent, receiver.parent, arguments[ .parent ] }
}

OCMethodNode -> {
	properties: SmallDictionary?,
	selector: ByteSymbol | WideSymbol,
	keywordsPositions: IntegerArray,
	body: OCSequenceNode,
	source: ByteString | WideString,
	replacements: SortedCollection,
	nodeReplacements: IdentityDictionary,
	selfReferences: { pragmas[ .parent ], body.parent }
}

OCPragmaNode -> {
	parent: { refType: OCProgramNode },
	selector: ByteSymbol,
	keywordsPositions: IntegerArray,
	left: { type: SmallInteger, between: 4 and: 1902 },
	right: { type: SmallInteger, between: 13 and: 1960 },
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
	value: ByteSymbol | WideSymbol
}

OCSequenceNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	leftBar: { type: SmallInteger, between: 6 and: 7291, nullable: true },
	rightBar: { type: SmallInteger, between: 11 and: 7295, nullable: true },
	statements: { type: [ OCArrayNode | OCAssignmentNode | OCBlockNode | OCCascadeNode | OCLiteralArrayNode | OCLiteralValueNode | OCMessageNode | OCReturnNode | OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 178 },
	periods: { type: [ SmallInteger ], collection: OrderedCollection, sizeBetween: 0 and: 177 },
	temporaries: { type: [ OCVariableNode ], collection: OrderedCollection, sizeBetween: 0 and: 36 },
	selfReferences: { statements[ .parent ] }
}

OCVariableNode -> {
	parent: { refType: OCProgramNode },
	properties: SmallDictionary?,
	parentheses: { type: [ Interval ], collection: OrderedCollection, sizeBetween: 0 and: 2 },
	name: ByteSymbol,
	variable: OCUnresolvedVariable,
	start: { type: SmallInteger, between: 3 and: 30614 }
}

OCWarningNotice -> {
	messageText: { oneOf: { ''Use a proper symbol literal'' } },
	node: OCLiteralValueNode
}'
]
