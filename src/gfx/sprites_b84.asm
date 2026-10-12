; gfx/sprites_b84: sprite frame sets (SpriteSetN, see FrameSetTable): header, frame table, pieces, 4bpp tiles.
; Bank $84. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $848000
SpriteSet9:		;frame set 9: frames 406-461
	dw 56		; frames
	dw 365		; pieces
	dw 640		; tiles
	dw .pieces-SpriteSet9
	dw .tiles-SpriteSet9
.frames:		;first piece of each frame (frame n = SPFGoalie+n)
	dw 0,8,15,24,28,35,40,43
	dw 49,53,60,67,73,83,90,99
	dw 108,114,121,124,127,133,139,146
	dw 155,158,163,172,180,186,191,196
	dw 202,209,218,224,229,235,244,249
	dw 255,263,268,275,281,288,293,302
	dw 310,318,326,332,338,343,351,356
	dw 365
.pieces:		;x, y, tile, attributes per piece
	incbin "../../data/Sprites/set09.pieces"
	assert .tiles-.pieces == 4*365
.tiles:		;640 4bpp tiles (32 bytes each)
	incbin "../../data/Sprites/set09.chr"
SpriteSet9End:
	assert SpriteSet9End-SpriteSet9 == $630+640*32
