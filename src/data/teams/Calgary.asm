Calgary:		;team 2
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/CGYh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/CGYv.snespal"		; visitor colours
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
	dw 2		; end of the player list (empty name)
.tn:	%String("Calgary")
.ta:	%String("CGY")

