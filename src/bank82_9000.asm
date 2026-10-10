; $829000-$829FFF  ROM $11000-$11FFF: GameSamples continued (BRR samples of the in-game SPC upload stream, see bank81_8000)
org $829000
	incbin "../data/gamesamples.brr":$8FAC..$9FAC		; $829000-$829FFF
