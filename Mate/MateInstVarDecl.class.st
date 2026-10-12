Class {
	#name : 'MateInstVarDecl',
	#superclass : 'MateDecl',
	#instVars : [
		'name',
		'constraint',
		'nullable'
	],
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'comparing' }
MateInstVarDecl >> = anObject [

	super = anObject ifFalse: [ ^ false ].
	
	^ name = anObject name and: [ constraint = anObject constraint and: [ self nullable = anObject nullable ] ]
]

{ #category : 'as yet unclassified' }
MateInstVarDecl >> acceptType: aType [

	^ type acceptType: aType
]

{ #category : 'as yet unclassified' }
MateInstVarDecl >> chooseOneTypeFrom: context [

	^ type getOneFrom: context
]

{ #category : 'accessing' }
MateInstVarDecl >> constraint [

	^ constraint
]

{ #category : 'accessing' }
MateInstVarDecl >> constraint: aConstraint [

	constraint := aConstraint
]

{ #category : 'as yet unclassified' }
MateInstVarDecl >> explorationPercentage [

	^ visits ifEmpty: [ 0 ] ifNotEmpty: [ 1 ]
]

{ #category : 'comparing' }
MateInstVarDecl >> hash [

	^ self class hash bitXor: name hash
]

{ #category : 'accessing' }
MateInstVarDecl >> maxSize [

	^ 0
]

{ #category : 'actions' }
MateInstVarDecl >> merge: decl [
	
	self mergeType: decl type.
	nullable := self nullable or: [ decl nullable ]
]

{ #category : 'actions' }
MateInstVarDecl >> mergeType: aType [

	aType ifNil: [ ^ nil ].
	
	type := MateOptionalType union: type with: aType
]

{ #category : 'accessing' }
MateInstVarDecl >> name [

	^ name
]

{ #category : 'accessing' }
MateInstVarDecl >> name: instanceVariableName [

	name := instanceVariableName 
]

{ #category : 'accessing' }
MateInstVarDecl >> nullable [

	^ nullable ifNil: [ false ]
]

{ #category : 'accessing' }
MateInstVarDecl >> nullable: aBoolean [

	nullable := aBoolean
]

{ #category : 'accessing' }
MateInstVarDecl >> reachableTypes [

	^ self types
]

{ #category : 'rendering' }
MateInstVarDecl >> renderShape: totalVisits [

	| label box color composite node typeName |
	
	node := MateGrammarRenderNode new.
	node declaration: self.
	node label: self name.
	node totalVisits: self totalVisits.
	
	typeName := type ifNil: [ 'nil' ] ifNotNil: [ type name ].
	label := RSLabel new text: (self name , ': ' , typeName); color: Color black.
	color := self heatColor: totalVisits.
	
	box := RSBox new 
		extent: (label extent + (20@10));
		cornerRadius: 5;
		color: color;
		border: (self totalVisits = 0
			ifTrue: [ RSBorder new color: (Color red alpha: 0.5); width: 1; dashArray: #(4 3) ]
			ifFalse: [ RSBorder new color: (Color gray: 0.5); width: 1 ]).
		
	composite := RSComposite new model: node; shapes: { box . label }; yourself.
		
	composite @ (RSPopup new text: [ :n | 
		String streamContents: [ :s |
			s nextPutAll: 'Var: '; nextPutAll: n label; cr.
			s nextPutAll: 'Visits: '; print: n totalVisits.
			totalVisits > 0 ifTrue: [
				s cr; nextPutAll: 'Coverage: '; 
				  print: ((n totalVisits / totalVisits * 100) asFloat round: 1); nextPutAll: '%'
			]
		]
	]).

	^ composite
]

{ #category : 'rendering' }
MateInstVarDecl >> renderShapes: totalVisits parent: parentNode [

	| myShape myNode typeShapes |
	
	myShape := self renderShape: totalVisits.
	myNode := myShape model.
	parentNode ifNotNil: [
		myNode parent: parentNode.
		parentNode children add: myNode
	].
	
	type ifNil: [ ^ { myShape } ].
	
	typeShapes := (type renderShapes: totalVisits parent: myNode) asOrderedCollection.
	
	^ { myShape } , typeShapes
]

{ #category : 'accessing' }
MateInstVarDecl >> types [

	^ MateOptionalType typesOf: type
]

{ #category : 'visiting' }
MateInstVarDecl >> visiting: aVisitor from: context constraint: aConstraint [

	^ aVisitor visitInstVarDecl: self from: context
]
