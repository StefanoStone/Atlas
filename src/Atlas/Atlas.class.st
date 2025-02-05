"
Atlas is the General class dealing with managing general task concerning the socket and its connection
"
Class {
	#name : 'Atlas',
	#superclass : 'Object',
	#category : 'Atlas',
	#package : 'Atlas'
}

{ #category : 'as yet unclassified' }
Atlas class >> acceptConnection [
	|stream errString |
stream := SocketStream openConnectionToHostNamed: '127.0.0.1'  port: 4000 .
errString := ''.
[errString := stream nextLineLf.
Transcript show: 'received : ', errString. self error: errString.] fork.

stream close.
]

{ #category : 'as yet unclassified' }
Atlas class >> getValue: aString [
	"similar to sendMessage but this method also return the python value "

|stream errString retValue |
stream := SocketStream openConnectionToHostNamed: '127.0.0.1'  port: 4000 .
stream sendCommand: 'RetValue: ',aString.
errString := stream nextLineLf .
[errString matchesRegex: '.*end of error.*'] whileFalse:[
Transcript show: 'iterating with error:',errString ;cr.
(errString matchesRegex:  '.*no error.*') ifFalse: [  
	(errString matchesRegex: '.*end of error.*') ifFalse:[
		(errString matchesRegex: '') ifFalse: [
			(errString matchesRegex: 'RetValue\:.*') ifTrue: 
			
				[Transcript show: ' I am getting error:' , errString ;cr.
				(errString regex: '[^(RetValue:)].*'  matchesDo: 
					[ :word|  Transcript show: 'Returned' , word;cr. retValue := word]) .
				
				^ retValue] ifFalse: [
self error: errString .]]]].errString:=stream nextLineLf ].

stream close.

	
]

{ #category : 'class initialization' }
Atlas class >> initialize [
   
	Smalltalk addToStartUpList: self.
	

]

{ #category : 'as yet unclassified' }
Atlas class >> sendMessage: aString [
|stream errString  |
stream := SocketStream openConnectionToHostNamed: '127.0.0.1'  port: 4000 .
stream sendCommand: aString.
errString := stream nextLineLf .
[errString matchesRegex: '.*end of error.*'] whileFalse:[

(errString matchesRegex:  '.*no error.*') ifFalse: [  
	(errString matchesRegex: '.*end of error.*') ifFalse:[
		(errString matchesRegex: '') ifFalse: [   
self error: errString .]]].errString:= stream nextLineLf ].

stream close.

]

{ #category : 'system startup' }
Atlas class >> shutDown: isImageQuitting [

	isImageQuitting ifFalse: [ ^ self ].
	"ATLDockerRunner instance stopContainer."
	ATLDockerRunner reset.
]

{ #category : 'system startup' }
Atlas class >> startUp: isOpening [

	isOpening ifFalse: [ ^ self ].

	OSSUnixSubprocess new
		workingDirectory: ATLDockerRunner repositoryDirectory;
		shellCommand:
			'docker inspect -f ''{{.State.Running}}'' atlas-ner-1 2>/dev/null || echo "false"';
		redirectStdout;
		runAndWaitOnExitDo: [ :process :outString |
			| out |
			out := outString trim.
			out = 'false' ifTrue: [ ATLDockerRunner instanceIsRunning: false ].
			out = 'true' ifTrue: [ ATLDockerRunner instanceIsRunning: true ].
			(out ~= 'true' and: out ~= 'false') ifTrue: [
					^ self error: 'Docker runner not create successfully' ] ]
]
