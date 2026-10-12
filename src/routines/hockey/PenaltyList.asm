PenaltyList:		;penalty number = word offset into this table. Used by AddPenalty, the penalty box and stats
	dw $0000		; 0
	dw .eop-PenaltyList		; $02 period over
	dw .eog-PenaltyList		; $04 game over
	dw .faceoff-PenaltyList		; $06 out of play
	dw .faceoff-PenaltyList		; $08 goalie holding
	dw .whistle-PenaltyList		; $0A whistle
	dw .ice-PenaltyList		; $0C icing
	dw .goal-PenaltyList		; $0E goal
	dw .offsides-PenaltyList		; $10 offsides
	dw .rough2-PenaltyList		; $12 roughing, slow down time $A
	dw .p14-PenaltyList		; $14 no text
	dw .charge-PenaltyList		; $16 charging
	dw .slash-PenaltyList		; $18 slashing
	dw .rough-PenaltyList		; $1A roughing
	dw .cross-PenaltyList		; $1C cross check
	dw .hook-PenaltyList		; $1E hooking
	dw .trip-PenaltyList		; $20 tripping
	dw .int-PenaltyList		; $22 interference
	dw .hold-PenaltyList		; $24 holding
	dw .fight-PenaltyList		; $26 fighting
	dw .fight2-PenaltyList		; $28 fighting *
	dw .inst-PenaltyList		; $2A fight instigator
	dw .delay-PenaltyList		; $2C delay
;format: dw $ttmm (tt = slow down time in half secs, mm = penalty min.); string (length word counting itself, text)
;then dw $ffdd,... (ff = frame, dd = delay; negative ends)
.eop:		;period over
	dw $0100
	dw 13
	db "Period Over"
	dw -$0510
.eog:		;game over
	dw $0100
	dw 11
	db "Game Over"
	dw $0510,-$4030
.goal:		;goal
	dw $0100
	dw 2
	dw $050A,-$4010
.p14:		;no text
	dw $0100
	dw 2
	dw $0510,-$4018
.ice:		;icing
	dw $0100
	dw 7
	db "Icing"
	dw $0002,$0101,-$0206
.offsides:		;offsides
	dw $0100
	dw 10
	db "Off-side"
	dw $0002,$0301,-$040F
.faceoff:		;face off (PenOOP, PenGhold)
	dw $0100
	dw 10
	db "Face Off"
	dw -$050A
.delay:		;delay
	dw $0000
	dw 9
	db "Penalty"
	dw $0003,$0301,-$040F
.whistle:		;whistle
	dw $0000
	dw 2
	dw -$050A
.charge:		;charging
	dw $0402
	dw 10
	db "Charging"
	dw $0004,$0101,$0A01,$0B01,$0A01,$0B01,$0A01,$0B01,$0A01,$0B01,-$0101
.slash:		;slashing
	dw $0402
	dw 10
	db "Slashing"
	dw $0004,$0101,$0201,$0301,$0201,$0301,$0201,$0301,$0201,$0301,-$0101
.trip:		;tripping
	dw $0402
	dw 10
	db "Tripping"
	dw $0004,$0401,$0501,$0401,$0501,$0401,$0501,$0401,$0501,-$0101
.rough2:		;roughing, slow down time $A
	dw $0A02
	dw 10
	db "Roughing"
	dw $0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
.rough:		;roughing
	dw $0402
	dw 10
	db "Roughing"
	dw $0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
.hook:		;hooking
	dw $0402
	dw 9
	db "Hooking"
	dw $0004,$0101,$0901,$0801,$0901,$0801,$0901,$0801,$0901,$0801,-$0101
.cross:		;cross check
	dw $0402
	dw 13
	db "Cross Check"
	dw $0004,$0601,$0F01,$1001,$0F01,$1001,$0F01,$1001,$0F01,$1001,-$0101
.int:		;interference
	dw $0402
	dw 14
	db "Interference"
	dw $0004,$0101,$0C06,-$0101
.hold:		;holding
	dw $0402
	dw 9
	db "Holding"
	dw $0004,$0101,$0706,-$0101
.fight:		;fighting
	dw $2805
	dw 10
	db "Fighting"
	dw $0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
.fight2:		;fighting *
	dw $2805
	dw 12
	db "Fighting *"
	dw $0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
.inst:		;fight instigator
	dw $2802
	dw 18
	db "Fight Instigator"
	dw $0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
