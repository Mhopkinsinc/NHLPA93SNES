; $828000-$828FFF  ROM $10000-$10FFF: GameSamples continued (BRR samples of the in-game SPC upload stream, see bank81_8000)
org $828000
	incbin "../data/gamesamples.brr":$7FAC..$8FAC		; $828000-$828FFF
