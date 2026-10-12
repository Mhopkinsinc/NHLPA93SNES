Buffalo:		;team 1
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/BUFh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/BUFv.snespal"		; visitor colours
.sr:	%hex2($5522,$22D8,$2442,$3933)		; uupu,uuuu,skpd,cfgo
.sodds:	db 101,80
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,20,18,13,06,09,04,00		; line 1
	db 01,17,21,14,04,10,06,00		; line 2
	db 01,19,23,15,05,08,06,00		; line 3
	db 01,18,17,13,06,09,04,00		; line 4
	db 01,23,21,14,04,10,06,00		; line 5
	db 01,17,21,06,08,14,05,00		; line 6
	db 01,23,20,14,05,06,08,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Daren Puppa", $3188,$8AA8,$0000,$5588)		; 1
	%Player("Clint Malarchuk", $3058,$8AA8,$0100,$8885)		; 2
	%Player("Tom Draper", $3552,$8AA0,$0100,$2220)		; 3
	%Player("Dale Hawerchuk", $105E,$BE28,$51E5,$B5E4)		; 4
	%Player("Christan Ruuttu", $216B,$B558,$67B2,$B8BA)		; 5
	%Player("Pat LaFontaine", $164E,$BFB8,$80EE,$E5ED)		; 6
	%Player("Dave Hannan", $1452,$2222,$5328,$582A)		; 7
	%Player("Tony Tanti", $195B,$B858,$67B8,$BB5A)		; 8
	%Player("Alexnder Mogilny", $896F,$FE88,$65EB,$B8EA)		; 9
	%Player("Donald Audette", $2848,$8B88,$668B,$BB5A)		; 10
	%Player("Wayne Presley", $1858,$880B,$6655,$5B5D)		; 11
	%Player("Colin Patterson", $176B,$B252,$9458,$5554)		; 12
	%Player("Dave Andreychuk", $25A5,$5E5B,$6488,$BB87)		; 13
	%Player("Randy Wood", $1562,$E825,$9755,$EB5A)		; 14
	%Player("Brad May", $2775,$5225,$9D58,$8E2F)		; 15
	%Player("Rob Ray", $3288,$B222,$BD5B,$2B2F)		; 16
	%Player("Doug Bodger", $0885,$8885,$9752,$E28A)		; 17
	%Player("Petr Svoboda", $074B,$B588,$95B2,$B28D)		; 18
	%Player("Gord Donnelly", $3472,$5022,$BC25,$285F)		; 19
	%Player("Mike Ramsey", $0568,$22B5,$8552,$B22A)		; 20
	%Player("Ken Sutton", $4165,$5585,$5522,$E28A)		; 21
	%Player("Randy Moller", $2488,$5225,$9652,$555D)		; 22
	%Player("Grant Ledyard", $037B,$885B,$8B52,$E287)		; 23
	%Player("Randy Hillier", $2365,$2002,$5A20,$2B5D)		; 24
	dw 2		; end of the player list (empty name)
.tn:	%String("Buffalo")
.ta:	%String("BUF")

