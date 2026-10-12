asseben:		;asstab 9. player a3 should exit bench area
		;   SNES: player X comes onto the ice from the bench door (SPAwallright), then assexit
	lda.w pfalock,x
	bne .rtl
	lda.w pflags,x
	bit.w #$0002
	beq .nna
	and.w #$FFFD
	sta.w pflags,x
	stz.w Xvel,x
	stz.w Yvel,x
	txa
	lsr a
	sec
	sbc.w #$0006
	bmi .0
	inc a
.0:
	sta.b mulb
	lda.w #$000E
	sta.b mula
	jsl.l muls16
	sta.w Ypos,x
	lda.w #$FF78
	sta.w Xpos,x
	lda.w #$0002
	sta.w facedir,x
	sta.w pfalock,x
	lda.w #$101A
	sta.b d1
	jml.l SetSPA
.rtl:
	rtl
.nna:
	lda.w #$0004
	sta.w facedir,x
	lda.w pflags,x
	and.w #$6FFF
	sta.w pflags,x
	stz.w pfnc,x
	stz.w SPA,x
	lda.w #$1000
	sta.w Xvel,x
	jml.l assexit
