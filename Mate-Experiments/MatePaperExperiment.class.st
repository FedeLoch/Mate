Class {
	#name : 'MatePaperExperiment',
	#superclass : 'Object',
	#instVars : [
		'configurations',
		'timeout'
	],
	#category : 'Mate-Experiments',
	#package : 'Mate-Experiments'
}

{ #category : 'running' }
MatePaperExperiment class >> run: iterations [

	^ self new run: self name iterations: iterations
]

{ #category : 'running' }
MatePaperExperiment class >> runDuring: duration [

	^ self new run: self name duration: duration
]

{ #category : 'running' }
MatePaperExperiment >> bechmark: generated [

	self subclassResponsibility 
]

{ #category : 'running' }
MatePaperExperiment >> evalConfiguration: conf condition: condition [

	| collector invalids cases incrCoverageResult isError iterations initialMilliseconds errors |
	invalids := 0.
	collector := C2CoverageCollector new methods: self methodsToInstrument.
	incrCoverageResult := IncrementalCoverageResult for: {  } from: collector.
	cases := OrderedCollection new.
	iterations := 0.
	initialMilliseconds := Time primMillisecondClock.
	errors := IdentitySet new.

	collector installOn: [
		[ condition value: iterations value: initialMilliseconds ] whileFalse: [ | generated result diff initialCaseTime |
			initialCaseTime := Time primMillisecondClock.
			generated := nil.
			collector resetResult.

			isError := false.
			collector basicRun: [
				[
					generated := self genOne: conf.
					self withTimeout: [ self bechmark: generated ] phase: 'benchmark' ] onErrorDo: [ :e |
						errors add: e description.
						invalids := invalids + 1.
						isError := true ] ].
			result := collector collectResult.
			diff := result nodes difference: incrCoverageResult nodes.
			
			"feed the generator"
			generated ifNotNil: [ self feed: conf input: generated diff: diff ].
			
			"add the new case with the current code coverage result for this new generated"
			cases add: {
				('caseReachedCoverage' -> (result percentage asFloat)).
				('elapsedTime' -> (Time primMillisecondClock - initialCaseTime)).
				('newPaths' -> (diff collect: #path)).
				('isError' -> isError)
			} asDictionary.
			incrCoverageResult incrementWith: result.
			iterations := iterations + 1.
		]
	].

	^ {
		  ('errors' -> (errors inject: Dictionary new into: [ :dict :elem | | key |
				key := elem takeFirst: 200.
				dict at: key ifPresent: [ :curr | dict at: key put: (curr + 1) ]  ifAbsentPut: [ 1 ].
			dict])).
		  ('configuration' -> conf class name).
		  ('totalIterations' -> iterations).
		  ('totalTimeInMilliseconds' -> (Time primMillisecondClock - initialMilliseconds)).
		  ('reachedCoverage' -> incrCoverageResult percentage asFloat).
		  ('reachedPaths' -> (incrCoverageResult nodes collect: #path)).
		  ('validityRate' -> (iterations = 0 ifTrue: [ 0.0 ] ifFalse: [ (iterations - invalids / iterations) asFloat ])).
		  ('cases' -> cases) } asDictionary
]

{ #category : 'running' }
MatePaperExperiment >> feed: conf input: generated diff: diff [
	
	conf backPropagate: diff size from: generated
]

{ #category : 'running' }
MatePaperExperiment >> genOne: conf [

	| obj |

	self withTimeout: [ obj := conf gen: self rootType ] phase: 'generation'.
	
	self saveDerivation: (conf parse: obj).
	
	^ obj
]

{ #category : 'running' }
MatePaperExperiment >> initialize [ 
	
	configurations := {
		self mateFullGrammar.
		self mateWithRefsWithoutConstraintsGrammar.
		self mateRandomInstanceSelectionWithoutConstraintsGrammar.
		self mateWithoutRefsAndOptionalNilGrammarWithoutConstraints.
	}.
	
	timeout := 10 seconds
]

{ #category : 'testing' }
MatePaperExperiment >> isValid: anInput [
	
	^ true
]

{ #category : 'running' }
MatePaperExperiment >> mateFullGrammar [

	self subclassResponsibility 
]

{ #category : 'running' }
MatePaperExperiment >> mateRandomInstanceSelectionWithoutConstraintsGrammar [

	self subclassResponsibility 
]

{ #category : 'running' }
MatePaperExperiment >> mateWithRefsWithoutConstraintsGrammar [

	self subclassResponsibility 
]

{ #category : 'running' }
MatePaperExperiment >> mateWithoutRefsAndOptionalNilGrammarWithoutConstraints [

	self subclassResponsibility 
]

{ #category : 'running' }
MatePaperExperiment >> methodsToInstrument [

	self subclassResponsibility 
]

{ #category : 'running' }
MatePaperExperiment >> rootType [

	self subclassResponsibility 
]

{ #category : 'running' }
MatePaperExperiment >> run: fileName duration: duration [
	
	| maxMilliseconds|
	
	maxMilliseconds := duration asMilliSeconds.
	
	^ self run: fileName withBlock: [ :conf |
		self evalConfiguration: conf condition: [ :its :initialTimeMill |
			(Time primMillisecondClock - initialTimeMill) >= maxMilliseconds
		]
	]
]

{ #category : 'running' }
MatePaperExperiment >> run: fileName iterations: iterations [

	^ self run: fileName withBlock: [ :conf |
		self evalConfiguration: conf condition: [ :its :initialTimeMill | its >= iterations ]
	]
]

{ #category : 'running' }
MatePaperExperiment >> run: fileName withBlock: block [

	| results |

	results := configurations collect: [ :config | | currentResult |
		currentResult := block value: config.
		
		((fileName, '-', config className, '.json') asFileReference) ensureDelete; writeStreamDo: [ :stream |
			stream nextPutAll: (NeoJSONWriter toStringPretty: currentResult)
		]
	].

	^ results
]

{ #category : 'as yet unclassified' }
MatePaperExperiment >> saveDerivation: derivation [

	derivation saveAs: 'lastDerivation.fuel'.

]

{ #category : 'running' }
MatePaperExperiment >> withTimeout: aBlock phase: phaseName [
	"Run aBlock for at most timeout. When it takes longer, signal an Error naming the phase, so the errors tell generation and rendering timeouts apart."

	| result |
	result := nil.
	[ result := aBlock value ] valueWithin: timeout onTimeout: [
		Error signal: 'Timeout! (' , phaseName , ')' ].
	^ result
]
