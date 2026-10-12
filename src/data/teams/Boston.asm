Boston:		;team 0
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/BOSh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/BOSv.snespal"		; visitor colours
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
	dw 2		; end of the player list (empty name)
.tn:	%String("Boston")
.ta:	%String("BOS")

