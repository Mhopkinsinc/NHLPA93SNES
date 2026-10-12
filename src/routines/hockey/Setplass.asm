Setplass:		;Set player X's first assignment from his position
	lda.w position,x
	sta.b d0
	bmi .rtl		; no position: no assignment
	lda.w #.alist
	sta.b a0
	lda.w #.alist>>16
	sta.b a0+2
	ldy.b d0
	lda.b [a0],y
	and.w #$00FF
	sta.b d0
	jmp.w assreplace
.rtl:
	rtl
.alist:		;assignment for each position (goalie, LD, RD, LW, C, RW, extra)
	db agoalie,adefd,adefd,awingd,acenterd,awingd,acenterd
