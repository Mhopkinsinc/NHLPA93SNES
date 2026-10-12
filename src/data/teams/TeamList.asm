TeamList:		;long pointer to each team record (TeamList index = team number)
	dd Boston		; team 0
	dd Buffalo		; team 1
	dd Calgary		; team 2
	dd Chicago		; team 3
	dd Detroit		; team 4
	dd Edmonton		; team 5
	dd Hartford		; team 6
	dd LongIsland		; team 7
	dd LosAngeles		; team 8
	dd Minnesota		; team 9
	dd Montreal		; team 10
	dd NewJersey		; team 11
	dd NewYork		; team 12
	dd Ottawa		; team 13
	dd Philadelphia		; team 14
	dd Pittsburgh		; team 15
	dd Quebec		; team 16
	dd SanJose		; team 17
	dd StLouis		; team 18
	dd TampaBay		; team 19
	dd Toronto		; team 20
	dd Vancouver		; team 21
	dd Washington		; team 22
	dd Winnipeg		; team 23
	dd AllStarsEast		; team 24
	dd AllStarsWest		; team 25
	assert (TeamListEnd-TeamList)/4 == NumofTeams
TeamListEnd:

