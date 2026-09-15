Class {
	#name : 'MatePaperExperiment',
	#superclass : 'Object',
	#instVars : [
		'configurations'
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
		'reachedCoverage' -> (result percentage asFloat).
		'reachedNodes' -> (result nodes size asFloat).
		'validityRate' -> (iterations / (iterations - invalids))
	} asDictionary 
]

{ #category : 'running' }
MatePaperExperiment >> genOne: conf [

	^ conf gen: self rootType
]

{ #category : 'running' }
MatePaperExperiment >> initialize [ 
	
	configurations := {
		self mateGrammar
	}.
]

{ #category : 'testing' }
MatePaperExperiment >> isValid: anInput [
	
"	[ STON fromString: (STON toString: anInput) ] onErrorDo: [ ^ false ]."
	
	^ true
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
