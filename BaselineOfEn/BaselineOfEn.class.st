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
		spec baseline: 'PBT' with: [ spec repository: 'github://FedeLoch/Ume:main' ].
		spec package: 'En' with: [ spec requires: #( 'PBT' ) ].
	]
]
