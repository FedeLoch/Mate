Class {
	#name : 'MateBuiltInGenerator',
	#superclass : 'Object',
	#instVars : [
		'type'
	],
	#category : 'Mate-Generation',
	#package : 'Mate',
	#tag : 'Generation'
}

{ #category : 'translating' }
MateBuiltInGenerator >> generate [

	^ self generate: SharedRandom globalGenerator
]

{ #category : 'translating' }
MateBuiltInGenerator >> generate: aRandom [

	self subclassResponsibility 
]

{ #category : 'translating' }
MateBuiltInGenerator >> generateWithConstraint: aConstraint [

	^ self generateWithConstraint: aConstraint random: SharedRandom globalGenerator
]

{ #category : 'translating' }
MateBuiltInGenerator >> generateWithConstraint: aConstraint random: aRandom [

	aConstraint ifNil: [ ^ self generate: aRandom ].
	aConstraint hasOptions ifTrue: [
		^ (aConstraint options reject: [ :each | aConstraint excluded notNil and: [ aConstraint excluded includes: each ] ])
			atRandom: aRandom ].
	aConstraint hasPattern ifTrue: [ ^ self generateMatching: aConstraint random: aRandom ].

	^ self generateWithin: aConstraint random: aRandom
]

{ #category : 'translating' }
MateBuiltInGenerator >> generateWithin: aConstraint random: aRandom [

	100 timesRepeat: [ | value |
		value := self generate: aRandom.
		(aConstraint includes: value) ifTrue: [ ^ value ] ].

	^ self error: 'Unable to generate a ', type name, ' satisfying ', aConstraint printString
]

{ #category : 'accessing' }
MateBuiltInGenerator >> type [

	^ type
]

{ #category : 'accessing' }
MateBuiltInGenerator >> type: aClass [

	type := aClass
]

{ #category : 'translating' }
MateBuiltInGenerator >> fromString: aString [
	"Convert a string generated from a regular expression into a value of my type."

	(type includesBehavior: String) ifFalse: [
		^ self error: 'matching: only applies to strings and symbols, not to ', type name ].
	^ type = WideString
		ifTrue: [ aString asWideString ]
		ifFalse: [ aString asString ]
]

{ #category : 'translating' }
MateBuiltInGenerator >> generateMatching: aConstraint random: aRandom [
	"A value matching the regular expression of aConstraint and not among its excluded values."

	100 timesRepeat: [ | value |
		value := self fromString: (MateRegexGenerator generate: aConstraint pattern random: aRandom).
		(aConstraint includes: value) ifTrue: [ ^ value ] ].
	^ self error: 'Unable to generate a ', type name, ' satisfying ', aConstraint printString
]
