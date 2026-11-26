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

{ #category : 'running' }
MatePaperASTExperiment >> mateFullBreaksGrammar [

	^ MateASTBreaksGrammar new
]

{ #category : 'as yet unclassified' }
MatePaperASTExperiment >> mateFullGrammar [

	^ MateASTGrammar new
]

{ #category : 'running' }
MatePaperASTExperiment >> mateRandomInstanceSelectionWithoutConstraintsGrammar [

	^ MateASTWithoutConstraintsAndRandomRefSelectionGrammar new
]

{ #category : 'running' }
MatePaperASTExperiment >> mateWithRefsWithoutConstraintsGrammar [

	^ MateASTWithoutConstraintsGrammar new
]

{ #category : 'running' }
MatePaperASTExperiment >> mateWithoutRefsAndOptionalNilGrammarWithoutConstraints [

	^ MateASTWithoutConstraintsNilSelectionGrammar new
]

{ #category : 'running' }
MatePaperASTExperiment >> methodsToInstrument [

	^ OCMethodNode package methods
]

{ #category : 'running' }
MatePaperASTExperiment >> rootType [

	^ OCMethodNode
]
