SetLCmode2:		;a2 = team struct for lc. Draw the lc box with one row per eligible line (A/B/C + line name). Also called from lineinput
		;   SNES: draw the lc box, one row per eligible line (button letter + line name)
	jsl.l setlccords
	inc.b d0		; box size +1
	inc.b d1
	lda.w blankchar		; d2 = blank tile
	sta.b d2
	lda.b fobox		; faceoff box up: do not clear
	bne .cords
	jsl.l eraser		; d0/d1 size, d2 tile
.cords:
	jsl.l setlccords
	lda.w printy		; lower half of the screen?
	sec
	sbc.w #$000F
	bmi .neg
	bvc .lower
	bra .box
.neg:
	bvc .box
.lower:		;lower box: sf3llcs
	lda.w #sf3llcs
	tsb.w sflags3
	bra .frame
.box:
	jsl.l box
	jsl.l setlccords
.frame:
	jsl.l Framer		; d0/d1 size
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
	jsl.l getlchoice
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
	lda.w #linelist		; linelist
	sta.b a1
	lda.w #linelist>>16
	sta.b a1+2
	jsl.l PrintStringFromList
	pla
	sta.b d0
	jsl.l linebar
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
	lda.w #TeamList>>16		; team name: [tmdata] + its offsets
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
