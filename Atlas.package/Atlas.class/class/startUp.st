class initialization
startUp
   "Ensure that the container for the python socket is running"

	OSSUnixSubprocess new
	workingDirectory: self class repositoryDirectory;
	shellCommand: 'docker inspect -f ''{{.State.Running}}'' atlas 2>/dev/null || echo "false"';
	redirectStdout;
	runAndWaitOnExitDo: [ :process :outString | |out|
		out := outString trim.
		out = 'false' ifTrue: [ ATLDockerRunner instanceIsRunning: false ].
		out = 'true' ifTrue: [ ATLDockerRunner instanceIsRunning: true ].
		(out ~= 'true' and: (out ~= 'false')) ifTrue: [ ^ self error: 'Docker runner not create successfully' ].
	].