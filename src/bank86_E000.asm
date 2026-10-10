; $86E000-$86EFFF  ROM $36000: BootSamples continued (BRR samples of the boot SPC upload, see bank86_A000)
org $86E000
	incbin "../data/bootsamples.brr":$3837..$4837		; $86E000-$86EFFF
