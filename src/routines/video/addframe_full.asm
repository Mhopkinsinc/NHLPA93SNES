addframe_full:		;SNES: sprite VRAM cache full: sprnodraw, addframe_end
	lda.w #$0001
	sta.b sprnodraw
	jml.l addframe_end
