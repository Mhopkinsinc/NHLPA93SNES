; $81D000-$81DFFF  ROM $0D000-$0DFFF: GameSamples continued (BRR samples of the in-game SPC upload stream, see bank81_8000)
org $81D000
	incbin "../data/gamesamples.brr":$4FAC..$5FAC		; $81D000-$81DFFF
