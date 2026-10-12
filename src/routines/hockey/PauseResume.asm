PauseResume:		;pause menu item 0, Resume Game: A or Start leaves
	lda.b d1
	bit.w #JOYSTART|cbut
	bne PauseLeave
	jmp.w PauseMenu_gj
