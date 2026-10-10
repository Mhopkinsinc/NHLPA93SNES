; $869000-$869FFF  ROM $31000-$31FFF: SPCDriver continued (SPC700 sound driver code, see bank86_8000)
org $869000
	incbin "../data/spc/driver.bin":$FFC..$1FFC		; $869000-$869FFF
