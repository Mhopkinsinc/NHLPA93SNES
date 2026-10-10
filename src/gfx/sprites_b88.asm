; gfx/sprites_b88: sprite frame sets (SpriteSetN, see FrameSetTable): header, frame table, pieces, 4bpp tiles.
; Bank $88. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $888A0F
SpriteSet8:		;frame set 8 (arrows, pads, puck and goal): frames 384-405
	dw 22		; frames
	dw 75		; pieces
	dw 128		; tiles
	dw .pieces-SpriteSet8
	dw .tiles-SpriteSet8
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,6,12,18,24,30,36,38
	dw 40,42,43,44,45,46,47,48
	dw 49,50,51,52,53,63,75
.pieces:		;x, y, tile, attributes per piece
	incbin "../../data/Sprites/set08.pieces"		; $888A47-$888B72
	assert .tiles-.pieces == 4*75
.tiles:		;128 4bpp tiles (32 bytes each)
	incbin "../../data/Sprites/set08.chr"
SpriteSet8End:
	assert SpriteSet8End-SpriteSet8 == $164+128*32

org $88BC56
SpriteSet7:		;frame set 7 (gloves, fight, injury and penalty box): frames 353-383
	dw 31		; frames
	dw 191		; pieces
	dw 384		; tiles
	dw .pieces-SpriteSet7
	dw .tiles-SpriteSet7
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,12,17,23,27,32,37,46
	dw 54,59,64,72,79,85,89,94
	dw 98,106,111,115,120,126,130,135
	dw 141,150,159,167,174,181,186,191
.pieces:		;x, y, tile, attributes per piece
	incbin "../../data/Sprites/set07.pieces"		; $88BCA0-$88BF9B
	assert .tiles-.pieces == 4*191
.tiles:		;384 4bpp tiles (32 bytes each)
	incbin "../../data/Sprites/set07.chr"
SpriteSet7End:
	assert SpriteSet7End-SpriteSet7 == $346+384*32
