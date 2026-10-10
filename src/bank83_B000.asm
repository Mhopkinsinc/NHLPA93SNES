; $83AD02-$83BCA7  ROM $1AD02-$1BCA7: team records Pittsburgh, Quebec, SanJose, StLouis, TampaBay, Toronto (93G teamdata93.asm, same values; see bank83_8000 for the format).
; Starts at Pittsburgh, ends at the end of Toronto (boundaries moved to the records).
org $83AD02

Pittsburgh:		;93G Pittsburgh (TeamList 15)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/PITh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/PITv.snespal"		; visitor colours
.sr:	%hex2($7621,$10E7,$5566,$5725)		; uupu,uuuu,skpd,cfgo
.sodds:	db 182,0
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,18,17,13,04,09,03,00		; line 1
	db 01,19,23,14,03,10,04,00		; line 2
	db 01,20,21,15,05,08,04,00		; line 3
	db 01,17,20,13,04,08,10,00		; line 4
	db 01,21,18,03,10,09,04,00		; line 5
	db 01,17,22,14,03,05,08,00		; line 6
	db 01,18,20,05,08,14,03,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Tom Barrasso", $358C,$9AC9,$0000,$99C9)		; 1
	%Player("Ken Wregget", $3166,$9AA6,$0100,$9696)		; 2
	%Player("Ron Francis", $107C,$9C6C,$93CC,$F6C3)		; 3
	%Player("Mario Lemieux", $668F,$CFFC,$90FC,$C3F9)		; 4
	%Player("Bryan Trottier", $1969,$9936,$9199,$C996)		; 5
	%Player("Jiri Hrdina", $386C,$9696,$63C3,$6693)		; 6
	%Player("Ken Priestlay", $186C,$C393,$7596,$6360)		; 7
	%Player("Joe Mullen", $075C,$9FC9,$70CC,$F993)		; 8
	%Player("Jaromir Jagr", $688F,$CCC9,$A3FC,$C9C3)		; 9
	%Player("Rick Tocchet", $9286,$6CCC,$DA9C,$C99C)		; 10
	%Player("Jay Caufield", $16C3,$3063,$AC30,$363C)		; 11
	%Player("Jamie Leach", $2079,$9366,$966C,$6C60)		; 12
	%Player("Kevin Stevens", $2599,$CF99,$97CC,$C9CC)		; 13
	%Player("Bob Errey", $125C,$F996,$A59C,$CC69)		; 14
	%Player("Troy Loney", $2486,$9666,$CB69,$993C)		; 15
	%Player("Phil Bourque", $2976,$C966,$AB9C,$3669)		; 16
	%Player("Larry Murphy", $558C,$9CFC,$94C6,$F3C6)		; 17
	%Player("Kjell Samuelsson", $23B6,$639C,$C693,$F669)		; 18
	%Player("Gordie Roberts", $2869,$66C3,$9566,$9069)		; 19
	%Player("Ulf Samuelsson", $056C,$C399,$FB93,$F39C)		; 20
	%Player("Paul Stanton", $2269,$933C,$9463,$C6C9)		; 21
	%Player("Grant Jennings", $0376,$6396,$A769,$663C)		; 22
	%Player("Jim Paek", $0266,$9393,$6333,$6366)		; 23
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Pittsburgh")
.ta:	%String("PIT")

Quebec:		;93G Quebec (TeamList 16)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/QUEh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/QUEv.snespal"		; visitor colours
.sr:	%hex2($2602,$22E8,$3212,$1321)		; uupu,uuuu,skpd,cfgo
.sodds:	db 84,32
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,20,19,17,05,10,04,00		; line 1
	db 01,18,24,14,04,08,05,00		; line 2
	db 01,21,22,16,07,09,05,00		; line 3
	db 01,20,19,05,10,09,04,00		; line 4
	db 01,22,24,14,04,08,09,00		; line 5
	db 01,20,24,16,04,14,05,00		; line 6
	db 01,21,18,14,05,16,04,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Jacques Cloutier", $3232,$8AA2,$0100,$2225)		; 1
	%Player("Stephane Fiset", $3142,$8AA0,$0100,$2200)		; 2
	%Player("John Tanner", $3450,$8AA0,$0100,$0000)		; 3
	%Player("Claude Lapointe", $4748,$8855,$5388,$E859)		; 4
	%Player("Joe Sakic", $195B,$BE88,$51B8,$E5E3)		; 5
	%Player("Jamie Baker", $2860,$0552,$2155,$5B23)		; 6
	%Player("Marc Fortier", $0968,$8522,$3058,$8856)		; 7
	%Player("Mats Sundin", $136B,$BB2B,$32BB,$B8B9)		; 8
	%Player("Greg Paslawski", $2365,$5828,$508E,$BB53)		; 9
	%Player("Owen Nolan", $116B,$BB5B,$36BE,$B88C)		; 10
	%Player("Herb Raglan", $1485,$B555,$2625,$582C)		; 11
	%Player("Mike McNeill", $2068,$B222,$2155,$5553)		; 12
	%Player("Gino Cavallini", $4492,$8555,$5355,$5B56)		; 13
	%Player("Mike Hough", $1868,$5888,$538B,$E589)		; 14
	%Player("John Tonelli", $2178,$8555,$B355,$5559)		; 15
	%Player("Doug Smail", $4148,$8822,$232B,$B529)		; 16
	%Player("Valeri Kamensky", $177B,$BB5E,$60BB,$82B3)		; 17
	%Player("Craig Wolanin", $0685,$5222,$5722,$B529)		; 18
	%Player("Alexei Gusarov", $0558,$8558,$6185,$B283)		; 19
	%Player("Mikhail Tatarinov", $0468,$88BE,$B5B2,$E5B9)		; 20
	%Player("Steven Finn", $2975,$5228,$9B52,$B85C)		; 21
	%Player("Adam Foote", $5255,$5252,$8252,$B856)		; 22
	%Player("Tony Twist", $1590,$0050,$3D00,$280C)		; 23
	%Player("Curtis Leschyshyn", $0788,$B505,$8355,$E289)		; 24
	%Player("Dan Lambert", $5042,$2822,$015B,$5256)		; 25
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Quebec")
.ta:	%String("QUE")

SanJose:		;93G SanJose (TeamList 17)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/SJh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/SJv.snespal"		; visitor colours
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
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("San Jose")
.ta:	%String("SJ")

StLouis:		;93G StLouis (TeamList 18)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/STLh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/STLv.snespal"		; visitor colours
.sr:	%hex2($4210,$21D8,$4364,$4564)		; uupu,uuuu,skpd,cfgo
.sodds:	db 194,32
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,22,17,14,04,10,06,00		; line 1
	db 01,18,20,15,06,08,04,00		; line 2
	db 01,19,21,13,07,09,04,00		; line 3
	db 01,22,17,06,10,08,04,00		; line 4
	db 01,21,20,07,04,09,08,00		; line 5
	db 01,22,20,07,09,13,05,00		; line 6
	db 01,21,19,13,05,07,09,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Curtis Joseph", $315C,$9CCC,$0100,$99CC)		; 1
	%Player("Guy Hebert", $4050,$9AA0,$0100,$0000)		; 2
	%Player("Pat Jablonski", $0143,$9AA0,$0000,$3333)		; 3
	%Player("Nelson Emerson", $073C,$CC69,$74CC,$C696)		; 4
	%Player("Bob Bassen", $2839,$C6C6,$AB96,$966C)		; 5
	%Player("Craig Janney", $156C,$9C99,$61CC,$C3C3)		; 6
	%Player("Ron Sutter", $2259,$99C6,$C49C,$F6C9)		; 7
	%Player("Brendan Shanahan", $1989,$9C6C,$9ACC,$C9CC)		; 8
	%Player("Dave Christian", $2769,$6996,$309C,$F993)		; 9
	%Player("Brett Hull", $167C,$CF9F,$90FC,$CC96)		; 10
	%Player("Kelly Chase", $3960,$0063,$1603,$6F0F)		; 11
	%Player("Darin Kimble", $2980,$0360,$7A36,$360C)		; 12
	%Player("Rich Sutter", $2363,$9693,$6466,$CC69)		; 13
	%Player("Dave Lowry", $1066,$6636,$9366,$9C39)		; 14
	%Player("Ron Wilson", $1859,$99C3,$6169,$9966)		; 15
	%Player("Dave MacKey", $2673,$3033,$6336,$663C)		; 16
	%Player("Jeff Brown", $2189,$9C9F,$62C6,$C3C3)		; 17
	%Player("Stephane Quintal", $3393,$3633,$9693,$9399)		; 18
	%Player("Garth Butcher", $0576,$9696,$CA96,$C09C)		; 19
	%Player("Rick Zombo", $0466,$6699,$7466,$F066)		; 20
	%Player("Murray Baron", $0689,$9366,$4333,$F639)		; 21
	%Player("Paul Cavallini", $148C,$C999,$95C3,$F699)		; 22
	%Player("Lee Norwood", $2076,$66C3,$7763,$636C)		; 23
	%Player("Rob Robinson", $4493,$6033,$6160,$6933)		; 24
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("St. Louis")
.ta:	%String("STL")

TampaBay:		;93G TampaBay (TeamList 19)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/TBYh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/TBYv.snespal"		; visitor colours
.sr:	%hex2($0702,$02A7,$2111,$1411)		; uupu,uuuu,skpd,cfgo
.sodds:	db 48,0
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,13,12,09,02,06,03,00		; line 1
	db 01,14,15,10,03,07,02,00		; line 2
	db 01,16,17,11,04,08,02,00		; line 3
	db 01,12,14,09,02,06,04,00		; line 4
	db 01,15,13,11,04,07,02,00		; line 5
	db 01,14,13,10,03,11,05,00		; line 6
	db 01,16,18,11,05,10,03,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Wendell Young", $0159,$9AA9,$0100,$9699)		; 1
	%Player("Anatoli Semenov", $196C,$9CCC,$71CC,$C9C4)		; 2
	%Player("Rob Dimaio", $1846,$9303,$1269,$9F05)		; 3
	%Player("Brian Bradley", $443B,$8858,$8488,$5585)		; 4
	%Player("Michel Mongeau", $4163,$3960,$3139,$6360)		; 5
	%Player("Tim Hunter", $1572,$2285,$BC22,$2B2F)		; 6
	%Player("Tim Bergland", $1161,$4444,$1044,$7740)		; 7
	%Player("Shayne Stevenson", $4960,$0222,$2000,$282A)		; 8
	%Player("Mike Hartman", $2069,$9363,$CD33,$9F3C)		; 9
	%Player("Dan Vincelette", $1675,$5202,$2125,$5B2A)		; 10
	%Player("Basil McRae", $1785,$5225,$9F55,$2B2F)		; 11
	%Player("Peter Taglianeti", $3276,$63CC,$C593,$C669)		; 12
	%Player("Joe Reekie", $299C,$66C9,$7596,$F36B)		; 13
	%Player("Rob Ramage", $0578,$555B,$B685,$EBBD)		; 14
	%Player("Doug Crossman", $2867,$77D7,$7371,$71A4)		; 15
	%Player("Bob McGill", $0464,$411D,$B274,$7F4A)		; 16
	%Player("Jeff Bloemberg", $3870,$0020,$2000,$222A)		; 17
	%Player("Shawn Chambers", $2570,$0000,$2100,$220A)		; 18
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Tampa Bay")
.ta:	%String("TBY")

Toronto:		;93G Toronto (TeamList 20)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/TORh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/TORv.snespal"		; visitor colours
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
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Toronto")
.ta:	%String("TOR")
