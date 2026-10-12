puckgoalie:		;The puck hits goalie a2: a save or not, by his save ratings. A hard shot from the blue line area may
		;   slip through; a slow loose puck is held
	lda.w gmode
	bit.w #gmhl		; gmhl
	beq .go
	jmp.w .rtl
.go:
	stz.b d2
	lda.w Zpos+puckobj
	sec
	sbc.w #$0008
	beq .low
	bmi .neg
	bvs .low
	bra .side
.neg:
	bvs .side
.low:		;puck region: +2 when low
	inc.b d2
	inc.b d2
.side:
	lda.b d0		; direction from the goalie to the puck, relative to facedir
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
	jsl.l vtoa
	ldy.b a2
	lda.b d0
	sec
	sbc.w facedir,y
	and.w #$0007
	sta.b d0
	and.w #$0003
	sta.b d1
	bne .lr
	lda.w seed		; straight in front or behind: random side
	sta.b d0
.lr:
	lda.b d0
	and.w #$0004
	lsr a
	lsr a
	eor.w #$0001
	clc
	adc.b d2
	asl a
	sta.b d2
	lda.w GGSleft,y		; save rating for the region: GGSleft, passacc, spodds, endurance
	sta.b d1
	lda.b d2
	beq .odds
	lda.w passacc,y
	sta.b d1
	lda.b d2
	cmp.w #$0002
	beq .odds
	lda.w spodds,y
	sta.b d1
	lda.b d2
	cmp.w #$0004
	beq .odds
	lda.w endurance,y
	sta.b d1
.odds:		;d1 = save rating + 15
	lda.b d1
	clc
	adc.w #$000F
	sta.b d1
	lda.w attribute,y
	bit.w #$0800		; x flip
	beq .noflip
	lda.b d2
	eor.w #$0002
	sta.b d2
.noflip:
	lda.w puckvy
	bit.w #$8000
	beq .hard
	eor.w #$FFFF
	inc a
.hard:		;hard shot from the blue line area may slip through
	cmp.w #$3000		; |puckvy| >= $3000
	bcc .frame
	lda.w carriedy		; shot taken 80..169 from the goal line: 1 in (182-y) slips through
	bit.w #$8000
	beq .dist
	eor.w #$FFFF
	inc a
.dist:
	cmp.w #$0050
	bcc .frame
	cmp.w #$00AA
	bcs .frame
	eor.w #$FFFF
	inc a
	clc
	adc.w #$00B6
	jsl.l randoma
	cmp.w #$0003
	bne .frame
	jmp.w .rtl
.frame:		;goalie in the down frames and the puck on the ice: no save
	lda.w frame,y
	sec
	sbc.w #SPFgdive		; goalie dive frames SPFgdive..+15
	cmp.w #$0010
	bcs .saved
	lda.w Zpos+puckobj
	sec
	sbc.w #$0002
	bmi .neg1
	bvs .saved
.nosave:
	jmp.w .rtl
.neg1:
	bvs .nosave
.saved:
	jsl.l ChkShotStat		; ChkShotStat
	jsl.l a2touchpuck
	lda.w seed+1		; puck body sound (one of 2)
	and.w #$0001
	clc
	adc.w #SFXpuckbody
	pha
	jsl.l sfx
	lda.w puckvy
	bit.w #$8000
	beq .vy
	eor.w #$FFFF
	inc a
.vy:
	cmp.w #$3000
	bcc .nosong
	lda.w #SFXsavehome		; crowd: home save
	pha
	ldy.b a2
	lda.w pfteam,y
	beq .song
	lda.w #SFXsaveaway
	sta.b $01,s
.song:
	jsl.l sfx
.nosong:
	lda.w puckc
	sta.b d2
	bpl .carried
	jmp.w .nopc
.carried:		;carrier loses the puck
	lda.w #$FF00		; puckc high byte = $FF: loose
	tsb.w puckc
	asl.b d2
	lda.b d2
	sta.b a0
	tay
	lda.w #$0014		; old carrier nopuck = 20
	sta.w nopuck,y
	tya
	lsr a
	sta.w lastplayer
	lda.w #sfspdir|sfssdir		; clear sfspdir/sfssdir
	trb.w sflags
.bounce:
	stz.w Zvel,x		; Zvel = 0, nopuck(a2) = 10, temp4(a2) = 4
	ldy.b a2
	lda.w #$000A
	sta.w nopuck,y
	lda.w #$0004
	sta.w temp4,y
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	sta.b d1
	bne .sx
	lda.b a2
	jsl.l GetHot
.sx:
	lda.b d1
	and.w #$00FF
	bit.w #$0080
	beq .sy
	ora.w #$FF00
.sy:
	sta.b d1
	lda.b d1
	beq .away
	inc.b d1
.away:
	ldy.b a2
	lda.w Yvel,y
	eor.b d1
	bmi .0
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.0:
	sep #$20
	lda.b d0
	sta.w Xvel+1,x
	lda.b d1
	sta.w Yvel+1,x
	rep #$20
	jmp.w puckflip
.rtl:
	rtl
.nopc:		;loose puck: the goalie holds it if it is slow enough
	ldy.b a2
	lda.w SPA,y
	cmp.w #SPAgdive		; SPAgdive: always bounce
	beq .bounce
	lda.w #$0002		; catch speed limit = random((2+shotspd)*512) + $C00
	clc
	adc.w shotspd,y
	xba
	and.w #$FF00
	asl a
	jsl.l randoma
	adc.w #$0C00
	sta.b d0
	sec
	sbc.w puckvx
	bmi .neg2
	bvc .c2
.b1:
	jmp.w .bounce
.neg2:
	bvc .b1
.c2:
	lda.b d0
	sec
	sbc.w puckvy
	bmi .neg3
	bvc .c3
.b2:
	jmp.w .bounce
.neg3:
	bvc .b2
.c3:
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	sec
	sbc.w puckvx
	beq .c4
	bmi .neg4
	bvs .c4
.b3:
	jmp.w .bounce
.neg4:
	bvs .b3
.c4:
	lda.b d0
	sec
	sbc.w puckvy
	beq .c5
	bmi .neg5
	bvs .c5
.b4:
	jmp.w .bounce
.neg5:
	bvs .b4
.c5:
	ldy.b a2
	lda.w pflags,y
	bit.w #pf2unav		; pf2unav
	beq .hold
	jmp.w .bounce
.hold:
	stz.w Zvel,x
	jmp.w puckglue		; puckglue: goalie holds the puck
