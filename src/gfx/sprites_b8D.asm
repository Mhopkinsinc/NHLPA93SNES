; gfx/sprites_b8D: sprite frame sets (SpriteSetN, see FrameSetTable): header, frame table, pieces, 4bpp tiles.
; Bank $8D. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8D883C
SpriteSet10:		;frame set 10 (frames 462-517): frames 462-517
	dw 56		; frames
	dw 388		; pieces
	dw 768		; tiles
	dw .pieces-SpriteSet10
	dw .tiles-SpriteSet10
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,9,18,26,33,42,49,57
	dw 64,72,80,83,91,99,104,112
	dw 120,130,135,143,152,158,164,171
	dw 176,180,184,192,196,202,208,216
	dw 224,230,236,244,251,258,264,270
	dw 275,283,292,298,305,311,316,327
	dw 339,345,349,355,360,367,373,380
	dw 388
.pieces:		;x, y, tile, attributes per piece
	incbin "../../data/Sprites/set10.pieces"
	assert .tiles-.pieces == 4*388
.tiles:		;768 4bpp tiles (32 bytes each)
	incbin "../../data/Sprites/set10.chr"
SpriteSet10End:
	assert SpriteSet10End-SpriteSet10 == $68C+768*32
