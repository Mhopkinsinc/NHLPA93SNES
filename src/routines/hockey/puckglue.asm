puckglue:		;Player a2 takes the puck
	lda.w seed+2		; pickup sound (one of 4)
	and.w #$0003
	clc
	adc.w #SFXshotwiff
	pha
	jsl.l sfx
	ldy.b a2
	tya
	lsr a
	sta.w puckc		; puckc = a2
	sta.b d0
	stz.b a0
	lda.w #$0002
	sta.b a1
	lda.w pfteam,y
	bne .tm
	stz.b a1
	lda.w #$0002
	sta.b a0
.tm:
	ldy.b a0
	lda.w #$FFFF
	sta.w tmtouch2,y		; other team loses its touches
	sta.w tmtouch3,y
	lda.w tmflags,y
	ora.w #tmflast
	sta.w tmflags,y
	lda.w #sf3fo
	trb.w sflags3		; sf3fo: this pickup wins the faceoff
	beq .snd
	ldy.b a1
	lda.w tmfowon,y
	inc a
	sta.w tmfowon,y
	lda.b crowdlevel		; +200
	clc
	adc.w #$00C8
	sta.b crowdlevel
.snd:
	lda.b a2
	lsr a
	sta.b d0
	cmp.w passReceiverPlayerNum		; pass reached its receiver
	bne .nrec
	ldy.b a1
	lda.w tmpasscomp,y
	inc a
	sta.w tmpasscomp,y
.nrec:
	lda.w #$FFFF
	sta.w passReceiverPlayerNum
	lda.w #sfspdir|sfssdir		; clear sfspdir/sfssdir
	trb.w sflags
	ldy.b a2
	lda.w position,y
	beq .goalie
	jml.l setd0player
.goalie:
	jsl.l ChkShotStat		; ChkShotStat (goalie made a save)
	ldy.b a2
	lda.w #$008C		; temp5 = 140, count down for the faceoff
	sta.w temp5,y
	lda.w SPA,y
	cmp.w #SPAgdive
	beq .gdive
	jml.l setd0player
.gdive:
	lda.w #$0005
	sta.w temp5,y
	jml.l setd0player
