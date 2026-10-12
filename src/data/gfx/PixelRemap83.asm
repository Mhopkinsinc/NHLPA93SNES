PixelRemap83:		;SNES: 4bpp pixel value remap for SmallFontTiles (setupice, the pause menu, PlayoffScreen via RemapTiles). Only colours 0-6 occur: entries 7-15 would read the next bytes (muls32)
	db $04,$03,$04,$03,$02,$01,$04
