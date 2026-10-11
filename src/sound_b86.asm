; SPC700 uploads, the sound queue, music cues (keeps ScoutingReportText here too).
; Bank $86. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $868000
BootSoundUpload:		;boot SPC upload: the sound driver and its sample set (sndbank 2)
	dw SPCDRIVERSIZE, SPCDRIVER		; block 1: the driver code
SPCDriver:		;SPC700 sound driver code, loaded at APU $0400 (not disassembled: SPC700 code)
	incbin "../data/spc/driver.spc700"
SPCDriverEnd:
	assert SPCDriverEnd-SPCDriver == SPCDRIVERSIZE
	dw BootInstrumentsEnd-BootInstruments, SPCINSTR		; block 2: the instrument table
BootInstruments:		;29 instruments: sample number, ADSR1, ADSR2, GAIN, then 2 pitch bytes (SNES DSP values)
	db $00, $8F,$E0,$B8, $07,$A0		; instrument $00
	db $01, $8F,$E0,$B8, $07,$A0		; instrument $01
	db $02, $8F,$E0,$B8, $07,$A0		; instrument $02
	db $03, $8F,$E0,$B8, $04,$00		; instrument $03
	db $04, $8F,$E0,$B8, $07,$A0		; instrument $04
	db $05, $8F,$E0,$B8, $07,$A0		; instrument $05
	db $06, $8F,$E0,$B8, $02,$00		; instrument $06
	db $07, $8F,$E0,$B8, $06,$F0		; instrument $07
	db $08, $FF,$E0,$B8, $07,$A0		; instrument $08
	db $9A, $8F,$E0,$B8, $04,$70		; instrument $09
	db $00, $8F,$E0,$B8, $04,$70		; instrument $0A
	db $01, $8F,$E0,$B8, $07,$A0		; instrument $0B
	db $02, $8F,$E0,$B8, $07,$A0		; instrument $0C
	db $03, $8F,$E0,$B8, $07,$A0		; instrument $0D
	db $04, $8F,$E0,$B8, $07,$A0		; instrument $0E
	db $05, $8F,$E0,$B8, $07,$A0		; instrument $0F
	db $06, $8F,$E0,$B8, $07,$A0		; instrument $10
	db $07, $8F,$E0,$B8, $07,$A0		; instrument $11
	db $08, $8F,$E0,$B8, $07,$A0		; instrument $12
	db $09, $8F,$E0,$B8, $07,$A0		; instrument $13
	db $0A, $8F,$E0,$B8, $07,$A0		; instrument $14
	db $0B, $8F,$E0,$B8, $07,$A0		; instrument $15
	db $0C, $8F,$E0,$B8, $07,$A0		; instrument $16
	db $0D, $8F,$E0,$B8, $07,$A0		; instrument $17
	db $0E, $8F,$E0,$B8, $07,$A0		; instrument $18
	db $0F, $FF,$E0,$B8, $0A,$F0		; instrument $19
	db $10, $8F,$E0,$B8, $0A,$F0		; instrument $1A
	db $11, $8F,$E0,$B8, $09,$F0		; instrument $1B
	db $12, $8F,$E0,$B8, $07,$A0		; instrument $1C
BootInstrumentsEnd:
	dw BootSampleDirEnd-BootSampleDir, SPCSAMPLEDIR		; block 3: the sample directory
BootSampleDir:		;DSP sample directory: per sample the APU address of its start and of its loop point
	dw SPCBOOTSAMPLES+$0000,SPCBOOTSAMPLES+$0DD1		; sample $00: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$0DD1,SPCBOOTSAMPLES+$1689		; sample $01: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$1689,SPCBOOTSAMPLES+$2757		; sample $02: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$2757,SPCBOOTSAMPLES+$2796		; sample $03: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$27BA,SPCBOOTSAMPLES+$4233		; sample $04: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$4233,SPCBOOTSAMPLES+$4530		; sample $05: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$4530,SPCBOOTSAMPLES+$455D		; sample $06: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$456F,SPCBOOTSAMPLES+$4968		; sample $07: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$49A7,SPCBOOTSAMPLES+$5271		; sample $08: start, loop (offsets in bootsamples.brr)
BootSampleDirEnd:
	dw BOOTSAMPLESIZE, SPCBOOTSAMPLES		; block 4: the BRR samples
BootSamples:		;BRR samples of the boot set (9-byte blocks), BootSamples-BootSamples
	incbin "../data/bootsamples.brr"
BootSamplesEnd:
	assert BootSamplesEnd-BootSamples == BOOTSAMPLESIZE
	dw $0000, SPCDRIVER		; end block: length 0, start the driver at $0400

org $86FBE1
StartSong6:		;SNES: start song 6 (the title screen music, from TitleScreen and setoptions) unless it plays: the boot sound set (SPCBootUpload), then driver command 3
	lda.w cursong
	cmp.w #6
	beq .rtl
	lda.w sndbank
	cmp.w #2
	beq .cmd
	jsl.l SPCBootUpload
.cmd:
	sep #$20		; APUIO0 = 3: play song 6
	lda.b #$03
	sta.w APUIO0
	rep #$30
	lda.w #6
	sta.w cursong
.rtl:
	rtl
StartSong7:		;SNES: start song 7 (driver command 2); no caller found
	lda.w cursong
	cmp.w #7
	beq .rtl
	lda.w sndbank
	cmp.w #2
	beq .cmd
	jsl.l SPCBootUpload
.cmd:
	sep #$20
	lda.b #$02
	sta.w APUIO0
	rep #$30
	lda.w #7
	sta.w cursong
.rtl:
	rtl
