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
MatePaperExperiment >> evalConfiguration: conf iterations: iterations [
	
	| pathCollector invalids generationErrors result |
	
	invalids := 0.
	generationErrors := 0.
	pathCollector := MateObjectPathCollector new grammar: self mateGrammar. 
	iterations timesRepeat: [ | generated |
		generated := [ self genOne: conf ] on: Error do: [ :e |
			generationErrors := generationErrors + 1.
			e return: nil ].
		generated ifNotNil: [
			[ (self isValid: generated)
				ifTrue: [ pathCollector collect: generated ]
				ifFalse: [ invalids := invalids + 1 ] ] on: Error do: [ :e | invalids := invalids + 1 ] ]
	].

	result := pathCollector getResult.

	^ {
		'configuration' -> (conf class name).
		'totalIterations' -> iterations.
		'reachedCoverage' -> (result percentage asFloat).
		'reachedPaths' -> (result reachedPaths size asFloat).
		'generationErrors' -> generationErrors.
		'validityRate' -> (((iterations - invalids - generationErrors) / iterations) asFloat)
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
	
	((fileName, '.json') asFileReference) ensureDelete; writeStreamDo: [ :stream |
		stream nextPutAll: (NeoJSONWriter toStringPretty: results)
	] 
]
