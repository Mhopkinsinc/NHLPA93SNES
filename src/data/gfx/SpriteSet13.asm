SpriteSet13:		;frame set 13 (goalie catch, glass and save): frames 606-658
	dw 53		; frames
	dw 345		; pieces
	dw 640		; tiles
	dw .pieces-SpriteSet13
	dw .tiles-SpriteSet13
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,6,9,12,15,18,21,25
	dw 30,34,37,40,43,49,55,60
	dw 64,66,74,83,91,97,101,104
	dw 107,113,121,126,134,141,151,161
	dw 167,176,184,191,199,207,214,222
	dw 228,239,248,257,267,276,284,293
	dw 304,313,325,332,339,345
.pieces:		;x, y, tile, attributes per piece
	incbin "../../../data/Sprites/set13.pieces"
	assert .tiles-.pieces == 4*345
.tiles:		;640 4bpp tiles (32 bytes each)
	incbin "../../../data/Sprites/set13.chr"
SpriteSet13End:
	assert SpriteSet13End-SpriteSet13 == $5DA+640*32
