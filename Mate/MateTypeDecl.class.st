Class {
	#name : 'MateTypeDecl',
	#superclass : 'MateDecl',
	#instVars : [
		'grammar'
	],
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'accessing' }
MateTypeDecl >> grammar: aGrammar [

	grammar := aGrammar 
]

{ #category : 'accessing' }
MateTypeDecl >> name [

	^ type name 
]

{ #category : 'rendering' }
MateTypeDecl >> renderShape: totalVisits [

	| label box color composite node |
	
	node := MateGrammarNode new.
	node declaration: self.
	node label: self name.
	node totalVisits: self totalVisits.

	label := RSLabel new text: self name; color: Color black.
	color := self heatColor: totalVisits.
	
	box := RSBox new 
		extent: (label extent + (24@14));
		cornerRadius: 8;
		color: color;
		border: (RSBorder new color: (Color gray: 0.3); width: 2).
		
	composite := RSComposite new model: node; shapes: { box . label }; yourself.
		
	composite @ (RSPopup new text: [ :n | 
		String streamContents: [ :s |
			s nextPutAll: 'Type: '; nextPutAll: n label; cr.
			s nextPutAll: 'Visits: '; print: n totalVisits.
			totalVisits > 0 ifTrue: [
				s cr; nextPutAll: 'Coverage: '; 
				  print: ((n totalVisits / totalVisits * 100) asFloat round: 1); nextPutAll: '%'
			]
		]
	]).

	^ composite
]

{ #category : 'rendering' }
MateTypeDecl >> renderShapes: totalVisits parent: parentNode [

	| shape |
	shape := self renderShape: totalVisits.
	parentNode ifNotNil: [ 
		shape model parent: parentNode.
		parentNode children add: shape model 
	].
	^ { shape }
]
