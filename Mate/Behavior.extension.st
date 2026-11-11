Extension { #name : 'Behavior' }

{ #category : '*Mate' }
Behavior >> mateNew [

	^ [ self new ] on: Error do: [ :error | error return: self basicNew ]
]
