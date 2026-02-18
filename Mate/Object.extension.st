Extension { #name : 'Object' }

{ #category : '*Mate' }
Object class >> acceptType: aType [
	
	^ self = aType
]

{ #category : '*Mate' }
Object class >> getOne [

	^ self
]

{ #category : '*Mate' }
Object class >> getOneFrom: context [
	"For single types (not MateOptionalType), just return self ignoring context"
	^ self
]

{ #category : '*Mate' }
Object class >> renderShapes: totalVisits parent: parentNode [

	| node label box composite |
	
	node := MateGrammarRenderNode new.
	node declaration: nil.
	node label: self name.
	node totalVisits: 0.
	parentNode ifNotNil: [ 
		node parent: parentNode.
		parentNode children add: node 
	].

	label := RSLabel new text: self name; color: Color gray.
	
	box := RSBox new 
		extent: (label extent + (16@8));
		cornerRadius: 4;
		color: (Color veryLightGray);
		border: (RSBorder new color: (Color gray: 0.7); width: 1; dashArray: #(2 2)).
		
	composite := RSComposite new model: node; shapes: { box . label }; yourself.
		
	composite @ (RSPopup new text: [ :n | 
		'Leaf type: ', n label
	]).

	^ { composite }
]

{ #category : '*Mate' }
Object class >> types [

	^ { self }
]

{ #category : '*Mate' }
Object class >> updateReward: improvement context: context from: decl [
	
	^ nil
]

{ #category : '*Mate' }
Object class >> | aClass [ 
	
	^ MateOptionalType options: { self . aClass }
]
