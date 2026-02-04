Extension { #name : 'Object' }

{ #category : '*Mate' }
Object class >> getOne [

	^ self
]

{ #category : '*Mate' }
Object class >> getOneFrom: context [
	"For single types (not EnOptionalType), just return self ignoring context"
	^ self
]

{ #category : '*Mate' }
Object class >> | aClass [ 
	
	^ MateOptionalType options: { self . aClass }
]
