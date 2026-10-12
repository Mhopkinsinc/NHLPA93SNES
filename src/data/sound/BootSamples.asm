BootSamples:		;BRR samples of the boot set (9-byte blocks)
	incbin "../../../data/bootsamples.brr"
BootSamplesEnd:
	assert BootSamplesEnd-BootSamples == BOOTSAMPLESIZE
	dw $0000, SPCDRIVER		; end block: length 0, start the driver at $0400
