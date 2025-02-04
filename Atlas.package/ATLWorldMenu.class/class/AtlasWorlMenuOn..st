as yet unclassified
AtlasWorlMenuOn: aBuilder
	<worldMenu>
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
				action: [ ATLDockerRunner instance runContainer. ];
				order: 1.
			(aBuilder item: #Stop)
				parent: #Atlas;
				label: 'Stop Container';
				help: 'Stop the container';
				icon: (Smalltalk ui icons iconNamed: #stop);
				action: [ ATLDockerRunner instance stopContainer. ];
				order: 2.
			(aBuilder item: #Status)
				parent: #Atlas;
				label: 'Container Status';
				help: 'Status of the container';
				icon: [ ATLDockerRunner instance isRunning ifTrue: [ (Smalltalk ui icons iconNamed: #testGreen) ] ifFalse: [(Smalltalk ui icons iconNamed: #testRed)] ] value;
				order: 3.  
			].