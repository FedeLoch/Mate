Class {
	#name : 'MateBlocGrammarByLangTest',
	#superclass : 'MateGrammarByLangTest',
	#category : 'Mate-Generation Tests',
	#package : 'Mate',
	#tag : 'Generation Tests'
}

{ #category : 'running' }
MateBlocGrammarByLangTest >> newGrammar [

	^ MateBlocGrammarByLang new
]

{ #category : 'tests' }
MateBlocGrammarByLangTest >> testGrammarBlChildrenArrayDeclarationsMatch [
	
	self testDecl: BlChildrenArray expects: (MateInstDecl new type: BlChildrenArray; instanceVariableDeclarations: {
		MateInstArrayVarDecl new name: 'array'; elementType: BlElement; sizeBetween: 0 and: 10.
	})
]

{ #category : 'tests' }
MateBlocGrammarByLangTest >> testGrammarBlColorPaintDeclarationsMatch [
	
	self testDecl: BlColorPaint expects: (MateInstDecl new type: BlColorPaint; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'color'; type: Color.
	})
]

{ #category : 'tests' }
MateBlocGrammarByLangTest >> testGrammarBlCustomVisualsDeclarationsMatch [
	
	self testDecl: BlCustomVisuals expects: (MateInstDecl new type: BlCustomVisuals; instanceVariableDeclarations:{
		MateInstVarDecl new name: 'background'; type: (BlPaintBackground | BlTransparentBackground).
		MateInstVarDecl new name: 'geometry'; type: (BlRectangleGeometry | BlEllipseGeometry | BlTriangleGeometry).
		MateInstVarDecl new name: 'clipChildren'; type: Boolean.
	})
]

{ #category : 'tests' }
MateBlocGrammarByLangTest >> testGrammarBlElementDeclarationsMatch [
	
	self testDecl: BlElement expects: (MateInstDecl new type: BlElement; instanceVariableDeclarations: { 	
		MateInstVarDecl new name: 'children'; type: BlChildrenArray.
		MateInstRefVarDecl new name: 'parent'; type: BlElement.
		MateInstVarDecl new name: 'visuals'; type: (BlCustomVisuals | BlDefaultVisuals).
		MateInstVarDecl new name: 'constraints'; type: BlLayoutCommonConstraints.
	}; selfReferences: { MateReferencePath new: { MatePathProp from: 'children' . MatePathProp from: 'array' . MatePathEachProp from: 'parent' }})
]

{ #category : 'tests' }
MateBlocGrammarByLangTest >> testGrammarBlLayoutCommonConstraintsAxisDeclarationsMatch [
	
	self testDecl: BlLayoutCommonConstraintsAxis expects: (MateInstDecl new type: BlLayoutCommonConstraintsAxis; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'resizer'; type: BlLayoutExactResizer.
	})
]

{ #category : 'tests' }
MateBlocGrammarByLangTest >> testGrammarBlLayoutCommonConstraintsDeclarationsMatch [
	
	self testDecl: BlLayoutCommonConstraints expects: (MateInstDecl new type: BlLayoutCommonConstraints; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'position'; type: Point.
		MateInstVarDecl new name: 'vertical'; type: BlLayoutCommonConstraintsAxis.
		MateInstVarDecl new name: 'horizontal'; type: BlLayoutCommonConstraintsAxis.
	})
]

{ #category : 'tests' }
MateBlocGrammarByLangTest >> testGrammarBlLayoutExactResizerDeclarationsMatch [
	
	self testDecl: BlLayoutExactResizer expects: (MateInstDecl new type: BlLayoutExactResizer; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'size'; type: SmallFloat64; constraint: (MateConstraint between: 100 and: 1000).
	})
]

{ #category : 'tests' }
MateBlocGrammarByLangTest >> testGrammarBlPaintBackgroundDeclarationsMatch [
	
	self testDecl: BlPaintBackground expects: (MateInstDecl new type: BlPaintBackground; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'paint'; type: BlColorPaint.
	})
]

{ #category : 'tests' }
MateBlocGrammarByLangTest >> testGrammarBlTriangleGeometryDeclarationsMatch [
	
	self testDecl: BlTriangleGeometry expects: (MateInstDecl new type: BlTriangleGeometry; instanceVariableDeclarations: {
		MateInstOneOfVarDecl new name: 'orientation'; options: { #top . #right . #left . #bottom }.
	})
]
