ReadPads:		;SNES: once per frame (padvcount) read the 4 auto-read pads into joypad1-4, padnew1-4 = new presses, padlast1-4 = buttons
	lda.b vcount		; once per frame
	cmp.w padvcount
	beq .new
	sta.w padvcount
	lda.w #$0001
.wait:		;auto-joypad read busy
	bit.w HVBJOY
	bne .wait
	lda.w JOY1L
	sta.w joypad1
	lda.w JOY2L
	sta.w joypad2
	lda.w JOY3L
	sta.w joypad3
	lda.w JOY4L
	sta.w joypad4
.new:
	lda.w joypad1		; new presses = changed and down
	eor.w padlast1
	and.w joypad1
	sta.w padnew1
	lda.w joypad2
	eor.w padlast1+2
	and.w joypad2
	sta.w padnew1+2
	lda.w joypad3
	eor.w padlast1+4
	and.w joypad3
	sta.w padnew1+4
	lda.w joypad4
	eor.w padlast1+6
	and.w joypad4
	sta.w padnew1+6
	lda.w joypad1
	sta.w padlast1
	lda.w joypad2
	sta.w padlast1+2
	lda.w joypad3
	sta.w padlast1+4
	lda.w joypad4
	sta.w padlast1+6
	rtl
