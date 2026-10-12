GameSamples:		;BRR samples (9-byte blocks)
	incbin "../../../data/gamesamples.brr"
GameSamplesEnd:
	dw $0000, SPCRESUME		; end block: length 0, start the driver at $0800
