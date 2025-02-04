system startup
shutDown: isImageQuitting

	isImageQuitting ifFalse: [ ^ self ].
	"ATLDockerRunner instance stopContainer."
	ATLDockerRunner reset.