Extension { #name : 'Metaclass' }

{ #category : '*Mate' }
Metaclass >> | aClass [

	(aClass = self) ifTrue: [ ^ self ].
	
	^ MateOptionalType options: { self . aClass }
]
