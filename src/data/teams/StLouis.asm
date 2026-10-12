StLouis:		;team 18
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/STLh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/STLv.snespal"		; visitor colours
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
	dw 2		; end of the player list (empty name)
.tn:	%String("St. Louis")
.ta:	%String("STL")

