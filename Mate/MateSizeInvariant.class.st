"
I relate the size of a collection field to a value computed from another field of the same object.

    selector value numArgs = arguments size

The left side is a path: a field of the object followed by steps, each one a field of the previous value when it has one, or a unary message otherwise. The right side is a collection field of the same object.

Generation derives the size of the collection from the path, so the invariant holds by construction; validation compares both.
"
Class {
	#name : 'MateSizeInvariant',
	#superclass : 'Object',
	#instVars : [
		'path',
		'field'
	],
	#category : 'Mate-Constraints',
	#package : 'Mate',
	#tag : 'Constraints'
}

{ #category : 'instance creation' }
MateSizeInvariant class >> path: aCollectionOfNames field: aFieldName [

	^ self new setPath: aCollectionOfNames field: aFieldName
]

{ #category : 'comparing' }
MateSizeInvariant >> = anObject [

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ path = anObject path and: [ field = anObject field ]
]

{ #category : 'evaluating' }
MateSizeInvariant >> expectedSizeOf: anObject [
	"The size the collection field of anObject must have."

	^ self sizeFrom: [ :name | anObject instVarNamed: name ]
]

{ #category : 'accessing' }
MateSizeInvariant >> field [
	"The collection field whose size is constrained."

	^ field
]

{ #category : 'comparing' }
MateSizeInvariant >> hash [

	^ path hash bitXor: field hash
]

{ #category : 'testing' }
MateSizeInvariant >> holdsFor: anObject [

	| size collection |

	size := self expectedSizeOf: anObject.
	collection := anObject instVarNamed: field.
	(size isNil or: [ collection isNil ]) ifTrue: [ ^ true ].
	collection isCollection ifFalse: [ ^ false ].
	^ collection size = size
]

{ #category : 'testing' }
MateSizeInvariant >> isSizeInvariant [

	^ true
]

{ #category : 'accessing' }
MateSizeInvariant >> path [

	^ path
]

{ #category : 'printing' }
MateSizeInvariant >> printOn: aStream [

	path do: [ :each | aStream nextPutAll: each ] separatedBy: [ aStream space ].
	aStream nextPutAll: ' = '; nextPutAll: field; nextPutAll: ' size'
]

{ #category : 'initialization' }
MateSizeInvariant >> setPath: aCollectionOfNames field: aFieldName [

	path := aCollectionOfNames asArray collect: [ :each | each asString ].
	field := aFieldName asString
]

{ #category : 'evaluating' }
MateSizeInvariant >> sizeFrom: aBlock [
	"Evaluate the path, asking aBlock for the value of the first field.
	Generation uses it while the object is being built, before its fields are set."

	^ path allButFirst
		inject: (aBlock value: path first)
		into: [ :value :step | value ifNotNil: [ self step: step on: value ] ]
]

{ #category : 'accessing' }
MateSizeInvariant >> sourceField [
	"The field of the object the path starts from."

	^ path first
]

{ #category : 'evaluating' }
MateSizeInvariant >> step: aName on: anObject [

	(anObject class allInstVarNames includes: aName) ifTrue: [ ^ anObject instVarNamed: aName ].
	^ anObject perform: aName asSymbol
]
