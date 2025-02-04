accessing
instance 

	uniqueInstance ifNil: [ ^ self error: 'The singleton has not been initialized properly.' ].

	^ uniqueInstance