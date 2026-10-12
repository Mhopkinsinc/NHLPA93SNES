SanJose:		;team 17
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/SJh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/SJv.snespal"		; visitor colours
.sr:	%hex2($0702,$12E6,$2111,$3211)		; uupu,uuuu,skpd,cfgo
.sodds:	db 133,34
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,24,20,16,09,11,12,00		; line 1
	db 01,23,21,17,08,12,09,00		; line 2
	db 01,19,22,15,07,13,09,00		; line 3
	db 01,24,20,09,08,13,12,00		; line 4
	db 01,22,23,07,12,11,09,00		; line 5
	db 01,20,23,07,12,16,09,00		; line 6
	db 01,24,21,16,09,07,12,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Jeff Hackett", $3042,$8AA2,$0100,$2225)		; 1
	%Player("Jarmo Myllys", $3525,$8AA2,$0100,$5528)		; 2
	%Player("Arturs Irbe", $3245,$8AA8,$0100,$8855)		; 3
	%Player("Brian Hayward", $0155,$8AA5,$0100,$5558)		; 4
	%Player("Dean Evason", $0852,$2525,$8458,$5859)		; 5
	%Player("Perry Berezan", $166B,$B505,$6058,$5E83)		; 6
	%Player("Mike Sullivan", $4755,$8525,$2158,$EB53)		; 7
	%Player("Brian Lawton", $0965,$5805,$8358,$B856)		; 8
	%Player("Kelly Kisio", $1155,$5B28,$628B,$E289)		; 9
	%Player("Dale Craigwell", $3345,$5855,$8758,$5523)		; 10
	%Player("Pat Falloon", $176B,$BB08,$50B8,$B880)		; 11
	%Player("Brian Mullen", $1958,$5828,$5388,$E886)		; 12
	%Player("David Bruce", $1565,$5828,$225B,$BB56)		; 13
	%Player("Dave Snuggerud", $186B,$8525,$6582,$5886)		; 14
	%Player("Jeff Odgers", $3672,$5225,$6B58,$8E2C)		; 15
	%Player("Paul Fenton", $2258,$5205,$9358,$BE53)		; 16
	%Player("Steve Bozek", $145B,$B505,$8185,$8E53)		; 17
	%Player("Johan Garpenlov", $1058,$8885,$218B,$5853)		; 18
	%Player("Rob Zettler", $0265,$5225,$5582,$8889)		; 19
	%Player("Neil Wilkinson", $0568,$8525,$9482,$E5BC)		; 20
	%Player("David Williams", $0365,$5825,$8452,$B226)		; 21
	%Player("Link Gaetz", $2388,$8208,$BD85,$288F)		; 22
	%Player("Jay More", $0468,$550B,$8485,$E28C)		; 23
	%Player("Doug Wilson", $245B,$880F,$81B5,$E5B3)		; 24
	dw 2		; end of the player list (empty name)
.tn:	%String("San Jose")
.ta:	%String("SJ")

