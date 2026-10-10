; $819000-$819FFF  ROM $09000-$09FFF: GameSamples continued (BRR samples of the in-game SPC upload stream, see bank81_8000)
org $819000
	incbin "../data/gamesamples.brr":$FAC..$1FAC		; $819000-$819FFF
