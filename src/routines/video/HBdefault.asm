HBdefault:		;default hbint: count hcount, restore regs, rti
	rep #$30
	inc.b hcount
	ply
	plx
	pla
	rti
