Class {
	#name : 'BaselineOfMate',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfMate',
	#package : 'BaselineOfMate'
}

{ #category : 'baselines' }
BaselineOfMate >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec baseline: 'BlocBenchs' with: [ spec repository: 'github://pharo-graphics/BlocBenchs:master/src' ].
		spec baseline: 'Ume' with: [ spec repository: 'github://FedeLoch/Ume:main' ].
		spec package: 'Mate' with: [ spec requires: #( 'BlocBenchs' 'Ume' ) ].
	]
]
