API - accessing
repositoryDirectory 

	^ (IceRepository repositories 
    detect: [ :repo | repo name = 'Atlas' ] 
    ifNone: [ nil ]) location pathString. 
