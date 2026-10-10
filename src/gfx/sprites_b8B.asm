; gfx/sprites_b8B: sprite frame sets (SpriteSetN, see FrameSetTable): header, frame table, pieces, 4bpp tiles.
; Bank $8B. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8B83EE
SpriteSet5:		;frame set 5 (falls: SPFfallback, SPFfallfwd): frames 273-336
	dw 64		; frames
	dw 533		; pieces
	dw 896		; tiles
	dw .pieces-SpriteSet5
	dw .tiles-SpriteSet5
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,5,13,24,31,36,42,50
	dw 57,65,74,83,91,98,108,117
	dw 124,132,142,152,161,167,177,187
	dw 196,205,212,221,229,234,244,253
	dw 260,263,271,278,283,292,303,314
	dw 321,331,341,349,356,365,375,384
	dw 391,398,408,416,423,432,443,455
	dw 463,471,482,490,498,505,515,526
	dw 533
.pieces:		;x, y, tile, attributes per piece
	incbin "../../data/Sprites/set05.pieces"		; $8B847A-$8B8CCD
	assert .tiles-.pieces == 4*533
.tiles:		;896 4bpp tiles (32 bytes each)
	incbin "../../data/Sprites/set05.chr"
SpriteSet5End:
	assert SpriteSet5End-SpriteSet5 == $8E0+896*32
