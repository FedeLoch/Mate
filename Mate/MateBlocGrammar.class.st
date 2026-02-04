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
			children: BlChildrenArray,
			visuals: BlCustomVisuals,
			constraints: BlLayoutCommonConstraints
		}.
		
		BlChildrenArray -> { 
			array: { type: [ BlElement ], sizeBetween: 0 and: 30 }
		}.
		
		BlCustomVisuals -> { 
			background: (BlPaintBackground | BlTransparentBackground),
			geometry: (BlRectangleGeometry | BlEllipseGeometry | BlTriangleGeometry),
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
MateBlocGrammar >> generator [

	^ generator 
]

{ #category : 'accessing' }
MateBlocGrammar >> initialize [ 

	super initialize.
	
	self addTypeDeclaration: (MateInstDecl new type: BlElement; instanceVariableDeclarations: { 	
		MateInstVarDecl new name: 'children'; type: BlChildrenArray.
		MateInstVarDecl new name: 'visuals'; type: BlCustomVisuals.
		MateInstVarDecl new name: 'constraints'; type: BlLayoutCommonConstraints.
	}).
	
	self addTypeDeclaration: (MateInstDecl new type: BlChildrenArray; instanceVariableDeclarations: {
		MateInstArrayVarDecl new name: 'array'; elementType: BlElement; sizeBetween: 0 and: 30.
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
		MateInstOneOfVarDecl new name: 'orientation'; options: { #top . #right . #left . #bottom }.
	}).
]
