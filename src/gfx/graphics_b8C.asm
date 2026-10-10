; gfx/graphics_b8C: 93G graphics93: packed screens, tiles, maps, palettes, fonts, pixel remap tables.
; Bank $8C. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8C8000
NHLPALogo:		;SNES: the NHLPA logo, packed (data/NHLPALogo.map.pak): 8 x 10 map, 128 colours at $A0, 53 tiles at $1A0; game setup and playoff screens
	incbin "../../data/NHLPALogo.map.pak"		; $8C8000-$8C8459
NHLPALogoEnd:
	assert NHLPALogoEnd-NHLPALogo == $45A
