Class {
	#name : 'MateInferenceFinding',
	#superclass : 'Object',
	#instVars : [
		'type',
		'field',
		'kind',
		'description',
		'support',
		'accepted'
	],
	#category : 'Mate-Inference',
	#package : 'Mate',
	#tag : 'Inference'
}

{ #category : 'instance creation' }
MateInferenceFinding class >> type: aClass field: aFieldName kind: aSymbol description: aString support: anInteger accepted: aBoolean [

	^ self new
		setType: aClass
		field: aFieldName
		kind: aSymbol
		description: aString
		support: anInteger
		accepted: aBoolean
]

{ #category : 'testing' }
MateInferenceFinding >> accepted [

	^ accepted
]

{ #category : 'accessing' }
MateInferenceFinding >> description [

	^ description
]

{ #category : 'accessing' }
MateInferenceFinding >> field [

	^ field
]

{ #category : 'accessing' }
MateInferenceFinding >> kind [

	^ kind
]

{ #category : 'printing' }
MateInferenceFinding >> printOn: aStream [

	aStream
		nextPutAll: (accepted ifTrue: [ '[accepted] ' ] ifFalse: [ '[rejected] ' ]);
		nextPutAll: type name.
	field ifNotNil: [ aStream nextPutAll: '.'; nextPutAll: field ].
	aStream
		nextPutAll: ' ';
		nextPutAll: kind;
		nextPutAll: ': ';
		nextPutAll: description;
		nextPutAll: ' (support ';
		print: support;
		nextPut: $)
]

{ #category : 'initialization' }
MateInferenceFinding >> setType: aClass field: aFieldName kind: aSymbol description: aString support: anInteger accepted: aBoolean [

	type := aClass.
	field := aFieldName.
	kind := aSymbol.
	description := aString.
	support := anInteger.
	accepted := aBoolean
]

{ #category : 'accessing' }
MateInferenceFinding >> support [

	^ support
]

{ #category : 'accessing' }
MateInferenceFinding >> type [

	^ type
]
