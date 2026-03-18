Class {
	#name : 'MateWriter',
	#superclass : 'MateGrammarVisitor',
	#instVars : [
		'builtInTypes'
	],
	#category : 'Mate-Writing',
	#package : 'Mate',
	#tag : 'Writing'
}

{ #category : 'initialization' }
MateWriter >> initialize [

	super initialize.
	builtInTypes := { SmallInteger. Float . SmallFloat64 . Boolean . ByteString . Color . Point }
]

{ #category : 'writing' }
MateWriter >> mateDefinition [

	| defs |

	defs := OrderedCollection new.

	grammar typeDeclarations keysAndValuesDo: [ :type :decl |
		(builtInTypes includes: type) ifFalse: [
			defs add: (self definition: type decl: decl)
		]
	].

	^ String cr join: defs
]

{ #category : 'writing' }
MateWriter >> definition: type decl: decl [

	^ decl visit: self from: nil constraint: nil
]

{ #category : 'visiting' }
MateWriter >> visitInstanceDeclaration: decl from: context [

	^ String streamContents: [ :s |
		s nextPutAll: decl name.
		s nextPutAll: ' -> {'.
		
		decl instanceVariableDeclarations doWithIndex: [ :instVarDecl :index |
			index > 1 ifTrue: [ s nextPut: $, ].
			s cr; nextPutAll: '	'.
			s nextPutAll: (instVarDecl visit: self from: context constraint: instVarDecl constraint).
		].
		
		decl selfReferences ifNotEmpty: [ :refs |
			s nextPut: $,.
			s cr; nextPutAll: '	'.
			s nextPutAll: 'selfReferences: { '.
			refs doWithIndex: [ :ref :index |
				index > 1 ifTrue: [ s nextPutAll: ', ' ].
				s nextPutAll: (self writeReferencePath: ref).
			].
			s nextPutAll: ' }'.
		].
		
		s cr; nextPutAll: '}'.
	]
]

{ #category : 'visiting' }
MateWriter >> visitInstVarDecl: instVarDecl from: context [

	^ String streamContents: [ :s |
		s nextPutAll: instVarDecl name.
		s nextPutAll: ': '.
		s nextPutAll: (self writeType: instVarDecl type constraint: instVarDecl constraint).
	]
]

{ #category : 'visiting' }
MateWriter >> visitArrayDecl: decl from: context [

	^ String streamContents: [ :s |
		s nextPutAll: decl name.
		s nextPutAll: ': { array: { type: [ '.
		s nextPutAll: decl elementType name.
		s nextPutAll: ' ], sizeBetween: '.
		s nextPutAll: decl minSize asString.
		s nextPutAll: ' and: '.
		s nextPutAll: decl maxSize asString.
		s nextPutAll: ' } }'.
	]
]

{ #category : 'visiting' }
MateWriter >> visitOneOfDecl: decl from: context [

	^ String streamContents: [ :s |
		s nextPutAll: decl name.
		s nextPutAll: ': { oneOf: { '.
		decl options doWithIndex: [ :option :index |
			index > 1 ifTrue: [ s nextPutAll: ' . ' ].
			s nextPut: $#.
			s nextPutAll: option asString.
		].
		s nextPutAll: ' } }'.
	]
]

{ #category : 'visiting' }
MateWriter >> visitInstRefDecl: decl from: context [

	^ String streamContents: [ :s |
		s nextPutAll: decl name.
		s nextPutAll: ': { refType: '.
		s nextPutAll: decl type name.
		s nextPutAll: ' }'.
	]
]

{ #category : 'visiting' }
MateWriter >> visitBuiltinDeclaration: decl from: context [

	^ decl type name
]

{ #category : 'visiting' }
MateWriter >> visitBuiltinDeclaration: decl from: context constraint: aConstraint [

	^ decl type name
]

{ #category : 'visiting' }
MateWriter >> visitClassDeclaration: decl from: context [

	^ decl type name
]

{ #category : 'writing' }
MateWriter >> writeType: aType constraint: aConstraint [

	"Write a type with its optional constraint"
	
	^ String streamContents: [ :s |
		(aType isKindOf: MateOptionalType) ifTrue: [
			| types |
			types := aType types asArray.
			types doWithIndex: [ :t :index |
				index > 1 ifTrue: [ s nextPutAll: ' | ' ].
				s nextPutAll: t name.
			].
		] ifFalse: [
			aConstraint ifNotNil: [
				| universe |
				universe := aConstraint universe.
				s nextPutAll: '{ type: '.
				s nextPutAll: aType name.
				(universe isKindOf: Interval) ifTrue: [
					(universe last = universe last class maxVal) ifTrue: [
						s nextPutAll: ', greaterThan: '.
						s nextPutAll: universe first asString.
					] ifFalse: [
						s nextPutAll: ', between: '.
						s nextPutAll: universe first asString.
						s nextPutAll: ' and: '.
						s nextPutAll: universe last asString.
					].
				].
				s nextPutAll: ' }'.
			] ifNil: [
				s nextPutAll: aType name.
			].
		].
	]
]

{ #category : 'writing' }
MateWriter >> writeReferencePath: aReferencePath [

	^ String streamContents: [ :s |
		aReferencePath path do: [ :segment |
			(segment isKindOf: MatePathEachProp) ifTrue: [
				s nextPutAll: '[ .'.
				s nextPutAll: segment prop.
				s nextPutAll: ' ]'.
			] ifFalse: [
				s nextPutAll: '.'.
				s nextPutAll: segment prop.
			].
		].
	]
]
