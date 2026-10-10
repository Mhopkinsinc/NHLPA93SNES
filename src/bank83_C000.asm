; $83BCA8-$83CC0B  ROM $1BCA8-$1CC0B: team records Vancouver, Winnipeg, Washington (93G teamdata93.asm, see bank83_8000), playoffseats (93G teamdata93.asm,
; same bytes), then SmallFontTiles: the small font tiles packed for the decompressor $86FA3E (93G SmallFont.map.jim chars). Starts at
; Vancouver, ends at the end of the packed tiles (boundaries moved); the code after it is in bank83_D000.
org $83BCA8

Vancouver:		;93G Vancouver (TeamList 21)
.0:	dw .pld-.0		; $83BCA8 Playerdata
	dw .pad-.0		; $83BCAA Palettedata
	dw .tn-.0		; $83BCAC Teamname
	dw .ls-.0		; $83BCAE LineSets
	dw .sr-.0		; $83BCB0 ScoutReport
	dw .sodds-.0		; $83BCB2 ScoreOdds
.pad:	incbin "../data/Pals/VANh.snespal"		; $83BCB4 home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/VANv.snespal"		; $83BCD4 visitor colours
.sr:	%hex2($4111,$10E8,$6877,$7577)		; $83BCF4 uupu,uuuu,skpd,cfgo
.sodds:	db 211,0		; $83BCFC
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,18,19,13,03,09,05,00		; $83BCFE line 1
	db 01,17,21,12,05,11,03,00		; $83BD06 line 2
	db 01,20,22,16,04,10,03,00		; $83BD0E line 3
	db 01,18,19,13,04,09,05,00		; $83BD16 line 4
	db 01,22,17,12,05,11,04,00		; $83BD1E line 5
	db 01,19,22,06,07,12,05,00		; $83BD26 line 6
	db 01,17,18,12,05,06,07,00		; $83BD2E line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Kirk McLean", $016D,$AFFD,$0100,$DDFF)		; $83BD36 1
	%Player("Troy Gamble", $3567,$AAA7,$0100,$77AA)		; $83BD4B 2
	%Player("Cliff Ronning", $074F,$FDD7,$81DA,$AAD4)		; $83BD60 3
	%Player("Petr Nedved", $1947,$7A77,$41AD,$DAA4)		; $83BD77 4
	%Player("Igor Larionov", $183F,$ADA7,$71DF,$F4F7)		; $83BD8C 5
	%Player("Ryan Walter", $0977,$74A7,$83A7,$AD77)		; $83BDA3 6
	%Player("Tom Fergus", $1584,$4D44,$717D,$A774)		; $83BDB8 7
	%Player("Robert Kron", $5844,$7447,$21A4,$7F71)		; $83BDCC 8
	%Player("Trevor Linden", $168D,$DDAD,$A4DD,$DADA)		; $83BDE1 9
	%Player("Jim Sandlak", $2594,$7ADA,$7A7A,$AA7D)		; $83BDF8 10
	%Player("Pavel Bure", $104F,$FDAA,$71FA,$DDD4)		; $83BE0D 11
	%Player("Greg Adams", $086A,$ADAA,$B1AD,$FDA4)		; $83BE21 12
	%Player("Geoff Courtnall", $146F,$FD7A,$45D7,$DDDD)		; $83BE35 13
	%Player("Gino Odjick", $29A4,$44A4,$AF44,$4D4F)		; $83BE4E 14
	%Player("Garry Valk", $2364,$47A4,$4377,$7A77)		; $83BE63 15
	%Player("Sergio Momesso", $279D,$ADDA,$D77A,$AD7D)		; $83BE77 16
	%Player("Gerald Diduck", $048A,$A77D,$DAA4,$F4AD)		; $83BE8F 17
	%Player("Dave Babych", $4497,$77AA,$85A4,$F7A7)		; $83BEA6 18
	%Player("Jyrki Lumme", $216D,$AAD7,$83DA,$F1D7)		; $83BEBB 19
	%Player("Robert Dirk", $2297,$74A7,$A7A4,$A77D)		; $83BED0 20
	%Player("Dana Murzyn", $0577,$A4DD,$B774,$A77D)		; $83BEE5 21
	%Player("Doug Lidster", $037A,$AADA,$B2D7,$F4D4)		; $83BEFA 22
	%Player("Randy Gregg", $2494,$4444,$5144,$744A)		; $83BF10 23
	%Player("Adrien Plavsic", $0667,$7AD7,$A374,$7177)		; $83BF25 24
	dw 2		; $83BF3D end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Vancouver")		; $83BF3F
.ta:	%String("VAN")		; $83BF4A

Winnipeg:		;93G Winnipeg (TeamList 23)
.0:	dw .pld-.0		; $83BF4F Playerdata
	dw .pad-.0		; $83BF51 Palettedata
	dw .tn-.0		; $83BF53 Teamname
	dw .ls-.0		; $83BF55 LineSets
	dw .sr-.0		; $83BF57 ScoutReport
	dw .sodds-.0		; $83BF59 ScoreOdds
.pad:	incbin "../data/Pals/WPGh.snespal"		; $83BF5B home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/WPGv.snespal"		; $83BF7B visitor colours
.sr:	%hex2($2020,$10E7,$4555,$2185)		; $83BF9B uupu,uuuu,skpd,cfgo
.sodds:	db 149,48		; $83BFA3
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,20,21,17,07,10,04,00		; $83BFA5 line 1
	db 01,18,24,14,04,11,07,00		; $83BFAD line 2
	db 01,22,23,15,05,09,07,00		; $83BFB5 line 3
	db 01,20,21,07,10,11,04,00		; $83BFBD line 4
	db 01,22,18,14,04,12,11,00		; $83BFC5 line 5
	db 01,20,23,15,04,14,05,00		; $83BFCD line 6
	db 01,22,18,14,05,15,04,00		; $83BFD5 line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Bob Essensa", $352F,$9CCF,$0100,$CCCC)		; $83BFDD 1
	%Player("Steph Beauregard", $3056,$9AA6,$0000,$3666)		; $83BFF2 2
	%Player("Rick Tabaracci", $3156,$9AA3,$0100,$3366)		; $83C00C 3
	%Player("Troy Murray", $196C,$9936,$C099,$F9C6)		; $83C024 4
	%Player("Mike Eagles", $3659,$9636,$D599,$C96C)		; $83C039 5
	%Player("Stu Barnes", $1446,$9666,$0069,$6C33)		; $83C04E 6
	%Player("Thomas Steen", $256F,$9CCC,$A3FC,$C3F6)		; $83C062 7
	%Player("Aaron Broten", $1156,$6693,$413C,$6933)		; $83C078 8
	%Player("Lucien Deblois", $2376,$6666,$4066,$9C66)		; $83C08E 9
	%Player("Ed Olczyk", $167C,$9CCC,$63C9,$CCC9)		; $83C0A6 10
	%Player("Pat Elynuik", $1559,$9C6C,$429C,$C969)		; $83C0B9 11
	%Player("Luciano Borsato", $3839,$9966,$609C,$9696)		; $83C0CE 12
	%Player("Danton Cole", $2469,$C333,$4099,$6F36)		; $83C0E7 13
	%Player("Darrin Shannon", $3476,$6999,$919C,$F693)		; $83C0FC 14
	%Player("Phil Sykes", $1743,$0333,$7339,$9F39)		; $83C114 15
	%Player("Doug Evans", $3953,$3990,$633C,$693C)		; $83C128 16
	%Player("Evgeny Davydov", $405C,$C9FC,$42C9,$9CC6)		; $83C13C 17
	%Player("Teppo Numminen", $276C,$99C9,$70C3,$F393)		; $83C154 18
	%Player("Mike Lalor", $2279,$63C6,$7566,$6669)		; $83C16C 19
	%Player("Fredrik Olausson", $047C,$9C0C,$10C6,$F3C3)		; $83C180 20
	%Player("Phil Housley", $064F,$FF6C,$61F6,$C3F9)		; $83C19A 21
	%Player("Randy Carlyle", $0876,$6396,$A360,$F966)		; $83C1B0 22
	%Player("Shawn Cronin", $4480,$0030,$7D00,$C60F)		; $83C1C7 23
	%Player("Mario Marois", $3363,$3333,$6463,$9969)		; $83C1DD 24
	dw 2		; $83C1F3 end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Winnipeg")		; $83C1F5
.ta:	%String("WPG")		; $83C1FF

Washington:		;93G Washington (TeamList 22)
.0:	dw .pld-.0		; $83C204 Playerdata
	dw .pad-.0		; $83C206 Palettedata
	dw .tn-.0		; $83C208 Teamname
	dw .ls-.0		; $83C20A LineSets
	dw .sr-.0		; $83C20C ScoutReport
	dw .sodds-.0		; $83C20E ScoreOdds
.pad:	incbin "../data/Pals/WSHh.snespal"		; $83C210 home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/WSHv.snespal"		; $83C230 visitor colours
.sr:	%hex2($7320,$00E7,$9697,$8458)		; $83C250 uupu,uuuu,skpd,cfgo
.sodds:	db 164,32		; $83C258
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,19,20,12,05,08,04,00		; $83C25A line 1
	db 01,18,24,15,04,11,05,00		; $83C262 line 2
	db 01,21,22,14,06,10,05,00		; $83C26A line 3
	db 01,19,18,15,07,04,05,00		; $83C272 line 4
	db 01,21,20,06,05,08,04,00		; $83C27A line 5
	db 01,21,24,12,05,06,07,00		; $83C282 line 6
	db 01,18,19,06,07,12,05,00		; $83C28A line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Don Beaupre", $3337,$AAAA,$0100,$AAAA)		; $83C292 1
	%Player("Mike Liut", $0167,$AAA7,$0100,$A77A)		; $83C2A7 2
	%Player("Jim Hrivnak", $3954,$AAA4,$0100,$1144)		; $83C2BA 3
	%Player("Dimitri Khristich", $085A,$ADDD,$A0DD,$DAD2)		; $83C2CF 4
	%Player("Mike Ridley", $177D,$DDAD,$81DF,$F4D2)		; $83C2EA 5
	%Player("Michal Pivonka", $207A,$ADDA,$A3DA,$F7A2)		; $83C2FF 6
	%Player("Dale Hunter", $3277,$7DAA,$DB7F,$D4DB)		; $83C317 7
	%Player("Dino Ciccarelli", $224F,$DD7F,$82FA,$DDD8)		; $83C32C 8
	%Player("Paul MacDermid", $2387,$7777,$D67A,$7A7B)		; $83C345 9
	%Player("Peter Bondra", $125D,$DDDA,$71DD,$AAA2)		; $83C35D 10
	%Player("John Druce", $1977,$7ADA,$A07D,$ADA2)		; $83C373 11
	%Player("Kelly Miller", $107D,$DADA,$71D7,$D7D5)		; $83C387 12
	%Player("Alan May", $1674,$747A,$BA4D,$4A4B)		; $83C39D 13
	%Player("Todd Krygier", $2157,$AAA7,$8577,$AD4B)		; $83C3AF 14
	%Player("Randy Burridge", $185D,$AD7D,$73AD,$D4D5)		; $83C3C5 15
	%Player("Nick Kypreos", $0967,$4474,$BB7D,$4A4B)		; $83C3DD 16
	%Player("Dave Tippett", $1457,$A7A4,$4177,$7442)		; $83C3F3 17
	%Player("Calle Johansson", $068D,$ADAD,$A3DA,$F1D2)		; $83C409 18
	%Player("Kevin Hatcher", $04AA,$AADF,$E4D7,$F7D8)		; $83C422 19
	%Player("Sylvain Cote", $035A,$AAAA,$B0A7,$D4A2)		; $83C439 20
	%Player("Al Iafrate", $34AD,$AAAD,$DBDA,$F4AB)		; $83C44F 21
	%Player("Rod Langway", $059A,$74D4,$A1A1,$A172)		; $83C463 22
	%Player("Ken Sabourin", $0284,$4141,$1111,$771B)		; $83C478 23
	%Player("Brad Schlegel", $285A,$7147,$7071,$D770)		; $83C48E 24
	dw 2		; $83C4A5 end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Washington")		; $83C4A7
.ta:	%String("WSH")		; $83C4B3

playoffseats:		;93G playoffseats: 34 playoff trees, 16 team numbers each (maketree)
	db 15,22,11,12, 1,0,6,10, 5,8,23,21, 9,4,18,3		; $83C4B8 tree 0
	db 11,22,15,12, 6,0,1,10, 23,8,5,21, 18,4,9,3		; $83C4C8 tree 1
	db 15,22,7,12, 6,0,16,10, 5,8,2,21, 9,4,20,3		; $83C4D8 tree 2
	db 7,22,15,12, 16,0,1,10, 2,8,5,21, 20,4,9,3		; $83C4E8 tree 3
	db 11,22,7,12, 1,0,16,10, 23,8,2,21, 18,4,20,3		; $83C4F8 tree 4
	db 7,22,11,12, 16,0,6,10, 2,8,23,21, 20,4,18,3		; $83C508 tree 5
	db 11,22,14,12, 1,0,6,10, 5,8,17,21, 9,4,18,3		; $83C518 tree 6
	db 14,22,15,12, 6,0,1,10, 17,8,5,21, 18,4,9,3		; $83C528 tree 7
	db 15,22,14,12, 6,0,16,10, 23,8,17,21, 9,4,20,3		; $83C538 tree 8
	db 14,22,11,12, 16,0,1,10, 17,8,23,21, 20,4,9,3		; $83C548 tree 9
	db 7,22,14,12, 1,0,16,10, 17,8,2,21, 18,4,20,3		; $83C558 tree 10
	db 14,22,7,12, 16,0,6,10, 2,8,17,21, 20,4,18,3		; $83C568 tree 11
	db 15,22,11,12, 1,0,6,10, 5,8,23,21, 9,4,18,3		; $83C578 tree 12
	db 11,22,15,12, 6,0,1,10, 23,8,5,21, 18,4,9,3		; $83C588 tree 13
	db 15,22,11,12, 1,0,13,10, 5,8,23,21, 9,4,19,3		; $83C598 tree 14
	db 15,22,11,12, 13,0,6,10, 5,8,23,21, 19,4,18,3		; $83C5A8 tree 15
	db 3,18,4,9, 21,23,8,5, 10,6,0,1, 12,11,22,15		; $83C5B8 tree 16
	db 3,9,4,18, 21,5,8,23, 10,1,0,6, 12,15,22,11		; $83C5C8 tree 17
	db 3,20,4,9, 21,2,8,5, 10,16,0,6, 12,7,22,15		; $83C5D8 tree 18
	db 3,9,4,20, 21,5,8,2, 10,1,0,16, 12,15,22,7		; $83C5E8 tree 19
	db 3,20,4,18, 21,2,8,23, 10,16,0,1, 12,7,22,11		; $83C5F8 tree 20
	db 3,18,4,20, 21,23,8,2, 10,6,0,16, 12,11,22,7		; $83C608 tree 21
	db 3,18,4,9, 21,17,8,5, 10,6,0,1, 12,14,22,11		; $83C618 tree 22
	db 3,9,4,18, 21,5,8,17, 10,1,0,6, 12,15,22,14		; $83C628 tree 23
	db 3,20,4,9, 21,17,8,23, 10,16,0,6, 12,14,22,15		; $83C638 tree 24
	db 3,9,4,20, 21,23,8,17, 10,1,0,16, 12,11,22,14		; $83C648 tree 25
	db 3,20,4,18, 21,2,8,17, 10,16,0,1, 12,14,22,7		; $83C658 tree 26
	db 3,18,4,20, 21,17,8,2, 10,6,0,16, 12,7,22,14		; $83C668 tree 27
	db 3,18,4,9, 21,23,8,5, 10,6,0,1, 12,11,22,15		; $83C678 tree 28
	db 3,9,4,18, 21,5,8,23, 10,1,0,6, 12,15,22,11		; $83C688 tree 29
	db 3,18,4,9, 21,23,8,5, 10,6,0,1, 12,11,22,15		; $83C698 tree 30
	db 3,9,4,18, 21,5,8,23, 10,1,0,6, 12,15,22,11		; $83C6A8 tree 31
	db 3,19,4,9, 21,23,8,5, 10,13,0,1, 12,11,22,15		; $83C6B8 tree 32
	db 3,18,4,19, 21,23,8,5, 10,6,0,13, 12,11,22,15		; $83C6C8 tree 33
playoffseatsEnd:

SmallFontTiles:		;packed small font tiles (100 4bpp tiles, the print font of SmallFontMap; setupice and banks $83/$88/$8F unpack them, PixelRemap83)
	incbin "../data/SmallFont.chr.pak"		; $83C6D8-$83CC0B
SmallFontTilesEnd:
