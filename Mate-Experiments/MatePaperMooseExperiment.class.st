Class {
	#name : 'MatePaperMooseExperiment',
	#superclass : 'MatePaperExperiment',
	#category : 'Mate-Experiments',
	#package : 'Mate-Experiments'
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
