Extension { #name : 'SmallInteger' }

{ #category : '*Mate' }
SmallInteger class >> gen [
	
	^ (self minVal to: self maxVal) atRandom 
]
