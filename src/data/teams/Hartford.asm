Hartford:		;team 6
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/HFDh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/HFDv.snespal"		; visitor colours
.sr:	%hex2($1402,$00F6,$2222,$1342)		; uupu,uuuu,skpd,cfgo
.sodds:	db 146,0
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,18,22,11,03,08,04,00		; line 1
	db 01,19,21,12,04,09,03,00		; line 2
	db 01,20,23,13,05,10,03,00		; line 3
	db 01,22,19,11,13,03,05,00		; line 4
	db 01,20,18,12,05,09,11,00		; line 5
	db 01,18,20,13,12,04,09,00		; line 6
	db 01,19,23,04,09,12,13,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Kay Whitmore", $3545,$8AA5,$0100,$5858)		; 1
	%Player("Frank Petrangelo", $4055,$8AA8,$0100,$5555)		; 2
	%Player("John Cullen", $1158,$8B28,$32EB,$B5BB)		; 3
	%Player("Andrew Cassels", $2168,$8885,$3188,$B582)		; 4
	%Player("Geoff Sanderson", $085B,$8888,$6188,$B882)		; 5
	%Player("James Black", $2355,$5555,$3555,$5B52)		; 6
	%Player("Paul Gillis", $4478,$B225,$8B20,$255E)		; 7
	%Player("Bobby Holik", $2488,$8885,$9285,$8B82)		; 8
	%Player("Mark Hunter", $267B,$8555,$9458,$EB5B)		; 9
	%Player("Ed Kastelic", $2290,$0220,$8C0E,$800B)		; 10
	%Player("Pat Verbeek", $1668,$5B2B,$B6B8,$B8BB)		; 11
	%Player("Mikael Andersson", $3455,$B8B5,$0188,$E880)		; 12
	%Player("Murray Craven", $125B,$BB8B,$838B,$E885)		; 13
	%Player("Jim McKenzie", $3382,$5255,$355B,$5F28)		; 14
	%Player("Randy Cunnyworth", $0755,$5855,$9558,$5B8B)		; 15
	%Player("Yvon Corriveau", $2065,$58B5,$872B,$5B25)		; 16
	%Player("Paul Cyr", $1850,$0220,$0120,$5B28)		; 17
	%Player("Steve Konroyd", $0568,$8585,$B352,$E288)		; 18
	%Player("Zarley Zalapski", $038E,$BB5B,$95B5,$E588)		; 19
	%Player("Marc Bergevin", $2555,$5528,$6355,$E255)		; 20
	%Player("Randy Ladouceur", $29A8,$2282,$5552,$852B)		; 21
	%Player("Adam Burt", $0668,$852B,$8385,$B288)		; 22
	%Player("Doug Houda", $2762,$2255,$0225,$852B)		; 23
	dw 2		; end of the player list (empty name)
.tn:	%String("Hartford")
.ta:	%String("HFD")

