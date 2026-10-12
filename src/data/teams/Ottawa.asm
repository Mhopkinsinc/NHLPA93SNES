Ottawa:		;team 13
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/OTWh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/OTWv.snespal"		; visitor colours
.sr:	%hex2($0702,$02A6,$1111,$1411)		; uupu,uuuu,skpd,cfgo
.sodds:	db 96,0
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,12,13,10,07,02,03,00		; line 1
	db 01,14,15,08,03,06,10,00		; line 2
	db 01,16,17,09,04,05,10,00		; line 3
	db 01,12,13,08,03,06,10,00		; line 4
	db 01,17,14,07,10,02,03,00		; line 5
	db 01,12,13,10,02,08,09,00		; line 6
	db 01,17,16,08,09,10,02,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Peter Sidorkwicz", $3055,$8AA5,$0100,$5555)		; 1
	%Player("Mark Lamb", $075C,$C996,$9196,$6397)		; 2
	%Player("Mark Freer", $3756,$6393,$736C,$6963)		; 3
	%Player("Laurie Boschman", $165D,$77D7,$A577,$D77B)		; 4
	%Player("Rob Murphy", $1780,$0202,$2100,$280A)		; 5
	%Player("Jim Thomson", $2586,$6093,$9A33,$3C3D)		; 6
	%Player("Chris Lindberg", $3368,$B5B5,$5388,$555A)		; 7
	%Player("Sylvain Turgeon", $207D,$D77D,$7377,$AD75)		; 8
	%Player("Mike Peluso", $4474,$44A4,$DD4D,$4D4F)		; 9
	%Player("Jeff Lazaro", $145C,$F6C6,$9796,$6C68)		; 10
	%Player("Darcy Loewen", $3650,$0202,$2100,$250A)		; 11
	%Player("Ken Hammond", $0668,$8528,$5582,$B85C)		; 12
	%Player("Brad Shaw", $326B,$2588,$5282,$8285)		; 13
	%Player("Kent Paynter", $0550,$0020,$2100,$220A)		; 14
	%Player("Dominic Lavoie", $3880,$0020,$2000,$220A)		; 15
	%Player("Darren Rumble", $3470,$0020,$2100,$220A)		; 16
	%Player("Brad Miller", $44A2,$5255,$8D22,$855F)		; 17
	dw 2		; end of the player list (empty name)
.tn:	%String("Ottawa")
.ta:	%String("OTW")

