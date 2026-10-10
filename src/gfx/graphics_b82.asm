; gfx/graphics_b82: 93G graphics93: packed screens, tiles, maps, palettes, fonts, pixel remap tables.
; Bank $82. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $82CDA0
IceRinkTiles:		;packed rink tiles (93G IceRinkMap tiles)
	incbin "../../data/IceRink.chr.pak"
IceRinkTilesEnd:
	assert IceRinkTilesEnd-IceRinkTiles == $2B9C

org $82FCBD
PixelRemap8D:		;SNES: 4bpp pixel value remap for BigFontTiles (setupice via $8FE0E4): colour 0 -> 7, the rest unchanged
	db $07,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F

org $82FCD4
PixelRemap83:		;SNES: 4bpp pixel value remap for SmallFontTiles (setupice, $83F990, PlayoffScreen via $8FE0E4). Only colours 0-6 occur: entries 7-15 would read the next bytes (muls32)
	db $04,$03,$04,$03,$02,$01,$04
