; $8C8000-$8C8FFF  ROM $60000-$60FFF: NHLPALogo (the packed NHLPA logo picture), then SpriteSet0 (frame set 0: skating and turning
; frames 1-96), tiles continue to bank8C_F000.
org $8C8000
NHLPALogo:		;SNES: the NHLPA logo, packed (data/NHLPALogo.map.pak): 8 x 10 map, 128 colours at $A0, 53 tiles at $1A0; game setup and playoff screens
	incbin "../data/NHLPALogo.map.pak"		; $8C8000-$8C8459
NHLPALogoEnd:
	assert NHLPALogoEnd-NHLPALogo == $45A
SpriteSet0:		;frame set 0 (SPFskatewp, SPFskate, SPFturnl, SPFturnr): frames 1-96
	dw 96		; $8C845A frames
	dw 445		; $8C845C pieces
	dw 896		; $8C845E tiles
	dw .pieces-SpriteSet0		; $8C8460
	dw .tiles-SpriteSet0		; $8C8462
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,2,5,7,9,11,15,22		; $8C8464
	dw 28,32,37,40,44,51,59,65		; $8C8474
	dw 69,72,76,84,91,94,101,104		; $8C8484
	dw 108,113,116,122,126,132,137,140		; $8C8494
	dw 148,151,158,161,164,167,173,180		; $8C84A4
	dw 187,190,194,197,200,203,205,209		; $8C84B4
	dw 211,216,218,221,226,231,236,240		; $8C84C4
	dw 243,248,253,258,263,266,270,273		; $8C84D4
	dw 278,283,287,292,296,300,304,307		; $8C84E4
	dw 312,318,323,328,333,336,341,348		; $8C84F4
	dw 353,357,362,369,376,380,385,392		; $8C8504
	dw 397,399,405,412,416,424,434,441		; $8C8514
	dw 445		; $8C8524
.pieces:		;x, y, tile, attributes per piece
	incbin "../data/Sprites/set00.pieces"		; $8C8526-$8C8C19
	assert .tiles-.pieces == 4*445
.tiles:		;896 4bpp tiles (32 bytes each)
	incbin "../data/Sprites/set00.chr":0..$3E6		; $8C8C1A-$8C8FFF
