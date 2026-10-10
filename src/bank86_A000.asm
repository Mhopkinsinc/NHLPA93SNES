; $86A000-$86AFFF  ROM $32000-$32FFF: the end of SPCDriver, then the other blocks of BootSoundUpload: BootInstruments (APU $2B00),
; BootSampleDir (APU $2C00) and the start of BootSamples (data/bootsamples.brr, APU $2C30, continued to bank86_F000).
org $86A000
	incbin "../data/spc/driver.bin":$1FFC..$26E7		; $86A000-$86A6EA
SPCDriverEnd:
	assert SPCDriverEnd-SPCDriver == SPCDRIVERSIZE
	dw BootInstrumentsEnd-BootInstruments, SPCINSTR		; $86A6EB block 2: the instrument table
BootInstruments:		;29 instruments: sample number, ADSR1, ADSR2, GAIN, then 2 pitch bytes (SNES DSP values)
	db $00, $8F,$E0,$B8, $07,$A0		; $86A6EF instrument $00
	db $01, $8F,$E0,$B8, $07,$A0		; $86A6F5 instrument $01
	db $02, $8F,$E0,$B8, $07,$A0		; $86A6FB instrument $02
	db $03, $8F,$E0,$B8, $04,$00		; $86A701 instrument $03
	db $04, $8F,$E0,$B8, $07,$A0		; $86A707 instrument $04
	db $05, $8F,$E0,$B8, $07,$A0		; $86A70D instrument $05
	db $06, $8F,$E0,$B8, $02,$00		; $86A713 instrument $06
	db $07, $8F,$E0,$B8, $06,$F0		; $86A719 instrument $07
	db $08, $FF,$E0,$B8, $07,$A0		; $86A71F instrument $08
	db $9A, $8F,$E0,$B8, $04,$70		; $86A725 instrument $09
	db $00, $8F,$E0,$B8, $04,$70		; $86A72B instrument $0A
	db $01, $8F,$E0,$B8, $07,$A0		; $86A731 instrument $0B
	db $02, $8F,$E0,$B8, $07,$A0		; $86A737 instrument $0C
	db $03, $8F,$E0,$B8, $07,$A0		; $86A73D instrument $0D
	db $04, $8F,$E0,$B8, $07,$A0		; $86A743 instrument $0E
	db $05, $8F,$E0,$B8, $07,$A0		; $86A749 instrument $0F
	db $06, $8F,$E0,$B8, $07,$A0		; $86A74F instrument $10
	db $07, $8F,$E0,$B8, $07,$A0		; $86A755 instrument $11
	db $08, $8F,$E0,$B8, $07,$A0		; $86A75B instrument $12
	db $09, $8F,$E0,$B8, $07,$A0		; $86A761 instrument $13
	db $0A, $8F,$E0,$B8, $07,$A0		; $86A767 instrument $14
	db $0B, $8F,$E0,$B8, $07,$A0		; $86A76D instrument $15
	db $0C, $8F,$E0,$B8, $07,$A0		; $86A773 instrument $16
	db $0D, $8F,$E0,$B8, $07,$A0		; $86A779 instrument $17
	db $0E, $8F,$E0,$B8, $07,$A0		; $86A77F instrument $18
	db $0F, $FF,$E0,$B8, $0A,$F0		; $86A785 instrument $19
	db $10, $8F,$E0,$B8, $0A,$F0		; $86A78B instrument $1A
	db $11, $8F,$E0,$B8, $09,$F0		; $86A791 instrument $1B
	db $12, $8F,$E0,$B8, $07,$A0		; $86A797 instrument $1C
BootInstrumentsEnd:
	dw BootSampleDirEnd-BootSampleDir, SPCSAMPLEDIR		; $86A79D block 3: the sample directory
BootSampleDir:		;DSP sample directory: per sample the APU address of its start and of its loop point
	dw SPCBOOTSAMPLES+$0000,SPCBOOTSAMPLES+$0DD1		; $86A7A1 sample $00: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$0DD1,SPCBOOTSAMPLES+$1689		; $86A7A5 sample $01: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$1689,SPCBOOTSAMPLES+$2757		; $86A7A9 sample $02: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$2757,SPCBOOTSAMPLES+$2796		; $86A7AD sample $03: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$27BA,SPCBOOTSAMPLES+$4233		; $86A7B1 sample $04: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$4233,SPCBOOTSAMPLES+$4530		; $86A7B5 sample $05: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$4530,SPCBOOTSAMPLES+$455D		; $86A7B9 sample $06: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$456F,SPCBOOTSAMPLES+$4968		; $86A7BD sample $07: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$49A7,SPCBOOTSAMPLES+$5271		; $86A7C1 sample $08: start, loop (offsets in bootsamples.brr)
BootSampleDirEnd:
	dw BOOTSAMPLESIZE, SPCBOOTSAMPLES		; $86A7C5 block 4: the BRR samples
BootSamples:		;BRR samples of the boot set (9-byte blocks), $86A7C9-$86FA39
	incbin "../data/bootsamples.brr":0..$837		; $86A7C9-$86AFFF
