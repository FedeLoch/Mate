Class {
	#name : 'MateHeapGuardTest',
	#superclass : 'TestCase',
	#category : 'Mate-Generation Tests',
	#package : 'Mate',
	#tag : 'Generation Tests'
}

{ #category : 'helpers' }
MateHeapGuardTest >> allocate: megabytes into: aCollection [

	megabytes timesRepeat: [
		aCollection add: (ByteArray new: 1024 * 1024).
		(Delay forMilliseconds: 2) wait ]
]

{ #category : 'helpers' }
MateHeapGuardTest >> guardAllowing: megabytes [

	Smalltalk garbageCollect.
	^ (MateHeapGuard limit: MateHeapGuard usedHeap + (megabytes * 1024 * 1024))
		pollingInterval: 10 milliSeconds;
		yourself
]

{ #category : 'helpers' }
MateHeapGuardTest >> watchdogs [

	^ Process allInstances select: [ :each | each name = 'MateHeapGuard watchdog' and: [ each isTerminated not ] ]
]

{ #category : 'tests' }
MateHeapGuardTest >> testAllocatingPastTheLimitSignalsAnError [

	| kept error |

	kept := OrderedCollection new.
	error := [ (self guardAllowing: 64) run: [ self allocate: 400 into: kept ]. nil ]
		on: MateHeapLimitReached
		do: [ :e | e return: e ].

	self assert: (error isKindOf: MateHeapLimitReached).
	self assert: (error isKindOf: Error).
	self assert: (error messageText beginsWith: 'heap limit reached').
	self assert: error used > error limit.
	self assert: kept size < 400
]

{ #category : 'tests' }
MateHeapGuardTest >> testBlocksWithinTheLimitRunNormally [

	| guard |

	guard := self guardAllowing: 512.

	self assert: (guard run: [ 3 + 4 ]) equals: 7.
	self assert: (guard run: [ | kept | kept := OrderedCollection new. self allocate: 8 into: kept. kept size ]) equals: 8
]

{ #category : 'tests' }
MateHeapGuardTest >> testGarbageDoesNotTriggerTheLimit [

	| guard |

	guard := self guardAllowing: 64.

	self assert: (guard run: [
		200 timesRepeat: [ ByteArray new: 1024 * 1024 ].
		#done ]) equals: #done
]

{ #category : 'tests' }
MateHeapGuardTest >> testGeneratorHeapLimitStopsGeneration [

	| grammar |

	grammar := MatePersonGrammar new.
	grammar generator heapLimit: 1.

	self should: [ grammar gen: MatePerson ] raise: MateHeapLimitReached.

	grammar generator heapLimit: nil.
	self assert: (grammar gen: MatePerson) class equals: MatePerson
]

{ #category : 'tests' }
MateHeapGuardTest >> testGeneratorWithoutHeapLimitIsUnchanged [

	| grammar |

	grammar := MatePersonGrammar new.

	self assert: grammar generator heapLimit isNil.
	self assert: (grammar gen: MatePerson) class equals: MatePerson
]

{ #category : 'tests' }
MateHeapGuardTest >> testGuardCanRunAgainAfterTheLimitWasReached [

	| guard |

	guard := self guardAllowing: 64.

	self should: [ guard run: [ | kept | kept := OrderedCollection new. self allocate: 400 into: kept ] ] raise: MateHeapLimitReached.
	self assert: (guard run: [ #again ]) equals: #again
]

{ #category : 'tests' }
MateHeapGuardTest >> testWatchdogStopsWhenTheBlockEnds [

	| before guard |

	before := self watchdogs size.
	guard := self guardAllowing: 512.

	guard run: [ 1 ].
	[ guard run: [ Error signal: 'boom' ] ] on: Error do: [ :e | e return: nil ].
	[ (self guardAllowing: 64) run: [ | kept | kept := OrderedCollection new. self allocate: 400 into: kept ] ]
		on: MateHeapLimitReached
		do: [ :e | e return: nil ].

	self assert: self watchdogs size equals: before
]
