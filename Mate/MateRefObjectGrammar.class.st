Class {
	#name : 'MateRefObjectGrammar',
	#superclass : 'MateOGGrammar',
	#category : 'Mate-Grammar Examples',
	#package : 'Mate',
	#tag : 'Grammar Examples'
}

{ #category : 'accessing' }
MateRefObjectGrammar >> defineObjectGraph [

	^ '
		RefObject -> {
			name: ByteString,
			myLittleObject: ReferredObject,
			selfReferences: { myLittleObject.ref }
		}
		
		ReferredObject -> { 
			value: SmallInteger,
			ref: { refType: RefObject }
		}
	'
]
