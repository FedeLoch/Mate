Class {
	#name : 'MateBlocGrammarByLang',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Examples',
	#package : 'Mate',
	#tag : 'Grammar Examples'
}

{ #category : 'accessing' }
MateBlocGrammarByLang >> defineObjectGraph [

	^ '
	 	BlElement -> {
			children: BlChildrenArray,
			parent: { refType: BlElement },
			visuals: (BlCustomVisuals | BlDefaultVisuals),
			constraints: BlLayoutCommonConstraints,
			selfReferences: { children.array[ .parent ] }
		}
		
		BlChildrenArray -> { 
			array: { type: [ BlElement ], sizeBetween: 0 and: 10 }
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
			size: (SmallInteger | SmallFloat64)
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
