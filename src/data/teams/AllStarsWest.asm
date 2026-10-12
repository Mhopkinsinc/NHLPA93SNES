AllStarsWest:		;team 25
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/ASWh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/ASWv.snespal"		; visitor colours
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
	dw 2		; end of the player list (empty name)
.tn:	%String("All Stars West")
.ta:	%String("ASW")

