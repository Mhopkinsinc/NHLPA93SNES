; $83BCA8-$83CC0B  ROM $1BCA8-$1CC0B: team records Vancouver, Winnipeg, Washington (93G teamdata93.asm, see bank83_8000), playoffseats (93G teamdata93.asm,
; same bytes), then SmallFontTiles: the small font tiles packed for the decompressor $86FA3E (93G SmallFont.map.jim chars). Starts at
; Vancouver, ends at the end of the packed tiles (boundaries moved); the code after it is in bank83_D000.
org $83BCA8

Vancouver:		;93G Vancouver (TeamList 21)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/VANh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/VANv.snespal"		; visitor colours
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
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Vancouver")
.ta:	%String("VAN")

Winnipeg:		;93G Winnipeg (TeamList 23)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/WPGh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/WPGv.snespal"		; visitor colours
.sr:	%hex2($2020,$10E7,$4555,$2185)		; uupu,uuuu,skpd,cfgo
.sodds:	db 149,48
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,20,21,17,07,10,04,00		; line 1
	db 01,18,24,14,04,11,07,00		; line 2
	db 01,22,23,15,05,09,07,00		; line 3
	db 01,20,21,07,10,11,04,00		; line 4
	db 01,22,18,14,04,12,11,00		; line 5
	db 01,20,23,15,04,14,05,00		; line 6
	db 01,22,18,14,05,15,04,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Bob Essensa", $352F,$9CCF,$0100,$CCCC)		; 1
	%Player("Steph Beauregard", $3056,$9AA6,$0000,$3666)		; 2
	%Player("Rick Tabaracci", $3156,$9AA3,$0100,$3366)		; 3
	%Player("Troy Murray", $196C,$9936,$C099,$F9C6)		; 4
	%Player("Mike Eagles", $3659,$9636,$D599,$C96C)		; 5
	%Player("Stu Barnes", $1446,$9666,$0069,$6C33)		; 6
	%Player("Thomas Steen", $256F,$9CCC,$A3FC,$C3F6)		; 7
	%Player("Aaron Broten", $1156,$6693,$413C,$6933)		; 8
	%Player("Lucien Deblois", $2376,$6666,$4066,$9C66)		; 9
	%Player("Ed Olczyk", $167C,$9CCC,$63C9,$CCC9)		; 10
	%Player("Pat Elynuik", $1559,$9C6C,$429C,$C969)		; 11
	%Player("Luciano Borsato", $3839,$9966,$609C,$9696)		; 12
	%Player("Danton Cole", $2469,$C333,$4099,$6F36)		; 13
	%Player("Darrin Shannon", $3476,$6999,$919C,$F693)		; 14
	%Player("Phil Sykes", $1743,$0333,$7339,$9F39)		; 15
	%Player("Doug Evans", $3953,$3990,$633C,$693C)		; 16
	%Player("Evgeny Davydov", $405C,$C9FC,$42C9,$9CC6)		; 17
	%Player("Teppo Numminen", $276C,$99C9,$70C3,$F393)		; 18
	%Player("Mike Lalor", $2279,$63C6,$7566,$6669)		; 19
	%Player("Fredrik Olausson", $047C,$9C0C,$10C6,$F3C3)		; 20
	%Player("Phil Housley", $064F,$FF6C,$61F6,$C3F9)		; 21
	%Player("Randy Carlyle", $0876,$6396,$A360,$F966)		; 22
	%Player("Shawn Cronin", $4480,$0030,$7D00,$C60F)		; 23
	%Player("Mario Marois", $3363,$3333,$6463,$9969)		; 24
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Winnipeg")
.ta:	%String("WPG")

Washington:		;93G Washington (TeamList 22)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/WSHh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/WSHv.snespal"		; visitor colours
.sr:	%hex2($7320,$00E7,$9697,$8458)		; uupu,uuuu,skpd,cfgo
.sodds:	db 164,32
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,19,20,12,05,08,04,00		; line 1
	db 01,18,24,15,04,11,05,00		; line 2
	db 01,21,22,14,06,10,05,00		; line 3
	db 01,19,18,15,07,04,05,00		; line 4
	db 01,21,20,06,05,08,04,00		; line 5
	db 01,21,24,12,05,06,07,00		; line 6
	db 01,18,19,06,07,12,05,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Don Beaupre", $3337,$AAAA,$0100,$AAAA)		; 1
	%Player("Mike Liut", $0167,$AAA7,$0100,$A77A)		; 2
	%Player("Jim Hrivnak", $3954,$AAA4,$0100,$1144)		; 3
	%Player("Dimitri Khristich", $085A,$ADDD,$A0DD,$DAD2)		; 4
	%Player("Mike Ridley", $177D,$DDAD,$81DF,$F4D2)		; 5
	%Player("Michal Pivonka", $207A,$ADDA,$A3DA,$F7A2)		; 6
	%Player("Dale Hunter", $3277,$7DAA,$DB7F,$D4DB)		; 7
	%Player("Dino Ciccarelli", $224F,$DD7F,$82FA,$DDD8)		; 8
	%Player("Paul MacDermid", $2387,$7777,$D67A,$7A7B)		; 9
	%Player("Peter Bondra", $125D,$DDDA,$71DD,$AAA2)		; 10
	%Player("John Druce", $1977,$7ADA,$A07D,$ADA2)		; 11
	%Player("Kelly Miller", $107D,$DADA,$71D7,$D7D5)		; 12
	%Player("Alan May", $1674,$747A,$BA4D,$4A4B)		; 13
	%Player("Todd Krygier", $2157,$AAA7,$8577,$AD4B)		; 14
	%Player("Randy Burridge", $185D,$AD7D,$73AD,$D4D5)		; 15
	%Player("Nick Kypreos", $0967,$4474,$BB7D,$4A4B)		; 16
	%Player("Dave Tippett", $1457,$A7A4,$4177,$7442)		; 17
	%Player("Calle Johansson", $068D,$ADAD,$A3DA,$F1D2)		; 18
	%Player("Kevin Hatcher", $04AA,$AADF,$E4D7,$F7D8)		; 19
	%Player("Sylvain Cote", $035A,$AAAA,$B0A7,$D4A2)		; 20
	%Player("Al Iafrate", $34AD,$AAAD,$DBDA,$F4AB)		; 21
	%Player("Rod Langway", $059A,$74D4,$A1A1,$A172)		; 22
	%Player("Ken Sabourin", $0284,$4141,$1111,$771B)		; 23
	%Player("Brad Schlegel", $285A,$7147,$7071,$D770)		; 24
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Washington")
.ta:	%String("WSH")

playoffseats:		;93G playoffseats: 34 playoff trees, 16 team numbers each (maketree)
	db 15,22,11,12, 1,0,6,10, 5,8,23,21, 9,4,18,3		; tree 0
	db 11,22,15,12, 6,0,1,10, 23,8,5,21, 18,4,9,3		; tree 1
	db 15,22,7,12, 6,0,16,10, 5,8,2,21, 9,4,20,3		; tree 2
	db 7,22,15,12, 16,0,1,10, 2,8,5,21, 20,4,9,3		; tree 3
	db 11,22,7,12, 1,0,16,10, 23,8,2,21, 18,4,20,3		; tree 4
	db 7,22,11,12, 16,0,6,10, 2,8,23,21, 20,4,18,3		; tree 5
	db 11,22,14,12, 1,0,6,10, 5,8,17,21, 9,4,18,3		; tree 6
	db 14,22,15,12, 6,0,1,10, 17,8,5,21, 18,4,9,3		; tree 7
	db 15,22,14,12, 6,0,16,10, 23,8,17,21, 9,4,20,3		; tree 8
	db 14,22,11,12, 16,0,1,10, 17,8,23,21, 20,4,9,3		; tree 9
	db 7,22,14,12, 1,0,16,10, 17,8,2,21, 18,4,20,3		; tree 10
	db 14,22,7,12, 16,0,6,10, 2,8,17,21, 20,4,18,3		; tree 11
	db 15,22,11,12, 1,0,6,10, 5,8,23,21, 9,4,18,3		; tree 12
	db 11,22,15,12, 6,0,1,10, 23,8,5,21, 18,4,9,3		; tree 13
	db 15,22,11,12, 1,0,13,10, 5,8,23,21, 9,4,19,3		; tree 14
	db 15,22,11,12, 13,0,6,10, 5,8,23,21, 19,4,18,3		; tree 15
	db 3,18,4,9, 21,23,8,5, 10,6,0,1, 12,11,22,15		; tree 16
	db 3,9,4,18, 21,5,8,23, 10,1,0,6, 12,15,22,11		; tree 17
	db 3,20,4,9, 21,2,8,5, 10,16,0,6, 12,7,22,15		; tree 18
	db 3,9,4,20, 21,5,8,2, 10,1,0,16, 12,15,22,7		; tree 19
	db 3,20,4,18, 21,2,8,23, 10,16,0,1, 12,7,22,11		; tree 20
	db 3,18,4,20, 21,23,8,2, 10,6,0,16, 12,11,22,7		; tree 21
	db 3,18,4,9, 21,17,8,5, 10,6,0,1, 12,14,22,11		; tree 22
	db 3,9,4,18, 21,5,8,17, 10,1,0,6, 12,15,22,14		; tree 23
	db 3,20,4,9, 21,17,8,23, 10,16,0,6, 12,14,22,15		; tree 24
	db 3,9,4,20, 21,23,8,17, 10,1,0,16, 12,11,22,14		; tree 25
	db 3,20,4,18, 21,2,8,17, 10,16,0,1, 12,14,22,7		; tree 26
	db 3,18,4,20, 21,17,8,2, 10,6,0,16, 12,7,22,14		; tree 27
	db 3,18,4,9, 21,23,8,5, 10,6,0,1, 12,11,22,15		; tree 28
	db 3,9,4,18, 21,5,8,23, 10,1,0,6, 12,15,22,11		; tree 29
	db 3,18,4,9, 21,23,8,5, 10,6,0,1, 12,11,22,15		; tree 30
	db 3,9,4,18, 21,5,8,23, 10,1,0,6, 12,15,22,11		; tree 31
	db 3,19,4,9, 21,23,8,5, 10,13,0,1, 12,11,22,15		; tree 32
	db 3,18,4,19, 21,23,8,5, 10,6,0,13, 12,11,22,15		; tree 33
playoffseatsEnd:

SmallFontTiles:		;packed small font tiles (100 4bpp tiles, the print font of SmallFontMap; setupice and banks $83/$88/$8F unpack them, PixelRemap83)
	incbin "../data/SmallFont.chr.pak"		; $83C6D8-$83CC0B
SmallFontTilesEnd:
