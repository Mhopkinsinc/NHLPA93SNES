; sound_b89: 93G sound93: SPC700 uploads, the sound queue, music cues (93G keeps ScoutingReportText here too).
; Bank $89. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $89EB15
p_music_vblank:		;92 name (vblank handler). Clear the change bits, run the 8 track slots (d7 = track 7-0), (93G sound93)
		;   SNES: role: every other frame send the next queued sound command (sndqueue) to APUIO0, a counter to APUIO1
	lda.w sndsettle		; wait after the sample upload
	bne .settle
	sep #$30
	lda.b sndlock
	bne .ex
	lda.b vcount		; every other frame
	lsr a
	bcc .ex
	ldx.b sndqout
	cpx.b sndqin
	beq .ex
	lda.b sndqueue,x
	sta.w APUIO0
	inc.b sndptr		; sndptr (low byte) doubles as the command counter here
	lda.b sndptr
	sta.w APUIO1
	txa
	inc a
	inc a
	and.b #$0F
	sta.b sndqout
.ex:
	rep #$30
	rtl
.settle:
	dec.w sndsettle
	rtl

org $89FB6B
StartSong8:		;SNES: start song 8 (no caller found) unless it plays: the boot sound set (SPCBootUpload), then driver command 9
	lda.w cursong
	cmp.w #8
	beq .rtl
	lda.w sndbank
	cmp.w #2
	beq .cmd
	jsl.l SPCBootUpload
.cmd:
	sep #$20
	lda.b #$09
	sta.w APUIO0
	rep #$30
	lda.w #8
	sta.w cursong
.rtl:
	rtl
StartSong9:		;SNES: start song 9 (the playoff screen music, PlayoffScreen) unless it plays: the boot sound set (SPCBootUpload), then driver command 1
	lda.w cursong
	cmp.w #9
	beq .rtl
	lda.w sndbank
	cmp.w #2
	beq .cmd
	jsl.l SPCBootUpload
.cmd:
	sep #$20
	lda.b #$01
	sta.w APUIO0
	rep #$30
	lda.w #9
	sta.w cursong
.rtl:
	rtl
StartSong1:		;SNES: start music cue 1 (home goal) unless it plays: the in-game sound set, then $8FFE7B with 4; cuetimer = its length
	lda.w cursong
	cmp.w #$0001
	beq .rtl
	lda.w sndbank
	cmp.w #$0001
	beq .cmd
	jsl.l sndqreset
	jsl.l SPCGameUpload
.cmd:
	lda.w #$0004
	jsl.l MusicCue		; bank $8F: driver command A (music cue)
	lda.w #$0001
	sta.w cursong
	lda.w #$0240
	sta.w cuetimer
.rtl:
	rtl
StartSong2:		;SNES: start music cue 2 (period start) unless it plays: the in-game sound set, then $8FFE7B with 5; cuetimer = its length
	lda.w cursong
	cmp.w #$0002
	beq .rtl
	lda.w sndbank
	cmp.w #$0001
	beq .cmd
	jsl.l sndqreset
	jsl.l SPCGameUpload
.cmd:
	lda.w #$0005
	jsl.l MusicCue		; bank $8F: driver command A (music cue)
	lda.w #$0002
	sta.w cursong
	lda.w #$01CE
	sta.w cuetimer
.rtl:
	rtl
StartSong3:		;SNES: start music cue 3 (third period, Gameloop by p3cue) unless it plays: the in-game sound set, then $8FFE7B with 6; cuetimer = its length
	lda.w cursong
	cmp.w #$0003
	beq .rtl
	lda.w sndbank
	cmp.w #$0001
	beq .cmd
	jsl.l sndqreset
	jsl.l SPCGameUpload
.cmd:
	lda.w #$0006
	jsl.l MusicCue		; bank $8F: driver command A (music cue)
	lda.w #$0003
	sta.w cursong
	lda.w #$0474
	sta.w cuetimer
.rtl:
	rtl
StartSong4:		;SNES: start music cue 4 (no caller found) unless it plays: the in-game sound set, then $8FFE7B with 7; cuetimer = its length
	lda.w cursong
	cmp.w #$0004
	beq .rtl
	lda.w sndbank
	cmp.w #$0001
	beq .cmd
	jsl.l sndqreset
	jsl.l SPCGameUpload
.cmd:
	lda.w #$0007
	jsl.l MusicCue		; bank $8F: driver command A (music cue)
	lda.w #$0004
	sta.w cursong
	lda.w #$022E
	sta.w cuetimer
.rtl:
	rtl
StartSong5:		;SNES: start music cue 5 (mid-period) unless it plays: the in-game sound set, then $8FFE7B with 8; cuetimer = its length
	lda.w cursong
	cmp.w #$0005
	beq .rtl
	lda.w sndbank
	cmp.w #$0001
	beq .cmd
	jsl.l sndqreset
	jsl.l SPCGameUpload
.cmd:
	lda.w #$0008
	jsl.l MusicCue		; bank $8F: driver command A (music cue)
	lda.w #$0005
	sta.w cursong
	lda.w #$041A
	sta.w cuetimer
.rtl:
	rtl
