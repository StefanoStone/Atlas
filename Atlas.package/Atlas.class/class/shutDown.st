system startup
shutDown

	OSSUnixSubprocess new
	workingDirectory: ATLDockerRunner repositoryDirectory;
	shellCommand: 'docker inspect -f ''{{.State.Running}}'' atlas 2>/dev/null || echo "false"';
	redirectStdout;
	runAndWaitOnExitDo: [ :process :outString | |out|
		out := outString trim.
		out = 'true' ifTrue: [ ATLDockerRunner instance stopContainer ].
		(out ~= 'true' and: (out ~= 'false')) ifTrue: [ ^ self error: 'Docker runner not create successfully' ].
	].