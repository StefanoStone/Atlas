as yet unclassified
containerStatus

	| status |

	OSSUnixSubprocess new
		workingDirectory: self class repositoryDirectory;
		shellCommand:
			('docker inspect -f ''{{.State.Running}}'' {1} 2>/dev/null || echo "false"' format: { self class dockerContainerName });
		redirectStdout;
		runAndWaitOnExitDo: [ :process :outString |
			| out |
			out := outString trim.
			out = 'false' ifTrue: [ status := false ].
			out = 'true' ifTrue: [ status := true ].
			(out ~= 'true' and: out ~= 'false') ifTrue: [
					^ self error: 'Docker runner not create successfully' ] ].
			
		^ status