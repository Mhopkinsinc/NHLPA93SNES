Minnesota:		;team 9
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/MINh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/MINv.snespal"		; visitor colours
.sr:	%hex2($1301,$11F6,$1232,$1652)		; uupu,uuuu,skpd,cfgo
.sodds:	db 166,0
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,18,21,14,04,10,03,00		; line 1
	db 01,20,22,16,03,11,04,00		; line 2
	db 01,19,23,15,05,09,04,00		; line 3
	db 01,21,22,14,03,10,04,00		; line 4
	db 01,20,18,05,04,09,03,00		; line 5
	db 01,21,18,15,04,14,07,00		; line 6
	db 01,20,23,14,07,15,04,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Jon Casey", $301B,$8BA8,$0100,$558B)		; 1
	%Player("Darcy Wakaluk", $3555,$8AA8,$0100,$5585)		; 2
	%Player("Dave Gagner", $1555,$5B58,$8588,$B85A)		; 3
	%Player("Neal Broten", $073B,$B828,$8185,$E8B1)		; 4
	%Player("Bobby Smith", $1888,$8825,$6385,$B5BD)		; 5
	%Player("Todd Elik", $1468,$BB85,$6388,$555D)		; 6
	%Player("Marc Bureau", $1168,$8255,$6088,$8E5A)		; 7
	%Player("Kip Miller", $2528,$8808,$5188,$5584)		; 8
	%Player("Ulf Dahlen", $2268,$5B58,$518B,$BB81)		; 9
	%Player("Mike Modano", $096E,$EB58,$63E8,$B8B4)		; 10
	%Player("Mike Craig", $2058,$8828,$96B8,$8B5D)		; 11
	%Player("Shane Churla", $2772,$5222,$8C55,$2F5F)		; 12
	%Player("Stewart Gavin", $1268,$8282,$6155,$5B27)		; 13
	%Player("Brian Bellows", $236B,$BB2B,$62E8,$E8B4)		; 14
	%Player("Gaetan Duchesne", $1078,$B585,$8555,$BB2A)		; 15
	%Player("Brian Propp", $1668,$5B55,$6358,$8857)		; 16
	%Player("Derrick Smith", $2195,$2222,$9125,$5B2A)		; 17
	%Player("Chris Dahlquist", $0478,$5255,$8552,$E287)		; 18
	%Player("Craig Ludwig", $03A5,$5282,$9352,$8227)		; 19
	%Player("Jim Johnson", $0665,$82B5,$9782,$B5BA)		; 20
	%Player("Mark Tinordi", $2488,$5828,$B582,$E25D)		; 21
	%Player("David Shaw", $2685,$5225,$8452,$555A)		; 22
	%Player("Derian Hatcher", $2888,$55B5,$6558,$B82D)		; 23
	dw 2		; end of the player list (empty name)
.tn:	%String("Minnesota")
.ta:	%String("MIN")

