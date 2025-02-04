baselines
baseline: spec
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