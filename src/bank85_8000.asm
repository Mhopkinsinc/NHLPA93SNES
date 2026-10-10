; $858000-$858FFF  ROM $28000-$28FFF: SpriteSet4, sprite frame set 4 of the frame set table at $8FE67D: frames 225-272 (SPFhipl ..
; SPFfallback-1: the hip, shoulder and sweep check frames). Format as SpriteSet9 (bank84_8000); tiles continue to bank85_D000.
org $858000
SpriteSet4:		;frame set 4 (hip, shoulder and sweep checks): frames 225-272
	dw 48		; $858000 frames
	dw 334		; $858002 pieces
	dw 640		; $858004 tiles
	dw .pieces-SpriteSet4		; $858006
	dw .tiles-SpriteSet4		; $858008
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,6,12,18,24,30,37,44		; $85800A
	dw 50,55,58,67,74,77,79,85		; $85801A
	dw 90,97,104,117,130,135,143,155		; $85802A
	dw 165,171,177,184,194,202,209,214		; $85803A
	dw 220,223,229,234,242,249,258,264		; $85804A
	dw 273,281,288,296,303,312,321,329		; $85805A
	dw 334		; $85806A
.pieces:		;x, y, tile, attributes per piece
	incbin "../data/Sprites/set04.pieces"		; $85806C-$8585A3
	assert .tiles-.pieces == 4*334
.tiles:		;640 4bpp tiles (32 bytes each)
	incbin "../data/Sprites/set04.chr":0..$A5C		; $8585A4-$858FFF
