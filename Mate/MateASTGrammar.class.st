Class {
	#name : 'MateASTGrammar',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Examples',
	#package : 'Mate',
	#tag : 'Grammar Examples'
}

{ #category : 'accessing' }
MateASTGrammar >> defineObjectGraph [

	^ 'Pragma -> {
	selector: ByteSymbol,
	arguments: { type: [ ByteString ], sizeBetween: 0 and: 3 }
}

AdditionalMethodState -> {
	selector: ByteSymbol
}

OCReturnNode -> {
	parent: OCSequenceNode,
	value: OCArrayNode | OCBlockNode | OCAssignmentNode | OCVariableNode | OCLiteralValueNode | OCLiteralArrayNode | OCCascadeNode | OCMessageNode,
	start: SmallInteger,
	properties: SmallDictionary
}

OCBlockNode -> {
	parent: OCSequenceNode,
	left: SmallInteger,
	right: SmallInteger,
	colons: OrderedCollection,
	arguments: OrderedCollection,
	bar: SmallInteger,
	body: OCSequenceNode,
	scope: OCBlockScope
}

OCCascadeNode -> {
	parent: OCSequenceNode,
	messages: OrderedCollection,
	semicolons: OrderedCollection,
	properties: SmallDictionary
}

SmallDictionary -> {
	keys: { type: [ ByteSymbol ], sizeBetween: 0 and: 3 },
	values: { type: [ CompiledMethod ], sizeBetween: 0 and: 3 },
	size: SmallInteger
}

OCPragmaNode -> {
	parent: OCMethodNode,
	selector: ByteSymbol,
	keywordsPositions: IntegerArray,
	arguments: OrderedCollection,
	left: SmallInteger,
	right: SmallInteger,
	pragma: Pragma
}

OCMessageNode -> {
	parent: OCSequenceNode,
	receiver: OCArrayNode | OCBlockNode | OCAssignmentNode | OCVariableNode | OCLiteralValueNode | OCLiteralArrayNode | OCCascadeNode | OCMessageNode,
	selector: OCSelectorNode,
	keywordsPositions: IntegerArray,
	arguments: OrderedCollection,
	properties: SmallDictionary,
	parentheses: OrderedCollection
}

TemporaryVariable -> {
	name: ByteString,
	escaping: Boolean,
	scope: OCMethodScope
}

OCCommentNode -> {
	parent: OCVariableNode | OCMethodNode,
	contents: WideString | ByteString,
	start: SmallInteger,
	stop: SmallInteger
}

OCArrayNode -> {
	parent: OCSequenceNode,
	left: SmallInteger,
	right: SmallInteger,
	statements: OrderedCollection,
	periods: OrderedCollection
}

OrderedDictionary -> {
	dictionary: Dictionary,
	orderedKeys: { type: [ ByteSymbol ], sizeBetween: 0 and: 41 }
}

OCSequenceNode -> {
	parent: OCMethodNode,
	leftBar: SmallInteger,
	rightBar: SmallInteger,
	statements: OrderedCollection,
	periods: OrderedCollection,
	temporaries: OrderedCollection,
	properties: SmallDictionary
}

OCAssignmentNode -> {
	parent: OCSequenceNode,
	variable: OCVariableNode,
	assignment: SmallInteger,
	value: OCArrayNode | OCBlockNode | OCAssignmentNode | OCVariableNode | OCLiteralValueNode | OCLiteralArrayNode | OCCascadeNode | OCMessageNode,
	properties: SmallDictionary,
	parentheses: OrderedCollection
}

OrderedCollection -> {
	array: { type: [ OCMessageNode | OCAssignmentNode ], sizeBetween: 0 and: 178 },
	firstIndex: SmallInteger,
	lastIndex: SmallInteger
}

OCMethodScope -> {
	outerScope: OCMethodSemanticScope,
	tempVars: OrderedDictionary,
	copiedVars: OrderedDictionary,
	tempVector: OrderedDictionary,
	id: SmallInteger,
	node: OCMethodNode,
	isClean: Boolean,
	tempVectorVar: TemporaryVariable
}

OCMethodNode -> {
	properties: SmallDictionary,
	scope: OCMethodScope,
	selector: ByteSymbol | WideSymbol,
	keywordsPositions: IntegerArray,
	body: OCSequenceNode,
	source: WideString | ByteString,
	arguments: OrderedCollection,
	pragmas: { type: [ Object ], sizeBetween: 0 and: 0 },
	replacements: SortedCollection,
	nodeReplacements: IdentityDictionary,
	compilationContext: OCCompilationContext
}

OCVariableNode -> {
	parent: OCSequenceNode | OCMethodNode,
	name: ByteSymbol,
	variable: CopiedLocalVariable | SelfVariable | OCVectorTempVariable | InstanceVariableSlot | ClassVariable | UndeclaredVariable | TemporaryVariable | ArgumentVariable | GlobalVariable,
	start: SmallInteger,
	properties: SmallDictionary
}

OCLiteralValueNode -> {
	parent: OCSequenceNode,
	properties: SmallDictionary,
	start: SmallInteger,
	stop: SmallInteger,
	value: SmallFloat64 | ByteSymbol | ByteString | SmallInteger | Boolean,
	sourceText: ByteString
}

Set -> {
	tally: SmallInteger,
	array: { type: [ ByteSymbol ], sizeBetween: 0 and: 13 }
}

SortedCollection -> {
	array: { type: [ Object ], sizeBetween: 0 and: 0 },
	firstIndex: SmallInteger,
	lastIndex: SmallInteger,
	sortBlock: CleanBlockClosure
}

OCLiteralArrayNode -> {
	parent: OCSequenceNode,
	start: SmallInteger,
	stop: SmallInteger,
	isByteArray: Boolean,
	contents: OrderedCollection,
	openerSize: SmallInteger
}

IdentityDictionary -> {
	tally: SmallInteger,
	array: { type: [ Object ], sizeBetween: 0 and: 0 }
}

OCCompilationContext -> {
	options: Set,
	environment: SystemEnvironment,
	astTransformPlugins: OrderedCollection,
	astParseTransformPlugins: OrderedCollection,
	semanticScope: OCMethodSemanticScope,
	semanticAnalysisNeeded: Boolean
}

ArgumentVariable -> {
	name: ByteSymbol,
	escaping: ByteSymbol | Boolean,
	scope: OCMethodScope,
	usage: ByteSymbol
}'
]
