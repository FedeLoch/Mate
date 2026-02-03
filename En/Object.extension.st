Extension { #name : 'Object' }

{ #category : '*En' }
Object class >> getOne [

	^ self
]

{ #category : '*En' }
Object class >> getOneFrom: context [
	"For single types (not EnOptionalType), just return self ignoring context"
	^ self
]

{ #category : '*En' }
Object class >> | aClass [ 
	
	^ EnOptionalType options: { self . aClass }
]
