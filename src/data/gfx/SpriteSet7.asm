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
	incbin "../../../data/Sprites/set07.pieces"
	assert .tiles-.pieces == 4*191
.tiles:		;384 4bpp tiles (32 bytes each)
	incbin "../../../data/Sprites/set07.chr"
SpriteSet7End:
	assert SpriteSet7End-SpriteSet7 == $346+384*32
