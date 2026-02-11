Class {
	#name : 'MateBlocGrammarTest',
	#superclass : 'MateHandMadeGrammarTest',
	#category : 'Mate-Generation Tests',
	#package : 'Mate',
	#tag : 'Generation Tests'
}

{ #category : 'running' }
MateBlocGrammarTest >> newGrammar [

	^ MateBlocGrammar new.
]

{ #category : 'tests' }
MateBlocGrammarTest >> testGrammarCanGenerateABlChildrenArray [

	| gen |
	
	gen := grammar gen: BlChildrenArray.
	
	self assert: gen class equals: BlChildrenArray.
	self assert: (gen array) class equals: Array.
	self assert: ((0 to: 10) includes: gen array size).
]

{ #category : 'tests' }
MateBlocGrammarTest >> testGrammarCanGenerateABlCustomVisuals [

	| gen |
	
	gen := grammar gen: BlCustomVisuals.

	self assert: gen class equals: BlCustomVisuals.
	self assert: ({
			 BlPaintBackground.
			 BlTransparentBackground } includes: gen background class).
	self assert: ({
			 BlRectangleGeometry.
			 BlEllipseGeometry.
			 BlTriangleGeometry } includes: gen geometry class).
	self deny: gen clipChildren class equals: Boolean
]

{ #category : 'tests' }
MateBlocGrammarTest >> testGrammarCanGenerateABlElement [

	| element |
	
	element := grammar gen: BlElement.
	self assert: (element class) equals: BlElement.
	self assert: (element children class) equals: BlChildrenArray.
	element children array do: [ :child | self assert: child parent equals: element ].
	self assert: ({ BlCustomVisuals . BlDefaultVisuals } includes: element visuals class).
	self assert: (element constraints class) equals: BlLayoutCommonConstraints.
]

{ #category : 'tests' }
MateBlocGrammarTest >> testGrammarCanGenerateABlLayoutCommonConstraints [

	| gen |
	
	gen := grammar gen: BlLayoutCommonConstraints.

	self assert: (gen class) equals: BlLayoutCommonConstraints.
	self assert: (gen position class) equals: Point.
	self deny: (gen position) equals: Point new.
	self assert: (gen vertical class) equals: BlLayoutCommonConstraintsAxis.
	self assert: (gen horizontal class) equals: BlLayoutCommonConstraintsAxis.
	self deny: (gen horizontal) equals: gen vertical
]

{ #category : 'tests' }
MateBlocGrammarTest >> testGrammarCanGenerateABlLayoutCommonConstraintsAxis [

	| gen |
	
	gen := grammar gen: BlLayoutCommonConstraintsAxis.

	self assert: (gen class) equals: BlLayoutCommonConstraintsAxis.
	self assert: (gen resizer class) equals: BlLayoutExactResizer.
]

{ #category : 'tests' }
MateBlocGrammarTest >> testGrammarCanGenerateABlLayoutExactResizer [

	| gen |
	
	gen := grammar gen: BlLayoutExactResizer.

	self assert: (gen class) equals: BlLayoutExactResizer.
	self assert: ({ SmallInteger . SmallFloat64 } includes: gen size class)
]

{ #category : 'tests' }
MateBlocGrammarTest >> testGrammarCanGenerateABlPaintBackground [

	| gen |
	
	gen := grammar gen: BlPaintBackground.

	self assert: (gen class) equals: BlPaintBackground.
	self assert: (gen paint class) equals: Color.
	self deny: gen paint equals: Color black
]

{ #category : 'tests' }
MateBlocGrammarTest >> testGrammarCanGenerateABlTriangleGeometry [

	| gen |
	
	gen := grammar gen: BlTriangleGeometry.
	
	self assert: (gen class) equals: BlTriangleGeometry.
	self assert: ({ #top . #right . #left . #bottom } includes: (gen orientation))
]
