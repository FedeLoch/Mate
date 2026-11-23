Class {
	#name : 'MateRegexGrammar',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Examples',
	#package : 'Mate',
	#tag : 'Grammar Examples'
}

{ #category : 'accessing' }
MateRegexGrammar >> defineObjectGraph [

	^ 'RxMatcher -> {
	matcher: RxmMarker,
	ignoreCase: Boolean,
	startOptimizer: RxMatchOptimizer,
	markerCount: { type: SmallInteger, between: 2 and: 2 }
}

RxMatchOptimizer -> {
	ignoreCase: Boolean,
	prefixes: { type: [ Character ], collection: Set, sizeBetween: 0 and: 5 },
	nonPrefixes: { type: [ Object ], collection: Set, sizeBetween: 0 and: 0 },
	conditions: { type: [ ByteSymbol ], collection: Set, sizeBetween: 0 and: 2 },
	methodPredicates: { type: [ Object ], collection: Set, sizeBetween: 0 and: 0 },
	nonMethodPredicates: { type: [ Object ], collection: Set, sizeBetween: 0 and: 0 },
	nonPredicates: { type: [ Object ], collection: Set, sizeBetween: 0 and: 0 },
	lookarounds: { type: [ Object ], collection: Set, sizeBetween: 0 and: 0 }
}

RxmBranch -> {
	next: RxmPredicate | RxmSpecial | RxmSubstring,
	loopback: Boolean,
	alternative: (RxmLink | RxmMarker | RxmSubstring)?
}

RxmLink -> {
	next: RxmPredicate | RxmSubstring
}

RxmMarker -> {
	next: RxmBranch | RxmTerminator,
	index: { type: SmallInteger, between: 1 and: 2 }
}

RxmPredicate -> {
	next: RxmBranch | RxmLink | RxmMarker | RxmPredicate
}

RxmSpecial -> {
	next: RxmMarker | RxmPredicate | RxmSubstring,
	matchSelector: ByteSymbol
}

RxmSubstring -> {
	next: RxmMarker | RxmSpecial,
	sample: ByteString
}'
]
