Class {
	#name : 'MatePaperASTExperiment',
	#superclass : 'MatePaperExperiment',
	#category : 'Mate-Mate Paper Experimentation',
	#package : 'Mate',
	#tag : 'Mate Paper Experimentation'
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
