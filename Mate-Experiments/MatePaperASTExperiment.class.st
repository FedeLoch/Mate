Class {
	#name : 'MatePaperASTExperiment',
	#superclass : 'MatePaperExperiment',
	#category : 'Mate-Experiments',
	#package : 'Mate-Experiments'
}

{ #category : 'running' }
MatePaperASTExperiment >> bechmark: ast [

	^ OpalCompiler new ast: ast; compileOrFail
]

{ #category : 'as yet unclassified' }
MatePaperASTExperiment >> mateFullGrammar [

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
