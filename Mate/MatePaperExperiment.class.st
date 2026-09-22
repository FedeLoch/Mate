Class {
	#name : 'MatePaperExperiment',
	#superclass : 'Object',
	#instVars : [
		'configurations',
		'timeout'
	],
	#category : 'Mate-Mate Paper Experimentation',
	#package : 'Mate',
	#tag : 'Mate Paper Experimentation'
}

{ #category : 'running' }
MatePaperExperiment class >> run: iterations [

	^ self new run: self name iterations: iterations
]

{ #category : 'running' }
MatePaperExperiment >> bechmark: generated [

	self subclassResponsibility 
]

{ #category : 'running' }
MatePaperExperiment >> evalConfiguration: conf iterations: iterations [

	| collector invalids cases incrCoverageResult |

	invalids := 0.
	collector := C2CoverageCollector new methods: self methodsToInstrument.
	incrCoverageResult := IncrementalCoverageResult for: {} from: collector.
	cases := OrderedCollection new.

	iterations timesRepeat: [ | generated result |
		collector resetResult.
		[
			result := collector runOn: [
				generated := self genOne: conf.
				self bechmark: generated
			]] onErrorDo: [ :e | invalids := invalids + 1 ].
				result ifNotNil: [ | diff |
					diff := result nodes difference: incrCoverageResult nodes.
					
					"feed the generator"
					self feed: conf input: generated diff: diff.

					"add the new case with the current code coverage result for this new generated"					
					cases add: { result percentage asFloat . diff }.

					"increment general code coverage"
					incrCoverageResult incrementWith: result
			]
	].

	^ {
		  ('configuration' -> conf class name).
		  ('totalIterations' -> iterations).
		  ('reachedCoverage' -> (incrCoverageResult percentage asFloat)).
		  ('reachedPaths' -> (incrCoverageResult nodes collect: #asString)).
		  ('validityRate' -> (iterations - invalids / iterations) asFloat).
		  ('cases' -> cases)
	} asDictionary
]

{ #category : 'running' }
MatePaperExperiment >> feed: conf input: generated diff: diff [
	
	conf backPropagate: diff size from: generated
]

{ #category : 'running' }
MatePaperExperiment >> genOne: conf [
	
	| result |

result := nil.
	[ result := conf gen: self rootType ] valueWithin: timeout onTimeout: [
   	Error signal: 'Timeout!'
].

	^ result
]

{ #category : 'running' }
MatePaperExperiment >> initialize [ 
	
	configurations := {
		self mateGrammar
	}.
	timeout := 5 seconds
]

{ #category : 'testing' }
MatePaperExperiment >> isValid: anInput [
	
"	[ STON fromString: (STON toString: anInput) ] onErrorDo: [ ^ false ]."
	
	^ true
]

{ #category : 'running' }
MatePaperExperiment >> mateGrammar [

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
MatePaperExperiment >> run: fileName iterations: iterations [

	| results |

	results := configurations collect: [ :conf |
		self evalConfiguration: conf iterations: iterations
	].
	
	((fileName, '.json') asFileReference) writeStreamDo: [ :stream |
		stream nextPutAll: (NeoJSONWriter toStringPretty: results)
	] 
]
