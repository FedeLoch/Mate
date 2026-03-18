Class {
	#name : 'MatePersonGrammarByLang',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Examples',
	#package : 'Mate',
	#tag : 'Grammar Examples'
}

{ #category : 'accessing' }
MatePersonGrammarByLang >> defineObjectGraph [

	^ '
	 	MatePerson -> {
			age: MateAge
		}
		
	 	MateAge -> {
			value: SmallInteger
		}
	'
]
