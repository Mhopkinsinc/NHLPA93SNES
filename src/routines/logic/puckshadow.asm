puckshadow:		;Assignment: the puck shadow follows the puck
	lda.w frame,x
	cmp.w #$0189		; puck frame: shadow under the puck
	bne .none
	lda.w puckx
	sta.w Xpos,x
	lda.w pucky
	sta.w Ypos,x
	stz.w Zpos,x
	lda.w sfhormode
	beq .nhor
	inc.w Xpos,x
	rtl
.nhor:
	inc.w Ypos,x
	rtl
.none:
	tay
	beq .rtl
	stz.w Xpos,x
	lda.w #300		; behind the goal
	sta.w Ypos,x
	lda.w #14
	sta.w Zpos,x
	lda.w pucky
	bpl .rtl
	lda.w #$8000
	sta.w attribute,x
	lda.w #-300
	sta.w Ypos,x
	dec.w Zpos,x
.rtl:
	rtl
