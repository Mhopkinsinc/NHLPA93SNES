; gfx/graphics_b80: 93G graphics93: packed screens, tiles, maps, palettes, fonts, pixel remap tables.
; Bank $80. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $80ED38
RonBarrMap:		;93G RonBarrMap (RonBarr.map.jim): the Ron Barr picture of the scouting report, packed for DecompressGraphics (data/RonBarr.map.pak, 1590 bytes): unpacked an 8 x 9 map, 64 colours at
		;   +$90, tiles at +$190 (loaded by $8FDD22)
	incbin "../../data/RonBarr.map.pak"		; $80ED38-$80F36D
RonBarrMapEnd:
	assert RonBarrMapEnd-RonBarrMap == $636
