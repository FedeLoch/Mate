Class {
	#name : 'MateWriter',
	#superclass : 'MateGrammarVisitor',
	#category : 'Mate-Writing',
	#package : 'Mate',
	#tag : 'Writing'
}

{ #category : 'writing' }
MateWriter >> definition: type decl: decl [

	^ decl visit: self from: MateContext new constraint: nil
]

{ #category : 'writing' }
MateWriter >> eachProp: prop [

	^ String streamContents: [ :s |
		s nextPutAll: '[ .'.
		s nextPutAll: prop.
		s nextPutAll: ' ]'
	]
]

{ #category : 'writing' }
MateWriter >> mateDefinition [

	| definitions |
	
	definitions := grammar typeDeclarations keys inject: OrderedCollection new into: [ :defs :type | | decl |
		decl := grammar typeDeclarations at: type.
		(self shouldHandle: decl) ifTrue: [ defs add: (self definition: type decl: decl) ].
		defs
	].

	^ (String cr join: definitions) trim
]

{ #category : 'writing' }
MateWriter >> mateDefinition: type [

	^ self definition: type decl: (grammar typeDeclarations at: type)
]

{ #category : 'writing' }
MateWriter >> prop: prop index: index [

	^ String streamContents: [ :s |
		index > 1 ifTrue: [ s nextPutAll: '.' ].
		s nextPutAll: prop
	]
]

{ #category : 'writing' }
MateWriter >> shouldHandle: decl [

	^ decl isBuiltIn not
]

{ #category : 'visiting' }
MateWriter >> visitArrayDecl: decl from: context [

	^ String streamContents: [ :s |
		s nextPutAll: decl name.
		s nextPutAll: ': { type: [ '.
		s nextPutAll: decl elementType name.
		s nextPutAll: ' ], sizeBetween: '.
		s nextPutAll: decl minSize asString.
		s nextPutAll: ' and: '.
		s nextPutAll: decl maxSize asString.
		s nextPutAll: ' }'
	]
]

{ #category : 'visiting' }
MateWriter >> visitBuiltinDeclaration: decl from: context [

	^ decl type name
]

{ #category : 'visiting' }
MateWriter >> visitClassDeclaration: decl from: context [

	^ decl type name
]

{ #category : 'visiting' }
MateWriter >> visitInstRefDecl: decl from: context [

	^ String streamContents: [ :s |
		s nextPutAll: decl name.
		s nextPutAll: ': { refType: '.
		s nextPutAll: decl type name.
		s nextPutAll: ' }'
	]
]

{ #category : 'visiting' }
MateWriter >> visitInstVarDecl: decl from: context [

	^ String streamContents: [ :s |
		s nextPutAll: decl name.
		s nextPutAll: ': '.
		s nextPutAll: (self writeType: decl type constraint: decl constraint)
	]
]

{ #category : 'visiting' }
MateWriter >> visitInstanceDeclaration: decl from: context [

	decl instanceVariableDeclarations ifEmpty: [ ^ '' ].

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
		
		s cr; nextPutAll: '}'
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
			s nextPutAll: option asString
		].
		s nextPutAll: ' } }'
	]
]

{ #category : 'writing' }
MateWriter >> writeReferencePath: path [

	^ String streamContents: [ :s |
		path path doWithIndex: [ :segment :index |
			s nextPutAll: (segment isEach ifTrue: [
				self eachProp: segment prop
			] ifFalse: [ self prop: segment prop index: index ])
		]
	]
]

{ #category : 'writing' }
MateWriter >> writeType: type constraint: aConstraint [

	^ String streamContents: [ :s |
		(type isKindOf: MateOptionalType) ifTrue: [ | types |
			types := type types asArray.
			types doWithIndex: [ :t :index |
				index > 1 ifTrue: [ s nextPutAll: ' | ' ].
				s nextPutAll: t name
			]
		] ifFalse: [
			aConstraint ifNotNil: [ | universe |
				universe := aConstraint universe.
				s nextPutAll: '{ type: '.
				s nextPutAll: type name.
				(universe isKindOf: Interval) ifTrue: [
					(universe last = universe last class maxVal) ifTrue: [
						s nextPutAll: ', greaterThan: '.
						s nextPutAll: universe first asString
					] ifFalse: [
						s nextPutAll: ', between: '.
						s nextPutAll: universe first asString.
						s nextPutAll: ' and: '.
						s nextPutAll: universe last asString
					]
				].
				s nextPutAll: ' }'.
			] ifNil: [
				s nextPutAll: type name
			]
		]
	]
]
