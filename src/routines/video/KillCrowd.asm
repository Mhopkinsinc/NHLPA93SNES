KillCrowd:		;Silence the crowd noise
	lda.w #$0088
	pha
	jsl.l sfx8F
	rtl
