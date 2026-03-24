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

	self parseTest: 'BlLayoutExactResizer -> { size: (SmallFloat64 | SmallInteger) }' expect: {
		MateInstDecl new type: BlLayoutExactResizer; instanceVariableDeclarations: { MateInstVarDecl new name: 'size'; type: (SmallFloat64 | SmallInteger) }
	}
]
