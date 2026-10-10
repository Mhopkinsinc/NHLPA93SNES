; $82E000-$82F93B  ROM $16000-$1793B: IceRinkTiles continued (packed rink tiles, see bank82_D000). Ends at the end of the packed stream
; (boundary moved from $82EFFF); the bank $82 code starts after it in bank82_F000.
org $82E000
	incbin "../data/IceRink.chr.pak":$1260..$2B9C		; $82E000-$82F93B
IceRinkTilesEnd:
	assert IceRinkTilesEnd-IceRinkTiles == $2B9C
