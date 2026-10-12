NewYork:		;team 12
.0:	dw .pld-.0		; Playerdata
	dw .pad-.0		; Palettedata
	dw .tn-.0		; Teamname
	dw .ls-.0		; LineSets
	dw .sr-.0		; ScoutReport
	dw .sodds-.0		; ScoreOdds
.pad:	incbin "../../../data/Pals/NYh.snespal"		; home colours (SNES BGR555, 16 colours)
	incbin "../../../data/Pals/NYv.snespal"		; visitor colours
.sr:	%hex2($7120,$20F8,$7989,$7789)		; uupu,uuuu,skpd,cfgo
.sodds:	db 152,0
.ls:		;-G,LD,RD,LW,-C,RW,XA,00
	db 01,18,20,15,03,09,05,00		; line 1
	db 01,21,24,16,05,08,03,00		; line 2
	db 01,19,22,17,04,12,03,00		; line 3
	db 01,18,19,03,05,09,04,00		; line 4
	db 01,21,24,16,04,08,03,00		; line 5
	db 01,19,21,03,07,04,11,00		; line 6
	db 01,18,20,04,11,03,07,00		; line 7
.pld:		;unwl,sodp,chga,eytm
	%Player("John Vanbiesbrk", $344A,$ADAA,$0100,$ADAD)		; 1
	%Player("Mike Richter", $355D,$ADDD,$0100,$DDDD)		; 2
	%Player("Mark Messier", $118F,$DFFA,$F3FD,$F4F9)		; 3
	%Player("Sergei Nemchinov", $135D,$ADDA,$A1AF,$F7A0)		; 4
	%Player("Darren Turcotte", $085F,$DDDA,$73DD,$DDA6)		; 5
	%Player("Doug Weight", $395A,$AA77,$73AA,$7773)		; 6
	%Player("Adam Graves", $095D,$DDD7,$A3AA,$ADAC)		; 7
	%Player("Tony Amonte", $335D,$DDDA,$72AD,$DDA6)		; 8
	%Player("Mike Gartner", $226F,$FDDF,$84FD,$DDF6)		; 9
	%Player("Paul Broten", $3764,$47D4,$744A,$7D49)		; 10
	%Player("Randy Gilhen", $1664,$47A4,$7177,$AD43)		; 11
	%Player("Joey Kocur", $2667,$4477,$DC77,$AF7C)		; 12
	%Player("Tie Domi", $2871,$1471,$8E17,$4A1F)		; 13
	%Player("Tim Kerr", $12B7,$7A4A,$50DA,$7A73)		; 14
	%Player("Kris King", $198D,$D4D7,$8BAA,$ADAC)		; 15
	%Player("John Ogrodnick", $258A,$AAAA,$A1AD,$DDA3)		; 16
	%Player("Jan Erixon", $207A,$A7D7,$71AD,$AAA0)		; 17
	%Player("Brian Leetch", $025F,$AFDD,$83F7,$F1F3)		; 18
	%Player("James Patrick", $038F,$DDFD,$B2D7,$F1D6)		; 19
	%Player("Jeff Beukeboom", $2397,$74D7,$AA74,$D17C)		; 20
	%Player("Joe Cirella", $068A,$A4DA,$8674,$F47C)		; 21
	%Player("Mark Hardy", $1467,$74F4,$8574,$A479)		; 22
	%Player("Jay Wells", $2487,$74A7,$A577,$717C)		; 23
	%Player("Per Djoos", $4447,$A7D7,$8074,$D176)		; 24
	%Player("Normand Rochefort", $0597,$7114,$B171,$7A49)		; 25
	dw 2		; end of the player list (empty name)
.tn:	%String("New York")
.ta:	%String("NY")

