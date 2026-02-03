Class {
	#name : 'BaselineOfEn',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfEn',
	#package : 'BaselineOfEn'
}

{ #category : 'baselines' }
BaselineOfEn >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec baseline: 'BlocBenchs' with: [ spec repository: 'github://pharo-graphics/BlocBenchs:master/src' ].
		spec baseline: 'Ume' with: [ spec repository: 'github://FedeLoch/Ume:main' ].
		spec package: 'En' with: [ spec requires: #( 'BlocBenchs' 'Ume' ) ].
	]
]
