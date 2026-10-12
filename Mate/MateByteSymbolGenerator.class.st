Class {
	#name : 'MateByteSymbolGenerator',
	#superclass : 'MateBuiltInGenerator',
	#instVars : [
		'stringGenerator'
	],
	#category : 'Mate-Generation',
	#package : 'Mate',
	#tag : 'Generation'
}

{ #category : 'translating' }
MateByteSymbolGenerator >> generate: aRandom [

	| string |
	
	[ string := stringGenerator generate: aRandom.
	  string isEmpty ] whileTrue.

	^ string asSymbol
]

{ #category : 'initialization' }
MateByteSymbolGenerator >> initialize [ 
	
	super initialize.
	stringGenerator := MateByteStringGenerator new type: ByteString
]
