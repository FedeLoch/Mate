Class {
	#name : 'MateViolationInjector',
	#superclass : 'Object',
	#instVars : [
		'generator',
		'random',
		'rewards',
		'visits',
		'explorationConstant'
	],
	#category : 'Mate-Violations',
	#package : 'Mate',
	#tag : 'Violations'
}

{ #category : 'accessing' }
MateViolationInjector class >> allKinds [

	^ #( #range #oneOf #type #nil #size #element #reference #invariant )
]

{ #category : 'selecting' }
MateViolationInjector >> chooseKindFrom: kinds [

	| candidates unvisited total kind |

	candidates := (kinds asSortedCollection: [ :a :b | a <= b ]) asArray.
	unvisited := candidates select: [ :each | (visits at: each ifAbsent: [ 0 ]) = 0 ].

	kind := unvisited
		ifNotEmpty: [ unvisited atRandom: random ]
		ifEmpty: [
			total := candidates inject: 0 into: [ :sum :each | sum + (visits at: each) ].
			candidates detectMax: [ :each | | kindVisits |
				kindVisits := visits at: each.
				((rewards at: each ifAbsent: [ 0 ]) / kindVisits)
					+ (explorationConstant * ((total ln / kindVisits) sqrt)) ] ].

	visits at: kind put: (visits at: kind ifAbsent: [ 0 ]) + 1.
	^ kind
]

{ #category : 'sites' }
MateViolationInjector >> elementSitesFor: owner declaration: decl [

	^ (self arrayDeclarationsOf: decl) inject: OrderedCollection new into: [ :sites :each | | collection |
		collection := owner instVarNamed: each name.
		(self isCollection: collection of: each) ifTrue: [
			collection isEmpty ifFalse: [
				(self invalidValueFor: [ :value | (each elementType acceptType: value class) not ]) ifNotNil: [ :invalid |
					sites add: (self site: owner field: each name block: [ | elements |
						elements := collection asArray copy.
						elements at: (random nextInteger: elements size) put: invalid.
						self
							set: each name
							of: owner
							to: (each collectionFrom: elements)
							kind: #element
							description: 'holds a ', invalid class name, ' instead of ', each elementType name ]) ] ] ].
		sites ]
]

{ #category : 'accessing' }
MateViolationInjector >> explorationConstant: aNumber [

	explorationConstant := aNumber
]

{ #category : 'accessing' }
MateViolationInjector >> generator: aGenerator [

	generator := aGenerator
]

{ #category : 'accessing' }
MateViolationInjector >> grammar [

	^ generator grammar
]

{ #category : 'initialization' }
MateViolationInjector >> initialize [

	super initialize.
	rewards := Dictionary new.
	visits := Dictionary new.
	explorationConstant := 2
]

{ #category : 'injecting' }
MateViolationInjector >> inject: count into: derivation kinds: kinds random: aRandom [

	| unknown violations |

	unknown := kinds reject: [ :each | self class allKinds includes: each ].
	unknown ifNotEmpty: [ self error: 'Unknown violation kinds ', unknown asArray printString ].

	random := aRandom.
	violations := OrderedCollection new.

	count timesRepeat: [ | sites |
		sites := self sitesIn: derivation kinds: kinds excluding: violations.
		sites ifNotEmpty: [ | kind |
			kind := self chooseKindFrom: sites keys.
			violations add: ((sites at: kind) atRandom: random) value ] ].

	^ violations asArray
]

{ #category : 'sites' }
MateViolationInjector >> invariantSitesFor: owner declaration: decl [

	^ decl invariants inject: OrderedCollection new into: [ :sites :invariant | | left right |
		left := owner instVarNamed: invariant left.
		right := owner instVarNamed: invariant right.
		(left isNumber and: [ right isNumber ]) ifTrue: [
			sites add: (self site: owner field: invariant left block: [ self violate: invariant on: owner ]) ].
		sites ]
]

{ #category : 'values' }
MateViolationInjector >> invalidOptionFor: options [

	^ { #mateInvalidOption. 'mate invalid option'. -1. 1000001. Object new }
		detect: [ :each | (options includes: each) not ]
		ifNone: [ nil ]
]

{ #category : 'values' }
MateViolationInjector >> invalidValueFor: isInvalid [

	^ { 'mate invalid'. 42. #mateInvalid. 3.5. true. Object new }
		detect: isInvalid
		ifNone: [ nil ]
]

{ #category : 'testing' }
MateViolationInjector >> isCollection: aValue of: arrayDecl [

	^ aValue notNil and: [ aValue isCollection and: [ aValue isKindOf: arrayDecl collectionClass ] ]
]

{ #category : 'sites' }
MateViolationInjector >> nilSitesFor: owner declaration: decl [

	^ decl instanceVariableDeclarations inject: OrderedCollection new into: [ :sites :each |
		((each isKindOf: MateInstRefVarDecl) not
			and: [ each nullable not
			and: [ (owner instVarNamed: each name) notNil
			and: [ ((each isKindOf: MateInstOneOfVarDecl) and: [ each options includes: nil ]) not ] ] ])
				ifTrue: [
					sites add: (self site: owner field: each name block: [
						self set: each name of: owner to: nil kind: #nil description: 'mandatory field set to nil' ]) ].
		sites ]
]

{ #category : 'sites' }
MateViolationInjector >> oneOfSitesFor: owner declaration: decl [

	^ (decl instanceVariableDeclarations select: [ :each | each isKindOf: MateInstOneOfVarDecl ])
		inject: OrderedCollection new
		into: [ :sites :each |
			(self invalidOptionFor: each options) ifNotNil: [ :invalid |
				sites add: (self site: owner field: each name block: [
					self set: each name of: owner to: invalid kind: #oneOf description: 'not one of ', each options printString ]) ].
			sites ]
]

{ #category : 'accessing' }
MateViolationInjector >> ownersIn: derivation [

	| seen owners |

	seen := IdentitySet new.
	owners := OrderedCollection new.

	derivation allNodes do: [ :node | | instance |
		instance := node instance.
		(instance notNil
			and: [ (seen includes: instance) not
			and: [ (self grammar typeDeclarations at: instance class ifAbsent: [ nil ]) isKindOf: MateInstDecl ] ])
				ifTrue: [
					seen add: instance.
					owners add: instance ] ].

	^ owners
]

{ #category : 'sites' }
MateViolationInjector >> rangeSitesFor: owner declaration: decl [

	^ (decl instanceVariableDeclarations select: [ :each | each class == MateInstVarDecl and: [ each constraint notNil ] ])
		inject: OrderedCollection new
		into: [ :sites :each |
			(owner instVarNamed: each name) ifNotNil: [
				(self valuesOutside: each constraint) ifNotEmpty: [ :invalidValues |
					sites add: (self site: owner field: each name block: [
						self
							set: each name
							of: owner
							to: (invalidValues atRandom: random)
							kind: #range
							description: 'outside ', each constraint printString ]) ] ].
			sites ]
]

{ #category : 'accessing' }
MateViolationInjector >> arrayDeclarationsOf: decl [

	^ decl instanceVariableDeclarations select: [ :each | each isKindOf: MateInstArrayVarDecl ]
]

{ #category : 'sites' }
MateViolationInjector >> referenceSitesFor: owner declaration: decl [

	^ decl selfReferences inject: OrderedCollection new into: [ :sites :path | | field |
		field := path path last prop.
		([ path path last ownersIn: (path targetsFrom: owner) ] on: Error do: [ :e | #() ]) do: [ :target |
			sites add: (self site: target field: field block: [
				self
					set: field
					of: target
					to: nil
					kind: #reference
					description: 'no longer points back to its ', owner class name, ' through ', (MateWriter new writeReferencePath: path) ]) ].
		sites ]
]

{ #category : 'rewards' }
MateViolationInjector >> reward: kind with: improvement [

	rewards at: kind put: (rewards at: kind ifAbsent: [ 0 ]) + improvement
]

{ #category : 'accessing' }
MateViolationInjector >> rewards [

	^ rewards
]

{ #category : 'mutating' }
MateViolationInjector >> set: fieldName of: owner to: aValue kind: kind description: aString [

	| before |

	before := owner instVarNamed: fieldName.
	owner instVarNamed: fieldName put: aValue.

	^ MateViolation
		kind: kind
		owner: owner
		field: fieldName
		before: before
		after: aValue
		description: aString
]

{ #category : 'sites' }
MateViolationInjector >> site: owner field: fieldName block: aBlock [

	^ { owner. fieldName. aBlock }
]

{ #category : 'sites' }
MateViolationInjector >> sitesIn: derivation kinds: kinds excluding: violations [

	| sites |

	sites := Dictionary new.

	(self ownersIn: derivation) do: [ :owner | | decl |
		decl := self grammar typeDeclarations at: owner class.
		kinds do: [ :kind |
			(self perform: (kind , 'SitesFor:declaration:') asSymbol with: owner with: decl) do: [ :site |
				(violations anySatisfy: [ :each | each owner == site first and: [ each field = site second ] ]) ifFalse: [
					(sites at: kind ifAbsentPut: [ OrderedCollection new ]) add: site third ] ] ] ].

	^ sites
]

{ #category : 'sites' }
MateViolationInjector >> sizeSitesFor: owner declaration: decl [

	^ (self arrayDeclarationsOf: decl) inject: OrderedCollection new into: [ :sites :each | | collection |
		collection := owner instVarNamed: each name.
		(self isCollection: collection of: each) ifTrue: [
			sites add: (self site: owner field: each name block: [ self violateSizeOf: each in: owner ]) ].
		sites ]
]

{ #category : 'sites' }
MateViolationInjector >> typeSitesFor: owner declaration: decl [

	^ decl instanceVariableDeclarations inject: OrderedCollection new into: [ :sites :each |
		(owner instVarNamed: each name) ifNotNil: [
			(each isKindOf: MateInstArrayVarDecl)
				ifTrue: [
					sites add: (self site: owner field: each name block: [
						self set: each name of: owner to: 42 kind: #type description: 'not a ', each collectionClass name ]) ]
				ifFalse: [
					each class == MateInstVarDecl ifTrue: [
						(self invalidValueFor: [ :value | (each acceptType: value class) not ]) ifNotNil: [ :invalid |
							sites add: (self site: owner field: each name block: [
								self set: each name of: owner to: invalid kind: #type description: 'not a ', each type name ]) ] ] ] ].
		sites ]
]

{ #category : 'values' }
MateViolationInjector >> valuesOutside: aConstraint [

	| values |

	aConstraint hasOptions ifTrue: [
		^ (self invalidOptionFor: aConstraint options) ifNil: [ #() ] ifNotNil: [ :invalid | { invalid } ] ].

	values := OrderedCollection new.
	aConstraint max ifNotNil: [ :max |
		values add: (max isInteger ifTrue: [ max + 1 ] ifFalse: [ max asFloat successor ]) ].
	aConstraint min ifNotNil: [ :min |
		values add: (min isInteger ifTrue: [ min - 1 ] ifFalse: [ min asFloat predecessor ]) ].

	^ values asArray
]

{ #category : 'mutating' }
MateViolationInjector >> violate: invariant on: owner [

	| left right |

	left := owner instVarNamed: invariant left.
	right := owner instVarNamed: invariant right.

	invariant operator = '=' ifTrue: [
		^ self set: invariant right of: owner to: left + 1 kind: #invariant description: 'breaks ', invariant printString ].

	(invariant operator = '<=' and: [ left ~= right ]) ifTrue: [
		owner instVarNamed: invariant right put: left.
		^ self set: invariant left of: owner to: right kind: #invariant description: 'breaks ', invariant printString, ' by swapping both fields' ].

	^ self
		set: invariant left
		of: owner
		to: (invariant operator = '<' ifTrue: [ right ] ifFalse: [ right + 1 ])
		kind: #invariant
		description: 'breaks ', invariant printString
]

{ #category : 'mutating' }
MateViolationInjector >> violateSizeOf: arrayDecl in: owner [

	| elements collection attempts |

	elements := (owner instVarNamed: arrayDecl name) asArray.

	(arrayDecl minSize > 0 and: [ random next < 0.5 ]) ifTrue: [
		^ self
			set: arrayDecl name
			of: owner
			to: (arrayDecl collectionFrom: (elements first: arrayDecl minSize - 1))
			kind: #size
			description: 'fewer than ', arrayDecl minSize printString, ' elements' ].

	collection := arrayDecl collectionFrom: elements.
	attempts := 0.
	[ collection size <= arrayDecl maxSize and: [ attempts < 100 ] ] whileTrue: [
		attempts := attempts + 1.
		elements := elements copyWith: (generator gen: ((MateOptionalType typesOf: arrayDecl elementType) atRandom: random)).
		collection := arrayDecl collectionFrom: elements ].

	^ self
		set: arrayDecl name
		of: owner
		to: collection
		kind: #size
		description: 'more than ', arrayDecl maxSize printString, ' elements'
]

{ #category : 'accessing' }
MateViolationInjector >> visits [

	^ visits
]
