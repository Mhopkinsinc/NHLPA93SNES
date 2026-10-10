; $81B000-$81BFFF  ROM $0B000-$0BFFF: GameSamples continued (BRR samples of the in-game SPC upload stream, see bank81_8000)
org $81B000
	incbin "../data/gamesamples.brr":$2FAC..$3FAC		; $81B000-$81BFFF
