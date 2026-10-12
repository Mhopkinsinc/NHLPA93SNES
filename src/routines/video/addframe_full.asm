addframe_full:		;Sprite tile cache full: skip drawing this frame
	lda.w #$0001
	sta.b sprnodraw
	jml.l addframe_end
