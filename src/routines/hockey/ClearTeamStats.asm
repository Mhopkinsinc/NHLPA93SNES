ClearTeamStats:		;Clear the team stats (but the goalie choice) and both penalty box lists, then set up the teams
	lda.w tmgoalie		; keep tmgoalie (2 words)
	pha
	lda.w tmgoalie+2
	pha
	ldx.w #$0000
.clr:
	stz.w tmshots,x
	inx
	inx
	cpx.w #$01CC
	bne .clr
	pla
	sta.w tmgoalie+2
	pla
	sta.w tmgoalie
	lda.w #$FFFF		; both penalty box lists empty
	sta.w tmboxlist
	sta.w tmboxlist+$1A
	jml.l setteams
