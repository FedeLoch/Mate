Class {
	#name : 'MateContext',
	#superclass : 'Object',
	#instVars : [
		'path',
		'parentNode'
	],
	#category : 'Mate-Parsing',
	#package : 'Mate',
	#tag : 'Parsing'
}

{ #category : 'copying' }
MateContext >> copy [

	^ self class new 
		path: path copy;
		parentNode: parentNode
]

{ #category : 'accessing' }
MateContext >> depth [

	^ path size
]

{ #category : 'testing' }
MateContext >> includes: aDeclaration [

	^ path includes: aDeclaration
]

{ #category : 'initialization' }
MateContext >> initialize [

	super initialize.
	path := OrderedCollection new.
]

{ #category : 'accessing' }
MateContext >> parentNode [

	^ parentNode
]

{ #category : 'accessing' }
MateContext >> parentNode: aNode [

	parentNode := aNode
]

{ #category : 'accessing' }
MateContext >> path [

	^ path
]

{ #category : 'accessing' }
MateContext >> path: aCollection [

	path := aCollection
]

{ #category : 'navigation' }
MateContext >> pop [

	path removeLast.
]

{ #category : 'navigation' }
MateContext >> push: aDeclaration [

	path add: aDeclaration.
]
