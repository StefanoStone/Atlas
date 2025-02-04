instance creation
newIsRunning: aBoolean 
	"To get the instance of this singleton you should use the method #instanceIsRunning: this method is only a support to that method"
	
	| runner |

	runner := self basicNew initialize.
	aBoolean ifFalse: [ runner runContainer ].
	runner isRunning: true.
	
	^ runner 