; $848000-$848FFF  ROM $20000-$20FFF: SpriteSet9, sprite frame set 9 of the frame set table at $8FE67D: frames 406-461
; (SPFGoalie .. SPFGoalie+55, the first goalie frames). A frame set: header (frames, pieces, tiles, piece table offset, tile offset),
; the first piece of each frame (+1 entry for the end), the pieces (4 bytes: x, y, tile, attributes; data/Sprites/set09.pieces),
; then the 4bpp tiles (data/Sprites/set09.chr, continued in bank84_9000 .. bank84_D000). Drawn by addframe ($8FEC68 / $85FBB9).
org $848000
SpriteSet9:		;frame set 9 (SNES sprite frames; the 93G frames come from Sprites.anim)
	dw 56		; $848000 frames
	dw 365		; $848002 pieces
	dw 640		; $848004 tiles
	dw .pieces-SpriteSet9		; $848006
	dw .tiles-SpriteSet9		; $848008
.frames:		;first piece of each frame (frame n = SPFGoalie+n)
	dw 0,8,15,24,28,35,40,43		; $84800A
	dw 49,53,60,67,73,83,90,99		; $84801A
	dw 108,114,121,124,127,133,139,146		; $84802A
	dw 155,158,163,172,180,186,191,196		; $84803A
	dw 202,209,218,224,229,235,244,249		; $84804A
	dw 255,263,268,275,281,288,293,302		; $84805A
	dw 310,318,326,332,338,343,351,356		; $84806A
	dw 365		; $84807A
.pieces:		;x, y, tile, attributes per piece
	incbin "../data/Sprites/set09.pieces"		; $84807C-$84862F
	assert .tiles-.pieces == 4*365
.tiles:		;640 4bpp tiles (32 bytes each)
	incbin "../data/Sprites/set09.chr":0..$9D0		; $848630-$848FFF
