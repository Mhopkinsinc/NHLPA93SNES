EncodePW:		;After a playoff game, work out the winners and the new password, or new playoffs when the user's team won or went out
	lda.w OptPlayMode
	bne .po
	jmp.w .rtl
.po:
	lda.w #$0001
	sta.w OptPlayMode
	jsl.l ResolveGames
	jsl.l maketree
	lda.w gamelevel		; finished playoffs
	cmp.w #$0004
	beq .userwon
	lda.w gamenum		; gamenum >= 0: player 1 won
	bpl .nofail
	lda.w pojoy		; pojoy < 2: one player or teammates
	sec
	sbc.w #$0002
	bmi .lt
	bvc .two
	bra .userfailed
.lt:
	bvc .userfailed
.two:		;two players, first round: switch to the other team
	lda.w gamelevel
	cmp.w #$0001
	bne .userfailed
	lda.w potreeteam
	eor.w #$0001
	sta.w potreeteam
	lda.w pojoy
	eor.w #$0001
	sta.w pojoy
.nofail:
	jsl.l WritePassBits
	jsl.l BitstoPW
	lda.w sflags3		; sf3alttree: passbits before all games were resolved
	bit.w #sf3alttree
	beq .tree
	ldy.w #$000E
.cp:
	lda.w tpassbits,y
	sta.w passbits,y
	dey
	dey
	bpl .cp
	jsl.l ReadPassBits
.tree:
	jml.l maketree
.userwon:
	jsl.l ResetPassWord
.userfailed:
	lda.w #$0080		; PassWord bit 7: no password
	tsb.w PassWord
	lda.w #$0002
	sta.w OptPlayMode
	lda.b bosgames
	cmp.w #$0007
	beq .rtl
	lda.w #$0003
	sta.w OptPlayMode
.rtl:
	rtl
