; $81C000-$81CFFF  ROM $0C000-$0CFFF: GameSamples continued (BRR samples of the in-game SPC upload stream, see bank81_8000)
org $81C000
	incbin "../data/gamesamples.brr":$3FAC..$4FAC		; $81C000-$81CFFF
