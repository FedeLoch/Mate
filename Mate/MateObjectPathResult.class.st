Class {
	#name : 'MateObjectPathResult',
	#superclass : 'Object',
	#instVars : [
		'grammar',
		'reachedPaths'
	],
	#category : 'Mate-Object Path Collector',
	#package : 'Mate',
	#tag : 'Object Path Collector'
}

{ #category : 'instance creation' }
MateObjectPathResult class >> from: grammar paths: paths [

	^ self new grammar: grammar; reachedPaths: paths
]

{ #category : 'accessing' }
MateObjectPathResult >> grammar [

	^ grammar
]

{ #category : 'accessing' }
MateObjectPathResult >> grammar: aGrammar [

	grammar := aGrammar

	
]

{ #category : 'computation' }
MateObjectPathResult >> percentage [

	^ grammar explorationPercentage
]

{ #category : 'accessing' }
MateObjectPathResult >> reachedPaths [

	^ reachedPaths 
]

{ #category : 'accessing' }
MateObjectPathResult >> reachedPaths: paths [

	reachedPaths := paths
]
