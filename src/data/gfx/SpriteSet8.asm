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
	incbin "../../../data/Sprites/set08.pieces"
	assert .tiles-.pieces == 4*75
.tiles:		;128 4bpp tiles (32 bytes each)
	incbin "../../../data/Sprites/set08.chr"
SpriteSet8End:
	assert SpriteSet8End-SpriteSet8 == $164+128*32
