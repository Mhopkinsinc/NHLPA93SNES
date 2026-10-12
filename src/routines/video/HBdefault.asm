HBdefault:		;Default horizontal blank handler: count the line and return
	rep #$30
	inc.b hcount
	ply
	plx
	pla
	rti
