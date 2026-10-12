sublist:		;substitution lists by position: word offsets from sublist, then roster slots (line * 8 + position); -1 ends
	dw .defl-sublist		; goalie
	dw .defl-sublist		; LD
	dw .defr-sublist		; RD
	dw .wingl-sublist		; LW
	dw .center-sublist		; C
	dw .wingr-sublist		; RW
	dw .center-sublist		; extra attacker
.defl:	db 0+1,8+1,16+1,24+1,32+1,40+1,48+1
	db 0+2,8+2,16+2,24+2,32+2,40+2,48+2
.defr:	db 0+2,8+2,16+2,24+2,32+2,40+2,48+2
	db 0+1,8+1,16+1,24+1,32+1,40+1,48+1
.wingl:	db 0+3,8+3,16+3,24+3,32+3,40+3,48+3
	db 0+5,8+5,16+5,24+5,32+5,40+5,48+5
	db 0+4,8+4,16+4,24+4,32+4,40+4,48+4
.wingr:	db 0+5,8+5,16+5,24+5,32+5,40+5,48+5
	db 0+3,8+3,16+3,24+3,32+3,40+3,48+3
	db 0+4,8+4,16+4,24+4,32+4,40+4,48+4
.center:	db 0+4,8+4,16+4,24+4,32+4,40+4,48+4
	db 0+3,8+3,16+3,24+3,32+3,40+3,48+3
	db 0+5,8+5,16+5,24+5,32+5,40+5,48+5
	db -1
