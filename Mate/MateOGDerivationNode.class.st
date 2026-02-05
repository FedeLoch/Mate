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

{ #category : 'as yet unclassified' }
MateOGDerivationNode >> recursiveBackPropagate: improvement from: aContext seen: set [
	"Update this node's declaration and recursively propagate to children.
	 The 'seen' set prevents infinite loops in cyclic graphs."

	(set includes: self) ifTrue: [ ^ self ].
	set add: self.
	
	"Update this declaration's reward"
	declaration updateReward: improvement context: aContext.
	
	"Propagate to all child edges"
	edges valuesDo: [ :childNode |
		childNode recursiveBackPropagate: improvement from: aContext seen: set.
	].
]

{ #category : 'rendering' }
MateOGDerivationNode >> render [
	
	| canvas shapes lines |
	
	shapes := self shapes.
	canvas := RSCanvas new.
	canvas addAll: shapes.
	
	"Build edges with labels"
	lines := self buildEdgesOn: canvas.
	canvas addAll: lines.
	
	"Apply horizontal tree layout for better readability"
	RSHorizontalTreeLayout new 
		horizontalGap: 50;
		verticalGap: 30;
		on: canvas nodes.
	
	"Add interactions"
	canvas @ RSCanvasController.
	canvas @ RSZoomToFitCanvasInteraction.
	
	"Add minimap for overview navigation"
	canvas addInteraction: (RSMiniMap new 
		extent: 150@100;
		yourself).
	
	^ canvas
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
MateOGDerivationNode >> buildEdgesOn: canvas [
	"Build labeled edges connecting parent to children"
	
	| lines |
	lines := OrderedCollection new.
	
	edges keysAndValuesDo: [ :slotName :childNode |
		| parentShape childShape line labelShape |
		
		parentShape := canvas shapeFromModel: self.
		childShape := canvas shapeFromModel: childNode.
		
		(parentShape notNil and: [ childShape notNil ]) ifTrue: [
			"Create curved arrow line"
			line := RSBezier new
				withVerticalAttachPoint;
				from: parentShape;
				to: childShape;
				color: (Color gray alpha: 0.6);
				border: (RSBorder new color: (Color gray alpha: 0.6); width: 1.5);
				yourself.
			line markerEnd: (RSShapeFactory arrow 
				size: 10; 
				color: (Color gray alpha: 0.8)).
			
			"Add edge label"
			labelShape := RSLabel new
				text: slotName asString;
				fontSize: 9;
				color: (Color gray darker);
				yourself.
			
			canvas add: labelShape.
			lines add: line.
		].
	].
	
	^ lines
]

{ #category : 'rendering' }
MateOGDerivationNode >> nodeColor [
	
	^ Color fromHexString: '9B59B6'
]

{ #category : 'rendering' }
MateOGDerivationNode >> tooltipText [
		
	^ String streamContents: [ :s |
		s nextPutAll: 'Type: '; nextPutAll: declaration name asString.
		instance ifNotNil: [ 
			s cr; nextPutAll: 'Value: '; nextPutAll: instance printString truncateWithElipsisTo: 50.
		].
		context ifNotNil: [
			context level ifNotNil: [ :lvl |
				s cr; nextPutAll: 'Level: '; nextPutAll: lvl asString.
			].
		].
	]
]

