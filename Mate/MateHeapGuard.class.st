Class {
	#name : 'MateHeapGuard',
	#superclass : 'Object',
	#instVars : [
		'limit',
		'pollingInterval'
	],
	#category : 'Mate-Generation',
	#package : 'Mate',
	#tag : 'Generation'
}

{ #category : 'instance creation' }
MateHeapGuard class >> limit: bytes [

	^ self new limit: bytes
]

{ #category : 'accessing' }
MateHeapGuard class >> usedHeap [

	^ Smalltalk vm memorySize - Smalltalk vm freeOldSpaceSize
]

{ #category : 'checking' }
MateHeapGuard >> exceededUsage [

	| used |

	used := self class usedHeap.
	used > limit ifFalse: [ ^ nil ].

	Smalltalk garbageCollect.
	used := self class usedHeap.

	^ used > limit ifTrue: [ used ] ifFalse: [ nil ]
]

{ #category : 'initialization' }
MateHeapGuard >> initialize [

	super initialize.
	pollingInterval := 100 milliSeconds
]

{ #category : 'accessing' }
MateHeapGuard >> limit [

	^ limit
]

{ #category : 'accessing' }
MateHeapGuard >> limit: bytes [

	limit := bytes
]

{ #category : 'accessing' }
MateHeapGuard >> pollingInterval: aDuration [

	pollingInterval := aDuration
]

{ #category : 'running' }
MateHeapGuard >> run: aBlock [

	| guarded watchdog |

	self exceededUsage ifNotNil: [ :used | ^ (MateHeapLimitReached limit: limit used: used) signal ].

	guarded := Processor activeProcess.
	watchdog := [
		[
			pollingInterval wait.
			self exceededUsage ifNotNil: [ :used |
				guarded signalException: (MateHeapLimitReached limit: limit used: used).
				^ self ] ] repeat ] newProcess.
	watchdog
		name: 'MateHeapGuard watchdog';
		priority: Processor userInterruptPriority;
		resume.

	^ aBlock ensure: [ watchdog terminate ]
]
