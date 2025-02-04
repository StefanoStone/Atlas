as yet unclassified
runContainer 

	OSSUnixSubprocess new
	shellCommand: self class dockerRunCommand;
		redirectStdout;
		runAndWait.
		
	^ self