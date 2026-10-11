; gfx/sprites_b8E: sprite frame sets (SpriteSetN, see FrameSetTable): header, frame table, pieces, 4bpp tiles.
; Bank $8E. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8E83EB
SpriteSet3:		;frame set 3 (SPFcelebrate, SPFpump, SPFcup): frames 185-224
	dw 40		; frames
	dw 344		; pieces
	dw 640		; tiles
	dw .pieces-SpriteSet3
	dw .tiles-SpriteSet3
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,6,16,26,34,48,59,68
	dw 75,82,89,97,105,120,132,140
	dw 147,157,161,167,177,187,195,201
	dw 210,217,222,232,241,247,258,263
	dw 267,276,292,304,311,319,327,333
	dw 344
.pieces:		;x, y, tile, attributes per piece
	incbin "../../data/Sprites/set03.pieces"
	assert .tiles-.pieces == 4*344
.tiles:		;640 4bpp tiles (32 bytes each)
	incbin "../../data/Sprites/set03.chr"
SpriteSet3End:
	assert SpriteSet3End-SpriteSet3 == $5BC+640*32
SpriteSet14:		;frame set 14: frames 659-720, 6-byte pieces (DrawFrameHi)
	dw 62		; frames
	dw 742		; pieces
	dw 151		; tiles
	dw .pieces-SpriteSet14
	dw $11EC		; .tiles-SpriteSet14 (asserted in bank8E_E000)
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,17,31,50,72,89,109,126
	dw 148,162,183,203,216,232,293,344
	dw 395,444,495,501,503,508,512,513
	dw 520,529,534,539,544,549,554,559
	dw 563,567,571,577,581,587,595,602
	dw 606,611,618,628,633,647,667,682
	dw 696,706,710,712,714,717,718,721
	dw 724,727,730,733,736,739,742
.pieces:		;x, y (signed words), tile, attributes per piece (6 bytes, DrawFrameHi)
	incbin "../../data/Sprites/set14.pieces"
	assert .tiles-.pieces == 6*742
	assert .tiles-SpriteSet14 == $11EC
.tiles:		;151 4bpp tiles (32 bytes each)
	incbin "../../data/Sprites/set14.chr"
SpriteSet14End:
	assert SpriteSet14End-SpriteSet14 == $11EC+151*32
