Class {
	#name : 'BaselineOfAtlas',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfAtlas',
	#package : 'BaselineOfAtlas'
}

{ #category : 'baselines' }
BaselineOfAtlas >> baseline: spec [
	<baseline>
	spec
		for: #pharo
		do:
			[
			self osSubprocess: spec.
			
			spec
				preLoadDoIt: #preload:package:;
				postLoadDoIt: #postload:package:.
			spec package: 'Atlas'	. 
 ]	
]

{ #category : 'external projects' }
BaselineOfAtlas >> osSubprocess: spec [

    spec 
		baseline: #OSSubprocess
		with: [ spec repository: 'github://pharo-contributions/OSSubprocess:master/repository' ]
]

{ #category : 'baselines' }
BaselineOfAtlas >> postload: arg1 package: arg2 [

Atlas startUp: true.
UIManager default inform: 'Atlas installed successfuly'.
]

{ #category : 'baselines' }
BaselineOfAtlas >> preload: arg1 package: arg2 [

UIManager default inform: 'Installing Atlas. Please wait...'.
]
