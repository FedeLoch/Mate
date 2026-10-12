Class {
	#name : 'MatePaperASTExperiment',
	#superclass : 'MatePaperExperiment',
	#category : 'Mate-Experiments',
	#package : 'Mate-Experiments'
}

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
