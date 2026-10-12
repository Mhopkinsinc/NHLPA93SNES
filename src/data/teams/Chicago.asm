Chicago:		;team 3
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/CHIh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/CHIv.snespal"		; visitor colours
.sr:	%hex2($3000,$21D7,$7777,$9888)		; uupu,uuuu,skpd,cfgo
.sodds:	db 164,49
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,18,19,14,05,09,07,00		; line 1
	db 01,20,22,16,07,11,05,00		; line 2
	db 01,21,23,13,06,10,05,00		; line 3
	db 01,18,19,14,05,09,10,00		; line 4
	db 01,21,22,07,10,11,05,00		; line 5
	db 01,21,22,07,10,06,09,00		; line 6
	db 01,18,19,06,09,07,10,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Ed Belfour", $305F,$AFFF,$0100,$FFFF)		; 1
	%Player("Dominik Hasek", $313A,$AAA7,$0100,$7AAA)		; 2
	%Player("Jim Waite", $295A,$AAA7,$0100,$77AA)		; 3
	%Player("Ray LeBlanc", $5034,$AAA1,$0000,$1144)		; 4
	%Player("Jeremy Roenick", $273F,$FFDF,$84FF,$DADA)		; 5
	%Player("Mike Hudson", $207A,$A747,$B77D,$DDAA)		; 6
	%Player("Brent Sutter", $125A,$7D4A,$B4DA,$FAA4)		; 7
	%Player("Tony Hrkac", $1137,$77A4,$8774,$7744)		; 8
	%Player("Steve Larmer", $286D,$ADDD,$B5D7,$FDD7)		; 9
	%Player("Dirk Graham", $337D,$AA7A,$DAA7,$FDAA)		; 10
	%Player("Rob Brown", $225D,$DD47,$8BDD,$D77A)		; 11
	%Player("Brian Noonan", $106A,$AADD,$A4AA,$7FAA)		; 12
	%Player("Jocelyn Lemieux", $267A,$D4AD,$8774,$AD4A)		; 13
	%Player("Michel Goulet", $166D,$ADDA,$85DA,$D7D7)		; 14
	%Player("Stu Grimson", $23A4,$4174,$DD17,$4D1F)		; 15
	%Player("Greg Gilbert", $1467,$7477,$BBAD,$AD47)		; 16
	%Player("Stephane Matteau", $3267,$7AD4,$A77D,$7A4D)		; 17
	%Player("Chris Chelios", $075D,$ADDD,$E4F4,$F4DD)		; 18
	%Player("Steve Smith", $059D,$D7DD,$DBD4,$F7DF)		; 19
	%Player("Frantsek Kucera", $0687,$74A4,$5274,$A774)		; 20
	%Player("Bryan Marchment", $0274,$7477,$BB77,$F44D)		; 21
	%Player("Keith Brown", $046D,$D7D7,$BAA4,$FAAA)		; 22
	%Player("Rod Buskas", $2584,$4144,$5A41,$A44D)		; 23
	%Player("Igor Kravchuk", $037D,$AA4A,$81D4,$74A4)		; 24
	dw 2		; end of the player list (empty name)
.tn:	%String("Chicago")
.ta:	%String("CHI")

