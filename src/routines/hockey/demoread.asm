demoread:		;In the demo, Start pauses and any other button ends it
	lda.w cont1team		; a controller team: not a demo
	ora.w cont2team
	bne .rtl
	jsl.l Readjoy1
	lda.b d1
	bit.w #JOYSTART		; Start on pad 1: startpause1
	beq .any1
	jml.l startpause1
.any1:
	lda.b d1
	bne .exit
	jsl.l Readjoy2
	lda.b d1
	bit.w #JOYSTART		; Start on pad 2: startpause2
	beq .any2
	jml.l startpause2
.any2:
	lda.b d1
	bne .exit
.rtl:
	rtl
.exit:		;end the demo: back to the title screen
	jsl.l sndqreset		; sound queue reset; on to the title screen
	jml.l Opening		; on to the title screen
