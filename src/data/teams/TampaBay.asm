TampaBay:		;team 19
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/TBYh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/TBYv.snespal"		; visitor colours
.sr:	%hex2($0702,$02A7,$2111,$1411)		; uupu,uuuu,skpd,cfgo
.sodds:	db 48,0
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,13,12,09,02,06,03,00		; line 1
	db 01,14,15,10,03,07,02,00		; line 2
	db 01,16,17,11,04,08,02,00		; line 3
	db 01,12,14,09,02,06,04,00		; line 4
	db 01,15,13,11,04,07,02,00		; line 5
	db 01,14,13,10,03,11,05,00		; line 6
	db 01,16,18,11,05,10,03,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Wendell Young", $0159,$9AA9,$0100,$9699)		; 1
	%Player("Anatoli Semenov", $196C,$9CCC,$71CC,$C9C4)		; 2
	%Player("Rob Dimaio", $1846,$9303,$1269,$9F05)		; 3
	%Player("Brian Bradley", $443B,$8858,$8488,$5585)		; 4
	%Player("Michel Mongeau", $4163,$3960,$3139,$6360)		; 5
	%Player("Tim Hunter", $1572,$2285,$BC22,$2B2F)		; 6
	%Player("Tim Bergland", $1161,$4444,$1044,$7740)		; 7
	%Player("Shayne Stevenson", $4960,$0222,$2000,$282A)		; 8
	%Player("Mike Hartman", $2069,$9363,$CD33,$9F3C)		; 9
	%Player("Dan Vincelette", $1675,$5202,$2125,$5B2A)		; 10
	%Player("Basil McRae", $1785,$5225,$9F55,$2B2F)		; 11
	%Player("Peter Taglianeti", $3276,$63CC,$C593,$C669)		; 12
	%Player("Joe Reekie", $299C,$66C9,$7596,$F36B)		; 13
	%Player("Rob Ramage", $0578,$555B,$B685,$EBBD)		; 14
	%Player("Doug Crossman", $2867,$77D7,$7371,$71A4)		; 15
	%Player("Bob McGill", $0464,$411D,$B274,$7F4A)		; 16
	%Player("Jeff Bloemberg", $3870,$0020,$2000,$222A)		; 17
	%Player("Shawn Chambers", $2570,$0000,$2100,$220A)		; 18
	dw 2		; end of the player list (empty name)
.tn:	%String("Tampa Bay")
.ta:	%String("TBY")

