AttribEnergy:		;Roster column: the player's energy, scaled to at most 100
	asl.b d0
	lda.b a2
	beq .team
	lda.w #$0034
.team:
	adc.b d0
	tay
	lda.w tmpde,y		; divu16 by 40
	sta.b mulb
	lda.w #$0028
	sta.b mula
	jsl.l divu16
	cmp.w #$0065
	bcc .cap
	lda.w #$0064
.cap:
	sta.b d0
	bra AttribPrintPct
