setsortcords:		;Draw the sorted objects in display order, hiding ones that are off screen
	lda.w #OOlist		; a4 = OOlist
	sta.b a4
.top:
	lda.b (a4)
	and.w #$00FF
	tax
	lda.w Zpos,x
	bmi .next
	sta.b d2
	lda.w Xpos,x
	sta.b d0
	lda.w Ypos,x
	sta.b d1
	jsl.l projxy
	cmp.w #OFFSCREEN		; off the screen
	beq .next
	sta.b spry
	lda.b d0
	sta.b sprx
	lda.w frame,x		; oldframe = frame
	sta.w oldframe,x
	sta.b sprframe
	lda.w attribute,x
	and.w #$0800
	sta.b sprhflip
	lda.w attribute,x
	and.w #$1000
	sta.b sprvflip
	lda.w attribute,x		; attribute bit 0: sprflag
	lsr a
	bcc .add
	lda.w #$8000
	sta.b sprflag
.add:
	jsl.l addframe		; sprframe at sprx/spry
.next:
	inc.b a4
	lda.b a4
	cmp.w #OOlist+$10
	bne .top
	rtl
