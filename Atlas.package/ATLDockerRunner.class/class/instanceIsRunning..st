as yet unclassified
instanceIsRunning: aBoolean

	uniqueInstance ifNil: [ uniqueInstance := self newIsRunning: aBoolean ].
	
   (uniqueInstance notNil and: (aBoolean not)) ifTrue: [ uniqueInstance runContainer ].
	
	^ uniqueInstance