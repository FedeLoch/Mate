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
MatePaperBlocExperiment >> mateGrammar [

	^ MateBlocCompleteGrammar new
]

{ #category : 'as yet unclassified' }
MatePaperBlocExperiment >> mateGrammarWithoutConstraints [

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
