lcfound:		;d2 = line choice 0-2: getlchoice; loadTeamStruct, tmline, setpersonel, lcfound2
	ldx.b a3
	ldy.b a2
	lda.b d2
	sta.b d0
	sta.w tmlcchoice,y
	jsl.l getlchoice
	lda.b d0
	bmi .rtl
	lda.w pflags,x
	and.w #$DFFF
	ora.w #$0008
	sta.w pflags,x
	jsl.l loadTeamStruct
	ldy.b a2
	lda.w tmflags,y
	and.w #$FFF7
	sta.w tmflags,y
	lda.b d0
	sta.w tmline,y
	jsl.l setpersonel
	jml.l lcfound2
.rtl:
	rtl
