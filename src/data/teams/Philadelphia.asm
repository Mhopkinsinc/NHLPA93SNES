Philadelphia:		;team 14
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/PHIh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/PHIv.snespal"		; visitor colours
.sr:	%hex2($2201,$22E8,$3443,$2353)		; uupu,uuuu,skpd,cfgo
.sodds:	db 147,0
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,17,18,13,03,09,04,00		; line 1
	db 01,21,23,15,04,10,03,00		; line 2
	db 01,19,20,16,05,11,03,00		; line 3
	db 01,17,23,12,04,10,03,00		; line 4
	db 01,21,18,13,03,09,04,00		; line 5
	db 01,17,23,04,09,03,05,00		; line 6
	db 01,21,20,03,05,04,09,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Ron Hextall", $2769,$9AA9,$0100,$CC99)		; 1
	%Player("Dominic Roussel", $3353,$9AA3,$0100,$3366)		; 2
	%Player("Rod Brindamour", $177C,$9C6C,$75CC,$F9C9)		; 3
	%Player("Mike Ricci", $186C,$CC66,$9399,$F6C9)		; 4
	%Player("Pelle Eklund", $094F,$C999,$71C6,$C9C0)		; 5
	%Player("Keith Acton", $2536,$6663,$A136,$6C3C)		; 6
	%Player("Allan Conroy", $4653,$3693,$6536,$633C)		; 7
	%Player("Steve Kasper", $1549,$9639,$A39F,$6CC6)		; 8
	%Player("Kevin Dineen", $206C,$FC66,$7699,$FC9C)		; 9
	%Player("Mark Recchi", $085F,$CF36,$73CC,$C6C9)		; 10
	%Player("Dave Brown", $2180,$0030,$4C06,$9F09)		; 11
	%Player("Dan Quinn", $105C,$C936,$4199,$9693)		; 12
	%Player("Mark Pederson", $1476,$6CC6,$716C,$C663)		; 13
	%Player("Claude Boivin", $4070,$0660,$0309,$663C)		; 14
	%Player("Andrei Lomakin", $236C,$9969,$319C,$99C3)		; 15
	%Player("Brad Jones", $476C,$F666,$6569,$9C66)		; 16
	%Player("Steve Duchesne", $286C,$CC6C,$63C6,$F3C9)		; 17
	%Player("Garry Galley", $0366,$6996,$9793,$C399)		; 18
	%Player("Brian Benning", $1966,$6969,$A563,$939C)		; 19
	%Player("Terry Carkner", $2996,$6336,$9B63,$C36C)		; 20
	%Player("Kerry Huffman", $0579,$9999,$7399,$F666)		; 21
	%Player("Dan Kordic", $0680,$0390,$7603,$693C)		; 22
	%Player("Mark Howe", $0259,$99FC,$71C9,$F3C3)		; 23
	%Player("Corey Foster", $4470,$0603,$1133,$6C36)		; 24
	dw 2		; end of the player list (empty name)
.tn:	%String("Philadelphia")
.ta:	%String("PHI")

