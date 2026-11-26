"
A message send for testing size invariants: as many arguments as the selector takes.
"
Class {
	#name : 'MateSend',
	#superclass : 'Object',
	#instVars : [
		'selector',
		'arguments'
	],
	#category : 'Mate-Testing Models',
	#package : 'Mate',
	#tag : 'Testing Models'
}

{ #category : 'instance creation' }
MateSend class >> selector: aSymbol arguments: aCollection [

	^ self new setSelector: aSymbol arguments: aCollection
]

{ #category : 'accessing' }
MateSend >> arguments [

	^ arguments
]

{ #category : 'accessing' }
MateSend >> selector [

	^ selector
]

{ #category : 'initialization' }
MateSend >> setSelector: aSymbol arguments: aCollection [

	selector := aSymbol.
	arguments := aCollection
]
