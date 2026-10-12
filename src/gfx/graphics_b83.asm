; gfx/ packed screens, tiles, maps, palettes, fonts, pixel remap tables.
; Bank $83. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $83C6D8

SmallFontTiles:		;packed small font tiles (100 4bpp tiles, the print font of SmallFontMap; setupice and banks $83/$88/$8F unpack them, PixelRemap83)
	incbin "../../data/SmallFont.chr.pak"
SmallFontTilesEnd:

org $83CCCB
IceRinkMap:		;the vertical rink tile map: 48 x 85 words (8160 bytes, data/IceRink.snesmap). Rows go to vram as Vpos scrolls (ShowRinkRows)
	incbin "../../data/IceRink.snesmap"
IceRinkMapEnd:
	assert IceRinkMapEnd-IceRinkMap == 48*85*2
HorRinkMap:		;horizontal rink tile map, 48 x 28 words
	incbin "../../data/IceRinkHor.snesmap"
HorRinkMapEnd:
	assert HorRinkMapEnd-HorRinkMap == 48*28*2
RinkPalette:		;the game palette: 128 colours (data/Pals/Rink.snespal), copied to both halves of palbuffer by setupice
	incbin "../../data/Pals/Rink.snespal"

org $83FAEC
RefsMap:		;the ref window frames, 7 frames of 8 x 7 words (data/Refs.snesmap); PushRef copies frame d0 (+$70 each)
	incbin "../../data/Refs.snesmap"
RefsMapEnd:
	assert RefsMapEnd-RefsMap == 7*$70
