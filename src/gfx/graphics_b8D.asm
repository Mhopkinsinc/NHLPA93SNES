; gfx/ packed screens, tiles, maps, palettes, fonts, pixel remap tables.
; Bank $8D. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8DEEC8
BigFontTiles:		;BigFont.map.jim tiles: the big font (144 tiles, data/BigFont.chr.pak), packed; setupice sends them to BigFontChars (PixelRemap8D), printbig draws them
	incbin "../../data/BigFont.chr.pak"
BigFontTilesEnd:
	assert BigFontTilesEnd-BigFontTiles == $9C0
