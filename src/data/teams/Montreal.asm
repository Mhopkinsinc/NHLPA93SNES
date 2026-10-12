Montreal:		;team 10
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/MTLh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/MTLv.snespal"		; visitor colours
.sr:	%hex2($3011,$22E7,$7888,$8499)		; uupu,uuuu,skpd,cfgo
.sodds:	db 210,32
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,20,18,14,05,13,04,00		; line 1
	db 01,21,23,16,04,10,05,00		; line 2
	db 01,19,22,15,06,11,05,00		; line 3
	db 01,20,19,14,16,04,05,00		; line 4
	db 01,21,23,17,05,09,14,00		; line 5
	db 01,19,23,16,08,14,05,00		; line 6
	db 01,20,18,14,05,16,08,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Patrick Roy", $335F,$AFFF,$0100,$FFFF)		; 1
	%Player("Roland Melanson", $0157,$AAA7,$0100,$4477)		; 2
	%Player("Andre Racicot", $4031,$AAA1,$0100,$1111)		; 3
	%Player("Stephan Lebeau", $474D,$DDDA,$70AD,$DAA0)		; 4
	%Player("Denis Savard", $184F,$DDAA,$52FD,$F7D5)		; 5
	%Player("Guy Carbonneau", $215F,$DAA7,$B0DD,$AAD2)		; 6
	%Player("John Leclair", $179A,$D7AA,$B17A,$7D72)		; 7
	%Player("Brian Skrudland", $397D,$7477,$D5A4,$AFA5)		; 8
	%Player("Brent Gilchrist", $415D,$AAFA,$81DD,$AAA5)		; 9
	%Player("Mike Keane", $124A,$DAD7,$8277,$A7A5)		; 10
	%Player("Chris Nilan", $3084,$4474,$DC4A,$AD4E)		; 11
	%Player("Todd Ewen", $36A4,$41A4,$DA44,$4D4B)		; 12
	%Player("Russ Courtnall", $065F,$FDDA,$70DA,$A7D2)		; 13
	%Player("Kirk Muller", $118D,$DDDD,$D5DD,$FAD8)		; 14
	%Player("Mike McPhee", $357A,$D7AA,$D37A,$AD75)		; 15
	%Player("Shayne Corson", $277D,$DDDA,$D7DA,$FADB)		; 16
	%Player("Gilbert Dionne", $456A,$ADDA,$71AF,$7D72)		; 17
	%Player("J.J. Daigneault", $485D,$D4DD,$73A4,$D772)		; 18
	%Player("Matt Schneider", $086A,$77DA,$B3A4,$F7D5)		; 19
	%Player("Eric Desjardins", $287D,$AADA,$B2D4,$F4A5)		; 20
	%Player("Lyle Odelein", $248A,$44D7,$BB74,$D47B)		; 21
	%Player("Sylvain Lefebvre", $038A,$A4D4,$8374,$A4A8)		; 22
	%Player("Kevin Haller", $1457,$7774,$8747,$F478)		; 23
	%Player("Patrice Brisebois", $434A,$A7DA,$A674,$7475)		; 24
	dw 2		; end of the player list (empty name)
.tn:	%String("Montreal")
.ta:	%String("MTL")

