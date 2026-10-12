HorRinkMap:		;horizontal rink tile map, 48 x 28 words
	incbin "../../../data/IceRinkHor.snesmap"
HorRinkMapEnd:
	assert HorRinkMapEnd-HorRinkMap == 48*28*2
