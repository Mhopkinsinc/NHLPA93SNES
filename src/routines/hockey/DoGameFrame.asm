DoGameFrame:		;Run one frame of game logic (d7 = elapsed frames)
	jsl.l periodicevents		; periodicevents
	jsl.l updateplayers		; updateplayers
	jsl.l checkwindow		; checkwindow
	jsl.l updatereplay		; updatereplay
	jmp.w setvideo
