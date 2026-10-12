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
	aConstraint hasOptions ifTrue: [ ^ aConstraint options atRandom: aRandom ].

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
