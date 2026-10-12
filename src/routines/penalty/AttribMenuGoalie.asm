AttribMenuGoalie:		;SNES: goalie attribute menu
	dw 15
	db "   Status   ]"
	dw $0000,$0000		; bit mask, rating column
	dw 15
	db "[  Overall  ]"
	dw $1B0F,$000A		; bit mask, rating column
	dw 15
	db "[  Agility  ]"
	dw $1000,$000A		; bit mask, rating column
	dw 15
	db "[   Speed   ]"
	dw $0800,$000A		; bit mask, rating column
	dw 15
	db "[Glove Hand ]"
	dw $0040,$0004		; bit mask, rating column
	dw 15
	db "[Def. Aware.]"
	dw $0200,$000A		; bit mask, rating column
	dw 15
	db "[Puck Cont. ]"
	dw $0100,$000A		; bit mask, rating column
	dw 15
	db "[Stick Right]"
	dw $0008,$000A		; bit mask, rating column
	dw 15
	db "[Stick Left ]"
	dw $0004,$000A		; bit mask, rating column
	dw 15
	db "[Glove Right]"
	dw $0002,$000A		; bit mask, rating column
	dw 15
	db "[Glove Left ]"
	dw $0001,$000A		; bit mask, rating column
	dw 15
	db "[   Weight   "
	dw $2000,$0006		; bit mask, rating column
	dw $FFFF		; end
