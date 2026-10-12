SpriteSet3:		;frame set 3 (SPFcelebrate, SPFpump, SPFcup): frames 185-224
	dw 40		; frames
	dw 344		; pieces
	dw 640		; tiles
	dw .pieces-SpriteSet3
	dw .tiles-SpriteSet3
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,6,16,26,34,48,59,68
	dw 75,82,89,97,105,120,132,140
	dw 147,157,161,167,177,187,195,201
	dw 210,217,222,232,241,247,258,263
	dw 267,276,292,304,311,319,327,333
	dw 344
.pieces:		;x, y, tile, attributes per piece
	incbin "../../../data/Sprites/set03.pieces"
	assert .tiles-.pieces == 4*344
.tiles:		;640 4bpp tiles (32 bytes each)
	incbin "../../../data/Sprites/set03.chr"
SpriteSet3End:
	assert SpriteSet3End-SpriteSet3 == $5BC+640*32
