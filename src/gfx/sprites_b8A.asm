; gfx/sprites_b8A: sprite frame sets (SpriteSetN, see FrameSetTable): header, frame table, pieces, 4bpp tiles.
; Bank $8A. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8A8000
SpriteSet12:		;frame set 12 (includes SPFflip, SPFstumble, SPFhook): frames 532-605
	dw 74		; frames
	dw 504		; pieces
	dw 896		; tiles
	dw .pieces-SpriteSet12
	dw .tiles-SpriteSet12
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,11,28,48,67,80,93,100
	dw 108,114,119,120,121,122,123,124
	dw 125,126,127,128,129,130,131,132
	dw 133,134,161,172,179,191,200,207
	dw 215,225,235,242,249,258,264,270
	dw 278,287,293,302,313,325,337,342
	dw 350,355,365,376,386,397,404,413
	dw 420,428,435,438,442,445,450,456
	dw 466,469,473,476,479,482,488,491
	dw 495,500,504
.pieces:		;x, y, tile, attributes per piece
	incbin "../../data/Sprites/set12.pieces"		; $8A80A0-$8A887F
	assert .tiles-.pieces == 4*504
.tiles:		;896 4bpp tiles (32 bytes each)
	incbin "../../data/Sprites/set12.chr"
SpriteSet12End:
	assert SpriteSet12End-SpriteSet12 == $880+896*32
