Class {
	#name : 'MateViolation',
	#superclass : 'Object',
	#instVars : [
		'kind',
		'owner',
		'field',
		'before',
		'after',
		'description'
	],
	#category : 'Mate-Violations',
	#package : 'Mate',
	#tag : 'Violations'
}

{ #category : 'instance creation' }
MateViolation class >> kind: aSymbol owner: anObject field: aFieldName before: oldValue after: newValue description: aString [

	^ self new
		setKind: aSymbol
		owner: anObject
		field: aFieldName
		before: oldValue
		after: newValue
		description: aString
]

{ #category : 'accessing' }
MateViolation >> after [

	^ after
]

{ #category : 'accessing' }
MateViolation >> before [

	^ before
]

{ #category : 'accessing' }
MateViolation >> description [

	^ description
]

{ #category : 'accessing' }
MateViolation >> field [

	^ field
]

{ #category : 'accessing' }
MateViolation >> kind [

	^ kind
]

{ #category : 'accessing' }
MateViolation >> owner [

	^ owner
]

{ #category : 'printing' }
MateViolation >> printOn: aStream [

	aStream
		nextPutAll: kind;
		nextPutAll: ': ';
		nextPutAll: owner class name;
		nextPutAll: '.';
		nextPutAll: field asString;
		nextPutAll: ' ';
		nextPutAll: (self shortPrint: before);
		nextPutAll: ' -> ';
		nextPutAll: (self shortPrint: after);
		nextPutAll: ' (';
		nextPutAll: description;
		nextPut: $)
]

{ #category : 'initialization' }
MateViolation >> setKind: aSymbol owner: anObject field: aFieldName before: oldValue after: newValue description: aString [

	kind := aSymbol.
	owner := anObject.
	field := aFieldName.
	before := oldValue.
	after := newValue.
	description := aString
]

{ #category : 'printing' }
MateViolation >> shortPrint: anObject [

	^ anObject printString truncateTo: 40
]
