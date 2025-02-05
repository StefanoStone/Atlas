Class {
	#name : 'ATLDockerRunner',
	#superclass : 'Object',
	#instVars : [
		'isRunning'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'Atlas',
	#package : 'Atlas'
}

{ #category : 'as yet unclassified' }
ATLDockerRunner class >> dockerContainerName [

	^ 'atlas-ner-1'
]

{ #category : 'as yet unclassified' }
ATLDockerRunner class >> dockerRunCommand [

	 ^ 'docker compose -f ''docker-compose.yaml'' up -d --build'
]

{ #category : 'as yet unclassified' }
ATLDockerRunner class >> dockerStopCommand [

	^ 'docker compose -f docker-compose.yaml stop'
]

{ #category : 'accessing' }
ATLDockerRunner class >> instance [ 

	uniqueInstance ifNil: [ ^ self error: 'The singleton has not been initialized properly.' ].

	^ uniqueInstance
]

{ #category : 'as yet unclassified' }
ATLDockerRunner class >> instanceIsRunning: aBoolean [

	uniqueInstance ifNil: [ uniqueInstance := self newIsRunning: aBoolean ].
	
	^ uniqueInstance
]

{ #category : 'instance creation' }
ATLDockerRunner class >> new [

	self error: 'Use dedicated #instanceIsRunning: class method to get an instance of GMCommitUtilities Class'
]

{ #category : 'instance creation' }
ATLDockerRunner class >> newIsRunning: aBoolean [ 
	"To get the instance of this singleton you should use the method #instanceIsRunning: this method is only a support to that method"
	
	| runner |

	runner := self basicNew initialize.
	aBoolean ifFalse: [ runner runContainer ].
	runner isRunning: true.
	
	^ runner 
]

{ #category : 'API - accessing' }
ATLDockerRunner class >> repositoryDirectory [ 

	^ (IceRepository repositories 
    detect: [ :repo | repo name = 'Atlas' ] 
    ifNone: [ nil ]) location pathString. 

]

{ #category : 'operations' }
ATLDockerRunner class >> reset [

	^ uniqueInstance := nil
]

{ #category : 'as yet unclassified' }
ATLDockerRunner >> containerStatus [

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
]

{ #category : 'accessing' }
ATLDockerRunner >> isRunning [

	^ isRunning
]

{ #category : 'accessing' }
ATLDockerRunner >> isRunning: anObject [

	isRunning := anObject
]

{ #category : 'as yet unclassified' }
ATLDockerRunner >> runContainer [ 
	
	UIManager default inform: 'Running atlas container. Please wait ...'.
	
	OSSUnixSubprocess new
	workingDirectory: self class repositoryDirectory;
	shellCommand: self class dockerRunCommand;
		redirectStdout;
		runAndWaitOnExitDo: [ :process | 
			self isRunning: true
			].
		
	^ self
]

{ #category : 'as yet unclassified' }
ATLDockerRunner >> stopContainer [ 
	
	UIManager default inform: 'Stopping atlas container. Please wait ...'.

	OSSUnixSubprocess new
	workingDirectory: self class repositoryDirectory;
		shellCommand: self class dockerStopCommand;
		redirectStdout;
		runAndWaitOnExitDo: [ :process |
			self isRunning: false.
		]. 
	
	
	^ self
]
