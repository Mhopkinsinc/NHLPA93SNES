LongIsland:		;team 7
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/LIh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/LIv.snespal"		; visitor colours
.sr:	%hex2($5522,$01E7,$5455,$5234)		; uupu,uuuu,skpd,cfgo
.sodds:	db 102,0
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,20,17,13,04,12,03,00		; line 1
	db 01,18,19,14,03,11,04,00		; line 2
	db 01,21,23,15,06,10,04,00		; line 3
	db 01,20,17,15,14,04,06,00		; line 4
	db 01,23,18,13,06,03,14,00		; line 5
	db 01,17,19,16,07,08,11,00		; line 6
	db 01,20,22,08,11,16,07,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Glenn Healy", $3546,$9AA6,$0100,$3636)		; 1
	%Player("Mark Fitzpatrik", $3063,$9AA3,$0100,$3366)		; 2
	%Player("Ray Ferraro", $2056,$9CCC,$65CF,$C698)		; 3
	%Player("Pierre Turgeon", $777C,$CF9C,$93CC,$C6C2)		; 4
	%Player("Adam Creighton", $1189,$6963,$656C,$6C68)		; 5
	%Player("Benoit Hogue", $336C,$FCF9,$65CC,$C6C5)		; 6
	%Player("Claude Loiselle", $1069,$6333,$9796,$6C68)		; 7
	%Player("Hubie McDonough", $3959,$9666,$756F,$9F62)		; 8
	%Player("Dan Marois", $2469,$9909,$3299,$6C68)		; 9
	%Player("Mick Vukota", $1260,$9063,$7C00,$990E)		; 10
	%Player("Tom Fitzgerald", $1463,$0663,$1066,$CC35)		; 11
	%Player("Patrick Flatley", $2679,$6CF6,$A2C9,$93C5)		; 12
	%Player("Steve Thomas", $325C,$FC99,$A599,$C9C8)		; 13
	%Player("Derek King", $2779,$6C6C,$33CF,$C962)		; 14
	%Player("Dave Volek", $255C,$CC96,$31C9,$C692)		; 15
	%Player("Bill Berg", $1769,$3633,$1106,$9C02)		; 16
	%Player("Tom Kurvers", $2869,$9C3C,$7396,$F092)		; 17
	%Player("Uwe Krupp", $04B6,$69C9,$A466,$C395)		; 18
	%Player("Richard Pilon", $4779,$9399,$AB63,$C33B)		; 19
	%Player("Jeff Finley", $0353,$3369,$4133,$F032)		; 20
	%Player("Jeff Norton", $0869,$9996,$7363,$9095)		; 21
	%Player("Wayne McBean", $0663,$33F6,$6363,$6C65)		; 22
	%Player("Scott Lachance", $0776,$66F3,$6163,$6332)		; 23
	dw 2		; end of the player list (empty name)
.tn:	%String("Long Island")
.ta:	%String("LI")

