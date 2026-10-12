PrintTeamNameAndScore:		;Print team a2's name, then its score as two characters
	jsl.l printteamname
	lda.w #mesarea
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	lda.w #4
	sta.b [a1]
	lda.w #' '		; blank tens
	sta.w mesarea+2
	ldy.b a2
	lda.w tmscore,y
	sta.b mulb
	lda.w #10
	sta.b mula
	jsl.l divu16
	beq .ones
	adc.w #'0'
	sta.w mesarea+2
.ones:
	lda.b mulres+2
	adc.w #'0'
	sta.w mesarea+3
	jml.l print
