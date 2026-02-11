Class {
	#name : 'MateBlocGrammar',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Examples',
	#package : 'Mate',
	#tag : 'Grammar Examples'
}

{ #category : 'accessing' }
MateBlocGrammar >> initialize [ 

	super initialize.
	
	self addTypeDeclaration: (MateInstDecl new type: BlElement; instanceVariableDeclarations: { 	
		MateInstVarDecl new name: 'children'; type: BlChildrenArray.
		MateInstRefVarDecl new name: 'parent'; type: BlElement.
		MateInstVarDecl new name: 'visuals'; type: (BlCustomVisuals | BlDefaultVisuals).
		MateInstVarDecl new name: 'constraints'; type: BlLayoutCommonConstraints.
	}; selfReferences: { MateReferencePath new: { MatePathProp from: 'children' . MatePathProp from: 'array' . MatePathEachProp from: 'parent' }}).
	
	self addTypeDeclaration: (MateInstDecl new type: BlChildrenArray; instanceVariableDeclarations: {
		MateInstArrayVarDecl new name: 'array'; elementType: BlElement; sizeBetween: 0 and: 10.
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
		MateInstVarDecl new name: 'size'; type: (SmallInteger | SmallFloat64).
	}).
	
	self addTypeDeclaration: (MateInstDecl new type: BlPaintBackground; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'paint'; type: Color.
	}).
	
	self addTypeDeclaration: (MateInstDecl new type: BlTriangleGeometry; instanceVariableDeclarations: {
		MateInstOneOfVarDecl new name: 'orientation'; options: { #top . #right . #left . #bottom }.
	}).
]
