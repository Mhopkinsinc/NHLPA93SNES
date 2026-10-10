; $839D7D-$83AD01  ROM $19D7D-$1AD01: team records Minnesota, Montreal, NewJersey, NewYork, Ottawa, Philadelphia (93G teamdata93.asm, same values; see bank83_8000 for the format).
; Starts at Minnesota, ends at the end of Philadelphia (boundaries moved to the records).
org $839D7D

Minnesota:		;93G Minnesota (TeamList 9)
.0:	dw .pld-.0		; $839D7D Playerdata
	dw .pad-.0		; $839D7F Palettedata
	dw .tn-.0		; $839D81 Teamname
	dw .ls-.0		; $839D83 LineSets
	dw .sr-.0		; $839D85 ScoutReport
	dw .sodds-.0		; $839D87 ScoreOdds
.pad:	incbin "../data/Pals/MINh.snespal"		; $839D89 home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/MINv.snespal"		; $839DA9 visitor colours
.sr:	%hex2($1301,$11F6,$1232,$1652)		; $839DC9 uupu,uuuu,skpd,cfgo
.sodds:	db 166,0		; $839DD1
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,18,21,14,04,10,03,00		; $839DD3 line 1
	db 01,20,22,16,03,11,04,00		; $839DDB line 2
	db 01,19,23,15,05,09,04,00		; $839DE3 line 3
	db 01,21,22,14,03,10,04,00		; $839DEB line 4
	db 01,20,18,05,04,09,03,00		; $839DF3 line 5
	db 01,21,18,15,04,14,07,00		; $839DFB line 6
	db 01,20,23,14,07,15,04,00		; $839E03 line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Jon Casey", $301B,$8BA8,$0100,$558B)		; $839E0B 1
	%Player("Darcy Wakaluk", $3555,$8AA8,$0100,$5585)		; $839E1E 2
	%Player("Dave Gagner", $1555,$5B58,$8588,$B85A)		; $839E35 3
	%Player("Neal Broten", $073B,$B828,$8185,$E8B1)		; $839E4A 4
	%Player("Bobby Smith", $1888,$8825,$6385,$B5BD)		; $839E5F 5
	%Player("Todd Elik", $1468,$BB85,$6388,$555D)		; $839E74 6
	%Player("Marc Bureau", $1168,$8255,$6088,$8E5A)		; $839E87 7
	%Player("Kip Miller", $2528,$8808,$5188,$5584)		; $839E9C 8
	%Player("Ulf Dahlen", $2268,$5B58,$518B,$BB81)		; $839EB0 9
	%Player("Mike Modano", $096E,$EB58,$63E8,$B8B4)		; $839EC4 10
	%Player("Mike Craig", $2058,$8828,$96B8,$8B5D)		; $839ED9 11
	%Player("Shane Churla", $2772,$5222,$8C55,$2F5F)		; $839EED 12
	%Player("Stewart Gavin", $1268,$8282,$6155,$5B27)		; $839F03 13
	%Player("Brian Bellows", $236B,$BB2B,$62E8,$E8B4)		; $839F1A 14
	%Player("Gaetan Duchesne", $1078,$B585,$8555,$BB2A)		; $839F31 15
	%Player("Brian Propp", $1668,$5B55,$6358,$8857)		; $839F4A 16
	%Player("Derrick Smith", $2195,$2222,$9125,$5B2A)		; $839F5F 17
	%Player("Chris Dahlquist", $0478,$5255,$8552,$E287)		; $839F76 18
	%Player("Craig Ludwig", $03A5,$5282,$9352,$8227)		; $839F8F 19
	%Player("Jim Johnson", $0665,$82B5,$9782,$B5BA)		; $839FA5 20
	%Player("Mark Tinordi", $2488,$5828,$B582,$E25D)		; $839FBA 21
	%Player("David Shaw", $2685,$5225,$8452,$555A)		; $839FD0 22
	%Player("Derian Hatcher", $2888,$55B5,$6558,$B82D)		; $839FE4 23
	dw 2		; $839FFC end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Minnesota")		; $839FFE
.ta:	%String("MIN")		; $83A009

Montreal:		;93G Montreal (TeamList 10)
.0:	dw .pld-.0		; $83A00E Playerdata
	dw .pad-.0		; $83A010 Palettedata
	dw .tn-.0		; $83A012 Teamname
	dw .ls-.0		; $83A014 LineSets
	dw .sr-.0		; $83A016 ScoutReport
	dw .sodds-.0		; $83A018 ScoreOdds
.pad:	incbin "../data/Pals/MTLh.snespal"		; $83A01A home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/MTLv.snespal"		; $83A03A visitor colours
.sr:	%hex2($3011,$22E7,$7888,$8499)		; $83A05A uupu,uuuu,skpd,cfgo
.sodds:	db 210,32		; $83A062
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,20,18,14,05,13,04,00		; $83A064 line 1
	db 01,21,23,16,04,10,05,00		; $83A06C line 2
	db 01,19,22,15,06,11,05,00		; $83A074 line 3
	db 01,20,19,14,16,04,05,00		; $83A07C line 4
	db 01,21,23,17,05,09,14,00		; $83A084 line 5
	db 01,19,23,16,08,14,05,00		; $83A08C line 6
	db 01,20,18,14,05,16,08,00		; $83A094 line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Patrick Roy", $335F,$AFFF,$0100,$FFFF)		; $83A09C 1
	%Player("Roland Melanson", $0157,$AAA7,$0100,$4477)		; $83A0B1 2
	%Player("Andre Racicot", $4031,$AAA1,$0100,$1111)		; $83A0CA 3
	%Player("Stephan Lebeau", $474D,$DDDA,$70AD,$DAA0)		; $83A0E1 4
	%Player("Denis Savard", $184F,$DDAA,$52FD,$F7D5)		; $83A0F9 5
	%Player("Guy Carbonneau", $215F,$DAA7,$B0DD,$AAD2)		; $83A10F 6
	%Player("John Leclair", $179A,$D7AA,$B17A,$7D72)		; $83A127 7
	%Player("Brian Skrudland", $397D,$7477,$D5A4,$AFA5)		; $83A13D 8
	%Player("Brent Gilchrist", $415D,$AAFA,$81DD,$AAA5)		; $83A156 9
	%Player("Mike Keane", $124A,$DAD7,$8277,$A7A5)		; $83A16F 10
	%Player("Chris Nilan", $3084,$4474,$DC4A,$AD4E)		; $83A183 11
	%Player("Todd Ewen", $36A4,$41A4,$DA44,$4D4B)		; $83A198 12
	%Player("Russ Courtnall", $065F,$FDDA,$70DA,$A7D2)		; $83A1AB 13
	%Player("Kirk Muller", $118D,$DDDD,$D5DD,$FAD8)		; $83A1C3 14
	%Player("Mike McPhee", $357A,$D7AA,$D37A,$AD75)		; $83A1D8 15
	%Player("Shayne Corson", $277D,$DDDA,$D7DA,$FADB)		; $83A1ED 16
	%Player("Gilbert Dionne", $456A,$ADDA,$71AF,$7D72)		; $83A204 17
	%Player("J.J. Daigneault", $485D,$D4DD,$73A4,$D772)		; $83A21C 18
	%Player("Matt Schneider", $086A,$77DA,$B3A4,$F7D5)		; $83A235 19
	%Player("Eric Desjardins", $287D,$AADA,$B2D4,$F4A5)		; $83A24D 20
	%Player("Lyle Odelein", $248A,$44D7,$BB74,$D47B)		; $83A266 21
	%Player("Sylvain Lefebvre", $038A,$A4D4,$8374,$A4A8)		; $83A27C 22
	%Player("Kevin Haller", $1457,$7774,$8747,$F478)		; $83A296 23
	%Player("Patrice Brisebois", $434A,$A7DA,$A674,$7475)		; $83A2AC 24
	dw 2		; $83A2C7 end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Montreal")		; $83A2C9
.ta:	%String("MTL")		; $83A2D3

NewJersey:		;93G NewJersey (TeamList 11)
.0:	dw .pld-.0		; $83A2D8 Playerdata
	dw .pad-.0		; $83A2DA Palettedata
	dw .tn-.0		; $83A2DC Teamname
	dw .ls-.0		; $83A2DE LineSets
	dw .sr-.0		; $83A2E0 ScoutReport
	dw .sodds-.0		; $83A2E2 ScoreOdds
.pad:	incbin "../data/Pals/NJh.snespal"		; $83A2E4 home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/NJv.snespal"		; $83A304 visitor colours
.sr:	%hex2($5200,$11F6,$8668,$6467)		; $83A324 uupu,uuuu,skpd,cfgo
.sodds:	db 165,0		; $83A32C
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,22,23,14,03,08,04,00		; $83A32E line 1
	db 01,20,21,13,04,09,03,00		; $83A336 line 2
	db 01,18,19,12,05,10,03,00		; $83A33E line 3
	db 01,23,20,13,03,08,04,00		; $83A346 line 4
	db 01,21,22,14,04,09,03,00		; $83A34E line 5
	db 01,23,19,12,11,05,10,00		; $83A356 line 6
	db 01,21,22,05,10,12,11,00		; $83A35E line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Chris Terreri", $311D,$AAAA,$0100,$AAAA)		; $83A366 1
	%Player("Craig Billington", $013A,$AAA4,$0100,$7777)		; $83A37D 2
	%Player("Kevin Todd", $144A,$DDA7,$B57D,$D7A5)		; $83A397 3
	%Player("Peter Stastny", $267D,$ADAA,$A1DD,$D7F5)		; $83A3AB 4
	%Player("Alexnder Semak", $205A,$AADA,$A0DA,$7DD0)		; $83A3C2 5
	%Player("Randy McKay", $2154,$47A4,$AC7D,$4D7B)		; $83A3DA 6
	%Player("John MacLean", $157A,$ADAD,$A6AD,$7D7B)		; $83A3EF 7
	%Player("Stephane Richer", $447D,$DDAF,$70DA,$DDA2)		; $83A405 8
	%Player("Claude Lemieux", $229D,$DDDA,$B4AD,$DD78)		; $83A41E 9
	%Player("Doug Brown", $245A,$D7D7,$B077,$DD72)		; $83A436 10
	%Player("Dave Barr", $116A,$AAD4,$B24A,$A745)		; $83A44A 11
	%Player("Tom Chorske", $0987,$7AA4,$50AA,$DDA2)		; $83A45D 12
	%Player("Claude Vilgrain", $198A,$7AF7,$52AF,$D7A8)		; $83A472 13
	%Player("Valeri Zelepukin", $255D,$DDDA,$71DD,$DAD5)		; $83A48B 14
	%Player("Pat Conacher", $3267,$74A4,$514D,$7F42)		; $83A4A5 15
	%Player("Troy Mallette", $0881,$17D1,$874D,$774B)		; $83A4BB 16
	%Player("Zdeno Ciger", $336A,$DA7A,$41AD,$7D72)		; $83A4D2 17
	%Player("Ken Daneyko", $0387,$74A4,$DB74,$A74B)		; $83A4E7 18
	%Player("Bruce Driver", $235A,$AAA7,$A3A4,$D4A5)		; $83A4FC 19
	%Player("Eric Weinrich", $058A,$DADA,$A3A7,$D4A5)		; $83A512 20
	%Player("Alexei Kasatonov", $079D,$AADD,$B5DA,$F4D5)		; $83A529 21
	%Player("Slava Fetisov", $02AD,$77DD,$B5D4,$F1D8)		; $83A543 22
	%Player("Scott Stevens", $049D,$ADFA,$F7AA,$F4DB)		; $83A55A 23
	dw 2		; $83A571 end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("New Jersey")		; $83A573
.ta:	%String("NJ")		; $83A57F

NewYork:		;93G NewYork (TeamList 12)
.0:	dw .pld-.0		; $83A583 Playerdata
	dw .pad-.0		; $83A585 Palettedata
	dw .tn-.0		; $83A587 Teamname
	dw .ls-.0		; $83A589 LineSets
	dw .sr-.0		; $83A58B ScoutReport
	dw .sodds-.0		; $83A58D ScoreOdds
.pad:	incbin "../data/Pals/NYh.snespal"		; $83A58F home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/NYv.snespal"		; $83A5AF visitor colours
.sr:	%hex2($7120,$20F8,$7989,$7789)		; $83A5CF uupu,uuuu,skpd,cfgo
.sodds:	db 152,0		; $83A5D7
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,18,20,15,03,09,05,00		; $83A5D9 line 1
	db 01,21,24,16,05,08,03,00		; $83A5E1 line 2
	db 01,19,22,17,04,12,03,00		; $83A5E9 line 3
	db 01,18,19,03,05,09,04,00		; $83A5F1 line 4
	db 01,21,24,16,04,08,03,00		; $83A5F9 line 5
	db 01,19,21,03,07,04,11,00		; $83A601 line 6
	db 01,18,20,04,11,03,07,00		; $83A609 line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("John Vanbiesbrk", $344A,$ADAA,$0100,$ADAD)		; $83A611 1
	%Player("Mike Richter", $355D,$ADDD,$0100,$DDDD)		; $83A62A 2
	%Player("Mark Messier", $118F,$DFFA,$F3FD,$F4F9)		; $83A640 3
	%Player("Sergei Nemchinov", $135D,$ADDA,$A1AF,$F7A0)		; $83A656 4
	%Player("Darren Turcotte", $085F,$DDDA,$73DD,$DDA6)		; $83A670 5
	%Player("Doug Weight", $395A,$AA77,$73AA,$7773)		; $83A689 6
	%Player("Adam Graves", $095D,$DDD7,$A3AA,$ADAC)		; $83A69E 7
	%Player("Tony Amonte", $335D,$DDDA,$72AD,$DDA6)		; $83A6B3 8
	%Player("Mike Gartner", $226F,$FDDF,$84FD,$DDF6)		; $83A6C8 9
	%Player("Paul Broten", $3764,$47D4,$744A,$7D49)		; $83A6DE 10
	%Player("Randy Gilhen", $1664,$47A4,$7177,$AD43)		; $83A6F3 11
	%Player("Joey Kocur", $2667,$4477,$DC77,$AF7C)		; $83A709 12
	%Player("Tie Domi", $2871,$1471,$8E17,$4A1F)		; $83A71D 13
	%Player("Tim Kerr", $12B7,$7A4A,$50DA,$7A73)		; $83A72F 14
	%Player("Kris King", $198D,$D4D7,$8BAA,$ADAC)		; $83A741 15
	%Player("John Ogrodnick", $258A,$AAAA,$A1AD,$DDA3)		; $83A754 16
	%Player("Jan Erixon", $207A,$A7D7,$71AD,$AAA0)		; $83A76C 17
	%Player("Brian Leetch", $025F,$AFDD,$83F7,$F1F3)		; $83A780 18
	%Player("James Patrick", $038F,$DDFD,$B2D7,$F1D6)		; $83A796 19
	%Player("Jeff Beukeboom", $2397,$74D7,$AA74,$D17C)		; $83A7AD 20
	%Player("Joe Cirella", $068A,$A4DA,$8674,$F47C)		; $83A7C5 21
	%Player("Mark Hardy", $1467,$74F4,$8574,$A479)		; $83A7DA 22
	%Player("Jay Wells", $2487,$74A7,$A577,$717C)		; $83A7EE 23
	%Player("Per Djoos", $4447,$A7D7,$8074,$D176)		; $83A801 24
	%Player("Normand Rochefort", $0597,$7114,$B171,$7A49)		; $83A814 25
	dw 2		; $83A82F end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("New York")		; $83A831
.ta:	%String("NY")		; $83A83B

Ottawa:		;93G Ottawa (TeamList 13)
.0:	dw .pld-.0		; $83A83F Playerdata
	dw .pad-.0		; $83A841 Palettedata
	dw .tn-.0		; $83A843 Teamname
	dw .ls-.0		; $83A845 LineSets
	dw .sr-.0		; $83A847 ScoutReport
	dw .sodds-.0		; $83A849 ScoreOdds
.pad:	incbin "../data/Pals/OTWh.snespal"		; $83A84B home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/OTWv.snespal"		; $83A86B visitor colours
.sr:	%hex2($0702,$02A6,$1111,$1411)		; $83A88B uupu,uuuu,skpd,cfgo
.sodds:	db 96,0		; $83A893
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,12,13,10,07,02,03,00		; $83A895 line 1
	db 01,14,15,08,03,06,10,00		; $83A89D line 2
	db 01,16,17,09,04,05,10,00		; $83A8A5 line 3
	db 01,12,13,08,03,06,10,00		; $83A8AD line 4
	db 01,17,14,07,10,02,03,00		; $83A8B5 line 5
	db 01,12,13,10,02,08,09,00		; $83A8BD line 6
	db 01,17,16,08,09,10,02,00		; $83A8C5 line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Peter Sidorkwicz", $3055,$8AA5,$0100,$5555)		; $83A8CD 1
	%Player("Mark Lamb", $075C,$C996,$9196,$6397)		; $83A8E7 2
	%Player("Mark Freer", $3756,$6393,$736C,$6963)		; $83A8FA 3
	%Player("Laurie Boschman", $165D,$77D7,$A577,$D77B)		; $83A90E 4
	%Player("Rob Murphy", $1780,$0202,$2100,$280A)		; $83A927 5
	%Player("Jim Thomson", $2586,$6093,$9A33,$3C3D)		; $83A93B 6
	%Player("Chris Lindberg", $3368,$B5B5,$5388,$555A)		; $83A950 7
	%Player("Sylvain Turgeon", $207D,$D77D,$7377,$AD75)		; $83A968 8
	%Player("Mike Peluso", $4474,$44A4,$DD4D,$4D4F)		; $83A981 9
	%Player("Jeff Lazaro", $145C,$F6C6,$9796,$6C68)		; $83A996 10
	%Player("Darcy Loewen", $3650,$0202,$2100,$250A)		; $83A9AB 11
	%Player("Ken Hammond", $0668,$8528,$5582,$B85C)		; $83A9C1 12
	%Player("Brad Shaw", $326B,$2588,$5282,$8285)		; $83A9D6 13
	%Player("Kent Paynter", $0550,$0020,$2100,$220A)		; $83A9E9 14
	%Player("Dominic Lavoie", $3880,$0020,$2000,$220A)		; $83A9FF 15
	%Player("Darren Rumble", $3470,$0020,$2100,$220A)		; $83AA17 16
	%Player("Brad Miller", $44A2,$5255,$8D22,$855F)		; $83AA2E 17
	dw 2		; $83AA43 end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Ottawa")		; $83AA45
.ta:	%String("OTW")		; $83AA4D

Philadelphia:		;93G Philadelphia (TeamList 14)
.0:	dw .pld-.0		; $83AA52 Playerdata
	dw .pad-.0		; $83AA54 Palettedata
	dw .tn-.0		; $83AA56 Teamname
	dw .ls-.0		; $83AA58 LineSets
	dw .sr-.0		; $83AA5A ScoutReport
	dw .sodds-.0		; $83AA5C ScoreOdds
.pad:	incbin "../data/Pals/PHIh.snespal"		; $83AA5E home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/PHIv.snespal"		; $83AA7E visitor colours
.sr:	%hex2($2201,$22E8,$3443,$2353)		; $83AA9E uupu,uuuu,skpd,cfgo
.sodds:	db 147,0		; $83AAA6
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,17,18,13,03,09,04,00		; $83AAA8 line 1
	db 01,21,23,15,04,10,03,00		; $83AAB0 line 2
	db 01,19,20,16,05,11,03,00		; $83AAB8 line 3
	db 01,17,23,12,04,10,03,00		; $83AAC0 line 4
	db 01,21,18,13,03,09,04,00		; $83AAC8 line 5
	db 01,17,23,04,09,03,05,00		; $83AAD0 line 6
	db 01,21,20,03,05,04,09,00		; $83AAD8 line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Ron Hextall", $2769,$9AA9,$0100,$CC99)		; $83AAE0 1
	%Player("Dominic Roussel", $3353,$9AA3,$0100,$3366)		; $83AAF5 2
	%Player("Rod Brindamour", $177C,$9C6C,$75CC,$F9C9)		; $83AB0E 3
	%Player("Mike Ricci", $186C,$CC66,$9399,$F6C9)		; $83AB26 4
	%Player("Pelle Eklund", $094F,$C999,$71C6,$C9C0)		; $83AB3A 5
	%Player("Keith Acton", $2536,$6663,$A136,$6C3C)		; $83AB50 6
	%Player("Allan Conroy", $4653,$3693,$6536,$633C)		; $83AB65 7
	%Player("Steve Kasper", $1549,$9639,$A39F,$6CC6)		; $83AB7B 8
	%Player("Kevin Dineen", $206C,$FC66,$7699,$FC9C)		; $83AB91 9
	%Player("Mark Recchi", $085F,$CF36,$73CC,$C6C9)		; $83ABA7 10
	%Player("Dave Brown", $2180,$0030,$4C06,$9F09)		; $83ABBC 11
	%Player("Dan Quinn", $105C,$C936,$4199,$9693)		; $83ABD0 12
	%Player("Mark Pederson", $1476,$6CC6,$716C,$C663)		; $83ABE3 13
	%Player("Claude Boivin", $4070,$0660,$0309,$663C)		; $83ABFA 14
	%Player("Andrei Lomakin", $236C,$9969,$319C,$99C3)		; $83AC11 15
	%Player("Brad Jones", $476C,$F666,$6569,$9C66)		; $83AC29 16
	%Player("Steve Duchesne", $286C,$CC6C,$63C6,$F3C9)		; $83AC3D 17
	%Player("Garry Galley", $0366,$6996,$9793,$C399)		; $83AC55 18
	%Player("Brian Benning", $1966,$6969,$A563,$939C)		; $83AC6B 19
	%Player("Terry Carkner", $2996,$6336,$9B63,$C36C)		; $83AC82 20
	%Player("Kerry Huffman", $0579,$9999,$7399,$F666)		; $83AC99 21
	%Player("Dan Kordic", $0680,$0390,$7603,$693C)		; $83ACB0 22
	%Player("Mark Howe", $0259,$99FC,$71C9,$F3C3)		; $83ACC4 23
	%Player("Corey Foster", $4470,$0603,$1133,$6C36)		; $83ACD7 24
	dw 2		; $83ACED end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Philadelphia")		; $83ACEF
.ta:	%String("PHI")		; $83ACFD
