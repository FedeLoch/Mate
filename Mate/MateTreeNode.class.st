Class {
	#name : 'MateTreeNode',
	#superclass : 'Object',
	#instVars : [
		'label',
		'children',
		'parent'
	],
	#category : 'Mate-Testing Models',
	#package : 'Mate',
	#tag : 'Testing Models'
}

{ #category : 'adding' }
MateTreeNode >> addChild: aNode [

	children add: aNode.
	aNode parent: self.
	^ aNode
]

{ #category : 'accessing' }
MateTreeNode >> children [

	^ children
]

{ #category : 'initialization' }
MateTreeNode >> initialize [

	super initialize.
	children := OrderedCollection new
]

{ #category : 'accessing' }
MateTreeNode >> label [

	^ label
]

{ #category : 'accessing' }
MateTreeNode >> label: aSymbol [

	label := aSymbol
]

{ #category : 'accessing' }
MateTreeNode >> parent [

	^ parent
]

{ #category : 'accessing' }
MateTreeNode >> parent: aNode [

	parent := aNode
]
