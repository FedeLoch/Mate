Class {
	#name : 'MateLanguageParserTest',
	#superclass : 'TestCase',
	#category : 'Mate-MateLanguage Parser Tests',
	#package : 'Mate',
	#tag : 'MateLanguage Parser Tests'
}

{ #category : 'tests' }
MateLanguageParserTest >> parseTest: source expect: expected [

	self assert: (MateLanguageParser parse: source) equals: expected asOrderedCollection
]

{ #category : 'tests' }
MateLanguageParserTest >> testParseADefinitionWithRelationships [

	self parseTest: 'BlElement -> {
			children: BlChildrenArray,
			parent: { refType: BlElement },
			visuals: (BlCustomVisuals | BlDefaultVisuals),
			constraints: BlLayoutCommonConstraints,
			selfReferences: { children.array[ .parent ] }
	}' expect: {
		MateInstDecl new type: BlElement; instanceVariableDeclarations: {
			MateInstVarDecl new name: 'children'; type: BlChildrenArray.
			MateInstRefVarDecl new name: 'parent'; type: BlElement.
			MateInstVarDecl new name: 'visuals'; type: (BlCustomVisuals | BlDefaultVisuals).
			MateInstVarDecl new name: 'constraints'; type: BlLayoutCommonConstraints.
		}; selfReferences: { MateReferencePath new: { MatePathProp from: 'children' . MatePathProp from: 'array' . MatePathEachProp from: 'parent' }}
	}
]

{ #category : 'tests' }
MateLanguageParserTest >> testParseAsimpleDefinition [

	self parseTest: 'BlLayoutExactResizer -> { size: SmallFloat64 }' expect: {
		MateInstDecl new type: BlLayoutExactResizer; instanceVariableDeclarations: { MateInstVarDecl new name: 'size'; type: SmallFloat64 }
	}
]

{ #category : 'tests' }
MateLanguageParserTest >> testParseAsimpleDefinitionWithAnArray [

	self parseTest: 'OrderedCollection -> {
		array: { type: [ Object ], sizeBetween: 0 and: 1 },
		firstIndex: SmallInteger,
		lastIndex: SmallInteger
	}' expect: {
		MateInstDecl new type: OrderedCollection; instanceVariableDeclarations: {
			MateInstArrayVarDecl new name: 'array'; elementType: Object; sizeBetween: 0 and: 1.
			MateInstVarDecl new name: 'firstIndex'; type: SmallInteger.
			MateInstVarDecl new name: 'lastIndex'; type: SmallInteger
		}
	}
]

{ #category : 'tests' }
MateLanguageParserTest >> testParseAsimpleDefinitionWithAnArrayWithOptionalTypes [

	self parseTest: 'OrderedCollection -> { array: { type: [ BlEllipseGeometry | BlTriangleGeometry ], sizeBetween: 0 and: 1 } }' expect: {
		MateInstDecl new type: OrderedCollection; instanceVariableDeclarations: {
			MateInstArrayVarDecl new name: 'array'; elementType: BlEllipseGeometry | BlTriangleGeometry; sizeBetween: 0 and: 1
		}
	}
]

{ #category : 'tests' }
MateLanguageParserTest >> testParseAsimpleDefinitionWithAnArrayWithParenthesis [

	self parseTest: 'OrderedCollection -> { array: { type: [ (SmallInteger) ], sizeBetween: 0 and: 1 } }' expect: {
		MateInstDecl new type: OrderedCollection; instanceVariableDeclarations: {
			MateInstArrayVarDecl new name: 'array'; elementType: SmallInteger; sizeBetween: 0 and: 1
		}
	}
]

{ #category : 'tests' }
MateLanguageParserTest >> testParseAsimpleDefinitionWithMultipleOptionalTypes [

	self parseTest: 'BlCustomVisuals -> { 
		background: (BlPaintBackground | BlTransparentBackground),
		geometry: (BlRectangleGeometry | BlEllipseGeometry | BlTriangleGeometry),
		clipChildren: Boolean
	}' expect: {
		MateInstDecl new type: BlCustomVisuals; instanceVariableDeclarations: {
			MateInstVarDecl new name: 'background'; type: BlPaintBackground | BlTransparentBackground.
			MateInstVarDecl new name: 'geometry'; type: BlRectangleGeometry | BlEllipseGeometry | BlTriangleGeometry.
			MateInstVarDecl new name: 'clipChildren'; type: Boolean
		}
	}
]

{ #category : 'tests' }
MateLanguageParserTest >> testParseAsimpleDefinitionWithOptionalTypes [

	self parseTest: 'BlLayoutExactResizer -> { size: (BlRectangleGeometry | BlEllipseGeometry | BlTriangleGeometry) }' expect: {
		MateInstDecl new type: BlLayoutExactResizer; instanceVariableDeclarations: { MateInstVarDecl new name: 'size'; type: (BlRectangleGeometry | BlEllipseGeometry | BlTriangleGeometry) }
	}
]

{ #category : 'helpers' }
MateLanguageParserTest >> field: aName in: declarations of: aClass [

	^ (declarations detect: [ :each | each type = aClass ]) instanceVariableDeclarationNamed: aName
]

{ #category : 'helpers' }
MateLanguageParserTest >> shouldReject: source [

	self should: [ MateLanguageParser parse: source ] raise: Error
]

{ #category : 'tests - aliases' }
MateLanguageParserTest >> testParseAliasDefinedAfterItsUse [

	self parseTest: 'BlCustomVisuals -> { geometry: MateGeometry }
		MateGeometry = BlEllipseGeometry | BlTriangleGeometry' expect: {
		MateInstDecl new type: BlCustomVisuals; instanceVariableDeclarations: {
			MateInstVarDecl new name: 'geometry'; type: BlEllipseGeometry | BlTriangleGeometry } }
]

{ #category : 'tests - aliases' }
MateLanguageParserTest >> testParseAliasInsideAUnion [

	| declarations type |

	declarations := MateLanguageParser parse: 'MateGeometry = BlEllipseGeometry | BlTriangleGeometry
		BlCustomVisuals -> { geometry: (MateGeometry | BlRectangleGeometry)? }'.
	type := (self field: 'geometry' in: declarations of: BlCustomVisuals) type.

	self assert: type types asSet equals: { BlEllipseGeometry. BlTriangleGeometry. BlRectangleGeometry } asSet.
	self assert: (self field: 'geometry' in: declarations of: BlCustomVisuals) nullable.
	self assert: type name equals: 'BlRectangleGeometry | MateGeometry'
]

{ #category : 'tests - aliases' }
MateLanguageParserTest >> testParseAliasOfAClass [

	| declarations field |

	declarations := MateLanguageParser parse: 'MateLeaf = MateAge  RefObject -> { name: MateLeaf }'.
	field := self field: 'name' in: declarations of: RefObject.

	self assert: field types asArray equals: { MateAge }.
	self assert: field type name equals: 'MateLeaf'
]

{ #category : 'tests - aliases' }
MateLanguageParserTest >> testParseAliasOfAnAlias [

	| parser declarations field |

	parser := MateLanguageParser new.
	declarations := parser parse: 'MateLeaf = MateAge
		MateShape = MateLeaf | ReferredObject
		RefObject -> { name: MateShape }'.
	field := self field: 'name' in: declarations of: RefObject.

	self assert: field types asSet equals: { MateAge. ReferredObject } asSet.
	self assert: field type name equals: 'MateShape'.
	self assert: (parser aliases keys asSortedCollection: [ :a :b | a <= b ]) asArray equals: #( 'MateLeaf' 'MateShape' ).
	self assert: ((parser aliases at: 'MateShape') aliases collect: #name) asArray equals: #( 'MateLeaf' )
]

{ #category : 'tests - aliases' }
MateLanguageParserTest >> testParseAliasesAreNotDeclarations [

	self parseTest: 'MateGeometry = BlEllipseGeometry | BlTriangleGeometry' expect: #().
	self parseTest: '"shapes" MateGeometry = BlEllipseGeometry "and" MateBound = { type: SmallInteger, atLeast: 0 }' expect: #()
]

{ #category : 'tests - aliases' }
MateLanguageParserTest >> testParseArrayElementTypeAlias [

	| declarations field |

	declarations := MateLanguageParser parse: 'MateGeometry = BlEllipseGeometry | BlTriangleGeometry
		OrderedCollection -> { array: { type: [ MateGeometry ], sizeBetween: 0 and: 2 } }'.
	field := self field: 'array' in: declarations of: OrderedCollection.

	self assert: field equals: (MateInstArrayVarDecl new name: 'array'; elementType: BlEllipseGeometry | BlTriangleGeometry; sizeBetween: 0 and: 2).
	self assert: field elementType name equals: 'MateGeometry'.
	self assert: (field aliases collect: #name) asArray equals: #( 'MateGeometry' )
]

{ #category : 'tests - aliases' }
MateLanguageParserTest >> testParseCollectionFieldAlias [

	| declarations first second |

	declarations := MateLanguageParser parse: 'MateNumbers = { type: [ SmallInteger ], collection: OrderedCollection, sizeBetween: 1 and: 3 }
		BlChildrenArray -> { array: MateNumbers }
		MateArray -> { elementType: MateNumbers }'.
	first := self field: 'array' in: declarations of: BlChildrenArray.
	second := self field: 'elementType' in: declarations of: MateArray.

	self assert: first equals: (MateInstArrayVarDecl new
		name: 'array';
		elementType: SmallInteger;
		collectionClass: OrderedCollection;
		sizeBetween: 1 and: 3).
	self assert: second name equals: 'elementType'.
	self assert: second collectionClass equals: OrderedCollection.
	self deny: first identicalTo: second.
	self assert: first alias identicalTo: second alias
]

{ #category : 'tests - aliases' }
MateLanguageParserTest >> testParseConstrainedFieldAlias [

	self parseTest: 'MateBound = { type: SmallInteger, between: -5 and: 9 }
		MateSpan -> { start: MateBound, stop: MateBound? }' expect: {
		MateInstDecl new type: MateSpan; instanceVariableDeclarations: {
			MateInstVarDecl new name: 'start'; type: SmallInteger; constraint: (MateConstraint between: -5 and: 9).
			MateInstVarDecl new name: 'stop'; type: SmallInteger; constraint: (MateConstraint between: -5 and: 9); nullable: true } }
]

{ #category : 'tests - aliases' }
MateLanguageParserTest >> testParseEachFieldGetsItsOwnCopyOfAnAlias [

	| declarations start stop first second |

	declarations := MateLanguageParser parse: 'MateBound = { type: SmallInteger, atLeast: 0 }
		MateShape = MateAge | ReferredObject
		MateSpan -> { start: MateBound, stop: MateBound }
		RefObject -> { name: MateShape, myLittleObject: MateShape }'.
	start := self field: 'start' in: declarations of: MateSpan.
	stop := self field: 'stop' in: declarations of: MateSpan.
	first := (self field: 'name' in: declarations of: RefObject) type.
	second := (self field: 'myLittleObject' in: declarations of: RefObject) type.

	self deny: start identicalTo: stop.
	self assert: start alias identicalTo: stop alias.
	self assert: start alias name equals: 'MateBound'.
	self deny: first identicalTo: second.
	self assert: first equals: second.
	self assert: (first aliases collect: #name) asArray equals: #( 'MateShape' )
]

{ #category : 'tests - aliases' }
MateLanguageParserTest >> testParseOneOfFieldAlias [

	| declarations kind |

	declarations := MateLanguageParser parse: 'MateKinds = { oneOf: { #open . #closed . nil } }  MateSpan -> { kind: MateKinds }'.
	kind := self field: 'kind' in: declarations of: MateSpan.

	self assert: (kind isKindOf: MateInstOneOfVarDecl).
	self assert: kind name equals: 'kind'.
	self assert: kind options equals: #( #open #closed nil ).
	self assert: kind alias name equals: 'MateKinds'
]

{ #category : 'tests - aliases' }
MateLanguageParserTest >> testParseTypeAlias [

	self parseTest: 'MateGeometry = BlEllipseGeometry | BlTriangleGeometry
		BlCustomVisuals -> { geometry: MateGeometry, clipChildren: Boolean }' expect: {
		MateInstDecl new type: BlCustomVisuals; instanceVariableDeclarations: {
			MateInstVarDecl new name: 'geometry'; type: BlEllipseGeometry | BlTriangleGeometry.
			MateInstVarDecl new name: 'clipChildren'; type: Boolean } }
]

{ #category : 'tests - alias errors' }
MateLanguageParserTest >> testRejectAliasCycles [

	self shouldReject: 'MateLoopA = MateLoopB | MateAge  MateLoopB = MateLoopA  RefObject -> { name: MateLoopA }'.
	self shouldReject: 'MateLoopA = MateLoopA | MateAge  RefObject -> { name: MateAge }'.
	self shouldReject: 'MateLoopA = { type: MateLoopA, atLeast: 0 }  RefObject -> { name: MateAge }'
]

{ #category : 'tests - alias errors' }
MateLanguageParserTest >> testRejectAliasDefinedTwice [

	self shouldReject: 'MateShape = MateAge  MateShape = ReferredObject  RefObject -> { name: MateShape }'
]

{ #category : 'tests - alias errors' }
MateLanguageParserTest >> testRejectAliasNamedLikeAClass [

	self shouldReject: 'MateAge = SmallInteger  RefObject -> { name: MateAge }'.
	self shouldReject: 'BlElement = { type: SmallInteger, atLeast: 0 }'
]

{ #category : 'tests - alias errors' }
MateLanguageParserTest >> testRejectAliasWithoutDefinition [

	self shouldReject: 'RefObject -> { name: MateAge }  MateShape ='.
	self shouldReject: 'MateShape = MateNoSuchClass  RefObject -> { name: MateAge }'
]

{ #category : 'tests - alias errors' }
MateLanguageParserTest >> testRejectFieldAliasInsideATypePosition [

	self shouldReject: 'MateBound = { type: SmallInteger, atLeast: 0 }  MateSpan -> { start: MateBound | MateAge }'.
	self shouldReject: 'MateBound = { type: SmallInteger, atLeast: 0 }  BlChildrenArray -> { array: { type: [ MateBound ], size: 2 } }'.
	self shouldReject: 'MateBound = { type: SmallInteger, atLeast: 0 }  MateShape = MateBound | MateAge  RefObject -> { name: MateShape }'
]

{ #category : 'tests - alias errors' }
MateLanguageParserTest >> testRejectNullableAliasDefinition [

	self shouldReject: 'MateShape = MateAge?  RefObject -> { name: MateShape }'.
	self shouldReject: 'MateShape = (MateAge | ReferredObject)?  RefObject -> { name: MateShape }'
]
