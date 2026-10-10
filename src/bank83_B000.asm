; $83AD02-$83BCA7  ROM $1AD02-$1BCA7: team records Pittsburgh, Quebec, SanJose, StLouis, TampaBay, Toronto (93G teamdata93.asm, same values; see bank83_8000 for the format).
; Starts at Pittsburgh, ends at the end of Toronto (boundaries moved to the records).
org $83AD02

Pittsburgh:		;93G Pittsburgh (TeamList 15)
.0:	dw .pld-.0		; $83AD02 Playerdata
	dw .pad-.0		; $83AD04 Palettedata
	dw .tn-.0		; $83AD06 Teamname
	dw .ls-.0		; $83AD08 LineSets
	dw .sr-.0		; $83AD0A ScoutReport
	dw .sodds-.0		; $83AD0C ScoreOdds
.pad:	incbin "../data/Pals/PITh.snespal"		; $83AD0E home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/PITv.snespal"		; $83AD2E visitor colours
.sr:	%hex2($7621,$10E7,$5566,$5725)		; $83AD4E uupu,uuuu,skpd,cfgo
.sodds:	db 182,0		; $83AD56
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,18,17,13,04,09,03,00		; $83AD58 line 1
	db 01,19,23,14,03,10,04,00		; $83AD60 line 2
	db 01,20,21,15,05,08,04,00		; $83AD68 line 3
	db 01,17,20,13,04,08,10,00		; $83AD70 line 4
	db 01,21,18,03,10,09,04,00		; $83AD78 line 5
	db 01,17,22,14,03,05,08,00		; $83AD80 line 6
	db 01,18,20,05,08,14,03,00		; $83AD88 line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Tom Barrasso", $358C,$9AC9,$0000,$99C9)		; $83AD90 1
	%Player("Ken Wregget", $3166,$9AA6,$0100,$9696)		; $83ADA6 2
	%Player("Ron Francis", $107C,$9C6C,$93CC,$F6C3)		; $83ADBB 3
	%Player("Mario Lemieux", $668F,$CFFC,$90FC,$C3F9)		; $83ADD0 4
	%Player("Bryan Trottier", $1969,$9936,$9199,$C996)		; $83ADE7 5
	%Player("Jiri Hrdina", $386C,$9696,$63C3,$6693)		; $83ADFF 6
	%Player("Ken Priestlay", $186C,$C393,$7596,$6360)		; $83AE14 7
	%Player("Joe Mullen", $075C,$9FC9,$70CC,$F993)		; $83AE2B 8
	%Player("Jaromir Jagr", $688F,$CCC9,$A3FC,$C9C3)		; $83AE3F 9
	%Player("Rick Tocchet", $9286,$6CCC,$DA9C,$C99C)		; $83AE55 10
	%Player("Jay Caufield", $16C3,$3063,$AC30,$363C)		; $83AE6B 11
	%Player("Jamie Leach", $2079,$9366,$966C,$6C60)		; $83AE81 12
	%Player("Kevin Stevens", $2599,$CF99,$97CC,$C9CC)		; $83AE96 13
	%Player("Bob Errey", $125C,$F996,$A59C,$CC69)		; $83AEAD 14
	%Player("Troy Loney", $2486,$9666,$CB69,$993C)		; $83AEC0 15
	%Player("Phil Bourque", $2976,$C966,$AB9C,$3669)		; $83AED4 16
	%Player("Larry Murphy", $558C,$9CFC,$94C6,$F3C6)		; $83AEEA 17
	%Player("Kjell Samuelsson", $23B6,$639C,$C693,$F669)		; $83AF00 18
	%Player("Gordie Roberts", $2869,$66C3,$9566,$9069)		; $83AF1A 19
	%Player("Ulf Samuelsson", $056C,$C399,$FB93,$F39C)		; $83AF32 20
	%Player("Paul Stanton", $2269,$933C,$9463,$C6C9)		; $83AF4A 21
	%Player("Grant Jennings", $0376,$6396,$A769,$663C)		; $83AF60 22
	%Player("Jim Paek", $0266,$9393,$6333,$6366)		; $83AF78 23
	dw 2		; $83AF8A end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Pittsburgh")		; $83AF8C
.ta:	%String("PIT")		; $83AF98

Quebec:		;93G Quebec (TeamList 16)
.0:	dw .pld-.0		; $83AF9D Playerdata
	dw .pad-.0		; $83AF9F Palettedata
	dw .tn-.0		; $83AFA1 Teamname
	dw .ls-.0		; $83AFA3 LineSets
	dw .sr-.0		; $83AFA5 ScoutReport
	dw .sodds-.0		; $83AFA7 ScoreOdds
.pad:	incbin "../data/Pals/QUEh.snespal"		; $83AFA9 home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/QUEv.snespal"		; $83AFC9 visitor colours
.sr:	%hex2($2602,$22E8,$3212,$1321)		; $83AFE9 uupu,uuuu,skpd,cfgo
.sodds:	db 84,32		; $83AFF1
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,20,19,17,05,10,04,00		; $83AFF3 line 1
	db 01,18,24,14,04,08,05,00		; $83AFFB line 2
	db 01,21,22,16,07,09,05,00		; $83B003 line 3
	db 01,20,19,05,10,09,04,00		; $83B00B line 4
	db 01,22,24,14,04,08,09,00		; $83B013 line 5
	db 01,20,24,16,04,14,05,00		; $83B01B line 6
	db 01,21,18,14,05,16,04,00		; $83B023 line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Jacques Cloutier", $3232,$8AA2,$0100,$2225)		; $83B02B 1
	%Player("Stephane Fiset", $3142,$8AA0,$0100,$2200)		; $83B045 2
	%Player("John Tanner", $3450,$8AA0,$0100,$0000)		; $83B05D 3
	%Player("Claude Lapointe", $4748,$8855,$5388,$E859)		; $83B072 4
	%Player("Joe Sakic", $195B,$BE88,$51B8,$E5E3)		; $83B08B 5
	%Player("Jamie Baker", $2860,$0552,$2155,$5B23)		; $83B09E 6
	%Player("Marc Fortier", $0968,$8522,$3058,$8856)		; $83B0B3 7
	%Player("Mats Sundin", $136B,$BB2B,$32BB,$B8B9)		; $83B0C9 8
	%Player("Greg Paslawski", $2365,$5828,$508E,$BB53)		; $83B0DE 9
	%Player("Owen Nolan", $116B,$BB5B,$36BE,$B88C)		; $83B0F6 10
	%Player("Herb Raglan", $1485,$B555,$2625,$582C)		; $83B10A 11
	%Player("Mike McNeill", $2068,$B222,$2155,$5553)		; $83B11F 12
	%Player("Gino Cavallini", $4492,$8555,$5355,$5B56)		; $83B135 13
	%Player("Mike Hough", $1868,$5888,$538B,$E589)		; $83B14D 14
	%Player("John Tonelli", $2178,$8555,$B355,$5559)		; $83B161 15
	%Player("Doug Smail", $4148,$8822,$232B,$B529)		; $83B177 16
	%Player("Valeri Kamensky", $177B,$BB5E,$60BB,$82B3)		; $83B18B 17
	%Player("Craig Wolanin", $0685,$5222,$5722,$B529)		; $83B1A4 18
	%Player("Alexei Gusarov", $0558,$8558,$6185,$B283)		; $83B1BB 19
	%Player("Mikhail Tatarinov", $0468,$88BE,$B5B2,$E5B9)		; $83B1D3 20
	%Player("Steven Finn", $2975,$5228,$9B52,$B85C)		; $83B1EE 21
	%Player("Adam Foote", $5255,$5252,$8252,$B856)		; $83B203 22
	%Player("Tony Twist", $1590,$0050,$3D00,$280C)		; $83B217 23
	%Player("Curtis Leschyshyn", $0788,$B505,$8355,$E289)		; $83B22B 24
	%Player("Dan Lambert", $5042,$2822,$015B,$5256)		; $83B246 25
	dw 2		; $83B25B end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Quebec")		; $83B25D
.ta:	%String("QUE")		; $83B265

SanJose:		;93G SanJose (TeamList 17)
.0:	dw .pld-.0		; $83B26A Playerdata
	dw .pad-.0		; $83B26C Palettedata
	dw .tn-.0		; $83B26E Teamname
	dw .ls-.0		; $83B270 LineSets
	dw .sr-.0		; $83B272 ScoutReport
	dw .sodds-.0		; $83B274 ScoreOdds
.pad:	incbin "../data/Pals/SJh.snespal"		; $83B276 home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/SJv.snespal"		; $83B296 visitor colours
.sr:	%hex2($0702,$12E6,$2111,$3211)		; $83B2B6 uupu,uuuu,skpd,cfgo
.sodds:	db 133,34		; $83B2BE
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,24,20,16,09,11,12,00		; $83B2C0 line 1
	db 01,23,21,17,08,12,09,00		; $83B2C8 line 2
	db 01,19,22,15,07,13,09,00		; $83B2D0 line 3
	db 01,24,20,09,08,13,12,00		; $83B2D8 line 4
	db 01,22,23,07,12,11,09,00		; $83B2E0 line 5
	db 01,20,23,07,12,16,09,00		; $83B2E8 line 6
	db 01,24,21,16,09,07,12,00		; $83B2F0 line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Jeff Hackett", $3042,$8AA2,$0100,$2225)		; $83B2F8 1
	%Player("Jarmo Myllys", $3525,$8AA2,$0100,$5528)		; $83B30E 2
	%Player("Arturs Irbe", $3245,$8AA8,$0100,$8855)		; $83B324 3
	%Player("Brian Hayward", $0155,$8AA5,$0100,$5558)		; $83B339 4
	%Player("Dean Evason", $0852,$2525,$8458,$5859)		; $83B350 5
	%Player("Perry Berezan", $166B,$B505,$6058,$5E83)		; $83B365 6
	%Player("Mike Sullivan", $4755,$8525,$2158,$EB53)		; $83B37C 7
	%Player("Brian Lawton", $0965,$5805,$8358,$B856)		; $83B393 8
	%Player("Kelly Kisio", $1155,$5B28,$628B,$E289)		; $83B3A9 9
	%Player("Dale Craigwell", $3345,$5855,$8758,$5523)		; $83B3BE 10
	%Player("Pat Falloon", $176B,$BB08,$50B8,$B880)		; $83B3D6 11
	%Player("Brian Mullen", $1958,$5828,$5388,$E886)		; $83B3EB 12
	%Player("David Bruce", $1565,$5828,$225B,$BB56)		; $83B401 13
	%Player("Dave Snuggerud", $186B,$8525,$6582,$5886)		; $83B416 14
	%Player("Jeff Odgers", $3672,$5225,$6B58,$8E2C)		; $83B42E 15
	%Player("Paul Fenton", $2258,$5205,$9358,$BE53)		; $83B443 16
	%Player("Steve Bozek", $145B,$B505,$8185,$8E53)		; $83B458 17
	%Player("Johan Garpenlov", $1058,$8885,$218B,$5853)		; $83B46D 18
	%Player("Rob Zettler", $0265,$5225,$5582,$8889)		; $83B486 19
	%Player("Neil Wilkinson", $0568,$8525,$9482,$E5BC)		; $83B49B 20
	%Player("David Williams", $0365,$5825,$8452,$B226)		; $83B4B3 21
	%Player("Link Gaetz", $2388,$8208,$BD85,$288F)		; $83B4CB 22
	%Player("Jay More", $0468,$550B,$8485,$E28C)		; $83B4DF 23
	%Player("Doug Wilson", $245B,$880F,$81B5,$E5B3)		; $83B4F1 24
	dw 2		; $83B506 end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("San Jose")		; $83B508
.ta:	%String("SJ")		; $83B512

StLouis:		;93G StLouis (TeamList 18)
.0:	dw .pld-.0		; $83B516 Playerdata
	dw .pad-.0		; $83B518 Palettedata
	dw .tn-.0		; $83B51A Teamname
	dw .ls-.0		; $83B51C LineSets
	dw .sr-.0		; $83B51E ScoutReport
	dw .sodds-.0		; $83B520 ScoreOdds
.pad:	incbin "../data/Pals/STLh.snespal"		; $83B522 home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/STLv.snespal"		; $83B542 visitor colours
.sr:	%hex2($4210,$21D8,$4364,$4564)		; $83B562 uupu,uuuu,skpd,cfgo
.sodds:	db 194,32		; $83B56A
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,22,17,14,04,10,06,00		; $83B56C line 1
	db 01,18,20,15,06,08,04,00		; $83B574 line 2
	db 01,19,21,13,07,09,04,00		; $83B57C line 3
	db 01,22,17,06,10,08,04,00		; $83B584 line 4
	db 01,21,20,07,04,09,08,00		; $83B58C line 5
	db 01,22,20,07,09,13,05,00		; $83B594 line 6
	db 01,21,19,13,05,07,09,00		; $83B59C line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Curtis Joseph", $315C,$9CCC,$0100,$99CC)		; $83B5A4 1
	%Player("Guy Hebert", $4050,$9AA0,$0100,$0000)		; $83B5BB 2
	%Player("Pat Jablonski", $0143,$9AA0,$0000,$3333)		; $83B5CF 3
	%Player("Nelson Emerson", $073C,$CC69,$74CC,$C696)		; $83B5E6 4
	%Player("Bob Bassen", $2839,$C6C6,$AB96,$966C)		; $83B5FE 5
	%Player("Craig Janney", $156C,$9C99,$61CC,$C3C3)		; $83B612 6
	%Player("Ron Sutter", $2259,$99C6,$C49C,$F6C9)		; $83B628 7
	%Player("Brendan Shanahan", $1989,$9C6C,$9ACC,$C9CC)		; $83B63C 8
	%Player("Dave Christian", $2769,$6996,$309C,$F993)		; $83B656 9
	%Player("Brett Hull", $167C,$CF9F,$90FC,$CC96)		; $83B66E 10
	%Player("Kelly Chase", $3960,$0063,$1603,$6F0F)		; $83B682 11
	%Player("Darin Kimble", $2980,$0360,$7A36,$360C)		; $83B697 12
	%Player("Rich Sutter", $2363,$9693,$6466,$CC69)		; $83B6AD 13
	%Player("Dave Lowry", $1066,$6636,$9366,$9C39)		; $83B6C2 14
	%Player("Ron Wilson", $1859,$99C3,$6169,$9966)		; $83B6D6 15
	%Player("Dave MacKey", $2673,$3033,$6336,$663C)		; $83B6EA 16
	%Player("Jeff Brown", $2189,$9C9F,$62C6,$C3C3)		; $83B6FF 17
	%Player("Stephane Quintal", $3393,$3633,$9693,$9399)		; $83B713 18
	%Player("Garth Butcher", $0576,$9696,$CA96,$C09C)		; $83B72D 19
	%Player("Rick Zombo", $0466,$6699,$7466,$F066)		; $83B744 20
	%Player("Murray Baron", $0689,$9366,$4333,$F639)		; $83B758 21
	%Player("Paul Cavallini", $148C,$C999,$95C3,$F699)		; $83B76E 22
	%Player("Lee Norwood", $2076,$66C3,$7763,$636C)		; $83B786 23
	%Player("Rob Robinson", $4493,$6033,$6160,$6933)		; $83B79B 24
	dw 2		; $83B7B1 end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("St. Louis")		; $83B7B3
.ta:	%String("STL")		; $83B7BE

TampaBay:		;93G TampaBay (TeamList 19)
.0:	dw .pld-.0		; $83B7C3 Playerdata
	dw .pad-.0		; $83B7C5 Palettedata
	dw .tn-.0		; $83B7C7 Teamname
	dw .ls-.0		; $83B7C9 LineSets
	dw .sr-.0		; $83B7CB ScoutReport
	dw .sodds-.0		; $83B7CD ScoreOdds
.pad:	incbin "../data/Pals/TBYh.snespal"		; $83B7CF home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/TBYv.snespal"		; $83B7EF visitor colours
.sr:	%hex2($0702,$02A7,$2111,$1411)		; $83B80F uupu,uuuu,skpd,cfgo
.sodds:	db 48,0		; $83B817
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,13,12,09,02,06,03,00		; $83B819 line 1
	db 01,14,15,10,03,07,02,00		; $83B821 line 2
	db 01,16,17,11,04,08,02,00		; $83B829 line 3
	db 01,12,14,09,02,06,04,00		; $83B831 line 4
	db 01,15,13,11,04,07,02,00		; $83B839 line 5
	db 01,14,13,10,03,11,05,00		; $83B841 line 6
	db 01,16,18,11,05,10,03,00		; $83B849 line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Wendell Young", $0159,$9AA9,$0100,$9699)		; $83B851 1
	%Player("Anatoli Semenov", $196C,$9CCC,$71CC,$C9C4)		; $83B868 2
	%Player("Rob Dimaio", $1846,$9303,$1269,$9F05)		; $83B881 3
	%Player("Brian Bradley", $443B,$8858,$8488,$5585)		; $83B895 4
	%Player("Michel Mongeau", $4163,$3960,$3139,$6360)		; $83B8AC 5
	%Player("Tim Hunter", $1572,$2285,$BC22,$2B2F)		; $83B8C4 6
	%Player("Tim Bergland", $1161,$4444,$1044,$7740)		; $83B8D8 7
	%Player("Shayne Stevenson", $4960,$0222,$2000,$282A)		; $83B8EE 8
	%Player("Mike Hartman", $2069,$9363,$CD33,$9F3C)		; $83B908 9
	%Player("Dan Vincelette", $1675,$5202,$2125,$5B2A)		; $83B91E 10
	%Player("Basil McRae", $1785,$5225,$9F55,$2B2F)		; $83B936 11
	%Player("Peter Taglianeti", $3276,$63CC,$C593,$C669)		; $83B94B 12
	%Player("Joe Reekie", $299C,$66C9,$7596,$F36B)		; $83B965 13
	%Player("Rob Ramage", $0578,$555B,$B685,$EBBD)		; $83B979 14
	%Player("Doug Crossman", $2867,$77D7,$7371,$71A4)		; $83B98D 15
	%Player("Bob McGill", $0464,$411D,$B274,$7F4A)		; $83B9A4 16
	%Player("Jeff Bloemberg", $3870,$0020,$2000,$222A)		; $83B9B8 17
	%Player("Shawn Chambers", $2570,$0000,$2100,$220A)		; $83B9D0 18
	dw 2		; $83B9E8 end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Tampa Bay")		; $83B9EA
.ta:	%String("TBY")		; $83B9F5

Toronto:		;93G Toronto (TeamList 20)
.0:	dw .pld-.0		; $83B9FA Playerdata
	dw .pad-.0		; $83B9FC Palettedata
	dw .tn-.0		; $83B9FE Teamname
	dw .ls-.0		; $83BA00 LineSets
	dw .sr-.0		; $83BA02 ScoutReport
	dw .sodds-.0		; $83BA04 ScoreOdds
.pad:	incbin "../data/Pals/TORh.snespal"		; $83BA06 home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/TORv.snespal"		; $83BA26 visitor colours
.sr:	%hex2($1411,$12E8,$2123,$3232)		; $83BA46 uupu,uuuu,skpd,cfgo
.sodds:	db 211,0		; $83BA4E
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,17,19,13,03,06,05,00		; $83BA50 line 1
	db 01,20,21,10,05,08,03,00		; $83BA58 line 2
	db 01,18,22,14,04,07,03,00		; $83BA60 line 3
	db 01,17,19,13,10,03,07,00		; $83BA68 line 4
	db 01,18,22,05,07,06,13,00		; $83BA70 line 5
	db 01,19,21,12,04,10,03,00		; $83BA78 line 6
	db 01,18,17,10,03,12,04,00		; $83BA80 line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Grant Fuhr", $315E,$8EEE,$0000,$BBEE)		; $83BA88 1
	%Player("Rick Wamsley", $3055,$8AA5,$0100,$5555)		; $83BA9C 2
	%Player("Doug Gilmour", $933E,$8BB8,$B1BB,$E2B8)		; $83BAB2 3
	%Player("Dave McLlwain", $0768,$5552,$6388,$B882)		; $83BAC8 4
	%Player("Peter Zezel", $2578,$8B28,$9188,$B5B2)		; $83BADF 5
	%Player("Glenn Anderson", $106B,$EB28,$57B8,$B8B8)		; $83BAF4 6
	%Player("Mike Bullard", $2268,$8828,$2385,$BB85)		; $83BB0C 7
	%Player("Rob Pearson", $1255,$5822,$305B,$8B58)		; $83BB22 8
	%Player("Mike Foligno", $7165,$5855,$E48B,$5858)		; $83BB37 9
	%Player("Mike Krushelski", $2678,$8555,$8385,$EB58)		; $83BB4D 10
	%Player("Ken Baumgarter", $0870,$0020,$9D00,$2E0E)		; $83BB66 11
	%Player("Mark Osborne", $2185,$5525,$5558,$8828)		; $83BB7E 12
	%Player("Wendel Clark", $1768,$8B2E,$B7B8,$BBBB)		; $83BB94 13
	%Player("Guy Larose", $1142,$5525,$532B,$8B25)		; $83BBAA 14
	%Player("Joe Sacco", $2455,$88E5,$225B,$5B52)		; $83BBBE 15
	%Player("Kent Mandervill", $1875,$8585,$5350,$5520)		; $83BBD1 16
	%Player("Dave Ellett", $047B,$B82E,$95B5,$E5B8)		; $83BBEA 17
	%Player("Bob Rouse", $0388,$8525,$9452,$E258)		; $83BBFF 18
	%Player("Jamie Macoun", $3478,$85BB,$B582,$E2B5)		; $83BC12 19
	%Player("Todd Gill", $2358,$8225,$B552,$8258)		; $83BC28 20
	%Player("Ric Nattress", $0282,$5582,$5452,$B228)		; $83BC3B 21
	%Player("Darryl Shannon", $2868,$5225,$8182,$B552)		; $83BC51 22
	%Player("Bob Halkidis", $3372,$2222,$2725,$582B)		; $83BC69 23
	%Player("Dimitri Mironov", $1568,$5208,$218B,$55B0)		; $83BC7F 24
	dw 2		; $83BC98 end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Toronto")		; $83BC9A
.ta:	%String("TOR")		; $83BCA3
