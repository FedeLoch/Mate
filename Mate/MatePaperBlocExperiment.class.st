Class {
	#name : 'MatePaperBlocExperiment',
	#superclass : 'MatePaperExperiment',
	#category : 'Mate-Mate Paper Experimentation',
	#package : 'Mate',
	#tag : 'Mate Paper Experimentation'
}

{ #category : 'running' }
MatePaperBlocExperiment >> bechmark: blElement [

	UmeBlocRender render: blElement

	
]

{ #category : 'as yet unclassified' }
MatePaperBlocExperiment >> mateGrammar [

	^ MateBlocGrammarByLang new
]

{ #category : 'running' }
MatePaperBlocExperiment >> methodsToInstrument [

	^ BlElement package methods
]

{ #category : 'running' }
MatePaperBlocExperiment >> rootType [

	^ BlElement 
]
