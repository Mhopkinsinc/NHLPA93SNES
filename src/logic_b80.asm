; Player logic and the assignments (asstab).
; Bank $80. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8083AB
goalieacc:		;goalie gets acc. in direction d0. Turns facedir one step toward d0 (92 set it directly)
		;   SNES: turns facedir one step toward d0, then playeracc
	lda.w #SPAgready		; SPAgready (2)
	sta.b d1
	lda.b d0
	and.w #$000F
	sta.b d0
	cmp.w #$0008		; 8 = no direction
	bcc .d1
	cmp.w #$0009		; 9 = stop
	bne .cgl
	lda.w Xvel,x
	ora.w Yvel,x
	beq .cgl
	jmp.w StopNA		; moving: slow down
.cgl:		;no direction: ready stance unless an animation is in progress
	lda.w pf2aip,x
	bne .rts
	jmp.w SetSPA
.rts:
	rtl
.d1:		;d0 = wanted direction: step facedir one eighth toward it
	sec
	sbc.w facedir,x
	sta.b d0
	beq .spa
	eor.w #$FFFF
	inc a
	and.w #$0004		; one step (+1/-1) toward d0
	lsr a
	dec a
	clc
	adc.w facedir,x
	and.w #$0007
	sta.b d0
	sta.w facedir,x
.spa:
	lda.w #SPAgskate		; SPAgskate $3F8
	sta.b d1
	jsl.l SetSPA
	lda.w facedir,x
	sta.b d2
	jml.l playeracc		; d2 = facedir, bank $8F (d2 = direction)
dostop:		;player a3 stops. Entered from doplayeracc and noturn0
		;   SNES: player X stops. Stop animation (and sound for the puck carrier) if fast, then StopNA
	lda.w Xvel,x
	bit.w #$8000
	beq .xabs
	eor.w #$FFFF
	inc a
.xabs:
	cmp.w #$1001		; |Xvel| > $1000?
	bcs .set
	lda.w Yvel,x
	bit.w #$8000
	beq .yabs
	eor.w #$FFFF
	inc a
.yabs:
	cmp.w #$1001
	bcc StopNA
.set:		;moving fast: glide (skating backwards) or stop animation
	lda.w #SPAglide		; SPAglide $52C
	sta.b d1
	lda.w pfrev,x		; skating backwards: glide
	bne .setspa
	txa
	lsr a
	cmp.w puckc		; puck carrier: skate stop sound
	bne .stopanim
	lda.w seed+1
	and.w #$0001
	clc
	adc.w #SFXstop
	pha
	jsl.l sfx
.stopanim:
	lda.w #SPAstop		; SPAstop $6E6, pf2aip
	sta.b d1
	sta.w pf2aip,x
.setspa:
	jsl.l SetSPA
StopNA:		;slow player a3 by 150 on each axis, no animation change. Falls in from dostop, also entered from goalieacc and others
		;   SNES: slow player X by $70*d7 on each axis, no animation change
	lda.w #$0070		; $70 per frame
	sta.b mula
	lda.b d7
	sta.b mulb
	jsl.l mulu16		; bank $8D: mulu, mulres = mula*mulb
	lda.w Xvel,x
	bpl .xp
	clc
	adc.b mulres
	sta.w Xvel,x
	bmi .y
	lda.w #$0000
.xp:
	sec
	sbc.b mulres
	sta.w Xvel,x
	bpl .y
	stz.w Xvel,x
.y:
	lda.w Yvel,x
	bpl .yp
	clc
	adc.b mulres
	sta.w Yvel,x
	bmi .rts
	lda.w #$0000
.yp:
	sec
	sbc.b mulres
	sta.w Yvel,x
	bpl .rts
	stz.w Yvel,x
.rts:
	rtl

org $8084E7
MaxSpeed:		;max speed^2 for each leg speed rating level 0-15. SNES ((n+20)*266)^2
	dd (20*266)*(20*266)
	dd (21*266)*(21*266)
	dd (22*266)*(22*266)
	dd (23*266)*(23*266)
	dd (24*266)*(24*266)
	dd (25*266)*(25*266)
	dd (26*266)*(26*266)
	dd (27*266)*(27*266)
	dd (28*266)*(28*266)
	dd (29*266)*(29*266)
	dd (30*266)*(30*266)
	dd (31*266)*(31*266)
	dd (32*266)*(32*266)
	dd (33*266)*(33*266)
	dd (34*266)*(34*266)
	dd (35*266)*(35*266)
check4bench:		;check if player a3 should go to bench. Called from assbench
		;   SNES: should player X go to the bench? Pops its return address when it takes over
	lda.w pflags,x
	bit.w #pfjoycon|pf2pen		; joystick controlled, or penalty
	bne .rts
	lda.w newpos,x
	bpl .b		; newpos negative: only a new roster player counts
	lda.w newpnum,x
	bmi .rts
.b:		;newpos or newpnum requested
	lda.w newpnum,x
	cmp.w pnum,x		; same roster player: just a position change
	beq .samepl
	txa		; current assignment: asslist+X*4+assnum
	asl a
	asl a
	adc.w assnum,x
	tay
	lda.w asslist,y
	and.w #$00FF
	cmp.w #abench		; already going to the bench
	beq .rts
	txa
	lsr a
	cmp.w puckc		; puck carrier stays
	beq .rts
	sep #$20		; pop the jsl return address
	pla
	rep #$30
	pla
	lda.w pflags,x
	ora.w #pf2unav		; pf2unav
	sta.w pflags,x
	stz.w temp1,x
	lda.w #abench		; abench
	sta.b d0
	jmp.w assreplace
.rts:
	rtl
.samepl:		;same roster player: just change position
	sep #$20		; pop the jsl return address
	pla
	rep #$30
	pla
	lda.w pflags,x
	and.w #~pf2unav&$FFFF		; clear pf2unav
	sta.w pflags,x
	stz.w pfnc,x
	lda.w #$FFFF
	sta.w newpnum,x
	sta.w newpos,x
	lda.w position,x		; d0 = position (newpos is negative here)
	sta.b d0
	jmp.w Setplass
checkob:		;bring up little warning ref if a player on your team is over blue line. Called from doinput and asspuckc
		;   SNES: bring up the little warning ref if a player on your team is over the blue line. Called from doinput and asspuckc
	lda.w gmode
	bit.w #gmoffs		; offsides off: nothing to do
	bne .offon
	jmp.w .rts
.offon:		;movem d0-d1/a0 to the stack
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
	lda.w #$0005
	sta.b d0
	stz.b a0
	cpx.w #$000C		; a0 = first object of the own team
	bcc .0
	lda.w #$000C
	sta.b a0
.0:		;d1 = blue line y ($5C), negated for the bottom goal
	lda.w #$5C		; blue line y
	sta.b d1
	lda.w pfgoal,x
	bne .top
	lda.w #-$5C
	sta.b d1
	sec
	sbc.w pucky		; puck not in this zone: no offside
	beq .bottom
	bmi .v1
	bvs .bottom
	bra .nob
.v1:
	bvs .nob
.bottom:		;any teammate below the blue line?
	ldy.b a0
	lda.w position,y
	bmi .bn
	lda.b d1
	sec
	sbc.w Ypos,y
	beq .bn
	bmi .v2
	bvs .bn
	bra .ob
.v2:
	bvs .ob
.bn:
	inc.b a0
	inc.b a0
	dec.b d0
	bpl .bottom
.nob:		;no player offside: clear the offside signal, ref away
	lda.w #$0040		; d0 = $40
	sta.b d0
	lda.w #sf2offsig
	trb.w sflags		; sf2offsig
	bne .dref
.ex:		;movem the registers back
	stx.b xsave
	ldx.w #$0002
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$0006
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
.rts:
	rtl
.ob:		;offside: set the signal, ref up
	lda.w #$0006		; d0 = 6
	sta.b d0
	lda.w #sf2offsig
	tsb.w sflags
	bne .ex
.dref:
	lda.w RefCnt		; ref idle? then bring him up
	bpl .ex
	jsl.l PushRef		; bank $8F
	bra .ex
.top:
	lda.b d1
	sec
	sbc.w pucky
	bmi .v3
	bvc .top1
	bra .nob
.v3:
	bvc .nob
.top1:
	ldy.b a0
	lda.w position,y
	bmi .tn
	lda.b d1
	sec
	sbc.w Ypos,y
	bmi .v4
	bvc .tn
	bra .ob
.v4:
	bvc .ob
.tn:
	inc.b a0
	inc.b a0
	dec.b d0
	bpl .top1
	bra .nob
chk4lc:		;see if computer should call line change
		;   SNES: should the computer call a line change? Then shoot the puck in (CompShoot)
	lda.w pucky
	sta.b d0
	lda.w pfgoal,x
	bne .gu
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.gu:
	lda.b d0
	bmi .rts
	sec
	sbc.w #blueline		; blueline
	beq .inzone
	bmi .v1
	bvs .inzone
	bra .rts
.v1:
	bvs .rts
.inzone:		;in own half, inside the blue line
	lda.w seed
	and.w #$0003		; one time in four
	bne .rts
	lda.w pflags,x
	bit.w #pf2lcm		; pf2lcm
	bne .rts
	stz.b a2
	lda.w #$0002
	sta.b a1
	lda.w pfteam,x
	beq .0
	stz.b a1
	lda.w #$0002
	sta.b a2
.0:		;a2 = own team, a1 = other team
	jsl.l AvgCline
	lda.b d0
	cmp.w #$0C01		; average energy of the line still above $C00: no change
	bcs .rts
	jsl.l CompLine		; bank $8F
	jsl.l setpersonel
	jsl.l printscores1		; bank $89
	jmp.w CompShoot
.rts:
	rtl
chk4shot:		;player a3 looks for shot (computer controlled)
		;   SNES: computer player X looks for a shot. Called from asspuckc
	jsl.l chkpk
	bne .npk
	lda.w threat		; threat on the puck carrier
	beq .npk
	lda.w Ypos,x
	bit.w #$8000
	beq .yabs
	eor.w #$FFFF
	inc a
.yabs:
	cmp.w #$00ED		; in front of the net
	bcs .npk
	lda.w seed		; one time in four: clear the puck
	and.w #$0003
	bne .npk
	jmp.w CompShoot
.npk:		;d4 = shot odds ($20-spodds)*16
	lda.w #$0020
	sec
	sbc.w spodds,x
	asl a
	asl a
	asl a
	asl a
	sta.b d4
	lda.w #blueline+goalline		; blueline+goalline
	sta.b d1
	lda.w pfgoal,x
	bne .c0
	lda.w #-(blueline+goalline)
	sta.b d1
.c0:
	lda.b d1
	sec
	sbc.w pucky
	sta.b d1
	pha
	lda.w puckx
	eor.w #$FFFF
	inc a
	sta.b mula
	sta.b mulb
	pha
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b tmp0
	lda.b mulres+2
	adc.b d0+2
	sta.b tmp1
	pla
	sta.b d0
	pla
	sta.b d1
	lda.b tmp0
	cmp.w #$2711		; distance^2 > 100*100?
	lda.b tmp1
	sbc.w #$0000
	bcs .no1
	lsr.b d4
	lsr.b d4
	lsr.b d4
	lsr.b d4
	jsl.l vtoa
	sta.b d5
	lda.w #$0005
	sta.b d3
	stz.b a1
	cpx.w #$000C
	bcs .co0
	lda.w #$000C
	sta.b a1
.co0:		;each opponent: a defender in the shot line doubles d4; a busy goalie means shoot now
	ldy.b a1
	lda.w position,y
	beq .gl
	lda.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	lda.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	jsl.l vtoa
	cmp.b d5
	bne .co1
	asl.b d4
	bra .co1
.gl:
	lda.w pf2aip,y
	beq .co1
	stz.b d3
	lda.w #$0001
	sta.b d4
.co1:
	inc.b a1
	inc.b a1
	dec.b d3
	bpl .co0
.no1:
	lda.b d4
	jsl.l randoma
	cmp.w #$0009		; no shot if random(d4) > 8
	bcs .rts
	lda.w pucky
	sta.b d0
	lda.w pfgoal,x
	bne .ds0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.ds0:
	lda.b d0
	bmi .rts
	lda.w #blueline+goalline
	sec
	sbc.b d0
	bmi .rts
	lda.w sflags		; sf2offsig: player is offside
	bit.w #sf2offsig
	bne .rts
	bra CompShoot
.rts:
	rtl
CompShoot:		;player a3 shoots (computer controlled player)
		;   SNES: computer player X shoots. Pops the caller (addq #4,sp), temp2b = swing time, assignment ashoot
	pla		; pop the caller
	sep #$20
	pla
	rep #$30
	lda.w pucky
	sta.b d0
	lda.w pfgoal,x
	bne .ds0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.ds0:
	lda.w #blueline+goalline		; swing time = (blueline+goalline - y)/8, max 20
	sec
	sbc.b d0
	lsr a
	lsr a
	lsr a
	sta.b d1
	cmp.w #$0014
	bcc .lt
	lda.w #$0014
	sta.b d1
.lt:
	stz.w temp2,x
	lda.b d1
	sta.w temp2b,x
	lda.w #ashoot		; ashoot
	sta.b d0
	jmp.w assreplace
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
	jml.l assnothing		; bank $8F
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
	jsl.l skatetopuckinit		; bank $8B (d0/d1 = puck spot)
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
	bmi .v1
	bvc .clamp1
	bra .go
.v1:
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
	bmi .v2
	bvs .clamp2
	bra .go
.v2:
	bvs .go
.clamp2:
	lda.w #$FFBC
	sta.b d1
.go:
	lda.w #rtss		; a0 = rtss: nothing to do on arrival
	sta.b a0
	lda.w #rtss>>16
	sta.b a0+2
	jsl.l skateto		; bank $88 (d0/d1 = spot, [a0] = arrival routine)
	jmp.w check4check
.topuck:
	jsl.l skatetopuck
	jmp.w check4check
check4check:		;look for good opportunity for checking opponent. Falls in from assnearest; also entered from assfwatch and asswingd
		;   SNES: look for a good chance to check an opponent. Falls in from assnearest; also entered from assfwatch and asswingd
	lda.w #$0014
	sec
	sbc.w aggress,x
	sta.b d0
	lda.w OptPen		; penalties on: half the chance
	beq .nopen
	asl.b d0
.nopen:
	lda.b d0
	jsl.l randoma
	cmp.w #$0004
	bcc .go
	lda.b d0
	jsl.l randoma
	cmp.w #$0004
	bcs .rts
.go:
	lda.w #$0005
	sta.b d2
	stz.b a0
	cpx.w #$000C
	bcs .0
	lda.w #$000C
	sta.b a0
.0:		;each opponent within 30 pixels in the facing direction
	ldy.b a0
	lda.w position,y
	beq .next
	lda.w pfalock,y
	bne .next
	lda.w pf2fight,y
	bne .next
	lda.w Xpos,y
	sec
	sbc.w Xpos,x
	sta.b d0
	bit.w #$8000
	beq .dx
	eor.w #$FFFF
	inc a
.dx:
	cmp.w #$001F
	bcs .next
	lda.w Ypos,y
	sec
	sbc.w Ypos,x
	sta.b d1
	bit.w #$8000
	beq .dy
	eor.w #$FFFF
	inc a
.dy:
	cmp.w #$001F
	bcs .next
	jsl.l vtoa
	lda.b d0
	cmp.w facedir,x		; opponent in the facing direction
	bne .next
	lda.w seed+3		; random: 1 in 4 hold, else check
	and.w #$0003
	sta.b d0
	bne burst
	jml.l Acheck		; bank $8F
.next:
	inc.b a0
	inc.b a0
	dec.b d2
	bpl .0
.rts:
	rtl
burst:		;cbut press check/speed. Also entered from check4check
		;   SNES: check button: speed burst in the facing direction (costs energy), lock in SPAburst. Also entered from check4check
	jsl.l getpde
	lda.w OptLine		; line changes off: no energy cost
	bne .0
	lda.b d0
	sec
	sbc.w #$00CC		; $1000/20
	sta.b d0
	jsl.l setpde		; bank $8F
.0:		;speed = energy*$233/$10000
	lda.b d0
	sta.b mula
	lda.w #$0233
	sta.b mulb
	jsl.l mulu		; bank $88, mulres = mula*mulb
	lda.b mulres+2
	sta.b mulb
	pha
	lda.w facedir,x
	asl a
	asl a
	tay
	lda.w #dirtab
	sta.b a0
	lda.w #dirtab>>16
	sta.b a0+2
	lda.b [a0],y
	iny
	iny
	sta.b mula
	jsl.l muls16
	adc.w Xvel,x
	sta.w Xvel,x
	lda.b [a0],y
	sta.b mula
	pla
	sta.b mulb
	jsl.l muls16
	adc.w Yvel,x
	sta.w Yvel,x
	bit.w #$8000
	beq .yabs
	eor.w #$FFFF
	inc a
.yabs:
	sta.b tmp0
	lda.w Xvel,x
	bit.w #$8000
	beq .xabs
	eor.w #$FFFF
	inc a
.xabs:
	clc
	adc.b tmp0
	sta.w pspeed,x		; |Xvel|+|Yvel|
	lda.w #SPAburst		; SPAburst $C7E, pfalock
	sta.b d1
	sta.w pfalock,x
	jmp.w SetSPA
skatetopuck:		;player a3 should skate to puck. d7 = elapse frames
		;   SNES: player X skates to the puck. d7 = elapsed frames
	jsl.l skatetopuckinit		; bank $8B (d0/d1 = puck spot)
	lda.w temp2,x
	sec
	sbc.b d7
	sta.w temp2,x
	bmi .aim
	jmp.w .ex
.aim:		;every 10 frames: aim at the puck (avoid the goal), maybe sweep check
	adc.w #$0009		; +10
	sta.w temp2,x
	jsl.l avdgoal		; bank $8D
	lda.b d1
	pha
	lda.b d0
	pha
	txa
	jsl.l GetHot
	lda.b d0
	eor.w #$FFFF
	inc a
	sec
	sbc.w Xvel+1,x		; - high byte of Xvel
	and.w #$00FF
	bit.w #$0080
	beq .vx
	ora.w #$FF00
.vx:
	clc
	adc.b $01,s
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.b d1
	eor.w #$FFFF
	inc a
	sec
	sbc.w Yvel+1,x		; - high byte of Yvel
	and.w #$00FF
	bit.w #$0080
	beq .vy
	ora.w #$FF00
.vy:
	clc
	adc.b $03,s
	sec
	sbc.w Ypos,x
	sta.b d1
	pla
	pla
	jsl.l vtoa
	lda.b d0
	sta.w temp2b,x		; temp2b = direction to the puck
	lda.w position,x
	beq .ex		; goalie skips the sweep check
	lda.w puckvx
	sta.b d0
	lda.w puckvy
	sta.b d1
	jsl.l vtoa
	lda.b d0
	eor.w #$0004		; puck coming toward the player
	cmp.w facedir,x
	beq .ex
	lda.w pucky
	sec
	sbc.w Ypos,x
	sta.b d1
	pha
	lda.w puckx
	sec
	sbc.w Xpos,x
	sta.b d0
	pha
	jsl.l vtoa
	lda.b d0
	sta.b tmp0
	pla
	sta.b d0
	sta.b mula
	sta.b mulb
	pla
	sta.b d1
	lda.w facedir,x
	cmp.b tmp0
	bne .ex
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
	cmp.w #$0385		; 30*30
	lda.b d0+2
	sbc.w #$0000
	bcc .ex
	lda.b d0
	cmp.w #$05A5		; 38*38
	lda.b d0+2
	sbc.w #$0000
	bcc Sweepcheck
.ex:
	lda.w temp2b,x
	sta.b d0
	lda.w position,x
	beq .acc
	lda.w Xpos,x
	sec
	sbc.w puckx
	bit.w #$8000
	beq .dx
	eor.w #$FFFF
	inc a
.dx:
	sta.b tmp0
	lda.w Ypos,x
	sec
	sbc.w pucky
	bit.w #$8000
	beq .dy
	eor.w #$FFFF
	inc a
.dy:
	clc
	adc.b tmp0
	cmp.w #$0036		; close to the puck: slow down, Xvel*7/8, Yvel*7/16
	bcs .acc
	lda.w Xvel,x
	sta.b mula
	lda.w #$0007
	sta.b mulb
	jsl.l muls32
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	sta.w Xvel,x
	lda.w Yvel,x
	sta.b mula
	lda.w #$0007
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
	sta.w Yvel,x
.acc:
	jml.l doplayeracc		; bank $8F (d0 = direction)
Sweepcheck:		;start sweep check on player a3
		;   SNES: start a sweep check on player X
	lda.w #SPAsweepchk		; SPAsweepchk $B44, pfalock
	sta.b d1
	sta.w pfalock,x
	jmp.w SetSPA
chkpk:		;return z flag set if killing penalty
		;   SNES: Z set if player X is killing a penalty. No power play returns NE
	lda.w sflags
	and.w #sf2pwrplay		; sf2pwrplay
	bne chkpk2
	inc a
	rtl
chkpk2:		;Z set if player X is on the short-handed team (sf2pwrtm vs pfteam)
	lda.w pfteam,x
	bne .team2
	lda.w sflags
	and.w #sf2pwrtm		; sf2pwrtm
	eor.w #sf2pwrtm
	rtl
.team2:
	lda.w sflags
	and.w #sf2pwrtm
	rtl
assshoot:		;asstab $12. assignment for computer shooting. Assignment ashoot ($12)
	lda.w pflags,x
	bit.w #pfna		; pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	bra SetShotMode
.nna:
	lda.w sflags
	bit.w #sfssdir		; sfssdir
	bne .swing
	jmp.w assexit
.swing:		;count down the swing time; then press the shot button (d2 = cbut)
	lda.w temp1,x
	sta.b d0
	stz.b d2
	lda.w temp2b,x
	sec
	sbc.b d7
	sta.w temp2b,x
	bpl ShotMode
	lda.w #cbut
	tsb.b d2
	bra ShotMode
SetShotMode:		;initiate shot by player a3
		;   SNES: start a shot by player X: shot mode, direction to goal, shot animation
	lda.w #$0008		; default shot direction: none
	sta.w passdir
	lda.w #sfssdir
	tsb.w sflags
	stz.b d0
	lda.w #$0128		; $128: goal y + 40
	sta.b d1
	lda.w pfgoal,x
	bne .ck0
	lda.w #$FED8
	sta.b d1
.ck0:
	lda.b d0
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.b d1
	sec
	sbc.w Ypos,x
	sta.b d1
	jsl.l vtoa
	lda.w #$000F		; minimum shot speed
	sta.w passspeed
	lda.w #SPAshotf		; SPAshotf $81C
	sta.b d1
	jsl.l Findhittype		; bank $8F (Z = forehand)
	beq .ck1
	lda.w #SPAshotb		; SPAshotb $94E
	sta.b d1
.ck1:
	jmp.w SetSPA
ShotMode:		;shot input. d0 = dpad, d2 = changed buttons. Falls into doshot at the end of the animation
	lda.w SPAnum,x
	cmp.w #$0018		; 7*4: end of the animation
	bcs doshot
	lda.b d0
	bit.w #$0008
	bne .ss0
	and.w #$0007
	sta.w passdir
.ss0:
	lda.w SPAnum,x
	cmp.w #$0010		; 4*4: past full windup
	bcs .rts
	lda.w passspeed
	clc
	adc.b d7
	sta.w passspeed
	lda.b d2
	bit.w #cbut		; button released
	beq .rts
	lda.w #$001C		; end the windup and swing through
	sec
	sbc.w SPAnum,x
	sta.w SPAnum,x
	cmp.w #$0018
	bcc .rts
	lda.w #$0018
	sta.w SPAnum,x
	bra doshot
.rts:
	rtl
doshot:		;stick is at puck so launch puck toward goal
		;   SNES: stick is at the puck, launch it toward the goal
	stx.b xsave
	ldx.w #$0000
.save:		;movem d0-d7/a0-a3 to the stack
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
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
	jsl.l checkgoalp_CalcGoalShotDir
	lda.w seed		; sound: wiff (one of 4)
	and.w #$0003
	clc
	adc.w #SFXshotwiff
	pha
	lda.w #sfssdir
	trb.w sflags		; sfssdir off, pfalock on
	sta.w pfalock,x
	txa
	lsr a
	sta.w shotplayer
	cmp.w puckc		; wiffed shot
	beq .hit
	jmp.w .ex
.hit:		;player has the puck: shot taken
	lda.w #SFXshotfh		; forehand shot sound
	sta.b $01,s
	lda.w #sf2shot		; sf2shot
	tsb.w sflags
	lda.w SPA,x
	cmp.w #SPAshotb
	bne .nbh
	lda.w #SFXshotbh		; backhand: sound, 25% less speed
	sta.b $01,s
	lda.w passspeed
	lsr a
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w passspeed
	sta.w passspeed
.nbh:
	lda.w passspeed
	cmp.w #$0032		; hard shot sound
	bcc .speed
	lda.w #SFXshothard
	sta.b $01,s
.speed:		;passspeed = passspeed*(makepde(shotspd)+$14)*$2570/$10000
	lda.w shotspd,x
	sta.b d0
	stx.b a0
	jsl.l makepde
	adc.w #$0014
	sta.b mulb
	lda.w passspeed
	sta.b mula
	jsl.l mulu16		; bank $8D: mulu, mulres = mula*mulb
	lda.w #$2570
	sta.b mula
	jsl.l mulu		; bank $88, mulres = mula*mulb
	lda.b mulres+2
	sta.w passspeed
	lda.w #$FFFF		; puck loose
	sta.w puckc
	lda.w #$0010		; no puck pickup for 16 frames
	sta.w nopuck,x
	txa
	lsr a
	sta.w lastplayer
	lda.w #blueline+goalline
	sta.b d1
	lda.w pfgoal,x
	bne .0
	lda.w #-(blueline+goalline)
	sta.b d1
.0:		;d0/d1 = shotsets[passdir] - puck, d2 = height; d3 = distance to the goal
	lda.w passdir
	asl a
	asl a
	tay
	lda.w #shotsets
	sta.b a0
	lda.w #shotsets>>16
	sta.b a0+2
	lda.b [a0],y
	sec
	sbc.w puckx
	sta.b d0
	iny
	iny
	lda.b [a0],y
	sta.b d2
	pha
	lda.b d1
	sec
	sbc.w pucky
	sta.b d1
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
	lda.b mulres+2
	adc.b d0+2
	sta.b d0+2
	jsl.l sroot
	bne .1
	inc a
.1:
	sta.b d3
	lda.w gmode
	bit.w #gmhl		; gmhl: highlights are always perfect
	beq .chkperf
	jmp.w .perf
.chkperf:
	lda.b d3
	cmp.w #$00C9		; too far away for a perfect shot
	bcs .notperf
	lda.w #$0010
	adc.w shotacc,x
	jsl.l randoma
	cmp.w #$000F		; chance of a perfect shot
	bcs .perf
.notperf:		;aim error from passspeed, shotacc and distance
	lda.w passspeed
	lsr a
	lsr a
	lsr a
	sec
	sbc.w shotacc,x
	clc
	adc.w #$0010
	sta.b mulb
	lda.b d3
	sta.b mula
	jsl.l mulu16		; bank $8D: mulu, mulres = mula*mulb
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d0
	lda.b d3
	cmp.w #$00FB		; closer than 251: half the error
	bcs .cp
	lsr.b d0
.cp:
	lda.b d0
	cmp.w #$0088		; clamp $88
	bcc .ar
	lda.w #$0088
	sta.b d0
.ar:
	lda.b d0
	pha
	jsl.l randomd0s
	adc.b $03,s
	sta.b $03,s
	lda.b $01,s
	sta.b d0
	cmp.w #$003D		; max 60
	bcc .ay
	lda.w #$003C
	sta.b d0
	sta.b $01,s
.ay:
	lda.b $05,s
	bpl .am
	lsr.b d0
.am:
	jsl.l randomd0sd0		; bank $8F: randomd0s on d0
	lda.b $05,s
	adc.b d0
	sta.b $05,s
	pla
	lsr a
	jsl.l randoma
	adc.b $05,s
	sta.b $05,s
.perf:		;puckvx/puckvy = passspeed*$44*dx/d3 and dy/d3; puckvz from the height
	lda.w passspeed
	sta.b mulb
	lda.w #$0044		; 1024/15
	sta.b mula
	jsl.l muls16
	pla
	sta.b mula
	jsl.l muls32
	lda.b d3
	sta.b mula
	jsl.l divs
	asl a
	sta.w puckvx
	lda.w passspeed
	sta.b mulb
	lda.w #$0044
	sta.b mula
	jsl.l muls16
	pla
	sta.b mula
	jsl.l muls32
	lda.b d3
	sta.b mula
	jsl.l divs
	asl a
	sta.w puckvy
	pla
	beq .ex
	sta.b mulb
	lda.w passspeed
	sta.b mula
	jsl.l mulu16		; bank $8D: mulu, mulres = mula*mulb
	lda.w #$0044
	sta.b mula
	jsl.l mulu		; bank $88, mulres = mula*mulb
	lda.b d3
	sta.b mula
	jsl.l divu
	asl a
	sta.b d1
	lda.w #$0B33
	sta.b mula
	lda.b d3
	sta.b mulb
	jsl.l mulu		; bank $88, mulres = mula*mulb
	lda.w passspeed
	sta.b mula
	jsl.l divu
	lsr a
	adc.b d1
	cmp.w #$1801
	bcc .noup
	lda.w #$1800		; max $1800
.noup:
	sta.w puckvz
.ex:		;play the sound, movem the registers back
	jsl.l sfx
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
	ldx.w #$001E
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3
	lda.w #blueline+goalline		; puckvy sign toward the shooting goal
	sta.b tmp0
	lda.w pfgoal,x
	bne .side
	lda.w #-(blueline+goalline)
	sta.b tmp0
.side:
	lda.b tmp0
	sec
	sbc.w pucky
	eor.w puckvy
	bpl .rtl
	lda.w puckvy
	eor.w #$FFFF
	inc a
	sta.w puckvy
.rtl:
	rtl
shotsets:		;x offset, height for each shot direction 0-8
	dw 0,$C,$10,$C		; 0: straight, high; 1
	dw $10,6,$10,0		; 2; 3
	dw 0,0,-$10,0		; 4; 5
	dw -$10,6,-$10,$C		; 6; 7
	dw 0,6		; 8: no direction
asspassrec:		;asstab $13. assignment for catching pass. Assignment apassrec ($13)
		;   SNES: assignment for catching a pass
	lda.w pfalock,x
	bne .rts		; locked
	lda.w gmclock		; clock stopped
	beq .joy
	jml.l assnothing		; bank $8F
.joy:
	lda.w pflags,x
	bit.w #pfjoycon		; joystick controlled
	beq .na
	jmp.w assexit
.na:
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF		; clear pfna, set pfdoff
	ora.w #pfdoff
	sta.w pflags,x
	stz.w temp2,x		; temp2 = 8
	lda.w #$0008
	sta.w temp2b,x
.nna:
	lda.w puckc		; puck loose: wait temp1 frames
	bpl .ex
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .rts
.ex:
	lda.w pflags,x		; clear pfdoff
	and.w #~pfdoff&$FFFF
	sta.w pflags,x
	jmp.w assexit
.rts:
	rtl
assfight:		;asstab $14. assfight : fighting logic for player X. The SNES drops the banner call and keeps the fighters inside x +-$6F
	lda.w pfalock,x
	beq .go
	jmp.w .rts
.go:
	lda.w Pencntdwn		; fight over
	bpl .chkna
	jml.l assnothing		; bank $8F
.chkna:
	lda.w pflags,x
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	jsl.l getpde
	lda.w fightagg,x		; getpde * fightagg / $1000
	sta.b d1
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l mulu16		; bank $8D: mulu, mulres = mula*mulb
	xba
	and.w #$00FF
	lsr a
	lsr a
	lsr a
	lsr a
	cmp.w #$0006
	bcs .s
	lda.w #$0005
.s:		;temp3 = strength (min 5)
	sta.w temp3,x
	stz.w temp2,x
	stz.w temp2b,x
	lda.w #$FFFF		; temp4 = banner timer
	sta.w temp4,x
	lda.w facedir,x
	cmp.w #$0002		; one player shows the banner
	bne .nna
	lda.w #$005A
	sta.w temp4,x
.nna:		;keep the fighter within x -$6F..$6F
	lda.w Xpos,x
	sec
	sbc.w #$006F
	beq .left
	bmi .v1
	bvc .clampr
	bra .left
.v1:
	bvc .left
.clampr:
	stz.w Xvel,x
	lda.w #$006F
	sta.w Xpos,x
.left:
	lda.w Xpos,x
	sec
	sbc.w #$FF91
	bmi .v2
	bvs .clampl
	bra .nna2
.v2:
	bvs .nna2
.clampl:
	stz.w Xvel,x
	lda.w #$FF91
	sta.w Xpos,x
.nna2:		;temp4 = banner timer (no banner on the SNES)
	lda.w temp4,x
	sec
	sbc.b d7
	sta.w temp4,x
	lda.w temp3,x
	bpl .fight
	jmp.w .rts
.fight:
	lda.w impactp,x		; a0 = opponent; xc1 = half way between the fighters
	asl a
	sta.b a0
	tay
	lda.w Xpos,x
	adc.w Xpos,y
	pha
	asl a
	pla
	ror a
	sta.w xc1
	lda.w pflags,x
	bit.w #pfjoycon		; joystick: no computer punch
	bne .j
	lda.w pf2aip,x		; set pf2aip, test the old value
	pha
	lda.w #$0001
	sta.w pf2aip,x
	pla
	bne .j
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Xvel,x
	xba
	and.w #$00FF
	bit.w #$0080
	beq .vx1
	ora.w #$FF00
.vx1:
	clc
	adc.b d0
	sta.b d0
	lda.w Xvel,y
	xba
	and.w #$00FF
	bit.w #$0080
	beq .vx2
	ora.w #$FF00
.vx2:
	sta.b d1
	lda.b d0
	sec
	sbc.b d1
	sta.b d0
	bit.w #$8000
	beq .inrange
	eor.w #$FFFF
	inc a
.inrange:
	cmp.w #$0019		; computer punches only within 25 pixels
	bcs .j
	lda.w #$0008
	sta.b d0
	jsl.l randomd0
	lda.b d0
	cmp.w #$0003
	bcc .p
	and.w #$0001
	sta.b d0
.p:		;choose the punch type from .al
	asl.b d0
	lda.w #.al
	sta.b a1
	lda.w #.al>>16
	sta.b a1+2
	ldy.b d0
	lda.b [a1],y
	sta.b d1
	jsl.l SetSPA
.j:
	jsl.l chkhit
	lda.w SPA,x
	cmp.w #SPAfheld		; held: still pushed
	beq .njc
	cmp.w #SPAfight		; ready: no push
	beq .jc
	lda.w pflags,x
	bit.w #pfjoycon
	bne .jc
.njc:		;push toward the fight spot (xc1+-10)
	lda.w xc1
	clc
	adc.w #$000A
	sta.b d0
	lda.w facedir,x
	cmp.w #$0002
	bne .0
	lda.b d0
	sec
	sbc.w #$0014
	sta.b d0
.0:
	lda.b d0
	sec
	sbc.w Xpos,x
	sta.b mula
	lda.w #$0023		; 35 toward the spot, 5 away from it
	sta.b mulb
	lda.w facedir,x
	sec
	sbc.w #$0004
	eor.b mula
	bmi .mul
	lda.w #$0005
	sta.b mulb
.mul:
	jsl.l muls16
	sta.b d0
	clc
	adc.w Xvel,x
	sta.w Xvel,x
.jc:		;Yvel = (yc1-Ypos)*256, +-$1000
	lda.w yc1
	sec
	sbc.w Ypos,x
	xba
	and.w #$FF00
	sta.b d1
	sec
	sbc.w #$1000
	bmi .v3
	bvc .y1
	bra .y2
.v3:
	bvc .y2
.y1:
	lda.w #$1000
	sta.b d1
.y2:
	lda.b d1
	sec
	sbc.w #$F000
	beq .y3
	bmi .v4
	bvs .y3
	bra .sety
.v4:
	bvs .sety
.y3:
	lda.w #$F000
	sta.b d1
.sety:
	lda.b d1
	sta.w Yvel,x
.rts:
	rtl
.al:		;punch animations SPAfhigh, SPAflow, SPAfgrab
	dw SPAfhigh,SPAflow,SPAfgrab
chkhit:		;part of fight to see if player is hit
		;   SNES: part of the fight, is player X hit by opponent a0?
	stx.b xsave
	ldx.w #$0000
.save:		;movem d0/a0-a3 to the stack
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0004
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
	ldy.b a0		; Y = opponent
	lda.w frame,x
	cmp.w oldframe,x		; same frame as last time: nothing new
	beq .ex
	cmp.w #SPFfight+2		; gloves dropped frame
	beq .dropped
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	bit.w #$8000
	beq .dx
	eor.w #$FFFF
	inc a
.dx:
	cmp.w #$0017		; within 22 in x
	bcs .ex
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	bit.w #$8000
	beq .dy
	eor.w #$FFFF
	inc a
.dy:
	cmp.w #$0009		; within 8 in y
	bcs .ex
	lda.w frame,x
	cmp.w #SPFfight+6		; high punch frames
	bne .1
	jmp.w .hithigh
.1:
	cmp.w #SPFfight+6+5
	bne .2
	jmp.w .hithigh
.2:
	cmp.w #SPFfight+7		; low punch frames
	bne .3
	jmp.w .hitlow
.3:
	cmp.w #SPFfight+7+5
	bne .4
	jmp.w .hitlow
.4:
	cmp.w #SPFfight+4		; grab frames
	beq .grab
	cmp.w #SPFfight+4+5
	beq .grab
.ex:		;movem the registers back (global: CwdFight/FightFall paths jump here)
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
	ldx.w #$0002
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3		; X = a3 again
	rtl
.dropped:		;gloves dropped, glovecords from xc1/yc1 (x clamped +-90)
	lda.w pflags,x
	and.w #~pf2npc&$FFFF		; clear pf2npc: gloves dropped
	sta.w pflags,x
	lda.w xc1
	sta.b d0
	sec
	sbc.w #$005A
	bmi .v1
	bvc .cl1
	bra .chkneg
.v1:
	bvc .chkneg
.cl1:
	lda.w #$005A
	sta.b d0
.chkneg:
	lda.b d0
	sec
	sbc.w #$FFA6
	beq .cl2
	bmi .v2
	bvs .cl2
	bra .drcont
.v2:
	bvs .drcont
.cl2:
	lda.w #$FFA6
	sta.b d0
.drcont:
	lda.b d0
	lsr a
	lsr a
	and.w #$00FF
	bne .dr0
	inc a
.dr0:
	sta.w glovecords		; glovecords x byte (0 becomes 1)
	lda.w yc1
	lsr a
	lsr a
	sep #$20
	sta.w glovecords+1		; glovecords y byte
	rep #$30
	bra .ex
.grab:		;exg a0,a3: the opponent is held
	ldx.b a0
	ldy.b a3
	stx.b a3
	sty.b a0
	lda.w #SPAfheld
	sta.b d1
	sta.w pf2aip,x
	jsl.l SetSPA
	jmp.w .ex
.hithigh:
	ldx.b a0
	ldy.b a3
	stx.b a3
	sty.b a0
	jsl.l CwdFight
	lda.w #$0001		; pf2aip
	sta.w pf2aip,x
	dec.w temp3,x		; strength -1; out of strength: falls
	bmi FightFall
	lda.w #SPAfhith
	sta.b d1
	jsl.l SetSPA
	lda.w #SFXhithigh
	pha
	jsl.l sfx
	jmp.w .ex
.hitlow:
	ldx.b a0
	ldy.b a3
	stx.b a3
	sty.b a0
	jsl.l CwdFight
	lda.w #$0001
	sta.w pf2aip,x
	dec.w temp3,x
	bmi FightFall
	lda.w #SPAfhitl
	sta.b d1
	jsl.l SetSPA
	lda.w #SFXhitlow
	pha
	jsl.l sfx
	jmp.w .ex
CwdFight:		;crowd reacts to a punch; push the hit player X back by the puncher (a0) strength
	ldy.b a0
	lda.b crowdlevel
	clc
	adc.w #$0050		; +80
	sta.b crowdlevel
	lda.w #$0005		; (5 + puncher strength) * 500
	clc
	adc.w temp3,y
	sta.b mulb
	lda.w #$01F4
	sta.b mula
	jsl.l mulu16		; bank $8D: mulu, mulres = mula*mulb
	sta.b d0
	lda.w facedir,x
	cmp.w #$0002		; push the other way when facing right
	bne .xveladj
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.xveladj:
	lda.w Xvel,x
	clc
	adc.b d0
	sta.w Xvel,x
	rtl
FightFall:		;X lost the fight: the a0 player gets PenFighting, maybe X is injured
	lda.b a1+2		; push a1
	pha
	lda.b a1
	pha
	lda.w #PenaltyBufferEnd		; a1 = penalty list
	sta.b a1
	lda.w #$0000
	sta.b a1+2
.loop:		;find the fight penalty of the a0 player
	inc.b a1
	inc.b a1
	lda.b [a1]
	and.w #$00FF
	cmp.w #PenFight
	bne .loop
	lda.b [a1]
	xba
	and.w #$000F
	sta.b d0
	ldy.b a0
	cmp.w SCnum,y		; penalty of the a0 player?
	bne .loop
	sep #$20
	lda.b #PenFighting		; it becomes PenFighting
	sta.b [a1]
	rep #$20
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$003C		; 60
	sta.w Pencntdwn
	lda.w #$FFFF		; temp3(a0) = -1: fight over for him
	sta.w temp3,y
	lda.b crowdlevel
	clc
	adc.w #$0258		; +600
	sta.b crowdlevel
	lda.w #$003C
	sta.b d0
	jsl.l randomd0
	ldy.b a0
	lda.b d0
	sec
	sbc.w aggress,y		; random 60 vs the winner aggress: injury?
	beq .inj
	bmi .v1
	bvs .inj
	bra .noinj
.v1:
	bvs .noinj
.inj:		;player X is injured
	lda.w #$00B4		; 180: player is injured
	sta.w Pencntdwn
	lda.w pflags,x
	ora.w #pf2inj
	sta.w pflags,x
	lda.w #SPAfinjury
	sta.b d1
	jsl.l SetSPA
	stx.b a2
	jsl.l setInjuryType		; setInjuryType (bank $8F): d1 = roster offset, bank $8F
	lda.b a0
	beq .team
	lda.w #$0034
.team:
	clc
	adc.b d1
	tay
	lda.w #INJfight		; tmpdst of the injured player = INJfight
	sta.w tmpdst,y
	lda.w #$0003
	sta.w InjCntDown		; InjCntDown = 3
	stz.w Xvel,x
	jmp.w chkhit_ex
.noinj:
	lda.w #SPAffall
	sta.b d1
	jsl.l SetSPA
	stz.b a2
	lda.w #SFXcrowdcheer		; home won: cheer
	pha
	lda.w pfteam,x
	bne .snd
	lda.w #$0002
	sta.b a2
	lda.w #SFXcrowdboo
	sta.b $01,s
.snd:
	jsl.l sfx
	jmp.w chkhit_ex
assfwatch:		;asstab $15. for player who is watching fight
		;   SNES: for a player watching a fight: skate to a spot 80 pixels from the fight
	lda.w pfalock,x
	beq .joy
	jmp.w .rts
.joy:
	lda.w pflags,x
	bit.w #pfjoycon		; joystick controlled
	beq .na
	jmp.w .rts
.na:
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stz.w temp1,x
.nna:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .spot
	jmp.w .go
.spot:		;new spot every second
	adc.w #$003C		; +60
	sta.w temp1,x
	lda.w Ypos,x
	sec
	sbc.w yc1
	pha
	lda.w Xpos,x
	sec
	sbc.w xc1
	pha
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b $03,s
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b mulres+2
	adc.b d0+2
	sta.b d0+2
	jsl.l sroot		; distance to the fight
	lda.b d0
	bne .d
	lda.w #$0001
.d:
	sta.b d2
	pla
	sta.b d0
	sta.b mulb
	pla
	sta.b d1
	lda.w #$0050		; 80 pixels from the fight
	sta.b mula
	jsl.l muls32
	lda.b d2
	sta.b mula
	jsl.l divs
	adc.w xc1
	sta.b d0
	lda.w #$007E		; x within +-$7E
	sta.b d3
	lda.b d0
	sec
	sbc.b d3
	bmi .v1
	bvc .cl1
	bra .x0
.v1:
	bvc .x0
.cl1:
	lda.b d3
	sta.b d0
.x0:
	lda.b d3
	eor.w #$FFFF
	inc a
	sta.b d3
	lda.b d0
	sec
	sbc.b d3
	beq .cl2
	bmi .v2
	bvs .cl2
	bra .x1
.v2:
	bvs .x1
.cl2:
	lda.b d3
	sta.b d0
.x1:
	lda.b d0
	sta.w temp3,x
	lda.w #$0050
	sta.b mula
	lda.b d1
	sta.b mulb
	jsl.l muls32
	lda.b d2
	sta.b mula
	jsl.l divs
	adc.w yc1
	sta.w temp4,x
.go:
	lda.w temp3,x
	sta.b d0
	lda.w temp4,x
	sta.b d1
	lda.w #rtss		; a0 = rtss
	sta.b a0
	lda.w #rtss>>16
	sta.b a0+2
	lda.w Xvel,x		; halve the velocity while watching
	pha
	asl a
	pla
	ror a
	sta.w Xvel,x
	lda.w Yvel,x
	pha
	asl a
	pla
	ror a
	sta.w Yvel,x
	jsl.l skateto		; bank $88 (d0/d1 = spot, [a0] = arrival routine)
	jmp.w check4check
.rts:
	rtl
assfaceoff:		;asstab $16. players do nothing until faceoff is over
		;   SNES: also starts the goal / period / mid-period music cues
	lda.w pfalock,x
	bne .rts
	lda.w sflags
	bit.w #sf2faceoff		; faceoff over: exit
	beq assexit
	lda.w goalcue		; home goal music cue
	beq .per
	stz.w goalcue
	lda.w #$0001		; hold and clear the sound queue
	sta.b sndlock
	stz.b sndqin
	stz.b sndqout
	jsl.l StartSong1		; bank $89: home goal music cue
.per:
	lda.w percue		; period start music cue
	beq .mid
	stz.w percue
	lda.w #$0001
	sta.b sndlock
	stz.b sndqin
	stz.b sndqout
	jsl.l StartSong2		; bank $89: period start music cue
.mid:
	lda.w cuetimer		; no cue playing, clock >= 60 and past midpercue: mid-period cue
	bne .rts
	lda.w gameclock
	cmp.w #$003C
	bcc .rts
	cmp.w midpercue
	bcs .rts
	stz.w midpercue
	jsl.l StartSong5		; bank $89: mid-period music cue
.rts:
	rtl
assexit:		;exit current assignment on player a3
		;   SNES: exit the current assignment of player X
	lda.w assnum,x
	inc a		; next assignment
	and.w #$0007
	sta.w assnum,x
	lda.w pflags,x
	ora.w #pfna		; pfna
	sta.w pflags,x
	rtl
assfaceoffpl:		;asstab $17. assignment for players actually participating in faceoff
		;   SNES: assignment for the players taking the faceoff
	lda.w pfalock,x
	beq .go
	jmp.w .rts
.go:
	lda.w sflags
	bit.w #sf2faceoff		; faceoff over
	beq .exit
	lda.w pflags,x
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stz.w temp1,x
.nna:
	lda.w #fofdata2		; a0 = fofdata2, +4 for the visitors
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	lda.w pfteam,x
	beq .0
	lda.w #fofdata2+4
	sta.b a0
.0:
	lda.w SPAnum,x		; frame = SPAnum/4 + 1, +3 for a righty
	lsr a
	lsr a
	inc a
	sta.b d0
	lda.w handed,x
	bne .lefty
	inc.b d0
	inc.b d0
	inc.b d0
.lefty:
	lda.b d0
	sta.b [a0]
	lda.w pflags,x
	bit.w #pfjoycon		; joystick: the player pulls
	bne .rts
	lda.w pf2aip,x		; set pf2aip, test the old value
	pha
	lda.w #$0001
	sta.w pf2aip,x
	pla
	cmp.w #$0000
	bne .rts
	lda.w #SPAfaceoff
	sta.b d1
	lda.w temp1+puckobj		; puck temp1 > $10: 7 in 8 reverse pull
	cmp.w #$0011
	bcc .d
	lda.w #$0008
	sta.b d0
	jsl.l randomd0
	lda.b d0
	beq .d
	lda.w #SPAfaceoffr
	sta.b d1
.d:
	lda.w #$0001
	sta.w pf2aip,x
	jmp.w SetSPA
.rts:
	rtl
.exit:
	lda.w #$0014		; nopuck = 20
	sta.w nopuck,x
	jmp.w assexit

org $8097AC
pucknorm:		;asstab $18. assignment for puck most of the time. a3 = puck, d7 = elapse frames since last call
		;   SNES: assignment for the puck most of the time. X = puck, d7 = elapsed frames
	lda.w #pfna
	trb.w pflags+puckobj		; pfna
	beq .nna
	stz.w temp1+puckobj		; temp1 = 0, temp2b = still puck timer 120
	stz.w temp2+puckobj
	lda.w #$0078
	sta.w temp2b+puckobj
.nna:
	lda.w puckcross+2		; puckcross times count down
	sec
	sbc.b d7
	sta.w puckcross+2
	lda.w puckcross+6
	sec
	sbc.b d7
	sta.w puckcross+6
	lda.w temp1+puckobj		; every 5 frames: findpc
	sec
	sbc.b d7
	sta.w temp1+puckobj
	bpl .c0
	adc.w #$0005
	sta.w temp1+puckobj
	jsl.l findpc
.c0:		;puck carried: pull it a quarter of the way to the carrier hot spot
	lda.w puckc		; puck carrier
	bmi .nothandled
	asl a
	sta.b a2
	jsl.l a2touchpuck
	lda.b a2
	jsl.l GetHot
	ldy.b a2
	lda.b d0
	clc
	adc.w Xpos,y
	sec
	sbc.w puckx
	lsr a
	lsr a
	bit.w #$2000		; asr #2
	beq .x
	ora.w #$C000
.x:
	clc
	adc.w puckx
	sta.w puckx
	lda.b d1
	clc
	adc.w Ypos,y
	sec
	sbc.w pucky
	lsr a
	lsr a
	bit.w #$2000
	beq .y
	ora.w #$C000
.y:
	clc
	adc.w pucky
	sta.w pucky
	lda.w Xvel,y		; puck velocity = carrier velocity
	sta.w puckvx
	lda.w Yvel,y
	sta.w puckvy
.nothandled:
	jsl.l puckIChk
	jsl.l ChkOffsides
	lda.w gmclock		; clock stopped
	bne .z
	lda.w puckc		; loose puck that has not moved for 120 calls: whistle
	bpl .mv
	lda.w puckx
	cmp.w OldXpos+puckobj
	bne .mv
	lda.w pucky
	cmp.w OldYpos+puckobj
	bne .mv
	lda.w #PenOOP		; PenOOP: whistle
	sta.b d0
	dec.w temp2b+puckobj
	bpl .np
	jsl.l AddPenalty2
.np:
	bra .z
.mv:		;reset the still puck timer
	lda.w #$0078
	sta.w temp2b+puckobj
.z:
	lda.w puckvz		; puck in the air: no unflip
	and.w #$FF00
	ora.w Zpos+puckobj
	beq .flat
	jmp.w checkpuckcoll
.flat:
	jsl.l pucknothing		; pucknothing: stop spinning
	jmp.w checkpuckcoll		; bra checkpuckcoll
findpc:		;find puck crossing lines: calculate when puck will cross goalline (if at all). Called from pucknorm
		;   SNES: when and where will the puck cross each goal line
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
	lda.w #blueline+goalline		; top goal line (blueline+goalline)
	sta.b d4
	ldy.w #$0000
	jsl.l findpc_calc
	lda.w #-(blueline+goalline)		; bottom goal line
	sta.b d4
	ldy.w #$0004
	jsl.l findpc_calc
	stx.b xsave
	ldx.w #$0012
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
findpc_calc:		;d4 = goal line y, Y = puckcross entry offset
	lda.b d4		; d0 = line - pucky
	sec
	sbc.w pucky
	sta.b d0
	lda.w puckvy
	bne .div
	jmp.w .nocross
.div:
	sta.b mula
	lda.b d0		; mulb = d0 << 12
	stz.b mulb
	lsr a
	ror.b mulb
	lsr a
	ror.b mulb
	lsr a
	ror.b mulb
	lsr a
	ror.b mulb
	bit.w #$0800
	beq .hi
	ora.w #$F000
.hi:
	sta.b mulb+2
	jsl.l divs
	bpl .time
	jmp.w .nocross
.time:
	sta.w puckcross+2,y		; frames until crossing
	lda.w puckvx
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l muls32		; x offset = puckvx*d0/puckvy, if it fits
	lda.w puckvy
	bit.w #$8000
	beq .vy
	eor.w #$FFFF
	inc a
.vy:
	sta.b mula
	lda.b mulres+2
	bit.w #$8000
	beq .ov
	eor.w #$FFFF
	inc a
.ov:
	cmp.b mula
	bcs .nocross
	lda.w puckvy
	sta.b mula
	jsl.l divs
	adc.w puckx
	sta.b d0
	sec
	sbc.w #$0088		; sideline $88
	bmi .v1
	bvc .o1
	bra .o1b
.v1:
	bvc .o1b
.o1:		;bounce off the right side boards
	lda.w #$0198		; 3*$88 - x
	sec
	sbc.b d0
	sta.b d0
.o1b:
	lda.b d0
	sec
	sbc.w #$FF78
	beq .o2
	bmi .v2
	bvs .o2
	bra .o2b
.v2:
	bvs .o2b
.o2:		;bounce off the left side boards
	lda.w #$FE68		; -3*$88 - x
	sec
	sbc.b d0
	sta.b d0
.o2b:
	lda.b d0
	sta.w puckcross,y
	bra .rtl
.nocross:
	lda.w #$FFFF
	sta.w puckcross+2,y
.rtl:
	rtl

org $8099C7
a2touchpuck:		;player a2 touches puck. Look for penalties/offsides/other junk. Called from pucknorm, puckstick and others
		;   SNES: last touch, offsides, icing
	ldy.b a2
	lda.w Xpos,y
	sta.w ltx		; ltx/lty/ltplayer
	lda.w Ypos,y
	sta.w lty
	tya
	lsr a
	sta.w ltplayer
	stz.b a0		; a0 = team
	lda.w pfteam,y
	beq .t
	inc.b a0
	inc.b a0
.t:
	lda.w pnum,y
	sta.b d0
	ldy.b a0
	cmp.w tmtouch1,y		; same player as the last touch: no change
	beq .same
	lda.w tmflags,y
	bit.w #tmflast		; tmflast: overwrite the last touch only
	beq .shift
	and.w #~tmflast&$FFFF
	sta.w tmflags,y
	bra .st
.shift:		;shift the touch list down
	lda.w tmtouch2,y
	sta.w tmtouch3,y
	lda.w tmtouch1,y
	sta.w tmtouch2,y
.st:
	lda.b d0
	sta.w tmtouch1,y
	cmp.w tmtouch3,y		; also the third touch: drop it
	bne .same
	lda.w #$FFFF
	sta.w tmtouch3,y
.same:
	lda.w #sf2shot		; sf2shot
	trb.w sflags
	jsl.l a2offsides
	ldy.b a2
	lda.w iflags		; ifok and ifcgl and a skater: icing
	bit.w #ifok
	beq .notice
	bit.w #ifcgl
	beq .notice
	lda.w position,y
	beq .notice
	lda.w iflags
	bit.w #ifdir
	bne .up
	lda.w pfgoal,y
	beq .notice
.icing:		;icing on icingPlayer
	phx
	lda.w iflags+1		; X = icingPlayer
	and.w #$00FF
	asl a
	sta.b a3
	tax
	lda.w #PenIcing		; PenIcing
	sta.b d0
	jsl.l AddPenalty		; AddPenalty
	plx
	stx.b a3
.rtl:
	rtl
.up:
	lda.w pfgoal,y
	beq .icing
.notice:		;start a new icing watch for player a2
	tya
	lsr a
	xba
	sta.w iflags		; iflags = 0, icingPlayer = a2
	lda.w pucky
	sta.b d0
	lda.w pfgoal,y
	beq .zero
	lda.w #ifdir		; ifdir
	tsb.w iflags
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.zero:
	lda.b d0
	bmi .rtl
	lda.w tmap		; own team not short-handed?
	sec
	sbc.w tmap+2
	sta.b d0
	lda.w pfteam,y
	beq .men
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.men:
	lda.b d0
	bmi .rtl
	lda.w #ifok		; ifok
	tsb.w iflags
	rtl
a2offsides:		;player a2 touched the puck: offsides penalty if his team is flagged and the puck is past the blue line. Called from a2touchpuck
		;   SNES: offsides if his team is flagged and the puck is past the blue line
	ldy.b a2
	lda.w gmode
	bit.w #gmoffs
	beq .rtl
	lda.w pucky
	sta.b d0
	lda.w pfgoal,y
	bne .0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.0:
	lda.b d0
	sec
	sbc.w #blueline		; blueline
	bmi .v1
	bvc .team
	bra .rtl
.v1:
	bvc .rtl
.team:
	stz.b a0
	lda.w pfteam,y
	beq .1
	lda.w #$0002
	sta.b a0
.1:
	ldy.b a0
	lda.w tmflags,y
	bit.w #tmfoffside		; team flagged offsides
	beq .rtl
	lda.w gmode
	bit.w #gmhl		; gmhl
	bne .rtl
	ldx.b a2		; exg a2,a3
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w #PenOffsides		; PenOffsides
	sta.b d0
	jsl.l AddPenalty		; AddPenalty
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
.rtl:
	rtl
GetHot:		;push long address of structure to get hot spot from. Hot spot x/y returned in d0/d1. Reads a byte pair per frame from HotList
		;   SNES: A = object index; d0/d1 = its hot spot x/y from HotList (a byte pair per frame)
	phx
	tay
	stz.b d0
	stz.b d1
	lda.w frame,y
	cmp.w #$0179		; the SNES frame list skips 6 frames from $179
	bcc .remap
	sbc.w #$0006
.remap:
	cmp.w #$0226		; frames 1-$225 have hot spots
	bcs .ex
	dec a
	bmi .ex
	asl a
	tax
	lda.l HotList,x		; HotList x (bank $84)
	and.w #$00FF
	bit.w #$0080
	beq .hx
	ora.w #$FF00
.hx:
	sta.b d0
	lda.l HotList+1,x		; HotList y
	and.w #$00FF
	bit.w #$0080
	beq .hy
	ora.w #$FF00
.hy:
	sta.b d1
	lda.w attribute,y
	bit.w #attrxflip		; x flip
	beq .nox
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.nox:
	lda.w attribute,y
	bit.w #attryflip		; y flip (clear = negate)
	bne .noy
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.noy:
	lda.w sfhormode		; horizontal mode: rotate
	beq .ex
	lda.b d0
	ldy.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
	sty.b d0
.ex:
	plx
	rtl
puckIChk:		;check for icing of puck penalty. Called from pucknorm
		;   SNES: sets ifcgl once the loose puck crosses the far goal line
	lda.w iflags
	bit.w #ifok		; ifok and not ifcgl, puck loose
	beq .rtl
	bit.w #ifcgl
	bne .rtl
	lda.w puckc
	bpl .rtl
	lda.w #blueline+goalline		; blueline+goalline
	sta.b d0
	lda.w iflags
	bit.w #ifdir
	bne .0
	lda.w #-(blueline+goalline)
	sec
	sbc.w pucky
	beq .rtl
	bmi .v1
	bvs .rtl
	bra .set
.v1:
	bvs .set
.rtl:
	rtl
.0:
	lda.w #blueline+goalline
	sec
	sbc.w pucky
	beq .set
	bmi .v2
	bvs .set
	bra .rtl
.v2:
	bvs .rtl
.set:
	lda.w #ifcgl		; ifcgl
	tsb.w iflags
	rtl
ChkOffsides:		;check for offsides penalty. a3 = puck. Flags the whole team (tmflags bit 4; 92 flagged each player). Called from pucknorm
		;   SNES: flag a team offsides when the puck crosses its blue line. Called from pucknorm
	lda.w gmode
	bit.w #gmoffs
	beq .rtl
	stz.b a1		; a1 = home, a2 = away; then swapped
	lda.w #$0002
	sta.b a2
	jsl.l ClearOffsidesIfAllPlayers
	stz.b a2
	lda.w #$0002
	sta.b a1
	jsl.l ClearOffsidesIfAllPlayers
	lda.w #blueline-4		; blueline-4
	sta.b d0
	sec
	sbc.w pucky
	beq .top
	bmi .v1
	bvs .top
	bra .neg
.v1:
	bvs .neg
.top:		;puck crossed the top line this frame?
	lda.w #blueline-4
	sec
	sbc.w OldYpos+puckobj
	beq .rtl
	bmi .v2
	bvc .t
	bra .rtl
.v2:
	bvc .rtl
.t:
	lda.w #blueline-4+$A		; +$A
	sta.b d0
	lda.w gmode
	bit.w #gmdir		; gmdir
	beq .t0
	lda.b a2
	ldy.b a1
	sta.b a1
	sty.b a2
.t0:
	lda.w #$0005
	sta.b d2
	ldy.b a2
	lda.w tmsort,y
	sta.b a0
.0:
	ldy.b a0
	lda.w position,y
	bmi .1
	lda.b d0
	sec
	sbc.w Ypos,y
	bmi .v3
	bvs .set0
	bra .1
.v3:
	bvs .1
.set0:
	ldy.b a2
	lda.w tmflags,y
	ora.w #tmfoffside		; tmfoffside
	sta.w tmflags,y
.rtl:
	rtl
.1:
	inc.b a0
	inc.b a0
	dec.b d2
	bpl .0
	rtl
.neg:		;bottom line
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	sec
	sbc.w pucky
	bmi .v4
	bvc .b1
	bra .rtl
.v4:
	bvc .rtl
.b1:
	lda.b d0
	sec
	sbc.w OldYpos+puckobj
	bmi .v5
	bvs .b2
	bra .rtl
.v5:
	bvs .rtl
.b2:
	lda.b d0
	sec
	sbc.w #$000A		; -$A
	sta.b d0
	lda.w gmode
	bit.w #gmdir
	bne .t1
	lda.b a2
	ldy.b a1
	sta.b a1
	sty.b a2
.t1:
	lda.w #$0005
	sta.b d2
	ldy.b a2
	lda.w tmsort,y
	sta.b a0
.2:
	ldy.b a0
	lda.w position,y
	bmi .3
	lda.b d0
	sec
	sbc.w Ypos,y
	beq .3
	bmi .v6
	bvc .set2
	bra .3
.v6:
	bvc .3
.set2:
	ldy.b a2
	lda.w tmflags,y
	ora.w #tmfoffside
	sta.w tmflags,y
	rtl
.3:
	inc.b a0
	inc.b a0
	dec.b d2
	bpl .2
	rtl
ClearOffsidesIfAllPlayers:		;a2 = team struct. Clears the team offsides flag (tmflags bit 4) once no skater on ice is past the blue line ($58, sign by pfgoal). Called twice from ChkOffsides
		;   SNES: clear tmfoffside once no skater is past the blue line
	ldy.b a2
	lda.w tmflags,y		; tmfoffside
	bit.w #tmfoffside
	bne .go
	jmp.w ChkOffsides_rtl
.go:
	lda.w tmsort,y
	sta.b a0
	lda.w #$0005
	sta.b d1
.top:
	ldy.b a0
	lda.w position,y
	bmi .next
	lda.w Ypos,y
	sta.b d0
	lda.w pfgoal,y
	bne .next
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.next:
	inc.b a0
	inc.b a0
	lda.b d0
	sec
	sbc.w #blueline
	beq .more
	bmi .v1
	bvs .more
.rtl:
	jmp.w ChkOffsides_rtl
.v1:
	bvs .rtl
.more:
	dec.b d1
	bpl .top
	ldy.b a2
	lda.w tmflags,y
	and.w #~tmfoffside&$FFFF		; clear tmfoffside
	sta.w tmflags,y
	rtl

org $80A148
setc1player:		;restore old player and switch to new d0 player on cont. 1
		;   SNES: restore the old player and give controller 1 to player d0
	lda.b d0
	cmp.w c1playernum
	beq .rtl
	lda.w c1playernum
	sta.b d1
	jsl.l restorepl
	lda.b d0
	sta.w c1playernum
.rtl:
	rtl
setc2player:		;restore old player and switch to new d0 player on cont. 2
		;   SNES: same for controller 2
	lda.b d0
	cmp.w c2playernum
	beq .rtl
	lda.w c2playernum
	sta.b d1
	jsl.l restorepl
	lda.b d0
	sta.w c2playernum
.rtl:
	rtl
restorepl:		;Restore old joy controlled player d1, give d0
		;   SNES: release old joystick player d1, give d0 the joystick. A player in line change mode keeps control (d0 = d1)
	stz.b a0
	lda.b d1
	bmi .spd
	cmp.w #$000C		; only players 0-11
	bcs .spd
	asl.b d1
	ldy.b d1
	lda.w pflags,y
	bit.w #pf2lcm		; pf2lcm: he keeps the joystick
	beq .rel
	lsr.b d1
	lda.b d1
	sta.b d0
	rtl
.rel:		;release the old player: clear pfjoycon, set pfna
	and.w #~pfjoycon&$FFFF		; clear pfjoycon, set pfna
	ora.w #pfna
	sta.w pflags,y
.spd:		;set pfjoycon on the new player
	lda.b d0
	bmi .rtl
	cmp.w #$000C
	bcs .rtl
	sta.b d1
	asl.b d1
	ldy.b d1
	lda.w pflags,y
	ora.w #pfjoycon
	sta.w pflags,y
.rtl:
	rtl

org $80A52A
pucknothing:		;asstab $1A. puck just slides along. Rev A listing labels this puckunflip
		;   SNES: puckunflip ( / ): puck just slides; stop spinning
	lda.w SPAnum+puckobj
	cmp.w #$0008		; SPAnum 2*4..6*4: flip the face
	bcc .k
	cmp.w #$0018
	bcs .k
	lda.w facedir+puckobj
	eor.w #$0002
	sta.w facedir+puckobj
.k:
	lda.w #$0004		; facedir |= 4
	tsb.w facedir+puckobj
	stz.w SPAnum+puckobj		; SPAnum = 0, SPAcnt = -1 (restart)
	lda.w #$FFFF
	sta.w SPAcnt+puckobj
	rtl
puckfaceoff:		;asstab $1B. puckfaceoff : this is where the action starts: period end checks, goalies, line change boxes, then pfaceoff2
	lda.w pflags,x
	bit.w #pfna
	bne .first
	jmp.w .nna
.first:
	and.w #~pfna&$FFFF
	sta.w pflags,x
	lda.w gameclock		; clock out: PeriodOver
	bne .g6
	jml.l PeriodOver		; bank $8D
.g6:
	lda.w gmode
	bit.w #gmendper
	beq .ot
	jml.l PeriodOver		; bank $8D
.ot:
	lda.w gsp		; overtime and not tied: clockcont_0
	cmp.w #$0003
	bne .npo
	lda.w tmscore
	cmp.w tmscore+2
	beq .npo
	jml.l clockcont_0		; bank $8F
.npo:
	lda.w gmode
	bit.w #gmpendel		; gmpendel: Stop4Pen
	beq .rg
	jmp.w Stop4Pen
.rg:
	jsl.l ReturnGoalies		; ReturnGoalies
	lda.w #$FFFF		; temp1/temp2 = -1: no lc box timers
	sta.w temp1,x
	sta.w temp2,x
	lda.w OptLine		; line changes off
	beq .lines
	jmp.w .nna
.lines:		;line changes on: no team in lc mode, clear pf2lcm on all 12 players
	lda.w #tmflc
	trb.w tmflags
	trb.w tmflags+2
	ldy.w #$0016
.lcm:
	lda.w pflags,y
	and.w #~pf2lcm&$FFFF
	sta.w pflags,y
	dey
	dey
	bpl .lcm
	lda.w cont1team		; a controlled team in horizontal mode: back to vertical
	ora.w cont2team
	beq .nohor
	lda.w sfhormode
	beq .nohor
	lda.w #sfslock
	tsb.w sflags
	jsl.l ClrHor
.nohor:
	lda.w c1playernum		; controller players get the lc box
	sta.b d0
	bmi .nlp
	jsl.l .slc
.nlp:
	lda.w c2playernum
	sta.b d0
	bmi .nlp2
	jsl.l .slc
.nlp2:
	stz.b a1		; a1 = home, a2 = away
	lda.w #$0002
	sta.b a2
	sta.b d0
	jsl.l .sclc
	bra .nna
.sclc:		;d0 = team (1/2), a2/a1 = team/other: computer line change unless that team is on a controller
	lda.w OptLine
	bne .rtl
	lda.b d0
	cmp.w cont1team
	beq .rtl
	cmp.w cont2team
	beq .rtl
	jsl.l CompLine		; bank $8F
	jsl.l setpersonel
	jml.l printscores1		; bank $89
.slc:		;controlled player d0 gets the line change box
	ldy.b a3
	sty.b a2
	lda.b d0
	asl a		; exg a2,a3: X = the controlled player
	sta.b d0
	sta.b a3
	tax
	lda.w pflags,x
	and.w #~pf2lcm&$FFFF
	sta.w pflags,x
	phy
	lda.w #$FFFF		; lcplayer = -1
	sta.w lcplayer
	jsl.l SetLCmode
	ply
	sty.b a2
	ldx.b a3
	lda.w pflags,x
	bit.w #pf2lcm		; pf2lcm: the box opened
	beq .slcex
	lda.w pfteam,x
	beq .t1
	lda.w #$0168		; visitors: temp2 = 6*60, temp4 = SCnum
	sta.w temp2,y
	txa
	lsr a
	sta.w temp4,y
	bra .slcex
.t1:
	lda.w #$0258		; home: temp1 = 10*60, temp3 = SCnum
	sta.w temp1,y
	txa
	lsr a
	sta.w temp3,y
.slcex:
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
.rtl:
	rtl
.nna:		;count down the two lc box timers (temp1/temp2); both done: pfaceoff2
	stz.b d0
	jsl.l .clc
	lda.w #$0020		; temp2/temp4
	sta.b d0
	jsl.l .clc
	ldx.b a3
	lda.w temp1,x
	bpl .rtl
	lda.w temp2,x
	bpl .rtl
	stz.b a2		; a2 = home, a1 = away
	lda.w #$0001
	sta.b d0
	inc a
	sta.b a1
	jsl.l .sclc
	lda.w #pfaceoff2		; pfaceoff2
	sta.b d0
	ldx.b a3
	jmp.w assreplace
.clc:		;d0 = 0 (temp1/temp3) or $20 (temp2/temp4): update one lc box timer
	lda.b a3
	clc
	adc.b d0
	tay
	lda.w temp1,y
	bmi .rtl
	lda.w temp3,y		; temp3/temp4 = SCnum of the box owner
	asl a
	sta.b d1
	tay
	stz.b a0
	stz.b a2
	lda.w pfteam,y
	beq .clh
	lda.w #$0002
	sta.b a2
.clh:
	lda.w pflags,y
	bit.w #pf2lcm		; pf2lcm still on?
	bne .clnd
	lda.b a3
	clc
	adc.b d0
	tay
	lda.w temp1,y
	ora.w #$FF00		; timer negative: box closed
	sta.w temp1,y
	ldx.b a3
	jmp.w SetLCmode2
.clnd:
	lda.b a3
	clc
	adc.b d0
	tay
	lda.w temp1,y
	sec
	sbc.b d7		; count down
	sta.w temp1,y
	bmi .clcex
	jmp.w .rtl
.clcex:
	ldx.b a3
	phx
	ldx.b d1
	stx.b a3
	lda.w pflags,x
	bit.w #pf2lcm		; still in lc mode: lcfound with choice 0
	beq .pop
	stz.b d2
	jsl.l lcfound		; bank $8F
	jsl.l SetLCmode2
.pop:
	plx
	stx.b a3
	rtl
SetLCmode:		;Initiate line change option if available (abut
		;   SNES: open the line change box for player X (abut of the puck carrier)
	lda.w OptLine
	bne .rtl
	jsl.l loadTeamStruct		; loadTeamStruct: a2 = team of X, bank $8F
	ldy.b a2
	lda.w tmflags,y
	bit.w #tmflc		; tmflc: team already in lc mode
	bne .rtl
	ora.w #tmflc
	sta.w tmflags,y
	lda.w #sfspdir|sfssdir		; clear sfspdir/sfssdir
	trb.w sflags
	lda.w pflags,x
	ora.w #pf2lcm		; pf2lcm
	sta.w pflags,x
	lda.w lcplayer		; remember the player when lcplayer = $FFFE
	cmp.w #$FFFE
	bne .show
	txa
	lsr a
	sta.w lcplayer
.show:
	jmp.w SetLCmode2
.rtl:
	rtl
SetLCmode2:		;a2 = team struct for lc. Draw the lc box with
		;   SNES: draw the lc box, one row per eligible line (button letter + line name)
	jsl.l setlccords
	inc.b d0		; box size +1
	inc.b d1
	lda.w blankchar		; d2 = blank tile
	sta.b d2
	lda.b fobox		; faceoff box up: do not clear
	bne .cords
	jsl.l eraser		; bank $8D (d0/d1 size, d2 tile)
.cords:
	jsl.l setlccords
	lda.w printy		; lower half of the screen?
	sec
	sbc.w #$000F
	bmi .v1
	bvc .lower
	bra .box
.v1:
	bvc .box
.lower:		;lower box: sf3llcs
	lda.w #sf3llcs
	tsb.w sflags3
	bra .frame
.box:
	jsl.l box		; bank $8F
	jsl.l setlccords
.frame:
	jsl.l Framer		; bank $8F (d0/d1 size)
	dec.w printy		; printy -= 2, printx += 1
	dec.w printy
	inc.w printx
	lda.w #$0002
	sta.b d4
	lda.w printx
	pha
.loop:		;rows 2..0: button letter, line name, energy bar
	lda.b $01,s
	sta.w printx
	lda.b d4
	sta.b d0
	jsl.l getlchoice		; bank $8A
	lda.b d0
	bmi .next
	ldy.b a2
	lda.w tmflags,y
	bit.w #tmflc		; tmflc: show every row
	bne .pr
	lda.b d4
	cmp.w tmlcchoice,y		; box being closed: only the chosen row
	bne .up
	lda.w tmline,y
	sta.b d0
.pr:
	lda.w #mesarea		; mesarea = 4, button letter
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #$0004
	sta.b [a1]
	phx
	ldx.b d4
	lda.l .btn,x
	plx
	and.w #$00FF
	ora.w #$2000		; text attribute $20
	ldy.w #$0002
	sta.b [a1],y
	jsl.l print
	lda.b d0
	pha
	lda.w #linelist		; linelist (bank $8F)
	sta.b a1
	lda.w #linelist>>16
	sta.b a1+2
	jsl.l PrintStringFromList		; bank $8F
	pla
	sta.b d0
	jsl.l linebar		; bank $8F
.up:
	dec.w printy
.next:
	dec.b d4
	bpl .loop
	pla
	clc
	adc.w #$0005
	sta.w printx
	ldy.b a2
	lda.w #TeamList>>16		; team name: [tmdata] + its offsets (bank $83)
	sta.b a1+2
	lda.w tmdata,y
	sta.b a1
	ldy.w #Teamname
	clc
	adc.b [a1],y
	sta.b a1
	adc.b [a1]
	sta.b a1
	jmp.w print
.btn:		;SNES button letter for lc rows 0-2
	db "YBA"

org $80A87C
puckfaceoff2:		;asstab $1C. puckfaceoff2 : face off control logic and general setup for action
	lda.w pflags,x
	bit.w #pfna
	bne .first
	jmp.w .nna
.first:		;first time: set up the faceoff
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .pusha
	ldx.b xsave
	lda.b crowdlevel		; limit crowd level
	cmp.w #$0258
	bcc .ntm
	lda.w #$0258
	sta.b crowdlevel
.ntm:
	lda.w #sfpz		; no pause, no lower lc box, no gloves, no icing, no refs, no goalie moves, puck invisible and loose
	trb.w sflags
	lda.w #sf3llcs
	trb.w sflags3
	stz.w glovecords
	stz.w iflags
	lda.w #$FFFF
	sta.w RefCnt
	sta.w puckcross+2
	sta.w puckcross+6
	sta.w Zpos+puckobj
	sta.w puckc
	sta.w passReceiverPlayerNum
	lda.w #sf2refref		; clear sf2refref; faceoff on, replay record off
	trb.w sflags
	lda.w #sf2faceoff|sf2drec
	tsb.w sflags
	jsl.l ClrHor
	stz.w Vpos		; Vpos = Hpos = 0
	stz.w Hpos
	lda.w fox		; puck to the faceoff spot, stopped
	sta.w puckx
	lda.w foy
	sta.w pucky
	stz.w puckvx
	stz.w puckvy
	stz.w puckvz
	stz.w Xvel+$18		; goal nets (objects 12/13) at y +-268
	stz.w Yvel+$18
	stz.w Xpos+$18
	lda.w #$010C
	sta.w Ypos+$18
	stz.w Xvel+$1A
	stz.w Yvel+$1A
	stz.w Xpos+$1A
	lda.w #$FEF4
	sta.w Ypos+$1A
	lda.w #SPFpuck		; object 15 (puck shadow) = SPFpuck
	sta.w frame+$1E
	stz.w SPA+$1E
	stz.w attribute+$1E
	stz.w attribute+puckobj
	lda.w #sfslock		; clear sfslock: free up scrolling
	trb.w sflags
	lda.w #$0064
	sta.b d4
.cw:		;scroll to the faceoff spot
	jsl.l checkwindow
	dec.b d4
	bpl .cw
	lda.w #$003C		; yleader = 60
	sta.w yleader
	jsl.l ResetBench		; ResetBench
	stz.b a2
	jsl.l setpersonel
	jsl.l forcepldata
	inc.b a2
	inc.b a2
	jsl.l setpersonel
	jsl.l forcepldata
	jsl.l resetplstuff		; resetplstuff
	lda.b a3+2		; push a3
	pha
	lda.b a3
	pha
	stz.b a3
	lda.w #$000B
	sta.b d2
.loop:		;each player: assignment and faceoff position
	ldx.b a3
	lda.w #$FF10		; Xpos = -240, off the screen
	sta.w Xpos,x
	stz.w Ypos,x
	stz.w frame,x
	lda.w position,x
	sta.b d1
	bpl .pos
	jmp.w .next
.pos:
	beq .goalie1
	lda.w #afaceoff
	sta.b d0
	lda.b d1
	cmp.w #$0004
	bne .d1ne
	stz.b a2		; center: team touches = him only
	lda.w pfteam,x
	beq .tm
	inc.b a2
	inc.b a2
.tm:
	ldy.b a2
	lda.w pnum,x
	and.w #$00FF
	sta.w tmtouch1,y
	lda.w #$FFFF
	sta.w tmtouch2,y
	sta.w tmtouch3,y
	lda.w tmflags,y
	and.w #~tmflast&$FFFF
	sta.w tmflags,y
	lda.w #afaceoffpl		; afaceoffpl
	sta.b d0
.d1ne:
	jsl.l assinsert
.goalie1:
	lda.w tmap		; d4 = (6-tmap)*8: .apl row
	sta.b d4
	ldx.b a3
	lda.w pfteam,x
	beq .t0
	lda.w tmap+2
	sta.b d4
.t0:
	lda.b d4
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0006
	asl a
	asl a
	asl a
	sta.b d4
	lda.w #.apl>>16
	sta.b a1+2
	lda.w #.apl
	clc
	adc.b d4
	sta.b a1
	ldy.b d1
	lda.b [a1],y
	and.w #$00FF
	asl a
	asl a
	sta.b d4
	lda.w #.ptab
	sta.b a1
	lda.w #.ptab>>16
	sta.b a1+2
	ldy.b d4
	lda.b [a1],y
	sta.b d0
	iny
	iny
	lda.b [a1],y
	sta.b d1
	lda.w pfgoal,x
	bne .f0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.f0:
	lda.w position,x
	beq .goalie2
	lda.b d4		; defense (entry <= 2*4): shift by fox/foy
	sec
	sbc.w #$0008
	beq .def
	bmi .v1
	bvs .def
	bra .nodef
.v1:
	bvs .nodef
.def:
	lda.w fox
	eor.b d0
	bpl .notmid
	lda.w foy
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .mid
	ora.w #$E000
.mid:
	eor.w #$FFFF
	inc a
	clc
	adc.b d1
	sta.b d1
.notmid:
	lda.w fox
	lsr a
	lsr a
	bit.w #$2000
	beq .xadj
	ora.w #$C000
.xadj:
	sta.b d3
	lda.b d0
	sec
	sbc.b d3
	sta.b d0
.nodef:
	lda.b d0
	clc
	adc.w fox
	sta.b d0
	lda.b d1
	clc
	adc.w foy
	sta.b d1
.goalie2:
	lda.b d0
	sta.w Xpos,x
	sec
	sbc.w puckx
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d1
	sta.w Ypos,x
	sec
	sbc.w pucky
	eor.w #$FFFF
	inc a
	sta.b d1
	stz.w Xvel,x
	stz.w Yvel,x
	jsl.l vtoa		; face the puck
	lda.b d0
	sta.w facedir,x
	lda.w pflags,x
	and.w #~pf2unav&$FFFF		; clear pf2unav, pfalock, SPA
	sta.w pflags,x
	stz.w pfalock,x
	stz.w SPA,x
	lda.w #SPAglide
	sta.b d1
	jsl.l SetSPA
.next:
	inc.b a3
	inc.b a3
	dec.b d2
	bmi .done
	jmp.w .loop
.done:
	jsl.l SprSort		; SprSort
	pla
	sta.b a3
	pla
	sta.b a3+2
	ldx.b a3
	jsl.l ResetAndSelectPlayers		; bank $8F
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$00,$00
	lda.w #$0036		; 8+46
	sta.b d0
	lda.w fox
	bpl .fok
	lda.w #$00BE		; (18*8)+46
	sta.b d0
.fok:
	lda.b d0
	sta.w fodropx
	sec
	sbc.w #$002E
	lsr a
	lsr a
	lsr a
	sta.w printx
	lda.w #$005C		; (3*8)+68
	sta.w fodropy
	lda.w #$0003
	sta.w printy
	lda.w printy
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	jsl.l marktextlo		; mark the box rows dirty
	lda.w printy
	clc
	adc.w #$0009
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	adc.w #$000B
	jsl.l marktexthi
	lda.w #FaceOffMap		; fobox nonzero
	sta.b fobox
	sta.b tmp0
	lda.w #FaceOffMap>>16
	sta.b tmp1
	lda.w printy
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	tax
	ldy.w #$0000
	lda.w #$000A
	sta.b tmp1+1
	clc
.row:		;copy the 12x10 FaceOffMap into the text map
	lda.w #$000C
	sta.b tmp2+1
.col:
	lda.b [tmp0],y
	clc
	adc.w faceoffvrcset
	adc.w charofs
	sta.l textmap,x
	iny
	iny
	inx
	inx
	dec.b tmp2+1
	bne .col
	txa
	clc
	adc.w #$0028
	tax
	dec.b tmp1+1
	bne .row
	ldx.b a3
	lda.w OptLine		; line changes on: line names box
	bne .nol
	lda.w printy
	clc
	adc.w #$000A
	sta.w printy
	lda.w #$000C
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l Framer		; bank $8F (d0/d1 size)
	lda.w tmline
	sta.b d0
	lda.w tmline+2
	sta.b d1
	lda.w gmode		; gmdir
	bit.w #gmdir
	bne .nx
	lda.w tmline
	sta.b d1
	lda.w tmline+2
	sta.b d0
.nx:
	inc.w printx
	dec.w printy
	dec.w printy
	lda.w #linelist		; linelist (bank $8F)
	sta.b a1
	lda.w #linelist>>16
	sta.b a1+2
	jsl.l PrintStringFromList		; bank $8F
	inc.w printx
	inc.w printx
	inc.w printx
	inc.w printx
	lda.b d1
	sta.b d0
	lda.w #linelist
	sta.b a1
	lda.w #linelist>>16
	sta.b a1+2
	jsl.l PrintStringFromList		; bank $8F
.nol:		;time for the puck drop: 180-299 frames
	lda.w #$0078
	jsl.l randoma
	adc.w #$00B4
	sta.b d0
	ldx.b a3
	sta.w temp1,x
	lda.w #$0001		; fofdata2: home pull frame 1, away 4, ref 7
	sta.w fofdata2
	lda.w #$8000
	sta.w fofdata2+2
	sta.w fofdata+2
	lda.w #$0004
	sta.w fofdata2+4
	lda.w #$A800
	sta.w fofdata2+6
	lda.w #$0007
	sta.w fofdata
	lda.w gmode
	bit.w #gmdir		; gmdir: flip the attributes
	bne .nfl
	lda.w #$8800
	sta.w fofdata2+2
	lda.w #$A000
	sta.w fofdata2+6
.nfl:
	lda.w #$FFFF		; fodir1/fodir2 = none
	sta.w fodir1
	sta.w fodir2
	stx.b xsave
	ldx.w #$001A
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$001E
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	ldx.b a3
	rtl
.nna:		;count down to the drop; then Endfaceoff
	lda.b d7		; temp1 -= min(d7, temp1)
	sta.b tmp0
	sec
	sbc.w temp1,x
	bmi .v2
	bvc .one
	bra .sub
.v2:
	bvc .sub
.one:
	lda.w #$0001
	sta.b tmp0
.sub:
	lda.w temp1,x
	sec
	sbc.b tmp0
	sta.w temp1,x
	bpl updatefaceoff
	jmp.w Endfaceoff
.apl:		;.ptab entry for each position, by players on ice (6, 5, 4)
	db 0,1,2,3,4,5,6,0		; 6 on ice
	db 0,1,5,3,4,2,0,0		; 5 on ice
	db 0,3,5,1,4,0,0,0		; 4 on ice
.ptab:		;faceoff x/y offsets
	dw 0,-250, -35,-50, 35,-50, -50,-10
	dw 0,-15, 50,-10, 0,-60
updatefaceoff:		;a3 = puck. Drop animation frame from temp1; at 0 erases the faceoff box (92 did that in Endfaceoff). Entered from puckfaceoff2
		;   SNES: X = puck. Drop animation frame from temp1; at 0 erases the faceoff box
	lda.w temp1,x
	beq .erase
	clc		; (temp1+6)/8 <= 2: drop frame 10-d0
	adc.w #$0006
	lsr a
	lsr a
	lsr a
	sta.b d0
	sec
	sbc.w #$0002
	beq .set
	bmi .v1
	bvs .set
	bra .rtl
.v1:
	bvs .rtl
.set:
	lda.b d0
	eor.w #$FFFF
	inc a
	clc
	adc.w #$000A
	sta.b d0
	sta.w fofdata
.rtl:
	rtl
.erase:
	jsl.l printz		; erase the faceoff box
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$00,$00
	lda.w fodropx
	sec
	sbc.w #$002E
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .x
	ora.w #$E000
.x:
	sta.w printx
	lda.w fodropy
	sec
	sbc.w #$0044
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .y
	ora.w #$E000
.y:
	sta.w printy
	lda.w #$000C
	sta.b d0
	inc a
	sta.b d1
	lda.w blankchar
	sta.b d2
	jml.l eraser		; bank $8D (d0/d1 size, d2 tile)
Endfaceoff:		;drop the puck: pick the faceoff winner and send the puck off
	lda.w seed+2		; puck on the ice sound
	and.w #$0003
	clc
	adc.w #SFXshotwiff
	pha
	jsl.l sfx
	lda.w #sf2faceoff		; faceoff over, fobox off, replay record on, clock running
	trb.w sflags
	stz.b fobox
	lda.w #sf2drec
	trb.w sflags
	stz.w gmclock
	stz.w pf2fight,x
	lda.w #sf3fo		; sf3fo
	tsb.w sflags3
	lda.w fodir1		; d3 = fodir1, d4 = $800 (toward the top), a1 = home
	sta.b d3
	lda.w #$0800
	sta.b d4
	stz.b a1
	lda.w #$0010
	sta.b d2
	ldx.w fofdata2
	lda.l .ftab-1,x
	and.w #$00FF
	bit.w #$0080
	beq .f1
	ora.w #$FF00
.f1:
	eor.w #$FFFF
	inc a
	clc
	adc.b d2
	sta.b d2
	ldx.w fofdata2+4
	lda.l .ftab-1,x
	and.w #$00FF
	bit.w #$0080
	beq .f2
	ora.w #$FF00
.f2:
	clc
	adc.b d2
	sta.b d2
	lda.w #$0021		; random(33) vs the pull frames: who won
	jsl.l randoma
	cmp.b d2
	bcs .p1won
	lda.w #$0004		; visitors won
	sta.b a1
.p1won:
	ldx.b a1
	lda.w fofdata2+2,x
	bit.w #$0800		; winner faces down: fodir2, -$800
	beq .pos
	lda.w fodir2
	sta.b d3
	lda.w #$F800
	sta.b d4
.pos:
	lda.b d3
	bit.w #$0008
	bne .nojoy
	and.w #$0007
	sta.b d0
	lda.w seed		; joystick direction 3 in 4
	and.w #$0003
	bne .nj2
.nojoy:
	lda.w #$0005		; random direction -2..2
	jsl.l randoma
	dec a
	dec a
	and.w #$0007
	sta.b d0
	lda.b d4
	bmi .nj2
	lda.b d0
	eor.w #$0004
	sta.b d0
.nj2:
	asl.b d0
	asl.b d0
	ldx.b d0
	lda.l dirtab,x		; Xvel = dirtab x * 32
	asl a
	asl a
	asl a
	asl a
	asl a
	ldx.b a3
	sta.w Xvel,x
	ldx.b d0
	lda.l dirtab+2,x		; Yvel = dirtab y * 32 + d4
	asl a
	asl a
	asl a
	asl a
	asl a
	clc
	adc.b d4
	ldx.b a3
	sta.w Yvel,x
	lda.w #$0800		; Zvel = random(0..$800)
	jsl.l randoma
	sta.w Zvel,x
	stz.w Zpos+puckobj
	stz.w pfnc,x
	lda.w #pnorm		; pnorm
	sta.b d0
	jmp.w assreplace
.ftab:		;faceoff strength by pull frame
	db 0,8,16,0,8,16
dirtab:		;x,y speed for each direction 0-7 (92 runspeed 200, diagonal 141)
	dw 0,200, 141,141, 200,0, 141,-141
	dw 0,-200, -141,-141, -200,0, -141,141

org $80AE9D
changeplayer:		;switch controller d4 (0/2) to the teammate nearest the puck, or sweep check if that is the current player
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .pusha
	ldx.b xsave
	lda.w puckvy		; puck + velocity/256 (lead the puck)
	xba
	and.w #$00FF
	bit.w #$0080
	beq .ly
	ora.w #$FF00
.ly:
	clc
	adc.w pucky
	pha
	lda.w puckvx
	xba
	and.w #$00FF
	bit.w #$0080
	beq .lx
	ora.w #$FF00
.lx:
	clc
	adc.w puckx
	pha
	lda.w #$0005
	sta.b d2
	lda.b d4
	tay
	eor.w #$0002		; d3 = the other controller
	sta.b d3
	lda.w #$FFFF		; d5 = best distance^2
	sta.b d5+2
	ldx.w #$0000
	lda.w cont1team,y		; controller on the home team: players 0-5, else 6-11
	cmp.w #$0001
	beq .t1
	ldx.w #$000C
.t1:
	ldy.b d3
.top:
	lda.w position,x
	bmi .next
	beq .next
	lda.w pflags,x		; pf2unav or pfalock: skip
	and.w #$1000
	ora.w pfalock,x
	bne .next
	lda.b $01,s
	sec
	sbc.w Xpos,x
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b $03,s
	sec
	sbc.w Ypos,x
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b mulres+2
	adc.b d0+2
	sta.b d0+2
	lda.b d5
	cmp.b d0
	lda.b d5+2
	sbc.b d0+2
	bcc .next
	txa
	lsr a
	cmp.w c1playernum,y		; the other controller has him
	beq .next
	sta.b d6
	lda.b d0
	sta.b d5
	lda.b d0+2
	sta.b d5+2
.next:
	inx
	inx
	dec.b d2
	bpl .top
	ldx.b a3
	pla
	pla
	ldy.b d4
	lda.b d6
	cmp.w c1playernum,y		; same player: Sweepcheck
	bne .set
	jsl.l Sweepcheck
	bra .ex
.set:
	sta.b d0
	lda.b d4
	bne .c2
	jsl.l setc1player
	bra .ex
.c2:
	jsl.l setc2player
.ex:
	stx.b xsave
	ldx.w #$0006
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$001A
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl
vtoa:		;d0/d1 are x/y distances which are converted into direction 0-7 and returned in d0 (8 = no direction)
		;   SNES: d0/d1 are x/y distances, returned in d0 as a direction 0-7 (8 = no direction)
	lda.b d0
	ora.b d1
	beq .nodir		; no direction
	stz.b d0+2
	lda.b d0
	bpl .yabs
	eor.w #$FFFF
	inc a
	sta.b d0
	inc.b d0+2
.yabs:
	lda.b d1
	bpl .b2
	eor.w #$FFFF
	inc a
	sta.b d1
	inc.b d0+2
	inc.b d0+2
.b2:
	lda.b d1		; bit 2: |dx| <= 2|dy|
	asl a
	cmp.b d0
	bcc .b3
	lda.w #$0004
	tsb.b d0+2
.b3:
	lda.b d0		; bit 3: |dy| <= 2|dx|
	asl a
	cmp.b d1
	bcc .look
	lda.w #$0008
	tsb.b d0+2
.look:
	phx
	ldx.b d0+2
	lda.l .dt,x
	plx
	and.w #$00FF
	sta.b d0
	rtl
.nodir:
	lda.w #$0008
	sta.b d0
	rtl
.dt:		;direction for each sign/ratio combination
	db 1,7,3,5,0,0,4,4,2,6,2,6,1,7,3,5
SetSPA:		;set sprite animation on struct a3. d1 = new animation
		;   SNES: set sprite animation d1 on object X (restart at frame 0)
	lda.b d1
	cmp.w SPA,x		; same animation: keep going
	beq .rtl
	sta.w SPA,x
	stz.w SPAnum,x		; SPAnum = 0, SPAcnt = -1
	lda.w #$FFFF
	sta.w SPAcnt,x
.rtl:
	rtl

org $80B49D
assinsert:		;insert new assignment on player a3. d0 = assignment. Falls into assreplace
		;   SNES: insert assignment d0 on player X. Falls into assreplace
	lda.w assnum,x		; assnum - 1
	dec a
	and.w #$0007
	sta.w assnum,x
assreplace:		;replace current assignment on player a3. d0 = assignment
		;   SNES: replace the current assignment of player X with d0
	lda.w pflags,x
	ora.w #pfna		; pfna
	sta.w pflags,x
	txa		; asslist+X*4+assnum = d0 (byte)
	asl a
	asl a
	adc.w assnum,x
	tay
	sep #$20
	lda.b d0
	sta.w asslist,y
	rep #$30
	rtl

org $80BAF2
ChkGoalies:		;computer pulls goalie on delayed penalty. Called from periodicevents
		;   SNES: computer pulls the goalie on a delayed penalty. Called from periodicevents
	lda.w gmclock		; clock stopped
	bne ChkGoalies_CPG_rtl
	stz.b a2
	lda.w #$0001
	sta.b d0
	inc a
	sta.b a1
	jsl.l ChkGoalies_CPG
	lda.w #$0002
	sta.b d0
	lda.b a1
	ldy.b a2
	sta.b a2
	sty.b a1
ChkGoalies_CPG:		;d0 = team (1/2), a2/a1 = team/other
	lda.b d0
	cmp.w cont1team		; controlled team: no
	beq .rtl
	cmp.w cont2team
	beq .rtl
	ldy.b a2
	lda.w tmgoalie,y		; goalie already out
	bmi .rtl
	lda.w puckc
	bmi .rtl
	sec
	sbc.w #$0006		; puckc - 6, negated for the away team: negative = team a2 has the puck
	ldy.b a2
	beq .side
	eor.w #$FFFF
	inc a
.side:
	sta.b d0
	cmp.w #$0000
	bpl .rtl
	lda.w pucky
	sta.b d1
	lda.w gmode
	bit.w #gmpendel		; gmpendel
	bne .pull
	jmp.w CPgoalie
.pull:		;delayed penalty: pull the goalie, any team
	lda.w tmgoalie,y
	ora.w #$FF00		; tmgoalie high byte $FF: pulled
	sta.w tmgoalie,y
	jmp.w setpersonel
.rtl:
	rtl

org $80BE47
ReturnGoalies:		;if computer pulled goalie, look to see if computer should return him. Called from puckfaceoff
		;   SNES: if the computer pulled its goalie, should he come back? Called from puckfaceoff
	stz.b a2
	lda.w #$0001
	sta.b d0
	inc a
	sta.b a1
	jsl.l ReturnGoalies_r
	lda.w #$0002
	sta.b d0
	lda.b a1
	ldy.b a2
	sta.b a2
	sty.b a1
ReturnGoalies_r:		;d0 = team (1/2), a2/a1 = team/other
	lda.b d0
	cmp.w cont1team		; controlled team: no
	beq .rtl
	cmp.w cont2team
	beq .rtl
	ldy.b a2
	lda.w tmgoalie,y
	bpl .rtl		; goalie in
	and.w #$00FF
	cmp.w #$000A		; low byte = goalie to return
	bcs .rtl
	sta.w tmgoalie,y
	lda.w foy		; d1 = foy
	sta.b d1
	jmp.w CPgoalie
.rtl:
	rtl
CPgoalie:		;see if computer should pull his goalie. d1 = puck/faceoff y. Falls in from ReturnGoalies; also entered from ChkGoalies
		;   SNES: should the computer pull its goalie? d1 = puck/faceoff y. 3rd period, behind by 2, under a minute
	lda.w gsp		; 3rd period only
	cmp.w #$0002
	bne .rtl
	ldy.b a1
	lda.w tmscore,y
	ldy.b a2
	sec
	sbc.w tmscore,y
	sta.b d0
	bmi .rtl
	cmp.w #$0002		; behind by exactly 2
	bne .rtl
	lda.w gameclock
	cmp.w #$003D		; 60 seconds or less
	bcs .rtl
	lda.w tmsort,y
	tay
	lda.w pfgoal,y		; own half of the faceoff/puck
	bne .side
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.side:
	lda.b d1
	bmi .rtl
	ldy.b a2
	lda.w tmgoalie,y
	ora.w #$FF00		; pull the goalie
	sta.w tmgoalie,y
	jmp.w setpersonel
.rtl:
	rtl

org $80CEC9
puckflip:		;start puck spinning. a3 = puck, d0 bit 0 = flip. Called from checkgoal, wallcoll and others
		;   SNES: start the puck spinning. d0 bit 0 = flip
	lda.b d0
	and.w #$0001		; facedir of the puck ^= d0 bit 0, & 3
	sta.b d0
	eor.w facedir+puckobj
	and.w #$0003
	sta.w facedir+puckobj
	lda.w #$FFFF		; SPAcnt = -1
	sta.w SPAcnt+puckobj
	lda.w #SPApflip
	sta.b d1
	jmp.w SetSPA

org $80DF3F
doinput:		;process controller input
		;   SNES: controller input for player X. d0 = dpad, d1 = new buttons, d4 = controller 0/2
	jsl.l setpads		; setpads; Start: pause
	lda.b d1
	bit.w #JOYSTART
	beq .nostart
	lda.b d4
	bne .pause2
	jml.l startpause1		; bank $8F
.pause2:
	jml.l startpause2
.nostart:
	lda.w sfhormode		; horizontal mode: dpad +90 degrees
	beq .nhor
	lda.b d0
	bit.w #$0008
	bne .nhor
	inc a
	inc a
	and.w #$0007
	sta.b d0
.nhor:
	lda.w sflags		; faceoff in progress
	bit.w #sf2faceoff
	beq .nofo
	jmp.w faceoffinput
.nofo:
	lda.w pflags,x		; line change interface
	bit.w #pf2lcm
	beq .nolcm
	jml.l lineinput		; bank $8A
.nolcm:
	bit.w #pfjoycon		; not joystick controlled: exit
	bne .joy
	jmp.w .rtl
.joy:
	lda.w pfalock,x
	beq .nolock
	jmp.w .islocked
.nolock:
	lda.w pf2fight,x
	beq .nofight
	jml.l fightinput		; bank $8F
.nofight:
	lda.w puckc		; carrier?
	sta.b d5
	txa
	lsr a
	cmp.b d5
	beq .ispc
	lda.b d1
	bit.w #abut
	beq .nohold
	jmp.w holdplayer
.nohold:
	bit.w #bbut
	beq .nob
	jmp.w changeplayer
.nob:		;goalie cannot check
	lda.w position,x
	beq .rtl
	lda.b d1
	bit.w #cbut
	beq .acc
	jmp.w burst
.acc:
	jml.l doplayeracc		; bank $8F
.ispc:		;player is the puck carrier
	jsl.l checkob		; goalie with pf2aip: exit
	lda.w position,x
	bne .pc1
	lda.w pf2aip,x
	bne .rtl
.pc1:
	lda.w sflags
	bit.w #sfspdir
	beq .nopass
	jml.l passmode		; bank $8F
.nopass:
	bit.w #sfssdir
	beq .noshot
	jmp.w ShotMode
.noshot:
	lda.b d1
	bit.w #bbut
	bne .setpassmode
	lda.w sflags		; Y without a faceoff: line change mode
	bit.w #sf2faceoff
	bne .shoot
	lda.b d1
	bit.w #abut
	bne .lc
.shoot:
	lda.w position,x
	beq .rtl
	lda.b d1
	bit.w #cbut
	beq .acc2
	jmp.w SetShotMode
.acc2:
	jml.l doplayeracc		; bank $8F
.lc:
	lda.w lcplayer		; lcplayer $FFFF -> $FFFE
	cmp.w #$FFFF
	bne .setlc
	lda.w #$FFFE
	sta.w lcplayer
.setlc:
	jmp.w SetLCmode
.islocked:		;anim locked: only B (switch player) when not the carrier
	txa
	lsr a
	cmp.w puckc
	beq .rtl
	lda.b d1
	bit.w #$8000
	beq .rtl
	jmp.w changeplayer
.rtl:
	rtl
.setpassmode:		;the goalie keeps the puck behind the net (|x| < 16, |y| $108-$10F)
	lda.w position,x
	bne .set
	lda.w puckx
	bit.w #$8000
	beq .px
	eor.w #$FFFF
	inc a
.px:
	cmp.w #$0010
	bcs .set
	lda.w pucky
	bit.w #$8000
	beq .py
	eor.w #$FFFF
	inc a
.py:
	cmp.w #$0108
	bcc .set
	cmp.w #$0110
	bcc .rtl2
.set:
	lda.w facedir,x		; passdir = facedir; sfspdir
	and.w #$0007
	sta.w passdir
	lda.w #sfspdir
	tsb.w sflags
.rtl2:
	rtl
faceoffinput:		;controller processing for faceoff
		;   SNES: faceoff player X: dpad into fodir1/fodir2, B pulls (SPAfaceoff)
	txa		; faceoff player only
	asl a
	asl a
	adc.w assnum,x
	tay
	lda.w asslist,y
	and.w #$00FF
	cmp.w #afaceoffpl
	bne .rtl
	lda.w #fodir1
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	lda.w pfgoal,x
	beq .store
	lda.w #fodir2
	sta.b a0
	lda.w #$0000
	sta.b a0+2
.store:
	lda.b d0
	sta.b [a0]
	lda.w pf2aip,x		; pf2aip set: already pulling
	bne .rtl
	lda.b d1
	bit.w #bbut
	beq .nob
	lda.w #SPAfaceoff
	sta.b d1
	lda.w #$0001
	sta.w pf2aip,x
	jmp.w SetSPA
.nob:
	lda.w #SPAfaceoffr
	sta.b d1
	jmp.w SetSPA
.rtl:
	rtl
holdplayer:		;abut press hold. a0 = the player this one is
		;   SNES: Y pressed: hold. With impact, hold the last player who hit X (Acheck)
	lda.w #SPAhook		; pfalock
	sta.b d1
	sta.w pfalock,x
	lda.w impact,x
	bne .imp
	jmp.w SetSPA
.imp:
	lda.w impactp,x		; a0 = d0 = impactp*2
	asl a
	sta.b d0
	sta.b a0
	jml.l Acheck		; bank $8F
setpads:		;copy info into pad cont so graphics knows which player/number.
		;   SNES: d4 = pad index (-2 puck carrier, 0/2 controllers, 4 replay target): put SCnum of X in that nibble of PadControlBits
	stx.b xsave
	ldx.w #$0000
.push:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .push
	ldx.b xsave
	lda.w #$0002		; d0 = (2 + d4) * 2 = nibble shift
	clc
	adc.b d4
	asl a
	sta.b d0
	sta.b tmp0
	lda.w #$FFF0
	sta.b d1
.m1:		;d1 = $FFF0 rotated left by d0
	lda.b tmp0
	beq .and
	dec.b tmp0
	asl.b d1
	bcc .m2
	inc.b d1
.m2:
	bra .m1
.and:
	lda.w PadControlBits
	and.b d1
	sta.w PadControlBits
	lda.w SCnum,x
	sta.b d1
.sh:		;d1 = SCnum << d0
	lda.b d0
	beq .or
	dec.b d0
	asl.b d1
	bra .sh
.or:
	lda.w PadControlBits
	ora.b d1
	sta.w PadControlBits
	stx.b xsave
	ldx.w #$0006
.pop:
	pla
	sta.b d0,x
	dex
	dex
	bpl .pop
	ldx.b xsave
	rtl

org $80F391
setlccords:		;set printx/y to cords for lc box on team a2
		;   SNES: printx/printy for the line change box of team a2 (21 rows lower for the home team, flipped by gmdir); d0/d1 = Framer box size
	stz.b d0
	lda.b a2
	bne .pr
	inc.b d0
.pr:
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$13,$01
	lda.w gmode		; gmdir flips it
	bit.w #gmdir
	beq .noflip
	lda.b d0
	eor.w #$0001
	sta.b d0
.noflip:
	lda.w #$0015		; printy += 21 * d0
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l mulu16		; bank $8D: mulu, A = mula*mulb
	adc.w printy
	sta.w printy
	lda.w #$0002		; getlchoice 2: no third choice: 2 rows
	sta.b d0
	jsl.l getlchoice		; bank $8A (d0 = possible line, -1 = none)
	lda.w #$0006
	sta.b d1
	lda.b d0
	bpl .ex
	dec.b d1
	inc.w printy
.ex:
	lda.w #$000C
	sta.b d0
	rtl

org $80F45B
asspuckc:		;asstab $10. player a3 is puck handler
		;   SNES: player X is the puck carrier: every aioff frames checkob, chk4lc, chk4shot, chk4pass; skate to a postab spot (bank $8F) with
		;   .chkdir
	txa		; not the carrier: assexit
	lsr a
	cmp.w puckc
	beq .nl
	jmp.w assexit
.nl:
	lda.w pfalock,x		; anim locked
	beq .clk
	jmp.w .rtl
.clk:
	lda.w gmclock		; clock stopped: assnothing
	beq .go
	jml.l assnothing		; bank $8F
.go:
	lda.w pflags,x		; joystick controlled: assexit
	bit.w #pfjoycon
	beq .na
	jmp.w assexit
.na:
	bit.w #pfna		; new assignment: temp1 = 0, temp2b = 8, temp3 = random 0-3
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
	lda.w seed
	and.w #$0003
	sta.w temp3,x
.nna:
	lda.w temp1,x		; every aioff frames: checkob, chk4lc, chk4shot, chk4pass
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .nodec
	adc.w aioff,x
	bpl .set
	lda.w #$0000
.set:
	sta.w temp1,x
	jsl.l checkob
	jsl.l chk4lc
	jsl.l chk4shot
	jsl.l chk4pass		; bank $8C
.nodec:		;d0 = 6 + temp3 (random spot), or position when offsides
	lda.w #$0006
	clc
	adc.w temp3,x
	sta.b d0
	lda.w #PuckcSpots
	sta.b a0
	lda.w #PuckcSpots>>16
	sta.b a0+2
	lda.w sflags		; sf2offsig: spot by position
	bit.w #sf2offsig
	beq .nd1
	lda.w position,x
	sta.b d0
.nd1:
	lda.b d0		; d0/d1 = spot x/y, negated for pfgoal clear
	asl a
	asl a
	tay
	lda.b [a0],y
	sta.b d0
	iny
	iny
	lda.b [a0],y
	sta.b d1
	lda.w pfgoal,x
	bne .nd0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.nd0:
	lda.w #.chkdir		; skateto with the .chkdir callback
	sta.b a0
	lda.w #.chkdir>>16
	sta.b a0+2
	jml.l skateto		; bank $88 (d0/d1 = target, a0 = callback)
.rtl:
	rtl
.chkdir:		;skateto callback. d0 = direction; turn away from an opponent within 20 of where the puck will be (threat = count)
	lda.b d0
	and.w #$00FF
	bit.w #$0080
	beq .cd
	ora.w #$FF00
.cd:
	sta.b d0		; d2/d3 = puck + velocity
	lda.w Xvel+1,x
	and.w #$00FF
	bit.w #$0080
	beq .x2
	ora.w #$FF00
.x2:
	clc
	adc.w puckx
	sta.b d2
	lda.w Yvel+1,x
	and.w #$00FF
	bit.w #$0080
	beq .y2
	ora.w #$FF00
.y2:
	clc
	adc.w pucky
	sta.b d3
	stz.w threat
	lda.w #$0005
	sta.b d4
	stz.b a0		; the 6 opponents
	cpx.w #$000C
	bcs .cd0
	lda.w #$000C
	sta.b a0
.cd0:
	ldy.b a0
	lda.w Xvel+1,y
	and.w #$00FF
	bit.w #$0080
	beq .cx
	ora.w #$FF00
.cx:
	clc
	adc.w Xpos,y
	sec
	sbc.b d2
	bit.w #$8000
	beq .ax
	eor.w #$FFFF
	inc a
.ax:
	cmp.w #$0015
	bcs .next
	lda.w Yvel+1,y
	and.w #$00FF
	bit.w #$0080
	beq .cy
	ora.w #$FF00
.cy:
	clc
	adc.w Ypos,y
	sec
	sbc.b d3
	bit.w #$8000
	beq .ay
	eor.w #$FFFF
	inc a
.ay:
	cmp.w #$0015
	bcs .next
	inc.w threat		; threat +1; facing straight at it: turn one step either way
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	sta.b d1
	jsl.l vtoa
	lda.w facedir,x
	eor.w #$0004
	cmp.b d0
	bne .next
	lda.w seed+2
	and.w #$0001
	clc
	adc.b d0
	and.w #$0007
	sta.b d0
.next:
	inc.b a0
	inc.b a0
	dec.b d4
	bmi .rtl2
	jmp.w .cd0
.rtl2:
	rtl

org $80F6AD
assgoalie:		;asstab $E. Player a3 is goalie. Also entered from assnearest
		;   SNES: goalie X. Skate back to the crease, hold/pass the puck, cover a loose puck, follow the puck and lead it, saves
		;   (GoalieSaveList), hug the post, rush a loose puck (agoalietopuck)
	lda.w pfalock,x		; anim locked: nothing
	beq .go
	jmp.w .rtl
.go:
	jsl.l check4bench
	lda.w pflags,x		; new assignment: temp1/temp2 = 0, temp2b = 8, temp4 = -1
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
	lda.w #$FFFF
	sta.w temp4,x
.nna:
	lda.w Xpos,x		; outside the crease area: skate back
	bit.w #$8000
	beq .ax
	eor.w #$FFFF
	inc a
.ax:
	cmp.w #$0035
	bcs .skate
	lda.w Ypos,x
	bit.w #$8000
	beq .ay
	eor.w #$FFFF
	inc a
.ay:
	cmp.w #$010F
	bcs .skate
	cmp.w #$00D3
	bcs .noskate
.skate:		;skate back to the net (callback rtss)
	lda.w #rtss
	sta.b a0
	lda.w #rtss>>16
	sta.b a0+2
	lda.w #$0004
	sta.b d0
	lda.w Xpos,x
	bpl .zero
	lda.w #$FFFC
	sta.b d0
.zero:
	lda.w #$00E4
	sta.b d1
	lda.w pfgoal,x
	beq .sk
	lda.w #$FF1C
	sta.b d1
.sk:
	jml.l skateto		; bank $88 (d0/d1 = target, a0 = callback)
.noskate:
	lda.w pf2aip,x		; pf2aip: nothing
	beq .gready
	jmp.w .rtl
.gready:
	lda.w #SPAgready
	sta.b d1
	jsl.l SetSPA
	lda.w gmclock		; clock stopped: nothing
	beq .clk
	jmp.w .rtl
.clk:
	lda.w temp5,x		; temp5 = holding time
	bmi .nofo
	lda.w SCnum,x
	sta.b d0
	cmp.w puckc
	beq .mbfo
	lda.w #$FFFF
	sta.w temp5,x
	bra .nofo
.mbfo:		;holding the puck: PenGhold when temp5 runs out
	lda.w temp5,x
	sec
	sbc.b d7
	sta.w temp5,x
	bpl .nofo
	lda.w #PenGhold
	sta.b d0
	jsl.l AddPenalty2
.nofo:
	lda.w temp1,x		; every aidef/4 frames
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .dec
	jmp.w .nodec
.dec:
	lda.w aidef,x
	lsr a
	lsr a
	clc
	adc.w temp1,x
	bpl .st1
	lda.w #$0000
.st1:
	sta.w temp1,x
	lda.w pflags,x		; joystick goalie: only .cover
	bit.w #pfjoycon
	beq .half
	jmp.w .cover
.half:
	lda.w pucky		; puck in the other half: stay at the top of the crease (y +-$F4)
	sta.b d0
	lda.w Ypos,x
	eor.b d0
	sta.b d1
	bpl .cnt
	stz.b d0
	lda.w #$00F4
	sta.b d2
	lda.w pfgoal,x
	bne .other
	jmp.w .de5
.other:
	lda.w #$FF0C
	sta.b d2
	jmp.w .de5
.cnt:		;puck in my half
	dec.w temp4,x
	bpl .pc
	lda.w #$FFFF
	sta.w temp4,x
.pc:
	lda.w SCnum,x
	cmp.w puckc
	beq .hold0
	jmp.w .cover
.hold0:
	lda.w temp5,x		; 90 frames before the holding penalty
	bpl .hold
	lda.w #$005A
	sta.w temp5,x
.hold:
	lda.w #$FFFF
	sta.w temp4,x
	lda.w temp5,x
	sec
	sbc.w #$005A
	beq .roll
	bmi .v1
	bvs .roll
.de1j:
	jmp.w .de1
.v1:
	bvs .de1j
.roll:
	lda.w #$0064		; 1 in 4: pass
	jsl.l randoma
	cmp.w #$004B
	bcs .pass
	jmp.w .de1
.pass:
	lda.w #$0005
	sta.b d0
	stz.b a0
	lda.w pfteam,x
	bne .tl
	lda.w #$000C
	sta.b a0
.tl:		;pass only if no opponent is near the puck
	ldy.b a0
	lda.w pflags,y
	bit.w #pf2unav
	bne .tn
	lda.w pucky
	sec
	sbc.w Ypos,y
	bit.w #$8000
	beq .tly
	eor.w #$FFFF
	inc a
.tly:
	cmp.w #$001D
	bcs .tn
	lda.w puckx
	sec
	sbc.w Xpos,y
	bit.w #$8000
	beq .tlx
	eor.w #$FFFF
	inc a
.tlx:
	cmp.w #$001A
	bcs .tn
	jmp.w .de1
.tn:
	inc.b a0
	inc.b a0
	dec.b d0
	bpl .tl
	lda.w #$0001		; threat = 1, chk4pass
	sta.w threat
	jsl.l chk4pass		; bank $8C
	bra .de1
.cover:		;cover a loose puck at the crease
	lda.w temp4,x
	bne .de1
	lda.w puckc
	bpl .de1
	lda.w puckx
	sec
	sbc.w Xpos,x
	sta.b d0
	bit.w #$8000
	beq .cvx
	eor.w #$FFFF
	inc a
.cvx:
	cmp.w #$0015
	bcs .de1
	lda.w pucky
	sta.b d1
	bit.w #$8000
	beq .cvy
	eor.w #$FFFF
	inc a
.cvy:
	cmp.w #$0109
	bcs .de1
	lda.b d1
	sec
	sbc.w Ypos,x
	sta.b d1
	bit.w #$8000
	beq .cvd
	eor.w #$FFFF
	inc a
.cvd:
	cmp.w #$001F
	bcs .de1
	jsl.l vtoa
	lda.b d0
	sta.w facedir,x		; facedir to the puck, nopuck 8, cover anim, pf2aip, crowd +150
	lda.w #$0008
	sta.w nopuck,x
	lda.w #SPAgdive
	sta.b d1
	jsl.l SetSPA
	lda.w #$0096
	sta.w pf2aip,x
	clc
	adc.b crowdlevel
	sta.b crowdlevel
.rtl:
	rtl
.de1:		;a0 = puckcross entry of my goal, d3 = goal line
	lda.w #puckcross
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	lda.w #$0104
	sta.b d3
	lda.w pfgoal,x
	beq .de2
	lda.w #puckcross+4
	sta.b a0
	lda.w #$FEFC
	sta.b d3
.de2:
	lda.w Ypos,x		; out of the crease in y: behind the goal line
	bit.w #$8000
	beq .de2y
	eor.w #$FFFF
	inc a
.de2y:
	cmp.w #$0105
	bcs .out
	lda.w puckx		; face the puck: ClampYPosition, vtoa, AdjustFacingDirection
	sta.b d0
	lda.w pucky
	sta.b d1
	jsl.l ClampYPosition
	lda.b d1
	bit.w #$8000
	beq .near
	eor.w #$FFFF
	inc a
.near:
	cmp.w #$002E
	bcs .in
	lda.b d1
	pha
	lda.b d0
	pha
	jsl.l vtoa
	jsl.l AdjustFacingDirection
	lda.b $01,s
	sta.b d0
	lda.b $03,s
	sta.b d1
	jmp.w .sq
.out:		;behind the goal line
	stz.b d2
	stz.b d0
	lda.w Xpos,x
	bit.w #$8000
	beq .outx
	eor.w #$FFFF
	inc a
.outx:
	cmp.w #$002D
	bcc .out2
	jmp.w .de5
.out2:
	lda.w #$0088
	sta.b d0
	lda.w Xpos,x
	bmi .outn
	jmp.w .de5
.outn:
	lda.w #$FF78
	sta.b d0
	jmp.w .de5
.in:		;face the puck, lead it by its velocity
	jsl.l vtoa
	jsl.l AdjustFacingDirection
	lda.w puckvy		; lead the puck by its velocity (/2 near the ends)
	xba
	lsr a
	and.w #$007F
	bit.w #$0040
	beq .iy
	ora.w #$FF80
.iy:
	clc
	adc.w pucky
	sta.b d1
	lda.w puckvx
	xba
	and.w #$00FF
	bit.w #$0080
	beq .ix
	ora.w #$FF00
.ix:
	sta.b d0
	lda.b d1
	sec
	sbc.w #$00E0
	beq .lo
	bmi .v2
	bvs .lo
	bra .lead2
.v2:
	bvs .lead2
.lo:
	lda.b d1
	sec
	sbc.w #$FF20
	beq .lead2
	bmi .v3
	bvs .lead2
	bra .lead
.v3:
	bvs .lead
.lead2:
	lda.b d0
	pha
	asl a
	pla
	ror a
	sta.b d0
.lead:
	lda.b d0
	clc
	adc.w puckx
	sta.b d0
	jsl.l ClampYPosition
	lda.b d1
	pha
	lda.b d0
	pha
.sq:
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
	sta.b d1
	lda.b mulres+2
	sta.b d1+2
	lda.b d0
	adc.b d1
	sta.b d0
	lda.b d0+2
	adc.b d1+2
	sta.b d0+2
	lda.b d0		; distance^2 < 30*30: stay
	cmp.w #$0385
	lda.b d0+2
	sbc.w #$0000
	bcs .far
	pla
	sta.b d0
	pla
	sta.b d1
	bra .de4
.far:		;scale to a 20 (28 if shooting) pixel arc
	jsl.l sroot
	lda.b d0
	inc a
	sta.b d2
	lda.w #$0014
	sta.b d4
	lda.w sflags
	bit.w #sfssdir
	beq .f0
	lda.w #$001C
	sta.b d4
.f0:
	pla
	sta.b d0
	pla
	sta.b d1
	sta.b mulb
	lda.b d4
	sta.b mula
	jsl.l muls32
	lda.b d2
	sta.b mula
	jsl.l divs
	sta.b d1
	lda.b d4
	adc.w #$0006
	sta.b d4
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l muls32
	lda.b d2
	sta.b mula
	jsl.l divs
	sta.b d0
.de4:
	lda.b d1
	clc
	adc.b d3
	sta.b d1
	sta.b d2
	ldy.w #$0002		; puckcross frames til crossing < $14?
	lda.b [a0],y
	cmp.w #$0014
	bcc .cross
	jmp.w .de5
.cross:		;puck crossing the goal line soon?
	lda.b [a0]
	bit.w #$8000
	beq .cx
	eor.w #$FFFF
	inc a
.cx:
	cmp.w #$0019
	bcc .cz
	jmp.w .rush
.cz:
	lda.b [a0],y
	cmp.w #$000C
	bcc .cy
	jmp.w .de8
.cy:
	lda.w pucky
	bit.w #$8000
	beq .cy2
	eor.w #$FFFF
	inc a
.cy2:
	cmp.w #$0109
	bcc .aip
	jmp.w .de8
.aip:
	lda.w pf2aip,x
	beq .save
	jmp.w .de8
.save:		;pick the save anim: glove side by the direction, stick when low and slow, stack
	inc.w pf2aip,x
	lda.b [a0]
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.b d3
	sec
	sbc.w Ypos,x
	sta.b d1
	jsl.l vtoa
	lda.b d0
	sec
	sbc.w facedir,x
	and.w #$0007
	sta.b d3
	lsr a
	lsr a
	sta.b d0
	lda.w attribute,x
	bit.w #$0800
	beq .noflip
	lda.b d0
	eor.w #$0001
	sta.b d0
.noflip:
	lda.w Zpos+puckobj		; puck low (Zpos <= 8) and slow: stick (+4)
	sec
	sbc.w #$0008
	beq .pz
	bmi .v4
	bvs .pz
	bra .de7
.v4:
	bvs .de7
.pz:
	lda.w puckvz
	sec
	sbc.w #$0800
	beq .stick
	bmi .v5
	bvs .stick
	bra .de7
.v5:
	bvs .de7
.stick:
	lda.b d0
	clc
	adc.w #$0004
	sta.b d0
	ldy.w #$0002		; more than 8 frames, facing up/down, puck carried: stack (-2)
	lda.b [a0],y
	cmp.w #$0009
	bcc .de7
	lda.w facedir,x
	cmp.w #$0002
	beq .de7
	cmp.w #$0006
	beq .de7
	lda.w puckc
	bmi .de7
	dec.b d0
	dec.b d0
.de7:
	asl.b d0
	lda.w #GoalieSaveList
	sta.b a1
	lda.w #GoalieSaveList>>16
	sta.b a1+2
	ldy.b d0
	lda.b [a1],y
	sta.b d1
	jsl.l SetSPA
	lda.b crowdlevel		; crowd +150
	clc
	adc.w #$0096
	sta.b crowdlevel
.de8:
	lda.b [a0]
	sta.b d0
	lda.w pucky		; puck near the goal line: hug the post (+-$18)
	sec
	sbc.w #$00FC
	beq .p2
	bmi .v6
	bvs .p2
	bra .post
.v6:
	bvs .post
.p2:
	lda.w pucky
	sec
	sbc.w #$FF04
	beq .post
	bmi .v7
	bvs .post
	bra .de5
.v7:
	bvs .de5
.post:		;hug the post
	lda.w #$0018
	sta.b d0
	lda.w puckx
	bpl .de5
	lda.w #$FFE8
	sta.b d0
.de5:		;skate toward d0/d2 minus the velocity
	lda.b d2
	sta.b d1
	pha
	lda.b d0
	pha
	lda.w Xvel,x
	xba
	and.w #$00FF
	bit.w #$0080
	beq .vx
	ora.w #$FF00
.vx:
	eor.w #$FFFF
	inc a
	sta.b d0
	pla
	clc
	adc.b d0
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w Yvel,x
	xba
	and.w #$00FF
	bit.w #$0080
	beq .vy
	ora.w #$FF00
.vy:
	eor.w #$FFFF
	inc a
	sta.b d1
	pla
	clc
	adc.b d1
	sec
	sbc.w Ypos,x
	sta.b d1
	lda.w #$0005		; within 5 (10 with the puck): stop
	sta.b tmp0
	txa
	lsr a
	cmp.w puckc
	bne .near2
	asl.b tmp0
.near2:
	lda.b d0
	bit.w #$8000
	beq .nx
	eor.w #$FFFF
	inc a
.nx:
	cmp.b tmp0
	bcs .vt
	lda.b d1
	bit.w #$8000
	beq .ny
	eor.w #$FFFF
	inc a
.ny:
	cmp.b tmp0
	bcs .vt
	stz.b d0
	stz.b d1
.vt:
	jsl.l vtoa
	lda.b d0
	sta.w temp2b,x
.nodec:
	lda.w temp2b,x		; direction > 7: StopNA, else playeracc
	sta.b d2
	sec
	sbc.w #$0007
	beq .acc
	bmi .v8
	bvc .stop
.acc:
	jml.l playeracc		; bank $8F
.v8:
	bvc .acc
.stop:
	jmp.w StopNA
.rush:		;rush a loose puck when the tmnear stats say so
	lda.w puckc
	bmi .r1
	jmp.w .de5
.r1:
	lda.w iflags		; icing possible: no rush
	bit.w #ifok
	beq .r2
	jmp.w .de5
.r2:
	stz.b a1
	lda.w #$0002
	sta.b a2
	lda.w pfteam,x
	beq .t0
	stz.b a2
	lda.w #$0002
	sta.b a1
.t0:
	ldy.b a1		; tmnear of my team >= $1324 and of the other >= $9C4
	lda.w tmnear,y
	cmp.w #$1324
	lda.w tmnear+4,y
	sbc.w #$0000
	bcs .t1
	jmp.w .de5
.t1:
	ldy.b a2
	lda.w tmnear,y
	cmp.w #$09C4
	lda.w tmnear+4,y
	sbc.w #$0000
	bcs .r3
	jmp.w .de5
.r3:
	lda.w pucky		; puck near my end, moving toward me, mostly in y
	sbc.w #$00E0
	beq .r4
	bmi .v9
	bvs .r4
	bra .dir
.v9:
	bvs .dir
.r4:
	lda.w pucky
	sec
	sbc.w #$FF20
	beq .dir
	bmi .v10
	bvs .dir
.de5j:
	jmp.w .de5
.v10:
	bvs .de5j
.dir:
	lda.w puckvy
	sta.b tmp0
	lda.w pfgoal,x
	beq .dir2
	lda.b tmp0
	eor.w #$FFFF
	inc a
	sta.b tmp0
.dir2:
	lda.b tmp0
	bpl .ax2
	jmp.w .de5
.ax2:
	lda.w puckvx
	bit.w #$8000
	beq .axs
	eor.w #$FFFF
	inc a
.axs:
	sta.b d0
	lda.w puckvy
	bit.w #$8000
	beq .ay2
	eor.w #$FFFF
	inc a
.ay2:
	sta.b d1
	lda.b d1
	cmp.b d0
	bcs .ins
	jmp.w .de5
.ins:
	lda.w #agoalietopuck		; agoalietopuck
	sta.b d0
	jmp.w assinsert
ClampYPosition:		;d1 = y clamped to +-$103, minus goal line d3. d0 = 0 if X has the puck
	lda.w puckc
	sta.b d2
	cmp.w SCnum,x
	bne .zero
	stz.b d0
.zero:
	lda.b d1
	sec
	sbc.w #$0103
	bmi .v1
	bvc .hi
	bra .one
.v1:
	bvc .one
.hi:
	lda.w #$0103
	sta.b d1
.one:
	lda.b d1
	sec
	sbc.w #$FEFD
	beq .lo
	bmi .v2
	bvs .lo
	bra .two
.v2:
	bvs .two
.lo:
	lda.w #$FEFD
	sta.b d1
.two:
	lda.b d1
	sec
	sbc.b d3
	sta.b d1
	rtl
AdjustFacingDirection:		;Turn facedir one step
		;   SNES: turn facedir of goalie X one step toward d0, not past the sides of the net
	lda.w facedir,x
	sta.b d1
	lda.b d0
	sec
	sbc.b d1
	sta.b d0
	bne .turn
	jmp.w assgoalie_rtl
.turn:
	eor.w #$FFFF
	inc a
	and.w #$0004
	lsr a
	dec a
	sta.b d0
	lda.b d1
	cmp.w #$0001
	beq .add
	cmp.w #$0006
	bne .dn
.add:
	clc
	adc.b d0
	sta.b d1
	lda.w pfgoal,x
	bne .other
	lda.b d1
	cmp.w #$0002
	bcc .neg
	cmp.w #$0007
	beq .neg
	bra .set
.other:
	lda.b d1
	cmp.w #$0003
	bcc .set
	cmp.w #$0006
	bcs .set
.neg:
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	clc
	adc.b d1
	sta.b d1
.dn:
	lda.b d1
	clc
	adc.b d0
	sta.b d1
.set:
	lda.b d1
	and.w #$0007
	sta.b d1
	sta.w facedir,x
	rtl
GoalieSaveList:		;save anims by index: glove 0/1, stack 2/3, stick 4/5
	dw SPAgglover,SPAgglovel,SPAgstackr,SPAgstackl,SPAgstickr,SPAgstickl
checkgoalp_CalcGoalShotDir:		;kept: 92 checkgoalp is the goal/net collision in hockey93_04. 93 only. If the opposing goalie
		;   SNES: if the opposing goalie covers the middle of the net, passdir 2 or 6 to shoot at the open side, else 0.
		;   Skipped for joystick players
	lda.w pflags,x		; joystick player: skip
	bit.w #pfjoycon
	beq .go
	jmp.w .rtl
.go:
	lda.w #$0008
	sta.b d0
	lda.w #$0005
	sta.b d1
	lda.w #$FFFE
	sta.b a0
	lda.w pfteam,x
	bne .g
	lda.w #$000A
	sta.b a0
.g:		;find position 0 on the other team
	inc.b a0
	inc.b a0
	ldy.b a0
	lda.w position,y
	beq .found
	dec.b d1
	bpl .g
	jmp.w .x
.found:		;goalie x/y + half his velocity - puck; d2 = distance
	lda.w Xvel+1,y
	and.w #$00FF
	bit.w #$0080
	beq .gx
	ora.w #$FF00
.gx:
	pha
	asl a
	pla
	ror a
	clc
	adc.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	lda.w Yvel+1,y
	and.w #$00FF
	bit.w #$0080
	beq .gy
	ora.w #$FF00
.gy:
	pha
	asl a
	pla
	ror a
	clc
	adc.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
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
	sec
	adc.b d0
	sta.b d0
	lda.b mulres+2
	adc.b d0+2
	sta.b d0+2
	jsl.l sroot
	lda.b d0
	sta.b d2
	pla
	sta.b d0
	pla
	sta.b d1
	lda.w #$0012		; d3/d4 = post x/goal y
	sta.b d3
	lda.w #$0108
	sta.b d4
	lda.w pfgoal,x
	bne .l
	lda.w #$FEF8
	sta.b d4
.l:		;posts at x +-18, y +-$108
	lda.b d4
	pha
	lda.b d3
	pha
	jsl.l CalcAngleOffset
	lda.b d4
	sta.b d5
	pla
	eor.w #$FFFF
	inc a
	sta.b d3
	pla
	sta.b d4
	jsl.l CalcAngleOffset
	lda.b d4
	clc
	adc.b d5
	sta.b d4
	stz.b d0
	lda.b d4
	bit.w #$8000
	beq .abs
	eor.w #$FFFF
	inc a
.abs:
	cmp.w #$002D		; |angle| < 45: shoot at the open side
	bcs .x
	lda.w pfgoal,x
	beq .s
	lda.b d4
	eor.w #$FFFF
	inc a
	sta.b d4
.s:
	lda.w #$0002
	sta.b d0
	lda.b d4
	bpl .x
	lda.w #$0006
	sta.b d0
.x:
	lda.b d0
	sta.w passdir
.rtl:
	rtl
CalcAngleOffset:		;d4 = cross product of goalie vector d0/d1 and post vector
		;   SNES: d4 = (goalie vector d0/d1 x post vector d3/d4 from the puck) / d2
	lda.b d3
	sec
	sbc.w puckx
	sta.b d3
	lda.b d4
	sec
	sbc.w pucky
	sta.b mulb
	lda.b d0
	sta.b mula
	jsl.l muls32
	sta.b d4
	lda.b mulres+2
	sta.b d4+2
	lda.b d1
	sta.b mula
	lda.b d3
	sta.b mulb
	jsl.l muls32
	sta.b d3
	lda.b mulres+2
	sta.b d3+2
	lda.b d4
	sec
	sbc.b d3
	sta.b mulb
	lda.b d4+2
	sbc.b d3+2
	sta.b mulb+2
	lda.b d2
	sta.b mula
	jsl.l divs
	sta.b d4
	rtl
