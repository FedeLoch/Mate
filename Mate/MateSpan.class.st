Class {
	#name : 'MateSpan',
	#superclass : 'Object',
	#instVars : [
		'start',
		'stop',
		'kind'
	],
	#category : 'Mate-Testing Models',
	#package : 'Mate',
	#tag : 'Testing Models'
}

{ #category : 'instance creation' }
MateSpan class >> from: start to: stop kind: aSymbol [

	^ self new setStart: start stop: stop kind: aSymbol
]

{ #category : 'accessing' }
MateSpan >> kind [

	^ kind
]

{ #category : 'initialization' }
MateSpan >> setStart: aStart stop: aStop kind: aSymbol [

	start := aStart.
	stop := aStop.
	kind := aSymbol
]

{ #category : 'accessing' }
MateSpan >> start [

	^ start
]

{ #category : 'accessing' }
MateSpan >> stop [

	^ stop
]
