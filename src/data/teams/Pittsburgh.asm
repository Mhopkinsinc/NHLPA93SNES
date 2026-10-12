Pittsburgh:		;team 15
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/PITh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/PITv.snespal"		; visitor colours
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
	dw 2		; end of the player list (empty name)
.tn:	%String("Pittsburgh")
.ta:	%String("PIT")

