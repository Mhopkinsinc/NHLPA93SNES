Vancouver:		;team 21
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/VANh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/VANv.snespal"		; visitor colours
.sr:	%hex2($4111,$10E8,$6877,$7577)		; uupu,uuuu,skpd,cfgo
.sodds:	db 211,0
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,18,19,13,03,09,05,00		; line 1
	db 01,17,21,12,05,11,03,00		; line 2
	db 01,20,22,16,04,10,03,00		; line 3
	db 01,18,19,13,04,09,05,00		; line 4
	db 01,22,17,12,05,11,04,00		; line 5
	db 01,19,22,06,07,12,05,00		; line 6
	db 01,17,18,12,05,06,07,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Kirk McLean", $016D,$AFFD,$0100,$DDFF)		; 1
	%Player("Troy Gamble", $3567,$AAA7,$0100,$77AA)		; 2
	%Player("Cliff Ronning", $074F,$FDD7,$81DA,$AAD4)		; 3
	%Player("Petr Nedved", $1947,$7A77,$41AD,$DAA4)		; 4
	%Player("Igor Larionov", $183F,$ADA7,$71DF,$F4F7)		; 5
	%Player("Ryan Walter", $0977,$74A7,$83A7,$AD77)		; 6
	%Player("Tom Fergus", $1584,$4D44,$717D,$A774)		; 7
	%Player("Robert Kron", $5844,$7447,$21A4,$7F71)		; 8
	%Player("Trevor Linden", $168D,$DDAD,$A4DD,$DADA)		; 9
	%Player("Jim Sandlak", $2594,$7ADA,$7A7A,$AA7D)		; 10
	%Player("Pavel Bure", $104F,$FDAA,$71FA,$DDD4)		; 11
	%Player("Greg Adams", $086A,$ADAA,$B1AD,$FDA4)		; 12
	%Player("Geoff Courtnall", $146F,$FD7A,$45D7,$DDDD)		; 13
	%Player("Gino Odjick", $29A4,$44A4,$AF44,$4D4F)		; 14
	%Player("Garry Valk", $2364,$47A4,$4377,$7A77)		; 15
	%Player("Sergio Momesso", $279D,$ADDA,$D77A,$AD7D)		; 16
	%Player("Gerald Diduck", $048A,$A77D,$DAA4,$F4AD)		; 17
	%Player("Dave Babych", $4497,$77AA,$85A4,$F7A7)		; 18
	%Player("Jyrki Lumme", $216D,$AAD7,$83DA,$F1D7)		; 19
	%Player("Robert Dirk", $2297,$74A7,$A7A4,$A77D)		; 20
	%Player("Dana Murzyn", $0577,$A4DD,$B774,$A77D)		; 21
	%Player("Doug Lidster", $037A,$AADA,$B2D7,$F4D4)		; 22
	%Player("Randy Gregg", $2494,$4444,$5144,$744A)		; 23
	%Player("Adrien Plavsic", $0667,$7AD7,$A374,$7177)		; 24
	dw 2		; end of the player list (empty name)
.tn:	%String("Vancouver")
.ta:	%String("VAN")

