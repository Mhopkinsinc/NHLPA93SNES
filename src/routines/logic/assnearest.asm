assnearest:		;asstab $11. this is a special assignment used for the player who is nearest the puck but doesn't have it. Assignment anearest ($11)
		;   SNES: assignment for the player nearest the puck who does not have it
	lda.w pflags,x
	bit.w #pfna		; pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stz.w temp3,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
	stz.w temp1,x
.nna:
	txa
	lsr a
	sta.b d1
	cmp.w puckc		; X has the puck?
	bne .nopc
	lda.w position,x
	bne .pc
	jmp.w assgoalie
.pc:
	lda.w #apuckc		; apuckc unless joystick controlled
	sta.b d0
	lda.w pflags,x
	bit.w #pfjoycon
	bne .rts
	jmp.w assinsert
.rts:
	rtl
.nopc:		;every aioff frames: find the teammate nearest the (moving) puck
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .dec
	jmp.w .nodec
.dec:
	adc.w aioff,x		; reload temp1 from aioff
	bpl .setcnt
	lda.w #$0000
.setcnt:
	sta.w temp1,x
	ldy.b a2
	lda.w #$0000		; tmnear = 0
	sta.w tmnear,y
	sta.w tmnear+4,y
	lda.w puckc
	bmi .np
	asl a
	sta.b a1
	tay
	lda.w pfteam,y		; puck carrier on my team?
	beq .pcteam
	lda.w #$0001
.pcteam:
	sta.b tmp0
	lda.w pfteam,x
	beq .myteam
	lda.w #$0001
.myteam:
	eor.b tmp0
	bne .np
	jmp.w .switch
.np:
	lda.w #$FFFF		; d2 = best distance^2 = $FFFFFFFF
	sta.b d2
	sta.b d2+2
	lda.w #$0005
	sta.b d4
	ldy.b a2
	lda.w tmsort,y		; a0 = first object of the team
	sta.b a0
.de0:
	ldy.b a0
	lda.w position,y
	bpl .pos
	jmp.w .next
.pos:
	bne .nop
	jmp.w .next
.nop:
	lda.w nopuck,y
	beq .unav
	jmp.w .next
.unav:
	lda.w pflags,y
	bit.w #pf2unav
	beq .pass
	jmp.w .next
.pass:
	tya
	asl a
	asl a
	adc.w assnum,y
	tay
	lda.w asslist,y
	and.w #$00FF
	cmp.w #apassrec		; skip a player on apassrec
	bne .dist
	jmp.w .next
.dist:
	lda.b a0
	jsl.l GetHot
	ldy.b a0
	lda.b d0
	clc
	adc.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	lda.b d1
	clc
	adc.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	lda.w puckvx		; lead the puck: puckvx/64
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0200
	beq .vx
	ora.w #$FC00
.vx:
	sta.b d3
	lda.b d0
	sec
	sbc.b d3
	sta.b d0
	lda.w puckvy
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0200
	beq .vy
	ora.w #$FC00
.vy:
	sta.b d3
	lda.b d1
	sec
	sbc.b d3
	sta.b d1
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
	lda.b mulres+2
	adc.b d0+2
	sta.b d0+2
	lda.b d2		; nearer?
	cmp.b d0
	lda.b d2+2
	sbc.b d0+2
	bcc .next
	lda.b d0
	sta.b d2
	lda.b d0+2
	sta.b d2+2
	lda.b a0
	sta.b a1
.next:
	inc.b a0
	inc.b a0
	dec.b d4
	bmi .done
	jmp.w .de0
.done:
	lda.b d2+2
	bmi .de1
	ldy.b a2
	sta.w tmnear+4,y		; tmnear = nearest distance^2
	lda.b d2
	sta.w tmnear,y
.switch:		;if another player is nearer: give him anearest and leave
	cpx.b a1
	beq .de1
	lda.w gmclock		; clock stopped
	bne .de1
	ldy.b a1
	lda.w pflags,y
	bit.w #pf2unav
	bne .de1
	ldx.b a1		; exg a1,a3 (X = a1)
	ldy.b a3
	stx.b a3
	sty.b a1
	lda.w pflags,x
	and.w #~pfdoff&$FFFF		; clear pfdoff
	sta.w pflags,x
	lda.w #anearest		; anearest
	sta.b d0
	jsl.l assinsert
	ldx.b a1		; exg back
	ldy.b a3
	stx.b a3
	sty.b a1
	jmp.w assexit
.de1:
	lda.w pfalock,x
	beq .odds
	jmp.w .rts
.odds:
	lda.w #$0002
	sta.b d1
	lda.b d2
	cmp.w #$0191		; 20^2
	bcs .nfar
	stz.b d1
	lda.w position,x
	cmp.w #$0003
	bcc .nodec
.nfar:
	lda.w sflags
	bit.w #sf2pwrplay		; sf2pwrplay
	beq .x
	dec.b d1
	dec.b d1
	jsl.l chkpk2
	bne .x
	inc.b d1
	inc.b d1
	inc.b d1
	inc.b d1
.x:
	lda.w #$0014		; ($14-aggress) << d1
	sec
	sbc.w aggress,x
	sta.b d0
	lda.b d1
	sta.b tmp0
.shl:
	dec.b tmp0
	bmi .rnd
	asl.b d0
	bra .shl
.rnd:
	jsl.l randomd0
	lda.b d0
	cmp.w #$0002
	bcs .nodec
	lda.w #$00F0		; temp3 = 240
	sta.w temp3,x
.nodec:
	lda.w pfalock,x
	beq .clk
	jmp.w .rts
.clk:
	lda.w gmclock
	beq .joy
	jml.l assnothing
.joy:
	lda.w pflags,x
	bit.w #pfjoycon
	beq .mode
	jmp.w .rts
.mode:
	ldy.b a2
	lda.w tmflags,y		; tmfmid: always the in-between spot
	bit.w #tmfmid
	bne .mid
	lda.w puckc
	bpl .cnt
	jmp.w .topuck
.cnt:
	lda.w temp3,x
	sec
	sbc.b d7
	sta.w temp3,x
	bmi .clr
	jmp.w .topuck
.clr:
	stz.w temp3,x
.mid:		;skate to halfway between the puck spot and the own goal mouth (0,+-$F4)
	jsl.l skatetopuckinit		; d0/d1 = puck spot
	lda.b d1
	pha
	lda.b d0
	pha
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d1
	eor.w #$FFFF
	inc a
	clc
	adc.w #$00F4		; own goal mouth y $F4
	sta.b d1
	lda.w pfgoal,x
	beq .nd0
	lda.b d1
	sec
	sbc.w #$01E8		; $1E8 = 2*$F4 for the top goal
	sta.b d1
.nd0:
	lda.b d0
	pha
	asl a		; asr #1
	pla
	ror a
	sta.b d0
	lda.b d1
	pha
	asl a
	pla
	ror a
	sta.b d1
	pla
	clc
	adc.b d0
	sta.b d0
	pla
	clc
	adc.b d1
	sta.b d1
	ldy.b a2
	lda.w tmflags,y
	bit.w #tmfmid
	beq .go
	lda.w pfgoal,x
	beq .neg
	lda.b d1
	sec
	sbc.w #$0053
	bmi .neg1
	bvc .clamp1
	bra .go
.neg1:
	bvc .go
.clamp1:
	lda.w #$0044
	sta.b d1
	bra .go
.neg:
	lda.b d1
	sec
	sbc.w #$FFAD
	beq .clamp2
	bmi .neg2
	bvs .clamp2
	bra .go
.neg2:
	bvs .go
.clamp2:
	lda.w #$FFBC
	sta.b d1
.go:
	lda.w #rtss		; a0 = rtss: nothing to do on arrival
	sta.b a0
	lda.w #rtss>>16
	sta.b a0+2
	jsl.l skateto		; d0/d1 = spot, [a0] = arrival routine
	jmp.w check4check
.topuck:
	jsl.l skatetopuck
	jmp.w check4check
