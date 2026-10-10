; $86B000-$86BFFF  ROM $33000: BootSamples continued (BRR samples of the boot SPC upload, see bank86_A000)
org $86B000
	incbin "../data/bootsamples.brr":$837..$1837		; $86B000-$86BFFF
