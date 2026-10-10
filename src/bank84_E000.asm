; $84E949-$84EF3B  ROM $26949-$26F3B: FaceOffMap, then the SNES scouting report extras: PutDigits2, the two showcased
; players who skate in with their number and name (ScoutPlayersRun: one per team, picked from the line sets in ScoutLineOrder,
; animated with the ScoutScripts chosen from their ratings), and the roster helpers. The team stat words are scratch during the
; scouting report: tmshots = team shown, tmPwrGoals = ScoutLineOrder index, tmPwrPlays = roster player, tmPenalties = line slot,
; tmPenmin = script, tmATOP = script step. Starts after ScoutingReportText (boundary moved), ends before HotList.
org $84E949
FaceOffMap:		;93G FaceOffMap (92G FaceOffMap): the 12 x 10 faceoff box map (tiles from FaceOffTiles, attribute $20), copied into textmap by puckfaceoff2 ($80A3F4)
	dw $2000,$2001,$2002,$2003,$2004,$2005,$2006,$2007,$2008,$2009,$200A,$200B
	dw $200C,$200D,$200E,$200F,$2010,$2011,$2012,$2013,$2014,$2015,$2016,$2017
	dw $2018,$2019,$201A,$2019,$2019,$2019,$201B,$201C,$2019,$2019,$2019,$201D
	dw $201E,$201F,$2020,$201F,$201F,$201F,$2021,$2022,$601F,$601F,$601F,$2023
	dw $2024,$2025,$2026,$2025,$2025,$2025,$2027,$2028,$2025,$2025,$2025,$2029
	dw $2024,$2025,$2025,$2025,$2025,$2025,$202A,$202B,$202C,$2025,$2025,$2029
	dw $2024,$2025,$2025,$2025,$2025,$2025,$202D,$202E,$202F,$2025,$2025,$2029
	dw $2024,$2025,$2025,$2025,$2025,$2025,$2030,$2031,$2032,$2033,$2025,$2029
	dw $2024,$2025,$2025,$2025,$2025,$2025,$2025,$2025,$2025,$2025,$2025,$2029
	dw $2034,$2035,$2035,$2035,$2035,$2035,$2035,$2035,$2035,$2035,$2035,$2036
PutDigits2:		;auto: CODE_84EA39. SNES: write the 2 digit number d0 (BCD byte, blank leading zero) as 2 characters at [a1], a1 += 2
	lda.w #$2020		; blank, then the tens digit when d0 >= 10
	sta.b tmp0
	lda.b d0
	and.w #$00FF
	cmp.w #$000A
	bcc .lo
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc.w #$0030
	sta.b tmp0
.lo:
	lda.b d0
	and.w #$000F
	clc
	adc.w #$0030
	sta.b tmp0+1
	lda.b tmp0
	sta.b [a1]
	inc.b a1
	inc.b a1
	rtl
ScoutPlayersRun:		;auto: CODE_84EA66. SNES scouting report: one frame of the two showcased players (home a2 = 0, away a2 = 2), then draw them
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .pusha
	ldx.b xsave
	lda.w #$0001		; d7 = 1 frame
	sta.b d7
	stz.b a2
	jsl.l ScoutTeamStep
	lda.w #$0002
	sta.b a2
	jsl.l ScoutTeamStep
	jsl.l DrawScoutPlayers
	stx.b xsave
	ldx.w #$001A
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$001E
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	ldx.b a3
	rtl
ScoutTeamStep:		;auto: CODE_84EABF. SNES: step the showcased player of team a2: a new team (tmteam changed) picks its goalie and restarts the order (ScoutPlayerExit); skating out to the side
		;   (tmflags bit 1) ends at x 40 (ScoutNextPlayer); else the next script step (SPA, facedir) every 9 frames, then print his number and name
	ldy.b a2
	lda.w tmteam,y		; team changed?
	sta.b d0
	cmp.w tmshots,y
	beq .cur
	sta.w tmshots,y
	jsl.l PickStartingGoalie
	ldy.b a2
	lda.w #$0000
	sta.w tmPwrGoals,y
	jsl.l ScoutPlayerExit
.cur:
	ldy.b a2
	lda.w tmsort,y		; X = a3 = first object of the team
	sta.b a3
	tax
	lda.w tmflags,y
	bit.w #$0002
	beq .in
	inc.w OldZpos,x		; skating out: x += 3
	inc.w OldZpos,x
	inc.w OldZpos,x
	inc.w OldXpos,x
	inc.w OldXpos,x
	inc.w OldXpos,x
	lda.w OldXpos,x
	sec
	sbc.w #40
	beq .rtl
	bmi .v1
	bvs .rtl
.next1:
	jmp.w ScoutNextPlayer
.v1:
	bvs .next1
.rtl:
	rtl
.in:		;skating in from the left
	lda.w OldXpos,x		; skating in: x += 1 while negative
	bpl .anim
	inc.w OldZpos,x
	inc.w OldXpos,x
.anim:
	jsl.l updateanim
	lda.w pf2aip,x		; pf2aip: wait for the step delay
	beq .step
	jmp.w ScoutPlayerExit_rtl
.step:		;next script step
	ldy.b a2
	lda.w tmPenmin,y		; a0 = ScoutScripts + offset of the script + step; step += 4
	asl a
	sta.b d0
	tay
	lda.w #ScoutScripts>>16
	sta.b a0+2
	lda.w #ScoutScripts
	sta.b a0
	clc
	adc.b [a0],y
	ldy.b a2
	adc.w tmATOP,y
	sta.b a0
	lda.w tmATOP,y
	adc.w #$0004
	sta.w tmATOP,y
	lda.b [a0]
	sta.b d1
	bne .set
	jmp.w ScoutPlayerExit
.set:
	jsl.l SetSPA		; SetSPA d1, 9 frames per step, facedir
	lda.w #$0009
	sta.w pf2aip,x
	ldy.w #$0002
	lda.b [a0],y
	sta.w facedir,x
	bmi .flip
	jmp.w ScoutPlayerExit_rtl
.flip:		;negative facedir: first step of a new player, print the name
	eor.w #$FFFF
	inc a
	sta.w facedir,x
	ldy.b a2
	lda.w tmPwrPlays,y
	sta.b d0
	jsl.l GetRosterEntry		; mesarea = number and the first name, centered in 11 columns
	jsl.l ScoutNamePos
	lda.w printx
	pha
	lda.w #mesarea+2
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	lda.b [a0]
	tay
	lda.b [a0],y
	and.w #$00FF
	sta.b d0
	lsr a
	lsr a
	lsr a
	lsr a
	beq .lo
	clc
	adc.w #$0030
	sta.b [a1]
	inc.b a1
.lo:
	lda.b d0
	and.w #$000F
	clc
	adc.w #$0030
	sta.b [a1]
	inc.b a1
	lda.w #$0020
	sta.b [a1]
	inc.b a1
	ldy.w #$0001
.first:
	iny
	lda.b [a0],y
	and.w #$00FF
	cmp.w #$0020
	beq .pr1
	sta.b [a1]
	inc.b a1
	bra .first
.pr1:
	lda.b a1
	sec
	sbc.w #mesarea
	sta.w mesarea
	dec a
	dec a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$000B
	lsr a
	clc
	adc.w printx
	sta.w printx
	lda.w #mesarea
	sta.b a1
	jsl.l print
	pla
	sta.w printx
	inc.w printy
	lda.b [a0]		; then the last name on the next line
	sta.b tmp0
	ldy.w #$0001
.skip:
	iny
	lda.b [a0],y
	and.w #$00FF
	cmp.w #$0020
	bne .skip
	lda.w #mesarea+2
	sta.b a1
	lda.w #$0000
	sta.b a1+2
.last:
	iny
	cpy.b tmp0
	beq .pr2
	lda.b [a0],y
	sta.b [a1]
	inc.b a1
	bra .last
.pr2:
	lda.b a1
	sec
	sbc.w #mesarea
	sta.w mesarea
	dec a
	dec a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$000B
	lsr a
	clc
	adc.w printx
	sta.w printx
	lda.w #mesarea
	sta.b a1
	jml.l print
ScoutPlayerExit:		;auto: CODE_84EC4C. SNES: the showcased player of team a2 skates off ($89FCC1, tmflags bit 1)
	jsl.l EraseScoutName		; bank $89
	ldy.b a2
	lda.w tmflags,y
	ora.w #$0002
	sta.w tmflags,y
.rtl:
	rtl
ScoutNextPlayer:		;auto: CODE_84EC5C. SNES: the next showcased player of team a2 from ScoutLineOrder (goalie: tmgoalie): start at x -40, pick his ScoutScripts entry from his ratings
	jsl.l SetTeamColors		; SprSort
	ldy.b a2
	lda.w tmflags,y
	and.w #$FFFD
	sta.w tmflags,y
	lda.w tmsort,y
	sta.b a3
	tax
	lda.w #-40
	sta.w OldXpos,x
	stz.w SPA,x
.order:
	ldy.b a2
	lda.w tmPwrGoals,y
	sta.b d0
	tay
	lda.w #ScoutLineOrder		; ScoutLineOrder[tmPwrGoals]: $FF restarts the list
	sta.b a0
	lda.w #ScoutLineOrder>>16
	sta.b a0+2
	lda.b [a0],y
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	beq .got
	ldy.b a2
	lda.w #$0000
	sta.w tmPwrGoals,y
	bra .order
.got:
	ldy.b a2
	lda.b d0
	sta.w tmPenalties,y
	lda.w tmPwrGoals,y
	inc a
	sta.w tmPwrGoals,y
	lda.w #TeamList>>16
	sta.b a0+2
	lda.w tmdata,y		; roster player = LineSets byte - 1 (goalie slot: tmgoalie)
	sta.b a0
	clc
	ldy.w #LineSets
	adc.b [a0],y
	sta.b a0
	ldy.b d0
	lda.b [a0],y
	and.w #$00FF
	dec a
	sta.b d0
	ldy.b a2
	lda.w tmPenalties,y
	bne .pl
	lda.w tmgoalie,y
	sta.b d0
.pl:
	lda.b d0
	ldy.b a2
	sta.w tmPwrPlays,y
	jsl.l GetRosterEntry
	lda.b a0
	clc
	adc.b [a0]
	sta.b a0
	lda.w attribute,x		; handedness bit: flip
	and.w #$F7FF
	sta.w attribute,x
	ldy.w #Playerdata+4
	lda.b [a0],y
	lsr a
	bcs .rate
	lda.w attribute,x
	ora.w #$0800
	sta.w attribute,x
.rate:		;ScoutPickScript for each of the 14 rating nibbles (ScoutScriptPick, goalies ScoutScriptPickG)
	inc.b a0
	lda.w #$0006
	sta.b d0
	stz.b d2
	lda.w #ScoutScriptPick
	sta.b a1
	lda.w #ScoutScriptPick>>16
	sta.b a1+2
	ldy.b a2
	lda.w tmPenalties,y
	and.w #$0007
	sta.b d3
	bne .nib
	lda.w #ScoutScriptPickG
	sta.b a1
.nib:
	lda.b [a0]
	and.w #$00FF
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d1
	jsl.l ScoutPickScript
	lda.b [a0]
	inc.b a0
	and.w #$000F
	sta.b d1
	jsl.l ScoutPickScript
	dec.b d0
	bpl .nib
	ldy.b a2
	lda.w #$0000
	sta.w tmATOP,y
	rtl
ScoutPickScript:		;auto: CODE_84ED51. SNES: rating nibble d1 against the next (minimum, script) pair at [a1]: the highest qualifying rating picks tmPenmin
	lda.b [a1]
	and.w #$00FF
	sta.b tmp0
	inc.b a1
	lda.b [a1]
	and.w #$00FF
	sta.b tmp1
	inc.b a1
	lda.b d1
	sec
	sbc.b tmp0
	bmi .v1
	bvc .best
.ex1:
	jmp.w ScoutPlayerExit_rtl
.v1:
	bvc .ex1
.best:
	lda.b d1
	sec
	sbc.b d2
	bmi .v2
	bvc .z
.ex2:
	jmp.w ScoutPlayerExit_rtl
.v2:
	bvc .ex2
.z:
	lda.b d2
	beq .take
	lda.b tmp0
	bne .take
	jmp.w ScoutPlayerExit_rtl
.take:
	lda.b d1
	sta.b d2
	ldy.b a2
	lda.b tmp1
	sta.w tmPenmin,y
	rtl
GetRosterEntry:		;auto: CODE_84ED96. SNES: a0 = Playerdata entry of roster player d0 of team a2 (walks the Player list)
	lda.w #TeamList>>16
	sta.b a0+2
	ldy.b a2
	lda.w tmdata,y
	sta.b a0
	clc
	ldy.w #Playerdata
	adc.b [a0],y
	sta.b a0
	bra .cnt
.next:
	lda.b a0
	clc
	adc.b [a0]
	adc.w #$0008
	sta.b a0
.cnt:
	dec.b d0
	bpl .next
	rtl
ScoutScriptPick:		;SNES: (minimum rating, script) per rating nibble for skaters
	db 0,1, 11,2, 0,1, 0,1, 11,6, 11,3, 0,1, 11,7, 11,4, 0,1, 0,1, 0,1, 0,1, 0,1
ScoutScriptPickG:		;SNES: (minimum rating, script) per rating nibble for goalies
	db 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 0,0, 11,5, 11,5
ScoutScripts:		;SNES: the showcase animation scripts: 8 offsets, then (SPA, facedir) steps; a negative facedir prints the name (and flips), 0 ends
	dw .s0-ScoutScripts,.s1-ScoutScripts,.s2-ScoutScripts,.s3-ScoutScripts,.s4-ScoutScripts,.s5-ScoutScripts,.s6-ScoutScripts,.s7-ScoutScripts
.s0:	dw SPAgready2,3,SPAgready2,4,SPAgready2,5,SPAgready2,-4,SPAgglover,4,SPAgready2,4,SPAgglovel,4,SPAgready2,4,0
.s5:	dw SPAgready2,3,SPAgready2,4,SPAgready2,5,SPAgready2,-4,SPAgglovel,4,SPAgready2,4,SPAgready2,4,0
.s1:	dw SPAskate,3,SPAskate,4,SPAcelebrate,-5,SPAcelebrate,4,SPAglide,4,SPAglide,4,0
.s2:	dw SPAskatewp,4,SPAskatewp,4,SPAskatewp,-4,SPAglide,4,SPAglide,4,0
.s3:	dw SPAskatewp,5,SPAskatewp,5,SPAshotf,-5,SPAglide,5,SPAglide,5,0
.s4:	dw SPAskatewp,3,SPAskatewp,3,SPAstumble,-3,SPAshotf,3,SPAglide,3,SPAglide,3,0
.s6:	dw SPAskate,4,SPAskate,5,SPAsweepchk,-5,SPAsweepchk,5,SPAskate,5,SPAsweepchk,5,SPAglide,5,SPAglide,5,0
.s7:	dw SPAskate,3,SPAskate,2,SPAfight,-2,SPAfhigh,2,SPAflow,2,SPAfhigh,2,SPAflow,2,0
ScoutLineOrder:		;SNES: the LineSets bytes shown in order (lines 1-3), $FF ends
	db $04,$05,$03,$00,$02,$01,$0C,$0D,$0B,$0A,$09,$14,$15,$13,$12,$11,$FF
DrawScoutPlayers:		;auto: CODE_84EEF4. SNES: addframe for the two showcased players (objects 0 and 6)
	ldx.w #$0000
	stx.b a3
	jsl.l DrawScoutPlayer
	ldx.w #$000C
	stx.b a3
DrawScoutPlayer:		;auto: CODE_84EF02. SNES: addframe for object X at (Xpos + OldXpos - 144, Ypos - 128)
	lda.w Xpos,x
	clc
	adc.w OldXpos,x
	sec
	sbc.w #$0090
	sta.b sprx
	lda.w Ypos,x
	sec
	sbc.w #$0080
	sta.b spry
	lda.w frame,x
	sta.b sprframe
	lda.w attribute,x
	and.w #$0800
	sta.b sprhflip
	lda.w attribute,x
	and.w #$1000
	sta.b sprvflip
	lda.w attribute,x
	lsr a
	bcc .add
	lda.w #$8000
	sta.b sprflag
.add:
	jml.l addframe		; bank $8F: 93G addframe
