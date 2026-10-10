; $85D000-$85DFFF  ROM $2D000-$2DFFF: the last SpriteSet4 tiles, GetShifter (93G penalty93_2 / 92G), then the start of
; Title1Map, the title screen (goalie and the NHLPA Hockey '93 logo) packed for the decompressor $86FA3E (data/Title1.map.pak, $85D5C0-$85FBB8): unpacked it is a
; 32 x 28 tile map ($7F0000), 128 colours ($7F0700) and 408 tiles ($7F0800); the bank $88 title screen ($88F2B0, 93G TitleScreen) shows it.
org $85D000
	incbin "../data/Sprites/set04.chr":$4A5C..$5000		; $85D000-$85D5A3
SpriteSet4End:
	assert SpriteSet4End-SpriteSet4 == $5A4+640*32
GetShifter:		;auto: CODE_85D5A4. 92G/93G GetShifter: d1 = number of games - 1, d2 = first bit of WinBits for the playoff gamelevel
	lda.w #-16
	sta.b d2
	lda.w #16
	sta.b d1
	ldy.w gamelevel
.3:		;92G .3
	lda.b d2
	clc
	adc.b d1
	sta.b d2
	lsr.b d1
	dey
	bpl .3
	dec.b d1
	rtl
Title1Map:		;93G Title1Map (Title1.map.jim): the title screen backdrop, packed (map, palette, tiles)
	incbin "../data/Title1.map.pak":0..$A40		; $85D5C0-$85DFFF
