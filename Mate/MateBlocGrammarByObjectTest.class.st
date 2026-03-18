Class {
	#name : 'MateBlocGrammarByObjectTest',
	#superclass : 'MateGrammarByObjectTest',
	#category : 'Mate-Generation Tests',
	#package : 'Mate',
	#tag : 'Generation Tests'
}

{ #category : 'running' }
MateBlocGrammarByObjectTest >> objectInstance [

	^ BlElement new
		  id: #B;
		  position: 100 @ 0;
		  extent: 100 @ 100;
		  background: Color green;
		  border: (BlBorder paint: Color blue width: 2);
		  addChild: (BlElement new
				   id: #BA;
				   extent: 50 @ 50;
				   background: Color blue;
				   yourself)
]

{ #category : 'tests' }
MateBlocGrammarByObjectTest >> testGrammarBlChildrenArrayDeclarationsMatch [
	
	self testDecl: BlChildrenArray expects: (MateInstDecl new type: BlChildrenArray; instanceVariableDeclarations: {
		MateInstArrayVarDecl new name: 'array'; elementType: BlElement.
	})
]

{ #category : 'tests' }
MateBlocGrammarByObjectTest >> testGrammarBlColorPaintDeclarationsMatch [
	
	self testDecl: BlColorPaint expects: (MateInstDecl new type: BlColorPaint; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'color'; type: Color
	})
]

{ #category : 'tests' }
MateBlocGrammarByObjectTest >> testGrammarBlCustomVisualsDeclarationsMatch [
	
	self testDecl: BlCustomVisuals expects: (MateInstDecl new type: BlCustomVisuals; instanceVariableDeclarations:{
		MateInstVarDecl new name: 'border'; type: BlBorder.
		MateInstVarDecl new name: 'background'; type: BlPaintBackground.
	})
]

{ #category : 'tests' }
MateBlocGrammarByObjectTest >> testGrammarBlElementDeclarationsMatch [
	
	self testDecl: BlElement expects: (MateInstDecl new type: BlElement; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'spaceReference'; type: BlNullSpaceReference.
		MateInstVarDecl new name: 'children'; type: BlChildrenArray.
		MateInstVarDecl new name: 'bounds'; type: BlElementLocalBounds.
		MateInstVarDecl new name: 'measuredBounds'; type: BlElementLocalBounds.
		MateInstVarDecl new name: 'boundsCache'; type: BlBoundsCache.
		MateInstVarDecl new name: 'eventDispatcher'; type: BlElementEventDispatcher.
		MateInstVarDecl new name: 'constraints'; type: BlLayoutCommonConstraints.
		MateInstVarDecl new name: 'layout'; type: BlBasicLayout.
		MateInstVarDecl new name: 'transformation'; type: BlElementCachedIdentityTransformation.
		MateInstVarDecl new name: 'taskQueue'; type: BlTaskQueue.
		MateInstVarDecl new name: 'errorHandler'; type: BlCompositeErrorHandler.
		MateInstVarDecl new name: 'userData'; type: IdentityDictionary.
		MateInstVarDecl new name: 'visuals'; type: BlCustomVisuals.
		MateInstVarDecl new name: 'flags'; type: BlElementFlags.
	}; selfReferences: {})
]

{ #category : 'tests' }
MateBlocGrammarByObjectTest >> testGrammarBlLayoutCommonConstraintsAxisDeclarationsMatch [
	
	self testDecl: BlLayoutCommonConstraintsAxis expects: (MateInstDecl new type: BlLayoutCommonConstraintsAxis; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'resizer'; type: BlLayoutExactResizer.
	})
]

{ #category : 'tests' }
MateBlocGrammarByObjectTest >> testGrammarBlLayoutCommonConstraintsDeclarationsMatch [
	
	self testDecl: BlLayoutCommonConstraints expects: (MateInstDecl new type: BlLayoutCommonConstraints; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'vertical'; type: BlLayoutCommonConstraintsAxis.
		MateInstVarDecl new name: 'horizontal'; type: BlLayoutCommonConstraintsAxis.
		MateInstVarDecl new name: 'position'; type: Point.
		MateInstVarDecl new name: 'margin'; type: BlInsets.
		MateInstVarDecl new name: 'padding'; type: BlInsets.
		MateInstVarDecl new name: 'minHeight'; type: SmallFloat64.
		MateInstVarDecl new name: 'minWidth'; type: SmallFloat64.
		MateInstVarDecl new name: 'maxHeight'; type: BoxedFloat64.
		MateInstVarDecl new name: 'maxWidth'; type: BoxedFloat64.
		MateInstVarDecl new name: 'ignoredByLayout'; type: Boolean.
		MateInstVarDecl new name: 'accountTransformation'; type: Boolean.
	})
]

{ #category : 'tests' }
MateBlocGrammarByObjectTest >> testGrammarBlLayoutExactResizerDeclarationsMatch [
	
	self testDecl: BlLayoutExactResizer expects: (MateInstDecl new type: BlLayoutExactResizer; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'size'; type: SmallFloat64.
	})
]

{ #category : 'tests' }
MateBlocGrammarByObjectTest >> testGrammarBlPaintBackgroundDeclarationsMatch [
	
	self testDecl: BlPaintBackground expects: (MateInstDecl new type: BlPaintBackground; instanceVariableDeclarations: {
		MateInstVarDecl new name: 'paint'; type: BlColorPaint.
	})
]
