Class {
	#name : 'FuzzProxy',
	#superclass : 'Object',
	#instVars : [
		'history'
	],
	#category : 'En-ProxyObjectFuzzer',
	#package : 'En',
	#tag : 'ProxyObjectFuzzer'
}

{ #category : 'initialization' }
FuzzProxy >> doesNotUnderstand: aMessage [

	| selector |
	1 halt.
	selector := aMessage selector.

	(history includesKey: selector) ifFalse: [
		"TODO"
		history at: selector put: (self randomResultFor: selector)
	].

	^ history at: selector
]

{ #category : 'initialization' }
FuzzProxy >> initialize [ 

	super initialize.
	history := Dictionary new.
]

{ #category : 'initialization' }
FuzzProxy >> randomResultFor: selector [

    1 halt.
]
