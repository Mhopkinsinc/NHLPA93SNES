DoGameFrame:		;wait for at least one vblank, then run one frame of game logic
		;   SNES: one frame of game logic (d7 = elapsed frames, set by the caller)
	jsl.l periodicevents		; periodicevents
	jsl.l updateplayers		; updateplayers
	jsl.l checkwindow		; checkwindow
	jsl.l updatereplay		; updatereplay
	jmp.w setvideo
