NewJersey:		;team 11
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/NJh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/NJv.snespal"		; visitor colours
.sr:	%hex2($5200,$11F6,$8668,$6467)		; uupu,uuuu,skpd,cfgo
.sodds:	db 165,0
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,22,23,14,03,08,04,00		; line 1
	db 01,20,21,13,04,09,03,00		; line 2
	db 01,18,19,12,05,10,03,00		; line 3
	db 01,23,20,13,03,08,04,00		; line 4
	db 01,21,22,14,04,09,03,00		; line 5
	db 01,23,19,12,11,05,10,00		; line 6
	db 01,21,22,05,10,12,11,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Chris Terreri", $311D,$AAAA,$0100,$AAAA)		; 1
	%Player("Craig Billington", $013A,$AAA4,$0100,$7777)		; 2
	%Player("Kevin Todd", $144A,$DDA7,$B57D,$D7A5)		; 3
	%Player("Peter Stastny", $267D,$ADAA,$A1DD,$D7F5)		; 4
	%Player("Alexnder Semak", $205A,$AADA,$A0DA,$7DD0)		; 5
	%Player("Randy McKay", $2154,$47A4,$AC7D,$4D7B)		; 6
	%Player("John MacLean", $157A,$ADAD,$A6AD,$7D7B)		; 7
	%Player("Stephane Richer", $447D,$DDAF,$70DA,$DDA2)		; 8
	%Player("Claude Lemieux", $229D,$DDDA,$B4AD,$DD78)		; 9
	%Player("Doug Brown", $245A,$D7D7,$B077,$DD72)		; 10
	%Player("Dave Barr", $116A,$AAD4,$B24A,$A745)		; 11
	%Player("Tom Chorske", $0987,$7AA4,$50AA,$DDA2)		; 12
	%Player("Claude Vilgrain", $198A,$7AF7,$52AF,$D7A8)		; 13
	%Player("Valeri Zelepukin", $255D,$DDDA,$71DD,$DAD5)		; 14
	%Player("Pat Conacher", $3267,$74A4,$514D,$7F42)		; 15
	%Player("Troy Mallette", $0881,$17D1,$874D,$774B)		; 16
	%Player("Zdeno Ciger", $336A,$DA7A,$41AD,$7D72)		; 17
	%Player("Ken Daneyko", $0387,$74A4,$DB74,$A74B)		; 18
	%Player("Bruce Driver", $235A,$AAA7,$A3A4,$D4A5)		; 19
	%Player("Eric Weinrich", $058A,$DADA,$A3A7,$D4A5)		; 20
	%Player("Alexei Kasatonov", $079D,$AADD,$B5DA,$F4D5)		; 21
	%Player("Slava Fetisov", $02AD,$77DD,$B5D4,$F1D8)		; 22
	%Player("Scott Stevens", $049D,$ADFA,$F7AA,$F4DB)		; 23
	dw 2		; end of the player list (empty name)
.tn:	%String("New Jersey")
.ta:	%String("NJ")

