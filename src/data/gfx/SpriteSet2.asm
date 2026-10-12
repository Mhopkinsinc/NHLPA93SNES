SpriteSet2:		;frame set 2 (stop and skate backwards): frames 145-184
	dw 40		; frames
	dw 209		; pieces
	dw 512		; tiles
	dw .pieces-SpriteSet2
	dw .tiles-SpriteSet2
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,3,6,14,22,33,44,50
	dw 56,60,64,69,74,80,86,92
	dw 98,100,104,107,112,118,122,127
	dw 132,137,141,145,151,155,161,166
	dw 171,176,179,184,189,194,199,204
	dw 209
.pieces:		;x, y, tile, attributes per piece
	incbin "../../../data/Sprites/set02.pieces"
	assert .tiles-.pieces == 4*209
.tiles:		;512 4bpp tiles (32 bytes each)
	incbin "../../../data/Sprites/set02.chr"
SpriteSet2End:
	assert SpriteSet2End-SpriteSet2 == $3A0+512*32
