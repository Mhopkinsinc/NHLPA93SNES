TeamBlocksTiles:		;TeamBlocks.map.jim tiles: 405 team name banner tiles, packed ($32A0 bytes unpacked); sent to vram by PlayoffScreen, the scouting report and setoptions
	incbin "../../../data/TeamBlocks.chr.pak"
TeamBlocksTilesEnd:
	assert TeamBlocksTilesEnd-TeamBlocksTiles == $20E3
