Class {
	#name : 'MatePathEachProp',
	#superclass : 'MatePathProp',
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'instance creation' }
MatePathEachProp >> from: object [ 
	
	1 halt.
]

{ #category : 'derivation' }
MatePathEachProp >> insertDerivation: instance atDerivation: aNode [ 

	aNode edges valuesDo: [ :elementNode | 
		(elementNode edges at: prop) instance: instance 
	]
]
