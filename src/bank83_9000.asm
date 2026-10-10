; $838D83-$839D7C  ROM $18D83-$19D7C: team records Chicago, Detroit, Edmonton, Hartford, LosAngeles, LongIsland (93G teamdata93.asm, same values; see bank83_8000 for the format).
; Starts at Chicago, ends at the end of LongIsland (boundaries moved to the records).
org $838D83

Chicago:		;93G Chicago (TeamList 3)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/CHIh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/CHIv.snespal"		; visitor colours
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
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Chicago")
.ta:	%String("CHI")

Detroit:		;93G Detroit (TeamList 4)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/DETh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/DETv.snespal"		; visitor colours
.sr:	%hex2($6111,$00D7,$8879,$7878)		; uupu,uuuu,skpd,cfgo
.sodds:	db 226,16
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,17,20,13,06,08,04,00		; line 1
	db 01,18,22,14,04,07,06,00		; line 2
	db 01,19,21,15,05,09,06,00		; line 3
	db 01,17,20,06,04,08,05,00		; line 4
	db 01,21,18,15,05,09,06,00		; line 5
	db 01,20,18,06,07,13,04,00		; line 6
	db 01,17,19,13,04,06,07,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Tim Cheveldae", $325D,$ADDD,$0100,$DADD)		; 1
	%Player("Greg Millen", $3447,$AAA4,$0000,$7774)		; 2
	%Player("Vincent Riendeau", $375A,$AAA7,$0100,$A77A)		; 3
	%Player("Sergei Fedorov", $916F,$FDDD,$A5FA,$FAF7)		; 4
	%Player("Jimmy Carson", $1277,$DDDD,$52DF,$D7D4)		; 5
	%Player("Steve Yzerman", $195F,$FFDD,$50FD,$FAF7)		; 6
	%Player("Kevin Miller", $236D,$DAAA,$B6DD,$DAA7)		; 7
	%Player("Ray Sheppard", $2657,$7DAA,$B2AD,$DD74)		; 8
	%Player("Bob Probert", $249D,$ADDA,$FF7F,$D7AF)		; 9
	%Player("Brent Fedyk", $1464,$747A,$8477,$7D77)		; 10
	%Player("Alan Kerr", $186A,$A4A7,$BA77,$4A7D)		; 11
	%Player("Sheldon Kennedy", $283A,$A777,$7477,$7777)		; 12
	%Player("Paul Ysebaert", $216D,$DDFA,$87DD,$DAD7)		; 13
	%Player("Shawn Burr", $1157,$7AD7,$D77A,$A77A)		; 14
	%Player("Gerard Gallant", $1757,$7ADA,$DBAA,$DAAD)		; 15
	%Player("Keith Primeau", $55AA,$AADA,$577F,$747D)		; 16
	%Player("Nicklas Lidstrom", $054D,$ADFA,$A5D7,$F4D4)		; 17
	%Player("Vladimir Konstantov", $164A,$AADA,$EAA7,$F4AD)		; 18
	%Player("Brad McCrimmon", $027A,$77F7,$D747,$D4AA)		; 19
	%Player("Steve Chiasson", $038A,$AAFD,$BB77,$F4AD)		; 20
	%Player("Yves Racine", $335A,$A77D,$B5A4,$D4AA)		; 21
	%Player("Brad Marsh", $20A4,$74D4,$A547,$A47A)		; 22
	%Player("Bobby Dollas", $0897,$A4D1,$231A,$7F17)		; 23
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Detroit")
.ta:	%String("DET")

Edmonton:		;93G Edmonton (TeamList 5)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/EDMh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/EDMv.snespal"		; visitor colours
.sr:	%hex2($6512,$11C7,$6535,$4534)		; uupu,uuuu,skpd,cfgo
.sodds:	db 214,34
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,22,17,10,07,08,15,00		; line 1
	db 01,19,20,11,15,06,07,00		; line 2
	db 01,18,21,16,05,09,07,00		; line 3
	db 01,17,21,10,07,08,05,00		; line 4
	db 01,19,20,16,05,09,07,00		; line 5
	db 01,22,18,16,05,12,08,00		; line 6
	db 01,19,20,12,08,16,05,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Bill Ranford", $303C,$9CFC,$0100,$CCFC)		; 1
	%Player("Ron Tugnutt", $3216,$9AA3,$0100,$3336)		; 2
	%Player("Peter Ing", $0136,$9AA3,$0100,$6969)		; 3
	%Player("Norm Foster", $3343,$9AA3,$0100,$3363)		; 4
	%Player("Craig MacTavish", $146C,$9696,$C59C,$C96A)		; 5
	%Player("Josef Beranek", $4259,$9966,$119C,$6994)		; 6
	%Player("Bernie Nicholls", $0959,$9C9C,$32CC,$C6C7)		; 7
	%Player("Joe Murphy", $086C,$CCCC,$A19C,$F6C7)		; 8
	%Player("Scott Mellanby", $2783,$3999,$CA6C,$C96D)		; 9
	%Player("Vincent Damphousse", $215C,$CCC9,$11FC,$C9C7)		; 10
	%Player("Craig Simpson", $1866,$6C99,$649C,$969A)		; 11
	%Player("Kelly Buchberger", $1686,$6996,$DD3F,$963D)		; 12
	%Player("Martin Gelinas", $206C,$C9C9,$6399,$6967)		; 13
	%Player("David Maley", $1260,$09C9,$9769,$663D)		; 14
	%Player("Petr Klima", $856F,$F93C,$32FC,$9C97)		; 15
	%Player("Esa Tikkanen", $107F,$FC3C,$F5C6,$FCCA)		; 16
	%Player("Dave Manson", $2479,$999F,$CD96,$C69D)		; 17
	%Player("Luke Richardson", $229C,$C663,$C793,$C39A)		; 18
	%Player("Geoff Smith", $257C,$C363,$3393,$F394)		; 19
	%Player("Brian Glynn", $0699,$C66C,$7363,$F364)		; 20
	%Player("Norm MacIver", $3659,$9CF9,$9166,$C097)		; 21
	%Player("Kevin Lowe", $046C,$9369,$A1C3,$C39D)		; 22
	%Player("Craig Muni", $2873,$33C3,$C533,$6667)		; 23
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Edmonton")
.ta:	%String("EDM")

Hartford:		;93G Hartford (TeamList 6)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/HFDh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/HFDv.snespal"		; visitor colours
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
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Hartford")
.ta:	%String("HFD")

LosAngeles:		;93G LosAngeles (TeamList 8)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/LAh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/LAv.snespal"		; visitor colours
.sr:	%hex2($4410,$10D8,$5664,$6535)		; uupu,uuuu,skpd,cfgo
.sodds:	db 198,16
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,19,20,11,05,10,04,00		; line 1
	db 01,18,21,12,04,09,05,00		; line 2
	db 01,17,22,13,06,08,05,00		; line 3
	db 01,19,20,11,05,10,04,00		; line 4
	db 01,17,18,12,04,09,05,00		; line 5
	db 01,17,18,12,06,13,04,00		; line 6
	db 01,19,20,13,04,12,06,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Kelly Hrudey", $3259,$9AAC,$0100,$6669)		; 1
	%Player("Steve Weeks", $0133,$9AA3,$0100,$6633)		; 2
	%Player("David Goverde", $4380,$9AA3,$0000,$0330)		; 3
	%Player("Bob Kudelski", $3779,$9939,$629C,$FC94)		; 4
	%Player("Wayne Gretzky", $993F,$CF36,$61FC,$C3F4)		; 5
	%Player("John McIntyre", $4456,$6696,$9369,$C36A)		; 6
	%Player("Corey Millen", $2339,$CC96,$629C,$669A)		; 7
	%Player("Dave Taylor", $1869,$66C9,$9299,$9667)		; 8
	%Player("Jari Kurri", $176C,$9C3C,$6099,$C994)		; 9
	%Player("Tomas Sandstrom", $077C,$CC6F,$A7C9,$CC9A)		; 10
	%Player("Luc Robitaille", $206C,$CF6C,$71FC,$C6CA)		; 11
	%Player("Tony Granato", $215C,$FC99,$949C,$FC9D)		; 12
	%Player("Mike Donnelly", $115C,$C996,$936C,$CC94)		; 13
	%Player("Jay Miller", $2986,$6369,$CD69,$396D)		; 14
	%Player("Kyosti Karjalanen", $146C,$C6C9,$3193,$6364)		; 15
	%Player("Scott Bjugstad", $0853,$3669,$3166,$6C64)		; 16
	%Player("Peter Ahola", $2686,$66C9,$9766,$F66A)		; 17
	%Player("Marty McSorley", $33B3,$9639,$CC93,$F39F)		; 18
	%Player("Paul Coffey", $777F,$FC9C,$71F3,$F3FA)		; 19
	%Player("Rob Blake", $049C,$966C,$9293,$F99D)		; 20
	%Player("Larry Robinson", $19A9,$6396,$A396,$9397)		; 21
	%Player("Charlie Huddy", $2289,$6639,$9393,$9397)		; 22
	%Player("Tim Watters", $0556,$6363,$7360,$636D)		; 23
	%Player("Brent Thompson", $5643,$3333,$6530,$633D)		; 24
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Los Angeles")
.ta:	%String("LA")

LongIsland:		;93G LongIsland (TeamList 7)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/LIh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/LIv.snespal"		; visitor colours
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
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Long Island")
.ta:	%String("LI")
