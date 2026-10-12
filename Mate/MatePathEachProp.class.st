Class {
	#name : 'MatePathEachProp',
	#superclass : 'MatePathProp',
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'instance creation' }
MatePathEachProp >> from: object [ 
	
	^ object asArray collect: [ :each | each instVarNamed: prop ]
]

{ #category : 'derivation' }
MatePathEachProp >> insertDerivation: instance atDerivation: aNode [ 

	aNode edges valuesDo: [ :edge |
		edge edges at: prop ifPresent: [ (edge edges at: prop) instance: instance ]
	]
]

{ #category : 'testing' }
MatePathEachProp >> isEach [

	^ true
]

{ #category : 'accessing' }
MatePathEachProp >> ownersIn: targets [

	^ ((targets reject: #isNil) flatCollect: [ :collection | collection asArray ]) reject: #isNil
]
