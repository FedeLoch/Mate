Class {
	#name : 'EnBlocGrammar',
	#superclass : 'EnOGGrammar',
	#category : 'En-Grammar Tests',
	#package : 'En',
	#tag : 'Grammar Tests'
}

{ #category : 'accessing' }
EnBlocGrammar >> defineGrammar [ 

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
EnBlocGrammar >> initialize [ 

	super initialize.
	
	self addTypeDeclaration: (EnInstDecl new type: BlElement; instanceVariableDeclarations: { 	
		EnInstVarDecl new name: 'children'; type: BlChildrenArray.
		EnInstVarDecl new name: 'visuals'; type: BlCustomVisuals.
		EnInstVarDecl new name: 'constraints'; type: BlLayoutCommonConstraints.
	}).
	
	self addTypeDeclaration: (EnInstDecl new type: BlChildrenArray; instanceVariableDeclarations: {
		EnInstVarDecl new name: 'array'; type: (EnArray of: BlElement); constraint: (EnArrayConstraint sizeBetween: 0 and: 30)
	}).
	
	self addTypeDeclaration: (EnInstDecl new type: BlCustomVisuals; instanceVariableDeclarations:{
		EnInstVarDecl new name: 'background'; type: (BlPaintBackground | BlTransparentBackground).
		EnInstVarDecl new name: 'geometry'; type: (BlRectangleGeometry | BlEllipseGeometry | BlTriangleGeometry).
		EnInstVarDecl new name: 'clipChildren:'; type: Boolean.
	}).
	
	self addTypeDeclaration: (EnInstDecl new type: BlLayoutCommonConstraints; instanceVariableDeclarations: { 	
		EnInstVarDecl new name: 'position'; type: Point.
		EnInstVarDecl new name: 'vertical'; type: BlLayoutCommonConstraintsAxis.
		EnInstVarDecl new name: 'horizontal'; type: BlLayoutCommonConstraintsAxis.
	}).
	
	self addTypeDeclaration: (EnInstDecl new type: BlLayoutCommonConstraintsAxis; instanceVariableDeclarations: {
		EnInstVarDecl new name: 'resizer'; type: BlLayoutExactResizer.
	}).
	
	self addTypeDeclaration: (EnInstDecl new type: BlLayoutExactResizer; instanceVariableDeclarations: {
		EnInstVarDecl new name: 'size'; type: SmallInteger.
	}).
	
	self addTypeDeclaration: (EnInstDecl new type: BlPaintBackground; instanceVariableDeclarations: {
		EnInstVarDecl new name: 'paint'; type: Color.
	}).
	
	self addTypeDeclaration: (EnInstDecl new type: BlTriangleGeometry; instanceVariableDeclarations: {
		EnInstVarDecl new name: 'orientation'; constraint: (EnConstraint oneOf: { #top . #right . #left . #bottom }).
	}).
]
