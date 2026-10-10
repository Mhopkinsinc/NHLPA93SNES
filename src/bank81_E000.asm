; $81E000-$81EFFF  ROM $0E000-$0EFFF: GameSamples continued (BRR samples of the in-game SPC upload stream, see bank81_8000)
org $81E000
	incbin "../data/gamesamples.brr":$5FAC..$6FAC		; $81E000-$81EFFF
