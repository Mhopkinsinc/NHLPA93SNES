ResolveGames:		;Record the played playoff game and the series wins; when the round is over, move on to the next round
	lda.w gamenum
	asl a
	sta.b d0
	stz.b a0		; copy the score of the played game
	tay
	lda.w tmscore
	sta.w gss1,y
	lda.w tmscore+2
	sta.w gss2,y
	jsl.l GetShifter
	lda.b d1
	asl a
	sta.b a0
	lda.b bosgames
	cmp.w #7
	bne .b0
	jmp.w .notbos
.b0:
	ldy.b a0
	lda.w #4
	cmp.w gspotwins,y
	beq .b1
	cmp.w gspobwins,y
	beq .b1
	stz.b d3
	lda.w gsflags,y		; gsflags bit 0 (gsftf): teams swapped
	bit.w #$0001
	beq .nf
	lda.w #$0010
	sta.b d3
.nf:
	lda.w gss1,y
	cmp.w gss2,y
	bpl .ns1
	lda.b d3
	eor.w #$0010
	sta.b d3
.ns1:
	lda.b a0
	clc
	adc.b d3
	tax
	inc.w gspotwins,x
.b1:
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .b0
	inc.b bosgames		; next game of the series
	lda.b bosgames
	cmp.w #7
	bne .more
	jmp.w .nextround
.more:
	lda.w gamenum
	asl a
	sta.b a0
	tay
	lda.w #4
	cmp.w gspotwins,y
	beq .cround
	cmp.w gspobwins,y
	beq .cround
	jmp.w .rtl
.cround:		;finish the other series of the round
	lda.w gamelevel
	sec
	sbc.w #3
	bmi .lvlneg
	bvs .cr
	bra .nextround
.lvlneg:
	bvs .nextround
.cr:
	jsl.l GetShifter
	lda.b d1
	asl a
	sta.b a0
.cr0:
	ldy.b a0
	lda.b d1
	cmp.w gamenum
	beq .crn
	lda.w #4
	cmp.w gspotwins,y
	beq .crn
	cmp.w gspobwins,y
	beq .crn
	lda.w gspotwins,y
	inc a
	sta.w gspotwins,y
	lda.w #200		; random series result: 50/50 per game
	jsl.l randoma
	lsr a
	bcc .cr0
	lda.w gspotwins,y
	dec a
	sta.w gspotwins,y
	lda.w gspobwins,y
	inc a
	sta.w gspobwins,y
	bra .cr0
.crn:
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .cr0
	jsl.l WritePassBits		; sf3alttree: passbits before the rest was resolved
	ldy.w #$000E
.cp:
	lda.w passbits,y
	sta.w tpassbits,y
	dey
	dey
	bpl .cp
	lda.w #sf3alttree
	tsb.w sflags3
.nextround:
	stz.b bosgames
	jsl.l GetShifter
	lda.b d1
	asl a
	sta.b a0
	stz.b d3
.nr0:
	ldy.b a0
	lda.w gspotwins,y
	cmp.w #$0004
	beq .nr1
	lda.b d1
	asl a
	tax
	lda.l BitMaskTable,x
	tsb.b d3
.nr1:
	lda.w #$0000
	sta.w gspotwins,y
	sta.w gspobwins,y
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .nr0
	lda.b d2		; WinBits: the winners of level d2
	asl a
	tax
	lda.l BitMaskTable,x
	sta.b mula
	dec a
	and.w WinBits
	sta.w WinBits
	lda.b d3
	sta.b mulb
	jsl.l mulu16		; 16-bit multiply
	tsb.w WinBits
	inc.w gamelevel
.rtl:
	rtl
.notbos:		;single games
	stz.b d3
.s0:
	ldy.b a0
	lda.w gss2,y
	cmp.w gss1,y
	bcc .s1
	lda.b d1
	asl a
	tax
	lda.l BitMaskTable,x
	tsb.b d3
.s1:
	lda.w gsflags,y
	bit.w #$0001
	beq .s2
	lda.b d1
	asl a
	tax
	lda.l BitMaskTable,x
	eor.b d3
	sta.b d3
.s2:
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .s0
	lda.b d2
	asl a
	tax
	lda.l BitMaskTable,x
	sta.b mula
	dec a
	and.w WinBits
	sta.w WinBits
	lda.b d3
	sta.b mulb
	jsl.l mulu16		; 16-bit multiply
	tsb.w WinBits
	inc.w gamelevel
	rtl
