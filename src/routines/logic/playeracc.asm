playeracc:		;Accelerate player X in direction d2 by his weight and leg strength, up to his top speed; uses energy
	asl.b d2
	asl.b d2
	ldx.b d2
	lda.l dirtab8F+2,x
	sta.b mula
	lda.b d7
	sta.b mulb
	jsl.l muls16
	lsr a
	lsr a
	bit.w #$2000
	beq .sx
	ora.w #$C000
.sx:
	sta.b d1
	lda.l dirtab8F,x
	sta.b mula
	lda.b d7
	sta.b mulb
	jsl.l muls16
	lsr a
	lsr a
	bit.w #$2000
	beq .sy
	ora.w #$C000
.sy:
	sta.b d0
	ldx.b a3
	lda.w Wallsin,x
	beq .nox
	eor.b d0
	bpl .nox
	stz.b d0
.nox:
	lda.w Wallcos,x
	beq .noy
	eor.b d1
	bmi .noy
	stz.b d1
.noy:
	lda.w weight,x
	lsr a
	lsr a
	lsr a
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0020
	clc
	adc.w legstr,x
	sta.b d2
	lda.w position,x
	bne .ng
	lda.b d2
	clc
	adc.w legstr,x
	clc
	adc.w #$0008
	sta.b d2
.ng:
	lda.b d2
	pha
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l muls32
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	sta.b mula
	lda.b d7
	sta.b mulb
	jsl.l muls16
	adc.w Xvel,x
	sta.b d0
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d2
	lda.b mulres+2
	sta.b d2+2
	pla
	sta.b mula
	lda.b d1
	sta.b mulb
	jsl.l muls32
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	sta.b mula
	lda.b d7
	sta.b mulb
	jsl.l muls16
	adc.w Yvel,x
	sta.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d2
	sta.b d3
	lda.b mulres+2
	adc.b d2+2
	sta.b d3+2
	lda.b d1
	pha
	lda.b d0
	pha
	jsl.l getpde
	lda.w legspd,x
	sta.b mula
	lda.b d0
	lsr a
	clc
	adc.w #$0800
	sta.b mulb
	jsl.l mulu
	asl a
	rol.b mulres+2
	asl a
	rol.b mulres+2
	asl a
	rol.b mulres+2
	asl a
	rol.b mulres+2
	lda.b mulres+2
	asl a
	asl a
	tax
	lda.l MaxSpeed,x
	sta.b d2
	lda.l MaxSpeed+2,x
	sta.b d2+2
	ldx.b a3
	pla
	sta.b d0
	pla
	sta.b d1
	lda.b d2
	cmp.b d3
	lda.b d2+2
	sbc.b d3+2
	bcc .sube
	lda.b d0
	sta.w Xvel,x
	lda.b d1
	sta.w Yvel,x
.sube:
	lda.w OptLine
	bne .rtl
	lda.w seed
	and.w #$003F
	bne .rtl
	jsl.l getpde
	lda.b d0
	sec
	sbc.w #$0021
	sta.b d0
	sec
	sbc.w #$0C00
	bmi .lt
	bvc .add
.set:
	jmp.w setpde
.lt:
	bvc .set
.add:
	lda.w endurance,x
	sta.b d2
	clc
	adc.b d0
	sta.b d0
	jmp.w setpde
.rtl:
	rtl
