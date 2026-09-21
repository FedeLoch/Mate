Class {
	#name : 'MatePaperMooseExperiment',
	#superclass : 'MatePaperExperiment',
	#category : 'Mate-Mate Paper Experimentation',
	#package : 'Mate',
	#tag : 'Mate Paper Experimentation'
}

{ #category : 'running' }
MatePaperMooseExperiment >> bechmark: mooseModel [

	1 halt.
]

{ #category : 'as yet unclassified' }
MatePaperMooseExperiment >> mateGrammar [

	^ MateMooseGrammar new
]

{ #category : 'running' }
MatePaperMooseExperiment >> methodsToInstrument [

	^ FamixStEntity package methods
]

{ #category : 'running' }
MatePaperMooseExperiment >> rootType [

	^ FamixStModel
]
