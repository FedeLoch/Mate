Class {
	#name : 'MateObjectPathCollector',
	#superclass : 'Object',
	#instVars : [
		'grammar',
		'paths'
	],
	#category : 'Mate-Object Path Collector',
	#package : 'Mate',
	#tag : 'Object Path Collector'
}

{ #category : 'accessing' }
MateObjectPathCollector >> collect: anObject [
	
	| devTree |
	
	devTree := grammar parse: anObject. 
	paths add: devTree derivationPath
]

{ #category : 'helpers' }
MateObjectPathCollector >> getResult [

	^ MateObjectPathResult from: grammar paths: paths
]

{ #category : 'accessing' }
MateObjectPathCollector >> grammar [

	^ grammar
]

{ #category : 'accessing' }
MateObjectPathCollector >> grammar: aMateGrammar [

	grammar := aMateGrammar
]

{ #category : 'accessing' }
MateObjectPathCollector >> initialize [ 
	
	super initialize.
	paths := IdentitySet new.
]
