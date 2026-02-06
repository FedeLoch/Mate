Class {
	#name : 'MateParser',
	#superclass : 'Object',
	#instVars : [
		'grammar'
	],
	#category : 'Mate-Parsing',
	#package : 'Mate',
	#tag : 'Parsing'
}

{ #category : 'accessing' }
MateParser >> grammar [

	^ grammar
]

{ #category : 'accessing' }
MateParser >> grammar: aGrammar [

	grammar := aGrammar 
]

{ #category : 'parsing' }
MateParser >> parse: obj [ 

	^ self parse: obj class from: MateContext new
]
