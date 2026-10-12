AllStarsEast:		;team 24
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/ASEh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/ASEv.snespal"		; visitor colours
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
	dw 2		; end of the player list (empty name)
.tn:	%String("All Stars East")
.ta:	%String("ASE")

