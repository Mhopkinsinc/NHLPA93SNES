Quebec:		;team 16
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/QUEh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/QUEv.snespal"		; visitor colours
.sr:	%hex2($2602,$22E8,$3212,$1321)		; uupu,uuuu,skpd,cfgo
.sodds:	db 84,32
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,20,19,17,05,10,04,00		; line 1
	db 01,18,24,14,04,08,05,00		; line 2
	db 01,21,22,16,07,09,05,00		; line 3
	db 01,20,19,05,10,09,04,00		; line 4
	db 01,22,24,14,04,08,09,00		; line 5
	db 01,20,24,16,04,14,05,00		; line 6
	db 01,21,18,14,05,16,04,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Jacques Cloutier", $3232,$8AA2,$0100,$2225)		; 1
	%Player("Stephane Fiset", $3142,$8AA0,$0100,$2200)		; 2
	%Player("John Tanner", $3450,$8AA0,$0100,$0000)		; 3
	%Player("Claude Lapointe", $4748,$8855,$5388,$E859)		; 4
	%Player("Joe Sakic", $195B,$BE88,$51B8,$E5E3)		; 5
	%Player("Jamie Baker", $2860,$0552,$2155,$5B23)		; 6
	%Player("Marc Fortier", $0968,$8522,$3058,$8856)		; 7
	%Player("Mats Sundin", $136B,$BB2B,$32BB,$B8B9)		; 8
	%Player("Greg Paslawski", $2365,$5828,$508E,$BB53)		; 9
	%Player("Owen Nolan", $116B,$BB5B,$36BE,$B88C)		; 10
	%Player("Herb Raglan", $1485,$B555,$2625,$582C)		; 11
	%Player("Mike McNeill", $2068,$B222,$2155,$5553)		; 12
	%Player("Gino Cavallini", $4492,$8555,$5355,$5B56)		; 13
	%Player("Mike Hough", $1868,$5888,$538B,$E589)		; 14
	%Player("John Tonelli", $2178,$8555,$B355,$5559)		; 15
	%Player("Doug Smail", $4148,$8822,$232B,$B529)		; 16
	%Player("Valeri Kamensky", $177B,$BB5E,$60BB,$82B3)		; 17
	%Player("Craig Wolanin", $0685,$5222,$5722,$B529)		; 18
	%Player("Alexei Gusarov", $0558,$8558,$6185,$B283)		; 19
	%Player("Mikhail Tatarinov", $0468,$88BE,$B5B2,$E5B9)		; 20
	%Player("Steven Finn", $2975,$5228,$9B52,$B85C)		; 21
	%Player("Adam Foote", $5255,$5252,$8252,$B856)		; 22
	%Player("Tony Twist", $1590,$0050,$3D00,$280C)		; 23
	%Player("Curtis Leschyshyn", $0788,$B505,$8355,$E289)		; 24
	%Player("Dan Lambert", $5042,$2822,$015B,$5256)		; 25
	dw 2		; end of the player list (empty name)
.tn:	%String("Quebec")
.ta:	%String("QUE")

