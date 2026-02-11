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
			visuals: (BlCustomVisuals | BlDefaultVisuals),
			constraints: BlLayoutCommonConstraints,
			withSelfReferences: {
				children.array[ .parent ]: self
			}
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
			paint: Color
		}
		BlTriangleGeometry -> {
			orientation: { oneOf: { #top . #right . #left . #bottom } }
		}
'
	

]
