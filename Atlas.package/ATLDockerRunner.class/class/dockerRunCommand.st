as yet unclassified
dockerRunCommand

	 | repoPath |
	
	repoPath := (IceRepository repositories 
    detect: [ :repo | repo name = 'Atlas' ] 
    ifNone: [ nil ]) location pathString. 

	^ repoPath, ' docker compose -f ''docker-compose.yaml'' up -d --build '