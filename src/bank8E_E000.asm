; $8EE00B-$8EF00A  ROM $7600B-$7700A: the rest of the SpriteSet14 pieces and the first set 14 tiles (see bank8E_D000)
org $8EE00B
	incbin "../data/Sprites/set14.pieces":$5DC..$1164		; $8EE00B-$8EEB92
	assert .tiles-.pieces == 6*742
	assert .tiles-SpriteSet14 == $11EC
.tiles:		;151 4bpp tiles (32 bytes each)
	incbin "../data/Sprites/set14.chr":$0..$478		; $8EEB93-$8EF00A
