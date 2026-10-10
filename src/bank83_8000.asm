; $838000-$838D82  ROM $18000-$18D82: team data (93G teamdata93.asm, identical values; SNES palettes and little-endian words).
; TeamList, then the team records in ROM order: AllStarsEast, AllStarsWest, Boston, Buffalo, Calgary. Record: 6 offsets (Playerdata,
; Palettedata, Teamname, LineSets, ScoutReport, ScoreOdds), .pad home/visitor palettes, .sr scout ratings, .sodds, .ls 7 line sets,
; .pld players (Player: length word, name, 8 rating bytes), the empty end entry, .tn / .ta name and abbreviation (String).
; Ends at the end of Calgary (boundary moved from $838FFF).
org $838000

TeamList:		;93G TeamList: long pointer to each team record (TeamList index = team number)
	dd Boston		; team 0
	dd Buffalo		; team 1
	dd Calgary		; team 2
	dd Chicago		; team 3
	dd Detroit		; team 4
	dd Edmonton		; team 5
	dd Hartford		; team 6
	dd LongIsland		; team 7
	dd LosAngeles		; team 8
	dd Minnesota		; team 9
	dd Montreal		; team 10
	dd NewJersey		; team 11
	dd NewYork		; team 12
	dd Ottawa		; team 13
	dd Philadelphia		; team 14
	dd Pittsburgh		; team 15
	dd Quebec		; team 16
	dd SanJose		; team 17
	dd StLouis		; team 18
	dd TampaBay		; team 19
	dd Toronto		; team 20
	dd Vancouver		; team 21
	dd Washington		; team 22
	dd Winnipeg		; team 23
	dd AllStarsEast		; team 24
	dd AllStarsWest		; team 25
	assert (TeamListEnd-TeamList)/4 == NumofTeams
TeamListEnd:

AllStarsEast:		;93G AllStarsEast (TeamList 24)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/ASEh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/ASEv.snespal"		; visitor colours
.sr:	%hex2($7020,$00D6,$9999,$9099)		; uupu,uuuu,skpd,cfgo
.sodds:	db 216,160
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,17,18,14,04,11,05,00		; line 1
	db 01,19,20,15,05,12,04,00		; line 2
	db 01,21,22,16,06,13,04,00		; line 3
	db 01,17,18,14,04,11,05,00		; line 4
	db 01,19,20,16,05,12,04,00		; line 5
	db 01,21,22,16,08,15,07,00		; line 6
	db 01,20,17,15,07,16,08,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Patrick Roy", $335F,$AFFF,$0100,$FFFF)		; 1
	%Player("Mike Richter", $355D,$ADDD,$0100,$DDDD)		; 2
	%Player("Don Beaupre", $0137,$AAAA,$0100,$AAAA)		; 3
	%Player("Mario Lemieux", $668F,$CFFC,$90FC,$C3F9)		; 4
	%Player("Mark Messier", $118F,$DFFA,$F3FD,$F4F9)		; 5
	%Player("Rod Brindamour", $177C,$9C6C,$75CC,$F9C9)		; 6
	%Player("Bryan Trottier", $1969,$9936,$9199,$C996)		; 7
	%Player("Joe Sakic", $165B,$BE88,$51B8,$E5E3)		; 8
	%Player("Ray Ferraro", $2056,$9CCC,$65CF,$C698)		; 9
	%Player("John Cullen", $1558,$8B28,$32EB,$B5BB)		; 10
	%Player("Jaromir Jagr", $688F,$CCC9,$A3FC,$C9C3)		; 11
	%Player("Alexnder Mogilny", $896F,$FE88,$65EB,$B8EA)		; 12
	%Player("Owen Nolan", $126B,$BB5B,$36BE,$B88C)		; 13
	%Player("Kevin Stevens", $2599,$CF99,$97CC,$C9CC)		; 14
	%Player("Randy Burridge", $185D,$AD7D,$73AD,$D4D5)		; 15
	%Player("Kirk Muller", $098D,$DDDD,$D5DD,$FAD8)		; 16
	%Player("Ray Bourque", $778F,$CCCF,$F1F6,$F3F5)		; 17
	%Player("Paul Coffey", $077F,$FC9C,$71F3,$F3FA)		; 18
	%Player("Brian Leetch", $025F,$AFDD,$83F7,$F1F3)		; 19
	%Player("Kevin Hatcher", $05AA,$AADF,$E4D7,$F7D8)		; 20
	%Player("Eric Desjardins", $287D,$AADA,$B2D4,$F4A5)		; 21
	%Player("Scott Stevens", $049D,$ADFA,$F7AA,$F4DB)		; 22
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("All Stars East")
.ta:	%String("ASE")

AllStarsWest:		;93G AllStarsWest (TeamList 25)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/ASWh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/ASWv.snespal"		; visitor colours
.sr:	%hex2($7020,$00C7,$9999,$9099)		; uupu,uuuu,skpd,cfgo
.sodds:	db 173,224
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,17,16,12,04,09,05,00		; line 1
	db 01,18,19,13,05,10,04,00		; line 2
	db 01,20,21,14,06,11,04,00		; line 3
	db 01,17,16,12,05,09,04,00		; line 4
	db 01,19,22,13,04,11,05,00		; line 5
	db 01,17,20,14,07,15,08,00		; line 6
	db 01,22,18,15,08,14,07,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Ed Belfour", $305F,$AFFF,$0100,$FFFF)		; 1
	%Player("Kirk McLean", $016D,$AFFD,$0100,$DDFF)		; 2
	%Player("Tim Cheveldae", $325D,$ADDD,$0100,$DADD)		; 3
	%Player("Wayne Gretzky", $993F,$CF36,$61FC,$C3F4)		; 4
	%Player("Jeremy Roenick", $273F,$FFDF,$84FF,$DADA)		; 5
	%Player("Adam Oates", $126F,$CF69,$90F9,$C3F2)		; 6
	%Player("Steve Yzerman", $185F,$FFDD,$50FD,$FAF7)		; 7
	%Player("Sergei Fedorov", $916F,$FDDD,$A5FA,$FAF7)		; 8
	%Player("Brett Hull", $167C,$CF9F,$90FC,$CC96)		; 9
	%Player("Trevor Linden", $178D,$DDAD,$A4DD,$DADA)		; 10
	%Player("Theoren Fleury", $142E,$EB8B,$C4BB,$B88D)		; 11
	%Player("Luc Robitaille", $206C,$CF6C,$71FC,$C6CA)		; 12
	%Player("Gary Roberts", $106B,$BEEB,$CBBF,$B88D)		; 13
	%Player("Brian Bellows", $236B,$BB2B,$62E8,$E8B4)		; 14
	%Player("Vincent Damphousse", $215C,$CCC9,$11FC,$C9C7)		; 15
	%Player("Al MacInnis", $0278,$8BBF,$80B5,$E2BA)		; 16
	%Player("Chris Chelios", $075D,$ADDD,$E4F4,$F4DD)		; 17
	%Player("Doug Wilson", $245B,$880F,$81B5,$E5B3)		; 18
	%Player("Phil Housley", $064F,$FF6C,$61F6,$C3F9)		; 19
	%Player("Mark Tinordi", $2588,$5828,$B582,$E25D)		; 20
	%Player("Larry Robinson", $19A9,$6396,$A396,$9397)		; 21
	%Player("Dave Ellett", $047B,$B82E,$95B5,$E5B8)		; 22
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("All Stars West")
.ta:	%String("ASW")

Boston:		;93G Boston (TeamList 0)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/BOSh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/BOSv.snespal"		; visitor colours
.sr:	%hex2($3311,$21E6,$6766,$6756)		; uupu,uuuu,skpd,cfgo
.sodds:	db 197,34
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,19,20,16,05,14,06,00		; line 1
	db 01,21,22,17,06,11,05,00		; line 2
	db 01,23,24,15,07,12,05,00		; line 3
	db 01,19,20,05,06,14,16,00		; line 4
	db 01,21,22,15,16,11,05,00		; line 5
	db 01,19,20,11,12,15,07,00		; line 6
	db 01,21,22,15,07,11,12,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Andy Moog", $353C,$9ACC,$0100,$C9C9)		; 1
	%Player("Daniel Berthiaume", $3116,$9AA6,$0100,$6966)		; 2
	%Player("Matt Delguidice", $3333,$9AA3,$0000,$0300)		; 3
	%Player("Rejean Lemelin", $0139,$9AA6,$0100,$6666)		; 4
	%Player("Adam Oates", $126F,$CF69,$90F9,$C3F2)		; 5
	%Player("Vladimir Ruzicka", $389C,$CC6C,$77CC,$CC95)		; 6
	%Player("Bob Sweeney", $207C,$6639,$CA96,$C99B)		; 7
	%Player("Ken Hodge", $1079,$963C,$97C6,$6992)		; 8
	%Player("Barry Pederson", $215C,$C639,$A499,$6960)		; 9
	%Player("Joe Juneau", $494C,$9FF6,$6099,$6392)		; 10
	%Player("Stephen Leach", $2759,$9C69,$AA99,$FC9B)		; 11
	%Player("Peter Douris", $1669,$C9C9,$6296,$CC60)		; 12
	%Player("Lyndon Byers", $3473,$3033,$CC06,$3C0E)		; 13
	%Player("Cam Neely", $088C,$CFFC,$CA9F,$CC9B)		; 14
	%Player("Brent Ashton", $188C,$C966,$C59C,$F995)		; 15
	%Player("Bob Carpenter", $116F,$CC6C,$65CC,$CCC5)		; 16
	%Player("Dave Reid", $1786,$9699,$4366,$9C65)		; 17
	%Player("Andy Brickley", $2576,$9FC6,$636F,$6090)		; 18
	%Player("Ray Bourque", $778F,$CCCF,$F1F6,$F3F5)		; 19
	%Player("Glen Wesley", $266F,$C96C,$ABC3,$F3C5)		; 20
	%Player("Don Sweeney", $323F,$F36C,$A5C3,$F6C8)		; 21
	%Player("Gordon Murphy", $286F,$C39C,$CA93,$F998)		; 22
	%Player("Jim Wiemer", $3686,$33C3,$6B63,$966B)		; 23
	%Player("Bob Beers", $2279,$9306,$7230,$9305)		; 24
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Boston")
.ta:	%String("BOS")

Buffalo:		;93G Buffalo (TeamList 1)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/BUFh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/BUFv.snespal"		; visitor colours
.sr:	%hex2($5522,$22D8,$2442,$3933)		; uupu,uuuu,skpd,cfgo
.sodds:	db 101,80
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,20,18,13,06,09,04,00		; line 1
	db 01,17,21,14,04,10,06,00		; line 2
	db 01,19,23,15,05,08,06,00		; line 3
	db 01,18,17,13,06,09,04,00		; line 4
	db 01,23,21,14,04,10,06,00		; line 5
	db 01,17,21,06,08,14,05,00		; line 6
	db 01,23,20,14,05,06,08,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Daren Puppa", $3188,$8AA8,$0000,$5588)		; 1
	%Player("Clint Malarchuk", $3058,$8AA8,$0100,$8885)		; 2
	%Player("Tom Draper", $3552,$8AA0,$0100,$2220)		; 3
	%Player("Dale Hawerchuk", $105E,$BE28,$51E5,$B5E4)		; 4
	%Player("Christan Ruuttu", $216B,$B558,$67B2,$B8BA)		; 5
	%Player("Pat LaFontaine", $164E,$BFB8,$80EE,$E5ED)		; 6
	%Player("Dave Hannan", $1452,$2222,$5328,$582A)		; 7
	%Player("Tony Tanti", $195B,$B858,$67B8,$BB5A)		; 8
	%Player("Alexnder Mogilny", $896F,$FE88,$65EB,$B8EA)		; 9
	%Player("Donald Audette", $2848,$8B88,$668B,$BB5A)		; 10
	%Player("Wayne Presley", $1858,$880B,$6655,$5B5D)		; 11
	%Player("Colin Patterson", $176B,$B252,$9458,$5554)		; 12
	%Player("Dave Andreychuk", $25A5,$5E5B,$6488,$BB87)		; 13
	%Player("Randy Wood", $1562,$E825,$9755,$EB5A)		; 14
	%Player("Brad May", $2775,$5225,$9D58,$8E2F)		; 15
	%Player("Rob Ray", $3288,$B222,$BD5B,$2B2F)		; 16
	%Player("Doug Bodger", $0885,$8885,$9752,$E28A)		; 17
	%Player("Petr Svoboda", $074B,$B588,$95B2,$B28D)		; 18
	%Player("Gord Donnelly", $3472,$5022,$BC25,$285F)		; 19
	%Player("Mike Ramsey", $0568,$22B5,$8552,$B22A)		; 20
	%Player("Ken Sutton", $4165,$5585,$5522,$E28A)		; 21
	%Player("Randy Moller", $2488,$5225,$9652,$555D)		; 22
	%Player("Grant Ledyard", $037B,$885B,$8B52,$E287)		; 23
	%Player("Randy Hillier", $2365,$2002,$5A20,$2B5D)		; 24
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Buffalo")
.ta:	%String("BUF")

Calgary:		;93G Calgary (TeamList 2)
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../data/Pals/CGYh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../data/Pals/CGYv.snespal"		; visitor colours
.sr:	%hex2($6622,$11D8,$4334,$4823)		; uupu,uuuu,skpd,cfgo
.sodds:	db 196,0
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,19,17,14,03,10,06,00		; line 1
	db 01,18,21,13,06,11,03,00		; line 2
	db 01,16,20,15,04,09,03,00		; line 3
	db 01,19,17,14,03,10,05,00		; line 4
	db 01,18,21,06,05,11,03,00		; line 5
	db 01,17,16,04,07,13,09,00		; line 6
	db 01,19,20,13,09,04,07,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Mike Vernon", $3038,$8AAB,$0100,$BB88)		; 1
	%Player("Jeff Reese", $3535,$8AA5,$0100,$5588)		; 2
	%Player("Theoren Fleury", $142E,$EB8B,$C4BB,$B88D)		; 3
	%Player("Joel Otto", $29AB,$8855,$EA88,$B85D)		; 4
	%Player("Robert Reichel", $265B,$BB8B,$53B8,$88B4)		; 5
	%Player("Joe Nieuwendyk", $256B,$BB8B,$85BB,$B557)		; 6
	%Player("Marc Habscheid", $175B,$B528,$84B8,$8887)		; 7
	%Player("Carey Wilson", $3368,$8825,$508B,$5857)		; 8
	%Player("Ronnie Stern", $2265,$5585,$9A58,$BB5F)		; 9
	%Player("Sergei Makarov", $425E,$BBB5,$21EE,$B2E7)		; 10
	%Player("Gary Leeman", $114B,$B828,$64B5,$BBBA)		; 11
	%Player("Tomas Forslund", $277B,$B522,$31B8,$5854)		; 12
	%Player("Paul Ranheim", $286B,$B8B8,$52BB,$BB84)		; 13
	%Player("Gary Roberts", $106B,$BEEB,$CBBF,$B88D)		; 14
	%Player("Craig Berube", $1685,$8255,$9D25,$8B2D)		; 15
	%Player("Frank Musil", $038B,$B2B5,$9B52,$B55A)		; 16
	%Player("Al MacInnis", $0278,$8BBF,$80B5,$E2BA)		; 17
	%Player("Michel Petit", $0788,$852B,$9AB2,$B28D)		; 18
	%Player("Gary Suter", $206E,$BB8B,$B5B5,$E2BD)		; 19
	%Player("Mark Osiecki", $5575,$5252,$2252,$B524)		; 20
	%Player("Trent Yawney", $1868,$5555,$8788,$B287)		; 21
	%Player("Alexnder Godynyuk", $2185,$8525,$9B55,$222D)		; 22
	%Player("Neil Sheehy", $1595,$2225,$8A22,$282D)		; 23
	dw 2		; end of the player list (empty name; 93G dc.b 0,2)
.tn:	%String("Calgary")
.ta:	%String("CGY")
