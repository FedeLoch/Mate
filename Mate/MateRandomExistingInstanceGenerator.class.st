Class {
	#name : 'MateRandomExistingInstanceGenerator',
	#superclass : 'MateGrammarBaseInstanceGenerator',
	#instVars : [
		'instances',
		'selectionExistingProbability'
	],
	#category : 'Mate-Generation',
	#package : 'Mate',
	#tag : 'Generation'
}

{ #category : 'visiting' }
MateRandomExistingInstanceGenerator >> existingInstanceFor: decl random: aRandom closing: isClosing [

	| pool |

	pool := instances at: decl type ifAbsent: [ ^ nil ].
	pool ifEmpty: [ ^ nil ].

	(isClosing or: [ aRandom next < selectionExistingProbability ]) ifFalse: [ ^ nil ].

	^ pool atRandom: aRandom
]

{ #category : 'initialization' }
MateRandomExistingInstanceGenerator >> initialize [

	super initialize.
	instances := Dictionary new.
	selectionExistingProbability := 0.5
]

{ #category : 'accessing' }
MateRandomExistingInstanceGenerator >> instancesOf: aClass [

	^ instances at: aClass ifAbsent: [ #() ]
]

{ #category : 'visiting' }
MateRandomExistingInstanceGenerator >> newInstanceFor: decl [

	| instance |

	instance := super newInstanceFor: decl.
	(instances at: decl type ifAbsentPut: [ OrderedCollection new ]) add: instance.
	^ instance
]

{ #category : 'initialization' }
MateRandomExistingInstanceGenerator >> reset [

	instances := Dictionary new
]

{ #category : 'accessing' }
MateRandomExistingInstanceGenerator >> selectionExistingProbability [

	^ selectionExistingProbability
]

{ #category : 'accessing' }
MateRandomExistingInstanceGenerator >> selectionExistingProbability: prob [

	selectionExistingProbability := prob
]
