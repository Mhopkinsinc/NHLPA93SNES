; $88E00F-$88EF9B  ROM $4600F-$46F9B: the last SpriteSet7 tiles (see bank88_B000). Ends at the set end; the code after it is in bank88_F000
; (boundary moved from $88F001).
org $88E00F
	incbin "../data/Sprites/set07.chr":$2073..$3000		; $88E00F-$88EF9B
SpriteSet7End:
	assert SpriteSet7End-SpriteSet7 == $346+384*32
