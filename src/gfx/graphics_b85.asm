; gfx/ packed screens, tiles, maps, palettes, fonts, pixel remap tables.
; Bank $85. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $85D5C0
Title1Map:		;the title screen backdrop, packed (map, palette, tiles)
	incbin "../../data/Title1.map.pak"
Title1MapEnd:
	assert Title1MapEnd-Title1Map == $25F9
