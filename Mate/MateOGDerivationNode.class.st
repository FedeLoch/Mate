Class {
	#name : 'MateOGDerivationNode',
	#superclass : 'Object',
	#instVars : [
		'declaration',
		'edges',
		'context',
		'instance'
	],
	#category : 'Mate-Derivation Tree',
	#package : 'Mate',
	#tag : 'Derivation Tree'
}

{ #category : 'initialization' }
MateOGDerivationNode >> addEdge: anEdge at: key [

	edges at: key put: anEdge
]

{ #category : 'as yet unclassified' }
MateOGDerivationNode >> allNodes [

	^ { self }, (edges flatCollect: #allNodes)
]

{ #category : 'converting' }
MateOGDerivationNode >> asLabel [
	
	^ RSLabel new text: declaration name; color: Color black.
]

{ #category : 'accessing' }
MateOGDerivationNode >> context [

	^ context
]

{ #category : 'accessing' }
MateOGDerivationNode >> context: aContext [

	context := aContext 
]

{ #category : 'as yet unclassified' }
MateOGDerivationNode >> currentReward [

	^ declaration reward: context
]

{ #category : 'accessing' }
MateOGDerivationNode >> declaration [

	^ declaration
]

{ #category : 'accessing' }
MateOGDerivationNode >> declaration: aMateInstanceDeclaration [ 

	declaration := aMateInstanceDeclaration
]

{ #category : 'accessing' }
MateOGDerivationNode >> edges [

	^ edges
]

{ #category : 'initialization' }
MateOGDerivationNode >> initialize [ 
	
	super initialize.
	edges := Dictionary new.
]

{ #category : 'as yet unclassified' }
MateOGDerivationNode >> instance [

	^ instance
]

{ #category : 'accessing' }
MateOGDerivationNode >> instance: anInstance [

	instance := anInstance 
]

{ #category : 'rendering' }
MateOGDerivationNode >> nodeColor [
	
	^ Color fromHexString: '9B59B6'
]

{ #category : 'as yet unclassified' }
MateOGDerivationNode >> recursiveBackPropagate: improvement seen: set [
	"Update current node's declaration and recursively propagate to children."
	 
	"seen set prevents infinite loops in cyclic graphs."
	(set includes: self) ifTrue: [ ^ self ].
	set add: self.
	
	"Update this declaration's reward"
	declaration updateReward: improvement context: context.
	
	"Propagate to all child edges"
	edges valuesDo: [ :child |
		child recursiveBackPropagate: improvement seen: set
	].
]

{ #category : 'rendering' }
MateOGDerivationNode >> render [

	| canvas shapes |
	shapes := self shapes.
	canvas := RSCanvas new.
	canvas addAll: shapes.

	RSLineBuilder arrowedLine
		withBorderAttachPoint;
		canvas: canvas;
		connectFrom: [ :e | e context parentNode ].

	(shapes size >= 100
		 ifTrue: [ RSRadialTreeLayout ]
		 ifFalse: [ RSHorizontalDominanceTreeLayout ]) new
		horizontalGap: 50;
		verticalGap: 30;
		on: canvas nodes.

	canvas @ RSCanvasController.
	canvas @ RSZoomToFitCanvasInteraction.

	^ canvas
]

{ #category : 'as yet unclassified' }
MateOGDerivationNode >> replaceRefDeclarationsFrom: source [ 
	
	(declaration isRef and: [ instance isNil ]) ifTrue: [
		self instance: source instance
	] ifFalse: [
		"Propagate to edges"
		edges keys do: [ :key | | edge nextSource |
			source edges at: key ifPresent: [
				(edges at: key) replaceRefDeclarationsFrom: (source edges at: key)
			]
		]
	]
]

{ #category : 'accessing' }
MateOGDerivationNode >> shape [
	
	| label box color composite |
	
	label := self asLabel.
	color := self nodeColor.
	
	"Rounded rectangle with gradient"
	box := RSBox new 
		extent: (label extent + (20@16));
		cornerRadius: 8;
		color: color;
		border: (RSBorder new 
			width: 2; 
			color: (color mixed: 0.7 with: Color black)).
	
	composite := RSComposite new
		draggable;
		model: self;
		shapes: (RSGroup with: box with: label);
		yourself.
	
	"Add popup on hover"
	composite @ (RSPopup new text: [ :node | node tooltipText ]).
	
	^ composite
]

{ #category : 'accessing' }
MateOGDerivationNode >> shapes [
	
	^ { self shape }, (edges flatCollect: [ :edge | edge shapes ])
]

{ #category : 'rendering' }
MateOGDerivationNode >> tooltipText [
		
	^ String streamContents: [ :s |
		s nextPutAll: 'Type: '; nextPutAll: declaration name asString.
		instance ifNotNil: [ 
			s cr; nextPutAll: 'Value: '; nextPutAll: instance printString.
		].
		context ifNotNil: [
			context level ifNotNil: [ :lvl |
				s cr; nextPutAll: 'Level: '; nextPutAll: lvl asString.
			].
		].
	]
]
