updatepwrplay_clr:		;Power play over: put the EASN logo back
	lda.w #sf2pwrplay
	trb.w sflags
	beq .rtl
	jml.l EASNLogo
.rtl:
	rtl
