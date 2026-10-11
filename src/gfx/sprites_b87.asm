; gfx/sprites_b87: sprite frame sets (SpriteSetN, see FrameSetTable): header, frame table, pieces, 4bpp tiles.
; Bank $87. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $878000
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
	incbin "../../data/Sprites/set02.pieces"
	assert .tiles-.pieces == 4*209
.tiles:		;512 4bpp tiles (32 bytes each)
	incbin "../../data/Sprites/set02.chr"
SpriteSet2End:
	assert SpriteSet2End-SpriteSet2 == $3A0+512*32

org $87D205
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
	incbin "../../data/Sprites/set06.pieces"
	assert .tiles-.pieces == 4*110
.tiles:		;256 4bpp tiles (32 bytes each)
	incbin "../../data/Sprites/set06.chr"
SpriteSet6End:
	assert SpriteSet6End-SpriteSet6 == $1E4+256*32
