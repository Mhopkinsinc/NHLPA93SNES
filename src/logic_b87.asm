; Player logic and the assignments (asstab).
; Bank $87. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $87FF78
assepen:		;asstab $A. player a3 should exit penalty area
		;   SNES: player X leaves the penalty box: PBnum - $10/1, onto the ice at x $88, SPAwallleft; then out of the area (assexit)
	lda.w pflags,x
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	ldy.w #$0010
	lda.w pfteam,x
	beq .one
	ldy.w #$0001
.one:
	sty.b d0
	lda.w PBnum
	sec
	sbc.b d0
	sta.w PBnum
	stz.w Xvel,x
	stz.w Yvel,x
	lda.w #60
	sta.b d0
	lda.w pfteam,x
	bne .y
	lda.w #-60
	sta.b d0
.y:
	lda.b d0
	sta.w Ypos,x
	lda.w #$0088
	sta.w Xpos,x
	lda.w #$0002
	sta.w facedir,x
	sta.w pfalock,x
	lda.w #SPAwallleft
	sta.b d1
	jsl.l SetSPA
	jml.l SprSort
.nna:
	lda.w #$0004
	sta.w facedir,x
	lda.w #$FFFF
	sta.w newpnum,x
	sta.w newpos,x
	lda.w pflags,x
	and.w #$6FF7
	sta.w pflags,x
	stz.w pfnc,x
	lda.w #$F000
	sta.w Xvel,x
	jml.l assexit
unusedFF87:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
