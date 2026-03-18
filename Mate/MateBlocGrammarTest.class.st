Class {
	#name : 'MateBlocGrammarTest',
	#superclass : 'MateGrammarTest',
	#category : 'Mate-Grammar Tests',
	#package : 'Mate',
	#tag : 'Grammar Tests'
}

{ #category : 'running' }
MateBlocGrammarTest >> newGrammar [

	^ MateBlocGrammar new
]

{ #category : 'running' }
MateBlocGrammarTest >> testPersonGrammarKnowHowToCalculateBlChildrenArrayLanguageDefinition [

	self assert: (grammar mateDefinition: BlChildrenArray) equals: 'BlChildrenArray -> {
	array: { type: [ BlElement ], sizeBetween: 0 and: 10 }
}'
]

{ #category : 'running' }
MateBlocGrammarTest >> testPersonGrammarKnowHowToCalculateBlColorPaintLanguageDefinition [

	self assert: (grammar mateDefinition: BlColorPaint) equals: 'BlColorPaint -> {
	color: Color
}'
]

{ #category : 'running' }
MateBlocGrammarTest >> testPersonGrammarKnowHowToCalculateBlCustomVisualsLanguageDefinition [

	self assert: (grammar mateDefinition: BlCustomVisuals) equals: 'BlCustomVisuals -> {
	background: BlTransparentBackground | BlPaintBackground,
	geometry: BlTriangleGeometry | BlRectangleGeometry | BlEllipseGeometry,
	clipChildren: Boolean
}'
]

{ #category : 'running' }
MateBlocGrammarTest >> testPersonGrammarKnowHowToCalculateBlElementLanguageDefinition [

	self assert: (grammar mateDefinition: BlElement) equals: 'BlElement -> {
	children: BlChildrenArray,
	parent: { refType: BlElement },
	visuals: BlDefaultVisuals | BlCustomVisuals,
	constraints: BlLayoutCommonConstraints,
	selfReferences: { children.array[ .parent ] }
}'
]

{ #category : 'running' }
MateBlocGrammarTest >> testPersonGrammarKnowHowToCalculateBlLayoutCommonConstraintsAxisLanguageDefinition [

	self assert: (grammar mateDefinition: BlLayoutCommonConstraintsAxis) equals: 'BlLayoutCommonConstraintsAxis -> {
	resizer: BlLayoutExactResizer
}'
]

{ #category : 'running' }
MateBlocGrammarTest >> testPersonGrammarKnowHowToCalculateBlLayoutCommonConstraintsLanguageDefinition [

	self assert: (grammar mateDefinition: BlLayoutCommonConstraints) equals: 'BlLayoutCommonConstraints -> {
	position: Point,
	vertical: BlLayoutCommonConstraintsAxis,
	horizontal: BlLayoutCommonConstraintsAxis
}'
]

{ #category : 'running' }
MateBlocGrammarTest >> testPersonGrammarKnowHowToCalculateBlLayoutExactResizerLanguageDefinition [

	self assert: (grammar mateDefinition: BlLayoutExactResizer) equals: 'BlLayoutExactResizer -> {
	size: SmallInteger | SmallFloat64
}'
]

{ #category : 'running' }
MateBlocGrammarTest >> testPersonGrammarKnowHowToCalculateBlPaintBackgroundLanguageDefinition [

	self assert: (grammar mateDefinition: BlPaintBackground) equals: 'BlPaintBackground -> {
	paint: BlColorPaint
}'
]

{ #category : 'running' }
MateBlocGrammarTest >> testPersonGrammarKnowHowToCalculateBlTriangleGeometryLanguageDefinition [

	self assert: (grammar mateDefinition: BlTriangleGeometry) equals: 'BlTriangleGeometry -> {
	orientation: { oneOf: { #top . #right . #left . #bottom } }
}'
]
