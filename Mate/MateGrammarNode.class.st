Class {
	#name : 'MateGrammarNode',
	#superclass : 'Object',
	#instVars : [
		'declaration',
		'parent',
		'children',
		'label',
		'totalVisits'
	],
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'accessing' }
MateGrammarNode >> children [

	^ children
]

{ #category : 'accessing' }
MateGrammarNode >> children: anObject [

	children := anObject
]

{ #category : 'accessing' }
MateGrammarNode >> declaration [

	^ declaration
]

{ #category : 'accessing' }
MateGrammarNode >> declaration: anObject [

	declaration := anObject
]

{ #category : 'initialization' }
MateGrammarNode >> initialize [

	super initialize.
	children := OrderedCollection new.
]

{ #category : 'accessing' }
MateGrammarNode >> label [

	^ label
]

{ #category : 'accessing' }
MateGrammarNode >> label: anObject [

	label := anObject
]

{ #category : 'accessing' }
MateGrammarNode >> parent [

	^ parent
]

{ #category : 'accessing' }
MateGrammarNode >> parent: anObject [

	parent := anObject
]

{ #category : 'accessing' }
MateGrammarNode >> totalVisits [

	^ totalVisits
]

{ #category : 'accessing' }
MateGrammarNode >> totalVisits: anObject [

	totalVisits := anObject
]
