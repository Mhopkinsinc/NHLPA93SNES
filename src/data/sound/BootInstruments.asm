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
