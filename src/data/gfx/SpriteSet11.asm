SpriteSet11:		;frame set 11 (goal siren): frames 518-531
	dw 14		; frames
	dw 50		; pieces
	dw 128		; tiles
	dw .pieces-SpriteSet11
	dw .tiles-SpriteSet11
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,2,5,8,16,19,22,24
	dw 28,32,35,39,42,46,50
.pieces:		;x, y, tile, attributes per piece
	incbin "../../../data/Sprites/set11.pieces"
	assert .tiles-.pieces == 4*50
.tiles:		;128 4bpp tiles (32 bytes each)
	incbin "../../../data/Sprites/set11.chr"
SpriteSet11End:
	assert SpriteSet11End-SpriteSet11 == $F0+128*32
