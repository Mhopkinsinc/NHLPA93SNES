Detroit:		;team 4
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/DETh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/DETv.snespal"		; visitor colours
.sr:	%hex2($6111,$00D7,$8879,$7878)		; uupu,uuuu,skpd,cfgo
.sodds:	db 226,16
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,17,20,13,06,08,04,00		; line 1
	db 01,18,22,14,04,07,06,00		; line 2
	db 01,19,21,15,05,09,06,00		; line 3
	db 01,17,20,06,04,08,05,00		; line 4
	db 01,21,18,15,05,09,06,00		; line 5
	db 01,20,18,06,07,13,04,00		; line 6
	db 01,17,19,13,04,06,07,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Tim Cheveldae", $325D,$ADDD,$0100,$DADD)		; 1
	%Player("Greg Millen", $3447,$AAA4,$0000,$7774)		; 2
	%Player("Vincent Riendeau", $375A,$AAA7,$0100,$A77A)		; 3
	%Player("Sergei Fedorov", $916F,$FDDD,$A5FA,$FAF7)		; 4
	%Player("Jimmy Carson", $1277,$DDDD,$52DF,$D7D4)		; 5
	%Player("Steve Yzerman", $195F,$FFDD,$50FD,$FAF7)		; 6
	%Player("Kevin Miller", $236D,$DAAA,$B6DD,$DAA7)		; 7
	%Player("Ray Sheppard", $2657,$7DAA,$B2AD,$DD74)		; 8
	%Player("Bob Probert", $249D,$ADDA,$FF7F,$D7AF)		; 9
	%Player("Brent Fedyk", $1464,$747A,$8477,$7D77)		; 10
	%Player("Alan Kerr", $186A,$A4A7,$BA77,$4A7D)		; 11
	%Player("Sheldon Kennedy", $283A,$A777,$7477,$7777)		; 12
	%Player("Paul Ysebaert", $216D,$DDFA,$87DD,$DAD7)		; 13
	%Player("Shawn Burr", $1157,$7AD7,$D77A,$A77A)		; 14
	%Player("Gerard Gallant", $1757,$7ADA,$DBAA,$DAAD)		; 15
	%Player("Keith Primeau", $55AA,$AADA,$577F,$747D)		; 16
	%Player("Nicklas Lidstrom", $054D,$ADFA,$A5D7,$F4D4)		; 17
	%Player("Vladimir Konstantov", $164A,$AADA,$EAA7,$F4AD)		; 18
	%Player("Brad McCrimmon", $027A,$77F7,$D747,$D4AA)		; 19
	%Player("Steve Chiasson", $038A,$AAFD,$BB77,$F4AD)		; 20
	%Player("Yves Racine", $335A,$A77D,$B5A4,$D4AA)		; 21
	%Player("Brad Marsh", $20A4,$74D4,$A547,$A47A)		; 22
	%Player("Bobby Dollas", $0897,$A4D1,$231A,$7F17)		; 23
	dw 2		; end of the player list (empty name)
.tn:	%String("Detroit")
.ta:	%String("DET")

