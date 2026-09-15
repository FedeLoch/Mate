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
MatePaperExperiment >> evalConfiguration: conf iterations: iterations [
	
	| collector invalids result |
	
	invalids := 0.
	collector := CoverageCollector new methods: self methodsToInstrument.
	result := collector runOn: [ 
		iterations timesRepeat: [ | generated | [
				generated := self genOne: conf.
				(self isValid: generated) ifFalse: [ invalids := invalids + 1 ]
			] onErrorDo: [ :e | invalids := invalids + 1 ]
		]
 	].

	^ {
		'configuration' -> (conf class name).
		'totalIterations' -> iterations.
		'reachedCoverage' -> (result percentage asFloat).
		'reachedNodes' -> (result nodes size asFloat).
		'validityRate' -> (((iterations - invalids) / iterations) asFloat)
	} asDictionary 
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
