NewPO:		;Start new playoffs with the same team 1 and build the tree
	lda.w #32		; d0 = random 0-31
	sta.b d0
	jsl.l randomd0
.top:
	lda.b d0
	inc a
	and.w #$001F
	sta.b d0
	asl a
	asl a
	asl a
	asl a
	adc.w #playoffseats		; a0 = playoffseats + 16 * d0
	sta.b a0
	lda.w #playoffseats>>16
	sta.b a0+2
	lda.w #15
	sta.b d1
	lda.w OptTeam1
	sta.b d2
	cmp.w #24		; all-star teams (24+): team 23
	bcc .loop
	lda.w #23
	sta.b d2
.loop:
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	cmp.b d2
	beq .found
	dec.b d1
	bpl .loop
	bra .top
.found:
	lda.b d1		; potreeteam = slot of OptTeam1
	eor.w #$000F
	sta.b d1
	sta.w potreeteam
	lda.b d0
	sta.w postarts
	stz.w gamelevel
	lda.w #7		; bosgames 7: single games (OptPlayMode 2)
	sta.b bosgames
	lda.w OptPlayMode
	cmp.w #2
	beq .tree
	stz.b bosgames		; best of seven: clear the series
	lda.w #7
	sta.b d0
	ldx.w #$0000
.cg:
	stz.w gspotwins,x
	stz.w gspobwins,x
	inx
	inx
	dec.b d0
	bpl .cg
.tree:
	jml.l maketree
