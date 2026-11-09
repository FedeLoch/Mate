Class {
	#name : 'MateBlocGrammarWithoutConstraintsByLang',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Examples',
	#package : 'Mate',
	#tag : 'Grammar Examples'
}

{ #category : 'accessing' }
MateBlocGrammarWithoutConstraintsByLang >> defineObjectGraph [

	^ '
	 	BlElement -> {
			children: BlChildrenArray,
			parent: BlElement,
			visuals: (BlCustomVisuals | BlDefaultVisuals),
			constraints: BlLayoutCommonConstraints
		}
		
		BlChildrenArray -> { 
			array: { type: [ BlElement ], sizeBetween: 1 and: 10 }
		}
		
		BlCustomVisuals -> { 
			background: (BlPaintBackground | BlTransparentBackground),
			geometry: (BlRectangleGeometry | BlEllipseGeometry | BlTriangleGeometry),
			clipChildren: Boolean,
		}
		
		BlLayoutCommonConstraints -> {
			position: Point,
			vertical: BlLayoutCommonConstraintsAxis,
			horizontal: BlLayoutCommonConstraintsAxis
		}
		
		BlLayoutCommonConstraintsAxis -> {
			resizer: BlLayoutExactResizer
		}
		
		BlLayoutExactResizer -> {
			size: { type: SmallFloat64, between: 100 and: 1000 }
		}
		
		BlPaintBackground -> {
			paint: BlColorPaint
		}
		
		BlColorPaint -> {
			color: Color
		}
		
		BlTriangleGeometry -> {
			orientation: { oneOf: { #top . #right . #left . #bottom } }
		}
'
	

]
