system startup
startUp
	
	OSSUnixSubprocess new
		workingDirectory: ATLDockerRunner repositoryDirectory;
		shellCommand:
			'docker inspect -f ''{{.State.Running}}'' atlas-ner 2>/dev/null || echo "false"';
		redirectStdout;
		runAndWaitOnExitDo: [ :process :outString |
			| out |
			out := outString trim.
			out = 'false' ifTrue: [ ATLDockerRunner instanceIsRunning: false ].
			out = 'true' ifTrue: [ ATLDockerRunner instanceIsRunning: true ].
			(out ~= 'true' and: out ~= 'false') ifTrue: [
					^ self error: 'Docker runner not create successfully' ] ]