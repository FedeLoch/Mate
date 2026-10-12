Class {
	#name : 'MateByteStringGenerator',
	#superclass : 'MateBuiltInGenerator',
	#category : 'Mate-Generation',
	#package : 'Mate',
	#tag : 'Generation'
}

{ #category : 'translating' }
MateByteStringGenerator >> generate: aRandom [

	| size string |
	
	size := self sizeFor: aRandom.
	string := type new: size.
	1 to: size do: [ :index | string at: index put: (self characterFor: aRandom) ].
	
	^ string
]

{ #category : 'translating' }
MateByteStringGenerator >> characterFor: aRandom [

	| choice |
	
	choice := aRandom next.
	
	choice < 0.6 ifTrue: [ ^ ($a to: $z) atRandom: aRandom ].
	choice < 0.75 ifTrue: [ ^ '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' atRandom: aRandom ].
	choice < 0.9 ifTrue: [ ^ ' !"#$%&''()*+,-./:;<=>?@[\]^_`{|}~' atRandom: aRandom ].
	(type = WideString and: [ choice < 0.97 ]) ifTrue: [ ^ self wideCharacterFor: aRandom ].
	
	^ Character value: (aRandom nextInteger: 256) - 1
]

{ #category : 'translating' }
MateByteStringGenerator >> sizeFor: aRandom [

	| choice |
	
	choice := aRandom next.
	
	choice < 0.15 ifTrue: [ ^ 0 ].
	choice < 0.8 ifTrue: [ ^ aRandom nextInteger: 16 ].
	choice < 0.95 ifTrue: [ ^ 16 + (aRandom nextInteger: 48) ].
	
	^ 255 + (aRandom nextInteger: 770)
]

{ #category : 'translating' }
MateByteStringGenerator >> wideCharacterFor: aRandom [

	| code |
	
	[ code := 255 + (aRandom nextInteger: 16r10FFFF - 255).
	  code between: 16rD800 and: 16rDFFF ] whileTrue.

	^ Character value: code
]
