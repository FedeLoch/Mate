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
	
	| collector valids |
	
	valids := 0.
	collector := CoverageCollector new methods: self methodsToInstrument.
	collector runOn: [ 
		iterations timesRepeat: [
			(self isValid: (self genOne: conf)) ifTrue: [
				valids := valids + 1.
			]
		]
 	].

	^ {
		'configuration' -> (conf class name).
		'reachedCoverage' -> (collector result percentage).
		'validityRate' -> (iterations / valids)
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

	| result |

	result := configurations collect: [ :conf |
		self evalConfiguration: conf iterations: iterations
	].
	
	1 halt.
]
