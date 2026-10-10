; $878000-$878FFF  ROM $38000-$38FFF: SpriteSet2, sprite frame set 2 of the frame set table at $8FE67D: frames 145-184 (SPFstop ..
; SPFskateb+23: the stop and skate backwards frames). Format as SpriteSet9 (bank84_8000); tiles continue to bank87_C000.
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
	incbin "../data/Sprites/set02.pieces"		; $87805C-$87839F
	assert .tiles-.pieces == 4*209
.tiles:		;512 4bpp tiles (32 bytes each)
	incbin "../data/Sprites/set02.chr":0..$C60		; $8783A0-$878FFF
