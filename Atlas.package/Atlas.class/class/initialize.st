class initialization
initialize
   
	SessionManager default registerUserClassNamed: self name atPriority: (SessionManager default defaultPriority + 1)
