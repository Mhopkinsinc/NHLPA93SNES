; $80ED38-$80FFFF  ROM $06D38-$07FFF: RonBarrMap (packed), adda43 (hockey93_02), setlccords, startpause, ReadPads,
; asspuckc (logic93_3), SuperDiv, randomd0s, assgoalie, ClampYPosition, AdjustFacingDirection, GoalieSaveList (logic93_3),
; checkgoalp_CalcGoalShotDir, CalcAngleOffset (logic93_1), reenergizeteam (penalty93_2), the internal header and the vectors.
; Starts at RonBarrMap (boundary moved from $80F008).
org $80ED38
RonBarrMap:		;93G RonBarrMap (RonBarr.map.jim): the Ron Barr picture of the scouting report, packed for DecompressGraphics (data/RonBarr.map.pak, 1590 bytes): unpacked an 8 x 9 map, 64 colours at
		;   +$90, tiles at +$190 (loaded by $8FDD22)
	incbin "../data/RonBarr.map.pak"		; $80ED38-$80F36D
RonBarrMapEnd:
	assert RonBarrMapEnd-RonBarrMap == $636
adda43:		;a4 += replaysize, wrapping from replayend to replaystart (93G hockey93_02)
		;   SNES: a4 += replaysize, wrapping from ReplayBufferEnd to ReplayBufferStart
	lda.b a4
	clc
	adc.w #replaysize
	sta.b a4
	bcc .nc
	inc.b a4+2
.nc:
	cmp.w #ReplayBufferEnd&$FFFF		; past the end of the buffer: wrap
	bne .rtl
	lda.b a4+2
	cmp.w #ReplayBufferEnd>>16
	bne .rtl
	lda.w #ReplayBufferStart&$FFFF
	sta.b a4
	lda.w #ReplayBufferStart>>16
	sta.b a4+2
.rtl:
	rtl
setlccords:		;set printx/y to cords for lc box on team a2 (93G logic93_1)
		;   SNES: printx/printy for the line change box of team a2 (21 rows lower for the home team, flipped by gmdir); d0/d1 = Framer box size
	stz.b d0
	lda.b a2
	bne .pr
	inc.b d0
.pr:
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$13,$01
	lda.w gmode		; gmdir flips it
	bit.w #gmdir
	beq .noflip
	lda.b d0
	eor.w #$0001
	sta.b d0
.noflip:
	lda.w #$0015		; printy += 21 * d0
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l mulu16		; bank $8D: mulu, A = mula*mulb
	adc.w printy
	sta.w printy
	lda.w #$0002		; getlchoice 2: no third choice: 2 rows
	sta.b d0
	jsl.l getlchoice		; bank $8A: 93G getlchoice (d0 = possible line, -1 = none)
	lda.w #$0006
	sta.b d1
	lda.b d0
	bpl .ex
	dec.b d1
	inc.w printy
.ex:
	lda.w #$000C
	sta.b d0
	rtl
startpause:		;93G startpause (hockey93_01): set sfpz (startpause1 and startpause2 jump here)
	lda.w #sfpz
	tsb.w sflags
	rtl
ReadPads:		;SNES: once per frame (padvcount) read the 4 auto-read pads into joypad1-4, padnew1-4 = new presses, padlast1-4 = buttons
	lda.b vcount		; once per frame
	cmp.w padvcount
	beq .new
	sta.w padvcount
	lda.w #$0001
.wait:		;auto-joypad read busy
	bit.w HVBJOY
	bne .wait
	lda.w JOY1L
	sta.w joypad1
	lda.w JOY2L
	sta.w joypad2
	lda.w JOY3L
	sta.w joypad3
	lda.w JOY4L
	sta.w joypad4
.new:
	lda.w joypad1		; new presses = changed and down
	eor.w padlast1
	and.w joypad1
	sta.w padnew1
	lda.w joypad2
	eor.w padlast1+2
	and.w joypad2
	sta.w padnew1+2
	lda.w joypad3
	eor.w padlast1+4
	and.w joypad3
	sta.w padnew1+4
	lda.w joypad4
	eor.w padlast1+6
	and.w joypad4
	sta.w padnew1+6
	lda.w joypad1
	sta.w padlast1
	lda.w joypad2
	sta.w padlast1+2
	lda.w joypad3
	sta.w padlast1+4
	lda.w joypad4
	sta.w padlast1+6
	rtl
asspuckc:		;asstab $10. player a3 is puck handler (93G logic93_3)
		;   SNES: player X is the puck carrier: every aioff frames checkob, chk4lc, chk4shot, chk4pass; skate to a postab spot (bank $8F) with
		;   .chkdir
	txa		; not the carrier: assexit
	lsr a
	cmp.w puckc
	beq .nl
	jmp.w assexit
.nl:
	lda.w pfalock,x		; anim locked
	beq .clk
	jmp.w .rtl
.clk:
	lda.w gmclock		; clock stopped: assnothing
	beq .go
	jml.l assnothing		; bank $8F: 93G assnothing
.go:
	lda.w pflags,x		; joystick controlled: assexit
	bit.w #pfjoycon
	beq .na
	jmp.w assexit
.na:
	bit.w #pfna		; new assignment: temp1 = 0, temp2b = 8, temp3 = random 0-3
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
	lda.w seed
	and.w #$0003
	sta.w temp3,x
.nna:
	lda.w temp1,x		; every aioff frames: checkob, chk4lc, chk4shot, chk4pass
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .nodec
	adc.w aioff,x
	bpl .set
	lda.w #$0000
.set:
	sta.w temp1,x
	jsl.l checkob
	jsl.l chk4lc
	jsl.l chk4shot
	jsl.l chk4pass		; bank $8C: 93G chk4pass
.nodec:		;IDA asspuckc_onside: d0 = 6 + temp3 (random spot), or position when offsides
	lda.w #$0006
	clc
	adc.w temp3,x
	sta.b d0
	lda.w #PuckcSpots
	sta.b a0
	lda.w #PuckcSpots>>16
	sta.b a0+2
	lda.w sflags		; sf2offsig: spot by position
	bit.w #sf2offsig
	beq .nd1
	lda.w position,x
	sta.b d0
.nd1:
	lda.b d0		; d0/d1 = spot x/y, negated for pfgoal clear
	asl a
	asl a
	tay
	lda.b [a0],y
	sta.b d0
	iny
	iny
	lda.b [a0],y
	sta.b d1
	lda.w pfgoal,x
	bne .nd0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.nd0:
	lda.w #.chkdir		; skateto with the .chkdir callback
	sta.b a0
	lda.w #.chkdir>>16
	sta.b a0+2
	jml.l skateto		; bank $88: 93G skateto (d0/d1 = target, a0 = callback)
.rtl:
	rtl
.chkdir:		;IDA asspuckc_chkdir: skateto callback. d0 = direction; turn away from an opponent within 20 of where the puck will be (threat = count)
	lda.b d0
	and.w #$00FF
	bit.w #$0080
	beq .cd
	ora.w #$FF00
.cd:
	sta.b d0		; d2/d3 = puck + velocity
	lda.w Xvel+1,x
	and.w #$00FF
	bit.w #$0080
	beq .x2
	ora.w #$FF00
.x2:
	clc
	adc.w puckx
	sta.b d2
	lda.w Yvel+1,x
	and.w #$00FF
	bit.w #$0080
	beq .y2
	ora.w #$FF00
.y2:
	clc
	adc.w pucky
	sta.b d3
	stz.w threat
	lda.w #$0005
	sta.b d4
	stz.b a0		; the 6 opponents
	cpx.w #$000C
	bcs .cd0
	lda.w #$000C
	sta.b a0
.cd0:
	ldy.b a0
	lda.w Xvel+1,y
	and.w #$00FF
	bit.w #$0080
	beq .cx
	ora.w #$FF00
.cx:
	clc
	adc.w Xpos,y
	sec
	sbc.b d2
	bit.w #$8000
	beq .ax
	eor.w #$FFFF
	inc a
.ax:
	cmp.w #$0015
	bcs .next
	lda.w Yvel+1,y
	and.w #$00FF
	bit.w #$0080
	beq .cy
	ora.w #$FF00
.cy:
	clc
	adc.w Ypos,y
	sec
	sbc.b d3
	bit.w #$8000
	beq .ay
	eor.w #$FFFF
	inc a
.ay:
	cmp.w #$0015
	bcs .next
	inc.w threat		; threat +1; facing straight at it: turn one step either way
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	sta.b d1
	jsl.l vtoa
	lda.w facedir,x
	eor.w #$0004
	cmp.b d0
	bne .next
	lda.w seed+2
	and.w #$0001
	clc
	adc.b d0
	and.w #$0007
	sta.b d0
.next:
	inc.b a0
	inc.b a0
	dec.b d4
	bmi .rtl2
	jmp.w .cd0
.rtl2:
	rtl
DecodePW:		;translate char password in PassWord to variables used in game (92G hockey)
		;   SNES: translate the password in PassWord to game variables: PWtoBits, then ReadPassBits ($8B817A)
	jsl.l PWtoBits
	jml.l ReadPassBits		; bank $8B
PlayoffScreenOpening4:		;SNES: PlayoffScreen, then on to Opening4 (92G: the playoff tree, then the next game)
	jsl.l PlayoffScreen		; bank $88: 93G PlayoffScreen (font tile bases, the playoff tree)
	jml.l Opening4		; bank $8B
SuperDiv:		;5 words at a3 divided by 1 word (d0). 92 SuperDiv. (93G hockey93_09)
		;   SNES: passbits (128 bits) / d0: quotient in passbits, remainder in d0. Shift-subtract over 128 bits with the divisor in mula+0..+16 and the remainder in
		;   mulres+0..+14
	phx		; remainder = passbits, divisor = d0 << 128
	ldx.w #$000E
.init:
	lda.w passbits,x
	sta.b mulres,x
	stz.b mula,x
	dex
	dex
	bpl .init
	lda.b d0
	sta.b mula+16
	ldx.w #$0080
.loop:
	lsr.b mula+16
	ror.b mula+14
	ror.b mula+12
	ror.b mula+10
	ror.b mula+8
	ror.b mula+6
	ror.b mula+4
	ror.b mula+2
	ror.b mula
	asl.w passbits		; shift the dividend left
	rol.w passbits+2
	rol.w passbits+4
	rol.w passbits+6
	rol.w passbits+8
	rol.w passbits+10
	rol.w passbits+12
	rol.w passbits+14
	lda.b mulres		; remainder >= divisor: subtract, quotient bit 1
	cmp.b mula
	lda.b mulres+2
	sbc.b mula+2
	lda.b mulres+4
	sbc.b mula+4
	lda.b mulres+6
	sbc.b mula+6
	lda.b mulres+8
	sbc.b mula+8
	lda.b mulres+10
	sbc.b mula+10
	lda.b mulres+12
	sbc.b mula+12
	lda.b mulres+14
	sbc.b mula+14
	lda.w #$0000
	sbc.b mula+16
	bcc .next
	lda.b mulres
	sbc.b mula
	sta.b mulres
	lda.b mulres+2
	sbc.b mula+2
	sta.b mulres+2
	lda.b mulres+4
	sbc.b mula+4
	sta.b mulres+4
	lda.b mulres+6
	sbc.b mula+6
	sta.b mulres+6
	lda.b mulres+8
	sbc.b mula+8
	sta.b mulres+8
	lda.b mulres+10
	sbc.b mula+10
	sta.b mulres+10
	lda.b mulres+12
	sbc.b mula+12
	sta.b mulres+12
	lda.b mulres+14
	sbc.b mula+14
	sta.b mulres+14
	inc.w passbits
.next:
	dex
	beq .done
	jmp.w .loop
.done:
	plx
	lda.b mulres
	sta.b d0
	clc
	rtl
randomd0s:		;IDA: sub_D7B2 (Rev A lst). d0 = range. Return d0 = random number (-range < d0 < range) (93G middle93_1)
		;   SNES: A = random -A..A (randoma of 2A, minus A)
	sta.b tmp0
	asl a
	jsl.l randoma
	sec
	sbc.b tmp0
	clc
	rtl
assgoalie:		;asstab $E. Player a3 is goalie. Also entered from assnearest (93G logic93_3)
		;   SNES: goalie X. Skate back to the crease, hold/pass the puck, cover a loose puck, follow the puck and lead it, saves
		;   (GoalieSaveList), hug the post, rush a loose puck (agoalietopuck)
	lda.w pfalock,x		; anim locked: nothing
	beq .go
	jmp.w .rtl
.go:
	jsl.l check4bench
	lda.w pflags,x		; new assignment: temp1/temp2 = 0, temp2b = 8, temp4 = -1
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
	lda.w #$FFFF
	sta.w temp4,x
.nna:
	lda.w Xpos,x		; outside the crease area: skate back
	bit.w #$8000
	beq .ax
	eor.w #$FFFF
	inc a
.ax:
	cmp.w #$0035
	bcs .skate
	lda.w Ypos,x
	bit.w #$8000
	beq .ay
	eor.w #$FFFF
	inc a
.ay:
	cmp.w #$010F
	bcs .skate
	cmp.w #$00D3
	bcs .noskate
.skate:		;skate back to the net (callback rtss)
	lda.w #rtss
	sta.b a0
	lda.w #rtss>>16
	sta.b a0+2
	lda.w #$0004
	sta.b d0
	lda.w Xpos,x
	bpl .zero
	lda.w #$FFFC
	sta.b d0
.zero:
	lda.w #$00E4
	sta.b d1
	lda.w pfgoal,x
	beq .sk
	lda.w #$FF1C
	sta.b d1
.sk:
	jml.l skateto		; bank $88: 93G skateto (d0/d1 = target, a0 = callback)
.noskate:
	lda.w pf2aip,x		; pf2aip: nothing
	beq .gready
	jmp.w .rtl
.gready:
	lda.w #SPAgready
	sta.b d1
	jsl.l SetSPA
	lda.w gmclock		; clock stopped: nothing
	beq .clk
	jmp.w .rtl
.clk:
	lda.w temp5,x		; temp5 = holding time
	bmi .nofo
	lda.w SCnum,x
	sta.b d0
	cmp.w puckc
	beq .mbfo
	lda.w #$FFFF
	sta.w temp5,x
	bra .nofo
.mbfo:		;holding the puck: PenGhold when temp5 runs out
	lda.w temp5,x
	sec
	sbc.b d7
	sta.w temp5,x
	bpl .nofo
	lda.w #PenGhold
	sta.b d0
	jsl.l AddPenalty2
.nofo:
	lda.w temp1,x		; every aidef/4 frames
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .dec
	jmp.w .nodec
.dec:
	lda.w aidef,x
	lsr a
	lsr a
	clc
	adc.w temp1,x
	bpl .st1
	lda.w #$0000
.st1:
	sta.w temp1,x
	lda.w pflags,x		; joystick goalie: only .cover
	bit.w #pfjoycon
	beq .half
	jmp.w .cover
.half:
	lda.w pucky		; puck in the other half: stay at the top of the crease (y +-$F4)
	sta.b d0
	lda.w Ypos,x
	eor.b d0
	sta.b d1
	bpl .cnt
	stz.b d0
	lda.w #$00F4
	sta.b d2
	lda.w pfgoal,x
	bne .other
	jmp.w .de5
.other:
	lda.w #$FF0C
	sta.b d2
	jmp.w .de5
.cnt:		;puck in my half
	dec.w temp4,x
	bpl .pc
	lda.w #$FFFF
	sta.w temp4,x
.pc:
	lda.w SCnum,x
	cmp.w puckc
	beq .hold0
	jmp.w .cover
.hold0:
	lda.w temp5,x		; 90 frames before the holding penalty
	bpl .hold
	lda.w #$005A
	sta.w temp5,x
.hold:
	lda.w #$FFFF
	sta.w temp4,x
	lda.w temp5,x
	sec
	sbc.w #$005A
	beq .roll
	bmi .v1
	bvs .roll
.de1j:
	jmp.w .de1
.v1:
	bvs .de1j
.roll:
	lda.w #$0064		; 1 in 4: pass
	jsl.l randoma
	cmp.w #$004B
	bcs .pass
	jmp.w .de1
.pass:
	lda.w #$0005
	sta.b d0
	stz.b a0
	lda.w pfteam,x
	bne .tl
	lda.w #$000C
	sta.b a0
.tl:		;pass only if no opponent is near the puck
	ldy.b a0
	lda.w pflags,y
	bit.w #pf2unav
	bne .tn
	lda.w pucky
	sec
	sbc.w Ypos,y
	bit.w #$8000
	beq .tly
	eor.w #$FFFF
	inc a
.tly:
	cmp.w #$001D
	bcs .tn
	lda.w puckx
	sec
	sbc.w Xpos,y
	bit.w #$8000
	beq .tlx
	eor.w #$FFFF
	inc a
.tlx:
	cmp.w #$001A
	bcs .tn
	jmp.w .de1
.tn:
	inc.b a0
	inc.b a0
	dec.b d0
	bpl .tl
	lda.w #$0001		; threat = 1, chk4pass
	sta.w threat
	jsl.l chk4pass		; bank $8C: 93G chk4pass
	bra .de1
.cover:		;cover a loose puck at the crease
	lda.w temp4,x
	bne .de1
	lda.w puckc
	bpl .de1
	lda.w puckx
	sec
	sbc.w Xpos,x
	sta.b d0
	bit.w #$8000
	beq .cvx
	eor.w #$FFFF
	inc a
.cvx:
	cmp.w #$0015
	bcs .de1
	lda.w pucky
	sta.b d1
	bit.w #$8000
	beq .cvy
	eor.w #$FFFF
	inc a
.cvy:
	cmp.w #$0109
	bcs .de1
	lda.b d1
	sec
	sbc.w Ypos,x
	sta.b d1
	bit.w #$8000
	beq .cvd
	eor.w #$FFFF
	inc a
.cvd:
	cmp.w #$001F
	bcs .de1
	jsl.l vtoa
	lda.b d0
	sta.w facedir,x		; facedir to the puck, nopuck 8, cover anim, pf2aip, crowd +150
	lda.w #$0008
	sta.w nopuck,x
	lda.w #SPAgdive
	sta.b d1
	jsl.l SetSPA
	lda.w #$0096
	sta.w pf2aip,x
	clc
	adc.b crowdlevel
	sta.b crowdlevel
.rtl:
	rtl
.de1:		;a0 = puckcross entry of my goal, d3 = goal line
	lda.w #puckcross
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	lda.w #$0104
	sta.b d3
	lda.w pfgoal,x
	beq .de2
	lda.w #puckcross+4
	sta.b a0
	lda.w #$FEFC
	sta.b d3
.de2:
	lda.w Ypos,x		; out of the crease in y: behind the goal line
	bit.w #$8000
	beq .de2y
	eor.w #$FFFF
	inc a
.de2y:
	cmp.w #$0105
	bcs .out
	lda.w puckx		; face the puck: ClampYPosition, vtoa, AdjustFacingDirection
	sta.b d0
	lda.w pucky
	sta.b d1
	jsl.l ClampYPosition
	lda.b d1
	bit.w #$8000
	beq .near
	eor.w #$FFFF
	inc a
.near:
	cmp.w #$002E
	bcs .in
	lda.b d1
	pha
	lda.b d0
	pha
	jsl.l vtoa
	jsl.l AdjustFacingDirection
	lda.b $01,s
	sta.b d0
	lda.b $03,s
	sta.b d1
	jmp.w .sq
.out:		;behind the goal line
	stz.b d2
	stz.b d0
	lda.w Xpos,x
	bit.w #$8000
	beq .outx
	eor.w #$FFFF
	inc a
.outx:
	cmp.w #$002D
	bcc .out2
	jmp.w .de5
.out2:
	lda.w #$0088
	sta.b d0
	lda.w Xpos,x
	bmi .outn
	jmp.w .de5
.outn:
	lda.w #$FF78
	sta.b d0
	jmp.w .de5
.in:		;face the puck, lead it by its velocity
	jsl.l vtoa
	jsl.l AdjustFacingDirection
	lda.w puckvy		; lead the puck by its velocity (/2 near the ends)
	xba
	lsr a
	and.w #$007F
	bit.w #$0040
	beq .iy
	ora.w #$FF80
.iy:
	clc
	adc.w pucky
	sta.b d1
	lda.w puckvx
	xba
	and.w #$00FF
	bit.w #$0080
	beq .ix
	ora.w #$FF00
.ix:
	sta.b d0
	lda.b d1
	sec
	sbc.w #$00E0
	beq .lo
	bmi .v2
	bvs .lo
	bra .lead2
.v2:
	bvs .lead2
.lo:
	lda.b d1
	sec
	sbc.w #$FF20
	beq .lead2
	bmi .v3
	bvs .lead2
	bra .lead
.v3:
	bvs .lead
.lead2:
	lda.b d0
	pha
	asl a
	pla
	ror a
	sta.b d0
.lead:
	lda.b d0
	clc
	adc.w puckx
	sta.b d0
	jsl.l ClampYPosition
	lda.b d1
	pha
	lda.b d0
	pha
.sq:
	lda.b d0
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d1
	lda.b mulres+2
	sta.b d1+2
	lda.b d0
	adc.b d1
	sta.b d0
	lda.b d0+2
	adc.b d1+2
	sta.b d0+2
	lda.b d0		; distance^2 < 30*30: stay
	cmp.w #$0385
	lda.b d0+2
	sbc.w #$0000
	bcs .far
	pla
	sta.b d0
	pla
	sta.b d1
	bra .de4
.far:		;scale to a 20 (28 if shooting) pixel arc
	jsl.l sroot
	lda.b d0
	inc a
	sta.b d2
	lda.w #$0014
	sta.b d4
	lda.w sflags
	bit.w #sfssdir
	beq .f0
	lda.w #$001C
	sta.b d4
.f0:
	pla
	sta.b d0
	pla
	sta.b d1
	sta.b mulb
	lda.b d4
	sta.b mula
	jsl.l muls32
	lda.b d2
	sta.b mula
	jsl.l divs
	sta.b d1
	lda.b d4
	adc.w #$0006
	sta.b d4
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l muls32
	lda.b d2
	sta.b mula
	jsl.l divs
	sta.b d0
.de4:
	lda.b d1
	clc
	adc.b d3
	sta.b d1
	sta.b d2
	ldy.w #$0002		; puckcross frames til crossing < $14?
	lda.b [a0],y
	cmp.w #$0014
	bcc .cross
	jmp.w .de5
.cross:		;puck crossing the goal line soon?
	lda.b [a0]
	bit.w #$8000
	beq .cx
	eor.w #$FFFF
	inc a
.cx:
	cmp.w #$0019
	bcc .cz
	jmp.w .rush
.cz:
	lda.b [a0],y
	cmp.w #$000C
	bcc .cy
	jmp.w .de8
.cy:
	lda.w pucky
	bit.w #$8000
	beq .cy2
	eor.w #$FFFF
	inc a
.cy2:
	cmp.w #$0109
	bcc .aip
	jmp.w .de8
.aip:
	lda.w pf2aip,x
	beq .save
	jmp.w .de8
.save:		;pick the save anim: glove side by the direction, stick when low and slow, stack
	inc.w pf2aip,x
	lda.b [a0]
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.b d3
	sec
	sbc.w Ypos,x
	sta.b d1
	jsl.l vtoa
	lda.b d0
	sec
	sbc.w facedir,x
	and.w #$0007
	sta.b d3
	lsr a
	lsr a
	sta.b d0
	lda.w attribute,x
	bit.w #$0800
	beq .noflip
	lda.b d0
	eor.w #$0001
	sta.b d0
.noflip:
	lda.w Zpos+puckobj		; puck low (Zpos <= 8) and slow: stick (+4)
	sec
	sbc.w #$0008
	beq .pz
	bmi .v4
	bvs .pz
	bra .de7
.v4:
	bvs .de7
.pz:
	lda.w puckvz
	sec
	sbc.w #$0800
	beq .stick
	bmi .v5
	bvs .stick
	bra .de7
.v5:
	bvs .de7
.stick:
	lda.b d0
	clc
	adc.w #$0004
	sta.b d0
	ldy.w #$0002		; more than 8 frames, facing up/down, puck carried: stack (-2)
	lda.b [a0],y
	cmp.w #$0009
	bcc .de7
	lda.w facedir,x
	cmp.w #$0002
	beq .de7
	cmp.w #$0006
	beq .de7
	lda.w puckc
	bmi .de7
	dec.b d0
	dec.b d0
.de7:
	asl.b d0
	lda.w #GoalieSaveList
	sta.b a1
	lda.w #GoalieSaveList>>16
	sta.b a1+2
	ldy.b d0
	lda.b [a1],y
	sta.b d1
	jsl.l SetSPA
	lda.b crowdlevel		; crowd +150
	clc
	adc.w #$0096
	sta.b crowdlevel
.de8:
	lda.b [a0]
	sta.b d0
	lda.w pucky		; puck near the goal line: hug the post (+-$18)
	sec
	sbc.w #$00FC
	beq .p2
	bmi .v6
	bvs .p2
	bra .post
.v6:
	bvs .post
.p2:
	lda.w pucky
	sec
	sbc.w #$FF04
	beq .post
	bmi .v7
	bvs .post
	bra .de5
.v7:
	bvs .de5
.post:		;hug the post
	lda.w #$0018
	sta.b d0
	lda.w puckx
	bpl .de5
	lda.w #$FFE8
	sta.b d0
.de5:		;skate toward d0/d2 minus the velocity
	lda.b d2
	sta.b d1
	pha
	lda.b d0
	pha
	lda.w Xvel,x
	xba
	and.w #$00FF
	bit.w #$0080
	beq .vx
	ora.w #$FF00
.vx:
	eor.w #$FFFF
	inc a
	sta.b d0
	pla
	clc
	adc.b d0
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w Yvel,x
	xba
	and.w #$00FF
	bit.w #$0080
	beq .vy
	ora.w #$FF00
.vy:
	eor.w #$FFFF
	inc a
	sta.b d1
	pla
	clc
	adc.b d1
	sec
	sbc.w Ypos,x
	sta.b d1
	lda.w #$0005		; within 5 (10 with the puck): stop
	sta.b tmp0
	txa
	lsr a
	cmp.w puckc
	bne .near2
	asl.b tmp0
.near2:
	lda.b d0
	bit.w #$8000
	beq .nx
	eor.w #$FFFF
	inc a
.nx:
	cmp.b tmp0
	bcs .vt
	lda.b d1
	bit.w #$8000
	beq .ny
	eor.w #$FFFF
	inc a
.ny:
	cmp.b tmp0
	bcs .vt
	stz.b d0
	stz.b d1
.vt:
	jsl.l vtoa
	lda.b d0
	sta.w temp2b,x
.nodec:
	lda.w temp2b,x		; direction > 7: StopNA, else playeracc
	sta.b d2
	sec
	sbc.w #$0007
	beq .acc
	bmi .v8
	bvc .stop
.acc:
	jml.l playeracc		; bank $8F: 93G playeracc
.v8:
	bvc .acc
.stop:
	jmp.w StopNA
.rush:		;rush a loose puck when the tmnear stats say so
	lda.w puckc
	bmi .r1
	jmp.w .de5
.r1:
	lda.w iflags		; icing possible: no rush
	bit.w #ifok
	beq .r2
	jmp.w .de5
.r2:
	stz.b a1
	lda.w #$0002
	sta.b a2
	lda.w pfteam,x
	beq .t0
	stz.b a2
	lda.w #$0002
	sta.b a1
.t0:
	ldy.b a1		; tmnear of my team >= $1324 and of the other >= $9C4
	lda.w tmnear,y
	cmp.w #$1324
	lda.w tmnear+4,y
	sbc.w #$0000
	bcs .t1
	jmp.w .de5
.t1:
	ldy.b a2
	lda.w tmnear,y
	cmp.w #$09C4
	lda.w tmnear+4,y
	sbc.w #$0000
	bcs .r3
	jmp.w .de5
.r3:
	lda.w pucky		; puck near my end, moving toward me, mostly in y
	sbc.w #$00E0
	beq .r4
	bmi .v9
	bvs .r4
	bra .dir
.v9:
	bvs .dir
.r4:
	lda.w pucky
	sec
	sbc.w #$FF20
	beq .dir
	bmi .v10
	bvs .dir
.de5j:
	jmp.w .de5
.v10:
	bvs .de5j
.dir:
	lda.w puckvy
	sta.b tmp0
	lda.w pfgoal,x
	beq .dir2
	lda.b tmp0
	eor.w #$FFFF
	inc a
	sta.b tmp0
.dir2:
	lda.b tmp0
	bpl .ax2
	jmp.w .de5
.ax2:
	lda.w puckvx
	bit.w #$8000
	beq .axs
	eor.w #$FFFF
	inc a
.axs:
	sta.b d0
	lda.w puckvy
	bit.w #$8000
	beq .ay2
	eor.w #$FFFF
	inc a
.ay2:
	sta.b d1
	lda.b d1
	cmp.b d0
	bcs .ins
	jmp.w .de5
.ins:
	lda.w #agoalietopuck		; agoalietopuck
	sta.b d0
	jmp.w assinsert
ClampYPosition:		;93G ClampYPosition (logic93_3): d1 = y clamped to +-$103, minus goal line d3. d0 = 0 if X has the puck
	lda.w puckc
	sta.b d2
	cmp.w SCnum,x
	bne .zero
	stz.b d0
.zero:
	lda.b d1
	sec
	sbc.w #$0103
	bmi .v1
	bvc .hi
	bra .one
.v1:
	bvc .one
.hi:
	lda.w #$0103
	sta.b d1
.one:
	lda.b d1
	sec
	sbc.w #$FEFD
	beq .lo
	bmi .v2
	bvs .lo
	bra .two
.v2:
	bvs .two
.lo:
	lda.w #$FEFD
	sta.b d1
.two:
	lda.b d1
	sec
	sbc.b d3
	sta.b d1
	rtl
AdjustFacingDirection:		;Turn facedir one step (93G logic93_3)
		;   SNES: turn facedir of goalie X one step toward d0, not past the sides of the net
	lda.w facedir,x
	sta.b d1
	lda.b d0
	sec
	sbc.b d1
	sta.b d0
	bne .turn
	jmp.w assgoalie_rtl
.turn:
	eor.w #$FFFF
	inc a
	and.w #$0004
	lsr a
	dec a
	sta.b d0
	lda.b d1
	cmp.w #$0001
	beq .add
	cmp.w #$0006
	bne .dn
.add:
	clc
	adc.b d0
	sta.b d1
	lda.w pfgoal,x
	bne .other
	lda.b d1
	cmp.w #$0002
	bcc .neg
	cmp.w #$0007
	beq .neg
	bra .set
.other:
	lda.b d1
	cmp.w #$0003
	bcc .set
	cmp.w #$0006
	bcs .set
.neg:
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	clc
	adc.b d1
	sta.b d1
.dn:
	lda.b d1
	clc
	adc.b d0
	sta.b d1
.set:
	lda.b d1
	and.w #$0007
	sta.b d1
	sta.w facedir,x
	rtl
GoalieSaveList:		;93G GoalieSaveList (logic93_3): save anims by index: glove 0/1, stack 2/3, stick 4/5
	dw SPAgglover,SPAgglovel,SPAgstackr,SPAgstackl,SPAgstickr,SPAgstickl
checkgoalp_CalcGoalShotDir:		;IDA name kept: 92 checkgoalp is the goal/net collision in hockey93_04. 93 only. If the opposing goalie (93G logic93_1)
		;   SNES: if the opposing goalie covers the middle of the net, passdir 2 or 6 to shoot at the open side, else 0.
		;   Skipped for joystick players
	lda.w pflags,x		; joystick player: skip
	bit.w #pfjoycon
	beq .go
	jmp.w .rtl
.go:
	lda.w #$0008
	sta.b d0
	lda.w #$0005
	sta.b d1
	lda.w #$FFFE
	sta.b a0
	lda.w pfteam,x
	bne .g
	lda.w #$000A
	sta.b a0
.g:		;IDA CheckOpponentGoalie: find position 0 on the other team
	inc.b a0
	inc.b a0
	ldy.b a0
	lda.w position,y
	beq .found
	dec.b d1
	bpl .g
	jmp.w .x
.found:		;goalie x/y + half his velocity - puck; d2 = distance
	lda.w Xvel+1,y
	and.w #$00FF
	bit.w #$0080
	beq .gx
	ora.w #$FF00
.gx:
	pha
	asl a
	pla
	ror a
	clc
	adc.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	lda.w Yvel+1,y
	and.w #$00FF
	bit.w #$0080
	beq .gy
	ora.w #$FF00
.gy:
	pha
	asl a
	pla
	ror a
	clc
	adc.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	pha
	lda.b d0
	pha
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sec
	adc.b d0
	sta.b d0
	lda.b mulres+2
	adc.b d0+2
	sta.b d0+2
	jsl.l sroot
	lda.b d0
	sta.b d2
	pla
	sta.b d0
	pla
	sta.b d1
	lda.w #$0012		; d3/d4 = post x/goal y
	sta.b d3
	lda.w #$0108
	sta.b d4
	lda.w pfgoal,x
	bne .l
	lda.w #$FEF8
	sta.b d4
.l:		;IDA CalcLeftAngle: posts at x +-18, y +-$108
	lda.b d4
	pha
	lda.b d3
	pha
	jsl.l CalcAngleOffset
	lda.b d4
	sta.b d5
	pla
	eor.w #$FFFF
	inc a
	sta.b d3
	pla
	sta.b d4
	jsl.l CalcAngleOffset
	lda.b d4
	clc
	adc.b d5
	sta.b d4
	stz.b d0
	lda.b d4
	bit.w #$8000
	beq .abs
	eor.w #$FFFF
	inc a
.abs:
	cmp.w #$002D		; |angle| < 45: shoot at the open side
	bcs .x
	lda.w pfgoal,x
	beq .s
	lda.b d4
	eor.w #$FFFF
	inc a
	sta.b d4
.s:		;IDA SetShotDirection
	lda.w #$0002
	sta.b d0
	lda.b d4
	bpl .x
	lda.w #$0006
	sta.b d0
.x:		;IDA ReturnDefaultDir
	lda.b d0
	sta.w passdir
.rtl:
	rtl
CalcAngleOffset:		;d4 = cross product of goalie vector d0/d1 and post vector (93G logic93_1)
		;   SNES: d4 = (goalie vector d0/d1 x post vector d3/d4 from the puck) / d2
	lda.b d3
	sec
	sbc.w puckx
	sta.b d3
	lda.b d4
	sec
	sbc.w pucky
	sta.b mulb
	lda.b d0
	sta.b mula
	jsl.l muls32
	sta.b d4
	lda.b mulres+2
	sta.b d4+2
	lda.b d1
	sta.b mula
	lda.b d3
	sta.b mulb
	jsl.l muls32
	sta.b d3
	lda.b mulres+2
	sta.b d3+2
	lda.b d4
	sec
	sbc.b d3
	sta.b mulb
	lda.b d4+2
	sbc.b d3+2
	sta.b mulb+2
	lda.b d2
	sta.b mula
	jsl.l divs
	sta.b d4
	rtl
reenergizeteam:		;set all players to max energy on team a2. 93 also moves players marked -3 in tmpdst to the bench (-2). Called from SetupTeamForIntermission and StartHL2 .setteam (93G
		;   penalty93_2)
		;   SNES: max energy for every player of team a2; TMPDOUT players go to the bench
	lda.w #$0032
	sta.b d0
.top:
	lda.b a2
	beq .tm
	lda.w #$0034
.tm:
	clc
	adc.b d0
	tay
	lda.w #$1000		; max energy
	sta.w tmpde,y
	lda.w tmpdst,y		; out: back to the bench
	cmp.w #TMPDOUT
	bne .nb
	lda.w #TMPDBENCH
	sta.w tmpdst,y
.nb:
	dec.b d0
	dec.b d0
	bpl .top
	rtl
unusedFF:		;unused, $FF fill up to the internal header
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF
	db "NHLPA Hockey '93     "		; title (21 bytes)
	db $30		; map mode: LoROM, FastROM
	db $00		; cartridge type: ROM only
	db $09		; ROM size: 512 KB
	db $00		; SRAM size: none
	db $01		; country: USA
	db $69		; licensee: Electronic Arts
	db $00		; version
	dw $B75A		; checksum complement
	dw $48A5		; checksum
	db $FF,$FF,$FF,$FF		; native mode vectors:
	dw VBjsr&$FFFF		; COP
	dw BRKHalt&$FFFF		; BRK
	dw VBjsr&$FFFF		; ABORT
	dw VBjsr&$FFFF		; NMI
	dw Start&$FFFF		; (unused)
	dw HBjsr&$FFFF		; IRQ
	db $FF,$FF,$FF,$FF		; emulation mode vectors:
	dw VBjsr&$FFFF		; COP
	dw VBjsr&$FFFF		; (unused)
	dw VBjsr&$FFFF		; ABORT
	dw VBjsr&$FFFF		; NMI
	dw Start&$FFFF		; RESET
	dw HBjsr&$FFFF		; IRQ/BRK
