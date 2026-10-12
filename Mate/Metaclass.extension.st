Extension { #name : 'Metaclass' }

{ #category : '*Mate' }
Metaclass >> acceptType: aType [

	^ aType includesBehavior: self
]

{ #category : '*Mate' }
Metaclass >> getOne [

	^ self
]

{ #category : '*Mate' }
Metaclass >> getOneFrom: context [

	^ self
]

{ #category : '*Mate' }
Metaclass >> types [

	^ { self }
]

{ #category : '*Mate' }
Metaclass >> updateReward: improvement context: context from: decl [

	^ nil
]

{ #category : '*Mate' }
Metaclass >> | aType [

	^ MateOptionalType union: self with: aType
]
