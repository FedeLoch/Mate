Class {
	#name : 'MateRegexGrammar',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Examples',
	#package : 'Mate',
	#tag : 'Grammar Examples'
}

{ #category : 'accessing' }
MateRegexGrammar >> defineObjectGraph [

	^ 'RxmLink -> {
	next: RxmSubstring | RxmPredicate
}

RxMatcher -> {
	matcher: RxmMarker,
	ignoreCase: Boolean,
	startOptimizer: RxMatchOptimizer,
	markerPositions: { type: [ OrderedCollection ], sizeBetween: 0 and: 16 },
	markerCount: SmallInteger,
	lastResult: Boolean
}

Set -> {
	tally: SmallInteger,
	array: { type: [ Character ], sizeBetween: 0 and: 16 }
}

RxMatchOptimizer -> {
	ignoreCase: Boolean,
	prefixes: Set,
	nonPrefixes: Set,
	conditions: Set,
	testBlock: CleanBlockClosure | FullBlockClosure,
	methodPredicates: Set,
	nonMethodPredicates: Set,
	predicates: Set,
	nonPredicates: Set,
	lookarounds: Set
}

RxmSubstring -> {
	next: RxmSpecial | RxmMarker | RxmBranch | RxmPredicate,
	sample: ByteString,
	compare: CleanBlockClosure
}

RxmSpecial -> {
	next: RxmMarker | RxmSubstring | RxmPredicate,
	matchSelector: ByteSymbol
}

RxmPredicate -> {
	next: RxmLink | RxmMarker | RxmBranch | RxmPredicate,
	predicate: CleanBlockClosure | FullBlockClosure
}

RxmMarker -> {
	next: RxmTerminator | RxmLink | RxmBranch,
	index: SmallInteger
}

OrderedCollection -> {
	array: { type: [ Object ], sizeBetween: 0 and: 0 },
	firstIndex: SmallInteger,
	lastIndex: SmallInteger
}

RxmBranch -> {
	next: RxmSpecial | RxmMarker | RxmSubstring | RxmPredicate,
	loopback: Boolean,
	alternative: RxmLink | RxmMarker | RxmBranch | RxmSubstring
}'
]
