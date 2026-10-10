; $868000-$868FFF  ROM $30000-$30FFF: BootSoundUpload, the SPC700 upload stream sent at boot by SPCBootUpload ($82FA31). Same block
; format as GameSoundUpload (bank81_8000). Blocks: the sound driver (SPC700 code, data/spc/driver.bin) to APU $0400, the instrument
; table to $2B00, the sample directory to $2C00, the boot BRR samples (data/bootsamples.brr) to $2C30, then the end block (start the
; driver at $0400). The driver runs on through bank86_A000.
org $868000
BootSoundUpload:		;boot SPC upload: the sound driver and its sample set (sndbank 2)
	dw SPCDRIVERSIZE, SPCDRIVER		; $868000 block 1: the driver code
SPCDriver:		;SPC700 sound driver code, loaded at APU $0400 (not disassembled: SPC700 code)
	incbin "../data/spc/driver.bin":0..$FFC		; $868004-$868FFF
