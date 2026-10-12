SpriteSet6:		;frame set 6 (duck and hold): frames 337-352
	dw 16		; frames
	dw 110		; pieces
	dw 256		; tiles
	dw .pieces-SpriteSet6
	dw .tiles-SpriteSet6
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,8,16,23,31,40,48,54
	dw 61,65,71,80,85,91,96,103
	dw 110
.pieces:		;x, y, tile, attributes per piece
	incbin "../../../data/Sprites/set06.pieces"
	assert .tiles-.pieces == 4*110
.tiles:		;256 4bpp tiles (32 bytes each)
	incbin "../../../data/Sprites/set06.chr"
SpriteSet6End:
	assert SpriteSet6End-SpriteSet6 == $1E4+256*32
