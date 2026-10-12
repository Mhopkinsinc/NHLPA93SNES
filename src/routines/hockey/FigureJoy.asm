FigureJoy:		;Set which team each controller plays
	stz.w cont1team
	stz.w cont2team
	lda.w notdemo		; after the demo: no controller teams
	beq .rtl
	lda.w OptPlayMode
	bne .po
	jmp.w .fjnpo
.po:
	jsl.l GetShifter
	lda.w #potree		; d2 = the po team
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	ldy.w potreeteam
	lda.b [a0],y
	and.w #$00FF
	sta.b d2
	lda.b d1
	asl a
	sta.b a1
	lda.w #$FFFF		; gamenum -1: po team not playing
	sta.w gamenum
	stz.b d0
.f0:
	lda.b d2
	ldy.b a1
	cmp.w gst1,y
	beq .it1
	cmp.w gst2,y
	beq .it2
	dec.b a1
	dec.b a1
	dec.b d1
	bpl .f0
.rtl:		;po team not in the playoffs
	rtl
.it2:
	lda.w #4
	sta.b d0
	lda.w gst1,y
	sta.w OptTeam2
	bra .itx
.it1:
	stz.b d0
	lda.w gst2,y
	sta.w OptTeam2
.itx:
	lda.b d0
	clc
	adc.w pojoy
	sta.b d0
	lda.b d1
	sta.w gamenum
	lda.w gst1,y
	sta.w HomeTeam
	lda.w gst2,y
	sta.w VisTeam
	asl.b d0
	asl.b d0
	lda.w #.pojoylist		; .pojoylist entry (pojoy + 4 if the po team is team 2)
	sta.b a0
	lda.w #.pojoylist>>16
	sta.b a0+2
	ldy.b d0
	lda.b [a0],y
	sta.w cont1team
	iny
	iny
	lda.b [a0],y
	sta.w cont2team
	rtl
.fjnpo:
	lda.w OptPlayers		; regular season: .noplist by OptPlayers
	asl a
	asl a
	sta.b d0
	tay
	lda.w #.noplist
	sta.b a0
	lda.w #.noplist>>16
	sta.b a0+2
	lda.b [a0],y
	sta.w cont1team
	iny
	iny
	lda.b [a0],y
	sta.w cont2team
	rtl
.pojoylist:		;cont1team, cont2team by pojoy 0-3 (the po team as team 1), then as team 2
	dw 1,0
	dw 1,1
	dw 1,2
	dw 2,1
	dw 2,0
	dw 2,2
	dw 2,1
	dw 1,2
.noplist:		;cont1team, cont2team by OptPlayers
	dw 0,0
	dw 1,0
	dw 2,0
	dw 1,1
	dw 1,2
