clockcont_0:		;end of period. Also entered from puckfaceoff+2E
		;   SNES: puck pucknorm; third period winners celebrate (assscore, the Stanley Cup in the final), the game clock stops
	ldx.w #$001C
	stx.b a3
	lda.w #$18
	sta.b d0
	jsl.l assinsert
	lda.w gsp
	cmp.w #$0002
	bcs .p3
	jmp.w .notp3
.p3:
	lda.w #$0007
	sta.b d0
	ldx.w #$0000
	stx.b a3
	lda.w gamelevel
	cmp.w #$0003
	bne .winners
	lda.b bosgames
	cmp.w #$0007
	beq .cup
	lda.w gamenum
	asl a
	sta.b a0
	tay
	stz.b d3
	lda.w gsflags,y
	bit.w #$0001
	beq .nf
	lda.w #$0010
	sta.b d3
.nf:
	lda.w tmscore
	cmp.w tmscore+2
	bpl .ns1
	lda.b d3
	eor.w #$0010
	sta.b d3
.ns1:
	lda.b a0
	clc
	adc.b d3
	tay
	lda.w gspotwins,y
	cmp.w #$0003
	bne .winners
.cup:
	lda.w #$0008
	sta.b d0
	lda.w #$000B
	sta.b d2
.cpu:
	lda.w pflags,x
	and.w #$FFF7
	sta.w pflags,x
	inx
	inx
	dec.b d2
	bpl .cpu
	ldx.w #$0000
	stx.b a3
.winners:
	lda.w #$0005
	sta.b d2
	lda.w tmscore
	cmp.w tmscore+2
	beq .notp3
	bpl .celeb
	ldx.w #$000C
	stx.b a3
.celeb:
	lda.w position,x
	beq .next
	jsl.l assinsert
	lda.w #$0007
	sta.b d0
.next:
	inx
	inx
	stx.b a3
	dec.b d2
	bpl .celeb
.gameover:
	jsl.l ClearPenaltyBuffer
	lda.b crowdlevel
	clc
	adc.w #$03E8
	sta.b crowdlevel
	lda.w #$0040
	sta.w gmclock
	tsb.w gmode
	lda.w tmscore
	cmp.w tmscore+2
	bmi .awaywon
	stz.b crowdlevel
	lda.w #$0003
	sta.w cheercnt
	lda.b vcount
	sec
	sbc.w #$0096
	sta.w cheervc
.awaywon:
	lda.w #$0004
	sta.b d0
	jml.l AddPenalty2
.notp3:
	lda.w gsp
	cmp.w #$0003
	bne .perover
	lda.w OptPlayMode
	beq .gameover
.perover:
	lda.w #$0002
	sta.b d0
	jml.l AddPenalty2
