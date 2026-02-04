Class {
	#name : 'MateStringGenerator',
	#superclass : 'MateBuiltInGenerator',
	#instVars : [
		'generator'
	],
	#category : 'Mate-BuiltIn Generators',
	#package : 'Mate',
	#tag : 'BuiltIn Generators'
}

{ #category : 'initialization' }
MateStringGenerator >> generate [

	^ generator gen: nil
]

{ #category : 'initialization' }
MateStringGenerator >> initialize [ 
	
	super initialize.
	generator := UmeGrammarGenerator new grammar: StringGrammar new.
]
