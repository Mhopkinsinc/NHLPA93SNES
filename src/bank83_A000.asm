; $839D7D-$83AD01  ROM $19D7D-$1AD01: team records Minnesota, Montreal, NewJersey, NewYork, Ottawa, Philadelphia (93G teamdata93.asm, same values; see bank83_8000 for the format).
; Starts at Minnesota, ends at the end of Philadelphia (boundaries moved to the records).
org $839D7D

Minnesota:		;93G Minnesota (TeamList 9)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/MINh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/MINv.snespal"		; visitor colours
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
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Minnesota")
.ta:	%String("MIN")

Montreal:		;93G Montreal (TeamList 10)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/MTLh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/MTLv.snespal"		; visitor colours
.sr:	%hex2($3011,$22E7,$7888,$8499)		; uupu,uuuu,skpd,cfgo
.sodds:	db 210,32
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,20,18,14,05,13,04,00		; line 1
	db 01,21,23,16,04,10,05,00		; line 2
	db 01,19,22,15,06,11,05,00		; line 3
	db 01,20,19,14,16,04,05,00		; line 4
	db 01,21,23,17,05,09,14,00		; line 5
	db 01,19,23,16,08,14,05,00		; line 6
	db 01,20,18,14,05,16,08,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Patrick Roy", $335F,$AFFF,$0100,$FFFF)		; 1
	%Player("Roland Melanson", $0157,$AAA7,$0100,$4477)		; 2
	%Player("Andre Racicot", $4031,$AAA1,$0100,$1111)		; 3
	%Player("Stephan Lebeau", $474D,$DDDA,$70AD,$DAA0)		; 4
	%Player("Denis Savard", $184F,$DDAA,$52FD,$F7D5)		; 5
	%Player("Guy Carbonneau", $215F,$DAA7,$B0DD,$AAD2)		; 6
	%Player("John Leclair", $179A,$D7AA,$B17A,$7D72)		; 7
	%Player("Brian Skrudland", $397D,$7477,$D5A4,$AFA5)		; 8
	%Player("Brent Gilchrist", $415D,$AAFA,$81DD,$AAA5)		; 9
	%Player("Mike Keane", $124A,$DAD7,$8277,$A7A5)		; 10
	%Player("Chris Nilan", $3084,$4474,$DC4A,$AD4E)		; 11
	%Player("Todd Ewen", $36A4,$41A4,$DA44,$4D4B)		; 12
	%Player("Russ Courtnall", $065F,$FDDA,$70DA,$A7D2)		; 13
	%Player("Kirk Muller", $118D,$DDDD,$D5DD,$FAD8)		; 14
	%Player("Mike McPhee", $357A,$D7AA,$D37A,$AD75)		; 15
	%Player("Shayne Corson", $277D,$DDDA,$D7DA,$FADB)		; 16
	%Player("Gilbert Dionne", $456A,$ADDA,$71AF,$7D72)		; 17
	%Player("J.J. Daigneault", $485D,$D4DD,$73A4,$D772)		; 18
	%Player("Matt Schneider", $086A,$77DA,$B3A4,$F7D5)		; 19
	%Player("Eric Desjardins", $287D,$AADA,$B2D4,$F4A5)		; 20
	%Player("Lyle Odelein", $248A,$44D7,$BB74,$D47B)		; 21
	%Player("Sylvain Lefebvre", $038A,$A4D4,$8374,$A4A8)		; 22
	%Player("Kevin Haller", $1457,$7774,$8747,$F478)		; 23
	%Player("Patrice Brisebois", $434A,$A7DA,$A674,$7475)		; 24
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Montreal")
.ta:	%String("MTL")

NewJersey:		;93G NewJersey (TeamList 11)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/NJh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/NJv.snespal"		; visitor colours
.sr:	%hex2($5200,$11F6,$8668,$6467)		; uupu,uuuu,skpd,cfgo
.sodds:	db 165,0
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,22,23,14,03,08,04,00		; line 1
	db 01,20,21,13,04,09,03,00		; line 2
	db 01,18,19,12,05,10,03,00		; line 3
	db 01,23,20,13,03,08,04,00		; line 4
	db 01,21,22,14,04,09,03,00		; line 5
	db 01,23,19,12,11,05,10,00		; line 6
	db 01,21,22,05,10,12,11,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Chris Terreri", $311D,$AAAA,$0100,$AAAA)		; 1
	%Player("Craig Billington", $013A,$AAA4,$0100,$7777)		; 2
	%Player("Kevin Todd", $144A,$DDA7,$B57D,$D7A5)		; 3
	%Player("Peter Stastny", $267D,$ADAA,$A1DD,$D7F5)		; 4
	%Player("Alexnder Semak", $205A,$AADA,$A0DA,$7DD0)		; 5
	%Player("Randy McKay", $2154,$47A4,$AC7D,$4D7B)		; 6
	%Player("John MacLean", $157A,$ADAD,$A6AD,$7D7B)		; 7
	%Player("Stephane Richer", $447D,$DDAF,$70DA,$DDA2)		; 8
	%Player("Claude Lemieux", $229D,$DDDA,$B4AD,$DD78)		; 9
	%Player("Doug Brown", $245A,$D7D7,$B077,$DD72)		; 10
	%Player("Dave Barr", $116A,$AAD4,$B24A,$A745)		; 11
	%Player("Tom Chorske", $0987,$7AA4,$50AA,$DDA2)		; 12
	%Player("Claude Vilgrain", $198A,$7AF7,$52AF,$D7A8)		; 13
	%Player("Valeri Zelepukin", $255D,$DDDA,$71DD,$DAD5)		; 14
	%Player("Pat Conacher", $3267,$74A4,$514D,$7F42)		; 15
	%Player("Troy Mallette", $0881,$17D1,$874D,$774B)		; 16
	%Player("Zdeno Ciger", $336A,$DA7A,$41AD,$7D72)		; 17
	%Player("Ken Daneyko", $0387,$74A4,$DB74,$A74B)		; 18
	%Player("Bruce Driver", $235A,$AAA7,$A3A4,$D4A5)		; 19
	%Player("Eric Weinrich", $058A,$DADA,$A3A7,$D4A5)		; 20
	%Player("Alexei Kasatonov", $079D,$AADD,$B5DA,$F4D5)		; 21
	%Player("Slava Fetisov", $02AD,$77DD,$B5D4,$F1D8)		; 22
	%Player("Scott Stevens", $049D,$ADFA,$F7AA,$F4DB)		; 23
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("New Jersey")
.ta:	%String("NJ")

NewYork:		;93G NewYork (TeamList 12)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/NYh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/NYv.snespal"		; visitor colours
.sr:	%hex2($7120,$20F8,$7989,$7789)		; uupu,uuuu,skpd,cfgo
.sodds:	db 152,0
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,18,20,15,03,09,05,00		; line 1
	db 01,21,24,16,05,08,03,00		; line 2
	db 01,19,22,17,04,12,03,00		; line 3
	db 01,18,19,03,05,09,04,00		; line 4
	db 01,21,24,16,04,08,03,00		; line 5
	db 01,19,21,03,07,04,11,00		; line 6
	db 01,18,20,04,11,03,07,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("John Vanbiesbrk", $344A,$ADAA,$0100,$ADAD)		; 1
	%Player("Mike Richter", $355D,$ADDD,$0100,$DDDD)		; 2
	%Player("Mark Messier", $118F,$DFFA,$F3FD,$F4F9)		; 3
	%Player("Sergei Nemchinov", $135D,$ADDA,$A1AF,$F7A0)		; 4
	%Player("Darren Turcotte", $085F,$DDDA,$73DD,$DDA6)		; 5
	%Player("Doug Weight", $395A,$AA77,$73AA,$7773)		; 6
	%Player("Adam Graves", $095D,$DDD7,$A3AA,$ADAC)		; 7
	%Player("Tony Amonte", $335D,$DDDA,$72AD,$DDA6)		; 8
	%Player("Mike Gartner", $226F,$FDDF,$84FD,$DDF6)		; 9
	%Player("Paul Broten", $3764,$47D4,$744A,$7D49)		; 10
	%Player("Randy Gilhen", $1664,$47A4,$7177,$AD43)		; 11
	%Player("Joey Kocur", $2667,$4477,$DC77,$AF7C)		; 12
	%Player("Tie Domi", $2871,$1471,$8E17,$4A1F)		; 13
	%Player("Tim Kerr", $12B7,$7A4A,$50DA,$7A73)		; 14
	%Player("Kris King", $198D,$D4D7,$8BAA,$ADAC)		; 15
	%Player("John Ogrodnick", $258A,$AAAA,$A1AD,$DDA3)		; 16
	%Player("Jan Erixon", $207A,$A7D7,$71AD,$AAA0)		; 17
	%Player("Brian Leetch", $025F,$AFDD,$83F7,$F1F3)		; 18
	%Player("James Patrick", $038F,$DDFD,$B2D7,$F1D6)		; 19
	%Player("Jeff Beukeboom", $2397,$74D7,$AA74,$D17C)		; 20
	%Player("Joe Cirella", $068A,$A4DA,$8674,$F47C)		; 21
	%Player("Mark Hardy", $1467,$74F4,$8574,$A479)		; 22
	%Player("Jay Wells", $2487,$74A7,$A577,$717C)		; 23
	%Player("Per Djoos", $4447,$A7D7,$8074,$D176)		; 24
	%Player("Normand Rochefort", $0597,$7114,$B171,$7A49)		; 25
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("New York")
.ta:	%String("NY")

Ottawa:		;93G Ottawa (TeamList 13)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/OTWh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/OTWv.snespal"		; visitor colours
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
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Ottawa")
.ta:	%String("OTW")

Philadelphia:		;93G Philadelphia (TeamList 14)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/PHIh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/PHIv.snespal"		; visitor colours
.sr:	%hex2($2201,$22E8,$3443,$2353)		; uupu,uuuu,skpd,cfgo
.sodds:	db 147,0
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,17,18,13,03,09,04,00		; line 1
	db 01,21,23,15,04,10,03,00		; line 2
	db 01,19,20,16,05,11,03,00		; line 3
	db 01,17,23,12,04,10,03,00		; line 4
	db 01,21,18,13,03,09,04,00		; line 5
	db 01,17,23,04,09,03,05,00		; line 6
	db 01,21,20,03,05,04,09,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Ron Hextall", $2769,$9AA9,$0100,$CC99)		; 1
	%Player("Dominic Roussel", $3353,$9AA3,$0100,$3366)		; 2
	%Player("Rod Brindamour", $177C,$9C6C,$75CC,$F9C9)		; 3
	%Player("Mike Ricci", $186C,$CC66,$9399,$F6C9)		; 4
	%Player("Pelle Eklund", $094F,$C999,$71C6,$C9C0)		; 5
	%Player("Keith Acton", $2536,$6663,$A136,$6C3C)		; 6
	%Player("Allan Conroy", $4653,$3693,$6536,$633C)		; 7
	%Player("Steve Kasper", $1549,$9639,$A39F,$6CC6)		; 8
	%Player("Kevin Dineen", $206C,$FC66,$7699,$FC9C)		; 9
	%Player("Mark Recchi", $085F,$CF36,$73CC,$C6C9)		; 10
	%Player("Dave Brown", $2180,$0030,$4C06,$9F09)		; 11
	%Player("Dan Quinn", $105C,$C936,$4199,$9693)		; 12
	%Player("Mark Pederson", $1476,$6CC6,$716C,$C663)		; 13
	%Player("Claude Boivin", $4070,$0660,$0309,$663C)		; 14
	%Player("Andrei Lomakin", $236C,$9969,$319C,$99C3)		; 15
	%Player("Brad Jones", $476C,$F666,$6569,$9C66)		; 16
	%Player("Steve Duchesne", $286C,$CC6C,$63C6,$F3C9)		; 17
	%Player("Garry Galley", $0366,$6996,$9793,$C399)		; 18
	%Player("Brian Benning", $1966,$6969,$A563,$939C)		; 19
	%Player("Terry Carkner", $2996,$6336,$9B63,$C36C)		; 20
	%Player("Kerry Huffman", $0579,$9999,$7399,$F666)		; 21
	%Player("Dan Kordic", $0680,$0390,$7603,$693C)		; 22
	%Player("Mark Howe", $0259,$99FC,$71C9,$F3C3)		; 23
	%Player("Corey Foster", $4470,$0603,$1133,$6C36)		; 24
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Philadelphia")
.ta:	%String("PHI")
