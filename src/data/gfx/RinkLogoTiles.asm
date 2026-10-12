RinkLogoTiles:		;SNES: packed rink logo tiles (14 tiles, $1C0 bytes unpacked), sent to vram after FaceOffTiles by setupice. Kept in data/HotList.bin after the hot spots
	incbin "../../../data/HotList.bin":$44A..$5F6
RinkLogoTilesEnd:
