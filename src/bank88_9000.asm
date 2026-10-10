; $88900F-$889FFF  ROM $4100F-$41FFF: the rest of SpriteSet8 (see bank88_8000), then TeamBlocksTiles (packed team name banner tiles,
; continued in bank88_A000).
org $88900F
	incbin "../data/Sprites/set08.chr":$49C..$1000		; $88900F-$889B72
SpriteSet8End:
	assert SpriteSet8End-SpriteSet8 == $164+128*32
TeamBlocksTiles:		;93G TeamBlocks.map.jim tiles: 405 team name banner tiles, packed ($32A0 bytes unpacked); vram by PlayoffScreen, $8FDCBC, $8FEFE0
	incbin "../data/TeamBlocks.chr.pak":$0..$49C		; $889B73-$88A00E
