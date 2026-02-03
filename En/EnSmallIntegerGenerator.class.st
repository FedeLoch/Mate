Class {
	#name : 'EnSmallIntegerGenerator',
	#superclass : 'EnBuiltInGenerator',
	#instVars : [
		'generator'
	],
	#category : 'En-BuiltIn Generators',
	#package : 'En',
	#tag : 'BuiltIn Generators'
}

{ #category : 'translating' }
EnSmallIntegerGenerator >> generate [

	^ (generator gen: nil) asNumber
]

{ #category : 'translating' }
EnSmallIntegerGenerator >> generateWithConstraint: aConstraint [

	aConstraint ifNil: [ ^ self generate ].
	
	^ aConstraint universe atRandom
]

{ #category : 'initialization' }
EnSmallIntegerGenerator >> initialize [ 
	
	super initialize.
	generator := PBTGrammarGenerator new grammar: DecimalGrammar new.
]
