QueueSound:		;SNES: queue sound command A (sfx/song number) for the SPC. Dropped while a music cue runs; sounds below $A2 need the in-game set (SPCGameUpload first)
	phx		; cuetimer running: drop it
	ldx.w cuetimer
	bne .exit
	phy
	pha
	ldx.w #$0001
	stx.b sndlock
	cpx.w sndbank		; game set not loaded and a game sound: upload it first
	beq .put
	cmp.w #$00A2
	bcs .put
	jsl.l SPCGameUpload
.put:
	ldx.b sndqin		; sndqueue[sndqin] = A, sndqin = (sndqin + 2) & 15
	pla
	sta.b sndqueue,x
	txa
	inc a
	inc a
	and.w #$000F
	sta.b sndqin
	stz.b sndlock
	ply
.exit:
	plx
	rtl
