assbench:		;Assignment: player X skates to the bench door and leaves; the new player comes on
	lda.w pfalock,x
	beq .na
	jmp.w .rtl
.na:
	lda.w temp1,x
	cmp.w #100		; temp1 100: at the bench door
	bne .chk
	jmp.w .done
.chk:
	jsl.l check4bench
	lda.w pflags,x
	bit.w #pf2pen		; pf2pen: assexit
	beq .pen
	jml.l assexit
.pen:
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stz.w temp2,x
	lda.w #8
	sta.w temp2b,x
	lda.w #80		; temp4 = bench y +-80, temp3 = bench x -144
	sta.b d0
	lda.w pfteam,x
	bne .0
	lda.w #-80
	sta.b d0
.0:
	lda.b d0
	sta.w temp4,x
	lda.w #-144
	sta.w temp3,x
	stz.w temp1,x
.nna:
	lda.w newpnum,x		; same player: just change position
	cmp.w pnum,x
	bne .dec
	jmp.w .nobench
.dec:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .near
	jmp.w .nodec
.near:
	lda.w temp1,x
	adc.w #8
	sta.w temp1,x
	lda.w Ypos,x
	sec
	sbc.w temp4,x
	bit.w #$8000
	beq .ay
	eor.w #$FFFF
	inc a
.ay:
	cmp.w #41
	bcc .ax
	jmp.w .nodec
.ax:
	lda.w Xpos,x
	sec
	sbc.w temp3,x
	sta.b d0
	sec
	sbc.w #32
	beq .gli0
	bmi .lt
	bvs .gli0
.nd:
	jmp.w .nodec
.lt:
	bvs .nd
.gli0:
	lda.w #SPAglide		; SPAglide (goalie SPAgready)
	sta.b d1
	lda.w position,x
	bne .gli
	lda.w #SPAgready
	sta.b d1
.gli:
	jsl.l SetSPA
	lda.w #1
	sta.w pfnc,x
	lda.w facedir,x
	cmp.w #4
	beq .ok
	inc a
	and.w #$0007
	sta.w facedir,x
.ok:
	stz.w Yvel,x
	lda.w #$F800
	sta.w Xvel,x
	lda.b d0
	sec
	sbc.w #16
	beq .stop
	bmi .lt2
	bvs .stop
	bra .rtl
.lt2:
	bvs .rtl
.stop:
	stz.w Xvel,x
	lda.w facedir,x
	cmp.w #4
	bne .rtl
	lda.w #$F800
	sta.w Xvel,x
	lda.w #2
	sta.w facedir,x
	lda.w #SPAwallleft		; SPAwallleft
	sta.b d1
	jsl.l SetSPA
	lda.w #100
	sta.w temp1,x
	sta.w pfalock,x
.rtl:
	rtl
.done:
	stz.w frame,x
	lda.w pnum,x
	asl a
	sta.b d0
	stz.b a0
	lda.w pfteam,x
	beq .away
	lda.w #2
	sta.b a0
.away:
	lda.b a0
	beq .t0
	lda.w #$34
.t0:
	clc
	adc.b d0
	tay
	lda.w #TMPDBENCH		; TMPDBENCH: on the bench
	sta.w tmpdst,y
	lda.w newpnum,x
	sta.b d3
	jsl.l .nobench2
	jml.l setplayer
.nodec:
	lda.w pfnc,x
	bne .rtl
	lda.w temp3,x
	sta.b d0
	lda.w temp4,x
	sta.b d1
	lda.w #EvadePC
	sta.b a0
	lda.w #EvadePC>>16
	sta.b a0+2
	jml.l skateto
.nobench:
	lda.w pflags,x
	and.w #~pf2unav&$FFFF
	sta.w pflags,x
.nobench2:		;position = newpos (Setplass), newpnum/newpos -1
	lda.w newpos,x
	sta.b d0
	sta.w position,x
	jsl.l Setplass
	lda.w #$FFFF
	sta.w newpnum,x
	sta.w newpos,x
	rtl
