; The game, screens, menus, password, playoffs.
; Bank $80. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8084C4
getpde:		;get player a3's energy level into d0. Return a2 = his team struct, d1 = pnum*2
		;   SNES: d0 = energy of player X (tmpde of its team, entry pnum)
	lda.w pfteam,x
	beq .0
	lda.w #$0002		; a2 = 2: away team
.0:
	sta.b a2
	lda.w pnum,x
	and.w #$00FF		; pnum low byte
	asl a
	sta.b d1
	lda.b a2
	beq .idx
	lda.w #$0034		; away team entries start $34 bytes in
.idx:
	adc.b d1
	tay
	lda.w tmpde,y
	sta.b d0
rtss:		;the rtl that ends getpde, also used as a do-nothing callback (lda #rtss for skateto)
	rtl

org $809D17
checkpuckcoll:		;look for puck coll with players. a3 = puck. Entered from pucknorm
		;   SNES: puck collision with the players within 22 in y (OOlist up and down from the puck)
	lda.w Zpos+puckobj		; puck feet in the air (Zpos > 16): no collision
	sec
	sbc.w #$0010
	beq .setup
	bmi .v1
	bvs .setup
	bra .rtl
.v1:
	bvs .rtl
.setup:
	lda.w OOlistpos+puckobj		; Y = puck position in OOlist
	sta.b d1
.up:
	ldy.b d1
	cpy.w #$000F		; top object
	beq .cl
	lda.w OOlist+1,y
	and.w #$00FF
	sta.b d4
	tay
	lda.w Ylist,y
	sec
	sbc.w pucky
	sec
	sbc.w #$0016		; next higher object within 22 in y
	beq .cc1
	bmi .v2
	bvs .cc1
	bra .cl
.v2:
	bvs .cl
.cc1:
	jsl.l checkpuckcoll_ccx
	inc.b d1
	bra .up
.cl:
	lda.w OOlistpos+puckobj
	beq .rtl
	sta.b d1
.dn:
	ldy.b d1
	lda.w OOlist-1,y
	and.w #$00FF
	sta.b d4
	tay
	lda.w pucky
	sec
	sbc.w Ylist,y
	sec
	sbc.w #$0016
	beq .cc2
	bmi .v3
	bvs .cc2
	bra .rtl
.v3:
	bvs .rtl
.cc2:
	jsl.l checkpuckcoll_ccx
	dec.b d1
	bne .dn
.rtl:
	rtl
checkpuckcoll_ccx:		;d4 = object index: stick (puckstick), body (puckbody) or goalie (puckgoalie) contact
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .save
	ldx.b xsave
	lda.b d4		; a2 = object
	sta.b a2
	tay
	lsr a
	cmp.w puckc
	bne .pl
	jmp.w .exit
.pl:
	cmp.w #$000C		; not a player
	bcc .nc
	jmp.w .exit
.nc:
	lda.w pfnc,y		; no collision or nopuck
	ora.w nopuck,y
	beq .unav
	jmp.w .exit
.unav:
	lda.w pflags,y
	bit.w #pf2unav		; pf2unav: body only
	beq .z
	jmp.w .chkbody
.z:
	lda.w Zpos+puckobj
	sec
	sbc.w #$0005		; puck above 5
	beq .zv
	bmi .v1
	bvs .zv
.body1:
	jmp.w .chkbody
.v1:
	bvs .body1
.zv:
	lda.w puckvz
	sec
	sbc.w #$0100		; puckvz > $100
	beq .stick
	bmi .v2
	bvs .stick
.body2:
	jmp.w .chkbody
.v2:
	bvs .body2
.stick:
	tya
	jsl.l GetHot
	ldy.b a2
	lda.b d0
	clc
	adc.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	bit.w #$8000
	beq .sx
	eor.w #$FFFF
	inc a
.sx:
	cmp.w #$000F		; stick: within 14
	bcs .chkbody
	lda.b d1
	clc
	adc.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	bit.w #$8000
	beq .sy
	eor.w #$FFFF
	inc a
.sy:
	cmp.w #$000F
	bcs .chkbody
	lda.b d0
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b d0+2
	adc.b mulres+2
	sta.b d0+2
	lda.w #$00C4		; cstick^2 ($C4), /4 if the puck is not ready to be caught
	sta.b d1
	lda.w nopuck+puckobj
	bmi .lo
	beq .lo
	lsr.b d1
	lsr.b d1
.lo:
	lda.b d1
	cmp.b d0
	lda.w #$0000
	sbc.b d0+2
	bcc .chkbody
	jsl.l puckstick
	bra .exit
.chkbody:
	lda.w position,y
	beq .chkgoalie
	lda.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	bit.w #$8000
	beq .bx
	eor.w #$FFFF
	inc a
.bx:
	cmp.w #$0009		; body: within 8
	bcs .exit
	lda.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	bit.w #$8000
	beq .by
	eor.w #$FFFF
	inc a
.by:
	cmp.w #$0009
	bcs .exit
	lda.b d0
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b d0+2
	adc.b mulres+2
	sta.b d0+2
	lda.b d0
	cmp.w #$0041		; cbody^2
	lda.b d0+2
	sbc.w #$0000
	bcs .exit
	jsl.l puckbody
.exit:
	stx.b xsave
	ldx.w #$001A
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
.chkgoalie:
	lda.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	bit.w #$8000
	beq .gx
	eor.w #$FFFF
	inc a
.gx:
	cmp.w #$000D		; goalie: within 12
	bcs .exit
	lda.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	bit.w #$8000
	beq .gy
	eor.w #$FFFF
	inc a
.gy:
	cmp.w #$000D
	bcs .exit
	jsl.l puckgoalie
	bra .exit
puckstick:		;puck collides with stick
		;   SNES: puck hits the stick of player a2. d0 = distance^2 (from checkpuckcoll_ccx)
	ldy.b a2
	lda.w position,y
	bne .0
	lda.w gmode
	bit.w #gmhl		; gmhl: goalie ignores the puck
	beq .0
	jmp.w .rtl
.0:
	lda.w pflags,y
	and.w #~pfdoff&$FFFF		; clear pfdoff
	sta.w pflags,y
	lda.w puckc
	bpl .carried
	jmp.w .nosteal
.carried:
	asl a
	sta.b a0
	tay
	lda.w pfteam,y
	beq .t1
	lda.w #$0001
.t1:
	sta.b tmp0
	ldy.b a2
	lda.w pfteam,y
	beq .t2
	lda.w #$0001
.t2:
	eor.b tmp0
	bne .range
	jmp.w .rtl
.range:
	lda.b d0
	cmp.w #$0025		; 6*6: smaller range for stealing
	lda.b d0+2
	sbc.w #$0000
	bcc .roll
	jmp.w .rtl
.roll:		;steal roll: carrier stickhand - stealer stickhand + 36
	lda.w position,y
	beq .steal		; goalie always steals
	ldy.b a0
	lda.w position,y
	bne .rnd
	jmp.w .rtl
.rnd:
	lda.w stickhand,y
	sta.b d0
	jsl.l makepde
	lda.b d0
	pha
	lda.b a0
	ldy.b a2
	sta.b a2
	sty.b a0
	lda.w stickhand,y
	sta.b d0
	jsl.l makepde
	lda.b a0
	ldy.b a2
	sta.b a2
	sty.b a0
	pla
	sec
	sbc.b d0
	clc
	adc.w #$0024
	jsl.l randoma
	cmp.w #$0003		; steal fails
	bcs .rtl
.steal:
	ldy.b a0
	lda.w stickhand,y
	sta.b d0
	jsl.l makepde
	lda.b d0
	clc
	adc.w #$0014		; nopuck = makepde(stickhand) + 20 for both
	ldy.b a0
	sta.w nopuck,y
	lda.b a0
	ldy.b a2
	sta.b a2
	sty.b a0
	lda.w stickhand,y
	sta.b d0
	jsl.l makepde
	lda.b d0
	clc
	adc.w #$0014
	ldy.b a0
	sta.w nopuck,y
	lda.b a0
	ldy.b a2
	sta.b a2
	sty.b a0
	tya
	lsr a
	sta.w lastplayer		; lastplayer = the old carrier
	lda.w #sfspdir|sfssdir		; clear sfspdir/sfssdir
	trb.w sflags
.stdef:		;stick deflect sound, touch, deflect
	lda.w seed+1		; stick deflect sound (one of 4)
	and.w #$0003
	clc
	adc.w #SFXshotwiff
	pha
	jsl.l sfx
	jsl.l a2touchpuck
	jmp.w deflect		; deflect
.rtl:
	rtl
.nosteal:
	ldy.b a2
	lda.w position,y
	bne .spd
	lda.b d0
	cmp.w #$0041		; goalie: loose puck within 8
	lda.b d0+2
	sbc.w #$0000
	bcs .rtl
.spd:		;catch if the puck speed^2 <= (13000+700*stickhand)^2
	lda.w puckvx
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.w puckvy
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b d0+2
	adc.b mulres+2
	sta.b d0+2
	stz.b d1
	lda.w sflags		; sf2shot: no stickhand bonus
	bit.w #sf2shot
	bne .nohand
	ldy.b a2
	lda.w stickhand,y
	sta.b mulb
	lda.w #$02BC		; * 700
	sta.b mula
	jsl.l mulu16		; mulu, mulres = mula*mulb
	sta.b d1
.nohand:
	lda.b d1
	clc
	adc.w #$32C8		; + 13000
	sta.b mula
	sta.b mulb
	jsl.l mulu		; mulres = mula*mulb
	cmp.b d0
	lda.b mulres+2
	sbc.b d0+2
	bcs puckglue
	ldy.b a2
	lda.w #$0008		; too fast: nopuck 8, deflect
	sta.w nopuck,y
	jmp.w .stdef
puckglue:		;Player a2 takes the puck
		;   SNES: ends in setd0player
	lda.w seed+2		; pickup sound (one of 4)
	and.w #$0003
	clc
	adc.w #SFXshotwiff
	pha
	jsl.l sfx
	ldy.b a2
	tya
	lsr a
	sta.w puckc		; puckc = a2
	sta.b d0
	stz.b a0
	lda.w #$0002
	sta.b a1
	lda.w pfteam,y
	bne .tm
	stz.b a1
	lda.w #$0002
	sta.b a0
.tm:
	ldy.b a0
	lda.w #$FFFF
	sta.w tmtouch2,y		; other team loses its touches
	sta.w tmtouch3,y
	lda.w tmflags,y
	ora.w #tmflast
	sta.w tmflags,y
	lda.w #sf3fo
	trb.w sflags3		; sf3fo: this pickup wins the faceoff
	beq .snd
	ldy.b a1
	lda.w tmfowon,y
	inc a
	sta.w tmfowon,y
	lda.b crowdlevel		; +200
	clc
	adc.w #$00C8
	sta.b crowdlevel
.snd:
	lda.b a2
	lsr a
	sta.b d0
	cmp.w passReceiverPlayerNum		; pass reached its receiver
	bne .nrec
	ldy.b a1
	lda.w tmpasscomp,y
	inc a
	sta.w tmpasscomp,y
.nrec:
	lda.w #$FFFF
	sta.w passReceiverPlayerNum
	lda.w #sfspdir|sfssdir		; clear sfspdir/sfssdir
	trb.w sflags
	ldy.b a2
	lda.w position,y
	beq .goalie
	jml.l setd0player
.goalie:
	jsl.l ChkShotStat		; ChkShotStat (goalie made a save)
	ldy.b a2
	lda.w #$008C		; temp5 = 140, count down for the faceoff
	sta.w temp5,y
	lda.w SPA,y
	cmp.w #SPAgdive
	beq .gdive
	jml.l setd0player
.gdive:
	lda.w #$0005
	sta.w temp5,y
	jml.l setd0player
deflect:		;random puck direction on deflection puck = a3. Entered from puckstick .stdef
		;   SNES: Entered from puckstick .stdef
	lda.w #$FFFF		; puck loose
	sta.w puckc
	lda.w #$1000		; random velocity +-$1000 in y and x, 0..$1000 up
	jsl.l randomd0s
	sta.w puckvy
	lda.w #$1000
	jsl.l randomd0s
	sta.w puckvx
	lda.w #$1000
	jsl.l randoma
	sta.w puckvz
	jmp.w puckflip		; puckflip

org $80A1B4
makepde:		;pass d0 as value to be scaled by player a0's energy level
		;   SNES: d0 = rating A (on entry) scaled by the energy of player a0: A*energy/$1000
	pha
	stx.b xsave
	ldx.w #$0000
.save:		;movem d1/a2-a3
	lda.b d1,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a2,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .savea
	ldx.b xsave
	ldx.b a0		; a3 = a0 for getpde
	stx.b a3
	jsl.l getpde
	stx.b xsave
	ldx.w #$0006
.resta:
	pla
	sta.b a2,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$0002
.restore:
	pla
	sta.b d1,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3
	pla
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l muls32
	asl a		; *16, high word: *energy/$1000
	rol.b mulres+2
	asl a
	rol.b mulres+2
	asl a
	rol.b mulres+2
	asl a
	rol.b mulres+2
	lda.b mulres+2
	sta.b d0
	clc
	rtl
puckbody:		;puck hits player a2. a3 = puck, d0 = distance^2 (from checkpuckcoll .ccx)
		;   SNES: puck (X) hits player a2. d0 = distance^2. A fast high puck knocks a2 down (FallDown), a slower one plays SPAcatch
	lda.w Zpos,x		; puck above 8: always a hit
	sec
	sbc.w #$0008
	beq .low
	bmi .v1
	bvs .low
	bra .hit
.v1:
	bvs .hit
.low:		;low puck: only a hit dead center counts
	lda.b d0
	and.w #$000F
	beq .hit
	jmp.w .rtl
.hit:
	jsl.l a2touchpuck
	lda.w seed		; puck body sound (one of 2)
	and.w #$0001
	clc
	adc.w #SFXpuckbody
	pha
	jsl.l sfx
	stz.w Zvel,x		; Zvel = 0, nopuck(a2) = 8
	ldy.b a2
	lda.w #$0008
	sta.w nopuck,y
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	sta.b d1
	bne .0		; centered: use the hot spot
	tya
	jsl.l GetHot
.0:
	lda.w Xvel,x
	sta.b d2
	lda.w Yvel,x
	sta.b d3
	sep #$20		; puck velocity high bytes = offset
	lda.b d0
	sta.w Xvel+1,x
	lda.b d1
	sta.w Yvel+1,x
	rep #$30
	jsl.l puckflip		; puckflip
	lda.w Zpos,x
	sec
	sbc.w #$0008
	beq .rtl
	bmi .v2
	bvc .high
	bra .rtl
.v2:
	bvc .rtl
.high:		;old speed^2 > $3000^2 and puck above 12: FallDown
	lda.b d2
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d2
	lda.b mulres+2
	sta.b d2+2
	lda.b d3
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d2
	sta.b d2
	lda.b mulres+2
	adc.b d2+2
	sta.b d2+2
	cmp.w #$0900		; $3000^2
	bcc .slow
	lda.w Zpos,x
	sec
	sbc.w #$000C		; Zpos 12
	beq .rtl
	bmi .v3
	bvs .rtl
.fall:
	jmp.w FallDown		; FallDown
.v3:
	bvs .fall
.rtl:
	rtl
.slow:
	ldy.b a2
	lda.w pfalock,y		; pfalock: already in a locked animation
	bne .rtl
	inc a
	sta.w pfalock,y
	lda.w #SPAcatch
	sta.b d1
	ldx.b a2		; exg a2,a3 around SetSPA
	ldy.b a3
	stx.b a3
	sty.b a2
	jsl.l SetSPA
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	rtl
puckgoalie:		;puck hits goalie a2. a3 = puck, d0/d1 = goalie - puck x/y
		;   SNES: puck (X) hits goalie a2. d0/d1 = goalie - puck x/y. Save odds from the four save ratings, no frame odds table
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
	bmi .v1
	bvs .low
	bra .side
.v1:
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
	bmi .v2
	bvs .saved
.nosave:
	jmp.w .rtl
.v2:
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
	bmi .v3
	bvc .c2
.b1:
	jmp.w .bounce
.v3:
	bvc .b1
.c2:
	lda.b d0
	sec
	sbc.w puckvy
	bmi .v4
	bvc .c3
.b2:
	jmp.w .bounce
.v4:
	bvc .b2
.c3:
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	sec
	sbc.w puckvx
	beq .c4
	bmi .v5
	bvs .c4
.b3:
	jmp.w .bounce
.v5:
	bvs .b3
.c4:
	lda.b d0
	sec
	sbc.w puckvy
	beq .c5
	bmi .v6
	bvs .c5
.b4:
	jmp.w .bounce
.v6:
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

org $80B01A
ResetBench:		;remove all players from penalty box/ put all players on their own bench
		;   SNES: empty the penalty boxes / put all players on their own bench. PBnum = players left in the box, home*16 + visitors
	stz.w PBnum
	lda.w #$0010		; home: +$10 per player
	sta.b d1
	stz.b a0
	jsl.l .rb
	lda.w #$0001
	sta.b d1
	lda.w #$0002
	sta.b a0
.rb:		;team a0 (0/2), d1 = PBnum step
	lda.w #$0032		; (MaxRos-1)*2
	sta.b d0
.rb1:
	lda.w PBnum
	clc
	adc.b d1
	sta.w PBnum
	lda.b a0
	beq .idx
	lda.w #$0034
.idx:
	adc.b d0
	tay
	lda.w tmpdst,y
	bmi .nopen		; on the ice or bench
	beq .nopen
	bit.w #TMPDINJ		; TMPDINJ: stays in the box
	beq .next
	and.w #$07FF		; no time left: not counted
	sta.b d2
	bne .next
	lda.w PBnum
	sec
	sbc.b d1
	sta.w PBnum
	bra .next
.nopen:
	lda.w PBnum
	sec
	sbc.b d1
	sta.w PBnum
	lda.w tmpdst,y
	cmp.w #TMPDOUT		; TMPDOUT stays out
	beq .next
	lda.w #TMPDBENCH		; TMPDBENCH
	sta.w tmpdst,y
.next:
	dec.b d0
	dec.b d0
	bpl .rb1
	rtl
forcepldata:		;no skating on/off force players to correct data (for faceoffs only)
		;   SNES: a2 = team. No skating on/off: force the players to their new positions (faceoffs only)
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .savea
	ldx.b xsave
	ldy.b a2
	lda.w tmsort,y
	sta.b a3
	lda.w #$0005
	sta.b d4
.top:
	ldx.b a3
	lda.w newpos,x		; position = newpos (byte)
	and.w #$00FF
	bit.w #$0080
	beq .pos
	ora.w #$FF00
.pos:
	sta.b d0
	sta.w position,x
	cmp.w #$0000
	bmi .next
	jsl.l Setplass
	ldx.b a3
	lda.w position,x
	cmp.w #$0004		; center
	bne .notnear
	lda.w #anearest		; anearest
	sta.b d0
	jsl.l assinsert
.notnear:
	ldx.b a3
	lda.w newpnum,x		; tmpdst of newpnum = TMPDICE: on the ice
	and.w #$00FF
	asl a
	sta.b d3
	lda.b a2
	beq .idx
	lda.w #$0034
.idx:
	adc.b d3
	tay
	lda.w #TMPDICE
	sta.w tmpdst,y
	lsr.b d3
	jsl.l setplayer		; setplayer
.next:
	ldx.b a3
	lda.w #$FFFF		; newpnum = newpos = -1
	sta.w newpnum,x
	sta.w newpos,x
	inc.b a3
	inc.b a3
	dec.b d4
	bpl .top
	stx.b xsave
	ldx.w #$000E
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$0012
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3
	rtl
Setplass:		;set players (a3) initial assignment
		;   SNES: set the initial assignment of player X from its position
	lda.w position,x
	sta.b d0
	bmi .rtl		; no position: no assignment
	lda.w #.alist
	sta.b a0
	lda.w #.alist>>16
	sta.b a0+2
	ldy.b d0
	lda.b [a0],y
	and.w #$00FF
	sta.b d0
	jmp.w assreplace
.rtl:
	rtl
.alist:		;assignment for each position (goalie, LD, RD, LW, C, RW, extra)
	db agoalie,adefd,adefd,awingd,acenterd,awingd,acenterd
setplayer:		;bring player onto the ice and set his stats
		;   SNES: bring roster player d3 (in d3 = $5F) onto the ice as object X and set his stats from the roster record plus the bonuses
	phx
	phy
	lda.w pflags,x		; clear pf2inj
	and.w #~pf2inj&$FFFF
	sta.w pflags,x
	stz.b a0
	lda.w pfteam,x
	beq .0
	inc.b a0
	inc.b a0
.0:
	lda.b d3
	and.w #$00FF
	sta.w pnum,x		; pnum = d3
	asl a
	sta.b d3
	lda.w #aepen		; aepen: from the penalty box
	sta.b d0
	lda.b a0
	beq .idx
	lda.w #$0034
.idx:
	adc.b d3
	tay
	lda.w tmpdst,y
	sta.b d1
	bpl .da
	lda.w #aeben		; aeben: from the bench
	sta.b d0
	lda.b d1
	cmp.w #TMPDBENCH
	bne .nda
.da:
	jsl.l assinsert
	stz.w pfalock,x		; pfalock = 0, SPA = 0
	stz.w SPA,x
.nda:
	lda.b a0
	beq .nda1
	lda.w #$0034
.nda1:
	clc
	adc.b d3
	tay
	lda.w #TMPDICE		; tmpdst = TMPDICE
	sta.w tmpdst,y
	lsr.b d3
	ldy.b a0		; a0 = team data
	lda.w tmdata,y
	sta.b a0
	lda.w #TeamList>>16
	sta.b a0+2
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .savea
	ldx.b xsave
	ldy.w #$0008		; team data + word at +8: bonus bytes
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
	stz.w PPBonus		; all four bonuses = 0
	stz.w PKBonus
	stz.b ThirdPBonus
	stz.w HmAwBonus
	lda.w position,x		; goalie: no modifiers
	bne .mods
	jmp.w .nomod
.mods:
	lda.w sflags
	bit.w #sf2pwrplay		; sf2pwrplay
	beq .nda3
	jsl.l chkpk2
	beq .nda2
	ldy.w #$0001		; power play: PPBonus = low nibble of byte 1
	lda.b [a0],y
	and.w #$000F
	sta.w PPBonus
	bra .nda3
.nda2:
	ldy.w #$0001		; short-handed: PKBonus = -high nibble of byte 1
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	eor.w #$FFFF
	inc a
	sta.w PKBonus
.nda3:
	ldy.w #$0002		; HmAwBonus: home = high nibble of byte 2, visitors = -low nibble
	lda.b [a0],y
	and.w #$000F
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.w pfteam,x
	bne .tm
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	sta.b d0
.tm:
	lda.b d0
	sta.w HmAwBonus
	lda.w gsp		; 3rd period?
	sec
	sbc.w #$0002
	bmi .v1
	bvc .p3
	bra .nomod
.v1:
	bvc .nomod
.p3:
	beq .half
	bmi .v2
	bvs .half
	bra .score
.v2:
	bvs .score
.half:
	jsl.l GetPeriodTime		; GetPeriodTime
	lsr.b d0
	lda.b d0
	sec
	sbc.w gameclock
	beq .score
	bmi .v3
	bvs .score
	bra .nomod
.v3:
	bvs .nomod
.score:
	lda.w tmscore		; tied or trailing: ThirdPBonus = 2
	sec
	sbc.w tmscore+2
	sta.b tmp0
	beq .close
	lda.w pfteam,x
	beq .side
	lda.b tmp0
	eor.w #$FFFF
	inc a
	sta.b tmp0
.side:
	lda.b tmp0
	bpl .nomod
.close:
	lda.w #$0002
	sta.b ThirdPBonus
.nomod:
	stx.b xsave
	ldx.w #$0002
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	ldy.w #$0000		; a0 = roster records
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
.find:		;skip the roster records before player d3
	lda.b [a0]
	clc
	adc.b a0
	adc.w #$0008
	sta.b a0
	dec.b d3
	bpl .find
	lda.b a0
	sec
	sbc.w #$0008
	sta.b a0
	lda.b [a0]		; byte 0: rostnum
	and.w #$00FF
	sta.w rostnum,x
	ldy.w #$0001		; byte 1: weight (high nibble*8), legstr
	lda.b [a0],y
	and.w #$00F0
	lsr a
	sta.w weight,x
	lda.b [a0],y
	and.w #$000F
	sta.w legstr,x
	iny		; byte 2: legspd, aioff
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	sta.w legspd,x
	lda.b [a0],y
	and.w #$000F
	clc
	adc.w PPBonus
	clc
	adc.w PKBonus
	clc
	adc.w HmAwBonus
	clc
	adc.b ThirdPBonus
	jsl.l ClampNibble
	eor.w #$000F		; frames to skip: (15-n+15)/2
	clc
	adc.w #$000F
	lsr a
	sta.w aioff,x
	iny		; byte 3: aidef, shotspd
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	clc
	adc.w HmAwBonus
	jsl.l ClampNibble
	eor.w #$000F
	clc
	adc.w #$000F
	lsr a
	sta.w aidef,x
	lda.b [a0],y
	and.w #$000F
	sta.w shotspd,x
	lda.w attribute,x		; clear the x flip
	and.w #~attrxflip&$FFFF
	sta.w attribute,x
	iny		; byte 4: aggress, handed, fightagg
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	clc
	adc.b ThirdPBonus
	jsl.l ClampNibble
	sta.w aggress,x
	lda.b [a0],y
	and.w #$0001		; bit 0 set: left handed
	sta.w handed,x
	bne .ha
	lda.w attribute,x
	ora.w #attrxflip
	sta.w attribute,x
.ha:
	lda.b [a0],y
	and.w #$000E
	sta.w fightagg,x
	iny		; byte 5: stickhand, shotacc
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	clc
	adc.w PPBonus
	clc
	adc.w PKBonus
	clc
	adc.w HmAwBonus
	jsl.l ClampNibble
	sta.w stickhand,x
	lda.b [a0],y
	and.w #$000F
	clc
	adc.w PPBonus
	clc
	adc.w PKBonus
	clc
	adc.w HmAwBonus
	jsl.l ClampNibble
	sta.w shotacc,x
	iny		; byte 6: endurance, spodds
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	sta.w endurance,x
	lda.b [a0],y
	and.w #$000F
	clc
	adc.b ThirdPBonus
	clc
	adc.b ThirdPBonus
	jsl.l ClampNibble
	sta.w spodds,x
	iny		; byte 7: passacc, GGSleft
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	clc
	adc.w PPBonus
	clc
	adc.w HmAwBonus
	jsl.l ClampNibble
	sta.w passacc,x
	lda.b [a0],y
	and.w #$000F
	sta.w GGSleft,x
	ply
	plx
	rtl
ClampNibble:		;clamp byte d3 to 0-15. Called by setplayer
		;   SNES: clamp A to 0-15
	bit.w #$0080		; negative: 0
	beq .hi
	lda.w #$0000
.hi:
	cmp.w #$000F
	bcc .x
	lda.w #$000F
.x:
	rtl
resetplstuff:		;reset team variables/and players on both teams. Called from puckfaceoff2 and StartHL2
		;   SNES: reset team variables and the players on both teams
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .savea
	ldx.b xsave
	stz.b a2
	jsl.l .top
	lda.w #$0002
	sta.b a2
	jsl.l .top
	stx.b xsave
	ldx.w #$000E
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$000A
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3
	rtl
.top:		;team a2
	ldy.b a2
	lda.w tmflags,y
	and.w #~tmfoffside&$FFFF		; clear tmfoffside
	sta.w tmflags,y
	lda.w #$0005
	sta.b d2
	ldx.w tmsort,y
	stx.b a3
.loop:
	stz.w pf2fight,x		; pf2fight = pf2aip = 0, pflags2 bits cleared
	stz.w pf2aip,x
	lda.w pflags,x
	and.w #~(pf2unav|pf2lcm|pf2pen|pf2npc)&$FFFF
	sta.w pflags,x
	lda.w position,x
	bmi .next
	lda.w #SPAglide
	sta.b d1
	jsl.l SetSPA
	stz.w impact,x		; impact = 0, nopuck = 0
	stz.w nopuck,x
	lda.w pflags,x
	and.w #~(pfdoff|pfjoycon)&$FFFF		; keep pfteam/pfgoal/pfna: clear pfdoff, pfjoycon
	sta.w pflags,x
	stz.w pfnc,x
	stz.w pfrev,x
	stz.w pfalock,x
.next:
	inc.b a3
	inc.b a3
	ldx.b a3
	dec.b d2
	bpl .loop
	rtl

org $80B4C1
setupice:		;set all variables, send non purgeable graphics, build sprite frame lists for ice rink.
		;   SNES: set all variables, send the rink and text graphics to vram, palettes, video mode, team colors
	jsl.l forceblack		; setvram role
	lda.w #$0207		; vram tile bases of the text layer
	sta.w faceoffvrcset
	clc
	adc.w #$0037
	sta.w unusedchars
	adc.w #$000E
	sta.w refcharshor
	adc.w #$0068
	sta.w refchars
	adc.w #$0075
	sta.w blankchar
	inc a
	sta.w smallfontchars
	adc.w #$0064
	sta.w Framercset
	adc.w #$0004
	sta.w BigFontChars
	adc.w #$0090
	sta.w scorechars
	adc.w #$0195
	sta.w ExtraChars
	lda.w #$FF00		; charofs = $FF00
	sta.w charofs
	stz.w charofs+2
	jsl.l InitPPU		; PPU init: PPU registers off/clear, sound driver start
	sep #$20
	cli
	lda.w RDNMI
	lda.b #NMITIMEN_NMI|NMITIMEN_JOY		; NMI on, auto joypad read
	sta.w NMITIMEN
	lda.b #$03		; OBSEL: 8x8/16x16 sprites at $6000
	sta.w OBSEL
	lda.b #BGMODE_1		; BGMODE 1
	sta.w BGMODE
	lda.b #$00
	sta.w BG1SC
	lda.b #$05		; BG2 map at $0400, 64x32
	sta.w BG2SC
	lda.b #$12		; BG1 tiles $2000, BG2 tiles $1000
	sta.w BG12NBA
	lda.b #TM_BG1|TM_BG2|TM_OBJ		; TM: BG1, BG2, sprites
	sta.w TM
	rep #$30
	ldx.w #$00FE
.pal:		;rink palette to both halves of palbuffer
	lda.l RinkPalette,x
	sta.l palbuffer,x
	sta.l palbuffer+$100,x
	dex
	dex
	bpl .pal
	jsl.l sndqreset		; sound queue reset
	lda.w sndbank		; in-game sound set not loaded yet: load it
	cmp.w #$0001
	beq .gfx
	jsl.l SPCGameUpload
.gfx:		;decompress each tile set to $7F0000 and send it to vram
	lda.w #IceRinkTiles		; packed rink tiles
	sta.b tmp0
	lda.w #IceRinkTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	lda.w #$1000		; vram $1000
	sta.w VMADDL
	ldx.w #$0000
.up1:
	lda.l unpackbuf,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$40E0
	bne .up1
	lda.w #FaceOffTiles		; packed faceoff box tiles
	sta.b tmp0
	lda.w #FaceOffTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$0000
.up2:
	lda.l unpackbuf,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$06E0
	bne .up2
	lda.w #RinkLogoTiles		; packed rink logo tiles
	sta.b tmp0
	lda.w #RinkLogoTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$0000
.up3:
	lda.l unpackbuf,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$01C0
	bne .up3
	lda.w #RefTilesHor		; packed ref window tiles, horizontal rink
	sta.b tmp0
	lda.w #RefTilesHor>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$0000
.up4:
	lda.l unpackbuf,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0D00
	bne .up4
	lda.w #RefTiles		; packed ref window tiles, vertical rink
	sta.b tmp0
	lda.w #RefTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$0000
.up5:
	lda.l unpackbuf,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0EA0
	bne .up5
	ldx.w #$0010
.blank:		;blank tile
	stz.w VMDATAL
	dex
	bne .blank
	lda.w #SmallFontTiles		; packed small font tiles
	sta.b tmp0
	lda.w #SmallFontTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	stz.b a0		; sprite frame list from the $7F0000 data
	lda.w #unpackbuf>>16
	sta.b a0+2
	lda.w #PixelRemap83
	sta.b a1
	lda.w #PixelRemap83>>16
	sta.b a1+2
	lda.w #$0064
	sta.b d0
	jsl.l RemapTiles		; build a sprite frame list ([a0] data, [a1] table, d0 count)
	lda.w #FramerTiles
	sta.b a0
	lda.w #FramerTiles>>16
	sta.b a0+2
	lda.w #PixelRemap87
	sta.b a1
	lda.w #PixelRemap87>>16
	sta.b a1+2
	lda.w #$0004
	sta.b d0
	jsl.l RemapTiles		; build a sprite frame list ([a0] data, [a1] table, d0 count)
	lda.w #BigFontTiles		; packed big font tiles
	sta.b tmp0
	lda.w #BigFontTiles>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	stz.b a0
	lda.w #unpackbuf>>16
	sta.b a0+2
	lda.w #PixelRemap8D
	sta.b a1
	lda.w #PixelRemap8D>>16
	sta.b a1+2
	lda.w #$0090
	sta.b d0
	jsl.l RemapTiles		; build a sprite frame list ([a0] data, [a1] table, d0 count)
	lda.w #999		; Oldrow = 999, no pause, Hpos = Vpos = 0
	sta.w Oldrow
	lda.w #$0001
	trb.w sflags
	stz.w Hpos
	stz.w Vpos
	lda.b vcount+2		; vcountmark well in the past
	dec a
	dec a
	sta.w vcountmark+2
	jsl.l InitSortObjects
	stz.w zamx
	jsl.l nullrtl
	lda.w gmode
	bit.w #gmdir		; gmdir
	beq .gok
	ldx.w #$0016
.l01:		;gmdir: flip pfgoal of the 12 players
	lda.w pfgoal,x
	eor.w #$0001
	sta.w pfgoal,x
	dex
	dex
	bpl .l01
.gok:
	jsl.l setplayercolors
	lda.w #$FFFF		; PadControlBits = $FFFF, padcont = 0
	sta.w PadControlBits
	stz.w padcont
	stz.w padcont+2
	stz.w padcont+4
	stz.w padcont+6
	lda.w #$FFFF		; c1playernum = c2playernum = -1
	sta.w c1playernum
	sta.w c2playernum
	stz.b brightness		; brightness 0, fade in after 10 frames
	lda.w #$000A
	sta.b fadein
	rtl
setplayercolors:		;copy in correct color data for each team. Called from setupice, setupice_highlight, StartHL2
		;   SNES: team colors into palbuffer, then the whole palette to CGRAM
	stz.w ffoframe+6		; pad 3 frame = 0
	stz.w colorflag1
	stz.w colorflag2
	jsl.l SetTeamColors
	lda.w #DMA_CGRAM		; whole CGRAM from palbuffer
	sta.w DMAP7
	lda.w #palbuffer
	sta.w A1T7L
	lda.w #$0200
	sta.w DAS7L
	sep #$20
	stz.w CGADD
	lda.b #palbuffer>>16
	sta.w A1B7
	lda.b #MDMAEN_CH7
	sta.w MDMAEN
	rep #$30
	rtl
SetTeamColors:		;convert both teams' Genesis colors (team data +2) to SNES colors in palbuffer (BG and sprite halves)
	phx
	phy
	ldx.w #$0000
	lda.w tmdata		; home team colors: palbuffer+$40
	sta.b tmp0
	lda.w #TeamList>>16
	sta.b tmp1
	stz.b tmp2+1
	jsl.l SetTeamColors_team
	lda.w tmdata+2		; away team colors: palbuffer+$60
	sta.b tmp0
	lda.w #$0020
	sta.b tmp2+1
	jsl.l SetTeamColors_team
	ply
	plx
	rtl
SetTeamColors_team:		;one team: tmp0 = team data, tmp2+1 = palbuffer offset
	ldy.w #$0002		; team data + word at +2: palette
	lda.b [tmp0],y
	clc
	adc.b tmp2+1
	tay
	lda.w #$0010
	sta.b tmp2+1
.col:		;0BGR (4 bits) -> 0BBBBBGGGGGRRRRR
	lda.b [tmp0],y
	xba
	and.w #$000F
	asl a
	sta.b tmp1+1
	lda.b [tmp0],y
	xba
	and.w #$00F0
	asl a
	asl a
	ora.b tmp1+1
	sta.b tmp1+1
	lda.b [tmp0],y
	xba
	and.w #$0F00
	asl a
	asl a
	asl a
	ora.b tmp1+1
	sta.l palbuffer+$40,x
	sta.l palbuffer+$140,x
	inx
	inx
	iny
	iny
	dec.b tmp2+1
	bne .col
	rtl
nullrtl:		;does nothing (setupice calls it)
	rtl
SprSort:		;sort objects in struct SortObj and set corresponding tables for keeping them sorted later
		;   SNES: sort the objects by y (x in horizontal mode) into OOlist/OOlistpos
	phx
	phy
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .save
	ldx.b xsave
	ldx.w #$0000
	lda.w sfhormode		; horizontal mode sorts by x
	bne .xlist
.loop0:
	lda.w Ypos,x
	sta.w Ylist,x
	inx
	inx
	cpx.w #$0020
	bne .loop0
	bra .loop
.xlist:
	lda.w Xpos,x
	sta.w Ylist,x
	inx
	inx
	cpx.w #$0020
	bne .xlist
.loop:
	stz.b d2
	ldx.w #$0000
.0:
	lda.w OOlist+1,x
	and.w #$00FF
	sta.b d1
	lda.w OOlist,x
	and.w #$00FF
	sta.b d0
	tay
	lda.w Ylist,y
	ldy.b d1
	sec
	sbc.w Ylist,y
	beq .1
	bmi .v1
	bvc .swap
	bra .1
.v1:
	bvc .1
.swap:
	lda.w OOlist,x
	xba
	sta.w OOlist,x
	txa
	sta.w OOlistpos,y
	inc a
	ldy.b d0
	sta.w OOlistpos,y
	inc.b d2
.1:
	inx
	cpx.w #$000F
	bne .0
	lda.b d2		; swapped: sort again
	bne .loop
	stx.b xsave
	ldx.w #$000A
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ply
	plx
	rtl
DoGameFrame:		;wait for at least one vblank, then run one frame of game logic
		;   SNES: one frame of game logic (d7 = elapsed frames, set by the caller)
	jsl.l periodicevents		; periodicevents
	jsl.l updateplayers		; updateplayers
	jsl.l checkwindow		; checkwindow
	jsl.l updatereplay		; updatereplay
	jmp.w setvideo
periodicevents:		;called every time thru game loop with d7 = elapsed frames
		;   SNES: every game loop; once a second (lldisp) the slower checks
	jsl.l PenaltyManager		; PenaltyManager
	jsl.l updatecrowdf		; updatecrowdf
	jsl.l updatesound		; updatesound
	jsl.l clockcont		; clockcont
	lda.w sfhormode		; horizontal: no screen updates
	bne .rtl
	lda.w lldisp
	sec
	sbc.b d7
	sta.w lldisp
	bpl .rtl
	clc
	adc.w #$0018		; +$18 frames
	sta.w lldisp
	jsl.l ChkGoalies		; ChkGoalies
	jsl.l UpdateCwdExcite		; UpdateCwdExcite
	jsl.l CheckLateGameSong		; CheckLateGameSong
	jsl.l RestoreBenchEnergy		; RestoreBenchEnergy
	jsl.l CheckInjury		; CheckInjury
	jmp.w updatepwrplay
.rtl:
	rtl

org $80BB5A
setpersonel:		;this will set personel on team a2 according to team a2's registers
		;   SNES: set the personel of team a2 from SetPlList: keep the players already on the ice, place the rest
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0018
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .savea
	ldx.b xsave
	ldy.b a2
	ldx.w tmsort,y
	stx.b a3
	lda.w #$0005
	sta.b d4
.l0:
	lda.w #$FFFF		; newpos = newpnum = -1 for the 6 objects
	sta.w newpos,x
	sta.w newpnum,x
	inx
	inx
	stx.b a3
	dec.b d4
	bpl .l0
	jsl.l SetPlList
	lda.w #$0005
	sta.b d4
	lda.w #PlList		; a4 = PlList
	sta.b a4
	lda.w #PlList>>16
	sta.b a4+2
.1:		;wanted players already on the ice keep their object
	ldy.b d4
	lda.b [a4],y
	and.w #$00FF
	sta.b d5
	beq .next
	dec.b d5
	lda.w #$0005
	sta.b d3
	ldy.b a2
	ldx.w tmsort,y
	dex
	dex
.2:
	inx
	inx
	stx.b a3
	lda.w pnum,x
	and.w #$00FF
	sta.b tmp0
	lda.b d5
	and.w #$00FF
	cmp.b tmp0
	beq .found
	dec.b d3
	bpl .2
	bra .next
.found:
	lda.b d4
	clc
	adc.w #$0006
	tay
	lda.b [a4],y
	and.w #$00FF
	bit.w #$0080
	beq .np
	ora.w #$FF00
.np:
	sta.w newpos,x
	lda.b d5
	and.w #$00FF
	bit.w #$0080
	beq .npn
	ora.w #$FF00
.npn:
	sta.w newpnum,x
	ldy.b d4
	sep #$20
	lda.b #$00
	sta.b [a4],y
	rep #$20
.next:
	dec.b d4
	bpl .1
	lda.w #$0005
	sta.b d4
	lda.w #PlList
	sta.b a4
	lda.w #PlList>>16
	sta.b a4+2
.3:		;the rest go to objects with no requested player
	ldy.b d4
	lda.b [a4],y
	and.w #$00FF
	sta.b d5
	beq .next2
	dec.b d5
	lda.w #$0005
	sta.b d3
	ldy.b a2
	ldx.w tmsort,y
	dex
	dex
.4:
	inx
	inx
	stx.b a3
	lda.w newpnum,x
	bit.w #$0080
	bne .free
	dec.b d3
	bpl .4
	bra .chkpos
.free:
	stx.b a0
.chkpos:
	lda.w position,x
	bpl .put
	dec.b d3
	bpl .4
.put:
	lda.b d4
	clc
	adc.w #$0006
	tay
	lda.b [a4],y
	and.w #$00FF
	bit.w #$0080
	beq .np2
	ora.w #$FF00
.np2:
	ldy.b a0
	sta.w newpos,y
	lda.b d5
	and.w #$00FF
	bit.w #$0080
	beq .npn2
	ora.w #$FF00
.npn2:
	sta.w newpnum,y
	ldy.b d4
	sep #$20
	lda.b #$00
	sta.b [a4],y
	rep #$20
.next2:
	dec.b d4
	bpl .3
	stx.b xsave
	ldx.w #$0012
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$0016
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3
	rtl
SetPlList:		;create list (PlList) of players who we want on the ice now
		;   SNES: make PlList, the players we want on the ice now (team a2)
	lda.w #PlList
	sta.b a4
	lda.w #PlList>>16
	sta.b a4+2
	lda.w #$0000
	sta.b [a4]
	ldy.w #$0002
	sta.b [a4],y
	ldy.w #$0004
	sta.b [a4],y
	lda.w #priolist		; priolist
	sta.b a0
	lda.w #priolist>>16
	sta.b a0+2
	ldy.b a2
	lda.w tmgoalie,y
	bpl .gin		; no goalie: skip the priolist goalie entry
	inc.b a0
.gin:
	lda.w tmdata,y		; line sets: team data + word at +6, + tmline*8
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	ldy.w #LineSets
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	ldy.b a2
	lda.w tmline,y
	asl a
	asl a
	asl a
	sta.b d0
	adc.b a1
	sta.b a1
	lda.w tmap,y		; tmap: players on ice
	sta.b d4
	bra .next
.0:
	ldy.b d4
	lda.b [a0],y
	and.w #$00FF
	sta.b d5
	tay
	sep #$20
	lda.b [a1],y
	ldy.b d4
	sta.b [a4],y
	iny
	iny
	iny
	iny
	iny
	iny
	lda.b d5
	sta.b [a4],y
	rep #$20
	lda.b d5
	bne .next
	ldy.b a2		; goalie: 1 + tmgoalie
	lda.w tmgoalie,y
	inc a
	sta.b d3
	ldy.b d4
	sep #$20
	lda.b d3
	sta.b [a4],y
	rep #$20
.next:
	dec.b d4
	bpl .0
	lda.w #$0005
	sta.b d4
.1:		;is each wanted player available?
	ldy.b d4
	lda.b [a4],y
	and.w #$00FF
	sta.b d3
	beq .next1
	and.w #$00FF
	bit.w #$0080
	beq .p
	ora.w #$FF00
.p:
	dec a
	asl a
	sta.b d3
	lda.b a2
	beq .idx
	lda.w #$0034
.idx:
	clc
	adc.b d3
	tay
	lda.w tmpdst,y
	cmp.w #TMPDOUT		; TMPDOUT: substitute
	beq .sub
	lda.w tmpdst,y
	bmi .next1		; bench or ice: ok
	beq .next1
.sub:		;not available: find a player of a similar position (sublist)
	ldy.b a2
	lda.w tmdata,y
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	ldy.w #LineSets
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	lda.b d4
	clc
	adc.w #$0006
	tay
	lda.b [a4],y
	and.w #$00FF
	asl a
	sta.b d0
	lda.w #sublist		; sublist (word offsets)
	sta.b a0
	lda.w #sublist>>16
	sta.b a0+2
	ldy.b d0
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
.s1:
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .all
	ldy.b d0
	lda.b [a1],y
	and.w #$00FF
	sta.b d0
	jsl.l TryAddPlayerToList
	beq .s1
.next1:
	dec.b d4
	bmi .rtl
	jmp.w .1
.rtl:
	rtl
.all:		;try every roster player, last first
	jsl.l GetPlayerCount		; GetPlayerCount
	lda.b d0
	sta.b d3
.try:
	lda.b d3
	sta.b d0
	dec.b d3
	bmi .next1
	jsl.l TryAddPlayerToList
	beq .try
	bra .next1
TryAddPlayerToList:		;used by SetPlList. d0 = player number (1 based), d4 = PlList slot
		;   SNES: d0 = roster player (1 based), d4 = PlList slot. A = d1 = player if added, 0 (Z set) if not available
	lda.b d0
	sta.b d1
	dec.b d0
	asl.b d0
	lda.b a2
	beq .idx
	lda.w #$0034
.idx:
	adc.b d0
	tay
	lda.w tmpdst,y
	sec
	sbc.w #$0000
	beq .chk
	bmi .v1
	bvs .chk
	bra .no
.v1:
	bvs .no
.chk:
	lda.w tmpdst,y
	cmp.w #TMPDOUT		; TMPDOUT: not available
	beq .no
	lda.w #$0005
	sta.b d0
.s2:
	ldy.b d0
	lda.b [a4],y
	and.w #$00FF
	sta.b tmp0
	lda.b d1
	and.w #$00FF
	cmp.b tmp0
	beq .no		; already in PlList
	dec.b d0
	bpl .s2
	ldy.b d4
	sep #$20
	lda.b d1
	sta.b [a4],y
	rep #$20
	lda.b d1
	and.w #$00FF
	rtl
.no:
	lda.w #$0000
	sta.b d1
	rtl

org $80BED1
updatecrowdf:		;this is called every game loop with d7 = elapsed frames
		;   SNES: every game loop (d7 = elapsed frames): crowd level decay and the crowd animation frame
	lda.b crowdlevel
	sec
	sbc.w #$015E		; 350
	bmi .v1
	bvc .loud
	bra .dec
.v1:
	bvc .dec
.loud:
	dec.b crowdlevel		; loud crowd calms down faster
	dec.b crowdlevel
	dec.b crowdlevel
.dec:
	lda.b crowdlevel
	sec
	sbc.b d7
	sta.b crowdlevel
	bpl .0
	stz.b crowdlevel
.0:
	lda.b crowdcnt
	sec
	sbc.b d7
	sta.b crowdcnt
	bpl .cf
	lda.b crowdlevel
	lsr a
	sta.b d0
	cmp.w #$0080
	bcc .1
	lda.w #$007F
	sta.b d0
.1:
	lda.b d0
	and.w #$0060		; %01100000
	sta.b d0
	lda.b crowdstep
	inc a
	inc a
	and.w #$001E		; %00011110
	sta.b crowdstep
	clc
	adc.b d0
	sta.b d0
	tay
	lda.w #cd0		; cd0: frame high byte, time low byte
	sta.b a0
	lda.w #cd0>>16
	sta.b a0+2
	lda.b [a0],y
	xba
	sep #$20
	sta.b crowdframe+1
	rep #$20
	lda.b [a0],y
	and.w #$00FF
	sta.b d1
	lda.w seed		; random 0..time
	and.b d1
	sta.b d2
	clc
	adc.b d1
	sta.b d1
	sta.b crowdcnt
.cf:		;random extra frame 19-25 when the crowd is loud
	sep #$20
	stz.b crowdframe
	rep #$30
	lda.b crowdlevel
	cmp.w #$0119		; 280
	bcc .rtl
	lda.w seed
	and.w #$007F
	cmp.w #$0013
	bcc .rtl
	cmp.w #$001A
	bcs .rtl
	sep #$20
	sta.b crowdframe
	rep #$30
.rtl:
	rtl
PenaltyList:		;penalty number = word offset into this table. Used by AddPenalty, the penalty box and stats
	dw $0000		; 0
	dw .eop-PenaltyList		; $02 period over
	dw .eog-PenaltyList		; $04 game over
	dw .faceoff-PenaltyList		; $06 out of play
	dw .faceoff-PenaltyList		; $08 goalie holding
	dw .whistle-PenaltyList		; $0A whistle
	dw .ice-PenaltyList		; $0C icing
	dw .goal-PenaltyList		; $0E goal
	dw .offsides-PenaltyList		; $10 offsides
	dw .rough2-PenaltyList		; $12 roughing, slow down time $A
	dw .p14-PenaltyList		; $14 no text
	dw .charge-PenaltyList		; $16 charging
	dw .slash-PenaltyList		; $18 slashing
	dw .rough-PenaltyList		; $1A roughing
	dw .cross-PenaltyList		; $1C cross check
	dw .hook-PenaltyList		; $1E hooking
	dw .trip-PenaltyList		; $20 tripping
	dw .int-PenaltyList		; $22 interference
	dw .hold-PenaltyList		; $24 holding
	dw .fight-PenaltyList		; $26 fighting
	dw .fight2-PenaltyList		; $28 fighting *
	dw .inst-PenaltyList		; $2A fight instigator
	dw .delay-PenaltyList		; $2C delay
;format: dw $ttmm (tt = slow down time in half secs, mm = penalty min.); string (length word counting itself, text)
;then dw $ffdd,... (ff = frame, dd = delay; negative ends)
.eop:		;period over
	dw $0100
	dw 13
	db "Period Over"
	dw -$0510
.eog:		;game over
	dw $0100
	dw 11
	db "Game Over"
	dw $0510,-$4030
.goal:		;goal
	dw $0100
	dw 2
	dw $050A,-$4010
.p14:		;no text
	dw $0100
	dw 2
	dw $0510,-$4018
.ice:		;icing
	dw $0100
	dw 7
	db "Icing"
	dw $0002,$0101,-$0206
.offsides:		;offsides
	dw $0100
	dw 10
	db "Off-side"
	dw $0002,$0301,-$040F
.faceoff:		;face off (PenOOP, PenGhold)
	dw $0100
	dw 10
	db "Face Off"
	dw -$050A
.delay:		;delay
	dw $0000
	dw 9
	db "Penalty"
	dw $0003,$0301,-$040F
.whistle:		;whistle
	dw $0000
	dw 2
	dw -$050A
.charge:		;charging
	dw $0402
	dw 10
	db "Charging"
	dw $0004,$0101,$0A01,$0B01,$0A01,$0B01,$0A01,$0B01,$0A01,$0B01,-$0101
.slash:		;slashing
	dw $0402
	dw 10
	db "Slashing"
	dw $0004,$0101,$0201,$0301,$0201,$0301,$0201,$0301,$0201,$0301,-$0101
.trip:		;tripping
	dw $0402
	dw 10
	db "Tripping"
	dw $0004,$0401,$0501,$0401,$0501,$0401,$0501,$0401,$0501,-$0101
.rough2:		;roughing, slow down time $A
	dw $0A02
	dw 10
	db "Roughing"
	dw $0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
.rough:		;roughing
	dw $0402
	dw 10
	db "Roughing"
	dw $0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
.hook:		;hooking
	dw $0402
	dw 9
	db "Hooking"
	dw $0004,$0101,$0901,$0801,$0901,$0801,$0901,$0801,$0901,$0801,-$0101
.cross:		;cross check
	dw $0402
	dw 13
	db "Cross Check"
	dw $0004,$0601,$0F01,$1001,$0F01,$1001,$0F01,$1001,$0F01,$1001,-$0101
.int:		;interference
	dw $0402
	dw 14
	db "Interference"
	dw $0004,$0101,$0C06,-$0101
.hold:		;holding
	dw $0402
	dw 9
	db "Holding"
	dw $0004,$0101,$0706,-$0101
.fight:		;fighting
	dw $2805
	dw 10
	db "Fighting"
	dw $0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
.fight2:		;fighting *
	dw $2805
	dw 12
	db "Fighting *"
	dw $0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
.inst:		;fight instigator
	dw $2802
	dw 18
	db "Fight Instigator"
	dw $0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101

org $80C278
freezewindow:		;lock scrolling to current position
		;   SNES: lock scrolling at the current position
	lda.w Vpos		; yc1 = Vpos, xc1 = Hpos, sfslock
	sta.w yc1
	lda.w Hpos
	sta.w xc1
	lda.w #sfslock
	tsb.w sflags
	rtl

org $80C2B4
updatereplay:		;called every frame to save replay events, d7 = elapsed frames
		;   SNES: save this frame into the replay buffer (positions, frames, players, puck, sound, pads, crowd, gloves, box, scroll)
	lda.w gmode
	bit.w #gmhl		; gmhl: no recording
	beq .rec
	jmp.w .rtl
.rec:
	lda.w sflags
	bit.w #sf2drec		; sf2drec: keep overwriting the same frame
	bne .frame
	lda.w ReplayBufferPtr		; next record (113 bytes)
	clc
	adc.w #$0071
	sta.w ReplayBufferPtr
	bcc .wrap
	inc.w ReplayBufferPtr+2
.wrap:
	cmp.w #ReplayBufferEnd&$FFFF
	bne .frame
	lda.w ReplayBufferPtr+2
	cmp.w #ReplayBufferEnd>>16
	bne .frame
	lda.w #sfwrap		; wrapped: sfwrap, back to the start
	tsb.w sflags
	lda.w #ReplayBufferStart&$FFFF
	sta.w ReplayBufferPtr
	lda.w #ReplayBufferStart>>16
	sta.w ReplayBufferPtr+2
.frame:
	lda.w ReplayBufferPtr
	sta.b a0
	lda.w ReplayBufferPtr+2
	sta.b a0+2
	lda.w #$000F
	sta.b d2
	ldx.w #$0000
	ldy.w #$0001
.top:		;16 objects: x (12 bits) and y (12 bits), frame and flip bits
	lda.w #$0000
	sta.b [a0]
	sta.b [a0],y
	lda.w Xpos,x
	and.w #$0FFF
	sta.b [a0]
	inc.b a0
	lda.w Ypos,x
	asl a
	asl a
	asl a
	asl a
	ora.b [a0]
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w frame,x
	and.w #$3FFF
	sta.b [a0]
	lda.w attribute,x
	and.w #$1800
	asl a
	asl a
	asl a
	ora.b [a0]
	sta.b [a0]
	inc.b a0
	inc.b a0
	inx
	inx
	dec.b d2
	bpl .top
	lda.w #$0005
	sta.b d2
	ldx.w #$0000
.pl:		;6 pairs: rostnum, positions
	lda.w rostnum,x
	sta.b [a0]
	inc.b a0
	lda.w rostnum+2,x
	sta.b [a0]
	inc.b a0
	lda.w position,x
	bpl .n0
	lda.w #$FFFF
.n0:
	and.w #$000F
	sta.b [a0]
	lda.w position+2,x
	bpl .n1
	lda.w #$FFFF
.n1:
	asl a
	asl a
	asl a
	asl a
	ora.b [a0]
	sta.b [a0]
	inc.b a0
	inx
	inx
	inx
	inx
	dec.b d2
	bpl .pl
	lda.w Zpos+puckobj		; puck and shadow height, lastsfx, d7, PadControlBits, crowdframe, glovecords, PBnum, Hpos, Vpos
	sta.b [a0]
	inc.b a0
	lda.w Zpos+$1E
	sta.b [a0]
	inc.b a0
	lda.w lastsfx
	sta.b [a0]
	inc.b a0
	stz.w lastsfx
	lda.b d7
	sta.b [a0]
	inc.b a0
	lda.w PadControlBits
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.b crowdframe
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w glovecords
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w PBnum
	sta.b [a0]
	inc.b a0
	lda.w Hpos
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w Vpos
	sta.b [a0]
.rtl:
	rtl
demoread:		;monitor joystick if in demo mode (called every game loop)
		;   SNES: in demo mode (no controller team), Start pauses and any other button ends the demo
	lda.w cont1team		; a controller team: not a demo
	ora.w cont2team
	bne .rtl
	jsl.l Readjoy1
	lda.b d1
	bit.w #JOYSTART		; Start on pad 1: startpause1
	beq .any1
	jml.l startpause1
.any1:
	lda.b d1
	bne .exit
	jsl.l Readjoy2
	lda.b d1
	bit.w #JOYSTART		; Start on pad 2: startpause2
	beq .any2
	jml.l startpause2
.any2:
	lda.b d1
	bne .exit
.rtl:
	rtl
.exit:		;end the demo: back to the title screen
	jsl.l sndqreset		; sound queue reset; on to the title screen
	jml.l Opening		; on to the title screen

org $80C46D
updateplayers:		;animation, velocity, position, input and the assignment for every sort object
	ldx.w #$0016		; 12 players
.spd:		;pspeed = max($1000, (|Xvel|+|Yvel|)*5/4) for the 12 players
	lda.w Xvel,x
	bit.w #$8000
	beq .vx
	eor.w #$FFFF
	inc a
.vx:
	sta.b tmp0
	lda.w Yvel,x
	bit.w #$8000
	beq .vy
	eor.w #$FFFF
	inc a
.vy:
	clc
	adc.b tmp0
	sta.b tmp0
	lsr a
	lsr a
	adc.b tmp0
	cmp.w #$1000
	bcs .setspd
	lda.w #$1000
.setspd:
	sta.w pspeed,x
	dex
	dex
	bpl .spd
	lda.w sfhormode		; vertical rink: PadControlBits |= $F
	bne .scload
	lda.w #$000F
	tsb.w PadControlBits
.scload:
	ldx.w #$0000
	stx.b a3
.top:		;each object: old position = position
	lda.w Xpos,x
	sta.w OldXpos,x
	lda.w Xfrac,x
	sta.w OldXfrac,x
	lda.w Ypos,x
	sta.w OldYpos,x
	lda.w Yfrac,x
	sta.w OldYfrac,x
	lda.w Zpos,x
	sta.w OldZpos,x
	lda.w Zfrac,x
	sta.w OldZfrac,x
	lda.w position,x		; not on the ice
	bpl .onice
	jmp.w .nf1
.onice:
	jsl.l updateanim		; updateanim
	lda.w nopuck,x		; nopuck, nopuckb count down
	sec
	sbc.b d7
	bpl .np
	lda.w #$0000
.np:
	sta.w nopuck,x
	lda.w nopuckb,x
	sec
	sbc.b d7
	bpl .np2
	lda.w #$0000
.np2:
	sta.w nopuckb,x
	lda.w sflags3		; sflags3 bit 5: count frames on ice (loadTeamStruct)
	bit.w #sf3icetime
	beq .vel
	lda.w pnum,x
	and.w #$00FF
	bit.w #$0080
	beq .pn
	ora.w #$FF00
.pn:
	sta.b d0
	cmp.w #$0000
	bmi .vel
	asl.b d0
	jsl.l loadTeamStruct
.vel:
	lda.w SPA,x
	cmp.w #SPAinjury1		; SPAinjury1: no movement
	bne .slow
	jmp.w .done
.slow:
	lda.w Zpos,x		; on the ice: decelerate
	bne .x2
	ldx.b d7
.hang:		;d7 >= 10: hang
	cpx.w #$000A
	bcs .hang
	lda.l .decel-1,x		; per-frame factor
	and.w #$00FF
	sta.b d2
	lda.l .decel2-1,x
	sta.b d2+2
	ldx.b a3
	lda.w pflags,x
	bit.w #pfdoff		; pfdoff: less deceleration
	beq .off
	lda.b d2+2
	and.w #$00FF
	sta.b d2
.off:
	lda.w Xvel,x
	sta.b mula
	lda.b d2
	sta.b mulb
	jsl.l muls32
	lda.b mulres+1		; velocity = velocity * factor / 256
	sta.w Xvel,x
	lda.w Yvel,x
	sta.b mula
	lda.b d2
	sta.b mulb
	jsl.l muls32
	lda.b mulres+1
	sta.w Yvel,x
.x2:		;Xpos += Xvel*velstep (/4 in horizontal mode except in the penalty box)
	lda.w Xvel,x
	beq .y2
	sta.b mula
	lda.b velstep
	sta.b mulb
	lda.w sfhormode
	beq .x3
	txa
	asl a
	asl a
	adc.w assnum,x
	tay
	lda.w asslist,y
	and.w #$00FF
	cmp.w #apenalty		; apenalty: full speed
	beq .x3
	lsr.b mulb
	lsr.b mulb
.x3:
	jsl.l muls32
	adc.w Xfrac,x
	sta.w Xfrac,x
	lda.w Xpos,x
	adc.b mulres+2
	sta.w Xpos,x
.y2:
	lda.w Yvel,x
	beq .z
	sta.b mula
	lda.b velstep
	sta.b mulb
	lda.w sfhormode
	beq .y3
	txa
	asl a
	asl a
	adc.w assnum,x
	tay
	lda.w asslist,y
	and.w #$00FF
	cmp.w #apenalty
	beq .y3
	lsr.b mulb
	lsr.b mulb
.y3:
	jsl.l muls32
	adc.w Yfrac,x
	sta.w Yfrac,x
	lda.w Ypos,x
	adc.b mulres+2
	sta.w Ypos,x
.z:		;height: gravity and the bounce off the ice
	lda.w Zpos,x
	bmi .done
	bne .z1
	lda.w Zvel,x
	beq .done
.z1:
	lda.b velstep
	sta.b mula
	lda.w Zvel,x		; Zvel -= gravstep
	sec
	sbc.b gravstep
	sta.w Zvel,x
	sta.b mulb
	jsl.l muls32
	adc.w Zfrac,x
	sta.w Zfrac,x
	lda.w Zpos,x
	adc.b mulres+2
	sta.w Zpos,x
	bpl .done
	stz.w Zpos,x		; bounce off the ice: Zvel = -Zvel/2
	stz.w Zfrac,x
	lda.w Zvel,x
	eor.w #$FFFF
	inc a
	lsr a
	sta.w Zvel,x
	sec
	sbc.w #$0200		; bounce sound when Zvel >= $200
	bmi .v1
	bvc .bsnd
	bra .done
.v1:
	bvc .done
.bsnd:
	lda.w seed
	and.w #$0003
	clc
	adc.w #SFXshotwiff
	pha
	jsl.l sfx
.done:
	txa
	lsr a
	sta.b d6
	cmp.w puckc		; puck carrier (not fighting, vertical): setpads
	bne .tp
	lda.w pf2fight,x
	bne .tp
	lda.w sfhormode
	bne .tp
	lda.w #-2		; d4 = -2: pad index of the puck carrier
	sta.b d4
	jsl.l setpads
.tp:
	lda.b d6
	cmp.w c1playernum		; controller 1 player: doinput
	bne .t0
	jsl.l Readjoy1
	stz.b d4
	jsl.l doinput
	bra .t1
.decel:		;deceleration factor /256 per d7 (1-10): normal
	db $F7,$F5,$F2,$EF,$EC,$E9,$E6,$E3,$E1,$DE
.decel2:		;with pfdoff
	db $FF,$FF,$FE,$FE,$FE,$FD,$FD,$FD,$FC,$FC
.t0:
	cmp.w c2playernum
	bne .t1
	jsl.l Readjoy2
	lda.w #$0002
	sta.b d4
	jsl.l doinput
.t1:		;call the assignment through asstab and jmlvector
	lda.w pfalock,x
	bne .cc
	txa
	asl a
	asl a
	adc.w assnum,x
	tay
	lda.w asslist,y		; current assignment
	and.w #$00FF
.hang2:
	cmp.w #$001D		; bad assignment: hang
	bcs .hang2
	asl a
	asl a
	tax
	lda.l asstab,x		; asstab entry into jmlvector
	sta.w jmlvector+1
	lda.l asstab+1,x
	sta.w jmlvector+2
	ldx.b a3
	jsl.l loadTeamStruct		; loadTeamStruct, then the assignment
	jsl.l jmlvector
.cc:
	lda.w Ypos,x
	sta.b d3
	stz.w Wallcos,x		; Wallcos = Wallsin = 0
	stz.w Wallsin,x
	lda.w Xpos,x
	sta.b d2
	cmp.w OldXpos,x
	bne .moved
	lda.b d3
	cmp.w OldYpos,x
	bne .moved
	jmp.w .nf
.moved:		;moved at least 1 pixel: checkcoll
	jsl.l checkcoll
	cpx.w #$0018		; only players
	bcs .nf
	lda.w position,x
	beq .nf
	lda.w pflags,x
	and.w #pf2npc		; pf2npc or horizontal: no goal check
	ora.w sfhormode
	bne .nf
	lda.w Xpos,x
	bit.w #$8000
	beq .ax
	eor.w #$FFFF
	inc a
.ax:
	cmp.w #$0019		; |x| < 25
	bcs .nf
	lda.w Ypos,x
	bit.w #$8000
	beq .ay
	eor.w #$FFFF
	inc a
.ay:
	sec
	sbc.w #$010D		; crossing y = +-269 (the goal line)?
	sta.b tmp0
	lda.w OldYpos,x
	bit.w #$8000
	beq .oy
	eor.w #$FFFF
	inc a
.oy:
	sec
	sbc.w #$010D
	eor.b tmp0
	bmi .back
	lda.w Ypos,x
	bit.w #$8000
	beq .gl
	eor.w #$FFFF
	inc a
.gl:
	cmp.w #$0103		; 259 <= |y| < 279
	bcc .nf
	cmp.w #$0117
	bcs .nf
.back:		;do not skate into the goal: old position
	lda.w OldXpos,x
	sta.w Xpos,x
	lda.w OldYpos,x
	sta.w Ypos,x
.nf:		;impact decays; limpact = impact
	lda.w impact,x
	sec
	sbc.b impactstep
	bpl .nf1
	lda.w #$0000
.nf1:
	sta.w impact,x
	sta.w limpact,x
	lda.w frame,x		; frames $173-$178: x kept within +-$60
	cmp.w #$0173
	bcc .next
	cmp.w #$0179
	bcs .next
	lda.w Xpos,x
	sec
	sbc.w #$FFA0
	beq .cl1
	bmi .v2
	bvs .cl1
	bra .cx
.v2:
	bvs .cx
.cl1:
	lda.w #$FFA0
	sta.w Xpos,x
.cx:
	lda.w Xpos,x
	sec
	sbc.w #$0060
	bmi .v3
	bvc .cl2
	bra .next
.v3:
	bvc .next
.cl2:
	lda.w #$0060
	sta.w Xpos,x
.next:
	inx
	inx
	stx.b a3
	cpx.w #$0020		; all 16 objects
	beq .lim
	jmp.w .top
.lim:		;players faster than pspeed are slowed to it
	ldx.w #$0016
.lim1:
	lda.w Xvel,x
	bit.w #$8000
	beq .lvx
	eor.w #$FFFF
	inc a
.lvx:
	sta.b tmp0
	lda.w Yvel,x
	bit.w #$8000
	beq .lvy
	eor.w #$FFFF
	inc a
.lvy:
	clc
	adc.b tmp0
	cmp.w pspeed,x
	bcc .lnext
	sta.b tmp0
	lda.w Xvel,x
	sta.b mula
	lda.w pspeed,x
	sta.b mulb
	jsl.l muls32
	lda.b tmp0
	sta.b mula
	jsl.l divs
	sta.w Xvel,x
	lda.w Yvel,x
	sta.b mula
	lda.w pspeed,x
	sta.b mulb
	jsl.l muls32
	lda.b tmp0
	sta.b mula
	jsl.l divs
	sta.w Yvel,x
.lnext:
	dex
	dex
	bpl .lim1
	lda.w Zpos+puckobj		; puck below 24: keep it inside the boards
	cmp.w #$0018
	bcs .py
	lda.w puckx
	sec
	sbc.w #$FF78		; x >= -$88
	bmi .v4
	bvs .px1
	bra .px2
.v4:
	bvs .px2
.px1:
	lda.w #$FF78
	sta.w puckx
.px2:
	lda.w puckx
	sec
	sbc.w #$0088		; x <= $88
	beq .py
	bmi .v5
	bvc .px3
	bra .py
.v5:
	bvc .py
.px3:
	lda.w #$0088
	sta.w puckx
.py:		;puck on the ice within |y| < 318: keep it inside the boards
	lda.w Zpos+puckobj
	bne .cy
	lda.w pucky
	bit.w #$8000
	beq .py1
	eor.w #$FFFF
	inc a
.py1:
	cmp.w #$013E
	bcs .cy
	lda.w pucky
	sec
	sbc.w #$FEDB		; y >= -$125
	bmi .v6
	bvs .py2
	bra .py3
.v6:
	bvs .py3
.py2:
	lda.w #$FEDB
	sta.w pucky
.py3:
	lda.w pucky
	sec
	sbc.w #$012A		; y <= $12A
	beq .cy
	bmi .v7
	bvc .py4
	bra .cy
.v7:
	bvc .cy
.py4:
	lda.w #$012A
	sta.w pucky
.cy:		;carried: carriedy = pucky
	lda.w puckc
	bmi .rtl
	lda.w pucky
	sta.w carriedy
.rtl:
	rtl
checkcoll:		;d2 = new x cord, d3 = new y cord, a3 = struct of object. Check wall collision (around the hot spot and the end of the stick) and player collisions, then move a3 in the OOlist sort order by its y. If a player collision set collflag, restore the old x/y instead. Does not clear Wallcos/Wallsin first. Called from updateplayers
		;   SNES: d2/d3 = new x/y of object X. Wall collision (hot spot, end of the stick), player collision, then keep OOlist sorted
	stz.b collflag		; collflag = 0
	lda.w sfhormode		; horizontal: exg d2,d3
	beq .nhor1
	lda.b d2
	ldy.b d3
	sta.b d3
	sty.b d2
.nhor1:
	lda.w pfnc,x		; pfnc: no collision
	beq .go
	jmp.w .ex
.go:		;movem d0-d6
	lda.b d6+2
	pha
	lda.b d6
	pha
	lda.b d5+2
	pha
	lda.b d5
	pha
	lda.b d4+2
	pha
	lda.b d4
	pha
	lda.b d3+2
	pha
	lda.b d3
	pha
	lda.b d2+2
	pha
	lda.b d2
	pha
	lda.b d1+2
	pha
	lda.b d1
	pha
	lda.b d0+2
	pha
	lda.b d0
	pha
	lda.w Xpos,x		; around the hot spot with the wall
	sta.b d2
	lda.w Ypos,x
	sta.b d3
	lda.w radiusx,x
	sta.w wcradiusx
	lda.w radiusy,x
	sta.w wcradiusy
	jsl.l checkwallcoll
	lda.w Wallcos,x		; wall hit: done
	ora.w Wallsin,x
	bne .xx
	cpx.w #$0018		; only players: the end of the stick
	bcs .xx
	lda.b $01,s
	sta.b d0
	lda.b $03,s
	sta.b d0+2
	lda.b $05,s
	sta.b d1
	lda.b $07,s
	sta.b d1+2
	lda.b $09,s
	sta.b d2
	lda.b $0B,s
	sta.b d2+2
	lda.b $0D,s
	sta.b d3
	lda.b $0F,s
	sta.b d3+2
	lda.b $11,s
	sta.b d4
	lda.b $13,s
	sta.b d4+2
	lda.b $15,s
	sta.b d5
	lda.b $17,s
	sta.b d5+2
	lda.b $19,s
	sta.b d6
	lda.b $1B,s
	sta.b d6+2
	txa
	jsl.l GetHot		; GetHot
	lda.w Xpos,x
	clc
	adc.b d0
	sta.b d2
	lda.w Ypos,x
	clc
	adc.b d1
	sta.b d3
	lda.w #$0001		; radius 1
	sta.w wcradiusx
	sta.w wcradiusy
	jsl.l checkwallcoll
.xx:
	pla
	sta.b d0
	pla
	sta.b d0+2
	pla
	sta.b d1
	pla
	sta.b d1+2
	pla
	sta.b d2
	pla
	sta.b d2+2
	pla
	sta.b d3
	pla
	sta.b d3+2
	pla
	sta.b d4
	pla
	sta.b d4+2
	pla
	sta.b d5
	pla
	sta.b d5+2
	pla
	sta.b d6
	pla
	sta.b d6+2
	jsl.l checkplcoll		; checkplcoll
.ex:
	lda.b collflag		; collflag: restore the old position
	beq .sort
	jmp.w .restoreold
.sort:
	lda.w OOlistpos,x		; move up/down OOlist by y
	sta.b d1
.2:
	ldy.b d1
	cpy.w #$000F
	beq .cl2
	lda.w OOlist+1,y
	and.w #$00FF
	sta.b d4
	tay
	lda.b d3
	sec
	sbc.w Ylist,y
	beq .cl2
	bmi .v1
	bvc .swapup
	bra .cl2
.v1:
	bvc .cl2
.swapup:
	inc.w OOlistpos,x
	lda.w OOlistpos,y
	dec a
	sta.w OOlistpos,y
	sep #$30
	ldy.b d1
	lda.b d4
	sta.w OOlist,y
	txa
	sta.w OOlist+1,y
	rep #$30
	inc.b d1
	bra .2
.cl2:
	lda.w OOlistpos,x
	beq .ex2
	sta.b d1
.3:
	ldy.b d1
	lda.w OOlist-1,y
	and.w #$00FF
	sta.b d4
	tay
	lda.b d3
	sec
	sbc.w Ylist,y
	bmi .v2
	bvs .swapdn
	bra .ex2
.v2:
	bvs .ex2
.swapdn:
	dec.w OOlistpos,x
	lda.w OOlistpos,y
	inc a
	sta.w OOlistpos,y
	sep #$30
	ldy.b d1
	lda.b d4
	sta.w OOlist,y
	txa
	sta.w OOlist-1,y
	rep #$30
	dec.b d1
	bne .3
.ex2:
	lda.b d3
	sta.w Ylist,x
	rtl
.restoreold:
	lda.w OldXpos,x
	sta.w Xpos,x
	lda.w OldYpos,x
	sta.w Ypos,x
	rtl
checkwallcoll:		;d2/d3 = x/y to test, a3 = object, wcradiusx/wcradiusy = radius. Called from checkcoll
		;   SNES: d2/d3 = x/y, object X, wcradiusx/y. Corner circles, goals, then side and end boards
	lda.w #$012A		; d3 = $12A - wcradiusy, d2 = $88 - wcradiusx; corner centers 64 in
	sec
	sbc.w wcradiusy
	pha
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0040
	sta.b d5
	lda.w #$0088
	sec
	sbc.w wcradiusx
	pha
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0040
	sta.b d4
	lda.b d3
	pha
	ldy.b d2
	phy
	sec
	sbc.b d5
	beq .negy
	bmi .v1
	bvs .negy
	bra .ctc
.v1:
	bvs .ctc
.negy:
	lda.b d2
	sec
	sbc.b d4
	bmi .v2
	bvc .gl1
	bra .circle
.v2:
	bvc .circle
.gl1:
	lda.b d4
	eor.w #$FFFF
	inc a
	sta.b d4
	sec
	sbc.b d2
	bmi .v3
	bvc .goal13
	bra .circle
.v3:
	bvc .circle
.goal13:		;goal at the -y end (object 13)
	lda.w #$001A
	sta.b a2
	jsl.l checkgoal
	jmp.w .exit
.ctc:
	lda.b d5
	eor.w #$FFFF
	inc a
	sta.b d5
	sec
	sbc.b d3
	beq .c2
	bmi .v4
	bvs .c2
.exit1:
	jmp.w .exit
.v4:
	bvs .exit1
.c2:
	lda.b d2
	sec
	sbc.b d4
	bmi .v5
	bvc .c3
	bra .circle
.v5:
	bvc .circle
.c3:
	lda.b d4
	eor.w #$FFFF
	inc a
	sta.b d4
	sec
	sbc.b d2
	bmi .v6
	bvc .goal12
	bra .circle
.v6:
	bvc .circle
.goal12:		;goal at the +y end (object 12)
	lda.w #$0018
	sta.b a2
	jsl.l checkgoal
	jmp.w .exit
.circle:		;distance from the corner center (max+min/4)
	lda.b d2
	sec
	sbc.b d4
	sta.b d2
	eor.w #$FFFF
	inc a
	sta.b d1
	bit.w #$8000
	beq .dx
	eor.w #$FFFF
	inc a
.dx:
	sta.b mula
	lda.b d3
	sec
	sbc.b d5
	sta.b d0
	bit.w #$8000
	beq .dy
	eor.w #$FFFF
	inc a
.dy:
	sta.b mulb
	cmp.b mula
	bcc .m2
	lda.b mula
	lsr a
	lsr a
	adc.b mulb
	bra .dist
.m2:
	lsr a
	lsr a
	adc.b mula
.dist:
	cmp.w #$0041		; inside the radius 64 circle: no hit
	bcc .exit
	sta.b d3		; cos = dy*256/r, sin = dx*256/r
	sta.b mula
	stz.b mulb
	stz.b mulb+2
	lda.b d0
	sta.b mulb+1
	bpl .cos
	lda.w #$FFFF
	sta.b mulb+3
.cos:
	jsl.l divs
	sta.b d0
	lda.b d3
	sta.b mula
	stz.b mulb
	stz.b mulb+2
	lda.b d1
	sta.b mulb+1
	bpl .sin
	lda.w #$FFFF
	sta.b mulb+3
.sin:
	jsl.l divs
	sta.b d1
	jsl.l wallcollb
.exit:		;no corner hit: the side and end boards
	pla
	sta.b d2
	pla
	sta.b d3
	pla
	sta.b d4
	pla
	sta.b d5
	lda.w Wallcos,x		; corner hit: done
	ora.w Wallsin,x
	bne .rtl
	lda.w #$0100		; side walls: cos $100, sin 0
	sta.b d0
	stz.b d1
	lda.b d3
	sec
	sbc.b d5
	bmi .v7
	bvs .s1
.b1:
	jmp.w wallcollb
.v7:
	bvs .b1
.s1:
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d5
	eor.w #$FFFF
	inc a
	sta.b d5
	sec
	sbc.b d3
	bmi .v8
	bvs .s2
.b2:
	jmp.w wallcollb
.v8:
	bvs .b2
.s2:
	lda.b d0
	pha
	lda.b d1
	sta.b d0
	pla
	sta.b d1
	lda.b d2
	sec
	sbc.b d4
	bmi .v9
	bvs .s3
.b3:
	jmp.w wallcollb
.v9:
	bvs .b3
.s3:
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
	lda.b d4
	eor.w #$FFFF
	inc a
	sta.b d4
	sec
	sbc.b d2
	bmi .v10
	bvs .rtl
.b4:
	jmp.w wallcollb
.v10:
	bvs .b4
.rtl:
	rtl

org $80CC1E
wallcollb:		;check for puck over wall. a3 = object, d0/d1 = cos/sin of the wall. Called from checkwallcoll
		;   SNES: object X hits a wall (d0/d1 = cos/sin). The puck may go over the glass; otherwise wallcoll
	cpx.w #$001C		; not the puck: wallcoll
	beq .puck
	jmp.w wallcoll
.puck:
	lda.w Zpos+puckobj
	sec
	sbc.w #$0020		; Zpos > 32: over
	beq .z1
	bmi .v1
	bvs .z1
	bra .0
.v1:
	bvs .0
.z1:
	lda.w Zpos+puckobj
	cmp.w #$0016		; Zpos <= 21: wallcoll
	bcs .y280
	jmp.w wallcoll
.y280:
	lda.w pucky
	sec
	sbc.w #$0112		; y >= 274
	bmi .v2
	bvc .x13
	bra .0
.v2:
	bvc .0
.x13:
	lda.w puckx
	sec
	sbc.w #$000D		; x 13-15 (the goal mouth)
	bmi .v3
	bvc .x15
.wc1:
	jmp.w wallcoll
.v3:
	bvc .wc1
.x15:
	lda.w puckx
	sec
	sbc.w #$000F
	beq .vy
	bmi .v4
	bvs .vy
	bra wallcoll
.v4:
	bvs wallcoll
.vy:
	lda.w puckvy
	sec
	sbc.w #$0FA0		; Yvel >= $FA0
	bmi .v5
	bvc .glass
	bra wallcoll
.v5:
	bvc wallcoll
.glass:		;over the glass at the goal: shadow animation, sound, crowd
	phx
	lda.w puckvy		; halve puckvy
	pha
	asl a
	pla
	ror a
	sta.w puckvy
	inx
	inx
	stx.b a3
	lda.w #SPAbglass		; object 15 (shadow): SPAbglass
	sta.b d1
	jsl.l SetSPA
	plx
	stx.b a3
	lda.w #SFXoverglass		; over the glass sound
	pha
	jsl.l sfx
	lda.b crowdlevel		; crowd +600
	clc
	adc.w #$0258
	sta.b crowdlevel
.0:		;puck out of play
	lda.w #sfslock		; sfslock; puck pfnc
	tsb.w sflags
	sta.w pfnc+puckobj
	lda.w pucky		; bottom: y flip
	bpl .1
	lda.w #$8000
	tsb.w attribute+puckobj
.1:
	stz.w frame+$1E		; shadow frame 0
	lda.w gmclock		; clock stopped
	bne .rtl
	lda.w ltplayer		; penalty 6 for the last touch player
	asl a
	sta.b a3
	tax
	lda.w #PenOOP
	sta.b d0
	jsl.l AddPenalty2
	ldx.w #$001C
	stx.b a3
.rtl:
	rtl
wallcoll:		;d0 = cosine, d1 = sine of angle of incidence with wall, a3 = object. Called from checkgoal, checkgoalp, wallcollb
		;   SNES: d0/d1 = cos/sin of the wall; bounce object X: puck loses speed, flips, sound; players sound on a hard hit
	lda.b d0		; Wallcos/Wallsin
	sta.w Wallcos,x
	lda.b d1
	sta.w Wallsin,x
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d2,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .save
	ldx.b xsave
	lda.b d1		; v1n = (Yvel*cos - Xvel*sin)/256, negated; v1t = (Xvel*cos + Yvel*sin)/256
	pha
	lda.b d0
	pha
	sta.b mulb
	lda.w Yvel,x
	sta.b mula
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.w Xvel,x
	sta.b mula
	lda.b d1
	sta.b mulb
	jsl.l muls32
	lda.b d0
	sec
	sbc.b mulres
	sta.b d0
	lda.b d0+2
	sbc.b mulres+2
	sta.b d0+2
	lda.b d0+1
	eor.w #$FFFF
	inc a
	sta.b d2
	lda.w Xvel,x
	sta.b mula
	lda.b $01,s
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.w Yvel,x
	sta.b mula
	lda.b d1
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b d0+2
	adc.b mulres+2
	sta.b d0+2
	lda.b d0+1
	sta.b d3
	cpx.w #$001C
	beq .puck
	jmp.w .player
.puck:
	lda.w #sf2shot		; puck: clear sf2shot
	trb.w sflags
	lda.b d2		; moving away from the wall
	bmi .pn
	jmp.w .nocoll
.pn:
	lsr a		; normal speed /4
	lsr a
	bit.w #$2000
	beq .pn1
	ora.w #$C000
.pn1:
	sta.b d2
	sec
	sbc.w #$FC00		; hard hit (v1n <= -$400): pop up, flip, sound by speed
	beq .hard
	bmi .v1
	bvs .hard
	bra .pok
.v1:
	bvs .pok
.hard:
	lda.w #$0800
	jsl.l randoma
	eor.w #$FFFF
	inc a
	sta.w puckvz
	sta.b d0
	jsl.l puckflip
	lda.w #SFXpuckwall1
	pha
	lda.b d2
	sec
	sbc.w #$EE00
	bmi .v2
	bvc .s2
	bra .snd
.v2:
	bvc .snd
.s2:
	pla
	lda.w #SFXpuckwall1+1
	pha
	lda.b d2
	sec
	sbc.w #$F800
	bmi .v3
	bvc .s3
	bra .snd
.v3:
	bvc .snd
.s3:
	pla
	lda.w #SFXpuckwall1+2
	pha
.snd:
	jsl.l sfx
.pok:		;reduce the tangent speed of the puck
	lda.b d3
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0200
	beq .t1
	ora.w #$FC00
.t1:
	sta.b d0
	pha
	asl a
	pla
	ror a
	sta.b d0+2
	lda.b d3
	sec
	sbc.b d0
	sec
	sbc.b d0+2
	sta.b d3
	bra .noadd
.player:
	lda.b d2
	sec
	sbc.w #$03E8		; player: v1n > 1000: no collision
	beq .p1
	bmi .v4
	bvs .p1
.nocoll1:
	jmp.w .nocoll
.v4:
	bvs .nocoll1
.p1:
	lda.b d2
	sec
	sbc.w #$F000		; v1n <= -$1000 and impact >= 10: board sound
	beq .imp
	bmi .v5
	bvs .imp
	bra .nosfx
.v5:
	bvs .nosfx
.imp:
	lda.w impact,x
	sec
	sbc.w #$000A
	bmi .v6
	bvc .psnd
	bra .nosfx
.v6:
	bvc .nosfx
.psnd:
	lda.w seed+1
	and.w #$0001
	clc
	adc.w #SFXplayerwall
	pha
	jsl.l sfx
.nosfx:
	lda.b d2
	lsr a
	lsr a
	bit.w #$2000
	beq .n1
	ora.w #$C000
.n1:
	sta.b d2
	sec
	sbc.w #$FC7C		; v1n >= -900: -1000
	bmi .v7
	bvc .min
	bra .noadd
.v7:
	bvc .noadd
.min:
	lda.w #$FC18
	sta.b d2
.noadd:		;rotate back: new Xvel/Yvel
	lda.b $01,s
	sta.b mula
	lda.b d3
	sta.b mulb
	jsl.l muls32
	sta.b tmp0
	lda.b mulres+2
	sta.b tmp1
	lda.b $03,s
	sta.b mula
	lda.b d2
	sta.b mulb
	jsl.l muls32
	lda.b tmp0
	sec
	sbc.b mulres
	sta.b tmp0
	lda.b tmp1
	sbc.b mulres+2
	sta.b tmp1
	lda.b tmp0+1
	sta.w Xvel,x
	lda.b $03,s
	sta.b mula
	lda.b d3
	sta.b mulb
	jsl.l muls32
	sta.b d3
	lda.b mulres+2
	sta.b d3+2
	lda.b $01,s
	sta.b mula
	lda.b d2
	sta.b mulb
	jsl.l muls32
	adc.b d3
	sta.b d3
	lda.b d3+2
	adc.b mulres+2
	sta.b d3+2
	lda.b d3+1
	sta.w Yvel,x
	lda.w Zvel,x		; moving up: Zvel = 0
	bmi .nocoll
	stz.w Zvel,x
.nocoll:
	pla
	pla
	stx.b xsave
	ldx.w #$0006
.restore:
	pla
	sta.b d2,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl

org $80CEE7
checkgoal:		;look for coll with goal/net. a2 = goal struct, a3 = object, d2/d3 = x/y. Called from checkwallcoll
		;   SNES: collision with the goal/net. a2 = goal object, X = object, d2/d3 = x/y. Not the puck: checkgoalp. Puck in the goal area: over the top
		;   (Zvel), through the mouth (Goal), off a post (deflect) or off the side/back (wallcoll)
	lda.w Zpos,x		; Zpos > 13 (goal height): over the goal
	sec
	sbc.w #$000D
	beq .z
	bmi .v1
	bvs .z
.ex1:
	jmp.w .rtl
.v1:
	bvs .ex1
.z:
	cpx.w #puckobj		; not the puck: checkgoalp
	beq .puck
	jmp.w checkgoalp
.puck:		;puck: inside |dx| <= 16+wcradiusx and |dy| <= 4+wcradiusy?
	ldy.b a2		; d2 = x - goal x
	lda.w #$0010
	clc
	adc.w wcradiusx
	sta.b d4
	lda.b d2
	sec
	sbc.w Xpos,y
	sta.b d2
	sec
	sbc.b d4
	beq .xl
	bmi .v2
	bvs .xl
.ex2:
	jmp.w .rtl
.v2:
	bvs .ex2
.xl:
	lda.b d4
	eor.w #$FFFF
	inc a
	sta.b d4
	lda.b d2
	sec
	sbc.b d4
	bmi .v3
	bvc .yh
.ex3:
	jmp.w .rtl
.v3:
	bvc .ex3
.yh:
	lda.w #$0004
	clc
	adc.w wcradiusy
	sta.b d5
	lda.b d3
	sec
	sbc.w Ypos,y
	sta.b d3
	sec
	sbc.b d5
	beq .yl
	bmi .v4
	bvs .yl
.ex4:
	jmp.w .rtl
.v4:
	bvs .ex4
.yl:
	lda.b d5
	eor.w #$FFFF
	inc a
	sta.b d5
	lda.b d3
	sec
	sbc.b d5
	bmi .v5
	bvc .inside
.ex5:
	jmp.w .rtl
.v5:
	bvc .ex5
.inside:		;inside the goal area now
	lda.w #$FFFF		; collflag
	sta.b collflag
	lda.w OldZpos+puckobj
	sec
	sbc.w #$000D
	bmi .v6
	bvc .over
	bra .nod
.v6:
	bvc .nod
.over:		;OldZpos >= 13: came over the top
	lda.w OldZpos+puckobj
	sta.w Zpos+puckobj
	jmp.w .deflectz
.nod:		;pfgoal of the puck = the carrier shot into his own goal
	stz.w pfgoal+puckobj
	lda.w puckc		; carrier: loses the puck, nopuck 8
	bmi .nocon
	asl a
	tay
	lda.w #$FFFF
	sta.w puckc
	lda.w #$0008
	sta.w nopuck,y
	lda.w pucky
	sta.b d1
	lda.w pfgoal,y
	bne .an
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.an:
	lda.b d1
	bpl .nocon
	lda.w #$0001
	sta.w pfgoal+puckobj
.nocon:		;d0 = -256 (top entry: +256)
	lda.w #$FF00		; d1 = (Ypos - OldYpos) >> 8
	sta.b d0
	lda.w Yfrac,x
	sec
	sbc.w OldYfrac,x
	sta.b d1
	lda.w Ypos,x
	sbc.w OldYpos,x
	sta.b d1+2
	lda.b d1+1
	sta.b d1
	bne .dy
	jmp.w .sideentry
.dy:
	bmi .0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d5
	eor.w #$FFFF
	inc a
	sta.b d5
.0:		;d5 = dy at entry; d2 -= dx*dy/vy: x where the puck crossed the goal line
	lda.b d5
	clc
	adc.b d3
	sta.b d5
	sta.b mulb
	lda.w Xfrac,x		; d3 = (Xpos - OldXpos) >> 8; d5*d3
	sec
	sbc.w OldXfrac,x
	sta.b d3
	lda.w Xpos,x
	sbc.w OldXpos,x
	sta.b d3+2
	lda.b d3+1
	sta.b d3
	sta.b mula
	jsl.l muls32
	lda.b d1		; |d5*d3| < |d1|? else side entry
	bit.w #$8000
	beq .m1
	eor.w #$FFFF
	inc a
.m1:
	sta.b mula
	lda.b mulres+2
	bit.w #$8000
	beq .m2
	eor.w #$FFFF
	inc a
.m2:
	cmp.b mula
	bcc .dv
	jmp.w .sideentry
.dv:
	lda.b d1
	sta.b mula
	jsl.l divs		; d5 = d5*d3 / d1
	sta.b d5
	lda.b d2
	sec
	sbc.b d5
	sta.b d2
	sec
	sbc.b d4
	bmi .v7
	bvc .xl2
.se1:
	jmp.w .sideentry
.v7:
	bvc .se1
.xl2:
	lda.b d4
	eor.w #$FFFF
	inc a
	sta.b d4
	lda.b d2
	sec
	sbc.b d4
	beq .mouth
	bmi .v8
	bvs .mouth
.se2:
	jmp.w .sideentry
.v8:
	bvs .se2
.mouth:		;crossed between the posts
	stz.b d1
	lda.w pucky		; puck on the back side: wallcoll
	eor.b d0
	bpl .pf
	jmp.w wallcoll
.pf:
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.w pfgoal+puckobj		; own goal by the carrier: wallcoll
	beq .z13
	jmp.w wallcoll
.z13:		;at the crossbar height: off the post
	lda.w Zpos+puckobj
	cmp.w #$000D
	beq .deflectsf
	lda.b d4		; mouth = half width - 5
	sec
	sbc.w #$0005
	sta.b d4
	lda.b d2
	sec
	sbc.b d4
	beq .ml
	bmi .v9
	bvs .ml
	bra .deflectsf
.v9:
	bvs .deflectsf
.ml:
	lda.b d4
	eor.w #$FFFF
	inc a
	sta.b d4
	lda.b d2
	sec
	sbc.b d4
	bmi .v10
	bvs .deflectsf
.goal:
	jmp.w Goal
.v10:
	bvs .goal
.deflectsf:		;off the post
	jsl.l ChkShotStat		; off the post: sfx and crowd +300
	lda.w #SFXpuckpost
	pha
	jsl.l sfx
	lda.b crowdlevel
	clc
	adc.w #$012C
	sta.b crowdlevel
	lda.w #$1000		; random Yvel away from the goal, Xvel/Zvel +-$1000
	jsl.l randoma
	sta.b d0
	lda.w pucky
	bmi .df0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.df0:
	lda.b d0
	sta.w puckvy
	lda.w #$2000
	jsl.l randoma
	sec
	sbc.w #$1000
	sta.w puckvx
	lda.w #$2000
	jsl.l randoma
	sec
	sbc.w #$1000
	sta.w puckvz
	jmp.w puckflip
.deflectz:		;Zvel = |Zvel|
	lda.w puckvz
	bit.w #$8000
	beq .dz
	eor.w #$FFFF
	inc a
.dz:
	sta.w puckvz
.rtl:
	rtl
.sideentry:		;off the side: wallcoll with normal (0, +-256)
	stz.b d0
	lda.w #$0100		; d1 = +-256 by the x movement
	sta.b d1
	lda.w puckx
	sec
	sbc.w OldXpos+puckobj
	sta.b d2
	bmi .wc
	lda.w #$FF00
	sta.b d1
.wc:
	jmp.w wallcoll

org $80D182
Goal:		;puck in goal. a3 = puck. Entered from checkgoal
		;   SNES: puck in the goal. Score +1 for the scoring team (a2, a1 = the other team), siren, ScoreSum entry, goal counts, PenGoalStuff, printscores1, ascore
		;   for the scorers, puck into the net, siren SPA and PenGoal
	lda.w gmclock		; clock stopped: no goal
	beq .go
	jmp.w .rtl
.go:		;puck must be moving into the net
	lda.w pucky
	eor.w puckvy
	bpl .in
	jmp.w .rtl
.in:
	jsl.l ChkShotStat		; sound reset, siren, mute other sfx
	jsl.l sndqreset
	lda.w #SFXsiren
	pha
	jsl.l sfx
	lda.b vcount
	sta.w sfxmutetime
	jsl.l freezewindow
	lda.b crowdlevel		; crowd +500
	clc
	adc.w #$01F4
	sta.b crowdlevel
	stz.b a2		; a2 = scoring team (0/2), a1 = other
	lda.w #$0002
	sta.b a1
	lda.w Ypos,x
	bpl .g0
	stz.b a1
	lda.w #$0002
	sta.b a2
.g0:
	lda.w gmode		; gmdir: swap
	bit.w #gmdir
	beq .g1
	lda.b a1
	sta.b a2
	eor.w #$0002
	sta.b a1
.g1:
	ldy.b a2
	lda.w tmscore,y
	inc a
	sta.w tmscore,y
	lda.w ScoreSumbytes		; ScoreSum full (30 entries): overwrite the last
	cmp.w #$00B4
	bne .sum
	sec
	sbc.w #$0006
	sta.w ScoreSumbytes
.sum:
	lda.w #$0000
	sta.b a0+2
	lda.w #ScoreSum
	clc
	adc.w ScoreSumbytes
	sta.b a0
	lda.w ScoreSumbytes
	adc.w #$0006
	sta.w ScoreSumbytes
	jsl.l GetPeriodTimeRemaining		; entry word 0 = time
	lda.b d0
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w #$0002		; byte 2 = 2 + tmap(a2) - tmap(a1), bit 7 = away team scored
	clc
	ldy.b a2
	adc.w tmap,y
	ldy.b a1
	sec
	sbc.w tmap,y
	ldy.b a2
	beq .home
	ora.w #$0080
.home:
	sta.b [a0]
	inc.b a0
	lda.w tmtouch1,y		; byte 3 = scorer; no assists yet
	sta.b d0
	sta.b [a0]
	inc.b a0
	lda.w #$FFFF
	sta.b [a0]
	lda.b a2		; goals +1 for the scorer
	beq .h1
	lda.w #$001A
.h1:
	clc
	adc.b d0
	tay
	sep #$20
	lda.w tmgoals,y
	inc a
	sta.w tmgoals,y
	rep #$20
	ldy.b a2		; assists
	lda.w tmtouch2,y
	bmi .noast
	sep #$20
	sta.b [a0]
	rep #$20
	inc.b a0
	lda.w tmtouch3,y
	bmi .noast
	sep #$20
	sta.b [a0]
	rep #$20
.noast:
	jsl.l PenGoalStuff		; PenGoalStuff, printscores1, ascore for the scoring team
	jsl.l printscores1
	lda.w #ascore
	sta.b d0
	jsl.l .setass
	lda.b a2		; home team within 3 after scoring: goal cue
	bne .nocue
	lda.w tmscore+2
	sec
	sbc.w tmscore
	bmi .nocue
	cmp.w #$0003
	bcs .nocue
	inc.w goalcue
.nocue:
	stz.b collflag		; puck into the net at (+-6, +-$110), Zvel $600
	stz.w puckvx
	stz.w puckvy
	lda.w #$0006
	sta.b d0
	lda.w puckx
	bpl .1
	lda.w #$FFFA
	sta.b d0
.1:
	lda.b d0
	sta.w puckx
	lda.w #$0110
	sta.b d0
	lda.w pucky
	bpl .0
	lda.w #$FEF0
	sta.b d0
.0:
	lda.b d0
	sta.w pucky
	lda.w #$0600
	sta.w puckvz
	stz.w Zpos+puckobj
	lda.w #$FFFF		; puckcross never; pfnc
	sta.w puckcross+2
	sta.w puckcross+6
	sta.w pfnc+puckobj
	lda.w #pnothing
	sta.b d0
	jsl.l assreplace
	inx		; shadow: siren anim
	inx
	lda.w #SPAsiren
	sta.b d1
	jsl.l SetSPA
	ldy.b a2		; PenGoal for the first object of team a2
	ldx.w tmsort,y
	stx.b a3
	lda.w #PenGoal
	sta.b d0
	jsl.l AddPenalty2
	ldx.w #puckobj
	stx.b a3
	rtl
.setass:		;give each skater of team a2 that is not fighting assignment d0, clear pfnc
	phx
	ldy.b a2
	lda.w tmsort,y
	tax
	lda.w #$0005
	sta.b d3
.loop:
	lda.w position,x
	bmi .nl
	beq .nl
	lda.w pf2fight,x
	bne .nl
	stz.w pfnc,x
	jsl.l assinsert
.nl:
	inx
	inx
	dec.b d3
	bpl .loop
	plx
.rtl:
	rtl

org $80D3D3
checkgoalp:		;check for player a3 collision with goal/net a2. Entered from checkgoal
		;   SNES: player X collision with the goal/net a2 (oval, radius x 32, y 11). CheckBump, then wallcoll with the normal
	lda.w pflags,x
	bit.w #pf2npc
	beq .npc
	jmp.w .rtl
.npc:
	lda.w Zpos,x
	sec
	sbc.w #$000A
	beq .pl
	bmi .v1
	bvs .pl
.ex1:
	jmp.w .rtl
.v1:
	bvs .ex1
.pl:		;players only (SCnum <= 11)
	cpx.w #$0017
	bcc .go
	jmp.w .rtl
.go:
	ldy.b a2		; d0 = -dy, d1 = dx
	lda.b d3
	pha
	sec
	sbc.w Ypos,y
	sta.b d3
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d2
	pha
	sec
	sbc.w Xpos,y
	sta.b d1
	asl a
	asl a
	asl a
	asl a
	sta.b mula
	sta.b mulb
	jsl.l muls32
	lda.w #$0400
	sta.b mula
	jsl.l divu
	cmp.w #$0101
	bcc .inx
	jmp.w .exit
.inx:		;(dy*16)^2/$79 + (dx*16)^2/$400 <= $100?
	sta.b d2
	lda.b d3
	asl a
	asl a
	asl a
	asl a
	sta.b mula
	sta.b mulb
	jsl.l muls32
	lda.w #$0079
	sta.b mula
	jsl.l divu
	adc.b d2
	cmp.w #$0101
	bcs .exit
	pla
	sta.b d2
	pla
	sta.b d3
	jsl.l CheckBump		; CheckBump, then wallcoll with the normal (d0,d1)/r
	lda.b d3
	pha
	lda.b d2
	pha
	lda.b d1
	pha
	lda.b d0
	pha
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b d0+2
	adc.b mulres+2
	sta.b d0+2
	jsl.l sroot
	inc a
	sta.b d2
	sta.b mula
	pla
	sta.b d0
	pla
	sta.b d1
	stz.b mulb
	lda.b d0
	sta.b mulb+1
	lda.b d0+2
	sta.b mulb+3
	jsl.l divs
	sta.b d0
	lda.b d2
	sta.b mula
	stz.b mulb
	lda.b d1
	sta.b mulb+1
	lda.b d1+2
	sta.b mulb+3
	jsl.l divs
	sta.b d1
	jsl.l wallcoll
.exit:
	pla
	sta.b d2
	pla
	sta.b d3
.rtl:
	rtl
CheckBump:		;supply minimum separation velocity for coll with walls/goal/net. a2 = goal, a3 = player. Called from checkgoalp
		;   SNES: goalie X against the net a2 with the puck near (1 in 32): if moving faster than $2000, bump the net (Xvel/Yvel / 4), stop and call
		;   PenGhold
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .save
	ldx.b xsave
	lda.w seed		; 1 in 32 frames
	and.w #$001F
	bne .ex
	ldy.b a2
	lda.w pucky		; puck within 41 of the net in y
	sec
	sbc.w Ypos,y
	bit.w #$8000
	beq .dy
	eor.w #$FFFF
	inc a
.dy:
	cmp.w #$0029
	bcs .ex
	lda.w Xvel,x
	sta.b d0
	lda.w Yvel,x
	sta.b d1
	bit.w #$8000
	beq .vy
	eor.w #$FFFF
	inc a
.vy:
	cmp.w #$2001
	bcs .bb
	lda.b d0
	bit.w #$8000
	beq .vx
	eor.w #$FFFF
	inc a
.vx:
	cmp.w #$2001
	bcs .bb
.ex:
	stx.b xsave
	ldx.w #$0006
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
.rtl:
	rtl
.bb:		;drop the saved d0-d3 and the jsl return: return to the caller of checkgoalp
	pla
	pla
	pla
	pla
	pla
	sep #$20
	pla
	rep #$30
	lda.b d0		; net Xvel/Yvel = speed / 4; player stops
	lsr a
	lsr a
	bit.w #$2000
	beq .sx
	ora.w #$C000
.sx:
	sta.b d0
	ldy.b a2
	sta.w Xvel,y
	lda.b d1
	lsr a
	lsr a
	bit.w #$2000
	beq .sy
	ora.w #$C000
.sy:
	sta.b d1
	sta.w Yvel,y
	stz.w Xvel,x
	stz.w Yvel,x
	lda.w #sfslock
	tsb.w sflags
	lda.w gmclock
	bne .rtl
	lda.w #PenGhold
	sta.b d0
	jmp.w AddPenalty2
checkplcoll:		;d2/d3 = x/y cords, a3 = struct. Walk up and down the OOlist from a3 and call checkcx for each object within $10 in y. Called from checkcoll
		;   SNES: d2/d3 = x/y, X = object. Walk up and down the OOlist from X and call checkcx for each object within 14 in y
	lda.w pflags,x
	bit.w #pf2npc
	beq .pl
	jmp.w .ex
.pl:
	cpx.w #$0018
	bcc .go
	jmp.w .ex
.go:
	lda.w OOlistpos,x		; d1 = position of X in OOlist
	sta.b d1
.0:		;objects higher in the list
	ldy.b d1
	cpy.w #$000F		; top of the list
	beq .cl
	lda.w OOlist+1,y
	and.w #$00FF
	sta.b d4
	tay
	lda.w Ylist,y
	sec
	sbc.b d3
	sta.b d5
	sec
	sbc.w #$000E
	beq .uy
	bmi .v1
	bvs .uy
	bra .cl
.v1:
	bvs .cl
.uy:
	lda.w Xpos,y
	sec
	sbc.b d2
	bit.w #$8000
	beq .ux
	eor.w #$FFFF
	inc a
.ux:
	cmp.w #$000F
	bcs .unext
	lda.w pflags,y		; not npc, nc, players only
	and.w #pf2npc
	ora.w pfnc,y
	bne .unext
	cpy.w #$0018
	bcs .unext
	jsl.l checkcx
.unext:
	inc.b d1
	bra .0
.cl:		;objects lower in the list
	lda.w OOlistpos,x
	beq .ex
	sta.b d1
.1:
	ldy.b d1
	lda.w OOlist-1,y
	and.w #$00FF
	sta.b d4
	tay
	lda.b d3
	sec
	sbc.w Ylist,y
	sta.b d5
	sec
	sbc.w #$000E
	beq .dy
	bmi .v2
	bvs .dy
	bra .ex
.v2:
	bvs .ex
.dy:
	lda.w Xpos,y
	sec
	sbc.b d2
	bit.w #$8000
	beq .dx
	eor.w #$FFFF
	inc a
.dx:
	cmp.w #$000F
	bcs .dnext
	lda.w pflags,y
	and.w #pf2npc
	ora.w pfnc,y
	bne .dnext
	cpy.w #$0018
	bcs .dnext
	jsl.l checkcx
.dnext:
	dec.b d1
	bne .1
.ex:
	rtl
checkcx:		;d4 = obj. # * 2 for possible coll so check x range and distance for coll. d2 = x, d5 = delta y, a3 = moving object. Opposing players add impact and run newcheck, checkint
		;   checkcheck and checkfight; then momentum moves from a3 to a2. Called from checkplcoll
		;   SNES: Y = object near X. Opposing players add impact and run newcheck, checkint, checkcheck and checkfight; then momentum moves from X to a2
		;   (weights + 140, elasticity evalue)
	stx.b xsave
	ldx.w #$0000
.push:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0018
	bne .push
	ldx.b xsave
	sty.b a2		; a2 = Y; d0/d1 = relative velocity, d2/d3 = relative position
	stz.b evalue
	lda.w Xvel,x
	sec
	sbc.w Xvel,y
	sta.b d0
	lda.w Yvel,x
	sec
	sbc.w Yvel,y
	sta.b d1
	sta.b mulb
	lda.w Xpos,y
	sec
	sbc.w Xpos,x
	sta.b d2
	lda.w Ypos,y
	sec
	sbc.w Ypos,x
	sta.b d3
	sta.b mula
	lda.b d1
	pha
	lda.b d0
	pha
	jsl.l muls32
	sta.b d1
	lda.b mulres+2
	sta.b d1+2
	lda.b d2
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l muls32
	adc.b d1
	sta.b d1
	lda.b d1+2
	adc.b mulres+2
	bpl .v1n		; v1n < 0: no collision
	jmp.w .exit4
.v1n:		;V1n = (Vy*Dy + Vx*Dx) / 16
	lsr a
	ror.b d1
	lsr a
	ror.b d1
	lsr a
	ror.b d1
	lsr a
	ror.b d1
	lda.w pfteam,x		; same team: no impact
	cmp.w pfteam,y
	beq .not
	lda.b d1+1
	and.w #$00FF
	sta.b d4
	cmp.w #$0006
	bcs .g40
	lda.w #$0005
	sta.b d4
.g40:		;minimum impact 5
	clc
	adc.w impact,x
	sta.w impact,x
	lda.w impact,y
	clc
	adc.b d4
	sta.w impact,y
	lda.w pf2fight,y		; impactp = the other (not while fighting)
	bne .if
	txa
	lsr a
	sta.w impactp,y
.if:
	lda.w pf2fight,x
	bne .if2
	tya
	lsr a
	sta.w impactp,x
.if2:		;impact under 20: no check sound
	lda.b d4
	cmp.w #$0014
	bcc .n1
	lda.w puckc		; check sound only if one of them has the puck
	cmp.w SCnum,x
	beq .nc
	cmp.w SCnum,y
	bne .n1
.nc:
	jsl.l newcheck
.n1:
	jsl.l checkint
	jsl.l checkcheck
	jsl.l checkfight
.not:		;same team: no check events
	lda.b d1
	sta.b d4
	pla
	sta.b d0
	pla
	sta.b d1
	lda.b collflag		; collflag set by holdcheck / Bcheck: no transfer
	bpl .tr
	jmp.w .exit
.tr:		;V1t = (Vx*Dy - Vy*Dx) / 16
	lda.b d2
	sta.b mula
	lda.b d1
	sta.b mulb
	jsl.l muls32
	sta.b d1
	lda.b mulres+2
	sta.b d1+2
	lda.b d3
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l muls32
	sec
	sbc.b d1
	sta.b d0
	lda.b mulres+2
	sbc.b d1+2
	lsr a
	ror.b d0
	lsr a
	ror.b d0
	lsr a
	ror.b d0
	lsr a
	ror.b d0
	lda.b d0
	sta.b d5
	lda.w weight,x		; weights + 140
	clc
	adc.w #$008C
	sta.b d0
	ldy.b a2
	lda.w weight,y
	clc
	adc.w #$008C
	sta.b d1
	sta.b mula
	lda.b evalue
	sta.b mulb
	jsl.l mulu16		; mulu, A = mula*mulb
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d7+2
	lda.b d1
	clc
	adc.b d0
	sta.b d1
	lda.b d0
	sec
	sbc.b d7+2
	sta.b mulb
	lda.b d4
	sta.b mula
	jsl.l muls32
	lda.b d1
	sta.b mula
	jsl.l divs
	sta.b d0
	lda.b evalue
	sta.b mulb
	lda.b d4
	sta.b mula
	jsl.l muls16
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0800
	beq .v2n
	ora.w #$F000
.v2n:		;V2n = V1n + V1n*e
	clc
	adc.b d0
	sta.b d1
	lda.b d5
	sta.b mula
	lda.b d3
	sta.b mulb
	jsl.l muls32
	sta.b tmp0
	lda.b mulres+2
	sta.b tmp1
	lda.b d0
	sta.b mula
	lda.b d2
	sta.b mulb
	jsl.l muls32
	adc.b tmp0
	sta.b tmp0
	lda.b tmp1
	adc.b mulres+2
	lsr a
	ror.b tmp0
	lsr a
	ror.b tmp0
	lsr a
	ror.b tmp0
	lsr a
	ror.b tmp0
	lda.w Xvel,y
	clc
	adc.b tmp0
	sta.w Xvel,x
	lda.b d5
	sta.b mula
	lda.b d2
	sta.b mulb
	jsl.l muls32
	sta.b tmp0
	lda.b mulres+2
	sta.b tmp1
	lda.b d0
	sta.b mula
	lda.b d3
	sta.b mulb
	jsl.l muls32
	sec
	sbc.b tmp0
	sta.b tmp0
	lda.b mulres+2
	sbc.b tmp1
	lsr a
	ror.b tmp0
	lsr a
	ror.b tmp0
	lsr a
	ror.b tmp0
	lsr a
	ror.b tmp0
	lda.w Yvel,y
	clc
	adc.b tmp0
	sta.w Yvel,x
	lda.b d1
	sta.b mula
	lda.b d2
	sta.b mulb
	jsl.l muls32
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	clc
	adc.w Xvel,y
	sta.w Xvel,y
	lda.b d1
	sta.b mula
	lda.b d3
	sta.b mulb
	jsl.l muls32
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	clc
	adc.w Yvel,y
	sta.w Yvel,y
	lda.w #$FFFF		; collflag
	sta.b collflag
.exit:
	stx.b xsave
	ldx.w #$0016
.pop:
	pla
	sta.b d0,x
	dex
	dex
	bpl .pop
	ldx.b xsave
	rtl
.exit4:		;drop the saved Vx/Vy
	pla
	pla
	bra .exit
newcheck:		;start a new check sound. 93: one of 4 sounds $1C-$1F (92: one of 5 from SFXcheck = 18), never the last one again. Called from checkcx; FallDown branches here when the player who
		;   fell did not have the puck
		;   SNES: check sound SFXcheck + random 0/1
	lda.w seed+1
	and.w #$0001
	clc
	adc.w #SFXcheck
	pha
	jsl.l sfx
	rtl
checkint:		;check for interference penalty. player a2 interferes with a3 or vice-versa; goalie is only player who cause an interference call. Called from checkcx
		;   SNES: goalie a2 against a3 and the other way round
	lda.b d0+2		; a2 and a3 swapped for the second call
	pha
	lda.b d0
	pha
	jsl.l .ci
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	jsl.l .ci
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	pla
	sta.b d0
	pla
	sta.b d0+2
.rtl:
	rtl
.ci:		;a2 must be a goalie, clock running
	ldy.b a2
	lda.w position,y
	bne .rtl
	lda.w gmclock
	bne .rtl
	lda.w puckc		; a3 has the puck: skip the impact 26 test
	asl a
	cmp.b a3
	beq .pc
	lda.w impact,x
	sec
	sbc.w #$001A
	beq .rtl
	bmi .v1
	bvc .pc
	bra .rtl
.v1:
	bvc .rtl
.pc:		;impact of X > 2
	lda.w impact,x
	sec
	sbc.w #$0003
	beq .rtl
	bmi .v2
	bvc .fall
	bra .rtl
.v2:
	bvc .rtl
.fall:		;X falls
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	jsl.l FallDown
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w impact,y		; impact of a2 > 31
	sec
	sbc.w #$001F
	beq .rtl
	bmi .v3
	bvc .pen
	bra .rtl
.v3:
	bvc .rtl
.pen:		;no double minor; penalty 3 times in (20 - GGSleft)
	lda.w pflags,x
	bit.w #pf2pen
	bne .rtl
	lda.w #$0014
	sec
	sbc.w GGSleft,x
	jsl.l randoma
	cmp.w #$0003
	bcs .rtl
	lda.w gmode		; not in highlights
	bit.w #gmhl
	bne .rtl
	lda.w #PenInt
	sta.b d0
	jmp.w AddPenalty
FallDown:		;player a2 falls down, player a3 is the hitting player. 93 adds anim $13A0 in place of a fall for some players, check stats for the hitter, a third fall anim ($1524), and injuries
		;   (setInjuryType) with a penalty. Called from checkint .ci, checkcheck .cc and Bcheck; also entered from setd0player
		;   SNES: player a2 falls, X is the hitter. Stumble for some players, check stats, fall back/forward/third fall, injuries with a penalty and crowd
		;   sounds
	ldy.b a2		; players only, not fighting
	cpy.w #$0018
	bcc .f1
	jmp.w .rtl
.f1:
	lda.w pf2fight,y
	beq .spa
	jmp.w .rtl
.spa:		;already in one of the fall anims?
	lda.w SPA,y
	cmp.w #SPAinjury1
	bne .s2
	jmp.w .rtl
.s2:
	cmp.w #SPAstumble
	bne .s3
	jmp.w .rtl
.s3:
	cmp.w #SPAfallfwd
	bne .s4
	jmp.w .rtl
.s4:
	cmp.w #SPAfallback
	bne .s5
	jmp.w .rtl
.s5:
	cmp.w #SPAflip
	bne .s6
	jmp.w .rtl
.s6:		;stumble when stickhand (byte $71) >= $C, nopuckb is 0 and impact < $10-$1F
	lda.w #SPAstumble
	sta.b d1
	lda.w stickhand,y
	cmp.w #$000C
	bcc .fall
	lda.w nopuckb,y
	bne .fall
	lda.w seed
	and.w #$000F
	ora.w #$0010
	sta.b d0
	sec
	sbc.w impact,y
	beq .fall
	bmi .v1
	bvc .stumble
	bra .fall
.v1:
	bvc .fall
.stumble:		;no second stumble for $3C
	lda.w #$003C
	sta.w nopuckb,y
	jmp.w .set
.fall:		;no check stats for a goalie hitter
	lda.w position,x
	beq .nostat
	stz.b a0		; team checks, player checks, ChkCnt (+3 when fightagg is 0)
	lda.w pfteam,x
	beq .tm
	lda.w #$0002
	sta.b a0
.tm:
	ldy.b a0
	lda.w tmchecks,y
	inc a
	sta.w tmchecks,y
	inc.w ChkCnt
	lda.w pnum,x
	sta.b d0
	lda.w pfteam,x
	beq .pl
	lda.w #$001A
.pl:
	clc
	adc.b d0
	tay
	sep #$20
	lda.w pchecks,y
	inc a
	sta.w pchecks,y
	rep #$20
	lda.w fightagg,x
	bne .nostat
	inc.w ChkCnt
	inc.w ChkCnt
.nostat:
	ldy.b a2		; nopuck 120 for a2
	lda.w #$0078
	sta.w nopuck,y
	lda.w Xpos,x		; direction from a2 to the hitter
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	sta.b d1
	jsl.l vtoa
	lda.w #SPAfallback
	sta.b d1
	ldy.b a2		; hit from the front: fall back
	lda.b d0
	sec
	sbc.w facedir,y
	inc a
	and.w #$0007
	cmp.w #$0003
	bcc .set
	lda.w #SPAfallfwd
	sta.b d1
	lda.w facedir,y		; facedir 0 or 4 and hitter aggress >= 10: third fall
	and.w #$0003
	bne .set
	lda.w aggress,x
	sec
	sbc.w #$000A
	bmi .v2
	bvc .f3
	bra .set
.v2:
	bvc .set
.f3:
	cpx.w #$0018
	bcs .set
	lda.w #SPAflip
	sta.b d1
.set:		;SetSPA d1 for a2
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w #$0001		; pfalock
	sta.w pfalock,x
	jsl.l SetSPA
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.b crowdlevel		; crowd +300
	clc
	adc.w #$012C
	sta.b crowdlevel
	lda.w puckc		; a2 did not have the puck: check sound only
	sta.b d0
	bpl .pc
	jmp.w newcheck
.pc:
	tya
	lsr a
	cmp.b d0
	beq .drop
	jmp.w newcheck
.drop:		;a2 had the puck: lose it, maybe an injury
	lda.w #$FFFF
	sta.w puckc
	lda.w gmode		; injury: no highlight, fall back, facedir 0/4, no penalty, random(160) <= impact, clock running
	bit.w #gmhl
	bne .snd
	lda.w SPA,y
	cmp.w #SPAfallback
	bne .snd
	lda.w facedir,y
	and.w #$0003
	bne .snd
	lda.w pflags,y
	bit.w #pf2pen
	bne .snd
	lda.w #$00A0
	jsl.l randoma
	ldy.b a2
	sec
	sbc.w impact,y
	beq .inj
	bmi .v3
	bvs .inj
	bra .snd
.v3:
	bvs .snd
.inj:
	lda.w gmclock
	bne .snd
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w #SPAinjury1
	sta.b d1
	jsl.l SetSPA
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	jsl.l setInjuryType		; setInjuryType
	lda.w #$0004
	sta.w InjCntDown
	lda.w #PenInjury		; PenInjury if the hitter is a goalie or penalties are off, else PenRough2 and Stop4Pen
	sta.b d0
	lda.w position,x
	bne .g
	jmp.w AddPenalty2
.g:
	lda.w OptPen
	bne .rough
	jmp.w AddPenalty2
.rough:
	lda.w #PenRough2
	sta.b d0
	jsl.l AddPenalty2
	jmp.w Stop4Pen
.snd:
	ldy.b a2		; home player fell: boo, else cheer
	lda.w #SFXcrowdcheer
	pha
	lda.w pfteam,y
	bne .play
	lda.w #SFXcrowdboo
	sta.b $01,s
.play:
	jsl.l sfx
.rtl:
	rtl
checkcheck:		;player is in contact look for various contact events. Runs .cc for a3 on a2, then for a2 on a3. d4 = impact. Called from checkcx
		;   SNES: players in contact: .cc for X on a2, then for a2 on X. d4 = impact
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .pusha
	ldx.b xsave
	jsl.l .cc
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	jsl.l .cc
	stx.b xsave
	ldx.w #$000E
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$0012
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	ldx.b a3
.rtl:
	rtl
.cc:		;X is checking a2
	ldy.b a2		; a2 holding: holdcheck
	lda.w SPA,y
	cmp.w #SPAHold
	bne .h2
	jml.l holdcheck
.h2:
	cmp.w #SPAhook
	bne .b
	jml.l holdcheck
.b:
	cmp.w #SPAsweepchk
	bne .burst
	jml.l Bcheck
.burst:		;X must be in the burst anim
	lda.w SPA,x
	cmp.w #SPAburst
	bne .rtl
	lda.w gmclock		; clock stopped: fight chance up
	beq .nofight
	lda.w #$0100
	sta.w impact,x
	sta.w impact,y
.nofight:
	lda.w Xpos,y
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w Ypos,y
	sec
	sbc.w Ypos,x
	sta.b d1
	jsl.l vtoa
	lda.b d0
	sec
	sbc.w facedir,x
	and.w #$0007
	sta.b d0
	lda.w attribute,x		; xflip: mirror the direction
	bit.w #$0800
	beq .n0
	lda.b d0
	eor.w #$FFFF
	inc a
	and.w #$0007
	sta.b d0
.n0:		;check anim from .list by the direction to a2
	asl.b d0
	lda.w #.list
	sta.b a0
	sta.w pfalock,x		; pfalock
	lda.w #.list>>16
	sta.b a0+2
	ldy.b d0
	lda.b [a0],y
	sta.b d1
	jsl.l SetSPA
	ldy.b a2
	lda.w position,y
	bne .pos
	jmp.w .rtl
.pos:		;goalie does not fall
	lda.b d4		; impact under 20: no fall
	sec
	sbc.w #$0014
	bmi .v1
	bvc .fall
.ex1:
	jmp.w .rtl
.v1:
	bvc .ex1
.fall:		;d0 = (120 (*2 joystick) - weight + weight of a2) / 2 - impact of a2
	lda.w #$0078
	sta.b d0
	lda.w pflags,x
	bit.w #pfjoycon
	beq .n00
	asl.b d0
.n00:
	lda.b d0
	sec
	sbc.w weight,x
	clc
	adc.w weight,y
	lsr a
	sec
	sbc.w impact,y
	sta.b d0
	beq .down
	bmi .down
	jsl.l randomd0		; random < aggress: down
	lda.b d0
	sec
	sbc.w aggress,x
	beq .down
	bmi .v2
	bvc .pen
	bra .down
.v2:
	bvc .down
.pen:
	jsl.l checkagr		; checkagr <= 4 and no highlight: PenCharge or PenSlash (d0 = penalty roll)
	lda.b d0
	cmp.w #$0005
	bcc .nohl
	jmp.w .rtl
.nohl:
	lda.w gmode
	bit.w #gmhl
	beq .roll
	jmp.w .rtl
.roll:
	lda.w seed+1
	and.w #$0002
	clc
	adc.w #PenCharge
	sta.b d0
	jmp.w AddPenalty
.down:
	jsl.l checkagr		; checkagr <= 3 and no highlight: PenRough or PenCross (d0 = penalty roll)
	lda.b d0
	cmp.w #$0004
	bcs .dn2
	lda.w gmode
	bit.w #gmhl
	bne .dn2
	lda.w seed+3
	and.w #$0002
	clc
	adc.w #PenRough
	sta.b d0
	jsl.l AddPenalty
.dn2:
	jmp.w FallDown
.list:		;check anim by direction
	dw SPAshoulderchkl,SPAshoulderchkr,SPAhipchkr,SPAhipchkr,SPAhipchkr,SPAhipchkl,SPAhipchkl,SPAshoulderchkl
checkfight:		;look for start of fight between players a2 & a3. Called from checkcx
		;   SNES: start of a fight between a2 and X. Both impact >= 10, no anim lock, no penalty, no goalie, clock running, no highlight, the puck not
		;   fighting or on a faceoff. SetInst both ways with d0 = 10 + max(0, 40 - ChkCnt)/4
	ldy.b a2
	lda.w impact,x
	sec
	sbc.w #$000A
	bmi .v1
	bvc .i2
.ex1:
	jmp.w .rtl
.v1:
	bvc .ex1
.i2:
	lda.w impact,y
	sec
	sbc.w #$000A
	bmi .v2
	bvc .lock
.ex2:
	jmp.w .rtl
.v2:
	bvc .ex2
.lock:
	lda.w pfalock,y
	ora.w pfalock,x
	beq .pen
	jmp.w .rtl
.pen:
	lda.w pflags,x
	ora.w pflags,y
	bit.w #pf2pen
	beq .pos1
	jmp.w .rtl
.pos1:
	lda.w position,x
	bne .pos2
	jmp.w .rtl
.pos2:
	lda.w position,y
	bne .clk
	jmp.w .rtl
.clk:
	lda.w gmode		; highlight, clock stopped, the puck fighting
	and.w #gmhl
	ora.w gmclock
	ora.w pf2fight+puckobj
	beq .go
	jmp.w .rtl
.go:
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .pusha
	ldx.b xsave
	ldy.w assnum+puckobj		; puck assignment pfaceoff: no fight
	lda.w asslist+puckobj*4,y
	and.w #$00FF
	cmp.w #pfaceoff
	bne .nofo
	jmp.w .ex
.nofo:
	lda.w #$0028		; d0 = 10 + max(0, 40 - ChkCnt)/4
	sec
	sbc.w ChkCnt
	bpl .pos
	lda.w #$0000
.pos:
	lsr a
	lsr a
	clc
	adc.w #$000A
	sta.b d0
	jsl.l SetInst
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	jsl.l SetInst
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w pf2fight,x
	bne .fight
	jmp.w .ex
.fight:		;clear ChkCnt and the check counts of both teams
	stz.w ChkCnt
	lda.w #$0000
	ldy.w #$0032
.clr:
	sta.w pchecks,y
	dey
	dey
	bpl .clr
	lda.b crowdlevel		; crowd +1000; no pass/shot dir; puckc = X; yc1 = middle; sfslock
	clc
	adc.w #$03E8
	sta.b crowdlevel
	lda.w #sfspdir|sfssdir
	trb.w sflags
	ldy.b a2
	txa
	lsr a
	sta.w puckc
	lda.w Ypos,x
	clc
	adc.w Ypos,y
	pha
	asl a
	pla
	ror a
	sta.w yc1
	lda.w #sfslock
	tsb.w sflags
	lda.w #$0002
	sta.b d1
	lda.w Xpos,x
	sta.b d0
	sec
	sbc.w Xpos,y
	bmi .v3
	bvc .flip
	bra .o1
.v3:
	bvc .o1
.flip:
	lda.b d1
	eor.w #$0007
	sta.b d1
.o1:		;face each other
	lda.b d1
	sta.w facedir,x
	eor.w #$0007
	sta.b d1
	sta.w facedir,y
	jsl.l .sf
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	jsl.l .sf
	ldx.w #$0000		; others: afwatch (not unavailable, not fighting, not goalies)
	lda.w #afwatch
	sta.b d0
	lda.w #$000B
	sta.b d1
.watch:		;the others watch the fight
	lda.w pflags,x
	and.w #pf2unav
	ora.w pf2fight,x
	bne .next
	lda.w position,x
	beq .next
	jsl.l assinsert
.next:
	inx
	inx
	dec.b d1
	bpl .watch
	ldx.w #puckobj		; the puck: pf2fight, pnothing
	lda.w #$0001
	sta.w pf2fight+puckobj
	lda.w #pnothing
	sta.b d0
	jsl.l assinsert
	lda.w #$FFFF
	sta.b collflag
.ex:
	stx.b xsave
	ldx.w #$000E
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$0012
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	ldx.b a3
.rtl:
	rtl
.sf:		;start the fight for X against a2
	ldy.b a2		; impactp = a2
	tya
	lsr a
	sta.w impactp,x
	lda.w #PenFight
	sta.b d0
	jsl.l AddPenalty2
	txa		; setd0player
	lsr a
	sta.b d0
	jsl.l setd0player
	lda.w #afight
	sta.b d0
	jsl.l assinsert
	lda.w attribute,x		; Xvel -$400 facing 2, else flipped and +$400
	and.w #$F7FF
	sta.w attribute,x
	lda.w #$FC00
	sta.b d1
	lda.w facedir,x
	cmp.w #$0002
	beq .sf2
	lda.w attribute,x
	ora.w #$0800
	sta.w attribute,x
	lda.w #$0400
	sta.b d1
.sf2:
	lda.b d1
	sta.w Xvel,x
	lda.w pflags,x		; unavailable, no player coll; pf2aip; SPAfight
	ora.w #pf2npc|pf2unav
	sta.w pflags,x
	stz.w pfalock,x
	lda.w #SPAfight
	sta.b d1
	sta.w pf2aip,x
	jmp.w SetSPA
SetInst:		;d0 = fight rating a3 needs. Called twice from checkfight (a2/a3 swapped)
		;   SNES: If fightagg of X >= d0, of a2 >= 2 and >= $10 - 2 * a2 checks, set pf2fight on both. Then 92 style: an instigator
		;   penalty for a shoulder check
	lda.w fightagg,x
	cmp.b d0
	bcc checkfight_rtl
	ldy.b a2		; tmp0 = fightagg of a2 >= 2
	lda.w fightagg,y
	sta.b tmp0
	sec
	sbc.w #$0002
	bmi .v1
	bvc .r2
.ex1:
	jmp.w checkfight_rtl
.v1:
	bvc .ex1
.r2:
	lda.w pnum,y		; d1 = $10 - 2 * a2 checks
	sta.b d1
	lda.w pfteam,y
	beq .tm
	lda.w #$001A
.tm:
	clc
	adc.w pnum,y
	tay
	lda.w pchecks,y
	and.w #$00FF
	bit.w #$0080
	beq .cnt
	ora.w #$FF00
.cnt:
	asl a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0010
	sta.b d1
	ldy.b a2
	sec
	sbc.b tmp0
	beq .set
	bmi .v2
	bvs .set
.ex2:
	jmp.w checkfight_rtl
.v2:
	bvs .ex2
.set:
	lda.w #$0001
	sta.w pf2fight,x
	sta.w pf2fight,y
	jmp.w .inst
.inst:		;X in a shoulder check: PenInst for the first teammate on the ice without a penalty
	jsl.l sndqreset		; sound reset
	lda.w SPA,x
	cmp.w #SPAshoulderchkl
	beq .chk
	cmp.w #SPAshoulderchkr
	bne .rtl
.chk:
	stx.b a4
	lda.w #$0005
	sta.b d0
	stz.b a3
	lda.w pfteam,x
	beq .loop
	lda.w #$000C
	sta.b a3
.loop:
	ldx.b a3
	cpx.b a4
	beq .next
	lda.w position,x
	bmi .next
	beq .next
	lda.w pflags,x
	bit.w #pf2pen|pf2unav
	bne .next
	lda.w #PenInst
	sta.b d0
	jsl.l AddPenalty2
	ldx.b a4
	stx.b a3
.rtl:
	rtl
.next:
	inc.b a3
	inc.b a3
	dec.b d0
	bpl .loop
	ldx.b a4
	stx.b a3
	rtl

org $80E13E
updateanim:		;frame switch control on struct a3. Also called
		;   SNES: SPA = offset in SPAList; next frame when SPAcnt runs out (d7), loops or ends the animation
	lda.w SPA,x		; no animation: clear pfalock, pf2aip
	bne .ia
	stz.w pf2aip,x
	stz.w pfalock,x
	rtl
.ia:
	clc		; a0 = SPAList + SPA; d1 = attributes (+$10)
	adc.w #SPAList&$FFFF
	sta.b a0
	lda.w #SPAList>>16
	sta.b a0+2
	ldy.w #$0010
	lda.b [a0],y
	sta.b d1
	lda.w facedir,x
	sta.b d0
	lda.w sfhormode		; horizontal rink: players turn 90 degrees
	beq .nhor
	cpx.w #$0018
	bcs .nhor
	lda.b d0
	dec a
	dec a
	and.w #$0007
	sta.b d0
.nhor:
	lda.w attribute,x		; x flip: mirror the direction
	bit.w #$0800
	beq .nox
	lda.b d0
	eor.w #$FFFF
	inc a
	and.w #$0007
	sta.b d0
.nox:
	lda.b d0		; a0 += direction table entry; d2 = new frame
	asl a
	tay
	lda.b [a0],y
	adc.b a0
	sta.b a0
	ldy.w SPAnum,x
	sty.b d0
	lda.b [a0],y
	sta.b d2
	lda.w SPAcnt,x		; SPAcnt negative: hold the frame
	bmi .one
	sec
	sbc.b d7
	sta.w SPAcnt,x
	bpl .cframe
	lda.w SPAnum,x		; next frame (4 bytes); a negative frame ends the list
	clc
	adc.w #$0004
	sta.w SPAnum,x
	iny
	iny
	iny
	iny
	sty.b d0
	dey
	dey
	lda.b [a0],y
	bpl .one
	stz.b d0		; end: restart, clear pfalock/pf2aip; d1 bit 0 = looper, else SPA = 0
	stz.w SPAnum,x
	stz.w pf2aip,x
	stz.w pfalock,x
	lda.b d1
	lsr a
	bcs .one
	stz.w SPA,x
.one:		;SPAcnt = |delay|
	ldy.b d0
	iny
	iny
	lda.b [a0],y
	bit.w #$8000
	beq .zero
	eor.w #$FFFF
	inc a
.zero:
	sta.w SPAcnt,x
.cframe:		;frame = new frame
	lda.b d2
	sta.w frame,x
	rtl
checkwindow:		;set hpos and vpos according to how screen should follow puck
		;   SNES: set Hpos/Vpos so the screen follows the puck (or xc1/yc1 when sfslock)
	lda.w yc1
	sta.b d2
	lda.w xc1
	sta.b d3
	lda.w sflags		; sfslock: use xc1/yc1
	bit.w #sfslock
	bne .dd
	ldx.w #puckobj		; follow the puck, or its carrier with yleader
	lda.w puckc
	bmi .ok
	asl a
	tax
	lda.w pfgoal,x		; carrier goes up: yleader up to 50, else down to -50
	beq .gd
	lda.w yleader
	adc.b impactstep
	sta.w yleader
	sec
	sbc.w #$0032
	bmi .v1
	bvc .ylmax
	bra .ok
.v1:
	bvc .ok
.ylmax:
	lda.w #$0032
	sta.w yleader
	bra .ok
.gd:
	lda.w yleader
	sec
	sbc.b impactstep
	sta.w yleader
	sec
	sbc.w #$FFCE
	beq .ylmin
	bmi .v2
	bvs .ylmin
	bra .ok
.v2:
	bvs .ok
.ylmin:
	lda.w #$FFCE
	sta.w yleader
.ok:		;d2 = Ypos + Yvel/128 + yleader, d3 = Xpos
	lda.w Yvel,x
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0100
	beq .sy
	ora.w #$FE00
.sy:
	clc
	adc.w Ypos,x
	clc
	adc.w yleader
	sta.b d2
	sta.w yc1
	lda.w Xpos,x
	sta.b d3
	sta.w xc1
.dd:
	lda.b d2		; |target - Vpos| > 10: scroll
	sec
	sbc.w Vpos
	sta.b d0
	sec
	sbc.w #$FFF6
	bmi .v3
	bvs .up
	bra .one
.v3:
	bvs .one
.up:
	lda.b d2
	sec
	sbc.w #$FFF6
	sta.b d1
	sec
	sbc.w #$FF39
	beq .yslimd
	bmi .v4
	bvs .yslimd
	bra .two
.v4:
	bvs .two
.yslimd:
	lda.w #$FF39
	sta.b d1
	bra .two
.one:
	lda.b d0
	sec
	sbc.w #$000A
	beq .twox
	bmi .v5
	bvc .down
	bra .twox
.v5:
	bvc .twox
.down:
	lda.b d2
	sec
	sbc.w #$000A
	sta.b d1
	sec
	sbc.w #$0100
	bmi .v6
	bvc .yslimu
	bra .two
.v6:
	bvc .two
.yslimu:
	lda.w #$0100
	sta.b d1
.two:		;Vpos += (target - Vpos) / 8 (at least 1)
	lda.b d1
	sec
	sbc.w Vpos
	beq .twox
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .s2
	ora.w #$E000
.s2:
	cmp.w #$0000
	bne .v2b
	inc a
.v2b:
	clc
	adc.w Vpos
	sta.w Vpos
.twox:
	lda.b d3		; |target - Hpos| > 40: scroll
	sec
	sbc.w Hpos
	sta.b d0
	sec
	sbc.w #$FFD8
	bmi .v7
	bvs .left
	bra .three
.v7:
	bvs .three
.left:
	lda.b d3
	sec
	sbc.w #$FFD8
	sta.b d1
	sec
	sbc.w #$FFC4
	bmi .v8
	bvs .xslimn
	bra .four
.v8:
	bvs .four
.xslimn:
	lda.w #$FFC4
	sta.b d1
	bra .four
.three:
	lda.b d0
	sec
	sbc.w #$0028
	beq .rtl
	bmi .v9
	bvc .right
	bra .rtl
.v9:
	bvc .rtl
.right:
	lda.b d3
	sec
	sbc.w #$0028
	sta.b d1
	sec
	sbc.w #$003C
	beq .four
	bmi .v10
	bvc .xslim
	bra .four
.v10:
	bvc .four
.xslim:
	lda.w #$003C
	sta.b d1
.four:		;Hpos += (target - Hpos) / 8 (at least 1)
	lda.b d1
	sec
	sbc.w Hpos
	beq .rtl
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .s4
	ora.w #$E000
.s4:
	cmp.w #$0000
	bne .h2
	inc a
.h2:
	clc
	adc.w Hpos
	sta.w Hpos
.rtl:
	rtl

org $80F36E
adda43:		;a4 += replaysize, wrapping from replayend to replaystart
		;   SNES: a4 += replaysize, wrapping from ReplayBufferEnd to ReplayBufferStart
	lda.b a4
	clc
	adc.w #replaysize
	sta.b a4
	bcc .nc
	inc.b a4+2
.nc:
	cmp.w #ReplayBufferEnd&$FFFF		; past the end of the buffer: wrap
	bne .rtl
	lda.b a4+2
	cmp.w #ReplayBufferEnd>>16
	bne .rtl
	lda.w #ReplayBufferStart&$FFFF
	sta.b a4
	lda.w #ReplayBufferStart>>16
	sta.b a4+2
.rtl:
	rtl

org $80F3E1
startpause:		;set sfpz (startpause1 and startpause2 jump here)
	lda.w #sfpz
	tsb.w sflags
	rtl

org $80F5EA
DecodePW:		;translate char password in PassWord to variables used in game
		;   SNES: translate the password in PassWord to game variables: PWtoBits, then ReadPassBits (ReadPassBits)
	jsl.l PWtoBits
	jml.l ReadPassBits
PlayoffScreenOpening4:		;SNES: PlayoffScreen, then on to Opening4
	jsl.l PlayoffScreen		; font tile bases, the playoff tree
	jml.l Opening4
SuperDiv:		;5 words at a3 divided by 1 word (d0).
		;   SNES: passbits (128 bits) / d0: quotient in passbits, remainder in d0. Shift-subtract over 128 bits with the divisor in mula+0..+16 and the remainder in
		;   mulres+0..+14
	phx		; remainder = passbits, divisor = d0 << 128
	ldx.w #$000E
.init:
	lda.w passbits,x
	sta.b mulres,x
	stz.b mula,x
	dex
	dex
	bpl .init
	lda.b d0
	sta.b mula+16
	ldx.w #$0080
.loop:
	lsr.b mula+16
	ror.b mula+14
	ror.b mula+12
	ror.b mula+10
	ror.b mula+8
	ror.b mula+6
	ror.b mula+4
	ror.b mula+2
	ror.b mula
	asl.w passbits		; shift the dividend left
	rol.w passbits+2
	rol.w passbits+4
	rol.w passbits+6
	rol.w passbits+8
	rol.w passbits+10
	rol.w passbits+12
	rol.w passbits+14
	lda.b mulres		; remainder >= divisor: subtract, quotient bit 1
	cmp.b mula
	lda.b mulres+2
	sbc.b mula+2
	lda.b mulres+4
	sbc.b mula+4
	lda.b mulres+6
	sbc.b mula+6
	lda.b mulres+8
	sbc.b mula+8
	lda.b mulres+10
	sbc.b mula+10
	lda.b mulres+12
	sbc.b mula+12
	lda.b mulres+14
	sbc.b mula+14
	lda.w #$0000
	sbc.b mula+16
	bcc .next
	lda.b mulres
	sbc.b mula
	sta.b mulres
	lda.b mulres+2
	sbc.b mula+2
	sta.b mulres+2
	lda.b mulres+4
	sbc.b mula+4
	sta.b mulres+4
	lda.b mulres+6
	sbc.b mula+6
	sta.b mulres+6
	lda.b mulres+8
	sbc.b mula+8
	sta.b mulres+8
	lda.b mulres+10
	sbc.b mula+10
	sta.b mulres+10
	lda.b mulres+12
	sbc.b mula+12
	sta.b mulres+12
	lda.b mulres+14
	sbc.b mula+14
	sta.b mulres+14
	inc.w passbits
.next:
	dex
	beq .done
	jmp.w .loop
.done:
	plx
	lda.b mulres
	sta.b d0
	clc
	rtl
