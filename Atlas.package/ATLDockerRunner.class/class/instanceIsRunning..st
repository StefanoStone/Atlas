as yet unclassified
instanceIsRunning: aBoolean

	uniqueInstance ifNil: [ uniqueInstance := self newIsRunning: aBoolean ].
	
	^ uniqueInstance