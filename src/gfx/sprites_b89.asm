; gfx/sprites_b89: sprite frame sets (SpriteSetN, see FrameSetTable): header, frame table, pieces, 4bpp tiles.
; Bank $89. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $898000
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
	incbin "../../data/Sprites/set11.pieces"		; $898028-$8980EF
	assert .tiles-.pieces == 4*50
.tiles:		;128 4bpp tiles (32 bytes each)
	incbin "../../data/Sprites/set11.chr"
SpriteSet11End:
	assert SpriteSet11End-SpriteSet11 == $F0+128*32

org $899383
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
	incbin "../../data/Sprites/set13.pieces"		; $8993F9-$89995C
	assert .tiles-.pieces == 4*345
.tiles:		;640 4bpp tiles (32 bytes each)
	incbin "../../data/Sprites/set13.chr"
SpriteSet13End:
	assert SpriteSet13End-SpriteSet13 == $5DA+640*32
