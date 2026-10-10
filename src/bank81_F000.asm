; $81F000-$81FFFF  ROM $0F000-$0FFFF: GameSamples continued (BRR samples of the in-game SPC upload stream, see bank81_8000)
org $81F000
	incbin "../data/gamesamples.brr":$6FAC..$7FAC		; $81F000-$81FFFF
