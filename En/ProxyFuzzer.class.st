Class {
	#name : 'ProxyFuzzer',
	#superclass : 'Object',
	#category : 'En-ProxyObjectFuzzer',
	#package : 'En',
	#tag : 'ProxyObjectFuzzer'
}

{ #category : 'as yet unclassified' }
ProxyFuzzer >> generateInstanceOf: aClass [

	^ aClass allInstVarNames inject: aClass basicNew into: [ :inst :var |
        	inst instVarNamed: var put: FuzzProxy new; yourself
    ]
]
