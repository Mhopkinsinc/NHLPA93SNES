Edmonton:		;team 5
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/EDMh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/EDMv.snespal"		; visitor colours
.sr:	%hex2($6512,$11C7,$6535,$4534)		; uupu,uuuu,skpd,cfgo
.sodds:	db 214,34
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,22,17,10,07,08,15,00		; line 1
	db 01,19,20,11,15,06,07,00		; line 2
	db 01,18,21,16,05,09,07,00		; line 3
	db 01,17,21,10,07,08,05,00		; line 4
	db 01,19,20,16,05,09,07,00		; line 5
	db 01,22,18,16,05,12,08,00		; line 6
	db 01,19,20,12,08,16,05,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("Bill Ranford", $303C,$9CFC,$0100,$CCFC)		; 1
	%Player("Ron Tugnutt", $3216,$9AA3,$0100,$3336)		; 2
	%Player("Peter Ing", $0136,$9AA3,$0100,$6969)		; 3
	%Player("Norm Foster", $3343,$9AA3,$0100,$3363)		; 4
	%Player("Craig MacTavish", $146C,$9696,$C59C,$C96A)		; 5
	%Player("Josef Beranek", $4259,$9966,$119C,$6994)		; 6
	%Player("Bernie Nicholls", $0959,$9C9C,$32CC,$C6C7)		; 7
	%Player("Joe Murphy", $086C,$CCCC,$A19C,$F6C7)		; 8
	%Player("Scott Mellanby", $2783,$3999,$CA6C,$C96D)		; 9
	%Player("Vincent Damphousse", $215C,$CCC9,$11FC,$C9C7)		; 10
	%Player("Craig Simpson", $1866,$6C99,$649C,$969A)		; 11
	%Player("Kelly Buchberger", $1686,$6996,$DD3F,$963D)		; 12
	%Player("Martin Gelinas", $206C,$C9C9,$6399,$6967)		; 13
	%Player("David Maley", $1260,$09C9,$9769,$663D)		; 14
	%Player("Petr Klima", $856F,$F93C,$32FC,$9C97)		; 15
	%Player("Esa Tikkanen", $107F,$FC3C,$F5C6,$FCCA)		; 16
	%Player("Dave Manson", $2479,$999F,$CD96,$C69D)		; 17
	%Player("Luke Richardson", $229C,$C663,$C793,$C39A)		; 18
	%Player("Geoff Smith", $257C,$C363,$3393,$F394)		; 19
	%Player("Brian Glynn", $0699,$C66C,$7363,$F364)		; 20
	%Player("Norm MacIver", $3659,$9CF9,$9166,$C097)		; 21
	%Player("Kevin Lowe", $046C,$9369,$A1C3,$C39D)		; 22
	%Player("Craig Muni", $2873,$33C3,$C533,$6667)		; 23
	dw 2		; end of the player list (empty name)
.tn:	%String("Edmonton")
.ta:	%String("EDM")

