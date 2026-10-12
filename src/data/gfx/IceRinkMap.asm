IceRinkMap:		;the vertical rink tile map: 48 x 85 words (8160 bytes, data/IceRink.snesmap). Rows go to vram as Vpos scrolls (ShowRinkRows)
	incbin "../../../data/IceRink.snesmap"
IceRinkMapEnd:
	assert IceRinkMapEnd-IceRinkMap == 48*85*2
