Toronto:		;team 20
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/TORh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/TORv.snespal"		; visitor colours
.sr:	%hex2($1411,$12E8,$2123,$3232)		; uupu,uuuu,skpd,cfgo
.sodds:	db 211,0
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,17,19,13,03,06,05,00		; line 1
	db 01,20,21,10,05,08,03,00		; line 2
	db 01,18,22,14,04,07,03,00		; line 3
	db 01,17,19,13,10,03,07,00		; line 4
	db 01,18,22,05,07,06,13,00		; line 5
	db 01,19,21,12,04,10,03,00		; line 6
	db 01,18,17,10,03,12,04,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Grant Fuhr", $315E,$8EEE,$0000,$BBEE)		; 1
	%Player("Rick Wamsley", $3055,$8AA5,$0100,$5555)		; 2
	%Player("Doug Gilmour", $933E,$8BB8,$B1BB,$E2B8)		; 3
	%Player("Dave McLlwain", $0768,$5552,$6388,$B882)		; 4
	%Player("Peter Zezel", $2578,$8B28,$9188,$B5B2)		; 5
	%Player("Glenn Anderson", $106B,$EB28,$57B8,$B8B8)		; 6
	%Player("Mike Bullard", $2268,$8828,$2385,$BB85)		; 7
	%Player("Rob Pearson", $1255,$5822,$305B,$8B58)		; 8
	%Player("Mike Foligno", $7165,$5855,$E48B,$5858)		; 9
	%Player("Mike Krushelski", $2678,$8555,$8385,$EB58)		; 10
	%Player("Ken Baumgarter", $0870,$0020,$9D00,$2E0E)		; 11
	%Player("Mark Osborne", $2185,$5525,$5558,$8828)		; 12
	%Player("Wendel Clark", $1768,$8B2E,$B7B8,$BBBB)		; 13
	%Player("Guy Larose", $1142,$5525,$532B,$8B25)		; 14
	%Player("Joe Sacco", $2455,$88E5,$225B,$5B52)		; 15
	%Player("Kent Mandervill", $1875,$8585,$5350,$5520)		; 16
	%Player("Dave Ellett", $047B,$B82E,$95B5,$E5B8)		; 17
	%Player("Bob Rouse", $0388,$8525,$9452,$E258)		; 18
	%Player("Jamie Macoun", $3478,$85BB,$B582,$E2B5)		; 19
	%Player("Todd Gill", $2358,$8225,$B552,$8258)		; 20
	%Player("Ric Nattress", $0282,$5582,$5452,$B228)		; 21
	%Player("Darryl Shannon", $2868,$5225,$8182,$B552)		; 22
	%Player("Bob Halkidis", $3372,$2222,$2725,$582B)		; 23
	%Player("Dimitri Mironov", $1568,$5208,$218B,$55B0)		; 24
	dw 2		; end of the player list (empty name)
.tn:	%String("Toronto")
.ta:	%String("TOR")

