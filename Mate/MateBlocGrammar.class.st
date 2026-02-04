Class {
	#name : 'MateBlocGrammar',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Tests',
	#package : 'Mate',
	#tag : 'Grammar Tests'
}

{ #category : 'accessing' }
MateBlocGrammar >> defineGrammar [ 

	^ '
		BlElement -> {
			children: BlElementArray,
			visuals: BlCustomVisuals,
			constraints: BlLayoutCommonConstraints
		}.
		
		BlElementArray -> { 
			array: { type: [ BlElement ], sizeBetween: 0 and: 30 }
		}.
		
		BlCustomVisuals -> { 
			background: (BlPaintBackground | BlTransparentBackground),
			geometry: (BlRectangleGeometry | BlElipseGeometry | BlTriangleGeometry),
			clipChildren: Boolean,
		}.
		
		BlLayoutCommonConstraints -> {
			position: Point,
			vertical: BlLayoutCommonConstraintsAxis,
			horizontal: BlLayoutCommonConstraintsAxis
		}.
		
		BlLayoutCommonConstraintsAxis -> {
			resizer: BlLayoutExactResizer
		}.
		
		BlLayoutExactResizer -> {
			size: SmallInteger
		}.
		
		BlPaintBackground -> {
			paint: Color
		}.
		
		BlTriangleGeometry -> {
			orientation: { oneOf: { #top . #right . #left . #bottom } }
		}
	'
	

]

{ #category : 'accessing' }
MateBlocGrammar >> initialize [ 

	super initialize.
	
	self addTypeDeclaration: (MateInstDecl new type: BlElement; instanceVariableDeclarations: { 	
		MateInstVarDecl new name: 'children'; type: BlChildrenArray.
		MateInstVarDecl new name: 'visuals'; type: BlCustomVisuals.
		MateInstVarDecl new name: 'constraints'; type: BlLayoutCommonConstraints.
	}).
	
	"Cómo hago esto ? El array no puede ser un builtin, tiene que ser generada la derivación con el array"
	self addTypeDeclaration: (MateInstDecl new type: BlChildrenArray; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'array'; type: (MateArray of: BlElement); constraint: (MateArrayConstraint sizeBetween: 0 and: 30)
	}).
	
	self addTypeDeclaration: (MateInstDecl new type: BlCustomVisuals; instanceVariableDeclarations:{
		MateInstVarDecl new name: 'background'; type: (BlPaintBackground | BlTransparentBackground).
		MateInstVarDecl new name: 'geometry'; type: (BlRectangleGeometry | BlEllipseGeometry | BlTriangleGeometry).
		MateInstVarDecl new name: 'clipChildren'; type: Boolean.
	}).
	
	self addTypeDeclaration: (MateInstDecl new type: BlLayoutCommonConstraints; instanceVariableDeclarations: { 	
		MateInstVarDecl new name: 'position'; type: Point.
		MateInstVarDecl new name: 'vertical'; type: BlLayoutCommonConstraintsAxis.
		MateInstVarDecl new name: 'horizontal'; type: BlLayoutCommonConstraintsAxis.
	}).
	
	self addTypeDeclaration: (MateInstDecl new type: BlLayoutCommonConstraintsAxis; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'resizer'; type: BlLayoutExactResizer.
	}).
	
	self addTypeDeclaration: (MateInstDecl new type: BlLayoutExactResizer; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'size'; type: SmallInteger.
	}).
	
	self addTypeDeclaration: (MateInstDecl new type: BlPaintBackground; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'paint'; type: Color.
	}).
	
	self addTypeDeclaration: (MateInstDecl new type: BlTriangleGeometry; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'orientation'; constraint: (MateConstraint oneOf: { #top . #right . #left . #bottom }).
	}).
]
