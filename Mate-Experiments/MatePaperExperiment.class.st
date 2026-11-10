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
MatePaperExperiment >> bechmark: generated [

	self subclassResponsibility 
]

{ #category : 'running' }
MatePaperExperiment >> evalConfiguration: conf iterations: iterations [

	| collector invalids cases incrCoverageResult isError |
	invalids := 0.
	collector := C2CoverageCollector new methods: self methodsToInstrument.
	incrCoverageResult := IncrementalCoverageResult for: {  } from: collector.
	cases := OrderedCollection new.

	collector installOn: [
		iterations timesRepeat: [ | generated result diff |
			collector resetResult.

			isError := false.
			collector basicRun: [
				[
					generated := self genOne: conf.
					self bechmark: generated ] onErrorDo: [ :e |
						invalids := invalids + 1.
						isError := true ] ].
			result := collector collectResult.
			diff := result nodes difference: incrCoverageResult nodes.
			
			"feed the generator"
			generated ifNotNil: [ self feed: conf input: generated diff: diff ].
			
			"add the new case with the current code coverage result for this new generated"
			cases add: {
				result percentage asFloat.
				(diff collect: #path).
				isError }.
			incrCoverageResult incrementWith: result
		]
	].

	^ {
		  ('configuration' -> conf class name).
		  ('totalIterations' -> iterations).
		  ('reachedCoverage' -> incrCoverageResult percentage asFloat).
		  ('reachedPaths' -> (incrCoverageResult nodes collect: #path)).
		  ('validityRate' -> (iterations - invalids / iterations) asFloat).
		  ('cases' -> cases) } asDictionary
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
		self mateGrammar.
		self mateGrammarWithoutConstraints.
	}.
	timeout := 5 seconds
]

{ #category : 'testing' }
MatePaperExperiment >> isValid: anInput [
	
	^ true
]

{ #category : 'running' }
MatePaperExperiment >> mateGrammar [

	self subclassResponsibility 
]

{ #category : 'running' }
MatePaperExperiment >> mateGrammarWithoutConstraints [

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

	((fileName, '.json') asFileReference) ensureDelete; writeStreamDo: [ :stream |
		stream nextPutAll: (NeoJSONWriter toStringPretty: results)
	].

	^ results
]
