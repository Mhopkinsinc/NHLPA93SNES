getpzjoy:		;read the joystick of the pad that paused (sfpj: Readjoy2, else Readjoy1)
	lda.w sflags
	bit.w #sfpj
	beq .p1
	jml.l Readjoy2
.p1:
	jml.l Readjoy1
