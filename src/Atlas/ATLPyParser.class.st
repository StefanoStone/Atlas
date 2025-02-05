"
ATLPyParser makes it possible to use pharo syntax for executing python code without passing the python code as a string as Ephestos sendMessage: requires. The parsion uses regex
"
Class {
	#name : 'ATLPyParser',
	#superclass : 'Object',
	#instVars : [
		'pythonString',
		'referencedString'
	],
	#classVars : [
		'PythonString',
		'badMessage'
	],
	#category : 'Atlas',
	#package : 'Atlas'
}

{ #category : 'as yet unclassified' }
ATLPyParser class >> PythonString [
	^ PythonString 
]

{ #category : 'as yet unclassified' }
ATLPyParser class >> PythonString: aValue [
PythonString := aValue
]

{ #category : 'as yet unclassified' }
ATLPyParser class >> badMessage [
	^ badMessage asString
]

{ #category : 'as yet unclassified' }
ATLPyParser class >> doesNotUnderstand: aMessage [

|messageRegex dictindexRegex 
valueRegex fullRegex parts message
methodcallRegex accessObjectRegex unaryRegex|

PythonString ifNil: [ PythonString :='' ].
message := aMessage asString.

messageRegex :='\w+\:'.
unaryRegex := '\w+'.
accessObjectRegex := 'nil'.
dictindexRegex := $' asString ,'\s*\[\s*"*\s*\w+\s*"*\s*\]\s*', $' asString.
valueRegex := '',$' asString ,'\s*=.+', $' asString,''.
methodcallRegex := '',$' asString ,'\s*\(.*\)\s*', $' asString,''.

fullRegex := '((',messageRegex,')|(',dictindexRegex,')|(',valueRegex,')|(',methodcallRegex,')|(',accessObjectRegex,')|(',unaryRegex ,'))'.

parts := message allRegexMatches: fullRegex.

parts do:[:part||index|
	
	index := parts indexOf: part.
	
	(index < parts size) ifTrue: [  
		
	EphPyParser parseDictIndexPart: part fromCollection: parts .	
     EphPyParser parseValuePart: part fromCollection: parts .
	EphPyParser parserMethodCallPart: part fromCollections: parts.
	
	]].
((parts size) = 1) ifTrue: [|part| part:= (parts at: 1) asString. (part matchesRegex: unaryRegex) ifTrue:[ 

		(PythonString = '') ifTrue: [ PythonString := part]
		                            ifFalse: [ PythonString := PythonString,'.',part ]]].


badMessage :=  aMessage.
]

{ #category : 'as yet unclassified' }
ATLPyParser class >> e [
|stringToSend|
	"comment stating purpose of message"
	Transcript show: 'pythonString : ',PythonString ;cr.
	Transcript show: '-------------END OF MESSAGE-------------';cr.
	stringToSend := PythonString .
	self PythonString:''.
	Ephestos sendMessage: stringToSend .



]

{ #category : 'as yet unclassified' }
ATLPyParser class >> endOfMessage [
	"comment stating purpose of message"

	self e
]

{ #category : 'as yet unclassified' }
ATLPyParser class >> endOfReceiveMessage [
	^self er
]

{ #category : 'as yet unclassified' }
ATLPyParser class >> er [
|stringToSend|
	"comment stating purpose of message"
	Transcript show: 'pythonString : ',PythonString ;cr.
	Transcript show: '-------------END OF MESSAGE-------------';cr.
	stringToSend := PythonString .
	self PythonString:''.
	^ Ephestos getValue: stringToSend .



]

{ #category : 'as yet unclassified' }
ATLPyParser class >> parseDictIndexPart: part fromCollection: parts [
	
	| messageRegex index dictindexRegex |
	index := parts indexOf: part.
	messageRegex :='\w+\:'.
	dictindexRegex := $' asString ,'\s*\[\s*"*\s*\w+\s*"*\s*\]\s*', $' asString.
	
	(part matchesRegex: messageRegex) ifTrue:[ ((parts at: (index + 1)) matchesRegex: dictindexRegex  ) ifTrue: [|newpart dictIndexString| 
			dictIndexString := (parts at: (index + 1)).
			dictIndexString := dictIndexString copyWithRegex: (($' asString),'+')  matchesReplacedWith:''. 
			newpart := part copyWithRegex: '\:' matchesReplacedWith:('' ,dictIndexString,'' ) . 
			"parts at: index put: newpart" .  PythonString = '' ifFalse:[PythonString := PythonString ,'.'] .PythonString := PythonString ,newpart]].
]

{ #category : 'as yet unclassified' }
ATLPyParser class >> parseValuePart: part fromCollection: parts [ 
| messageRegex index valueRegex |

index := parts indexOf: part.
messageRegex :='\w+\:'.
valueRegex := '',$' asString ,'\s*=.+', $' asString,''.

	(part matchesRegex: messageRegex) ifTrue:[ ((parts at: (index + 1)) matchesRegex: valueRegex  ) ifTrue: [|newpart valueString| 
			valueString := (parts at: (index + 1)).
			valueString := valueString copyWithRegex: (($' asString),'+')  matchesReplacedWith:''. 
			newpart := part copyWithRegex: '\:' matchesReplacedWith:('' ,valueString ) . 
			"parts at: index put: newpart ".  PythonString = '' ifFalse:[PythonString := PythonString ,'.'] .PythonString := PythonString ,newpart.]].
]

{ #category : 'as yet unclassified' }
ATLPyParser class >> parserMethodCallPart: part fromCollections: parts [ 
	
| messageRegex index methodcallRegex |

	index := parts indexOf: part.
	messageRegex :='\w+\:'.
	
methodcallRegex := '',$' asString ,'\s*\(.*\)\s*', $' asString,''.
	(part matchesRegex: messageRegex) ifTrue:[ ((parts at: (index + 1)) matchesRegex: methodcallRegex ) ifTrue: [|newpart methodcallString| 
			methodcallString := (parts at: (index + 1)).
			methodcallString := methodcallString  copyWithRegex: (($' asString),'+')  matchesReplacedWith:''. 
			newpart := part copyWithRegex: '\:' matchesReplacedWith:('' ,methodcallString ) . 
			"parts at: index put: newpart ".  PythonString = '' ifFalse:[PythonString := PythonString ,'.'] . PythonString := PythonString ,newpart.]].
]

{ #category : 'as yet unclassified' }
ATLPyParser >> doesNotUnderstand: aMessage [

|messageRegex dictindexRegex 
valueRegex fullRegex parts message
methodcallRegex accessObjectRegex unaryRegex|


message := aMessage asString.

messageRegex :='\w+\:'.
unaryRegex := '\w+'.
accessObjectRegex := 'nil'.
dictindexRegex := $' asString ,'\s*\[\s*"*\s*\w+\s*"*\s*\]\s*', $' asString.
valueRegex := '',$' asString ,'\s*=.+', $' asString,''.
methodcallRegex := '',$' asString ,'\s*\(.*\)\s*', $' asString,''.

fullRegex := '((',messageRegex,')|(',dictindexRegex,')|(',valueRegex,')|(',methodcallRegex,')|(',accessObjectRegex,')|(',unaryRegex ,'))'.

parts := message allRegexMatches: fullRegex.

parts do:[:part||index|
	
	index := parts indexOf: part.
	
	(index  < parts size) ifTrue: [  
	
	self parseDictIndexPart: part fromCollection: parts .	
     self parseValuePart: part fromCollection: parts .
	self parserMethodCallPart: part fromCollections: parts.
	
	]].
((parts size) = 1) ifTrue: [|part| part:= (parts at: 1) asString. (part matchesRegex: unaryRegex) ifTrue:[ 

		(pythonString = '') ifTrue: [ pythonString := part]
		                            ifFalse: [ pythonString := pythonString,'.',part ]]].

Transcript show: 'PythonString :' ,pythonString ;cr.
badMessage :=  aMessage.



]

{ #category : 'as yet unclassified' }
ATLPyParser >> e [
	"send the message through socket"

	Ephestos sendMessage: pythonString.
	Transcript show: 'pythonString : ',pythonString ;cr.
	pythonString := referencedString 
]

{ #category : 'initialize' }
ATLPyParser >> initialize [

	super initialize.

	pythonString := ''.
	referencedString := ''.
]

{ #category : 'as yet unclassified' }
ATLPyParser >> parseDictIndexPart: part fromCollection: parts [
	
	| messageRegex index dictindexRegex |
	index := parts indexOf: part.
	messageRegex :='\w+\:'.
	dictindexRegex := $' asString ,'\s*\[\s*"*\s*\w+\s*"*\s*\]\s*', $' asString.
	
	(part matchesRegex: messageRegex) ifTrue:[ ((parts at: (index + 1)) matchesRegex: dictindexRegex  ) ifTrue: [|newpart dictIndexString| 
			dictIndexString := (parts at: (index + 1)).
			dictIndexString := dictIndexString copyWithRegex: (($' asString),'+')  matchesReplacedWith:''. 
			newpart := part copyWithRegex: '\:' matchesReplacedWith:('' ,dictIndexString,'' ) . 
			"parts at: index put: newpart" .  pythonString = '' ifFalse:[pythonString := pythonString ,'.'] .pythonString := pythonString ,newpart]].
]

{ #category : 'as yet unclassified' }
ATLPyParser >> parseValuePart: part fromCollection: parts [ 
| messageRegex index valueRegex |

index := parts indexOf: part.
messageRegex :='\w+\:'.
valueRegex := '',$' asString ,'\s*=.+', $' asString,''.

	(part matchesRegex: messageRegex) ifTrue:[ ((parts at: (index + 1)) matchesRegex: valueRegex  ) ifTrue: [|newpart valueString| 
			valueString := (parts at: (index + 1)).
			valueString := valueString copyWithRegex: (($' asString),'+')  matchesReplacedWith:''. 
			newpart := part copyWithRegex: '\:' matchesReplacedWith:('' ,valueString ) . 
			"parts at: index put: newpart ".  pythonString = '' ifFalse:[pythonString := pythonString ,'.'] .pythonString := pythonString ,newpart.]].
]

{ #category : 'as yet unclassified' }
ATLPyParser >> parserMethodCallPart: part fromCollections: parts [
	
| messageRegex index methodcallRegex |

	index := parts indexOf: part.
	messageRegex :='\w+\:'.
	
methodcallRegex := '',$' asString ,'\s*\(.*\)\s*', $' asString,''.
	(part matchesRegex: messageRegex) ifTrue:[ ((parts at: (index + 1)) matchesRegex: methodcallRegex ) ifTrue: [|newpart methodcallString| 
			methodcallString := (parts at: (index + 1)).
			methodcallString := methodcallString  copyWithRegex: (($' asString),'+')  matchesReplacedWith:''. 
			newpart := part copyWithRegex: '\:' matchesReplacedWith:('' ,methodcallString ) . 
			"parts at: index put: newpart ".  pythonString = '' ifFalse:[pythonString := pythonString ,'.'] . pythonString := pythonString ,newpart.]].
]

{ #category : 'as yet unclassified' }
ATLPyParser >> r [
	"store a reference so the same messages can be used via variables again and again"

	referencedString := pythonString
]
