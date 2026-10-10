; $86C000-$86CFFF  ROM $34000: BootSamples continued (BRR samples of the boot SPC upload, see bank86_A000)
org $86C000
	incbin "../data/bootsamples.brr":$1837..$2837		; $86C000-$86CFFF
