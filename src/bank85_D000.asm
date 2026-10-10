; $85D000-$85DFFF  ROM $2D000-$2DFFF: the last SpriteSet4 tiles, GetShifter (93G penalty93_2 / 92G), then the start of
; MenuScreen88, a full screen packed for the decompressor $86FA3E (data/MenuScreen88.pak, $85D5C0-$85FBB8): unpacked it is a
; 32 x 28 tile map ($7F0000), 128 colours ($7F0700) and 408 tiles ($7F0800); the bank $88 menu screen setup at $88F2B0 shows it.
org $85D000
	incbin "../data/Sprites/set04.chr":$4A5C..$5000		; $85D000-$85D5A3
SpriteSet4End:
	assert SpriteSet4End-SpriteSet4 == $5A4+640*32
GetShifter:		;auto: CODE_85D5A4. 92G/93G GetShifter: d1 = number of games - 1, d2 = first bit of WinBits for the playoff gamelevel
	lda.w #-16		; $85D5A4: A9 F0 FF
	sta.b d2		; $85D5A7: 85 5B
	lda.w #16		; $85D5A9: A9 10 00
	sta.b d1		; $85D5AC: 85 57
	ldy.w gamelevel		; $85D5AE: AC 4A 01
.3:		;92G .3
	lda.b d2		; $85D5B1: A5 5B
	clc		; $85D5B3: 18
	adc.b d1		; $85D5B4: 65 57
	sta.b d2		; $85D5B6: 85 5B
	lsr.b d1		; $85D5B8: 46 57
	dey		; $85D5BA: 88
	bpl .3		; $85D5BB: 10 F4
	dec.b d1		; $85D5BD: C6 57
	rtl		; $85D5BF: 6B
MenuScreen88:		;packed menu screen (map, palette, tiles)
	incbin "../data/MenuScreen88.pak":0..$A40		; $85D5C0-$85DFFF
