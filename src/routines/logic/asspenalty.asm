asspenalty:		;asstab $C. player a3 should goto penalty box
		;   SNES: player X skates to the penalty box (temp3/temp4 by PBnum), glides in, faces the ice (SPAwallright), then adopen
	lda.w pfalock,x
	beq .na
	jmp.w .rtl
.na:
	lda.w pflags,x		; new assignment
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	ora.w #pf2unav
	sta.w pflags,x
	jsl.l clrplayer
	lda.w #-2		; setpads -2: number on the leaving player
	sta.b d4
	jsl.l setpads
	stz.w temp2,x
	lda.w #8
	sta.w temp2b,x
	lda.w #11		; temp4 = 11 * (n + 3), n = players in the box (0-2)
	sta.b d0
	lda.w PBnum
	sta.b d1
	lda.w pfteam,x
	bne .0
	lda.b d1
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d1
	lda.w #-11
	sta.b d0
.0:
	lda.b d1
	and.w #$000F
	sta.b d1
	cmp.w #3
	bcc .1
	lda.w #2
	sta.b d1
.1:
	inc.b d1
	inc.b d1
	inc.b d1
	lda.b d0
	sta.b mula
	lda.b d1
	sta.b mulb
	jsl.l muls16
	sta.b d1
	sta.w temp4,x
	lda.w #$0088		; temp3 = $88: the sideline
	sta.w temp3,x
	stz.w temp1,x
	lda.w pflags,x		; pf2npc: no player collision
	ora.w #pf2npc
	sta.w pflags,x
	stz.w Wallcos,x
	stz.w Wallsin,x
.nna:
	lda.w Ypos,x
	sec
	sbc.w temp4,x
	bit.w #$8000
	beq .ay
	eor.w #$FFFF
	inc a
.ay:
	cmp.w #13
	bcc .in
	jmp.w .st
.in:
	lda.w Xpos,x
	sec
	sbc.w temp3,x
	sta.b d0
	sec
	sbc.w #-24
	bmi .lt
	bvc .near
.st0:
	jmp.w .st
.lt:
	bvc .st0
.near:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .step
	jmp.w .rtl
.step:
	adc.w #8
	sta.w temp1,x
	lda.w #SPAglide		; SPAglide, pfnc
	sta.b d1
	sta.w pfnc,x
	jsl.l SetSPA
	lda.w #6		; face 6 (2 for the other hand)
	sta.b d2
	lda.w handed,x
	beq .left
	lda.w #2
	sta.b d2
.left:
	lda.w facedir,x
	cmp.b d2
	beq .ok
	inc a
	and.w #$0007
	sta.w facedir,x
.ok:
	stz.w Yvel,x
	lda.w #$1000
	sta.w Xvel,x
	lda.b d0
	sec
	sbc.w #-8
	bmi .lt2
	bvc .stop
	bra .rtl
.lt2:
	bvc .rtl
.stop:
	stz.w Xvel,x
	lda.w facedir,x
	cmp.b d2
	bne .rtl
	lda.w #2
	sta.w facedir,x
	sta.w pfalock,x
	lda.w #SPAwallright		; SPAwallright
	sta.b d1
	jsl.l SetSPA
	lda.w pflags,x
	and.w #~pf2pen&$FFFF		; pf2pen off
	sta.w pflags,x
	lda.w #$0D		; adopen
	sta.b d0
	jml.l assreplace
.rtl:
	rtl
.st:		;skate to the box
	lda.w temp3,x
	sta.b d0
	lda.w temp4,x
	sta.b d1
	lda.w #rtss		; a0 = rtss: no avoidance
	sta.b a0
	lda.w #rtss>>16
	sta.b a0+2
	jml.l skateto
