; $87F000-$87FFFF  ROM $3F000-$3FFFF: the last SpriteSet6 tiles, RestoreReplayFrame (hockey93_02), PixelRemap87, RefTiles (packed ref window tiles, vertical
; surround tiles for setupice), assepen (logic93_2, asstab $A), $FF fill.
org $87F000
	incbin "../data/Sprites/set06.chr":$1C17..$2000		; $87F000-$87F3E8
SpriteSet6End:
	assert SpriteSet6End-SpriteSet6 == $1E4+256*32
RestoreReplayFrame:		;a4 = current replay frame address to convert into normal (93G hockey93_02)
		;   SNES: replay frame record [a4] back into the objects (x, y 12 bits, frame, flip bits), rostnum/position pairs, puck and
		;   shadow z, lastsfx, d7 = frame delay, PadControlBits, crowdframe, glovecords, PBnum, Hpos/Vpos (not when sfscrl)
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pusha
	ldx.b xsave
	lda.b a4		; a0 = a4 (the record)
	sta.b a0
	lda.b a4+2
	sta.b a0+2
	lda.w #$000F
	sta.b d1
	ldx.w #$0000
.top:		;16 objects
	lda.b [a0]
	and.w #$0FFF
	bit.w #$0800
	beq .p
	ora.w #$F000
.p:
	sta.w Xpos,x
	inc.b a0
	lda.b [a0]
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0800
	beq .p1
	ora.w #$F000
.p1:
	sta.w Ypos,x
	inc.b a0
	inc.b a0
	lda.b [a0]
	and.w #$3FFF
	sta.w frame,x
	lda.w attribute,x
	and.w #$E7FF
	sta.w attribute,x
	lda.b [a0]
	lsr a
	lsr a
	lsr a
	and.w #$1800
	ora.w attribute,x
	sta.w attribute,x
	inc.b a0
	inc.b a0
	inx
	inx
	dec.b d1
	bpl .top
	lda.w #$0005
	sta.b d2
	ldx.w #$0000
.pl:		;6 pairs of players
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.w rostnum,x
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.w rostnum+2,x
	lda.b [a0]
	and.w #$000F
	cmp.w #$000F
	bne .n0
	lda.w #$FFFF
.n0:
	sta.w position,x
	lda.b [a0]
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	cmp.w #$000F
	bne .n1
	lda.w #$FFFF
.n1:
	sta.w position+2,x
	inc.b a0
	inx
	inx
	inx
	inx
	dec.b d2
	bpl .pl
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	bit.w #$0080
	beq .pz
	ora.w #$FF00
.pz:
	sta.w Zpos+puckobj
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	bit.w #$0080
	beq .sz
	ora.w #$FF00
.sz:
	sta.w Zpos+$1E
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.w lastsfx
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.b d7
	lda.w PadControlBits		; PadControlBits low 12 bits
	and.w #$F000
	sta.w PadControlBits
	lda.b [a0]
	inc.b a0
	inc.b a0
	and.w #$0FFF
	ora.w PadControlBits
	sta.w PadControlBits
	lda.b [a0]
	inc.b a0
	inc.b a0
	sta.b crowdframe
	lda.b [a0]
	inc.b a0
	inc.b a0
	sta.w glovecords
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	bit.w #$0080
	beq .pb
	ora.w #$FF00
.pb:
	sta.w PBnum
	lda.w sflags		; sfscrl: keep Hpos/Vpos
	bit.w #sfscrl
	bne .x
	lda.b [a0]
	inc.b a0
	inc.b a0
	sta.w Hpos
	lda.b [a0]
	sta.w Vpos
.x:
	stx.b xsave
	ldx.w #$0002
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$000A
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl
PixelRemap87:		;SNES: 4bpp pixel value remap for the 4 FramerTiles (bank $88; setupice via $8FE0E4): colours 0-3 only
	db $00,$03,$04,$03
RefTiles:		;packed ref window tiles for the vertical rink (117): setupice sends them to refchars
	incbin "../data/Ref.chr.pak"		; $87F55E-$87FF77
assepen:		;asstab $A. player a3 should exit penalty area (93G logic93_2)
		;   SNES: player X leaves the penalty box: PBnum - $10/1, onto the ice at x $88, SPAwallleft; then out of the area (assexit)
	lda.w pflags,x
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	ldy.w #$0010
	lda.w pfteam,x
	beq .one
	ldy.w #$0001
.one:		;93G .1
	sty.b d0
	lda.w PBnum
	sec
	sbc.b d0
	sta.w PBnum
	stz.w Xvel,x
	stz.w Yvel,x
	lda.w #60
	sta.b d0
	lda.w pfteam,x
	bne .y
	lda.w #-60
	sta.b d0
.y:
	lda.b d0
	sta.w Ypos,x
	lda.w #$0088
	sta.w Xpos,x
	lda.w #$0002
	sta.w facedir,x
	sta.w pfalock,x
	lda.w #SPAwallleft
	sta.b d1
	jsl.l SetSPA
	jml.l SprSort
.nna:
	lda.w #$0004
	sta.w facedir,x
	lda.w #$FFFF
	sta.w newpnum,x
	sta.w newpos,x
	lda.w pflags,x
	and.w #$6FF7
	sta.w pflags,x
	stz.w pfnc,x
	lda.w #$F000
	sta.w Xvel,x
	jml.l assexit
unusedFF87:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
