Class {
	#name : 'MateOGDerivationNodeTest',
	#superclass : 'TestCase',
	#category : 'Mate-Derivation Tree',
	#package : 'Mate',
	#tag : 'Derivation Tree'
}

{ #category : 'as yet unclassified' }
MateOGDerivationNodeTest >> blocElementDerivationRender [

	<script: ' self new blocElementDerivationRender'>
	| generator derivation |
	generator  := MateBlocGrammar new generator.
	
	derivation := generator gen: BlElement from: MateContext new.

	^ derivation render inspect
]

{ #category : 'as yet unclassified' }
MateOGDerivationNodeTest >> personDerivationRender [

	<script: ' self new personDerivationRender'>
	| generator derivation |
	generator  := MatePersonGrammar new generator.
	
	derivation := generator gen: Person from: MateContext new.

	^ derivation render inspect
]

{ #category : 'as yet unclassified' }
MateOGDerivationNodeTest >> playerDerivationRender [

	<script: ' self new playerDerivationRender'>
	| generator derivation |
	generator  := MatePlayerGrammar new generator.
	
	derivation := generator gen: Player from: MateContext new.

	^ derivation render inspect
]
