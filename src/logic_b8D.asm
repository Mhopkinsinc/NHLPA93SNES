; Player logic and the assignments (asstab).
; Bank $8D. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8D87B0
puckshadow:		;asstab $19. assignment for puck shadow. a3 = puck shadow (struct after the puck)
		;   SNES: the shadow object follows the puck (frame $189); else parks it behind the goal
	lda.w frame,x
	cmp.w #$0189		; puck frame: shadow under the puck
	bne .none
	lda.w puckx
	sta.w Xpos,x
	lda.w pucky
	sta.w Ypos,x
	stz.w Zpos,x
	lda.w sfhormode
	beq .nhor
	inc.w Xpos,x
	rtl
.nhor:
	inc.w Ypos,x
	rtl
.none:
	tay
	beq .rtl
	stz.w Xpos,x
	lda.w #300		; behind the goal
	sta.w Ypos,x
	lda.w #14
	sta.w Zpos,x
	lda.w pucky
	bpl .rtl
	lda.w #$8000
	sta.w attribute,x
	lda.w #-300
	sta.w Ypos,x
	dec.w Zpos,x
.rtl:
	rtl

org $8DFCC7
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
clrplayer:		;take the joystick off player a3
		;   SNES: take the joystick off player X (changeplayer)
	lda.w pflags,x
	bit.w #pfjoycon
	beq asspenalty_rtl
	stz.b d4
	txa
	lsr a
	sta.b d0
	cmp.w c1playernum
	beq .ch
	inc.b d4
	inc.b d4
.ch:
	jml.l changeplayer
avdgoal:		;don't try to skate thru goal: if d0/d1 cords intersect thru goal then provide new d0/d1 cords. a3 = player
		;   SNES: if the path d0/d1 crosses a goal line (y +-258) within 40 of the net, aim beside the net (x +-60) instead
	stz.b tmp2
	lda.w #-258		; goal line at y -258 ($FEFE) and 258 ($102)
	jsl.l .ch1
	lda.w #258
	jsl.l .ch1
	lda.b tmp2
	bne .rtl
	lda.w Xpos,x		; not crossing: is the player in front of a net?
	eor.b d0
	bpl .rtl
	lda.w Ypos,x
	sec
	sbc.w #258
	bit.w #$8000
	beq .b
	eor.w #$FFFF
	inc a
.b:
	cmp.w #32
	bcc .x
	lda.w Ypos,x
	sec
	sbc.w #-258
	bit.w #$8000
	beq .c
	eor.w #$FFFF
	inc a
.c:
	cmp.w #32
	bcs .rtl
.x:
	stz.b d1
	rtl
.ch1:		;goal line A: crossed within 40 of the net: d1 = line, d0 = +-60 by Xvel, tmp2 = 1
	sta.b tmp0
	lda.b d1
	sec
	sbc.b tmp0
	sta.b tmp1
	lda.w Ypos,x
	sec
	sbc.b tmp0
	eor.b tmp1
	bpl .rtl
	lda.w Xpos,x
	bit.w #$8000
	beq .ax
	eor.w #$FFFF
	inc a
.ax:
	cmp.w #40
	bcs .rtl
	inc.b tmp2
	lda.b tmp0
	sta.b d1
	lda.w #60
	sta.b d0
	lda.w Xvel,x
	bpl .rtl
	lda.w #-60
	sta.b d0
.rtl:
	rtl
unused008D:		;unused, zero fill to the end of the bank
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
