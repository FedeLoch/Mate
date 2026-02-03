Class {
	#name : 'EnContext',
	#superclass : 'Object',
	#instVars : [
		'path',
		'parentNode'
	],
	#category : 'En-Parsing',
	#package : 'En',
	#tag : 'Parsing'
}

{ #category : 'copying' }
EnContext >> copy [

	^ self class new 
		path: path copy;
		parentNode: parentNode
]

{ #category : 'accessing' }
EnContext >> depth [

	^ path size
]

{ #category : 'testing' }
EnContext >> includes: aDeclaration [

	^ path includes: aDeclaration
]

{ #category : 'initialization' }
EnContext >> initialize [

	super initialize.
	path := OrderedCollection new.
]

{ #category : 'accessing' }
EnContext >> parentNode [

	^ parentNode
]

{ #category : 'accessing' }
EnContext >> parentNode: aNode [

	parentNode := aNode
]

{ #category : 'accessing' }
EnContext >> path [

	^ path
]

{ #category : 'accessing' }
EnContext >> path: aCollection [

	path := aCollection
]

{ #category : 'navigation' }
EnContext >> pop [

	path removeLast.
]

{ #category : 'navigation' }
EnContext >> push: aDeclaration [

	path add: aDeclaration.
]
