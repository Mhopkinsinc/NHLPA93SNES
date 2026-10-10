; $87D205-$87DFFF  ROM $3D205-$3DFFF: SpriteSet6, sprite frame set 6 of the frame set table at $8FE67D: frames 337-352 (SPFduck ..
; SPFhold+7: the duck and hold frames). Format as SpriteSet9 (bank84_8000); tiles continue to bank87_F000. Starts after DrawFrame
; (boundary moved from $87D000).
org $87D205
SpriteSet6:		;frame set 6 (duck and hold): frames 337-352
	dw 16		; $87D205 frames
	dw 110		; $87D207 pieces
	dw 256		; $87D209 tiles
	dw .pieces-SpriteSet6		; $87D20B
	dw .tiles-SpriteSet6		; $87D20D
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,8,16,23,31,40,48,54		; $87D20F
	dw 61,65,71,80,85,91,96,103		; $87D21F
	dw 110		; $87D22F
.pieces:		;x, y, tile, attributes per piece
	incbin "../data/Sprites/set06.pieces"		; $87D231-$87D3E8
	assert .tiles-.pieces == 4*110
.tiles:		;256 4bpp tiles (32 bytes each)
	incbin "../data/Sprites/set06.chr":0..$C17		; $87D3E9-$87DFFF
