SPCBootUpload:		;SNES: wait for the queue and a vblank, then send the boot stream at BootSoundUpload (driver and its samples, sndbank 2)
	phy
	phx
	pha
.dark:		;keep the screen dark unless fully on
	lda.b brightness
	cmp.w #$000F
	beq .qwait
	stz.b brightness
.qwait:
	lda.b sndqin
	cmp.b sndqout
	bne .dark
	lda.b vcount
.vblank:
	cmp.b vcount
	beq .vblank
	lda.w #$0001		; sndbank 2, no song
	sta.b sndlock
	lda.w #$0002
	sta.w sndbank
	stz.w cursong
	lda.w #BootSoundUpload&$FFFF		; sndptr = BootSoundUpload
	sta.b sndptr
	lda.w #(BootSoundUpload>>8)&$FFFF
	sta.b sndptr+1
	jsl.l SPCUpload
	sep #$20
	lda.b #NMITIMEN_NMI|NMITIMEN_JOY		; NMI and auto joypad read back on
	sta.w NMITIMEN
	rep #$30
	lda.b vcount
	inc a
	inc a
.frames:		;wait 2 frames
	cmp.b vcount
	bne .frames
	pla
	plx
	ply
	rtl
