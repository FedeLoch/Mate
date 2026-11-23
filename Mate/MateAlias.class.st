Class {
	#name : 'MateAlias',
	#superclass : 'Object',
	#instVars : [
		'name',
		'definition'
	],
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'instance creation' }
MateAlias class >> name: aName definition: aTypeOrDeclaration [

	^ self new setName: aName definition: aTypeOrDeclaration
]

{ #category : 'accessing' }
MateAlias >> aliases [

	^ definition aliases
]

{ #category : 'accessing' }
MateAlias >> definition [

	^ definition
]

{ #category : 'instantiating' }
MateAlias >> instantiateField [

	^ definition aliasCopy alias: self; yourself
]

{ #category : 'instantiating' }
MateAlias >> instantiateType [

	^ (MateOptionalType options: definition types) aliases: { self }; yourself
]

{ #category : 'testing' }
MateAlias >> isTypeAlias [

	^ definition isKindOf: MateOptionalType
]

{ #category : 'accessing' }
MateAlias >> name [

	^ name
]

{ #category : 'printing' }
MateAlias >> printOn: aStream [

	aStream nextPutAll: 'MateAlias('; nextPutAll: name; nextPut: $)
]

{ #category : 'initialization' }
MateAlias >> setName: aName definition: aTypeOrDeclaration [

	name := aName.
	definition := aTypeOrDeclaration
]

{ #category : 'accessing' }
MateAlias >> types [

	^ definition types
]
