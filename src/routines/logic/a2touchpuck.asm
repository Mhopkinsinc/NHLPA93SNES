a2touchpuck:		;A player touches the puck: remember the last touches (for assists), then the offsides and icing checks
	ldy.b a2
	lda.w Xpos,y
	sta.w ltx		; ltx/lty/ltplayer
	lda.w Ypos,y
	sta.w lty
	tya
	lsr a
	sta.w ltplayer
	stz.b a0		; a0 = team
	lda.w pfteam,y
	beq .t
	inc.b a0
	inc.b a0
.t:
	lda.w pnum,y
	sta.b d0
	ldy.b a0
	cmp.w tmtouch1,y		; same player as the last touch: no change
	beq .same
	lda.w tmflags,y
	bit.w #tmflast		; tmflast: overwrite the last touch only
	beq .shift
	and.w #~tmflast&$FFFF
	sta.w tmflags,y
	bra .st
.shift:		;shift the touch list down
	lda.w tmtouch2,y
	sta.w tmtouch3,y
	lda.w tmtouch1,y
	sta.w tmtouch2,y
.st:
	lda.b d0
	sta.w tmtouch1,y
	cmp.w tmtouch3,y		; also the third touch: drop it
	bne .same
	lda.w #$FFFF
	sta.w tmtouch3,y
.same:
	lda.w #sf2shot		; sf2shot
	trb.w sflags
	jsl.l a2offsides
	ldy.b a2
	lda.w iflags		; ifok and ifcgl and a skater: icing
	bit.w #ifok
	beq .notice
	bit.w #ifcgl
	beq .notice
	lda.w position,y
	beq .notice
	lda.w iflags
	bit.w #ifdir
	bne .up
	lda.w pfgoal,y
	beq .notice
.icing:		;icing on icingPlayer
	phx
	lda.w iflags+1		; X = icingPlayer
	and.w #$00FF
	asl a
	sta.b a3
	tax
	lda.w #PenIcing		; PenIcing
	sta.b d0
	jsl.l AddPenalty		; AddPenalty
	plx
	stx.b a3
.rtl:
	rtl
.up:
	lda.w pfgoal,y
	beq .icing
.notice:		;start a new icing watch for player a2
	tya
	lsr a
	xba
	sta.w iflags		; iflags = 0, icingPlayer = a2
	lda.w pucky
	sta.b d0
	lda.w pfgoal,y
	beq .0
	lda.w #ifdir		; ifdir
	tsb.w iflags
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.0:
	lda.b d0
	bmi .rtl
	lda.w tmap		; own team not short-handed?
	sec
	sbc.w tmap+2
	sta.b d0
	lda.w pfteam,y
	beq .1
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.1:
	lda.b d0
	bmi .rtl
	lda.w #ifok		; ifok
	tsb.w iflags
	rtl
