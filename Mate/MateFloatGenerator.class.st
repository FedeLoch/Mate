Class {
	#name : 'MateFloatGenerator',
	#superclass : 'MateBuiltInGenerator',
	#category : 'Mate-BuiltIn Generators',
	#package : 'Mate',
	#tag : 'BuiltIn Generators'
}

{ #category : 'translating' }
MateFloatGenerator >> generate [

	"TODO: review this"
	^ (Random new next * 1000.0) - 500.0
]

{ #category : 'translating' }
MateFloatGenerator >> generateWithConstraint: aConstraint [

	| min max |

	aConstraint ifNil: [ ^ self generate ].
	
	min := aConstraint universe first.
	max := aConstraint universe last.
	
	^ min + (Random new next * (max - min))
]
