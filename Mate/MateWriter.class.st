Class {
	#name : 'MateWriter',
	#superclass : 'MateGrammarVisitor',
	#category : 'Mate-Writing',
	#package : 'Mate',
	#tag : 'Writing'
}

{ #category : 'writing' }
MateWriter >> definition: type decl: decl [

	^ decl visiting: self from: MateContext new constraint: nil
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
	
	definitions := (grammar typeDeclarations keys asSortedCollection: [ :a :b | a name <= b name ]) inject: OrderedCollection new into: [ :defs :type | | decl |
		decl := grammar typeDeclarations at: type.
		(self shouldHandle: decl) ifTrue: [ defs add: (self definition: type decl: decl) ].
		defs
	].

	^ (String streamContents: [ :stream | (definitions reject: #isEmpty) do: [ :each |
		stream nextPutAll: each ] separatedBy: [ stream cr; cr ] ]) trim
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
		s nextPutAll: (self writeType: decl type constraint: decl constraint nullable: decl nullable)
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
			s nextPutAll: (instVarDecl visiting: self from: context constraint: instVarDecl constraint).
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
			s nextPutAll: (self writeLiteral: option)
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
MateWriter >> writeConstraint: aConstraint on: aStream [

	(aConstraint min notNil and: [ aConstraint max notNil ]) ifTrue: [
		aStream nextPutAll: ', between: '; nextPutAll: (self writeLiteral: aConstraint min); nextPutAll: ' and: '; nextPutAll: (self writeLiteral: aConstraint max) ].
	(aConstraint min notNil and: [ aConstraint max isNil ]) ifTrue: [
		aStream nextPutAll: ', atLeast: '; nextPutAll: (self writeLiteral: aConstraint min) ].
	(aConstraint min isNil and: [ aConstraint max notNil ]) ifTrue: [
		aStream nextPutAll: ', atMost: '; nextPutAll: (self writeLiteral: aConstraint max) ].
	aConstraint hasOptions ifTrue: [
		aStream nextPutAll: ', in: [ '.
		aConstraint options do: [ :each | aStream nextPutAll: (self writeLiteral: each) ] separatedBy: [ aStream nextPutAll: ', ' ].
		aStream nextPutAll: ' ]' ]
]

{ #category : 'writing' }
MateWriter >> writeLiteral: anObject [

	anObject isSymbol ifTrue: [ ^ anObject storeString ].
	anObject isString ifTrue: [ ^ anObject storeString ].
	anObject isInteger ifTrue: [ ^ anObject printString ].
	anObject isFloat ifTrue: [
		anObject isFinite ifFalse: [ self error: 'Cannot write non finite float ', anObject printString ].
		^ anObject printString ].
	(anObject isNil or: [ anObject == true or: [ anObject == false ] ]) ifTrue: [ ^ anObject printString ].
	anObject isBehavior ifTrue: [ ^ anObject name ].

	^ self error: 'Cannot write literal ', anObject printString
]

{ #category : 'writing' }
MateWriter >> writeType: type constraint: aConstraint nullable: isNullable [

	| typeName |
	
	typeName := type name.
	
	(aConstraint isNil and: [ isNullable not ]) ifTrue: [ ^ typeName ].
	(aConstraint isNil and: [ (type isKindOf: MateOptionalType) not ]) ifTrue: [ ^ typeName, '?' ].
	aConstraint isNil ifTrue: [ ^ '(', typeName, ')?' ].

	^ String streamContents: [ :s |
		s nextPutAll: '{ type: '; nextPutAll: typeName.
		self writeConstraint: aConstraint on: s.
		isNullable ifTrue: [ s nextPutAll: ', nullable: true' ].
		s nextPutAll: ' }' ]
]
