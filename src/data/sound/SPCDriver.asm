SPCDriver:		;SPC700 sound driver code, loaded at APU $0400 (not disassembled: SPC700 code)
	incbin "../../../data/spc/driver.spc700"
SPCDriverEnd:
	assert SPCDriverEnd-SPCDriver == SPCDRIVERSIZE
	dw BootInstrumentsEnd-BootInstruments, SPCINSTR		; block 2: the instrument table
