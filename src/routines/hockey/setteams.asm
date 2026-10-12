setteams:		;use hometeam/visteam to set team structures. Falls in from clearTeamStats.
		;   SNES: with InitTeamStructure: use HomeTeam/VisTeam to set the team structs (tmsort, tmteam, tmdata from TeamList). Falls in from ClearTeamStats
	stz.w tmsort		; home: tmsort 0, away: tmsort $0C
	lda.w #$000C
	sta.w tmsort+2
	lda.w HomeTeam
	sta.w tmteam
	asl a
	asl a
	tax
	lda.l TeamList,x
	sta.w tmdata
	lda.w VisTeam
	sta.w tmteam+2
	asl a
	asl a
	tax
	lda.l TeamList,x
	sta.w tmdata+2
	rtl
