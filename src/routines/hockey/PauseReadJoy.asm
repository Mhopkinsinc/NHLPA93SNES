PauseReadJoy:		;wait for a vblank and a new button (not L/R); in demo mode with no controller team the pause ends after pausetimer frames (sets Start)
	jsl.l IntermissionTick
	bne .force
	jsl.l setvideo
	lda.b vcount
.vb:
	cmp.b vcount
	beq .vb
	jsl.l ReadPads		; ReadPads; ignore L/R
	lda.w joypad1
	ora.w joypad2
	bit.w #JOYR|JOYL
	bne PauseReadJoy
	jsl.l getpzjoy		; menu sounds and ticker
	jsl.l nullrtl85
	lda.w demoflag		; demo with no controller teams: count down pausetimer
	beq .chk
	lda.w cont1team
	ora.w cont2team
	bne .chk
	dec.b pausetimer
	bne .chk
.force:
	lda.w #JOYSTART
	tsb.b d1
.chk:
	lda.b d1
	beq PauseReadJoy
	lda.w #60000
	sta.b pausetimer
	rtl
