AttribMenuSkater:		;SNES: player attribute menu (ShowGoalBox): 15-byte item strings, the rating bit mask and column, $FFFF ends
	dw 15
	db "   Status   ]"
	dw $0000,$0000		; bit mask, rating column
	dw 15
	db "[  Overall  ]"
	dw $1F3A,$000A		; bit mask, rating column
	dw 15
	db "[  Energy   ]"
	dw $0000,$0002		; bit mask, rating column
	dw 15
	db "[  Agility  ]"
	dw $1000,$000A		; bit mask, rating column
	dw 15
	db "[   Speed   ]"
	dw $0800,$000A		; bit mask, rating column
	dw 15
	db "[  Handed   ]"
	dw $0040,$0004		; bit mask, rating column
	dw 15
	db "[Off. Aware.]"
	dw $0400,$000A		; bit mask, rating column
	dw 15
	db "[Def. Aware.]"
	dw $0200,$000A		; bit mask, rating column
	dw 15
	db "[Shot Power ]"
	dw $0100,$000A		; bit mask, rating column
	dw 15
	db "[Shot  Accur]"
	dw $0010,$000A		; bit mask, rating column
	dw 15
	db "[Pass  Accur]"
	dw $0002,$000A		; bit mask, rating column
	dw 15
	db "[Stick Handl]"
	dw $0020,$000A		; bit mask, rating column
	dw 15
	db "[  Weight   ]"
	dw $2000,$0006		; bit mask, rating column
	dw 15
	db "[ Endurance ]"
	dw $0008,$000A		; bit mask, rating column
	dw 15
	db "[Aggression ]"
	dw $0001,$000A		; bit mask, rating column
	dw 15
	db "[ Checking  ]"
	dw $0080,$000A		; bit mask, rating column
	dw 15
	db "[  Fighting  "
	dw $0040,$0008		; bit mask, rating column
	dw $FFFF		; end
