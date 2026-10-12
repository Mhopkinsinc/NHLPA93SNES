doinput:		;process controller input
		;   SNES: controller input for player X. d0 = dpad, d1 = new buttons, d4 = controller 0/2
	jsl.l setpads		; setpads; Start: pause
	lda.b d1
	bit.w #JOYSTART
	beq .0
	lda.b d4
	bne .pause2
	jml.l startpause1
.pause2:
	jml.l startpause2
.0:
	lda.w sfhormode		; horizontal mode: dpad +90 degrees
	beq .nhor
	lda.b d0
	bit.w #$0008
	bne .nhor
	inc a
	inc a
	and.w #$0007
	sta.b d0
.nhor:
	lda.w sflags		; faceoff in progress
	bit.w #sf2faceoff
	beq .nofo
	jmp.w faceoffinput
.nofo:
	lda.w pflags,x		; line change interface
	bit.w #pf2lcm
	beq .nolcm
	jml.l lineinput
.nolcm:
	bit.w #pfjoycon		; not joystick controlled: exit
	bne .joy
	jmp.w .rtl
.joy:
	lda.w pfalock,x
	beq .nolock
	jmp.w .islocked
.nolock:
	lda.w pf2fight,x
	beq .nofight
	jml.l fightinput
.nofight:
	lda.w puckc		; carrier?
	sta.b d5
	txa
	lsr a
	cmp.b d5
	beq .ispc
	lda.b d1
	bit.w #abut
	beq .nohold
	jmp.w holdplayer
.nohold:
	bit.w #bbut
	beq .nob
	jmp.w changeplayer
.nob:		;goalie cannot check
	lda.w position,x
	beq .rtl
	lda.b d1
	bit.w #cbut
	beq .acc
	jmp.w burst
.acc:
	jml.l doplayeracc
.ispc:		;player is the puck carrier
	jsl.l checkob		; goalie with pf2aip: exit
	lda.w position,x
	bne .pc1
	lda.w pf2aip,x
	bne .rtl
.pc1:
	lda.w sflags
	bit.w #sfspdir
	beq .nopass
	jml.l passmode
.nopass:
	bit.w #sfssdir
	beq .noshot
	jmp.w ShotMode
.noshot:
	lda.b d1
	bit.w #bbut
	bne .setpassmode
	lda.w sflags		; Y without a faceoff: line change mode
	bit.w #sf2faceoff
	bne .shoot
	lda.b d1
	bit.w #abut
	bne .lc
.shoot:
	lda.w position,x
	beq .rtl
	lda.b d1
	bit.w #cbut
	beq .acc2
	jmp.w SetShotMode
.acc2:
	jml.l doplayeracc
.lc:
	lda.w lcplayer		; lcplayer $FFFF -> $FFFE
	cmp.w #$FFFF
	bne .setlc
	lda.w #$FFFE
	sta.w lcplayer
.setlc:
	jmp.w SetLCmode
.islocked:		;anim locked: only B (switch player) when not the carrier
	txa
	lsr a
	cmp.w puckc
	beq .rtl
	lda.b d1
	bit.w #$8000
	beq .rtl
	jmp.w changeplayer
.rtl:
	rtl
.setpassmode:		;the goalie keeps the puck behind the net (|x| < 16, |y| $108-$10F)
	lda.w position,x
	bne .set
	lda.w puckx
	bit.w #$8000
	beq .px
	eor.w #$FFFF
	inc a
.px:
	cmp.w #$0010
	bcs .set
	lda.w pucky
	bit.w #$8000
	beq .py
	eor.w #$FFFF
	inc a
.py:
	cmp.w #$0108
	bcc .set
	cmp.w #$0110
	bcc .rtl2
.set:
	lda.w facedir,x		; passdir = facedir; sfspdir
	and.w #$0007
	sta.w passdir
	lda.w #sfspdir
	tsb.w sflags
.rtl2:
	rtl
