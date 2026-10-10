; $8ED00B-$8EE00A  ROM $7500B-$7600A: the last SpriteSet3 tiles, then SpriteSet14 (frame set 14: frames 659-720 with 6-byte pieces);
; its pieces continue in bank8E_E000.
org $8ED00B
	incbin "../data/Sprites/set03.chr":$4664..$5000		; $8ED00B-$8ED9A6
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
	incbin "../data/Sprites/set14.pieces":0..$5DC		; $8EDA2F-$8EE00A
