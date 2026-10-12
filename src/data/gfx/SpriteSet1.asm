SpriteSet1:		;frame set 1 (SPFswing): frames 97-144
	dw 48		; frames
	dw 258		; pieces
	dw 512		; tiles
	dw .pieces-SpriteSet1
	dw .tiles-SpriteSet1
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,6,12,20,24,29,35,39
	dw 43,45,48,56,60,64,69,72
	dw 76,84,89,94,97,100,106,112
	dw 120,125,131,136,140,145,157,162
	dw 166,172,176,186,197,201,206,209
	dw 215,224,232,238,243,248,252,255
	dw 258
.pieces:		;x, y, tile, attributes per piece
	incbin "../../../data/Sprites/set01.pieces"
	assert .tiles-.pieces == 4*258
.tiles:		;512 4bpp tiles (32 bytes each)
	incbin "../../../data/Sprites/set01.chr"
SpriteSet1End:
	assert SpriteSet1End-SpriteSet1 == $474+512*32
