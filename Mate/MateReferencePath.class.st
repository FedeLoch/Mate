Class {
	#name : 'MateReferencePath',
	#superclass : 'Object',
	#instVars : [
		'path'
	],
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'instance creation' }
MateReferencePath class >> new: path [

	^ self new path: path
]

{ #category : 'as yet unclassified' }
MateReferencePath >> insertReference: instance [ 

	| current |

	current := path allButLast inject: instance into: [ :inst :prop | prop from: inst ].
	
	path last insert: instance at: current.
]

{ #category : 'accessing' }
MateReferencePath >> path: aPath [ 

	path := aPath
]
