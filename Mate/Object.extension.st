Extension { #name : 'Object' }

{ #category : '*Mate' }
Object class >> acceptType: aType [
	
	^ self = aType
]

{ #category : '*Mate' }
Object class >> getOne [

	^ self
]

{ #category : '*Mate' }
Object class >> getOneFrom: context [
	"For single types (not MateOptionalType), just return self ignoring context"
	^ self
]

{ #category : '*Mate' }
Object class >> types [

	^ { self }
]

{ #category : '*Mate' }
Object class >> updateReward: improvement context: context from: decl [
	
	^ nil
]

{ #category : '*Mate' }
Object class >> | aClass [ 
	
	^ MateOptionalType options: { self . aClass }
]
