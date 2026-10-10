; $85E000-$85EFFF  ROM $2E000-$2EFFF: Title1Map continued (packed title screen, see bank85_D000)
org $85E000
	incbin "../data/Title1.pak":$A40..$1A40		; $85E000-$85EFFF
