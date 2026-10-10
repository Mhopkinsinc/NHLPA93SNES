; $838D83-$839D7C  ROM $18D83-$19D7C: team records Chicago, Detroit, Edmonton, Hartford, LosAngeles, LongIsland (93G teamdata93.asm, same values; see bank83_8000 for the format).
; Starts at Chicago, ends at the end of LongIsland (boundaries moved to the records).
org $838D83

Chicago:		;93G Chicago (TeamList 3)
.0:	dw .pld-.0		; $838D83 Playerdata
	dw .pad-.0		; $838D85 Palettedata
	dw .tn-.0		; $838D87 Teamname
	dw .ls-.0		; $838D89 LineSets
	dw .sr-.0		; $838D8B ScoutReport
	dw .sodds-.0		; $838D8D ScoreOdds
.pad:	incbin "../data/Pals/CHIh.snespal"		; $838D8F home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/CHIv.snespal"		; $838DAF visitor colours
.sr:	%hex2($3000,$21D7,$7777,$9888)		; $838DCF uupu,uuuu,skpd,cfgo
.sodds:	db 164,49		; $838DD7
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,18,19,14,05,09,07,00		; $838DD9 line 1
	db 01,20,22,16,07,11,05,00		; $838DE1 line 2
	db 01,21,23,13,06,10,05,00		; $838DE9 line 3
	db 01,18,19,14,05,09,10,00		; $838DF1 line 4
	db 01,21,22,07,10,11,05,00		; $838DF9 line 5
	db 01,21,22,07,10,06,09,00		; $838E01 line 6
	db 01,18,19,06,09,07,10,00		; $838E09 line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Ed Belfour", $305F,$AFFF,$0100,$FFFF)		; $838E11 1
	%Player("Dominik Hasek", $313A,$AAA7,$0100,$7AAA)		; $838E25 2
	%Player("Jim Waite", $295A,$AAA7,$0100,$77AA)		; $838E3C 3
	%Player("Ray LeBlanc", $5034,$AAA1,$0000,$1144)		; $838E4F 4
	%Player("Jeremy Roenick", $273F,$FFDF,$84FF,$DADA)		; $838E64 5
	%Player("Mike Hudson", $207A,$A747,$B77D,$DDAA)		; $838E7C 6
	%Player("Brent Sutter", $125A,$7D4A,$B4DA,$FAA4)		; $838E91 7
	%Player("Tony Hrkac", $1137,$77A4,$8774,$7744)		; $838EA7 8
	%Player("Steve Larmer", $286D,$ADDD,$B5D7,$FDD7)		; $838EBB 9
	%Player("Dirk Graham", $337D,$AA7A,$DAA7,$FDAA)		; $838ED1 10
	%Player("Rob Brown", $225D,$DD47,$8BDD,$D77A)		; $838EE6 11
	%Player("Brian Noonan", $106A,$AADD,$A4AA,$7FAA)		; $838EF9 12
	%Player("Jocelyn Lemieux", $267A,$D4AD,$8774,$AD4A)		; $838F0F 13
	%Player("Michel Goulet", $166D,$ADDA,$85DA,$D7D7)		; $838F28 14
	%Player("Stu Grimson", $23A4,$4174,$DD17,$4D1F)		; $838F3F 15
	%Player("Greg Gilbert", $1467,$7477,$BBAD,$AD47)		; $838F54 16
	%Player("Stephane Matteau", $3267,$7AD4,$A77D,$7A4D)		; $838F6A 17
	%Player("Chris Chelios", $075D,$ADDD,$E4F4,$F4DD)		; $838F84 18
	%Player("Steve Smith", $059D,$D7DD,$DBD4,$F7DF)		; $838F9B 19
	%Player("Frantsek Kucera", $0687,$74A4,$5274,$A774)		; $838FB0 20
	%Player("Bryan Marchment", $0274,$7477,$BB77,$F44D)		; $838FC9 21
	%Player("Keith Brown", $046D,$D7D7,$BAA4,$FAAA)		; $838FE2 22
	%Player("Rod Buskas", $2584,$4144,$5A41,$A44D)		; $838FF7 23
	%Player("Igor Kravchuk", $037D,$AA4A,$81D4,$74A4)		; $83900B 24
	dw 2		; $839022 end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Chicago")		; $839024
.ta:	%String("CHI")		; $83902D

Detroit:		;93G Detroit (TeamList 4)
.0:	dw .pld-.0		; $839032 Playerdata
	dw .pad-.0		; $839034 Palettedata
	dw .tn-.0		; $839036 Teamname
	dw .ls-.0		; $839038 LineSets
	dw .sr-.0		; $83903A ScoutReport
	dw .sodds-.0		; $83903C ScoreOdds
.pad:	incbin "../data/Pals/DETh.snespal"		; $83903E home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/DETv.snespal"		; $83905E visitor colours
.sr:	%hex2($6111,$00D7,$8879,$7878)		; $83907E uupu,uuuu,skpd,cfgo
.sodds:	db 226,16		; $839086
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,17,20,13,06,08,04,00		; $839088 line 1
	db 01,18,22,14,04,07,06,00		; $839090 line 2
	db 01,19,21,15,05,09,06,00		; $839098 line 3
	db 01,17,20,06,04,08,05,00		; $8390A0 line 4
	db 01,21,18,15,05,09,06,00		; $8390A8 line 5
	db 01,20,18,06,07,13,04,00		; $8390B0 line 6
	db 01,17,19,13,04,06,07,00		; $8390B8 line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Tim Cheveldae", $325D,$ADDD,$0100,$DADD)		; $8390C0 1
	%Player("Greg Millen", $3447,$AAA4,$0000,$7774)		; $8390D7 2
	%Player("Vincent Riendeau", $375A,$AAA7,$0100,$A77A)		; $8390EC 3
	%Player("Sergei Fedorov", $916F,$FDDD,$A5FA,$FAF7)		; $839106 4
	%Player("Jimmy Carson", $1277,$DDDD,$52DF,$D7D4)		; $83911E 5
	%Player("Steve Yzerman", $195F,$FFDD,$50FD,$FAF7)		; $839134 6
	%Player("Kevin Miller", $236D,$DAAA,$B6DD,$DAA7)		; $83914B 7
	%Player("Ray Sheppard", $2657,$7DAA,$B2AD,$DD74)		; $839161 8
	%Player("Bob Probert", $249D,$ADDA,$FF7F,$D7AF)		; $839177 9
	%Player("Brent Fedyk", $1464,$747A,$8477,$7D77)		; $83918C 10
	%Player("Alan Kerr", $186A,$A4A7,$BA77,$4A7D)		; $8391A1 11
	%Player("Sheldon Kennedy", $283A,$A777,$7477,$7777)		; $8391B4 12
	%Player("Paul Ysebaert", $216D,$DDFA,$87DD,$DAD7)		; $8391CD 13
	%Player("Shawn Burr", $1157,$7AD7,$D77A,$A77A)		; $8391E4 14
	%Player("Gerard Gallant", $1757,$7ADA,$DBAA,$DAAD)		; $8391F8 15
	%Player("Keith Primeau", $55AA,$AADA,$577F,$747D)		; $839210 16
	%Player("Nicklas Lidstrom", $054D,$ADFA,$A5D7,$F4D4)		; $839227 17
	%Player("Vladimir Konstantov", $164A,$AADA,$EAA7,$F4AD)		; $839241 18
	%Player("Brad McCrimmon", $027A,$77F7,$D747,$D4AA)		; $83925E 19
	%Player("Steve Chiasson", $038A,$AAFD,$BB77,$F4AD)		; $839276 20
	%Player("Yves Racine", $335A,$A77D,$B5A4,$D4AA)		; $83928E 21
	%Player("Brad Marsh", $20A4,$74D4,$A547,$A47A)		; $8392A3 22
	%Player("Bobby Dollas", $0897,$A4D1,$231A,$7F17)		; $8392B7 23
	dw 2		; $8392CD end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Detroit")		; $8392CF
.ta:	%String("DET")		; $8392D8

Edmonton:		;93G Edmonton (TeamList 5)
.0:	dw .pld-.0		; $8392DD Playerdata
	dw .pad-.0		; $8392DF Palettedata
	dw .tn-.0		; $8392E1 Teamname
	dw .ls-.0		; $8392E3 LineSets
	dw .sr-.0		; $8392E5 ScoutReport
	dw .sodds-.0		; $8392E7 ScoreOdds
.pad:	incbin "../data/Pals/EDMh.snespal"		; $8392E9 home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/EDMv.snespal"		; $839309 visitor colours
.sr:	%hex2($6512,$11C7,$6535,$4534)		; $839329 uupu,uuuu,skpd,cfgo
.sodds:	db 214,34		; $839331
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,22,17,10,07,08,15,00		; $839333 line 1
	db 01,19,20,11,15,06,07,00		; $83933B line 2
	db 01,18,21,16,05,09,07,00		; $839343 line 3
	db 01,17,21,10,07,08,05,00		; $83934B line 4
	db 01,19,20,16,05,09,07,00		; $839353 line 5
	db 01,22,18,16,05,12,08,00		; $83935B line 6
	db 01,19,20,12,08,16,05,00		; $839363 line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Bill Ranford", $303C,$9CFC,$0100,$CCFC)		; $83936B 1
	%Player("Ron Tugnutt", $3216,$9AA3,$0100,$3336)		; $839381 2
	%Player("Peter Ing", $0136,$9AA3,$0100,$6969)		; $839396 3
	%Player("Norm Foster", $3343,$9AA3,$0100,$3363)		; $8393A9 4
	%Player("Craig MacTavish", $146C,$9696,$C59C,$C96A)		; $8393BE 5
	%Player("Josef Beranek", $4259,$9966,$119C,$6994)		; $8393D7 6
	%Player("Bernie Nicholls", $0959,$9C9C,$32CC,$C6C7)		; $8393EE 7
	%Player("Joe Murphy", $086C,$CCCC,$A19C,$F6C7)		; $839407 8
	%Player("Scott Mellanby", $2783,$3999,$CA6C,$C96D)		; $83941B 9
	%Player("Vincent Damphousse", $215C,$CCC9,$11FC,$C9C7)		; $839433 10
	%Player("Craig Simpson", $1866,$6C99,$649C,$969A)		; $83944F 11
	%Player("Kelly Buchberger", $1686,$6996,$DD3F,$963D)		; $839466 12
	%Player("Martin Gelinas", $206C,$C9C9,$6399,$6967)		; $839480 13
	%Player("David Maley", $1260,$09C9,$9769,$663D)		; $839498 14
	%Player("Petr Klima", $856F,$F93C,$32FC,$9C97)		; $8394AD 15
	%Player("Esa Tikkanen", $107F,$FC3C,$F5C6,$FCCA)		; $8394C1 16
	%Player("Dave Manson", $2479,$999F,$CD96,$C69D)		; $8394D7 17
	%Player("Luke Richardson", $229C,$C663,$C793,$C39A)		; $8394EC 18
	%Player("Geoff Smith", $257C,$C363,$3393,$F394)		; $839505 19
	%Player("Brian Glynn", $0699,$C66C,$7363,$F364)		; $83951A 20
	%Player("Norm MacIver", $3659,$9CF9,$9166,$C097)		; $83952F 21
	%Player("Kevin Lowe", $046C,$9369,$A1C3,$C39D)		; $839545 22
	%Player("Craig Muni", $2873,$33C3,$C533,$6667)		; $839559 23
	dw 2		; $83956D end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Edmonton")		; $83956F
.ta:	%String("EDM")		; $839579

Hartford:		;93G Hartford (TeamList 6)
.0:	dw .pld-.0		; $83957E Playerdata
	dw .pad-.0		; $839580 Palettedata
	dw .tn-.0		; $839582 Teamname
	dw .ls-.0		; $839584 LineSets
	dw .sr-.0		; $839586 ScoutReport
	dw .sodds-.0		; $839588 ScoreOdds
.pad:	incbin "../data/Pals/HFDh.snespal"		; $83958A home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/HFDv.snespal"		; $8395AA visitor colours
.sr:	%hex2($1402,$00F6,$2222,$1342)		; $8395CA uupu,uuuu,skpd,cfgo
.sodds:	db 146,0		; $8395D2
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,18,22,11,03,08,04,00		; $8395D4 line 1
	db 01,19,21,12,04,09,03,00		; $8395DC line 2
	db 01,20,23,13,05,10,03,00		; $8395E4 line 3
	db 01,22,19,11,13,03,05,00		; $8395EC line 4
	db 01,20,18,12,05,09,11,00		; $8395F4 line 5
	db 01,18,20,13,12,04,09,00		; $8395FC line 6
	db 01,19,23,04,09,12,13,00		; $839604 line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Kay Whitmore", $3545,$8AA5,$0100,$5858)		; $83960C 1
	%Player("Frank Petrangelo", $4055,$8AA8,$0100,$5555)		; $839622 2
	%Player("John Cullen", $1158,$8B28,$32EB,$B5BB)		; $83963C 3
	%Player("Andrew Cassels", $2168,$8885,$3188,$B582)		; $839651 4
	%Player("Geoff Sanderson", $085B,$8888,$6188,$B882)		; $839669 5
	%Player("James Black", $2355,$5555,$3555,$5B52)		; $839682 6
	%Player("Paul Gillis", $4478,$B225,$8B20,$255E)		; $839697 7
	%Player("Bobby Holik", $2488,$8885,$9285,$8B82)		; $8396AC 8
	%Player("Mark Hunter", $267B,$8555,$9458,$EB5B)		; $8396C1 9
	%Player("Ed Kastelic", $2290,$0220,$8C0E,$800B)		; $8396D6 10
	%Player("Pat Verbeek", $1668,$5B2B,$B6B8,$B8BB)		; $8396EB 11
	%Player("Mikael Andersson", $3455,$B8B5,$0188,$E880)		; $839700 12
	%Player("Murray Craven", $125B,$BB8B,$838B,$E885)		; $83971A 13
	%Player("Jim McKenzie", $3382,$5255,$355B,$5F28)		; $839731 14
	%Player("Randy Cunnyworth", $0755,$5855,$9558,$5B8B)		; $839747 15
	%Player("Yvon Corriveau", $2065,$58B5,$872B,$5B25)		; $839761 16
	%Player("Paul Cyr", $1850,$0220,$0120,$5B28)		; $839779 17
	%Player("Steve Konroyd", $0568,$8585,$B352,$E288)		; $83978B 18
	%Player("Zarley Zalapski", $038E,$BB5B,$95B5,$E588)		; $8397A2 19
	%Player("Marc Bergevin", $2555,$5528,$6355,$E255)		; $8397BB 20
	%Player("Randy Ladouceur", $29A8,$2282,$5552,$852B)		; $8397D2 21
	%Player("Adam Burt", $0668,$852B,$8385,$B288)		; $8397EB 22
	%Player("Doug Houda", $2762,$2255,$0225,$852B)		; $8397FE 23
	dw 2		; $839812 end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Hartford")		; $839814
.ta:	%String("HFD")		; $83981E

LosAngeles:		;93G LosAngeles (TeamList 8)
.0:	dw .pld-.0		; $839823 Playerdata
	dw .pad-.0		; $839825 Palettedata
	dw .tn-.0		; $839827 Teamname
	dw .ls-.0		; $839829 LineSets
	dw .sr-.0		; $83982B ScoutReport
	dw .sodds-.0		; $83982D ScoreOdds
.pad:	incbin "../data/Pals/LAh.snespal"		; $83982F home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/LAv.snespal"		; $83984F visitor colours
.sr:	%hex2($4410,$10D8,$5664,$6535)		; $83986F uupu,uuuu,skpd,cfgo
.sodds:	db 198,16		; $839877
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,19,20,11,05,10,04,00		; $839879 line 1
	db 01,18,21,12,04,09,05,00		; $839881 line 2
	db 01,17,22,13,06,08,05,00		; $839889 line 3
	db 01,19,20,11,05,10,04,00		; $839891 line 4
	db 01,17,18,12,04,09,05,00		; $839899 line 5
	db 01,17,18,12,06,13,04,00		; $8398A1 line 6
	db 01,19,20,13,04,12,06,00		; $8398A9 line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Kelly Hrudey", $3259,$9AAC,$0100,$6669)		; $8398B1 1
	%Player("Steve Weeks", $0133,$9AA3,$0100,$6633)		; $8398C7 2
	%Player("David Goverde", $4380,$9AA3,$0000,$0330)		; $8398DC 3
	%Player("Bob Kudelski", $3779,$9939,$629C,$FC94)		; $8398F3 4
	%Player("Wayne Gretzky", $993F,$CF36,$61FC,$C3F4)		; $839909 5
	%Player("John McIntyre", $4456,$6696,$9369,$C36A)		; $839920 6
	%Player("Corey Millen", $2339,$CC96,$629C,$669A)		; $839937 7
	%Player("Dave Taylor", $1869,$66C9,$9299,$9667)		; $83994D 8
	%Player("Jari Kurri", $176C,$9C3C,$6099,$C994)		; $839962 9
	%Player("Tomas Sandstrom", $077C,$CC6F,$A7C9,$CC9A)		; $839976 10
	%Player("Luc Robitaille", $206C,$CF6C,$71FC,$C6CA)		; $83998F 11
	%Player("Tony Granato", $215C,$FC99,$949C,$FC9D)		; $8399A7 12
	%Player("Mike Donnelly", $115C,$C996,$936C,$CC94)		; $8399BD 13
	%Player("Jay Miller", $2986,$6369,$CD69,$396D)		; $8399D4 14
	%Player("Kyosti Karjalanen", $146C,$C6C9,$3193,$6364)		; $8399E8 15
	%Player("Scott Bjugstad", $0853,$3669,$3166,$6C64)		; $839A03 16
	%Player("Peter Ahola", $2686,$66C9,$9766,$F66A)		; $839A1B 17
	%Player("Marty McSorley", $33B3,$9639,$CC93,$F39F)		; $839A30 18
	%Player("Paul Coffey", $777F,$FC9C,$71F3,$F3FA)		; $839A48 19
	%Player("Rob Blake", $049C,$966C,$9293,$F99D)		; $839A5D 20
	%Player("Larry Robinson", $19A9,$6396,$A396,$9397)		; $839A70 21
	%Player("Charlie Huddy", $2289,$6639,$9393,$9397)		; $839A88 22
	%Player("Tim Watters", $0556,$6363,$7360,$636D)		; $839A9F 23
	%Player("Brent Thompson", $5643,$3333,$6530,$633D)		; $839AB4 24
	dw 2		; $839ACC end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Los Angeles")		; $839ACE
.ta:	%String("LA")		; $839ADB

LongIsland:		;93G LongIsland (TeamList 7)
.0:	dw .pld-.0		; $839ADF Playerdata
	dw .pad-.0		; $839AE1 Palettedata
	dw .tn-.0		; $839AE3 Teamname
	dw .ls-.0		; $839AE5 LineSets
	dw .sr-.0		; $839AE7 ScoutReport
	dw .sodds-.0		; $839AE9 ScoreOdds
.pad:	incbin "../data/Pals/LIh.snespal"		; $839AEB home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/LIv.snespal"		; $839B0B visitor colours
.sr:	%hex2($5522,$01E7,$5455,$5234)		; $839B2B uupu,uuuu,skpd,cfgo
.sodds:	db 102,0		; $839B33
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,20,17,13,04,12,03,00		; $839B35 line 1
	db 01,18,19,14,03,11,04,00		; $839B3D line 2
	db 01,21,23,15,06,10,04,00		; $839B45 line 3
	db 01,20,17,15,14,04,06,00		; $839B4D line 4
	db 01,23,18,13,06,03,14,00		; $839B55 line 5
	db 01,17,19,16,07,08,11,00		; $839B5D line 6
	db 01,20,22,08,11,16,07,00		; $839B65 line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Glenn Healy", $3546,$9AA6,$0100,$3636)		; $839B6D 1
	%Player("Mark Fitzpatrik", $3063,$9AA3,$0100,$3366)		; $839B82 2
	%Player("Ray Ferraro", $2056,$9CCC,$65CF,$C698)		; $839B9B 3
	%Player("Pierre Turgeon", $777C,$CF9C,$93CC,$C6C2)		; $839BB0 4
	%Player("Adam Creighton", $1189,$6963,$656C,$6C68)		; $839BC8 5
	%Player("Benoit Hogue", $336C,$FCF9,$65CC,$C6C5)		; $839BE0 6
	%Player("Claude Loiselle", $1069,$6333,$9796,$6C68)		; $839BF6 7
	%Player("Hubie McDonough", $3959,$9666,$756F,$9F62)		; $839C0F 8
	%Player("Dan Marois", $2469,$9909,$3299,$6C68)		; $839C28 9
	%Player("Mick Vukota", $1260,$9063,$7C00,$990E)		; $839C3C 10
	%Player("Tom Fitzgerald", $1463,$0663,$1066,$CC35)		; $839C51 11
	%Player("Patrick Flatley", $2679,$6CF6,$A2C9,$93C5)		; $839C69 12
	%Player("Steve Thomas", $325C,$FC99,$A599,$C9C8)		; $839C82 13
	%Player("Derek King", $2779,$6C6C,$33CF,$C962)		; $839C98 14
	%Player("Dave Volek", $255C,$CC96,$31C9,$C692)		; $839CAC 15
	%Player("Bill Berg", $1769,$3633,$1106,$9C02)		; $839CC0 16
	%Player("Tom Kurvers", $2869,$9C3C,$7396,$F092)		; $839CD3 17
	%Player("Uwe Krupp", $04B6,$69C9,$A466,$C395)		; $839CE8 18
	%Player("Richard Pilon", $4779,$9399,$AB63,$C33B)		; $839CFB 19
	%Player("Jeff Finley", $0353,$3369,$4133,$F032)		; $839D12 20
	%Player("Jeff Norton", $0869,$9996,$7363,$9095)		; $839D27 21
	%Player("Wayne McBean", $0663,$33F6,$6363,$6C65)		; $839D3C 22
	%Player("Scott Lachance", $0776,$66F3,$6163,$6332)		; $839D52 23
	dw 2		; $839D6A end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Long Island")		; $839D6C
.ta:	%String("LI")		; $839D79
