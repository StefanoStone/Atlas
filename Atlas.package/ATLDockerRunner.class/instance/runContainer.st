as yet unclassified
runContainer 
	
	UIManager default inform: 'Running atlas container. Please wait ...'.
	
	OSSUnixSubprocess new
	workingDirectory: self class repositoryDirectory;
	shellCommand: self class dockerRunCommand;
		redirectStdout;
		runAndWait.
		
	^ self