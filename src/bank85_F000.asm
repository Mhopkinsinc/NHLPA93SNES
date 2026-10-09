; $85F000-$84FFFF  ROM $2F000  (from src/bank85.asm; quick pass, TODO segment agents refine)
org $85F000
	db $FF,$3F,$C4,$05,$FF,$9F,$BF,$5F,$FF,$8F,$D0,$41,$E1,$12,$4A,$00	; $85F000
	db $3F,$49,$31,$CF,$20,$49,$62,$21,$00,$C0,$60,$8A,$DE,$03,$C0,$FF	; $85F010
	db $B9,$C9,$48,$00,$30,$49,$01,$B9,$40,$48,$05,$30,$40,$38,$C1,$30	; $85F020
	db $FF,$89,$02,$03,$38,$FF,$F7,$F9,$48,$00,$06,$49,$01,$F7,$08,$48	; $85F030
	db $04,$07,$0A,$07,$FA,$06,$80,$B6,$4C,$00,$07,$4B,$31,$3F,$20,$49	; $85F040
	db $50,$01,$9F,$20,$20,$02,$70,$C0,$7F,$8D,$60,$42,$DE,$62,$22,$EB	; $85F050
	db $12,$49,$01,$F7,$FA,$48,$00,$07,$49,$07,$E7,$1A,$CF,$33,$0F,$77	; $85F060
	db $1F,$E7,$83,$56,$4A,$81,$E6,$01,$1F,$FF,$31,$9F,$20,$49,$00,$DF	; $85F070
	db $20,$05,$CF,$10,$80,$38,$E0,$3F,$85,$38,$00,$80,$4B,$03,$E0,$FF	; $85F080
	db $BC,$D4,$48,$00,$38,$49,$01,$BC,$50,$48,$02,$38,$50,$3C,$DC,$80	; $85F090
	db $B4,$4F,$01,$FF,$3C,$81,$60,$01,$FB,$07,$49,$01,$F7,$0B,$48,$00	; $85F0A0
	db $07,$48,$DC,$E7,$58,$4B,$01,$90,$40,$4C,$00,$D0,$20,$48,$00,$80	; $85F0B0
	db $20,$01,$C0,$5F,$83,$58,$4E,$03,$C0,$FF,$39,$C1,$4A,$0B,$38,$C5	; $85F0C0
	db $3C,$D1,$3C,$D3,$38,$D3,$3E,$D3,$30,$FF,$4A,$85,$60,$00,$3E,$8B	; $85F0D0
	db $E0,$00,$80,$20,$00,$FB,$8B,$DE,$03,$04,$FB,$FD,$FE,$48,$00,$01	; $85F0E0
	db $49,$01,$FD,$02,$48,$00,$01,$48,$DC,$00,$FF,$8B,$02,$01,$FC,$F4	; $85F0F0
	db $48,$00,$F8,$49,$01,$FC,$F0,$48,$00,$F8,$58,$02,$F5,$F8,$FF,$89	; $85F100
	db $02,$03,$FC,$FF,$FB,$FD,$48,$00,$03,$49,$01,$FB,$05,$48,$00,$03	; $85F110
	db $48,$DC,$00,$FF,$8B,$02,$01,$18,$CF,$20,$07,$ED,$C6,$F0,$E1,$FC	; $85F120
	db $F8,$FF,$FE,$32,$FF,$04,$E7,$FF,$F3,$FF,$F9,$84,$0C,$42,$03,$50	; $85F130
	db $A6,$1C,$E2,$20,$0B,$F8,$8B,$B4,$59,$0A,$42,$82,$80,$F1,$E4,$FF	; $85F140
	db $FD,$49,$40,$02,$7B,$FF,$B7,$7B,$40,$10,$09,$29,$07,$37,$E6,$16	; $85F150
	db $E3,$13,$02,$12,$31,$C9,$43,$EB,$22,$8A,$F6,$80,$76,$00,$F9,$80	; $85F160
	db $78,$00,$FD,$80,$DC,$00,$BC,$69,$11,$17,$58,$66,$18,$17,$38,$03	; $85F170
	db $2C,$29,$1E,$C0,$D7,$5A,$47,$C7,$DF,$E0,$FF,$4A,$00,$F0,$49,$02	; $85F180
	db $38,$FF,$B8,$59,$0F,$01,$FE,$08,$77,$06,$39,$80,$1F,$4C,$87,$62	; $85F190
	db $81,$38,$C0,$36,$C8,$89,$FE,$4A,$07,$BC,$03,$97,$68,$AE,$51,$15	; $85F1A0
	db $EA,$20,$06,$FF,$41,$FE,$46,$F9,$30,$7F,$8D,$20,$00,$07,$49,$0D	; $85F1B0
	db $B7,$7F,$27,$FF,$AF,$7F,$4F,$9F,$1F,$DF,$1F,$BF,$0F,$FF,$4A,$00	; $85F1C0
	db $1F,$4F,$10,$BD,$FA,$89,$DE,$D2,$F5,$CD,$EE,$CC,$EF,$C0,$EB,$E1	; $85F1D0
	db $F9,$E8,$F1,$C0,$80,$7E,$00,$E8,$82,$80,$02,$F4,$FF,$F6,$49,$06	; $85F1E0
	db $88,$07,$DE,$01,$E7,$10,$FF,$20,$07,$AB,$54,$53,$AC,$88,$F0,$70	; $85F1F0
	db $82,$8D,$60,$00,$80,$80,$A2,$06,$07,$F8,$22,$F8,$7C,$E0,$CF,$20	; $85F200
	db $03,$7B,$04,$79,$06,$8D,$20,$01,$98,$EB,$E0,$1E,$0B,$FC,$8F,$73	; $85F210
	db $90,$6E,$86,$79,$83,$7C,$03,$FC,$04,$80,$14,$00,$02,$59,$00,$01	; $85F220
	db $84,$20,$1F,$EF,$3F,$0F,$1F,$07,$8F,$17,$BF,$53,$47,$13,$4F,$19	; $85F230
	db $EB,$28,$C1,$9F,$FF,$DF,$FF,$5F,$FF,$4F,$FF,$AF,$FF,$B7,$FF,$17	; $85F240
	db $FF,$1B,$FF,$01,$C0,$DF,$80,$63,$38,$FF,$00,$C0,$3C,$FF,$03,$38	; $85F250
	db $D7,$FF,$10,$8A,$10,$3C,$FF,$03,$07,$FB,$FF,$03,$8A,$10,$3C,$FF	; $85F260
	db $01,$E0,$3F,$8B,$60,$ED,$10,$20,$53,$8A,$10,$3A,$FF,$03,$3F,$CF	; $85F270
	db $FF,$1F,$8A,$10,$3C,$FF,$01,$F0,$9F,$8B,$B3,$ED,$10,$81,$52,$29	; $85F280
	db $00,$01,$C1,$80,$0F,$81,$14,$4B,$03,$01,$FF,$C3,$EF,$20,$00,$E7	; $85F290
	db $27,$00,$F0,$20,$05,$F3,$73,$2C,$10,$E7,$18,$86,$20,$04,$0F,$73	; $85F2A0
	db $7F,$F8,$FC,$20,$48,$26,$00,$7F,$20,$05,$FF,$3F,$04,$03,$FC,$03	; $85F2B0
	db $86,$20,$00,$80,$30,$3F,$E8,$13,$01,$FF,$03,$E0,$89,$20,$00,$7F	; $85F2C0
	db $E6,$16,$00,$03,$20,$11,$FC,$FC,$7F,$D9,$9F,$1C,$CF,$CF,$EF,$EB	; $85F2D0
	db $F0,$D0,$F0,$E0,$E0,$80,$C0,$20,$84,$C0,$0D,$F7,$F1,$EE,$C0,$FF	; $85F2E0
	db $D0,$EF,$C9,$F6,$FF,$F7,$10,$EF,$60,$20,$09,$60,$80,$80,$40,$EE	; $85F2F0
	db $5E,$7F,$80,$ED,$1B,$20,$06,$08,$EF,$10,$40,$DF,$20,$BF,$20,$02	; $85F300
	db $7F,$3E,$81,$20,$03,$80,$07,$FF,$FE,$88,$C0,$00,$E0,$80,$50,$00	; $85F310
	db $01,$89,$C0,$04,$1F,$CC,$CF,$03,$FD,$80,$C5,$38,$FF,$80,$83,$3A	; $85F320
	db $FF,$05,$FE,$FF,$FC,$FF,$F8,$FC,$C4,$07,$F0,$F9,$E1,$F4,$E8,$F6	; $85F330
	db $CD,$E7,$33,$FF,$00,$FD,$59,$1A,$FB,$FF,$F3,$FF,$F2,$FF,$C8,$84	; $85F340
	db $51,$95,$18,$9C,$18,$9A,$14,$1E,$B1,$BE,$A0,$BD,$20,$3D,$7F,$FF	; $85F350
	db $EE,$FF,$E7,$49,$02,$E3,$FF,$43,$49,$09,$C3,$FF,$CF,$C3,$A9,$A7	; $85F360
	db $A8,$A5,$CA,$C4,$20,$0C,$03,$49,$4A,$9B,$19,$20,$20,$3C,$FF,$5C	; $85F370
	db $FF,$5E,$FF,$81,$C6,$15,$B7,$FF,$E6,$FF,$DF,$FF,$60,$FF,$3C,$FF	; $85F380
	db $CE,$2F,$36,$FF,$1F,$93,$04,$EB,$49,$31,$80,$BE,$81,$98,$00,$10	; $85F390
	db $59,$02,$E0,$FF,$F0,$80,$7C,$11,$7F,$FF,$A0,$5F,$02,$FD,$08,$F7	; $85F3A0
	db $40,$FF,$D1,$FE,$A0,$FE,$02,$FC,$C0,$FC,$86,$BC,$4D,$0B,$9F,$1F	; $85F3B0
	db $1F,$3F,$1F,$7F,$9F,$3F,$BF,$7F,$3F,$FF,$30,$7F,$80,$5A,$4A,$78	; $85F3C0
	db $4A,$42,$80,$8E,$03,$F3,$F6,$FB,$F7,$48,$05,$FF,$F0,$FA,$F9,$FD	; $85F3D0
	db $FD,$80,$56,$00,$F8,$4D,$00,$FD,$80,$60,$48,$01,$7B,$84,$48,$01	; $85F3E0
	db $3A,$C5,$20,$08,$FF,$04,$FF,$C0,$FF,$C2,$FC,$E1,$FE,$8D,$60,$0F	; $85F3F0
	db $51,$AE,$2B,$D4,$05,$F8,$19,$E0,$E6,$19,$19,$07,$01,$7D,$10,$F3	; $85F400
	db $89,$1C,$13,$02,$FF,$0C,$FF,$A1,$5E,$08,$0F,$D3,$27,$94,$5F,$40	; $85F410
	db $FF,$C8,$F3,$24,$F3,$21,$7F,$81,$BE,$02,$18,$FF,$20,$86,$24,$10	; $85F420
	db $2E,$DE,$BF,$81,$9A,$A2,$4F,$94,$05,$89,$C7,$2A,$E1,$06,$7B,$81	; $85F430
	db $01,$80,$6A,$48,$00,$02,$49,$00,$01,$49,$20,$E3,$A6,$09,$7F,$BF	; $85F440
	db $FF,$1F,$3F,$DF,$7F,$9F,$BF,$CF,$D8,$E6,$B2,$81,$C8,$03,$BF,$FF	; $85F450
	db $01,$03,$20,$4C,$26,$01,$03,$FD,$4B,$00,$FC,$85,$60,$0A,$E3,$76	; $85F460
	db $81,$66,$83,$6C,$07,$C8,$07,$08,$03,$49,$0B,$07,$0C,$76,$6A,$66	; $85F470
	db $5E,$6C,$54,$CC,$34,$0C,$F4,$4A,$02,$08,$F4,$FF,$80,$92,$48,$C2	; $85F480
	db $06,$01,$01,$03,$03,$FE,$FF,$7F,$E4,$5B,$40,$05,$FE,$FE,$FC,$FC	; $85F490
	db $01,$F8,$78,$81,$86,$81,$20,$31,$C0,$00,$FE,$80,$16,$E5,$17,$31	; $85F4A0
	db $3F,$20,$04,$BF,$3F,$E2,$BF,$C0,$48,$07,$FF,$80,$1F,$60,$BF,$C7	; $85F4B0
	db $BF,$CF,$D9,$04,$33,$60,$24,$40,$30,$20,$04,$60,$C0,$A0,$40,$20	; $85F4C0
	db $48,$00,$7F,$20,$15,$ED,$1B,$AC,$5B,$EC,$1F,$E7,$1C,$F3,$0C,$F8	; $85F4D0
	db $FE,$FC,$FE,$1C,$EF,$07,$FF,$07,$7F,$03,$3F,$49,$09,$1F,$01,$07	; $85F4E0
	db $01,$03,$E0,$13,$F0,$F8,$18,$48,$02,$FC,$F8,$0C,$48,$00,$08,$49	; $85F4F0
	db $DC,$07,$E8,$E7,$E0,$E7,$E4,$E3,$F4,$F3,$4C,$01,$04,$F3,$86,$8E	; $85F500
	db $4B,$00,$FD,$3E,$FF,$10,$CC,$E0,$90,$CC,$80,$DC,$35,$F9,$71,$F9	; $85F510
	db $F7,$FB,$EB,$F5,$E1,$F6,$F7,$86,$2E,$00,$F8,$4B,$13,$60,$7D,$84	; $85F520
	db $FF,$D0,$FB,$E2,$F9,$8F,$FE,$08,$FE,$1E,$FE,$6D,$EC,$83,$FF,$03	; $85F530
	db $FF,$80,$84,$80,$D6,$4A,$04,$13,$FF,$4C,$4C,$81,$20,$0C,$11,$90	; $85F540
	db $25,$A4,$40,$80,$22,$42,$60,$80,$AC,$88,$B3,$30,$FF,$02,$EF,$FF	; $85F550
	db $DB,$E2,$66,$0B,$7F,$FF,$77,$FF,$73,$6D,$69,$75,$03,$7B,$4F,$FF	; $85F560
	db $20,$11,$B7,$50,$BF,$20,$FF,$20,$DF,$9E,$FF,$8E,$FF,$84,$FF,$80	; $85F570
	db $FF,$C8,$FF,$C0,$49,$00,$E0,$DC,$0E,$FD,$84,$FA,$80,$F9,$09,$F7	; $85F580
	db $0B,$F3,$03,$FF,$17,$E7,$07,$FF,$20,$80,$56,$00,$03,$84,$64,$00	; $85F590
	db $0F,$49,$00,$FC,$48,$00,$FE,$E9,$B8,$7E,$46,$04,$F0,$FF,$D0,$FE	; $85F5A0
	db $41,$80,$50,$20,$06,$7F,$10,$FF,$58,$FF,$18,$BF,$81,$40,$58,$E1	; $85F5B0
	db $0E,$4A,$12,$C0,$FF,$89,$AE,$A5,$7E,$0C,$B7,$96,$E3,$62,$C7,$43	; $85F5C0
	db $FE,$7A,$FB,$41,$FE,$70,$82,$78,$E3,$20,$14,$07,$FF,$3F,$FF,$45	; $85F5D0
	db $2C,$10,$77,$92,$FF,$17,$C9,$20,$B1,$09,$68,$38,$B0,$47,$66,$13	; $85F5E0
	db $82,$76,$0D,$3E,$FF,$7E,$FF,$F6,$FF,$C3,$FF,$81,$FF,$A8,$D1,$0C	; $85F5F0
	db $71,$20,$0A,$7C,$B8,$BE,$FD,$FE,$99,$1A,$85,$A6,$48,$37,$83,$5A	; $85F600
	db $00,$40,$80,$40,$09,$64,$FF,$78,$FF,$F8,$FF,$6F,$3F,$4F,$BF,$48	; $85F610
	db $03,$0F,$5F,$4F,$1F,$48,$06,$0F,$1F,$07,$2F,$DF,$FF,$5F,$49,$00	; $85F620
	db $3F,$4D,$00,$1F,$80,$B0,$00,$06,$49,$E4,$D1,$49,$01,$01,$F8,$4A	; $85F630
	db $20,$00,$FC,$20,$00,$FE,$25,$00,$FE,$80,$4C,$00,$41,$60,$85,$95	; $85F640
	db $21,$00,$BF,$4B,$00,$3F,$49,$24,$05,$7F,$BF,$78,$B8,$78,$B0,$4F	; $85F650
	db $01,$B0,$7F,$80,$76,$89,$02,$05,$1E,$2D,$FE,$09,$FF,$F0,$83,$3C	; $85F660
	db $4A,$01,$20,$C3,$20,$00,$03,$49,$00,$01,$59,$24,$02,$F8,$FC,$08	; $85F670
	db $49,$01,$F8,$1C,$48,$03,$F0,$3C,$F0,$38,$48,$01,$04,$F3,$4B,$00	; $85F680
	db $E3,$48,$03,$0C,$03,$08,$07,$48,$01,$FD,$FF,$4C,$00,$FB,$4D,$3D	; $85F690
	db $FF,$10,$CD,$F2,$C4,$F9,$84,$F8,$95,$EA,$83,$E8,$07,$EC,$0F,$E0	; $85F6A0
	db $2D,$C2,$FC,$80,$D2,$C5,$49,$00,$F8,$4B,$09,$62,$C0,$82,$3C,$10	; $85F6B0
	db $3E,$1D,$7E,$06,$7F,$20,$07,$7F,$2D,$20,$B3,$13,$3F,$FF,$7F,$49	; $85F6C0
	db $85,$FE,$00,$0C,$80,$91,$14,$63,$53,$E2,$DA,$48,$50,$67,$9F,$82	; $85F6D0
	db $7A,$B1,$79,$44,$38,$FF,$FF,$BC,$FF,$3D,$FF,$BF,$80,$3A,$00,$FD	; $85F6E0
	db $80,$48,$40,$11,$60,$1F,$10,$3F,$80,$AF,$B1,$8F,$10,$0F,$18,$0F	; $85F6F0
	db $E2,$E7,$2C,$26,$E0,$FF,$48,$00,$70,$49,$00,$F0,$49,$07,$18,$FF	; $85F700
	db $D9,$FF,$07,$EF,$CF,$9F,$E0,$48,$00,$BF,$80,$58,$40,$30,$FF,$E3	; $85F710
	db $54,$81,$64,$44,$09,$A4,$FF,$8A,$DF,$DE,$FF,$CF,$EF,$E7,$FF,$4A	; $85F720
	db $02,$EB,$FF,$C0,$E1,$3E,$82,$3E,$4C,$12,$1A,$DC,$65,$FA,$A9,$F2	; $85F730
	db $E3,$E4,$15,$F7,$98,$FB,$C0,$B8,$19,$E4,$3F,$FF,$1C,$49,$1E,$18	; $85F740
	db $FF,$08,$FF,$04,$FF,$07,$FF,$03,$FF,$F9,$C8,$BA,$B8,$10,$16,$90	; $85F750
	db $2F,$DB,$BD,$F2,$BF,$E9,$7E,$5B,$34,$07,$FF,$47,$FF,$6F,$80,$5E	; $85F760
	db $02,$7E,$FF,$7C,$E2,$44,$0F,$B2,$7C,$20,$7E,$2A,$CC,$3A,$24,$8C	; $85F770
	db $32,$1E,$21,$E2,$18,$D1,$5A,$81,$F4,$00,$F0,$80,$66,$20,$4B,$07	; $85F780
	db $20,$FF,$17,$3F,$37,$0F,$33,$07,$48,$00,$1B,$68,$06,$0F,$13,$A7	; $85F790
	db $A9,$53,$0F,$FF,$4C,$00,$07,$4D,$02,$FC,$FC,$FE,$C0,$04,$FB,$FE	; $85F7A0
	db $F9,$FF,$FC,$82,$EF,$73,$82,$09,$38,$FF,$E2,$4A,$00,$3F,$60,$01	; $85F7B0
	db $80,$9F,$20,$00,$0F,$E3,$D4,$00,$1F,$80,$62,$40,$58,$48,$01,$F5	; $85F7C0
	db $F9,$48,$00,$05,$49,$07,$1D,$E1,$3F,$C3,$01,$C1,$01,$81,$81,$3E	; $85F7D0
	db $4A,$04,$1E,$FF,$3C,$FF,$3E,$80,$A6,$01,$78,$B0,$4B,$0A,$B7,$7F	; $85F7E0
	db $B0,$7F,$BF,$60,$80,$60,$87,$78,$FF,$4C,$00,$7F,$49,$00,$40,$49	; $85F7F0
	db $01,$01,$07,$48,$01,$05,$FB,$D4,$05,$E1,$0F,$E1,$CF,$01,$0F,$78	; $85F800
	db $83,$B8,$48,$00,$E0,$49,$7A,$03,$47,$3F,$47,$3B,$4A,$05,$77,$0B	; $85F810
	db $F7,$8B,$07,$0B,$48,$01,$E7,$FF,$48,$00,$F7,$4B,$00,$77,$6B,$00	; $85F820
	db $FB,$4B,$00,$FA,$49,$81,$0E,$00,$F0,$3E,$FF,$03,$4C,$83,$19,$9C	; $85F830
	db $20,$04,$9F,$12,$AD,$36,$89,$58,$01,$13,$EC,$20,$01,$DF,$F8,$82	; $85F840
	db $5A,$81,$BA,$C7,$13,$FF,$97,$07,$12,$C0,$47,$80,$A9,$46,$21,$C0	; $85F850
	db $30,$C8,$7A,$80,$07,$FC,$08,$FF,$0F,$4D,$00,$07,$49,$12,$03,$FF	; $85F860
	db $F7,$0C,$FA,$1C,$E6,$08,$FA,$0B,$B3,$07,$7B,$05,$FD,$05,$FB,$02	; $85F870
	db $FF,$20,$00,$E7,$20,$00,$F7,$49,$00,$FB,$4B,$12,$FC,$01,$D7,$0B	; $85F880
	db $AE,$1A,$D7,$39,$73,$ED,$FA,$C5,$FD,$82,$3F,$F0,$07,$FC,$FD,$80	; $85F890
	db $14,$07,$F9,$06,$F1,$0F,$E1,$1F,$C0,$3F,$82,$CA,$28,$31,$80,$60	; $85F8A0
	db $85,$E0,$48,$01,$80,$7F,$C4,$CD,$2C,$00,$03,$C0,$E7,$18,$49,$0D	; $85F8B0
	db $03,$FD,$1C,$14,$0A,$0A,$0C,$08,$06,$04,$03,$02,$01,$01,$21,$0D	; $85F8C0
	db $72,$8C,$1B,$E0,$0D,$F0,$0F,$F0,$07,$F8,$03,$FC,$01,$FE,$20,$12	; $85F8D0
	db $FF,$C2,$FF,$AF,$D0,$C9,$F0,$EB,$F0,$AB,$B4,$A8,$B7,$5C,$53,$6E	; $85F8E0
	db $EF,$27,$A3,$83,$38,$00,$40,$49,$16,$A0,$FF,$90,$FF,$DC,$FF,$8B	; $85F8F0
	db $D4,$C1,$BE,$8C,$32,$C5,$3A,$F2,$0D,$21,$DE,$46,$B9,$02,$FD,$60	; $85F900
	db $E7,$18,$4B,$0F,$77,$F8,$58,$87,$CD,$02,$C2,$15,$D0,$2E,$71,$8C	; $85F910
	db $22,$D9,$C9,$36,$85,$18,$00,$01,$80,$FC,$1F,$07,$FF,$0F,$FF,$61	; $85F920
	db $9F,$01,$E7,$11,$C7,$BD,$8B,$AF,$43,$1B,$C7,$A7,$1F,$3F,$6F,$03	; $85F930
	db $FF,$1B,$FF,$3B,$FF,$73,$FF,$F7,$FF,$EF,$FF,$02,$CF,$FF,$9F,$58	; $85F940
	db $41,$20,$49,$62,$21,$01,$80,$0F,$8B,$C0,$00,$80,$32,$FF,$E1,$4C	; $85F950
	db $E1,$AD,$20,$00,$07,$81,$B4,$89,$02,$03,$01,$FF,$60,$80,$4A,$02	; $85F960
	db $40,$A0,$E0,$20,$48,$00,$C0,$48,$00,$07,$81,$9E,$4A,$00,$C0,$4D	; $85F970
	db $01,$1B,$07,$48,$04,$19,$07,$10,$0F,$1F,$20,$48,$22,$EB,$32,$49	; $85F980
	db $01,$F7,$FB,$48,$0C,$07,$FB,$0F,$F3,$EF,$17,$CF,$37,$1F,$67,$3F	; $85F990
	db $CF,$07,$80,$B6,$81,$B8,$4A,$08,$1F,$FF,$3F,$FF,$FB,$FC,$F8,$FF	; $85F9A0
	db $FE,$3F,$FF,$47,$12,$25,$31,$EC,$3B,$78,$8B,$E0,$FD,$F0,$F8,$FB	; $85F9B0
	db $FC,$FD,$FE,$FC,$FE,$CE,$FF,$C7,$80,$DC,$00,$FB,$36,$FF,$0C,$B3	; $85F9C0
	db $D0,$48,$A1,$25,$D8,$02,$FD,$58,$27,$02,$01,$86,$E0,$BF,$02,$0F	; $85F9D0
	db $FF,$DF,$3A,$FF,$01,$FB,$02,$48,$05,$4F,$B3,$F9,$81,$83,$C3,$C0	; $85F9E0
	db $05,$E6,$86,$F8,$08,$FC,$01,$49,$20,$00,$FE,$C4,$80,$9D,$13,$FE	; $85F9F0
	db $01,$F8,$07,$01,$FF,$C0,$3F,$F0,$0F,$FC,$03,$FE,$41,$7F,$F0,$9F	; $85FA00
	db $98,$CF,$AC,$87,$BA,$1D,$80,$FF,$E0,$FF,$90,$FF,$C0,$40,$60,$A0	; $85FA10
	db $70,$90,$B6,$CF,$43,$FC,$81,$7E,$C8,$3F,$F1,$0F,$40,$FF,$60,$DF	; $85FA20
	db $30,$EF,$1F,$FB,$86,$28,$20,$0B,$01,$01,$7A,$7D,$73,$8C,$80,$7F	; $85FA30
	db $E0,$1F,$FC,$03,$C8,$20,$05,$FF,$01,$FE,$7E,$8F,$C0,$86,$46,$11	; $85FA40
	db $1B,$1C,$AF,$D0,$01,$7E,$80,$6F,$70,$8D,$1C,$E3,$07,$F8,$80,$7F	; $85FA50
	db $1E,$EF,$E1,$56,$02,$10,$FF,$02,$84,$20,$03,$C1,$3E,$E0,$1F,$70	; $85FA60
	db $81,$38,$20,$04,$BF,$80,$7B,$F8,$06,$E0,$3E,$4D,$12,$40,$FF,$04	; $85FA70
	db $FF,$01,$FF,$9C,$DC,$4B,$EF,$6B,$FB,$78,$F0,$78,$FC,$7E,$FF,$7F	; $85FA80
	db $49,$04,$E3,$FF,$F0,$FF,$F4,$39,$FF,$0D,$FE,$7F,$7F,$F7,$F7,$FE	; $85FA90
	db $FE,$3A,$3E,$DE,$5F,$82,$FC,$FE,$82,$B8,$00,$08,$80,$38,$02,$C1	; $85FAA0
	db $FF,$A0,$32,$FF,$14,$12,$CB,$A8,$97,$35,$06,$E0,$07,$61,$06,$8E	; $85FAB0
	db $8D,$0B,$F7,$1F,$FF,$3C,$FF,$78,$FF,$F8,$49,$04,$F9,$FF,$73,$FF	; $85FAC0
	db $0F,$30,$FF,$04,$6F,$9F,$5F,$FF,$BF,$48,$81,$5B,$43,$00,$3F,$49	; $85FAD0
	db $84,$0B,$43,$01,$C0,$1F,$80,$51,$89,$10,$3C,$FF,$01,$03,$FC,$80	; $85FAE0
	db $6D,$89,$10,$ED,$12,$00,$9F,$9D,$BF,$01,$7F,$9F,$E5,$71,$E5,$70	; $85FAF0
	db $3B,$FF,$03,$1B,$98,$84,$FB,$39,$FF,$00,$E7,$3C,$FF,$00,$1F,$8A	; $85FB00
	db $3E,$3F,$FF,$1F,$07,$77,$61,$59,$50,$6E,$30,$2F,$28,$37,$14,$1B	; $85FB10
	db $19,$1E,$06,$07,$48,$FF,$46,$FF,$61,$BF,$20,$FF,$30,$DF,$18,$FF	; $85FB20
	db $1E,$EF,$07,$FB,$E0,$BF,$06,$80,$7F,$60,$3F,$BC,$07,$E7,$20,$00	; $85FB30
	db $FE,$20,$02,$FF,$70,$8F,$58,$48,$04,$80,$FF,$40,$FF,$18,$80,$D7	; $85FB40
	db $81,$0A,$06,$79,$FE,$0F,$FF,$CF,$3F,$F0,$D0,$06,$81,$7F,$78,$0F	; $85FB50
	db $CE,$03,$FB,$81,$20,$4C,$10,$80,$FF,$30,$FF,$04,$FF,$E0,$1F,$7E	; $85FB60
	db $81,$C7,$F8,$F1,$FE,$1C,$FF,$C7,$80,$26,$01,$F4,$0C,$87,$20,$4A	; $85FB70
	db $03,$1C,$FB,$0F,$F0,$68,$09,$C0,$3F,$F1,$0E,$3D,$C3,$B4,$CC,$A0	; $85FB80
	db $60,$22,$82,$18,$07,$01,$FF,$07,$FE,$1C,$FB,$E0,$DF,$20,$80,$F0	; $85FB90
	db $4A,$9B,$80,$01,$7F,$7F,$2D,$00,$7F,$82,$A2,$4F,$30,$FF,$2D,$EC	; $85FBA0
	db $10,$01,$FF,$3F,$9C,$5B,$42,$E0,$00	; $85FBB0
CODE_85FBB9:		; M=16 X=16
	lda.b $C7		; $85FBB9: A5 C7
	beq CODE_85FBC1		; $85FBBB: F0 04
	jml.l $87D1FE		; $85FBBD: 5C FE D1 87
CODE_85FBC1:		; M=16 X=16
	lda.b $0D		; $85FBC1: A5 0D
	sta.b $10		; $85FBC3: 85 10
	lda.b $0C		; $85FBC5: A5 0C
	clc		; $85FBC7: 18
	adc.w #$0200		; $85FBC8: 69 00 02
	sta.b $0F		; $85FBCB: 85 0F
	lda.b $A5		; $85FBCD: A5 A5
	beq CODE_85FBD6		; $85FBCF: F0 05
	lda.w #$0040		; $85FBD1: A9 40 00
	sta.b $A5		; $85FBD4: 85 A5
CODE_85FBD6:		; M=16 X=16
	lda.b $C3		; $85FBD6: A5 C3
	asl a		; $85FBD8: 0A
	adc.w #$000A		; $85FBD9: 69 0A 00
	tay		; $85FBDC: A8
	lda.b [$0C],y		; $85FBDD: B7 0C
	sta.b $C3		; $85FBDF: 85 C3
	iny		; $85FBE1: C8
	iny		; $85FBE2: C8
	lda.b [$0C],y		; $85FBE3: B7 0C
	sec		; $85FBE5: 38
	sbc.b $C3		; $85FBE6: E5 C3
	bne CODE_85FBEE		; $85FBE8: D0 04
	jml.l $87D1FE		; $85FBEA: 5C FE D1 87
CODE_85FBEE:		; M=16 X=16
	sta.w $0487		; $85FBEE: 8D 87 04
CODE_85FBF1:		; M=16 X=16
	lda.b $A9		; $85FBF1: A5 A9
	cmp.w #$0080		; $85FBF3: C9 80 00
	bne CODE_85FBFC		; $85FBF6: D0 04
	jml.l $87D1FE		; $85FBF8: 5C FE D1 87
CODE_85FBFC:		; M=16 X=16
	lda.b $C3		; $85FBFC: A5 C3
	asl a		; $85FBFE: 0A
	asl a		; $85FBFF: 0A
	adc.b $C3		; $85FC00: 65 C3
	adc.b $C3		; $85FC02: 65 C3
	ldy.w #$0006		; $85FC04: A0 06 00
	adc.b [$0C],y		; $85FC07: 77 0C
	tay		; $85FC09: A8
	lda.b [$0C],y		; $85FC0A: B7 0C
	sta.b $BD		; $85FC0C: 85 BD
	iny		; $85FC0E: C8
	iny		; $85FC0F: C8
	lda.b [$0C],y		; $85FC10: B7 0C
	clc		; $85FC12: 18
	adc.b $CB		; $85FC13: 65 CB
	sta.b $BF		; $85FC15: 85 BF
	iny		; $85FC17: C8
	iny		; $85FC18: C8
	lda.b [$0C],y		; $85FC19: B7 0C
	and.w #$03FF		; $85FC1B: 29 FF 03
	asl a		; $85FC1E: 0A
	asl a		; $85FC1F: 0A
	asl a		; $85FC20: 0A
	asl a		; $85FC21: 0A
	asl a		; $85FC22: 0A
	sta.b $B9		; $85FC23: 85 B9
	iny		; $85FC25: C8
	lda.b [$0C],y		; $85FC26: B7 0C
	tax		; $85FC28: AA
	lsr a		; $85FC29: 4A
	lsr a		; $85FC2A: 4A
	clc		; $85FC2B: 18
	adc.b $AB		; $85FC2C: 65 AB
	and.w #$0007		; $85FC2E: 29 07 00
	asl a		; $85FC31: 0A
	sta.b $AD		; $85FC32: 85 AD
	cmp.w #$0004		; $85FC34: C9 04 00
	bne CODE_85FC42		; $85FC37: D0 09
	lda.b $AB		; $85FC39: A5 AB
	bpl CODE_85FC42		; $85FC3B: 10 05
	lda.w #$0006		; $85FC3D: A9 06 00
	sta.b $AD		; $85FC40: 85 AD
CODE_85FC42:		; M=16 X=16
	txa		; $85FC42: 8A
	and.w #$00C0		; $85FC43: 29 C0 00
	sta.b $AF		; $85FC46: 85 AF
	txa		; $85FC48: 8A
	and.w #$0020		; $85FC49: 29 20 00
	beq CODE_85FC51		; $85FC4C: F0 03
	jmp.w $FD7D		; $85FC4E: 4C 7D FD
CODE_85FC51:		; M=16 X=16
	lda.b $A5		; $85FC51: A5 A5
	beq CODE_85FC61		; $85FC53: F0 0C
	lda.b $BD		; $85FC55: A5 BD
	eor.w #$FFFF		; $85FC57: 49 FF FF
	inc a		; $85FC5A: 1A
	sec		; $85FC5B: 38
	sbc.w #$0007		; $85FC5C: E9 07 00
	sta.b $BD		; $85FC5F: 85 BD
CODE_85FC61:		; M=16 X=16
	lda.b $C9		; $85FC61: A5 C9
	clc		; $85FC63: 18
	adc.b $BD		; $85FC64: 65 BD
	sta.b $BD		; $85FC66: 85 BD
	sec		; $85FC68: 38
	sbc.w #$FFF9		; $85FC69: E9 F9 FF
	bmi CODE_85FC73		; $85FC6C: 30 05
	bvc CODE_85FC75		; $85FC6E: 50 05
CODE_85FC70:		; M=16 X=16
	jmp.w $FEFD		; $85FC70: 4C FD FE
CODE_85FC73:		; M=16 X=16
	bvc CODE_85FC70		; $85FC73: 50 FB
CODE_85FC75:		; M=16 X=16
	lda.b $BD		; $85FC75: A5 BD
	sec		; $85FC77: 38
	sbc.w #$00FF		; $85FC78: E9 FF 00
	beq CODE_85FC86		; $85FC7B: F0 09
	bmi CODE_85FC84		; $85FC7D: 30 05
	bvs CODE_85FC86		; $85FC7F: 70 05
CODE_85FC81:		; M=16 X=16
	jmp.w $FEFD		; $85FC81: 4C FD FE
CODE_85FC84:		; M=16 X=16
	bvs CODE_85FC81		; $85FC84: 70 FB
CODE_85FC86:		; M=16 X=16
	lda.b $BF		; $85FC86: A5 BF
	sec		; $85FC88: 38
	sbc.w #$FFF9		; $85FC89: E9 F9 FF
	bmi CODE_85FC93		; $85FC8C: 30 05
	bvc CODE_85FC95		; $85FC8E: 50 05
CODE_85FC90:		; M=16 X=16
	jmp.w $FEFD		; $85FC90: 4C FD FE
CODE_85FC93:		; M=16 X=16
	bvc CODE_85FC90		; $85FC93: 50 FB
CODE_85FC95:		; M=16 X=16
	lda.b $BF		; $85FC95: A5 BF
	sec		; $85FC97: 38
	sbc.w #$00DF		; $85FC98: E9 DF 00
	beq CODE_85FCA6		; $85FC9B: F0 09
	bmi CODE_85FCA4		; $85FC9D: 30 05
	bvs CODE_85FCA6		; $85FC9F: 70 05
CODE_85FCA1:		; M=16 X=16
	jmp.w $FEFD		; $85FCA1: 4C FD FE
CODE_85FCA4:		; M=16 X=16
	bvs CODE_85FCA1		; $85FCA4: 70 FB
CODE_85FCA6:		; M=16 X=16
	lda.b $C3		; $85FCA6: A5 C3
	clc		; $85FCA8: 18
	adc.b $C5		; $85FCA9: 65 C5
	cmp.w #$131D		; $85FCAB: C9 1D 13
CODE_85FCAE:		; M=16 X=16
	bcs CODE_85FCAE		; $85FCAE: B0 FE
	asl a		; $85FCB0: 0A
	asl a		; $85FCB1: 0A
	tax		; $85FCB2: AA
	lda.b $A7		; $85FCB3: A5 A7
	sec		; $85FCB5: 38
	sbc.l $7E2000,x		; $85FCB6: FF 00 20 7E
	cmp.b $C1		; $85FCBA: C5 C1
	bcc CODE_85FD15		; $85FCBC: 90 57
CODE_85FCBE:		; M=16 X=16
	lda.b $B5		; $85FCBE: A5 B5
	inc a		; $85FCC0: 1A
	and.w #$01FF		; $85FCC1: 29 FF 01
	sta.b $B5		; $85FCC4: 85 B5
	cmp.b $B7		; $85FCC6: C5 B7
	bne CODE_85FCCE		; $85FCC8: D0 04
	jml.l $8FDAF3		; $85FCCA: 5C F3 DA 8F
CODE_85FCCE:		; M=16 X=16
	asl a		; $85FCCE: 0A
	tax		; $85FCCF: AA
	lda.b $A7		; $85FCD0: A5 A7
	sec		; $85FCD2: 38
	sbc.w $04AB,x		; $85FCD3: FD AB 04
	cmp.b $C1		; $85FCD6: C5 C1
	bcc CODE_85FCBE		; $85FCD8: 90 E4
	txa		; $85FCDA: 8A
	asl a		; $85FCDB: 0A
	asl a		; $85FCDC: 0A
	asl a		; $85FCDD: 0A
	adc.w #$6000		; $85FCDE: 69 00 60
	ldx.b $A3		; $85FCE1: A6 A3
CODE_85FCE3:		; M=16 X=16
	cpx.w #$0578		; $85FCE3: E0 78 05
	bcs CODE_85FCE3		; $85FCE6: B0 FB
	sta.w $1658,x		; $85FCE8: 9D 58 16
	lda.b $0E		; $85FCEB: A5 0E
	sta.w $1655,x		; $85FCED: 9D 55 16
	ldy.w #$0008		; $85FCF0: A0 08 00
	lda.b [$0C],y		; $85FCF3: B7 0C
	adc.b $B9		; $85FCF5: 65 B9
	adc.b $0C		; $85FCF7: 65 0C
	sta.w $1653,x		; $85FCF9: 9D 53 16
	lda.w #$0020		; $85FCFC: A9 20 00
	sta.w $1656,x		; $85FCFF: 9D 56 16
	txa		; $85FD02: 8A
	adc.w #$0007		; $85FD03: 69 07 00
	sta.b $A3		; $85FD06: 85 A3
	lda.b $C3		; $85FD08: A5 C3
	adc.b $C5		; $85FD0A: 65 C5
	asl a		; $85FD0C: 0A
	asl a		; $85FD0D: 0A
	tax		; $85FD0E: AA
	lda.b $B5		; $85FD0F: A5 B5
	sta.l $7E2002,x		; $85FD11: 9F 02 20 7E
CODE_85FD15:		; M=16 X=16
	lda.b $A7		; $85FD15: A5 A7
	sta.l $7E2000,x		; $85FD17: 9F 00 20 7E
	lda.l $7E2002,x		; $85FD1B: BF 02 20 7E
	sta.b $B9		; $85FD1F: 85 B9
	asl a		; $85FD21: 0A
	tax		; $85FD22: AA
	lda.b $A7		; $85FD23: A5 A7
	sta.w $04AB,x		; $85FD25: 9D AB 04
	lda.b $A9		; $85FD28: A5 A9
	asl a		; $85FD2A: 0A
	asl a		; $85FD2B: 0A
	tax		; $85FD2C: AA
	lda.b $BD		; $85FD2D: A5 BD
	sta.w $01FF,x		; $85FD2F: 9D FF 01
	lda.b $BF		; $85FD32: A5 BF
	sta.w $0200,x		; $85FD34: 9D 00 02
	lda.b $B9		; $85FD37: A5 B9
	sta.w $0201,x		; $85FD39: 9D 01 02
	xba		; $85FD3C: EB
	sep #$20		; $85FD3D: E2 20
	ora.b $AD		; $85FD3F: 05 AD
	ora.b $BB		; $85FD41: 05 BB
	ora.b $AF		; $85FD43: 05 AF
	eor.b $A5		; $85FD45: 45 A5
	sta.w $0202,x		; $85FD47: 9D 02 02
	rep #$30		; $85FD4A: C2 30
	lda.b $A9		; $85FD4C: A5 A9
	and.w #$0003		; $85FD4E: 29 03 00
	tax		; $85FD51: AA
	lda.l $85FD79,x		; $85FD52: BF 79 FD 85
	tay		; $85FD56: A8
	lda.b $A9		; $85FD57: A5 A9
	lsr a		; $85FD59: 4A
	lsr a		; $85FD5A: 4A
	tax		; $85FD5B: AA
	sep #$20		; $85FD5C: E2 20
	tya		; $85FD5E: 98
	and.w $03FF,x		; $85FD5F: 3D FF 03
	sta.w $03FF,x		; $85FD62: 9D FF 03
	lda.b $BE		; $85FD65: A5 BE
	bpl CODE_85FD72		; $85FD67: 10 09
	tya		; $85FD69: 98
	eor.b #$FF		; $85FD6A: 49 FF
	ora.w $03FF,x		; $85FD6C: 1D FF 03
	sta.w $03FF,x		; $85FD6F: 9D FF 03
CODE_85FD72:		; M=8 X=16
	rep #$30		; $85FD72: C2 30
	inc.b $A9		; $85FD74: E6 A9
	jmp.w $FEFD		; $85FD76: 4C FD FE
	db $FE,$FB,$EF,$BF	; $85FD79
CODE_85FD7D:		; M=16 X=16
	lda.b $A5		; $85FD7D: A5 A5
	beq CODE_85FD8D		; $85FD7F: F0 0C
	lda.b $BD		; $85FD81: A5 BD
	eor.w #$FFFF		; $85FD83: 49 FF FF
	inc a		; $85FD86: 1A
	sec		; $85FD87: 38
	sbc.w #$000F		; $85FD88: E9 0F 00
	sta.b $BD		; $85FD8B: 85 BD
CODE_85FD8D:		; M=16 X=16
	lda.b $C9		; $85FD8D: A5 C9
	clc		; $85FD8F: 18
	adc.b $BD		; $85FD90: 65 BD
	sta.b $BD		; $85FD92: 85 BD
	sec		; $85FD94: 38
	sbc.w #$FFF1		; $85FD95: E9 F1 FF
	bmi CODE_85FD9F		; $85FD98: 30 05
	bvc CODE_85FDA1		; $85FD9A: 50 05
CODE_85FD9C:		; M=16 X=16
	jmp.w $FEFD		; $85FD9C: 4C FD FE
CODE_85FD9F:		; M=16 X=16
	bvc CODE_85FD9C		; $85FD9F: 50 FB
CODE_85FDA1:		; M=16 X=16
	lda.b $BD		; $85FDA1: A5 BD
	sec		; $85FDA3: 38
	sbc.w #$00FF		; $85FDA4: E9 FF 00
	beq CODE_85FDB2		; $85FDA7: F0 09
	bmi CODE_85FDB0		; $85FDA9: 30 05
	bvs CODE_85FDB2		; $85FDAB: 70 05
CODE_85FDAD:		; M=16 X=16
	jmp.w $FEFD		; $85FDAD: 4C FD FE
CODE_85FDB0:		; M=16 X=16
	bvs CODE_85FDAD		; $85FDB0: 70 FB
CODE_85FDB2:		; M=16 X=16
	lda.b $BF		; $85FDB2: A5 BF
	sec		; $85FDB4: 38
	sbc.w #$FFF1		; $85FDB5: E9 F1 FF
	bmi CODE_85FDBF		; $85FDB8: 30 05
	bvc CODE_85FDC1		; $85FDBA: 50 05
CODE_85FDBC:		; M=16 X=16
	jmp.w $FEFD		; $85FDBC: 4C FD FE
CODE_85FDBF:		; M=16 X=16
	bvc CODE_85FDBC		; $85FDBF: 50 FB
CODE_85FDC1:		; M=16 X=16
	lda.b $BF		; $85FDC1: A5 BF
	sec		; $85FDC3: 38
	sbc.w #$00DF		; $85FDC4: E9 DF 00
	beq CODE_85FDD2		; $85FDC7: F0 09
	bmi CODE_85FDD0		; $85FDC9: 30 05
	bvs CODE_85FDD2		; $85FDCB: 70 05
CODE_85FDCD:		; M=16 X=16
	jmp.w $FEFD		; $85FDCD: 4C FD FE
CODE_85FDD0:		; M=16 X=16
	bvs CODE_85FDCD		; $85FDD0: 70 FB
CODE_85FDD2:		; M=16 X=16
	lda.b $C3		; $85FDD2: A5 C3
	clc		; $85FDD4: 18
	adc.b $C5		; $85FDD5: 65 C5
	cmp.w #$131D		; $85FDD7: C9 1D 13
CODE_85FDDA:		; M=16 X=16
	bcs CODE_85FDDA		; $85FDDA: B0 FE
	asl a		; $85FDDC: 0A
	asl a		; $85FDDD: 0A
	tax		; $85FDDE: AA
	lda.b $A7		; $85FDDF: A5 A7
	sec		; $85FDE1: 38
	sbc.l $7E2000,x		; $85FDE2: FF 00 20 7E
	cmp.b $C1		; $85FDE6: C5 C1
	bcs CODE_85FDED		; $85FDE8: B0 03
	jmp.w $FE89		; $85FDEA: 4C 89 FE
CODE_85FDED:		; M=16 X=16
	lda.b $B1		; $85FDED: A5 B1
	inc a		; $85FDEF: 1A
	and.w #$01FF		; $85FDF0: 29 FF 01
	sta.b $B1		; $85FDF3: 85 B1
	cmp.b $B3		; $85FDF5: C5 B3
	bne CODE_85FDFD		; $85FDF7: D0 04
	jml.l $8FDAF3		; $85FDF9: 5C F3 DA 8F
CODE_85FDFD:		; M=16 X=16
	and.w #$000F		; $85FDFD: 29 0F 00
	cmp.w #$000F		; $85FE00: C9 0F 00
	beq CODE_85FDED		; $85FE03: F0 E8
	lda.b $B1		; $85FE05: A5 B1
	and.w #$00F0		; $85FE07: 29 F0 00
	cmp.w #$00F0		; $85FE0A: C9 F0 00
	beq CODE_85FDED		; $85FE0D: F0 DE
	lda.b $B1		; $85FE0F: A5 B1
	asl a		; $85FE11: 0A
	tax		; $85FE12: AA
	lda.b $A7		; $85FE13: A5 A7
	sec		; $85FE15: 38
	sbc.w $04AB,x		; $85FE16: FD AB 04
	cmp.b $C1		; $85FE19: C5 C1
	bcc CODE_85FDED		; $85FE1B: 90 D0
	lda.b $A7		; $85FE1D: A5 A7
	sec		; $85FE1F: 38
	sbc.w $04AD,x		; $85FE20: FD AD 04
	cmp.b $C1		; $85FE23: C5 C1
	bcc CODE_85FDED		; $85FE25: 90 C6
	lda.b $A7		; $85FE27: A5 A7
	sec		; $85FE29: 38
	sbc.w $04CB,x		; $85FE2A: FD CB 04
	cmp.b $C1		; $85FE2D: C5 C1
	bcc CODE_85FDED		; $85FE2F: 90 BC
	lda.b $A7		; $85FE31: A5 A7
	sec		; $85FE33: 38
	sbc.w $04CD,x		; $85FE34: FD CD 04
	cmp.b $C1		; $85FE37: C5 C1
	bcc CODE_85FDED		; $85FE39: 90 B2
	txa		; $85FE3B: 8A
	asl a		; $85FE3C: 0A
	asl a		; $85FE3D: 0A
	asl a		; $85FE3E: 0A
	adc.w #$6000		; $85FE3F: 69 00 60
	ldx.b $A3		; $85FE42: A6 A3
CODE_85FE44:		; M=16 X=16
	cpx.w #$0571		; $85FE44: E0 71 05
	bcs CODE_85FE44		; $85FE47: B0 FB
	sta.w $1658,x		; $85FE49: 9D 58 16
	adc.w #$0100		; $85FE4C: 69 00 01
	sta.w $165F,x		; $85FE4F: 9D 5F 16
	lda.b $0E		; $85FE52: A5 0E
	sta.w $1655,x		; $85FE54: 9D 55 16
	sta.w $165C,x		; $85FE57: 9D 5C 16
	lda.w #$0040		; $85FE5A: A9 40 00
	sta.w $1656,x		; $85FE5D: 9D 56 16
	sta.w $165D,x		; $85FE60: 9D 5D 16
	ldy.w #$0008		; $85FE63: A0 08 00
	lda.b [$0C],y		; $85FE66: B7 0C
	adc.b $B9		; $85FE68: 65 B9
	adc.b $0C		; $85FE6A: 65 0C
	sta.w $1653,x		; $85FE6C: 9D 53 16
	adc.w #$0200		; $85FE6F: 69 00 02
	sta.w $165A,x		; $85FE72: 9D 5A 16
	txa		; $85FE75: 8A
	adc.w #$000E		; $85FE76: 69 0E 00
	sta.b $A3		; $85FE79: 85 A3
	lda.b $C3		; $85FE7B: A5 C3
	clc		; $85FE7D: 18
	adc.b $C5		; $85FE7E: 65 C5
	asl a		; $85FE80: 0A
	asl a		; $85FE81: 0A
	tax		; $85FE82: AA
	lda.b $B1		; $85FE83: A5 B1
	sta.l $7E2002,x		; $85FE85: 9F 02 20 7E
CODE_85FE89:		; M=16 X=16
	lda.b $A7		; $85FE89: A5 A7
	sta.l $7E2000,x		; $85FE8B: 9F 00 20 7E
	lda.l $7E2002,x		; $85FE8F: BF 02 20 7E
	sta.b $B9		; $85FE93: 85 B9
	asl a		; $85FE95: 0A
	tax		; $85FE96: AA
	lda.b $A7		; $85FE97: A5 A7
	sta.w $04AB,x		; $85FE99: 9D AB 04
	sta.w $04AD,x		; $85FE9C: 9D AD 04
	sta.w $04CB,x		; $85FE9F: 9D CB 04
	sta.w $04CD,x		; $85FEA2: 9D CD 04
	lda.b $A9		; $85FEA5: A5 A9
	asl a		; $85FEA7: 0A
	asl a		; $85FEA8: 0A
	tax		; $85FEA9: AA
	lda.b $BD		; $85FEAA: A5 BD
	sta.w $01FF,x		; $85FEAC: 9D FF 01
	lda.b $BF		; $85FEAF: A5 BF
	sta.w $0200,x		; $85FEB1: 9D 00 02
	lda.b $B9		; $85FEB4: A5 B9
	sta.w $0201,x		; $85FEB6: 9D 01 02
	xba		; $85FEB9: EB
	sep #$20		; $85FEBA: E2 20
	ora.b $AD		; $85FEBC: 05 AD
	ora.b $BB		; $85FEBE: 05 BB
	ora.b $AF		; $85FEC0: 05 AF
	eor.b $A5		; $85FEC2: 45 A5
	sta.w $0202,x		; $85FEC4: 9D 02 02
	rep #$30		; $85FEC7: C2 30
	lda.b $A9		; $85FEC9: A5 A9
	and.w #$0003		; $85FECB: 29 03 00
	tax		; $85FECE: AA
	lda.l $85FD79,x		; $85FECF: BF 79 FD 85
	tay		; $85FED3: A8
	lda.b $A9		; $85FED4: A5 A9
	lsr a		; $85FED6: 4A
	lsr a		; $85FED7: 4A
	tax		; $85FED8: AA
	sep #$20		; $85FED9: E2 20
	tya		; $85FEDB: 98
	and.w $03FF,x		; $85FEDC: 3D FF 03
	sta.w $03FF,x		; $85FEDF: 9D FF 03
	tya		; $85FEE2: 98
	eor.b #$FF		; $85FEE3: 49 FF
	asl a		; $85FEE5: 0A
	ora.w $03FF,x		; $85FEE6: 1D FF 03
	sta.w $03FF,x		; $85FEE9: 9D FF 03
	lda.b $BE		; $85FEEC: A5 BE
	bpl CODE_85FEF9		; $85FEEE: 10 09
	tya		; $85FEF0: 98
	eor.b #$FF		; $85FEF1: 49 FF
	ora.w $03FF,x		; $85FEF3: 1D FF 03
	sta.w $03FF,x		; $85FEF6: 9D FF 03
CODE_85FEF9:		; M=8 X=16
	rep #$30		; $85FEF9: C2 30
	inc.b $A9		; $85FEFB: E6 A9
CODE_85FEFD:		; M=16 X=16
	inc.b $C3		; $85FEFD: E6 C3
	dec.w $0487		; $85FEFF: CE 87 04
	beq CODE_85FF07		; $85FF02: F0 03
	jmp.w $FBF1		; $85FF04: 4C F1 FB
CODE_85FF07:		; M=16 X=16
	stz.b $A5		; $85FF07: 64 A5
	stz.b $CD		; $85FF09: 64 CD
	stz.b $AB		; $85FF0B: 64 AB
	rtl		; $85FF0D: 6B
	db $AD,$8C,$12,$89,$02,$00,$F0,$04,$5C,$29,$C4,$80,$5C,$0B,$C4,$80	; $85FF0E
CODE_85FF1E:		; M=16 X=16
	stx.b $0A		; $85FF1E: 86 0A
	ldx.w #$0000		; $85FF20: A2 00 00
CODE_85FF23:		; M=16 X=16
	lda.b $53,x		; $85FF23: B5 53
	pha		; $85FF25: 48
	inx		; $85FF26: E8
	inx		; $85FF27: E8
	cpx.w #$0020		; $85FF28: E0 20 00
	bne CODE_85FF23		; $85FF2B: D0 F6
	ldx.b $0A		; $85FF2D: A6 0A
	stx.b $0A		; $85FF2F: 86 0A
	ldx.w #$0000		; $85FF31: A2 00 00
CODE_85FF34:		; M=16 X=16
	lda.b $33,x		; $85FF34: B5 33
	pha		; $85FF36: 48
	inx		; $85FF37: E8
	inx		; $85FF38: E8
	cpx.w #$000C		; $85FF39: E0 0C 00
	bne CODE_85FF34		; $85FF3C: D0 F6
	ldx.b $0A		; $85FF3E: A6 0A
	lda.w $1600		; $85FF40: AD 00 16
	bne CODE_85FF51		; $85FF43: D0 0C
	lda.w $1604		; $85FF45: AD 04 16
	sta.w $129A		; $85FF48: 8D 9A 12
	lda.w $1606		; $85FF4B: AD 06 16
	sta.w $129C		; $85FF4E: 8D 9C 12
CODE_85FF51:		; M=16 X=16
	jsl.l $80B90C		; $85FF51: 22 0C B9 80
	ora.b $00		; $85FF55: 05 00
	ldx.w $0102,y		; $85FF57: BE 02 01
	lda.w $129C		; $85FF5A: AD 9C 12
	sta.b $57		; $85FF5D: 85 57
	jsl.l $8D84E2		; $85FF5F: 22 E2 84 8D
	jsl.l $80B90C		; $85FF63: 22 0C B9 80
	ora.b $00		; $85FF67: 05 00
	ldx.w $0115,y		; $85FF69: BE 15 01
	lda.w $129A		; $85FF6C: AD 9A 12
	sta.b $57		; $85FF6F: 85 57
	jsl.l $8D84E2		; $85FF71: 22 E2 84 8D
	jsl.l $86FC29		; $85FF75: 22 29 FC 86
	stx.b $0A		; $85FF79: 86 0A
	ldx.w #$000A		; $85FF7B: A2 0A 00
CODE_85FF7E:		; M=16 X=16
	pla		; $85FF7E: 68
	sta.b $33,x		; $85FF7F: 95 33
	dex		; $85FF81: CA
	dex		; $85FF82: CA
	bpl CODE_85FF7E		; $85FF83: 10 F9
	ldx.b $0A		; $85FF85: A6 0A
	stx.b $0A		; $85FF87: 86 0A
	ldx.w #$001E		; $85FF89: A2 1E 00
CODE_85FF8C:		; M=16 X=16
	pla		; $85FF8C: 68
	sta.b $53,x		; $85FF8D: 95 53
	dex		; $85FF8F: CA
	dex		; $85FF90: CA
	bpl CODE_85FF8C		; $85FF91: 10 F9
	ldx.b $0A		; $85FF93: A6 0A
	rtl		; $85FF95: 6B
CODE_85FF96:		; M=16 X=16
	rtl		; $85FF96: 6B
CODE_85FF97:		; M=16 X=16
	jsl.l $86FCA1		; $85FF97: 22 A1 FC 86
	lda.w $12F0		; $85FF9B: AD F0 12
	sec		; $85FF9E: 38
	sbc.w #$0003		; $85FF9F: E9 03 00
	bmi CODE_85FFA8		; $85FFA2: 30 04
	bvc CODE_85FFAA		; $85FFA4: 50 04
	bra CODE_85FFB4		; $85FFA6: 80 0C
CODE_85FFA8:		; M=16 X=16
	bvc CODE_85FFB4		; $85FFA8: 50 0A
CODE_85FFAA:		; M=16 X=16
	lda.w $1600		; $85FFAA: AD 00 16
	bne CODE_85FFB4		; $85FFAD: D0 05
	lda.w #$0258		; $85FFAF: A9 58 02
	sta.b $53		; $85FFB2: 85 53
CODE_85FFB4:		; M=16 X=16
	lda.b $53		; $85FFB4: A5 53
	sta.w $12F2		; $85FFB6: 8D F2 12
	sta.w $12F6		; $85FFB9: 8D F6 12
	sta.w $128A		; $85FFBC: 8D 8A 12
	rtl		; $85FFBF: 6B
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $85FFC0
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $85FFD0
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $85FFE0
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $85FFF0
