Class {
	#name : 'MateInstArrayVarDecl',
	#superclass : 'MateInstVarDecl',
	#instVars : [
		'elementType',
		'minSize',
		'maxSize'
	],
	#category : 'Mate-Grammar',
	#package : 'Mate',
	#tag : 'Grammar'
}

{ #category : 'comparing' }
MateInstArrayVarDecl >> = anObject [

	super = anObject ifFalse: [ ^ false ].
	
	^ elementType = anObject elementType and: [ 
		minSize = anObject minSize and: [ 
			maxSize = anObject maxSize ] ]
]

{ #category : 'visiting' }
MateInstArrayVarDecl >> acceptSize: size [ 
	
	^ size between: minSize and: maxSize 
]

{ #category : 'accessing' }
MateInstArrayVarDecl >> elementType [

	^ elementType
]

{ #category : 'accessing' }
MateInstArrayVarDecl >> elementType: aType [

	elementType := aType
]

{ #category : 'comparing' }
MateInstArrayVarDecl >> hash [

	^ ((super hash bitXor: elementType hash) bitXor: minSize hash) bitXor: maxSize hash
]

{ #category : 'accessing' }
MateInstArrayVarDecl >> maxSize [

	^ maxSize
]

{ #category : 'accessing' }
MateInstArrayVarDecl >> minSize [

	^ minSize
]

{ #category : 'rendering' }
MateInstArrayVarDecl >> renderShape: totalVisits [

	| label box color composite node arrayLabel |
	
	node := MateGrammarNode new.
	node declaration: self.
	arrayLabel := self name , ': [' , minSize asString , '..' , maxSize asString , ']'.
	node label: arrayLabel.
	node totalVisits: self totalVisits.
	
	label := RSLabel new text: arrayLabel; color: Color black.
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
			s nextPutAll: 'Array: '; nextPutAll: n label; cr.
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
MateInstArrayVarDecl >> renderShapes: totalVisits parent: parentNode [

	| myShape myNode elementNode elementLabel elementBox elementComposite |
	
	myShape := self renderShape: totalVisits.
	myNode := myShape model.
	parentNode ifNotNil: [
		myNode parent: parentNode.
		parentNode children add: myNode
	].
	
	"Child node for element type"
	elementNode := MateGrammarNode new.
	elementNode declaration: nil.
	elementNode label: elementType name.
	elementNode totalVisits: self totalVisits.
	elementNode parent: myNode.
	myNode children add: elementNode.
	
	elementLabel := RSLabel new text: elementType name; color: Color black.
	
	elementBox := RSBox new 
		extent: (elementLabel extent + (16@8));
		cornerRadius: 4;
		color: (self heatColor: totalVisits);
		border: (RSBorder new color: (Color gray: 0.6); width: 1; dashArray: #(2 2)).
		
	elementComposite := RSComposite new model: elementNode; shapes: { elementBox . elementLabel }; yourself.
	
	elementComposite @ (RSPopup new text: [ :n | 
		'Element type: ', n label
	]).
	
	^ { myShape . elementComposite }
]

{ #category : 'accessing' }
MateInstArrayVarDecl >> size: value [
	
	minSize := value.
	maxSize := value.
]

{ #category : 'accessing' }
MateInstArrayVarDecl >> sizeBetween: value and: anotherValue [
	
	minSize := value.
	maxSize := anotherValue.
]

{ #category : 'as yet unclassified' }
MateInstArrayVarDecl >> updateMe: parent replacingChild: child by: newChild [

	| index |

	index := parent instance indexOf: child instance.
	parent addEdge: newChild at: index.
	parent instance at: index put: newChild instance.
]

{ #category : 'visiting' }
MateInstArrayVarDecl >> visiting: aVisitor from: context constraint: aConstraint [

	^ aVisitor visitArrayDecl: self from: context
]
