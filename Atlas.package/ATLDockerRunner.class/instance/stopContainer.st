as yet unclassified
stopContainer 
	
	UIManager default inform: 'Stopping atlas container. Please wait ...'.

	OSSUnixSubprocess new
	workingDirectory: self class repositoryDirectory;
		shellCommand: self class dockerStopCommand;
		redirectStdout;
		runAndWaitOnExitDo: [ :process |
			self isRunning: false.
		]. 
	
	
	^ self