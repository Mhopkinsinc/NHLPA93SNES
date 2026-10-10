; $8DE00C-$8DF00B  ROM $6E00C-$6F00B: the last SpriteSet10 tiles (see bank8D_8000), then BigFontTiles (the packed big font), continued in bank8D_F000.
org $8DE00C
	incbin "../data/Sprites/set10.chr":$5144..$6000		; $8DE00C-$8DEEC7
SpriteSet10End:
	assert SpriteSet10End-SpriteSet10 == $68C+768*32
BigFontTiles:		;93G BigFont.map.jim tiles: the big font (144 tiles, data/BigFont.chr.pak), packed; setupice sends them to BigFontChars (PixelRemap8D), printbig draws them
	incbin "../data/BigFont.chr.pak":0..$144		; $8DEEC8-$8DF00B
