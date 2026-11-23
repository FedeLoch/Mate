Class {
	#name : 'MateHeapLimitReached',
	#superclass : 'Error',
	#instVars : [
		'limit',
		'used'
	],
	#category : 'Mate-Generation',
	#package : 'Mate',
	#tag : 'Generation'
}

{ #category : 'instance creation' }
MateHeapLimitReached class >> limit: limitBytes used: usedBytes [

	^ self new
		setLimit: limitBytes used: usedBytes;
		messageText: 'heap limit reached: ', (self megabytes: usedBytes), ' MB in use, limit ', (self megabytes: limitBytes), ' MB';
		yourself
]

{ #category : 'printing' }
MateHeapLimitReached class >> megabytes: bytes [

	^ (bytes // (1024 * 1024)) printString
]

{ #category : 'accessing' }
MateHeapLimitReached >> limit [

	^ limit
]

{ #category : 'initialization' }
MateHeapLimitReached >> setLimit: limitBytes used: usedBytes [

	limit := limitBytes.
	used := usedBytes
]

{ #category : 'accessing' }
MateHeapLimitReached >> used [

	^ used
]
