; Player logic and the assignments (asstab).
; Bank $86. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $86FCB7
lcfound2:		;close lc box. Also called from lineinput
		;   SNES: close the line change box (setlccords; the lower box clears sf3llcs), erase it unless the faceoff box is up, then printscores1
	jsl.l setlccords
	lda.w printy
	sec
	sbc.w #15
	bmi .neg
	bvc .low
	bra .nollcm
.neg:
	bvc .nollcm
.low:
	lda.w #sf3llcs
	trb.w sflags3
.nollcm:
	inc.b d1
	lda.w blankchar
	sta.b d2
	lda.b fobox
	bne .print
	jsl.l eraser		; bank $8D
.print:
	jml.l printscores1

org $86FD86
assscore:		;asstab 7. player a3 celebrates, if scoring player then do arm pump
		;   SNES: player X celebrates, the scorer pumps his arm; velocities * 3/4 each frame, the carrier drops the puck (nopuck 1800)
	lda.w Xvel,x		; Xvel, Yvel *= $C0/256
	sta.b mula
	lda.w #$00C0
	sta.b mulb
	jsl.l muls32
	lda.b mulres+1
	sta.w Xvel,x
	lda.w Yvel,x
	sta.b mula
	lda.w #$00C0
	sta.b mulb
	jsl.l muls32
	lda.b mulres+1
	sta.w Yvel,x
	txa		; the carrier drops the puck
	lsr a
	cmp.w puckc
	bne .al
	lda.w #$FFFF
	sta.w puckc
	lda.w #1800
	sta.w nopuck,x
.al:
	lda.w pfalock,x
	bne .rtl
	lda.w pflags,x
	bit.w #pfna		; new assignment: spot (+-90, Vpos)
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	jsl.l .1
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
	lda.w #90
	sta.w temp3,x
	lda.w Hpos
	bpl .0
	lda.w #-90
	sta.w temp3,x
.0:
	lda.w Vpos
	sta.w temp4,x
.nna:
	lda.w #rtss
	sta.b a0
	lda.w #rtss>>16
	sta.b a0+2
	lda.w temp3,x
	sta.b d0
	lda.w temp4,x
	sta.b d1
	lda.w temp1,x		; temp1 runs out: celebrate (SPApump for the scorer)
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .chkcon
	sta.w pfalock,x
	lda.w #SPAcelebrate
	sta.b d1
	txa
	lsr a
	cmp.w shotplayer
	bne .nopump
	lda.w #SPApump
	sta.b d1
.nopump:
	jsl.l SetSPA
.1:		;temp1 = random 120
	lda.w #120
	jsl.l randoma
	sta.w temp1,x
.rtl:
	rtl
.chkcon:		;joystick controlled: stand, else skateto
	lda.w pflags,x
	bit.w #pfjoycon
	bne .rtl2
	jml.l skateto
.rtl2:
	rtl
unusedFF86:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
