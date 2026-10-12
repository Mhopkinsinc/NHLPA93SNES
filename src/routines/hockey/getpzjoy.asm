getpzjoy:		;Read the pad of the controller that paused
	lda.w sflags
	bit.w #sfpj
	beq .p1
	jml.l Readjoy2
.p1:
	jml.l Readjoy1
