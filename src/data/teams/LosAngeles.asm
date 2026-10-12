LosAngeles:		;team 8
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/LAh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/LAv.snespal"		; visitor colours
.sr:	%hex2($4410,$10D8,$5664,$6535)		; uupu,uuuu,skpd,cfgo
.sodds:	db 198,16
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,19,20,11,05,10,04,00		; line 1
	db 01,18,21,12,04,09,05,00		; line 2
	db 01,17,22,13,06,08,05,00		; line 3
	db 01,19,20,11,05,10,04,00		; line 4
	db 01,17,18,12,04,09,05,00		; line 5
	db 01,17,18,12,06,13,04,00		; line 6
	db 01,19,20,13,04,12,06,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Kelly Hrudey", $3259,$9AAC,$0100,$6669)		; 1
	%Player("Steve Weeks", $0133,$9AA3,$0100,$6633)		; 2
	%Player("David Goverde", $4380,$9AA3,$0000,$0330)		; 3
	%Player("Bob Kudelski", $3779,$9939,$629C,$FC94)		; 4
	%Player("Wayne Gretzky", $993F,$CF36,$61FC,$C3F4)		; 5
	%Player("John McIntyre", $4456,$6696,$9369,$C36A)		; 6
	%Player("Corey Millen", $2339,$CC96,$629C,$669A)		; 7
	%Player("Dave Taylor", $1869,$66C9,$9299,$9667)		; 8
	%Player("Jari Kurri", $176C,$9C3C,$6099,$C994)		; 9
	%Player("Tomas Sandstrom", $077C,$CC6F,$A7C9,$CC9A)		; 10
	%Player("Luc Robitaille", $206C,$CF6C,$71FC,$C6CA)		; 11
	%Player("Tony Granato", $215C,$FC99,$949C,$FC9D)		; 12
	%Player("Mike Donnelly", $115C,$C996,$936C,$CC94)		; 13
	%Player("Jay Miller", $2986,$6369,$CD69,$396D)		; 14
	%Player("Kyosti Karjalanen", $146C,$C6C9,$3193,$6364)		; 15
	%Player("Scott Bjugstad", $0853,$3669,$3166,$6C64)		; 16
	%Player("Peter Ahola", $2686,$66C9,$9766,$F66A)		; 17
	%Player("Marty McSorley", $33B3,$9639,$CC93,$F39F)		; 18
	%Player("Paul Coffey", $777F,$FC9C,$71F3,$F3FA)		; 19
	%Player("Rob Blake", $049C,$966C,$9293,$F99D)		; 20
	%Player("Larry Robinson", $19A9,$6396,$A396,$9397)		; 21
	%Player("Charlie Huddy", $2289,$6639,$9393,$9397)		; 22
	%Player("Tim Watters", $0556,$6363,$7360,$636D)		; 23
	%Player("Brent Thompson", $5643,$3333,$6530,$633D)		; 24
	dw 2		; end of the player list (empty name)
.tn:	%String("Los Angeles")
.ta:	%String("LA")

