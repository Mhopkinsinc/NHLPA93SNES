; $838000-$838D82  ROM $18000-$18D82: team data (93G teamdata93.asm, identical values; SNES palettes and little-endian words).
; TeamList, then the team records in ROM order: AllStarsEast, AllStarsWest, Boston, Buffalo, Calgary. Record: 6 offsets (Playerdata,
; Palettedata, Teamname, LineSets, ScoutReport, ScoreOdds), .pad home/visitor palettes, .sr scout ratings, .sodds, .ls 7 line sets,
; .pld players (Player: length word, name, 8 rating bytes), the empty end entry, .tn / .ta name and abbreviation (String).
; Ends at the end of Calgary (boundary moved from $838FFF).
org $838000

macro Player(name, w1, w2, w3, w4)		;93G Player: length word (counts itself), name, ratings as 4 big-endian words
?l:	dw ?e-?l
	db "<name>"
?e:	db <w1>>>8,<w1>&$FF,<w2>>>8,<w2>&$FF,<w3>>>8,<w3>&$FF,<w4>>>8,<w4>&$FF
endmacro
macro String(text)		;93G String/StringB: length word (counts itself), then the text
?l:	dw ?e-?l
	db "<text>"
?e:
endmacro
macro hex2(w1, w2, w3, w4)		;93G hex2: 4 words as big-endian bytes
	db <w1>>>8,<w1>&$FF,<w2>>>8,<w2>&$FF,<w3>>>8,<w3>&$FF,<w4>>>8,<w4>&$FF
endmacro

TeamList:		;93G TeamList: long pointer to each team record (TeamList index = team number)
	dd Boston		; $838000 team 0
	dd Buffalo		; $838004 team 1
	dd Calgary		; $838008 team 2
	dd Chicago		; $83800C team 3
	dd Detroit		; $838010 team 4
	dd Edmonton		; $838014 team 5
	dd Hartford		; $838018 team 6
	dd LongIsland		; $83801C team 7
	dd LosAngeles		; $838020 team 8
	dd Minnesota		; $838024 team 9
	dd Montreal		; $838028 team 10
	dd NewJersey		; $83802C team 11
	dd NewYork		; $838030 team 12
	dd Ottawa		; $838034 team 13
	dd Philadelphia		; $838038 team 14
	dd Pittsburgh		; $83803C team 15
	dd Quebec		; $838040 team 16
	dd SanJose		; $838044 team 17
	dd StLouis		; $838048 team 18
	dd TampaBay		; $83804C team 19
	dd Toronto		; $838050 team 20
	dd Vancouver		; $838054 team 21
	dd Washington		; $838058 team 22
	dd Winnipeg		; $83805C team 23
	dd AllStarsEast		; $838060 team 24
	dd AllStarsWest		; $838064 team 25
	assert (TeamListEnd-TeamList)/4 == NumofTeams
TeamListEnd:

AllStarsEast:		;93G AllStarsEast (TeamList 24)
.0:	dw .pld-.0		; $838068 Playerdata
	dw .pad-.0		; $83806A Palettedata
	dw .tn-.0		; $83806C Teamname
	dw .ls-.0		; $83806E LineSets
	dw .sr-.0		; $838070 ScoutReport
	dw .sodds-.0		; $838072 ScoreOdds
.pad:	incbin "../data/Pals/ASEh.snespal"		; $838074 home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/ASEv.snespal"		; $838094 visitor colours
.sr:	%hex2($7020,$00D6,$9999,$9099)		; $8380B4 uupu,uuuu,skpd,cfgo
.sodds:	db 216,160		; $8380BC
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,17,18,14,04,11,05,00		; $8380BE line 1
	db 01,19,20,15,05,12,04,00		; $8380C6 line 2
	db 01,21,22,16,06,13,04,00		; $8380CE line 3
	db 01,17,18,14,04,11,05,00		; $8380D6 line 4
	db 01,19,20,16,05,12,04,00		; $8380DE line 5
	db 01,21,22,16,08,15,07,00		; $8380E6 line 6
	db 01,20,17,15,07,16,08,00		; $8380EE line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Patrick Roy", $335F,$AFFF,$0100,$FFFF)		; $8380F6 1
	%Player("Mike Richter", $355D,$ADDD,$0100,$DDDD)		; $83810B 2
	%Player("Don Beaupre", $0137,$AAAA,$0100,$AAAA)		; $838121 3
	%Player("Mario Lemieux", $668F,$CFFC,$90FC,$C3F9)		; $838136 4
	%Player("Mark Messier", $118F,$DFFA,$F3FD,$F4F9)		; $83814D 5
	%Player("Rod Brindamour", $177C,$9C6C,$75CC,$F9C9)		; $838163 6
	%Player("Bryan Trottier", $1969,$9936,$9199,$C996)		; $83817B 7
	%Player("Joe Sakic", $165B,$BE88,$51B8,$E5E3)		; $838193 8
	%Player("Ray Ferraro", $2056,$9CCC,$65CF,$C698)		; $8381A6 9
	%Player("John Cullen", $1558,$8B28,$32EB,$B5BB)		; $8381BB 10
	%Player("Jaromir Jagr", $688F,$CCC9,$A3FC,$C9C3)		; $8381D0 11
	%Player("Alexnder Mogilny", $896F,$FE88,$65EB,$B8EA)		; $8381E6 12
	%Player("Owen Nolan", $126B,$BB5B,$36BE,$B88C)		; $838200 13
	%Player("Kevin Stevens", $2599,$CF99,$97CC,$C9CC)		; $838214 14
	%Player("Randy Burridge", $185D,$AD7D,$73AD,$D4D5)		; $83822B 15
	%Player("Kirk Muller", $098D,$DDDD,$D5DD,$FAD8)		; $838243 16
	%Player("Ray Bourque", $778F,$CCCF,$F1F6,$F3F5)		; $838258 17
	%Player("Paul Coffey", $077F,$FC9C,$71F3,$F3FA)		; $83826D 18
	%Player("Brian Leetch", $025F,$AFDD,$83F7,$F1F3)		; $838282 19
	%Player("Kevin Hatcher", $05AA,$AADF,$E4D7,$F7D8)		; $838298 20
	%Player("Eric Desjardins", $287D,$AADA,$B2D4,$F4A5)		; $8382AF 21
	%Player("Scott Stevens", $049D,$ADFA,$F7AA,$F4DB)		; $8382C8 22
	dw 2		; $8382DF end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("All Stars East")		; $8382E1
.ta:	%String("ASE")		; $8382F1

AllStarsWest:		;93G AllStarsWest (TeamList 25)
.0:	dw .pld-.0		; $8382F6 Playerdata
	dw .pad-.0		; $8382F8 Palettedata
	dw .tn-.0		; $8382FA Teamname
	dw .ls-.0		; $8382FC LineSets
	dw .sr-.0		; $8382FE ScoutReport
	dw .sodds-.0		; $838300 ScoreOdds
.pad:	incbin "../data/Pals/ASWh.snespal"		; $838302 home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/ASWv.snespal"		; $838322 visitor colours
.sr:	%hex2($7020,$00C7,$9999,$9099)		; $838342 uupu,uuuu,skpd,cfgo
.sodds:	db 173,224		; $83834A
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,17,16,12,04,09,05,00		; $83834C line 1
	db 01,18,19,13,05,10,04,00		; $838354 line 2
	db 01,20,21,14,06,11,04,00		; $83835C line 3
	db 01,17,16,12,05,09,04,00		; $838364 line 4
	db 01,19,22,13,04,11,05,00		; $83836C line 5
	db 01,17,20,14,07,15,08,00		; $838374 line 6
	db 01,22,18,15,08,14,07,00		; $83837C line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Ed Belfour", $305F,$AFFF,$0100,$FFFF)		; $838384 1
	%Player("Kirk McLean", $016D,$AFFD,$0100,$DDFF)		; $838398 2
	%Player("Tim Cheveldae", $325D,$ADDD,$0100,$DADD)		; $8383AD 3
	%Player("Wayne Gretzky", $993F,$CF36,$61FC,$C3F4)		; $8383C4 4
	%Player("Jeremy Roenick", $273F,$FFDF,$84FF,$DADA)		; $8383DB 5
	%Player("Adam Oates", $126F,$CF69,$90F9,$C3F2)		; $8383F3 6
	%Player("Steve Yzerman", $185F,$FFDD,$50FD,$FAF7)		; $838407 7
	%Player("Sergei Fedorov", $916F,$FDDD,$A5FA,$FAF7)		; $83841E 8
	%Player("Brett Hull", $167C,$CF9F,$90FC,$CC96)		; $838436 9
	%Player("Trevor Linden", $178D,$DDAD,$A4DD,$DADA)		; $83844A 10
	%Player("Theoren Fleury", $142E,$EB8B,$C4BB,$B88D)		; $838461 11
	%Player("Luc Robitaille", $206C,$CF6C,$71FC,$C6CA)		; $838479 12
	%Player("Gary Roberts", $106B,$BEEB,$CBBF,$B88D)		; $838491 13
	%Player("Brian Bellows", $236B,$BB2B,$62E8,$E8B4)		; $8384A7 14
	%Player("Vincent Damphousse", $215C,$CCC9,$11FC,$C9C7)		; $8384BE 15
	%Player("Al MacInnis", $0278,$8BBF,$80B5,$E2BA)		; $8384DA 16
	%Player("Chris Chelios", $075D,$ADDD,$E4F4,$F4DD)		; $8384EF 17
	%Player("Doug Wilson", $245B,$880F,$81B5,$E5B3)		; $838506 18
	%Player("Phil Housley", $064F,$FF6C,$61F6,$C3F9)		; $83851B 19
	%Player("Mark Tinordi", $2588,$5828,$B582,$E25D)		; $838531 20
	%Player("Larry Robinson", $19A9,$6396,$A396,$9397)		; $838547 21
	%Player("Dave Ellett", $047B,$B82E,$95B5,$E5B8)		; $83855F 22
	dw 2		; $838574 end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("All Stars West")		; $838576
.ta:	%String("ASW")		; $838586

Boston:		;93G Boston (TeamList 0)
.0:	dw .pld-.0		; $83858B Playerdata
	dw .pad-.0		; $83858D Palettedata
	dw .tn-.0		; $83858F Teamname
	dw .ls-.0		; $838591 LineSets
	dw .sr-.0		; $838593 ScoutReport
	dw .sodds-.0		; $838595 ScoreOdds
.pad:	incbin "../data/Pals/BOSh.snespal"		; $838597 home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/BOSv.snespal"		; $8385B7 visitor colours
.sr:	%hex2($3311,$21E6,$6766,$6756)		; $8385D7 uupu,uuuu,skpd,cfgo
.sodds:	db 197,34		; $8385DF
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,19,20,16,05,14,06,00		; $8385E1 line 1
	db 01,21,22,17,06,11,05,00		; $8385E9 line 2
	db 01,23,24,15,07,12,05,00		; $8385F1 line 3
	db 01,19,20,05,06,14,16,00		; $8385F9 line 4
	db 01,21,22,15,16,11,05,00		; $838601 line 5
	db 01,19,20,11,12,15,07,00		; $838609 line 6
	db 01,21,22,15,07,11,12,00		; $838611 line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Andy Moog", $353C,$9ACC,$0100,$C9C9)		; $838619 1
	%Player("Daniel Berthiaume", $3116,$9AA6,$0100,$6966)		; $83862C 2
	%Player("Matt Delguidice", $3333,$9AA3,$0000,$0300)		; $838647 3
	%Player("Rejean Lemelin", $0139,$9AA6,$0100,$6666)		; $838660 4
	%Player("Adam Oates", $126F,$CF69,$90F9,$C3F2)		; $838678 5
	%Player("Vladimir Ruzicka", $389C,$CC6C,$77CC,$CC95)		; $83868C 6
	%Player("Bob Sweeney", $207C,$6639,$CA96,$C99B)		; $8386A6 7
	%Player("Ken Hodge", $1079,$963C,$97C6,$6992)		; $8386BB 8
	%Player("Barry Pederson", $215C,$C639,$A499,$6960)		; $8386CE 9
	%Player("Joe Juneau", $494C,$9FF6,$6099,$6392)		; $8386E6 10
	%Player("Stephen Leach", $2759,$9C69,$AA99,$FC9B)		; $8386FA 11
	%Player("Peter Douris", $1669,$C9C9,$6296,$CC60)		; $838711 12
	%Player("Lyndon Byers", $3473,$3033,$CC06,$3C0E)		; $838727 13
	%Player("Cam Neely", $088C,$CFFC,$CA9F,$CC9B)		; $83873D 14
	%Player("Brent Ashton", $188C,$C966,$C59C,$F995)		; $838750 15
	%Player("Bob Carpenter", $116F,$CC6C,$65CC,$CCC5)		; $838766 16
	%Player("Dave Reid", $1786,$9699,$4366,$9C65)		; $83877D 17
	%Player("Andy Brickley", $2576,$9FC6,$636F,$6090)		; $838790 18
	%Player("Ray Bourque", $778F,$CCCF,$F1F6,$F3F5)		; $8387A7 19
	%Player("Glen Wesley", $266F,$C96C,$ABC3,$F3C5)		; $8387BC 20
	%Player("Don Sweeney", $323F,$F36C,$A5C3,$F6C8)		; $8387D1 21
	%Player("Gordon Murphy", $286F,$C39C,$CA93,$F998)		; $8387E6 22
	%Player("Jim Wiemer", $3686,$33C3,$6B63,$966B)		; $8387FD 23
	%Player("Bob Beers", $2279,$9306,$7230,$9305)		; $838811 24
	dw 2		; $838824 end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Boston")		; $838826
.ta:	%String("BOS")		; $83882E

Buffalo:		;93G Buffalo (TeamList 1)
.0:	dw .pld-.0		; $838833 Playerdata
	dw .pad-.0		; $838835 Palettedata
	dw .tn-.0		; $838837 Teamname
	dw .ls-.0		; $838839 LineSets
	dw .sr-.0		; $83883B ScoutReport
	dw .sodds-.0		; $83883D ScoreOdds
.pad:	incbin "../data/Pals/BUFh.snespal"		; $83883F home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/BUFv.snespal"		; $83885F visitor colours
.sr:	%hex2($5522,$22D8,$2442,$3933)		; $83887F uupu,uuuu,skpd,cfgo
.sodds:	db 101,80		; $838887
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,20,18,13,06,09,04,00		; $838889 line 1
	db 01,17,21,14,04,10,06,00		; $838891 line 2
	db 01,19,23,15,05,08,06,00		; $838899 line 3
	db 01,18,17,13,06,09,04,00		; $8388A1 line 4
	db 01,23,21,14,04,10,06,00		; $8388A9 line 5
	db 01,17,21,06,08,14,05,00		; $8388B1 line 6
	db 01,23,20,14,05,06,08,00		; $8388B9 line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Daren Puppa", $3188,$8AA8,$0000,$5588)		; $8388C1 1
	%Player("Clint Malarchuk", $3058,$8AA8,$0100,$8885)		; $8388D6 2
	%Player("Tom Draper", $3552,$8AA0,$0100,$2220)		; $8388EF 3
	%Player("Dale Hawerchuk", $105E,$BE28,$51E5,$B5E4)		; $838903 4
	%Player("Christan Ruuttu", $216B,$B558,$67B2,$B8BA)		; $83891B 5
	%Player("Pat LaFontaine", $164E,$BFB8,$80EE,$E5ED)		; $838934 6
	%Player("Dave Hannan", $1452,$2222,$5328,$582A)		; $83894C 7
	%Player("Tony Tanti", $195B,$B858,$67B8,$BB5A)		; $838961 8
	%Player("Alexnder Mogilny", $896F,$FE88,$65EB,$B8EA)		; $838975 9
	%Player("Donald Audette", $2848,$8B88,$668B,$BB5A)		; $83898F 10
	%Player("Wayne Presley", $1858,$880B,$6655,$5B5D)		; $8389A7 11
	%Player("Colin Patterson", $176B,$B252,$9458,$5554)		; $8389BE 12
	%Player("Dave Andreychuk", $25A5,$5E5B,$6488,$BB87)		; $8389D7 13
	%Player("Randy Wood", $1562,$E825,$9755,$EB5A)		; $8389F0 14
	%Player("Brad May", $2775,$5225,$9D58,$8E2F)		; $838A04 15
	%Player("Rob Ray", $3288,$B222,$BD5B,$2B2F)		; $838A16 16
	%Player("Doug Bodger", $0885,$8885,$9752,$E28A)		; $838A27 17
	%Player("Petr Svoboda", $074B,$B588,$95B2,$B28D)		; $838A3C 18
	%Player("Gord Donnelly", $3472,$5022,$BC25,$285F)		; $838A52 19
	%Player("Mike Ramsey", $0568,$22B5,$8552,$B22A)		; $838A69 20
	%Player("Ken Sutton", $4165,$5585,$5522,$E28A)		; $838A7E 21
	%Player("Randy Moller", $2488,$5225,$9652,$555D)		; $838A92 22
	%Player("Grant Ledyard", $037B,$885B,$8B52,$E287)		; $838AA8 23
	%Player("Randy Hillier", $2365,$2002,$5A20,$2B5D)		; $838ABF 24
	dw 2		; $838AD6 end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Buffalo")		; $838AD8
.ta:	%String("BUF")		; $838AE1

Calgary:		;93G Calgary (TeamList 2)
.0:	dw .pld-.0		; $838AE6 Playerdata
	dw .pad-.0		; $838AE8 Palettedata
	dw .tn-.0		; $838AEA Teamname
	dw .ls-.0		; $838AEC LineSets
	dw .sr-.0		; $838AEE ScoutReport
	dw .sodds-.0		; $838AF0 ScoreOdds
.pad:	incbin "../data/Pals/CGYh.snespal"		; $838AF2 home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/CGYv.snespal"		; $838B12 visitor colours
.sr:	%hex2($6622,$11D8,$4334,$4823)		; $838B32 uupu,uuuu,skpd,cfgo
.sodds:	db 196,0		; $838B3A
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,19,17,14,03,10,06,00		; $838B3C line 1
	db 01,18,21,13,06,11,03,00		; $838B44 line 2
	db 01,16,20,15,04,09,03,00		; $838B4C line 3
	db 01,19,17,14,03,10,05,00		; $838B54 line 4
	db 01,18,21,06,05,11,03,00		; $838B5C line 5
	db 01,17,16,04,07,13,09,00		; $838B64 line 6
	db 01,19,20,13,09,04,07,00		; $838B6C line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Mike Vernon", $3038,$8AAB,$0100,$BB88)		; $838B74 1
	%Player("Jeff Reese", $3535,$8AA5,$0100,$5588)		; $838B89 2
	%Player("Theoren Fleury", $142E,$EB8B,$C4BB,$B88D)		; $838B9D 3
	%Player("Joel Otto", $29AB,$8855,$EA88,$B85D)		; $838BB5 4
	%Player("Robert Reichel", $265B,$BB8B,$53B8,$88B4)		; $838BC8 5
	%Player("Joe Nieuwendyk", $256B,$BB8B,$85BB,$B557)		; $838BE0 6
	%Player("Marc Habscheid", $175B,$B528,$84B8,$8887)		; $838BF8 7
	%Player("Carey Wilson", $3368,$8825,$508B,$5857)		; $838C10 8
	%Player("Ronnie Stern", $2265,$5585,$9A58,$BB5F)		; $838C26 9
	%Player("Sergei Makarov", $425E,$BBB5,$21EE,$B2E7)		; $838C3C 10
	%Player("Gary Leeman", $114B,$B828,$64B5,$BBBA)		; $838C54 11
	%Player("Tomas Forslund", $277B,$B522,$31B8,$5854)		; $838C69 12
	%Player("Paul Ranheim", $286B,$B8B8,$52BB,$BB84)		; $838C81 13
	%Player("Gary Roberts", $106B,$BEEB,$CBBF,$B88D)		; $838C97 14
	%Player("Craig Berube", $1685,$8255,$9D25,$8B2D)		; $838CAD 15
	%Player("Frank Musil", $038B,$B2B5,$9B52,$B55A)		; $838CC3 16
	%Player("Al MacInnis", $0278,$8BBF,$80B5,$E2BA)		; $838CD8 17
	%Player("Michel Petit", $0788,$852B,$9AB2,$B28D)		; $838CED 18
	%Player("Gary Suter", $206E,$BB8B,$B5B5,$E2BD)		; $838D03 19
	%Player("Mark Osiecki", $5575,$5252,$2252,$B524)		; $838D17 20
	%Player("Trent Yawney", $1868,$5555,$8788,$B287)		; $838D2D 21
	%Player("Alexnder Godynyuk", $2185,$8525,$9B55,$222D)		; $838D43 22
	%Player("Neil Sheehy", $1595,$2225,$8A22,$282D)		; $838D5E 23
	dw 2		; $838D73 end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Calgary")		; $838D75
.ta:	%String("CGY")		; $838D7E
