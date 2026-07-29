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

{ #category : 'initialization' }
MateByteSymbolGenerator >> generate [

	^ (stringGenerator gen: nil) createSymbol
]

{ #category : 'initialization' }
MateByteSymbolGenerator >> initialize [ 
	
	super initialize.
	stringGenerator := GncBPGrammarGenerator new grammar: MateStringGrammar new.
]
