Winnipeg:		;team 23
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/WPGh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/WPGv.snespal"		; visitor colours
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
	dw 2		; end of the player list (empty name)
.tn:	%String("Winnipeg")
.ta:	%String("WPG")

