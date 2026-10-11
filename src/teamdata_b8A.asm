; TeamList, the team records, playoffseats, Credits.
; Bank $8A. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8AFAA8
Credits:		;the title screen credit lines (length word, text); $FE ends the copyright page, $FF a page, an empty string the list
	dw 24
	db "$ 1992 Electronic Arts"
	dw 22
	db "Licensed by Nintendo"
	dw 3
	db $FE
	dw 19
	db "Design adapted by"
	dw 15
	db "Michael Brook"
	dw 11
	db "Scott Orr"
	dw 18
	db "Richard Hilleman"
	dw 3
	db $FF
	dw 21
	db "Technical Design by"
	dw 13
	db "Jim Simmons"
	dw 3
	db $FF
	dw 15
	db "Programmed by"
	dw 24
	db "Park Place Productions"
	dw 18
	db "William Robinson"
	dw 3
	db $FF
	dw 13
	db "Graphics by"
	dw 16
	db "George Simmons"
	dw 14
	db "Brian O'Hara"
	dw 16
	db "Curt Toumanian"
	dw 3
	db $FF
	dw 20
	db "Music and Sound by"
	dw 13
	db "Rob Hubbard"
	dw 3
	db $FF
	dw 13
	db "Produced by"
	dw 15
	db "Michael Brook"
	dw 3
	db $FF
	dw 20
	db "Assistant Producer"
	dw 14
	db "Robert Zalot"
	dw 3
	db $FF
	dw 21
	db "Technical Directors"
	dw 14
	db "Scott Cronce"
	dw 11
	db "Tom DeBry"
	dw 3
	db $FF
	dw 12
	db "Testing by"
	dw 10
	db "Yun Shin"
	dw 15
	db "Steve Matulac"
	dw 16
	db "Mike Rubinelli"
	dw 3
	db $FF
	dw 19
	db "Player Ratings by"
	dw 15
	db "Igor Kuperman"
	dw 3
	db $FF
	dw 19
	db "Special Thanks to"
	dw 12
	db "Bob Borgen"
	dw 12
	db "Ted Saskin"
	dw 12
	db "Ian Pulver"
	dw 11
	db "Rob Blake"
	dw 15
	db "John McIntyre"
	dw 3
	db $FF
	dw 2		; empty: end of the credits
	dw 3
	db $FF
	dw 3
	db $FF
