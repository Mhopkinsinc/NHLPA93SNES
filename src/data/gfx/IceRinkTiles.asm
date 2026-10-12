IceRinkTiles:		;packed rink tiles
	incbin "../../../data/IceRink.chr.pak"
IceRinkTilesEnd:
	assert IceRinkTilesEnd-IceRinkTiles == $2B9C
