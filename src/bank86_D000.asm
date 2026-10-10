; $86D000-$86DFFF  ROM $35000: BootSamples continued (BRR samples of the boot SPC upload, see bank86_A000)
org $86D000
	incbin "../data/bootsamples.brr":$2837..$3837		; $86D000-$86DFFF
