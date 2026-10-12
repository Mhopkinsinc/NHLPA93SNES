; Vblank and IRQ handlers, sprites, the screen. SNES PPU/DMA code lives here.
; Bank $82. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $82FCCD
marktextlo:		;SNES: textdirtylo = min(textdirtylo, A)
	cmp.b textdirtylo
	bcs .rtl
	sta.b textdirtylo
.rtl:
	rtl

org $82FD17
addframe_hi:		;SNES addframe path for sprframe >= $293: find the frame set in the table at FrameSetTable (sprframe -= set size, sprsetofs += set offset) and draw it (DrawFrameHi); lower
		;   frames go to addframe_end
	lda.b sprframe
	cmp.w #$0293
	bcs .hi
	jml.l addframe_end
.hi:
	dec.b sprframe
	stz.b sprsetofs
	ldx.w #$0000
	ldy.w #$0002
.find:
	lda.l FrameSetTable,x		; skip empty table entries
	beq .find
	sta.b farptr
	lda.l FrameSetTable+1,x
	sta.b farptr+1
	lda.b sprframe
	sec
	sbc.b [farptr]
	bcs .next
	jml.l DrawFrameHi
.next:
	sta.b sprframe
	lda.b sprsetofs
	clc
	adc.b [farptr],y
	sta.b sprsetofs
	inx
	inx
	inx
	inx
	bra .find
revplayeracc:		;SNES: playeracc with the direction d2 turned 180 degrees for a reversed player (pfrev)
	lda.w pfrev,x
	beq .acc
	lda.b d2
	eor.w #$0004
	sta.b d2
.acc:
	jml.l playeracc
marktexthi:		;SNES: textdirtyhi = max(textdirtyhi, A)
	cmp.b textdirtyhi
	bcc .rtl
	sta.b textdirtyhi
.rtl:
	rtl
ClearTeamStats:		;SNES: clear the team stats $13B2-$157D except tmgoalie, empty both penalty box lists, then on at setteams
	lda.w tmgoalie		; keep tmgoalie (2 words)
	pha
	lda.w tmgoalie+2
	pha
	ldx.w #$0000
.clr:
	stz.w tmshots,x
	inx
	inx
	cpx.w #$01CC
	bne .clr
	pla
	sta.w tmgoalie+2
	pla
	sta.w tmgoalie
	lda.w #$FFFF		; both penalty box lists empty
	sta.w tmboxlist
	sta.w tmboxlist+$1A
	jml.l setteams
