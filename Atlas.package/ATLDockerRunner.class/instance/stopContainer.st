as yet unclassified
stopContainer 

	OSSUnixSubprocess new
	shellCommand: self class dockerStopCommand;
		redirectStdout;
		runAndWait.
		
	^ self