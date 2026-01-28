Class {
	#name : 'RandomFuzzer',
	#superclass : 'Object',
	#category : 'En-RandomObjectFuzzer',
	#package : 'En',
	#tag : 'RandomObjectFuzzer'
}

{ #category : 'as yet unclassified' }
RandomFuzzer >> classCandidates: var for: aClass [

	| selectorsToRespond |
	selectorsToRespond := self selectorsFor: var in: aClass.

	^ Smalltalk allClasses select: [ :cls |
    	(selectorsToRespond allSatisfy: [:sel | cls canUnderstand: sel ]) and: [ cls isTrait not ]
	]
]

{ #category : 'as yet unclassified' }
RandomFuzzer >> fuzzInstancesOf: aClass count: n depth: maxDepth [

	^ (1 to: n) collect: [:i |
        self generateInstanceOf: aClass depth: maxDepth
    ]

]

{ #category : 'as yet unclassified' }
RandomFuzzer >> genInstanceVar: var for: aClass depth: maxDepth [

	"var -> possibleClass1 | possibleClass2 ..."

	| candidates |
    maxDepth <= 0 ifTrue: [ ^ self nilObject ].

	candidates := self classCandidates: var for: aClass. "An array of classes | production" 

	candidates ifEmpty: [ ^ self nilObject ].
	
	^ self generateInstanceOf: (self selectCandidate: candidates) depth: maxDepth

]

{ #category : 'as yet unclassified' }
RandomFuzzer >> generateInstanceOf: aClass depth: maxDepth [

	"AClass -> New + var1 var2 var3 ..."

    ^ aClass allInstVarNames inject: aClass basicNew into: [ :inst :ivar | | value |
			value := self genInstanceVar: ivar for: aClass depth: maxDepth - 1.
"			inst instVarAt: (aClass allInstVarNames indexOf: ivar) put: value."
        	inst instVarNamed: ivar put: value.
		  	inst
    ]
]

{ #category : 'as yet unclassified' }
RandomFuzzer >> nilObject [

	^ nil
]

{ #category : 'as yet unclassified' }
RandomFuzzer >> selectCandidate: candidates [

    ^ candidates atRandom
]

{ #category : 'as yet unclassified' }
RandomFuzzer >> selectorsFor: var class: class method: method [ 

	^ method sendNodes inject: OrderedCollection new into: [ :selectors :node | | leftNode |
		leftNode := node.
		[leftNode receiver isMessage ] whileTrue: [ leftNode := leftNode receiver ].
	
		(leftNode receiver isVariable and: [ leftNode receiver name = var ]) ifTrue: [
			selectors add: leftNode selector 
		].
		selectors
	]
]

{ #category : 'as yet unclassified' }
RandomFuzzer >> selectorsFor: var in: aClass [

	^ aClass methodDict values inject: OrderedCollection new into: [ :selectors :method |
		selectors addAll: (self selectorsFor: var class: aClass method: method)
	]
]
