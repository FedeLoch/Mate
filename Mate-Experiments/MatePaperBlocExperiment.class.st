Class {
	#name : 'MatePaperBlocExperiment',
	#superclass : 'MatePaperExperiment',
	#category : 'Mate-Experiments',
	#package : 'Mate-Experiments'
}

{ #category : 'running' }
MatePaperBlocExperiment >> bechmark: blElement [

	UmeBlocRender render: blElement
]

{ #category : 'as yet unclassified' }
MatePaperBlocExperiment >> mateFullGrammar [

	^ MateBlocCompleteGrammar new
]

{ #category : 'as yet unclassified' }
MatePaperBlocExperiment >> mateRandomInstanceSelectionWithoutConstraintsGrammar [

	^ MateBlocWithRandomReferenceSelectionGrammar new
]

{ #category : 'as yet unclassified' }
MatePaperBlocExperiment >> mateWithRefsWithoutConstraintsGrammar [

	^ MateBlocCompleteWithoutConstraintsGrammar new
]

{ #category : 'as yet unclassified' }
MatePaperBlocExperiment >> mateWithoutRefsAndOptionalNilGrammarWithoutConstraints [

	^ MateBlocGrammarWithoutConstraintsByLang new
]

{ #category : 'running' }
MatePaperBlocExperiment >> methodsToInstrument [

	^ BlElement package methods
]

{ #category : 'running' }
MatePaperBlocExperiment >> rootType [

	^ BlElement 
]
