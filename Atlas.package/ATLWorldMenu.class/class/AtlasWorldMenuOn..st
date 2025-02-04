as yet unclassified
AtlasWorldMenuOn: aBuilder
	<worldMenu>
	
	| dockerSingleton |
	dockerSingleton := [ATLDockerRunner instance] on: Error do: [ ^ self ].

	(aBuilder item: #Atlas)
	   label: 'Atlas';
		order: 90;
		help: 'Start and stop Atlas container from the UI';
		with: [
			(aBuilder item: #Start)
				parent: #Atlas;
				label: 'Start Container';
				help: 'Run the container';
				icon: (Smalltalk ui icons iconNamed: #go);
				action: [ dockerSingleton runContainer. ];
				order: 1.
			(aBuilder item: #Stop)
				parent: #Atlas;
				label: 'Stop Container';
				help: 'Stop the container';
				icon: (Smalltalk ui icons iconNamed: #stop);
				action: [ dockerSingleton stopContainer. ];
				order: 2.
			(aBuilder item: #Status)
				parent: #Atlas;
				label: (dockerSingleton isRunning ifTrue: [ 'The container is Running' ] ifFalse: ['The container is NOT Running']);
				icon: (dockerSingleton isRunning ifTrue: [ (Smalltalk ui icons iconNamed: #testGreen) ] ifFalse: [(Smalltalk ui icons iconNamed: #testRed)]);
				order: 3.  
			].