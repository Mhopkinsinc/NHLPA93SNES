; gfx/ packed screens, tiles, maps, palettes, fonts, pixel remap tables.
; Bank $80. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $80ED38
RonBarrMap:		;the Ron Barr picture of the scouting report, packed for DecompressBytecode (data/RonBarr.map.pak, 1590 bytes): unpacked an 8 x 9 map, 64 colours at
		;   +$90, tiles at +$190 (loaded by the scouting report)
	incbin "../../data/RonBarr.map.pak"
RonBarrMapEnd:
	assert RonBarrMapEnd-RonBarrMap == $636
