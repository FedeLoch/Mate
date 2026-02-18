Class {
	#name : 'MateGrammarRenderNode',
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
MateGrammarRenderNode >> children [

	^ children
]

{ #category : 'accessing' }
MateGrammarRenderNode >> children: anObject [

	children := anObject
]

{ #category : 'accessing' }
MateGrammarRenderNode >> declaration [

	^ declaration
]

{ #category : 'accessing' }
MateGrammarRenderNode >> declaration: anObject [

	declaration := anObject
]

{ #category : 'initialization' }
MateGrammarRenderNode >> initialize [

	super initialize.
	children := OrderedCollection new.
]

{ #category : 'accessing' }
MateGrammarRenderNode >> label [

	^ label
]

{ #category : 'accessing' }
MateGrammarRenderNode >> label: anObject [

	label := anObject
]

{ #category : 'accessing' }
MateGrammarRenderNode >> parent [

	^ parent
]

{ #category : 'accessing' }
MateGrammarRenderNode >> parent: anObject [

	parent := anObject
]

{ #category : 'accessing' }
MateGrammarRenderNode >> totalVisits [

	^ totalVisits
]

{ #category : 'accessing' }
MateGrammarRenderNode >> totalVisits: anObject [

	totalVisits := anObject
]
