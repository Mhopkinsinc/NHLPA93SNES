; $898000-$898FFF  ROM $48000-$48FFF: SpriteSet11, sprite frame set 11 of the frame set table at $8FE67D: frames 518-531 (SPFSiren ..
; SPFSiren+13: the goal siren light frames). Format as SpriteSet9 (bank84_8000); tiles continue to bank89_9000.
org $898000
SpriteSet11:		;frame set 11 (goal siren): frames 518-531
	dw 14		; frames
	dw 50		; pieces
	dw 128		; tiles
	dw .pieces-SpriteSet11
	dw .tiles-SpriteSet11
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,2,5,8,16,19,22,24
	dw 28,32,35,39,42,46,50
.pieces:		;x, y, tile, attributes per piece
	incbin "../data/Sprites/set11.pieces"		; $898028-$8980EF
	assert .tiles-.pieces == 4*50
.tiles:		;128 4bpp tiles (32 bytes each)
	incbin "../data/Sprites/set11.chr":0..$F10		; $8980F0-$898FFF
