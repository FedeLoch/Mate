Class {
	#name : 'MateGenerationLoop',
	#superclass : 'Error',
	#instVars : [
		'rootType',
		'objectCount',
		'path'
	],
	#category : 'Mate-Generation',
	#package : 'Mate',
	#tag : 'Generation'
}

{ #category : 'signalling' }
MateGenerationLoop class >> signalFor: aType objects: anInteger path: aPath reason: aString [

	^ self new
		setRootType: aType objectCount: anInteger path: aPath;
		signal: 'Generation of ', aType name, ' does not terminate: ', aString, '. Last steps: ', (self describe: aPath)
]

{ #category : 'printing' }
MateGenerationLoop class >> describe: aPath [

	| names |

	names := aPath collect: [ :each | each name asString ].
	names size > 12 ifTrue: [ names := { '...' } , (names last: 12) ].

	^ names asArray joinUsing: ' > '
]

{ #category : 'accessing' }
MateGenerationLoop >> objectCount [

	^ objectCount
]

{ #category : 'accessing' }
MateGenerationLoop >> path [

	^ path
]

{ #category : 'accessing' }
MateGenerationLoop >> rootType [

	^ rootType
]

{ #category : 'initialization' }
MateGenerationLoop >> setRootType: aType objectCount: anInteger path: aPath [

	rootType := aType.
	objectCount := anInteger.
	path := aPath asArray
]
