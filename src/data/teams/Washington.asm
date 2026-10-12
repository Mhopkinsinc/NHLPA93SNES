Washington:		;team 22
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/WSHh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/WSHv.snespal"		; visitor colours
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
	dw 2		; end of the player list (empty name)
.tn:	%String("Washington")
.ta:	%String("WSH")

