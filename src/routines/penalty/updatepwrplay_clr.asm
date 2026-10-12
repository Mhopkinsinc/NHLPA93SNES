updatepwrplay_clr:		;power play over, EASN logo back
	lda.w #sf2pwrplay
	trb.w sflags
	beq .rtl
	jml.l EASNLogo
.rtl:
	rtl
