; $86A000-$86AFFF  ROM $32000-$32FFF: the end of SPCDriver, then the other blocks of BootSoundUpload: BootInstruments (APU $2B00),
; BootSampleDir (APU $2C00) and the start of BootSamples (data/bootsamples.brr, APU $2C30, continued to bank86_F000).
org $86A000
	incbin "../data/spc/driver.spc700":$1FFC..$26E7		; $86A000-$86A6EA
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
BootSamples:		;BRR samples of the boot set (9-byte blocks), $86A7C9-$86FA39
	incbin "../data/bootsamples.brr":0..$837		; $86A7C9-$86AFFF
