Class {
	#name : 'MatePaperRegexExperiment',
	#superclass : 'MatePaperExperiment',
	#category : 'Mate-Mate Paper Experimentation',
	#package : 'Mate',
	#tag : 'Mate Paper Experimentation'
}

{ #category : 'running' }
MatePaperRegexExperiment >> bechmark: regex [
	1 halt.
	regex asRegex matches: (regex minimalStringMatching)
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
