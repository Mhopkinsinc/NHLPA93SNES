; $899000-$899FFF  ROM $49000-$49FFF: the last SpriteSet11 tiles, ReplayMode (93G hockey93_02: instant replay control), then SpriteSet13
; (frame set 13: goalie catch, glass and save frames), tiles continue to bank89_E000.
org $899000
	incbin "../data/Sprites/set11.chr":$F10..$1000		; $899000-$8990EF
SpriteSet11End:
	assert SpriteSet11End-SpriteSet11 == $F0+128*32
ReplayMode:		;auto: CODE_8990F0 (from the pause menu, $83F905). 93G ReplayMode (hockey93_02, the 92G form without tracking): replay icon, rewind to the first frame; dpad scrolls, A plays/stops, Y
		;   rewinds, B steps (slow motion), L/R one frame, Start leaves
	stz.b DMAListend		; $8990F0: 64 A3
	stz.b crowdlevel		; $8990F2: 64 DE
	lda.w #sf2replay		; $8990F4: A9 00 08
	tsb.w sflags		; $8990F7: 0C 8C 12
	jsl.l ClrHor		; $8990FA: 22 28 A8 80
	stz.w VMADDL		; $8990FE: 9C 16 21
	lda.w #$FFFF		; $899101: A9 FF FF
	sta.b textdirtylo		; $899104: 85 D0
	stz.b textdirtyhi		; $899106: 64 D2
	lda.w blankchar		; $899108: AD E7 1B
	clc		; $89910B: 18
	adc.w charofs		; $89910C: 6D CD 1B
	ldx.w #$0400		; $89910F: A2 00 04
.clr:
	sta.w VMDATAL		; $899112: 8D 18 21
	dex		; $899115: CA
	bne .clr		; $899116: D0 FA
	lda.w #$0042		; $899118: A9 42 00
	sta.b tmp0		; $89911B: 85 73
	ldx.w #$2020		; $89911D: A2 20 20
	lda.w #$0004		; $899120: A9 04 00
	sta.b tmp1		; $899123: 85 75
.icon:
	lda.b tmp0		; $899125: A5 73
	sta.w VMADDL		; $899127: 8D 16 21
	ldy.w #$0008		; $89912A: A0 08 00
.il:
	lda.l IceRinkMap,x		; $89912D: BF CB CC 83
	ora.w #$2000		; $899131: 09 00 20
	clc		; $899134: 18
	adc.w charofs		; $899135: 6D CD 1B
	sta.w VMDATAL		; $899138: 8D 18 21
	inx		; $89913B: E8
	inx		; $89913C: E8
	dey		; $89913D: 88
	bne .il		; $89913E: D0 ED
	lda.b tmp0		; $899140: A5 73
	clc		; $899142: 18
	adc.w #$0020		; $899143: 69 20 00
	sta.b tmp0		; $899146: 85 73
	txa		; $899148: 8A
	adc.w #$0050		; $899149: 69 50 00
	tax		; $89914C: AA
	dec.b tmp1		; $89914D: C6 75
	bne .icon		; $89914F: D0 D4
	lda.w #sfscrl		; $899151: A9 20 00
	trb.w sflags		; $899154: 1C 8C 12
	lda.w Vpos		; $899157: AD DF 08
	pha		; $89915A: 48
	lda.w Hpos		; $89915B: AD 54 01
	pha		; $89915E: 48
	lda.w ReplayBufferPtr		; $89915F: AD 95 04
	cmp.w #ReplayBufferStart		; $899162: C9 74 81
	lda.w ReplayBufferPtr+2		; $899165: AD 97 04
	sbc.w #ReplayBufferStart>>16		; $899168: E9 7E 00
	bcs .chk		; $89916B: B0 0C
.wrap:		;the buffer pointer back inside the replay buffer
	lda.w #ReplayBufferStart		; $89916D: A9 74 81
	sta.w ReplayBufferPtr		; $899170: 8D 95 04
	lda.w #ReplayBufferStart>>16		; $899173: A9 7E 00
	sta.w ReplayBufferPtr+2		; $899176: 8D 97 04
.chk:
	lda.w #ReplayBufferEnd		; $899179: A9 41 FF
	cmp.w ReplayBufferPtr		; $89917C: CD 95 04
	lda.w #ReplayBufferEnd>>16		; $89917F: A9 7E 00
	sbc.w ReplayBufferPtr+2		; $899182: ED 97 04
	bcc .wrap		; $899185: 90 E6
	lda.w ReplayBufferPtr		; $899187: AD 95 04
	sec		; $89918A: 38
	sbc.w #ReplayBufferStart		; $89918B: E9 74 81
	sta.b mulb		; $89918E: 85 83
	lda.w ReplayBufferPtr+2		; $899190: AD 97 04
	sbc.w #ReplayBufferStart>>16		; $899193: E9 7E 00
	sta.b mulb+2		; $899196: 85 85
	lda.w #replaysize		; $899198: A9 71 00
	sta.b mula		; $89919B: 85 7D
	jsl.l divu		; $89919D: 22 E5 CB 80
	lda.b mulres+2		; $8991A1: A5 95
	bne .wrap		; $8991A3: D0 C8
	lda.w ReplayBufferPtr		; $8991A5: AD 95 04
	sta.b a4		; $8991A8: 85 43
	lda.w ReplayBufferPtr+2		; $8991AA: AD 97 04
	sta.b a4+2		; $8991AD: 85 45
	lda.w #$0000		; $8991AF: A9 00 00
	pha		; $8991B2: 48
.rwd:		;rewind to the first frame, counting the frames
	jsl.l $8F8E54		; $8991B3: 22 54 8E 8F  bank $8F: 93G suba4 (one replay frame back)
	pla		; $8991B7: 68
	inc a		; $8991B8: 1A
	pha		; $8991B9: 48
	lda.b d7		; $8991BA: A5 6F
	bne .rwd		; $8991BC: D0 F5
	pla		; $8991BE: 68
	lsr a		; $8991BF: 4A
	pha		; $8991C0: 48
.fwd:		;then forward to the middle
	lda.b $01,s		; $8991C1: A3 01
	beq .go		; $8991C3: F0 09
	jsl.l $8F8EAF		; $8991C5: 22 AF 8E 8F  bank $8F: 93G adda4 (one replay frame on)
	pla		; $8991C9: 68
	dec a		; $8991CA: 3A
	pha		; $8991CB: 48
	bra .fwd		; $8991CC: 80 F3
.go:
	pla		; $8991CE: 68
	jsl.l SprSort		; $8991CF: 22 6C B7 80
	jsl.l setvideo		; $8991D3: 22 5E E3 80
	lda.w #sf3rmplay		; $8991D7: A9 02 00
	trb.w sflags3		; $8991DA: 1C 90 12
	lda.w #$0001		; $8991DD: A9 01 00
	sta.b d7		; $8991E0: 85 6F
.top:		;93G .top: wait d7 frames
	lda.b vcount		; $8991E2: A5 00
	sec		; $8991E4: 38
	sbc.w oldvcount		; $8991E5: ED 27 04
	cmp.b d7		; $8991E8: C5 6F
	bcc .top		; $8991EA: 90 F6
	lda.b vcount		; $8991EC: A5 00
	sta.w lastframevc		; $8991EE: 8D DB 08
	sta.w oldvcount		; $8991F1: 8D 27 04
	jsl.l ReadPads		; $8991F4: 22 E8 F3 80
	lda.w #$0001		; $8991F8: A9 01 00
	sta.b d7		; $8991FB: 85 6F
	jsl.l getpzjoy		; $8991FD: 22 0E FF 85
	lda.b d0		; $899201: A5 53
	bit.w #$0008		; $899203: 89 08 00
	beq .man		; $899206: F0 03
	jmp.w .nomans		; $899208: 4C 9E 92
.man:		;dpad: scroll by hand
	and.w #$0007		; $89920B: 29 07 00
	sta.b d0		; $89920E: 85 53
	lda.w #sfscrl		; $899210: A9 20 00
	tsb.w sflags		; $899213: 0C 8C 12
	asl.b d0		; $899216: 06 53
	asl.b d0		; $899218: 06 53
	lda.w #.stab		; $89921A: A9 7E 92
	sta.b a0		; $89921D: 85 33
	lda.w #.stab>>16		; $89921F: A9 89 00
	sta.b a0+2		; $899222: 85 35
	ldy.b d0		; $899224: A4 53
	lda.b [a0],y		; $899226: B7 33
	adc.w Hpos		; $899228: 6D 54 01
	sta.b d1		; $89922B: 85 57
	bit.w #$8000		; $89922D: 89 00 80
	beq .ax		; $899230: F0 04
	eor.w #$FFFF		; $899232: 49 FF FF
	inc a		; $899235: 1A
.ax:
	cmp.w #$0041		; $899236: C9 41 00
	bcs .nox		; $899239: B0 05
	lda.b d1		; $89923B: A5 57
	sta.w Hpos		; $89923D: 8D 54 01
.nox:
	iny		; $899240: C8
	iny		; $899241: C8
	lda.b [a0],y		; $899242: B7 33
	clc		; $899244: 18
	adc.w Vpos		; $899245: 6D DF 08
	sta.b d1		; $899248: 85 57
	sec		; $89924A: 38
	sbc.w #$0100		; $89924B: E9 00 01
	beq .ylo		; $89924E: F0 08
	bmi .lt		; $899250: 30 04
	bvs .ylo		; $899252: 70 04
	bra .noy		; $899254: 80 15
.lt:
	bvs .noy		; $899256: 70 13
.ylo:
	lda.b d1		; $899258: A5 57
	sec		; $89925A: 38
	sbc.w #$FF39		; $89925B: E9 39 FF
	bmi .lt2		; $89925E: 30 04
	bvc .sety		; $899260: 50 04
	bra .noy		; $899262: 80 07
.lt2:
	bvc .noy		; $899264: 50 05
.sety:
	lda.b d1		; $899266: A5 57
	sta.w Vpos		; $899268: 8D DF 08
.noy:
	lda.w PadControlBits		; $89926B: AD 31 04
	and.w #$0FFF		; $89926E: 29 FF 0F
	ora.w #$E000		; $899271: 09 00 E0
	sta.w PadControlBits		; $899274: 8D 31 04
	jsl.l setvideo		; $899277: 22 5E E3 80
	jmp.w .top		; $89927B: 4C E2 91
.stab:		;93G .stab: x, y scroll step per dpad direction
	dw 0,1,1,1,1,0,1,-1		; $89927E
	dw 0,-1,-1,-1,-1,0,-1,1		; $89928E
.nomans:
	lda.b d1		; $89929E: A5 57
	bit.w #JOYA		; $8992A0: 89 80 00
	beq .b00		; $8992A3: F0 09
	lda.w sflags3		; $8992A5: AD 90 12
	eor.w #sf3rmplay		; $8992A8: 49 02 00
	sta.w sflags3		; $8992AB: 8D 90 12
.b00:
	lda.b d1		; $8992AE: A5 57
	bit.w #JOYL		; $8992B0: 89 20 00
	bne .r1		; $8992B3: D0 1D
	bit.w #JOYR		; $8992B5: 89 10 00
	bne .f2		; $8992B8: D0 44
	lda.b d3		; $8992BA: A5 5F
	bit.w #abut		; $8992BC: 89 00 40
	beq .f0		; $8992BF: F0 28
	jsl.l $8F8E54		; $8992C1: 22 54 8E 8F  bank $8F: 93G suba4 (one replay frame back)
	jsl.l SprSort		; $8992C5: 22 6C B7 80
	lda.w #$812F		; $8992C9: A9 2F 81
.wait:
	cmp.b vbint		; $8992CC: C5 14
	beq .wait		; $8992CE: F0 FC
	bra .vid		; $8992D0: 80 08
.r1:		;L: one frame back
	jsl.l $8F8E54		; $8992D2: 22 54 8E 8F  bank $8F: 93G suba4 (one replay frame back)
.show:
	jsl.l SprSort		; $8992D6: 22 6C B7 80
.vid:
	jsl.l setvideo		; $8992DA: 22 5E E3 80
	lda.w #$0001		; $8992DE: A9 01 00
	sta.b d7		; $8992E1: 85 6F
	lda.w #sf3rmplay		; $8992E3: A9 02 00
	trb.w sflags3		; $8992E6: 1C 90 12
.f0:		;93G .0: B steps
	lda.b d3		; $8992E9: A5 5F
	bit.w #bbut		; $8992EB: 89 00 80
	beq .pl		; $8992EE: F0 28
	bit.w #abut		; $8992F0: 89 00 40
	beq .f1		; $8992F3: F0 0F
	lda.w #sfscrl		; $8992F5: A9 20 00
	trb.w sflags		; $8992F8: 1C 8C 12
	jmp.w .top		; $8992FB: 4C E2 91
.f2:		;R: one frame on
	jsl.l $8F8EAF		; $8992FE: 22 AF 8E 8F  bank $8F: 93G adda4 (one replay frame on)
	bra .show		; $899302: 80 D2
.f1:
	jsl.l $8F8EAF		; $899304: 22 AF 8E 8F  bank $8F: 93G adda4 (one replay frame on)
	jsl.l SprSort		; $899308: 22 6C B7 80
	jsl.l setvideo		; $89930C: 22 5E E3 80
	asl.b d7		; $899310: 06 6F
	lda.w #sf3rmplay		; $899312: A9 02 00
	trb.w sflags3		; $899315: 1C 90 12
.pl:		;93G .1: play mode on: one frame at the original speed, with its sounds
	lda.w sflags3		; $899318: AD 90 12
	bit.w #sf3rmplay		; $89931B: 89 02 00
	beq .noplay		; $89931E: F0 19
	stz.w lastsfx		; $899320: 9C 7F 01
	jsl.l $8F8EAF		; $899323: 22 AF 8E 8F  bank $8F: 93G adda4 (one replay frame on)
	lda.w lastsfx		; $899327: AD 7F 01
	beq .nosfx		; $89932A: F0 05
	pha		; $89932C: 48
	jsl.l sfx		; $89932D: 22 8B C2 80
.nosfx:
	jsl.l SprSort		; $899331: 22 6C B7 80
	jsl.l setvideo		; $899335: 22 5E E3 80
.noplay:
	lda.b d1		; $899339: A5 57
	bit.w #JOYSTART		; $89933B: 89 00 10
	bne .exit		; $89933E: D0 03
	jmp.w .top		; $899340: 4C E2 91
.exit:
	jsl.l $8FE404		; $899343: 22 04 E4 8F  bank $8F: 93G forceblack
	lda.w #$F000		; $899347: A9 00 F0
	tsb.w PadControlBits		; $89934A: 0C 31 04
	lda.w #sfscrl		; $89934D: A9 20 00
	trb.w sflags		; $899350: 1C 8C 12
	lda.w ReplayBufferPtr		; $899353: AD 95 04
	sta.b a4		; $899356: 85 43
	lda.w ReplayBufferPtr+2		; $899358: AD 97 04
	sta.b a4+2		; $89935B: 85 45
	jsl.l RestoreReplayFrame		; $89935D: 22 E9 F3 87
	jsl.l SprSort		; $899361: 22 6C B7 80
	pla		; $899365: 68
	sta.w Hpos		; $899366: 8D 54 01
	pla		; $899369: 68
	sta.w Vpos		; $89936A: 8D DF 08
	lda.w #sf2replay		; $89936D: A9 00 08
	trb.w sflags		; $899370: 1C 8C 12
	jsl.l $8F84B5		; $899373: 22 B5 84 8F  bank $8F: 93G SetHor
	jsl.l setvideo		; $899377: 22 5E E3 80
	stz.b textdirtylo		; $89937B: 64 D0
	lda.w #$03FF		; $89937D: A9 FF 03
	sta.b textdirtyhi		; $899380: 85 D2
	rtl		; $899382: 6B
SpriteSet13:		;frame set 13 (goalie catch, glass and save): frames 606-658
	dw 53		; $899383 frames
	dw 345		; $899385 pieces
	dw 640		; $899387 tiles
	dw .pieces-SpriteSet13		; $899389
	dw .tiles-SpriteSet13		; $89938B
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,6,9,12,15,18,21,25		; $89938D
	dw 30,34,37,40,43,49,55,60		; $89939D
	dw 64,66,74,83,91,97,101,104		; $8993AD
	dw 107,113,121,126,134,141,151,161		; $8993BD
	dw 167,176,184,191,199,207,214,222		; $8993CD
	dw 228,239,248,257,267,276,284,293		; $8993DD
	dw 304,313,325,332,339,345		; $8993ED
.pieces:		;x, y, tile, attributes per piece
	incbin "../data/Sprites/set13.pieces"		; $8993F9-$89995C
	assert .tiles-.pieces == 4*345
.tiles:		;640 4bpp tiles (32 bytes each)
	incbin "../data/Sprites/set13.chr":0..$6A3		; $89995D-$899FFF
