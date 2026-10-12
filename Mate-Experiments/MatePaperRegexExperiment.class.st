Class {
	#name : 'MatePaperRegexExperiment',
	#superclass : 'MatePaperExperiment',
	#category : 'Mate-Experiments',
	#package : 'Mate-Experiments'
}

{ #category : 'running' }
MatePaperRegexExperiment >> bechmark: regex [

	regex matches: ''
]

{ #category : 'as yet unclassified' }
MatePaperRegexExperiment >> mateGrammar [

	^ MateRegexGrammar new
]

{ #category : 'running' }
MatePaperRegexExperiment >> methodsToInstrument [

	^ RxMatcher package methods
]

{ #category : 'running' }
MatePaperRegexExperiment >> rootType [

	^ RxMatcher
]
