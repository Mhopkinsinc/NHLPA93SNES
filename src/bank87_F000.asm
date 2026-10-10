; $87F000-$87FFFF  ROM $3F000-$3FFFF: the last SpriteSet6 tiles, RestoreReplayFrame (hockey93_02), PixelRemap87, RefTiles (packed ref window tiles, vertical
; surround tiles for setupice), assepen (logic93_2, asstab $A), $FF fill.
org $87F000
	incbin "../data/Sprites/set06.chr":$1C17..$2000		; $87F000-$87F3E8
SpriteSet6End:
	assert SpriteSet6End-SpriteSet6 == $1E4+256*32
RestoreReplayFrame:		;auto: CODE_87F3E9. 93G RestoreReplayFrame (hockey93_02): replay frame record [a4] back into the objects (x, y 12 bits, frame, flip bits), rostnum/position pairs, puck and
		;   shadow z, lastsfx, d7 = frame delay, PadControlBits, crowdframe, glovecords, PBnum, Hpos/Vpos (not when sfscrl)
	stx.b xsave		; $87F3E9: 86 0A
	ldx.w #$0000		; $87F3EB: A2 00 00
.pushd:
	lda.b d0,x		; $87F3EE: B5 53
	pha		; $87F3F0: 48
	inx		; $87F3F1: E8
	inx		; $87F3F2: E8
	cpx.w #$000C		; $87F3F3: E0 0C 00
	bne .pushd		; $87F3F6: D0 F6
	ldx.b xsave		; $87F3F8: A6 0A
	stx.b xsave		; $87F3FA: 86 0A
	ldx.w #$0000		; $87F3FC: A2 00 00
.pusha:
	lda.b a0,x		; $87F3FF: B5 33
	pha		; $87F401: 48
	inx		; $87F402: E8
	inx		; $87F403: E8
	cpx.w #$0004		; $87F404: E0 04 00
	bne .pusha		; $87F407: D0 F6
	ldx.b xsave		; $87F409: A6 0A
	lda.b a4		; $87F40B: A5 43  a0 = a4 (the record)
	sta.b a0		; $87F40D: 85 33
	lda.b a4+2		; $87F40F: A5 45
	sta.b a0+2		; $87F411: 85 35
	lda.w #$000F		; $87F413: A9 0F 00
	sta.b d1		; $87F416: 85 57
	ldx.w #$0000		; $87F418: A2 00 00
.top:		;16 objects
	lda.b [a0]		; $87F41B: A7 33
	and.w #$0FFF		; $87F41D: 29 FF 0F
	bit.w #$0800		; $87F420: 89 00 08
	beq .p		; $87F423: F0 03
	ora.w #$F000		; $87F425: 09 00 F0
.p:
	sta.w Xpos,x		; $87F428: 9D FF 08
	inc.b a0		; $87F42B: E6 33
	lda.b [a0]		; $87F42D: A7 33
	lsr a		; $87F42F: 4A
	lsr a		; $87F430: 4A
	lsr a		; $87F431: 4A
	lsr a		; $87F432: 4A
	bit.w #$0800		; $87F433: 89 00 08
	beq .p1		; $87F436: F0 03
	ora.w #$F000		; $87F438: 09 00 F0
.p1:
	sta.w Ypos,x		; $87F43B: 9D 5F 09
	inc.b a0		; $87F43E: E6 33
	inc.b a0		; $87F440: E6 33
	lda.b [a0]		; $87F442: A7 33
	and.w #$3FFF		; $87F444: 29 FF 3F
	sta.w frame,x		; $87F447: 9D 3F 09
	lda.w attribute,x		; $87F44A: BD DF 09
	and.w #$E7FF		; $87F44D: 29 FF E7
	sta.w attribute,x		; $87F450: 9D DF 09
	lda.b [a0]		; $87F453: A7 33
	lsr a		; $87F455: 4A
	lsr a		; $87F456: 4A
	lsr a		; $87F457: 4A
	and.w #$1800		; $87F458: 29 00 18
	ora.w attribute,x		; $87F45B: 1D DF 09
	sta.w attribute,x		; $87F45E: 9D DF 09
	inc.b a0		; $87F461: E6 33
	inc.b a0		; $87F463: E6 33
	inx		; $87F465: E8
	inx		; $87F466: E8
	dec.b d1		; $87F467: C6 57
	bpl .top		; $87F469: 10 B0
	lda.w #$0005		; $87F46B: A9 05 00
	sta.b d2		; $87F46E: 85 5B
	ldx.w #$0000		; $87F470: A2 00 00
.pl:		;6 pairs of players
	lda.b [a0]		; $87F473: A7 33
	inc.b a0		; $87F475: E6 33
	and.w #$00FF		; $87F477: 29 FF 00
	sta.w rostnum,x		; $87F47A: 9D 3F 10
	lda.b [a0]		; $87F47D: A7 33
	inc.b a0		; $87F47F: E6 33
	and.w #$00FF		; $87F481: 29 FF 00
	sta.w rostnum+2,x		; $87F484: 9D 41 10
	lda.b [a0]		; $87F487: A7 33
	and.w #$000F		; $87F489: 29 0F 00
	cmp.w #$000F		; $87F48C: C9 0F 00
	bne .n0		; $87F48F: D0 03
	lda.w #$FFFF		; $87F491: A9 FF FF
.n0:
	sta.w position,x		; $87F494: 9D 9F 0B
	lda.b [a0]		; $87F497: A7 33
	lsr a		; $87F499: 4A
	lsr a		; $87F49A: 4A
	lsr a		; $87F49B: 4A
	lsr a		; $87F49C: 4A
	and.w #$000F		; $87F49D: 29 0F 00
	cmp.w #$000F		; $87F4A0: C9 0F 00
	bne .n1		; $87F4A3: D0 03
	lda.w #$FFFF		; $87F4A5: A9 FF FF
.n1:
	sta.w position+2,x		; $87F4A8: 9D A1 0B
	inc.b a0		; $87F4AB: E6 33
	inx		; $87F4AD: E8
	inx		; $87F4AE: E8
	inx		; $87F4AF: E8
	inx		; $87F4B0: E8
	dec.b d2		; $87F4B1: C6 5B
	bpl .pl		; $87F4B3: 10 BE
	lda.b [a0]		; $87F4B5: A7 33
	inc.b a0		; $87F4B7: E6 33
	and.w #$00FF		; $87F4B9: 29 FF 00
	bit.w #$0080		; $87F4BC: 89 80 00
	beq .pz		; $87F4BF: F0 03
	ora.w #$FF00		; $87F4C1: 09 00 FF
.pz:
	sta.w Zpos+puckobj		; $87F4C4: 8D BB 09
	lda.b [a0]		; $87F4C7: A7 33
	inc.b a0		; $87F4C9: E6 33
	and.w #$00FF		; $87F4CB: 29 FF 00
	bit.w #$0080		; $87F4CE: 89 80 00
	beq .sz		; $87F4D1: F0 03
	ora.w #$FF00		; $87F4D3: 09 00 FF
.sz:
	sta.w Zpos+$1E		; $87F4D6: 8D BD 09
	lda.b [a0]		; $87F4D9: A7 33
	inc.b a0		; $87F4DB: E6 33
	and.w #$00FF		; $87F4DD: 29 FF 00
	sta.w lastsfx		; $87F4E0: 8D 7F 01
	lda.b [a0]		; $87F4E3: A7 33
	inc.b a0		; $87F4E5: E6 33
	and.w #$00FF		; $87F4E7: 29 FF 00
	sta.b d7		; $87F4EA: 85 6F
	lda.w PadControlBits		; $87F4EC: AD 31 04  PadControlBits low 12 bits
	and.w #$F000		; $87F4EF: 29 00 F0
	sta.w PadControlBits		; $87F4F2: 8D 31 04
	lda.b [a0]		; $87F4F5: A7 33
	inc.b a0		; $87F4F7: E6 33
	inc.b a0		; $87F4F9: E6 33
	and.w #$0FFF		; $87F4FB: 29 FF 0F
	ora.w PadControlBits		; $87F4FE: 0D 31 04
	sta.w PadControlBits		; $87F501: 8D 31 04
	lda.b [a0]		; $87F504: A7 33
	inc.b a0		; $87F506: E6 33
	inc.b a0		; $87F508: E6 33
	sta.b crowdframe		; $87F50A: 85 DC
	lda.b [a0]		; $87F50C: A7 33
	inc.b a0		; $87F50E: E6 33
	inc.b a0		; $87F510: E6 33
	sta.w glovecords		; $87F512: 8D 4E 01
	lda.b [a0]		; $87F515: A7 33
	inc.b a0		; $87F517: E6 33
	and.w #$00FF		; $87F519: 29 FF 00
	bit.w #$0080		; $87F51C: 89 80 00
	beq .pb		; $87F51F: F0 03
	ora.w #$FF00		; $87F521: 09 00 FF
.pb:
	sta.w PBnum		; $87F524: 8D E4 12
	lda.w sflags		; $87F527: AD 8C 12  sfscrl: keep Hpos/Vpos
	bit.w #sfscrl		; $87F52A: 89 20 00
	bne .x		; $87F52D: D0 0E
	lda.b [a0]		; $87F52F: A7 33
	inc.b a0		; $87F531: E6 33
	inc.b a0		; $87F533: E6 33
	sta.w Hpos		; $87F535: 8D 54 01
	lda.b [a0]		; $87F538: A7 33
	sta.w Vpos		; $87F53A: 8D DF 08
.x:
	stx.b xsave		; $87F53D: 86 0A
	ldx.w #$0002		; $87F53F: A2 02 00
.popa:
	pla		; $87F542: 68
	sta.b a0,x		; $87F543: 95 33
	dex		; $87F545: CA
	dex		; $87F546: CA
	bpl .popa		; $87F547: 10 F9
	ldx.b xsave		; $87F549: A6 0A
	stx.b xsave		; $87F54B: 86 0A
	ldx.w #$000A		; $87F54D: A2 0A 00
.popd:
	pla		; $87F550: 68
	sta.b d0,x		; $87F551: 95 53
	dex		; $87F553: CA
	dex		; $87F554: CA
	bpl .popd		; $87F555: 10 F9
	ldx.b xsave		; $87F557: A6 0A
	rtl		; $87F559: 6B
PixelRemap87:		;SNES: 4bpp pixel value remap for the 4 FramerTiles (bank $88; setupice via $8FE0E4): colours 0-3 only
	db $00,$03,$04,$03		; $87F55A
RefTiles:		;packed ref window tiles for the vertical rink (117): setupice sends them to refchars
	incbin "../data/Ref.chr.pak"		; $87F55E-$87FF77
assepen:		;auto: CODE_87FF78 (asstab $A). 93G assepen (logic93_2): player X leaves the penalty box: PBnum - $10/1, onto the ice at x $88, SPAwallleft; then out of the area (assexit)
	lda.w pflags,x		; $87FF78: BD DF 0E
	bit.w #pfna		; $87FF7B: 89 02 00
	beq .nna		; $87FF7E: F0 52
	and.w #~pfna&$FFFF		; $87FF80: 29 FD FF
	sta.w pflags,x		; $87FF83: 9D DF 0E
	ldy.w #$0010		; $87FF86: A0 10 00
	lda.w pfteam,x		; $87FF89: BD 9F 11
	beq .one		; $87FF8C: F0 03
	ldy.w #$0001		; $87FF8E: A0 01 00
.one:		;93G .1
	sty.b d0		; $87FF91: 84 53
	lda.w PBnum		; $87FF93: AD E4 12
	sec		; $87FF96: 38
	sbc.b d0		; $87FF97: E5 53
	sta.w PBnum		; $87FF99: 8D E4 12
	stz.w Xvel,x		; $87FF9C: 9E DF 0A
	stz.w Yvel,x		; $87FF9F: 9E FF 0A
	lda.w #60		; $87FFA2: A9 3C 00
	sta.b d0		; $87FFA5: 85 53
	lda.w pfteam,x		; $87FFA7: BD 9F 11
	bne .y		; $87FFAA: D0 05
	lda.w #-60		; $87FFAC: A9 C4 FF
	sta.b d0		; $87FFAF: 85 53
.y:
	lda.b d0		; $87FFB1: A5 53
	sta.w Ypos,x		; $87FFB3: 9D 5F 09
	lda.w #$0088		; $87FFB6: A9 88 00
	sta.w Xpos,x		; $87FFB9: 9D FF 08
	lda.w #$0002		; $87FFBC: A9 02 00
	sta.w facedir,x		; $87FFBF: 9D BF 0D
	sta.w pfalock,x		; $87FFC2: 9D 7F 11
	lda.w #SPAwallleft		; $87FFC5: A9 58 10
	sta.b d1		; $87FFC8: 85 57
	jsl.l SetSPA		; $87FFCA: 22 06 B0 80
	jml.l SprSort		; $87FFCE: 5C 6C B7 80
.nna:
	lda.w #$0004		; $87FFD2: A9 04 00
	sta.w facedir,x		; $87FFD5: 9D BF 0D
	lda.w #$FFFF		; $87FFD8: A9 FF FF
	sta.w newpnum,x		; $87FFDB: 9D BF 0E
	sta.w newpos,x		; $87FFDE: 9D 9F 0E
	lda.w pflags,x		; $87FFE1: BD DF 0E
	and.w #$6FF7		; $87FFE4: 29 F7 6F
	sta.w pflags,x		; $87FFE7: 9D DF 0E
	stz.w pfnc,x		; $87FFEA: 9E FF 11
	lda.w #$F000		; $87FFED: A9 00 F0
	sta.w Xvel,x		; $87FFF0: 9D DF 0A
	jml.l assexit		; $87FFF3: 5C F9 96 80
unusedFF87:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $87FFF7
