DrawGameSetupBack:		;Draw the game setup screen backdrop with the NHLPA logo
	lda.w blankchar
	ldx.w #$07FE
.clr:
	sta.l textmap,x
	dex
	dex
	bpl .clr
	lda.w #GameSetupMap
	sta.b tmp0
	lda.w #GameSetupMap>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	ldx.w #$07FE
.map:
	lda.l TestList,x
	and.w #$DFFF		; priority bit off
	sta.l backmap,x
	dex
	dex
	bpl .map
	stz.b textdirtylo
	lda.w #$03FF
	sta.b textdirtyhi
	lda.w #NHLPALogo		; the NHLPA logo (packed)
	sta.b tmp0
	lda.w #NHLPALogo>>16
	sta.b tmp1
	jsl.l DecompressBytecode
	lda.w #$0009
	sta.b tmp1
.row:
	lda.w #$0007
	sta.b tmp0
.col:
	lda.b tmp1
	sta.b mula
	lda.w #$0008
	sta.b mulb
	jsl.l mulu16		; 16-bit multiply
	adc.b tmp0
	asl a		; logo map word + logochars
	tax
	lda.l TestList,x
	adc.w logochars
	pha
	lda.b tmp1
	asl a
	asl a
	asl a
	asl a
	asl a		; textmap row y * 32 + x + 12
	adc.b tmp0
	asl a
	tax
	pla
	sta.l textmap+$18,x
	dec.b tmp0
	bpl .col
	dec.b tmp1
	bpl .row
	rtl
