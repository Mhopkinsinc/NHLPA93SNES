restorepl:		;Restore old joy controlled player d1, give d0
		;   SNES: release old joystick player d1, give d0 the joystick. A player in line change mode keeps control (d0 = d1)
	stz.b a0
	lda.b d1
	bmi .spd
	cmp.w #$000C		; only players 0-11
	bcs .spd
	asl.b d1
	ldy.b d1
	lda.w pflags,y
	bit.w #pf2lcm		; pf2lcm: he keeps the joystick
	beq .rel
	lsr.b d1
	lda.b d1
	sta.b d0
	rtl
.rel:		;release the old player: clear pfjoycon, set pfna
	and.w #~pfjoycon&$FFFF		; clear pfjoycon, set pfna
	ora.w #pfna
	sta.w pflags,y
.spd:		;set pfjoycon on the new player
	lda.b d0
	bmi .rtl
	cmp.w #$000C
	bcs .rtl
	sta.b d1
	asl.b d1
	ldy.b d1
	lda.w pflags,y
	ora.w #pfjoycon
	sta.w pflags,y
.rtl:
	rtl
