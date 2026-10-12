Class {
	#name : 'MatePaperASTExperiment',
	#superclass : 'MatePaperExperiment',
	#category : 'Mate-Experiments',
	#package : 'Mate-Experiments'
}

{ #category : 'running' }
MatePaperASTExperiment >> bechmark: blElement [

	1 halt.
]

{ #category : 'as yet unclassified' }
MatePaperASTExperiment >> mateGrammar [

	^ MateASTGrammar new
]

{ #category : 'running' }
MatePaperASTExperiment >> methodsToInstrument [

	^ OCMethodNode package methods
]

{ #category : 'running' }
MatePaperASTExperiment >> rootType [

	^ OCMethodNode
]
