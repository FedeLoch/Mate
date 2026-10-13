Class {
	#name : 'MateGrammarInferrer',
	#superclass : 'Object',
	#instVars : [
		'observer',
		'minimumSupport',
		'maxEnumerationSize',
		'enumerationRatio',
		'maxPathLength',
		'findings',
		'backReferences',
		'referenceFields'
	],
	#category : 'Mate-Inference',
	#package : 'Mate',
	#tag : 'Inference'
}

{ #category : 'relationships' }
MateGrammarInferrer >> acceptBackReference: steps for: aClass ownerClasses: ownerClasses support: support [

	| path |

	path := MateReferencePath new: steps asArray.
	(backReferences at: aClass ifAbsentPut: [ OrderedCollection new ]) add: path.
	ownerClasses do: [ :ownerClass |
		referenceFields at: { ownerClass. steps last prop } put: aClass ].

	self
		record: #backReference
		on: aClass
		field: nil
		description: (MateWriter new writeReferencePath: path)
		support: support
		accepted: true
]

{ #category : 'declarations' }
MateGrammarInferrer >> collectionDeclarationFor: profile in: aClass [

	| collectionClasses elements decl sizes |

	collectionClasses := profile collectionClasses.
	collectionClasses size > 1 ifTrue: [
		self record: #unsupported on: aClass field: profile name description: 'holds different collection classes ', collectionClasses asArray printString support: profile observationCount accepted: false.
		^ nil ].

	elements := profile elements reject: #isNil.
	(elements anySatisfy: [ :each | each isBehavior or: [ observer isUnsupported: each ] ]) ifTrue: [
		self record: #unsupported on: aClass field: profile name description: 'holds collections of classes or unsupported objects' support: profile observationCount accepted: false.
		^ nil ].

	decl := MateInstArrayVarDecl new name: profile name.
	decl collectionClass: collectionClasses anyOne.
	decl elementType: (self unionOf: elements).

	sizes := profile sizes.
	sizes size >= minimumSupport
		ifTrue: [
			decl sizeBetween: sizes min and: sizes max.
			self record: #size on: aClass field: profile name description: 'sizeBetween: ', sizes min printString, ' and: ', sizes max printString support: sizes size accepted: true ]
		ifFalse: [
			decl sizeBetween: 0 and: sizes max.
			self record: #size on: aClass field: profile name description: 'minimum size ', sizes min printString, ' generalized to 0' support: sizes size accepted: false ].

	^ decl
]

{ #category : 'declarations' }
MateGrammarInferrer >> declarationFor: aClass [

	| instances fieldDeclarations |

	instances := observer instancesOf: aClass.

	fieldDeclarations := aClass allInstVarNames
		collect: [ :field |
			self
				fieldDeclarationFor: (MateFieldProfile
					name: field
					values: (instances collect: [ :each | each instVarNamed: field ])
					observer: observer)
				in: aClass ]
		thenSelect: #notNil.

	^ MateInstDecl new
		type: aClass;
		instanceVariableDeclarations: fieldDeclarations asArray;
		selfReferences: (backReferences at: aClass ifAbsent: [ #() ]) asArray;
		invariants: (self invariantsFor: aClass);
		yourself
]

{ #category : 'accessing' }
MateGrammarInferrer >> enumerationRatio: aNumber [

	enumerationRatio := aNumber
]

{ #category : 'declarations' }
MateGrammarInferrer >> fieldDeclarationFor: profile in: aClass [

	| decl |

	profile allNil ifTrue: [
		self record: #skipped on: aClass field: profile name description: 'always nil, no type can be inferred' support: profile observationCount accepted: false.
		^ nil ].

	profile isUnsupported ifTrue: [
		self record: #unsupported on: aClass field: profile name description: 'holds blocks, methods, processes or other unsupported objects' support: profile observationCount accepted: false.
		^ nil ].

	referenceFields at: { aClass. profile name } ifPresent: [ :target |
		^ MateInstRefVarDecl new name: profile name; type: target ].

	profile isClassValued ifTrue: [ ^ self oneOfDeclarationFor: profile in: aClass ].

	profile isCollectionValued ifTrue: [ ^ self collectionDeclarationFor: profile in: aClass ].

	(self isEnumeration: profile in: aClass) ifTrue: [ ^ self oneOfDeclarationFor: profile in: aClass ].

	decl := MateInstVarDecl new
		name: profile name;
		type: (self unionOf: profile nonNilValues);
		yourself.

	profile nilCount > 0 ifTrue: [
		decl nullable: true.
		self record: #nullable on: aClass field: profile name description: 'nil in ', profile nilCount printString, ' of ', profile observationCount printString, ' observations' support: profile observationCount accepted: true ].

	profile isNumeric ifTrue: [ decl constraint: (self numericConstraintFor: profile in: aClass) ].

	^ decl
]

{ #category : 'accessing' }
MateGrammarInferrer >> findings [

	findings ifNil: [ self grammar ].
	^ findings
]

{ #category : 'inferring' }
MateGrammarInferrer >> grammar [

	| grammar |

	findings := OrderedCollection new.
	backReferences := Dictionary new.
	referenceFields := Dictionary new.

	self inferBackReferences.

	grammar := MateOGGrammar new.
	(observer observedClasses reject: [ :each | grammar typeDeclarations includesKey: each ]) do: [ :each |
		grammar addTypeDeclaration: (self declarationFor: each) ].

	self inferSharing.

	^ grammar
]

{ #category : 'relationships' }
MateGrammarInferrer >> holds: steps for: aClass [

	| path support ownerClasses field |

	path := MateReferencePath new: steps asArray.
	field := steps last prop.
	support := 0.
	ownerClasses := Set new.

	(observer instancesOf: aClass) do: [ :instance | | owners |
		owners := [ steps last ownersIn: (path targetsFrom: instance) ] on: Error do: [ :e | ^ nil ].
		owners do: [ :owner |
			([ (owner instVarNamed: field) == instance ] on: Error do: [ :e | false ]) ifFalse: [ ^ nil ].
			ownerClasses add: owner class ].
		support := support + owners size ].

	support = 0 ifTrue: [ ^ nil ].

	ownerClasses do: [ :ownerClass |
		(referenceFields includesKey: { ownerClass. field }) ifTrue: [ ^ nil ].
		(observer instancesOf: ownerClass) do: [ :owner | | target |
			target := owner instVarNamed: field.
			target ifNotNil: [
				((target isKindOf: aClass) and: [
					([ (steps last ownersIn: (path targetsFrom: target)) identityIncludes: owner ] on: Error do: [ :e | false ]) ])
						ifFalse: [ ^ nil ] ] ] ].

	^ { ownerClasses. support }
]

{ #category : 'relationships' }
MateGrammarInferrer >> inferBackReferences [

	1 to: maxPathLength do: [ :length |
		observer observedClasses do: [ :aClass |
			(self pathsFrom: aClass length: length) do: [ :steps |
				(self holds: steps for: aClass) ifNotNil: [ :result |
					self acceptBackReference: steps for: aClass ownerClasses: result first support: result second ] ] ] ]
]

{ #category : 'relationships' }
MateGrammarInferrer >> inferSharing [

	| incoming |

	incoming := IdentityDictionary new.

	observer observedClasses do: [ :aClass |
		(observer instancesOf: aClass) do: [ :instance |
			aClass allInstVarNames do: [ :field |
				(referenceFields includesKey: { aClass. field }) ifFalse: [ | value |
					value := instance instVarNamed: field.
					((observer isCollectionValue: value)
						ifTrue: [ observer elementsOf: value ]
						ifFalse: [ { value } ]) do: [ :target |
							(observer isObserved: target) ifTrue: [
								incoming at: target put: (incoming at: target ifAbsent: [ 0 ]) + 1 ] ] ] ] ] ].

	observer observedClasses do: [ :aClass | | shared |
		shared := (observer instancesOf: aClass) count: [ :each | (incoming at: each ifAbsent: [ 0 ]) > 1 ].
		shared > 0 ifTrue: [
			self
				record: #sharing
				on: aClass
				field: nil
				description: shared printString, ' instances are referenced from more than one place; generated graphs will hold separate copies'
				support: (observer instancesOf: aClass) size
				accepted: false ] ]
]

{ #category : 'initialization' }
MateGrammarInferrer >> initialize [

	super initialize.
	observer := MateObserver new.
	minimumSupport := 10.
	maxEnumerationSize := 8.
	enumerationRatio := 3.
	maxPathLength := 3
]

{ #category : 'invariants' }
MateGrammarInferrer >> invariantsFor: aClass [

	| instances numericFields invariants |

	instances := observer instancesOf: aClass.
	instances size < minimumSupport ifTrue: [ ^ #() ].

	numericFields := aClass allInstVarNames select: [ :field |
		instances allSatisfy: [ :each | | value |
			value := each instVarNamed: field.
			value isNumber and: [ value isFloat not or: [ value isFinite ] ] ] ].

	invariants := OrderedCollection new.

	numericFields do: [ :left |
		numericFields do: [ :right |
			left = right ifFalse: [
				(self invariantBetween: left and: right in: instances) ifNotNil: [ :invariant |
					invariants add: invariant.
					self record: #invariant on: aClass field: nil description: invariant printString support: instances size accepted: true ] ] ] ].

	^ invariants asArray
]

{ #category : 'invariants' }
MateGrammarInferrer >> invariantBetween: left and: right in: instances [

	| leftValues rightValues pairs |

	leftValues := instances collect: [ :each | each instVarNamed: left ].
	rightValues := instances collect: [ :each | each instVarNamed: right ].
	pairs := leftValues with: rightValues collect: [ :a :b | a -> b ].

	(pairs allSatisfy: [ :pair | pair key = pair value ]) ifTrue: [
		(leftValues asSet size = 1 or: [ left > right ]) ifTrue: [ ^ nil ].
		^ MateInvariant left: left operator: '=' right: right ].

	(leftValues max < rightValues min) ifTrue: [ ^ nil ].

	(pairs allSatisfy: [ :pair | pair key < pair value ]) ifTrue: [ ^ MateInvariant left: left operator: '<' right: right ].
	(pairs allSatisfy: [ :pair | pair key <= pair value ]) ifTrue: [ ^ MateInvariant left: left operator: '<=' right: right ].

	^ nil
]

{ #category : 'declarations' }
MateGrammarInferrer >> isEnumeration: profile in: aClass [

	| distinct count |

	profile isEnumerable ifFalse: [ ^ false ].

	distinct := profile distinctValues size.
	count := profile nonNilValues size.

	(distinct <= maxEnumerationSize and: [ count >= (minimumSupport max: enumerationRatio * distinct) ]) ifTrue: [ ^ true ].

	self
		record: #enumeration
		on: aClass
		field: profile name
		description: distinct printString, ' distinct values in ', count printString, ' observations'
		support: count
		accepted: false.

	^ false
]

{ #category : 'accessing' }
MateGrammarInferrer >> maxDepth: anInteger [

	observer maxDepth: anInteger
]

{ #category : 'accessing' }
MateGrammarInferrer >> maxEnumerationSize: anInteger [

	maxEnumerationSize := anInteger
]

{ #category : 'accessing' }
MateGrammarInferrer >> maxPathLength: anInteger [

	maxPathLength := anInteger
]

{ #category : 'accessing' }
MateGrammarInferrer >> minimumSupport: anInteger [

	minimumSupport := anInteger
]

{ #category : 'declarations' }
MateGrammarInferrer >> numericConstraintFor: profile in: aClass [

	| count min max |

	count := profile nonNilValues size.
	min := profile min.
	max := profile max.

	count >= minimumSupport ifTrue: [
		self record: #range on: aClass field: profile name description: 'between: ', min printString, ' and: ', max printString support: count accepted: true.
		^ MateConstraint between: min and: max ].

	self record: #range on: aClass field: profile name description: 'between: ', min printString, ' and: ', max printString, ' needs ', minimumSupport printString, ' observations' support: count accepted: false.

	min > 0 ifTrue: [
		self record: #sign on: aClass field: profile name description: 'greaterThan: 0' support: count accepted: true.
		^ MateConstraint greaterThan: 0 ].

	min >= 0 ifTrue: [
		self record: #sign on: aClass field: profile name description: 'atLeast: 0' support: count accepted: true.
		^ MateConstraint atLeast: 0 ].

	^ nil
]

{ #category : 'observing' }
MateGrammarInferrer >> observe: anObject [

	observer observe: anObject.
	findings := nil
]

{ #category : 'observing' }
MateGrammarInferrer >> observeAll: aCollection [

	observer observeAll: aCollection.
	findings := nil
]

{ #category : 'accessing' }
MateGrammarInferrer >> observer [

	^ observer
]

{ #category : 'declarations' }
MateGrammarInferrer >> oneOfDeclarationFor: profile in: aClass [

	| options |

	options := (profile distinctValues asArray sort: [ :a :b | a printString <= b printString ]) asOrderedCollection.
	profile nilCount > 0 ifTrue: [ options add: nil ].

	self
		record: #enumeration
		on: aClass
		field: profile name
		description: 'oneOf: ', options asArray printString
		support: profile nonNilValues size
		accepted: true.

	^ MateInstOneOfVarDecl new name: profile name; options: options asArray
]

{ #category : 'relationships' }
MateGrammarInferrer >> pathsFrom: aClass length: length [

	| paths |

	paths := OrderedCollection new.
	self
		extend: #()
		state: { #objects. { aClass } }
		toward: aClass
		remaining: length
		into: paths.
	^ paths
]

{ #category : 'relationships' }
MateGrammarInferrer >> extend: steps state: state toward: aClass remaining: remaining into: paths [

	| kind classes |

	kind := state first.
	classes := state second.

	classes do: [ :ownerClass |
		ownerClass allInstVarNames do: [ :field | | step values |
			step := kind = #objects
				ifTrue: [ MatePathProp from: field ]
				ifFalse: [ MatePathEachProp from: field ].
			values := (observer instancesOf: ownerClass) collect: [ :each | each instVarNamed: field ] thenReject: #isNil.
			remaining = 1
				ifTrue: [
					(values anySatisfy: [ :each | each isKindOf: aClass ]) ifTrue: [ paths add: steps , { step } ] ]
				ifFalse: [
					(referenceFields includesKey: { ownerClass. field }) ifFalse: [
						(self statesFrom: values) do: [ :next |
							self extend: steps , { step } state: next toward: aClass remaining: remaining - 1 into: paths ] ] ] ] ]
]

{ #category : 'inferring' }
MateGrammarInferrer >> report [

	^ String streamContents: [ :stream |
		self findings do: [ :each | stream print: each ] separatedBy: [ stream cr ] ]
]

{ #category : 'reporting' }
MateGrammarInferrer >> record: kind on: aClass field: fieldName description: aString support: anInteger accepted: aBoolean [

	findings add: (MateInferenceFinding
		type: aClass
		field: fieldName
		kind: kind
		description: aString
		support: anInteger
		accepted: aBoolean)
]

{ #category : 'relationships' }
MateGrammarInferrer >> statesFrom: values [

	| objectClasses elementClasses states |

	objectClasses := (values select: [ :each | observer isObserved: each ]) collect: #class as: Set.
	elementClasses := ((values select: [ :each | observer isCollectionValue: each ])
		flatCollect: [ :each | (observer elementsOf: each) select: [ :element | observer isObserved: element ] ])
		collect: #class as: Set.

	states := OrderedCollection new.
	objectClasses ifNotEmpty: [ states add: { #objects. objectClasses asArray } ].
	elementClasses ifNotEmpty: [ states add: { #collections. elementClasses asArray } ].
	^ states
]

{ #category : 'declarations' }
MateGrammarInferrer >> typeOf: anObject [

	^ (anObject class includesBehavior: Boolean)
		ifTrue: [ Boolean ]
		ifFalse: [ anObject class ]
]

{ #category : 'declarations' }
MateGrammarInferrer >> unionOf: values [

	^ values
		inject: nil
		into: [ :union :each | MateOptionalType union: union with: (self typeOf: each) ]
]
