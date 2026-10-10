; $82A000-$82AFFF  ROM $12000-$12FFF: GameSamples continued (BRR samples of the in-game SPC upload stream, see bank81_8000)
org $82A000
	incbin "../data/gamesamples.brr":$9FAC..$AFAC		; $82A000-$82AFFF
