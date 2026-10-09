; $86F000-$86FFFF  ROM $37000  (from src/bank86.asm; quick pass, TODO segment agents refine)
org $86F000
	db $53,$55,$19,$AE,$36,$52,$EC,$E0,$8A,$00,$01,$42,$0E,$FF,$DD,$E0	; $86F000
	db $40,$9A,$02,$41,$DC,$C0,$21,$00,$00,$12,$8A,$2F,$DF,$01,$01,$11	; $86F010
	db $23,$1E,$BC,$8A,$05,$3F,$CD,$03,$32,$FD,$E2,$21,$AA,$FF,$FF,$EE	; $86F020
	db $03,$00,$03,$5E,$AA,$9A,$D4,$74,$20,$F0,$1F,$DD,$E0,$34,$9A,$42	; $86F030
	db $22,$0C,$D0,$23,$20,$FF,$0F,$8A,$D0,$12,$32,$0E,$FF,$EE,$F1,$2F	; $86F040
	db $8A,$25,$4E,$CB,$CF,$32,$00,$0F,$14,$8A,$40,$EE,$00,$02,$20,$12	; $86F050
	db $1F,$CC,$8A,$F4,$3F,$DD,$13,$32,$FC,$E2,$31,$AA,$FF,$FF,$ED,$04	; $86F060
	db $1F,$F4,$5E,$AA,$AA,$E2,$42,$10,$0F,$00,$FE,$F0,$22,$9A,$31,$33	; $86F070
	db $0C,$DF,$14,$21,$FF,$EF,$8A,$F1,$F2,$42,$FE,$F0,$EE,$12,$0F,$8A	; $86F080
	db $34,$0E,$DE,$F0,$01,$00,$F0,$24,$8A,$30,$0F,$FF,$12,$10,$12,$1F	; $86F090
	db $CC,$8A,$04,$2E,$DD,$14,$42,$FC,$D2,$31,$AA,$FF,$FF,$ED,$04,$0F	; $86F0A0
	db $04,$5E,$AA,$AA,$E2,$32,$11,$0F,$00,$FE,$E0,$22,$9A,$43,$21,$1D	; $86F0B0
	db $CF,$14,$21,$FF,$FE,$8A,$D1,$12,$32,$FE,$00,$FF,$10,$0F,$8A,$23	; $86F0C0
	db $1E,$FF,$FE,$11,$FF,$01,$24,$8A,$31,$FF,$F0,$02,$2F,$02,$2F,$CC	; $86F0D0
	db $8A,$F4,$3F,$CD,$14,$43,$EB,$D3,$41,$AA,$FF,$FF,$DD,$05,$0F,$04	; $86F0E0
	db $5E,$A9,$AA,$E2,$42,$20,$FF,$10,$EE,$F0,$22,$9A,$32,$32,$0D,$DE	; $86F0F0
	db $14,$30,$FF,$FE,$8A,$E1,$01,$42,$0E,$00,$FF,$00,$1F,$8A,$13,$1F	; $86F100
	db $F0,$EE,$01,$00,$F0,$25,$8A,$41,$FE,$F0,$11,$10,$12,$1F,$CC,$8A	; $86F110
	db $F4,$3F,$CD,$15,$42,$EB,$E2,$41,$AA,$FF,$FF,$DD,$05,$0F,$04,$5E	; $86F120
	db $A9,$AA,$D3,$42,$11,$0F,$0F,$FE,$F0,$22,$9A,$32,$23,$1C,$CF,$23	; $86F130
	db $21,$0E,$FE,$8A,$E0,$12,$32,$FF,$01,$EF,$01,$0E,$8A,$14,$2F,$EF	; $86F140
	db $FF,$00,$00,$F0,$25,$8A,$41,$FE,$F0,$12,$1F,$02,$2F,$CC,$8A,$03	; $86F150
	db $3F,$CC,$25,$42,$EB,$E2,$32,$AB,$FF,$FF,$DD,$14,$0F,$04,$6E,$99	; $86F160
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$B4,$FF,$4D,$32,$E1,$F4,$D0	; $86F170
	db $00,$C0,$C4,$3D,$02,$C0,$0F,$01,$0D,$13,$E0,$B4,$5F,$03,$14,$B2	; $86F180
	db $EE,$E1,$E1,$31,$B8,$20,$10,$D0,$E2,$B5,$ED,$4E,$11,$C4,$01,$44	; $86F190
	db $F2,$3F,$31,$FF,$11,$0F,$B4,$FE,$0F,$A0,$EA,$BF,$FF,$FF,$FF,$C4	; $86F1A0
	db $00,$11,$F4,$10,$21,$13,$10,$01,$B8,$00,$01,$01,$FC,$5E,$A6,$B4	; $86F1B0
	db $3B,$B4,$FF,$FF,$24,$11,$42,$E7,$40,$0F,$B4,$42,$0B,$F6,$1F,$ED	; $86F1C0
	db $ED,$C1,$11,$A0,$3C,$B2,$43,$2D,$B6,$52,$10,$EC,$B4,$00,$F3,$1E	; $86F1D0
	db $21,$00,$DA,$23,$DF,$B4,$3C,$F2,$CF,$22,$23,$FF,$1F,$01,$B4,$4C	; $86F1E0
	db $11,$FF,$21,$F3,$FC,$21,$CE,$B4,$CF,$3F,$0F,$00,$02,$1D,$64,$D4	; $86F1F0
	db $B4,$1F,$60,$B0,$FD,$2F,$CC,$43,$BF,$B4,$1F,$3C,$F3,$3C,$F2,$D3	; $86F200
	db $2F,$F2,$B4,$00,$61,$C0,$F4,$D1,$3D,$D3,$00,$B0,$EF,$41,$01,$13	; $86F210
	db $02,$4C,$C3,$2D,$B0,$C0,$EC,$F0,$DC,$32,$04,$33,$20,$C4,$15,$10	; $86F220
	db $FF,$1F,$FD,$00,$C1,$0E,$B4,$C1,$2F,$22,$FE,$21,$06,$FE,$40,$C4	; $86F230
	db $F2,$00,$3F,$E2,$0D,$11,$D0,$4C,$B4,$D4,$F0,$F1,$FE,$1E,$F0,$4E	; $86F240
	db $D2,$B4,$D4,$14,$00,$6E,$31,$CF,$FE,$07,$B4,$A0,$11,$EA,$4C,$00	; $86F250
	db $5B,$05,$C2,$C4,$E1,$31,$0E,$3D,$F5,$F0,$F1,$FE,$C4,$EF,$3F,$1D	; $86F260
	db $E3,$12,$FD,$41,$0E,$C0,$F1,$23,$0F,$E2,$2F,$01,$13,$1C,$B4,$43	; $86F270
	db $01,$CD,$63,$FE,$01,$6E,$B3,$C0,$13,$11,$12,$00,$EB,$21,$FD,$DF	; $86F280
	db $C4,$F0,$E0,$11,$0C,$41,$F1,$E1,$01,$C0,$1F,$11,$1F,$EE,$E2,$DC	; $86F290
	db $FF,$1E,$B4,$D0,$66,$EE,$D7,$29,$24,$32,$BD,$C0,$31,$35,$F1,$42	; $86F2A0
	db $E0,$EE,$31,$FE,$C0,$F0,$ED,$CF,$FD,$DD,$EF,$40,$15,$C4,$02,$D2	; $86F2B0
	db $FE,$2D,$21,$0D,$12,$0F,$B0,$04,$E2,$FD,$19,$9E,$C1,$10,$A2,$C4	; $86F2C0
	db $1F,$00,$2D,$20,$00,$3C,$C2,$01,$C0,$10,$E0,$2F,$DE,$F2,$ED,$D0	; $86F2D0
	db $1F,$C0,$FE,$35,$0C,$20,$13,$10,$20,$10,$C0,$01,$22,$E1,$11,$00	; $86F2E0
	db $2F,$14,$FF,$C0,$3D,$E4,$0C,$DF,$CD,$EB,$FF,$00,$C0,$1E,$E4,$F1	; $86F2F0
	db $44,$30,$10,$54,$22,$C4,$F3,$F0,$B1,$F1,$FB,$5F,$11,$E2,$C0,$1F	; $86F300
	db $CF,$00,$32,$24,$2F,$33,$F5,$C4,$0F,$1F,$1E,$D3,$E0,$FF,$F5,$CC	; $86F310
	db $C4,$32,$EF,$3B,$16,$CC,$25,$1E,$0F,$C4,$11,$2C,$13,$F3,$C2,$D0	; $86F320
	db $4D,$F0,$B4,$CF,$0F,$4D,$2D,$B3,$E1,$40,$1E,$C4,$10,$0D,$22,$D4	; $86F330
	db $E0,$C2,$3E,$3F,$C4,$01,$B2,$10,$2F,$5D,$D2,$1F,$10,$C0,$11,$40	; $86F340
	db $DF,$DE,$52,$CE,$0E,$FE,$C0,$C1,$40,$BC,$2F,$F0,$02,$40,$AD,$C4	; $86F350
	db $33,$19,$14,$0E,$03,$04,$DD,$22,$C4,$2F,$EF,$F2,$FC,$30,$F0,$F1	; $86F360
	db $FF,$B4,$3C,$43,$FD,$F6,$1D,$D0,$61,$AF,$C0,$F1,$C0,$DF,$40,$EC	; $86F370
	db $0F,$21,$E3,$C0,$44,$1E,$13,$20,$F1,$20,$AE,$1F,$C0,$D1,$BE,$ED	; $86F380
	db $DD,$ED,$FF,$D3,$00,$C0,$12,$3D,$F2,$00,$51,$D2,$11,$21,$C4,$E1	; $86F390
	db $2F,$F0,$32,$C0,$3E,$20,$C2,$C0,$1F,$3E,$02,$0D,$BD,$E0,$DE,$1E	; $86F3A0
	db $C0,$01,$FF,$F3,$44,$20,$40,$11,$0F,$B0,$1F,$ED,$E2,$EE,$1D,$3E	; $86F3B0
	db $DF,$23,$C0,$11,$F2,$0D,$F3,$2F,$2B,$E1,$F1,$C4,$3C,$E2,$FC,$31	; $86F3C0
	db $11,$FD,$1F,$11,$C0,$F1,$01,$0C,$02,$F0,$4F,$05,$FD,$C0,$31,$01	; $86F3D0
	db $2D,$D1,$F1,$FF,$DF,$F0,$C4,$EE,$40,$1E,$A2,$40,$F0,$10,$3B,$C0	; $86F3E0
	db $E2,$21,$0E,$05,$0E,$DF,$52,$FE,$C0,$24,$11,$D1,$22,$1B,$25,$2C	; $86F3F0
	db $11,$C4,$F4,$CD,$42,$BD,$44,$E0,$CF,$43,$B0,$F0,$11,$31,$E0,$36	; $86F400
	db $B9,$34,$EF,$C0,$FC,$03,$FE,$02,$DF,$E3,$0F,$3F,$B0,$16,$00,$60	; $86F410
	db $13,$C3,$0C,$E1,$0B,$C0,$1E,$EF,$0E,$F3,$DF,$1F,$F0,$0E,$B0,$24	; $86F420
	db $23,$D0,$F4,$FB,$E1,$0D,$1A,$C0,$23,$D0,$42,$20,$01,$2F,$0F,$F2	; $86F430
	db $C0,$30,$BF,$20,$ED,$10,$00,$BE,$30,$C0,$EF,$3F,$20,$32,$00,$15	; $86F440
	db $F2,$5F,$C0,$01,$4F,$E1,$31,$D0,$F3,$1D,$D2,$C0,$2C,$2F,$F1,$0E	; $86F450
	db $F2,$12,$FE,$2F,$B0,$3B,$F6,$6E,$12,$1D,$FE,$5B,$A2,$C0,$2E,$DF	; $86F460
	db $CD,$1C,$E0,$EF,$FE,$03,$C0,$DC,$13,$F2,$0E,$2C,$1C,$E3,$D0,$C0	; $86F470
	db $C0,$13,$DC,$11,$30,$FF,$10,$D1,$C0,$10,$10,$0D,$52,$0E,$12,$10	; $86F480
	db $BF,$C0,$0F,$EE,$10,$FE,$00,$06,$2F,$14,$C4,$1C,$D3,$01,$E1,$1D	; $86F490
	db $4F,$C1,$13,$C0,$EF,$F0,$D3,$1D,$F3,$FE,$32,$FF,$B0,$13,$51,$F5	; $86F4A0
	db $22,$0F,$5D,$4F,$11,$B0,$16,$9E,$DB,$FF,$90,$DB,$21,$D1,$C4,$1D	; $86F4B0
	db $11,$D4,$3D,$E1,$4D,$1D,$F4,$C0,$24,$DE,$FF,$FF,$F2,$2B,$C2,$F2	; $86F4C0
	db $C0,$2E,$F2,$10,$20,$E1,$5D,$00,$11,$C0,$F1,$F2,$10,$DF,$34,$0F	; $86F4D0
	db $21,$1E,$C0,$2F,$E3,$FE,$04,$0D,$2F,$13,$0D,$C4,$F4,$21,$EF,$11	; $86F4E0
	db $D2,$10,$0F,$2D,$C0,$1F,$11,$BC,$F3,$DD,$2F,$02,$0F,$C8,$3E,$1F	; $86F4F0
	db $F3,$E1,$B5,$3B,$2F,$0B,$B0,$53,$AD,$F4,$FF,$CC,$6B,$0F,$C0,$C0	; $86F500
	db $21,$00,$0E,$10,$E4,$1D,$D1,$01,$C0,$CF,$02,$1D,$1F,$BE,$1E,$D1	; $86F510
	db $EC,$B0,$D3,$42,$FA,$25,$3D,$B6,$FE,$D0,$C4,$4D,$F0,$10,$1D,$F2	; $86F520
	db $10,$F1,$F1,$B0,$BD,$0E,$6D,$DE,$06,$0D,$11,$D2,$C0,$30,$12,$0C	; $86F530
	db $04,$ED,$E1,$01,$3E,$B4,$27,$EC,$26,$DB,$D5,$3D,$FE,$21,$B0,$02	; $86F540
	db $02,$13,$B2,$2E,$F1,$EE,$2E,$C0,$E1,$DE,$2E,$12,$3F,$AD,$3E,$E0	; $86F550
	db $C4,$F0,$E0,$04,$2E,$C1,$21,$0B,$23,$C4,$3F,$B0,$05,$FB,$5F,$1C	; $86F560
	db $B5,$7E,$B0,$FB,$D6,$1F,$3E,$34,$1B,$12,$BF,$C4,$E3,$2E,$E2,$2D	; $86F570
	db $31,$ED,$4F,$C6,$C0,$30,$23,$F1,$62,$21,$F3,$00,$1F,$C0,$EE,$F0	; $86F580
	db $FA,$D0,$0F,$CD,$34,$0E,$C0,$10,$32,$E1,$22,$2E,$E4,$10,$E0,$C0	; $86F590
	db $32,$1C,$A2,$4C,$BE,$01,$DE,$0E,$B0,$E3,$AB,$04,$1E,$D4,$2D,$FE	; $86F5A0
	db $D7,$C0,$1B,$03,$0E,$A0,$40,$20,$E1,$3F,$B0,$E3,$01,$BC,$3F,$F1	; $86F5B0
	db $D3,$0F,$AE,$C0,$00,$1B,$02,$00,$DF,$11,$0E,$02,$C4,$0B,$53,$B1	; $86F5C0
	db $D4,$0F,$F2,$D2,$F0,$C4,$0C,$30,$4B,$00,$E4,$E2,$3D,$E2,$C0,$EE	; $86F5D0
	db $22,$21,$F3,$1F,$10,$11,$F0,$B0,$1A,$21,$9D,$4E,$FD,$CE,$E0,$3E	; $86F5E0
	db $C0,$D1,$14,$2F,$E3,$31,$E0,$30,$BF,$C0,$30,$2C,$0F,$04,$FD,$01	; $86F5F0
	db $F0,$FE,$B0,$25,$FB,$E6,$2D,$00,$E5,$2B,$D0,$C0,$13,$0F,$5E,$EF	; $86F600
	db $2E,$E3,$C0,$2F,$C0,$D0,$3E,$12,$00,$2E,$F3,$14,$E0,$B0,$03,$1E	; $86F610
	db $5E,$2E,$E1,$B3,$00,$D5,$C0,$F1,$40,$2F,$03,$12,$D1,$10,$30,$C4	; $86F620
	db $3C,$02,$1E,$F0,$1E,$02,$20,$EC,$C0,$30,$03,$D1,$43,$F0,$0F,$5F	; $86F630
	db $E3,$C0,$3F,$D0,$2F,$C0,$DF,$2B,$03,$1D,$C0,$00,$C2,$F0,$E0,$01	; $86F640
	db $FC,$20,$DE,$C0,$03,$E0,$2D,$1E,$1C,$00,$E1,$00,$B0,$C1,$0D,$2E	; $86F650
	db $46,$CB,$00,$D5,$FD,$B0,$3D,$D3,$6E,$01,$21,$C4,$9C,$3E,$C0,$E3	; $86F660
	db $FD,$21,$F1,$C0,$0F,$DF,$3E,$C0,$30,$01,$16,$01,$40,$11,$0F,$4D	; $86F670
	db $C4,$1F,$11,$E0,$D4,$3D,$EF,$4F,$3D,$B0,$D4,$05,$40,$25,$54,$D2	; $86F680
	db $34,$EF,$C0,$C2,$FE,$FF,$FD,$FC,$C2,$EE,$DA,$C0,$12,$3F,$00,$40	; $86F690
	db $00,$02,$14,$EE,$B0,$92,$1C,$41,$DA,$EF,$CF,$2E,$9D,$B0,$5D,$0E	; $86F6A0
	db $44,$02,$E0,$E2,$10,$70,$C0,$E2,$0E,$F3,$F0,$01,$3C,$F1,$1D,$C0	; $86F6B0
	db $12,$14,$F1,$13,$30,$1E,$04,$22,$B0,$0E,$51,$9F,$0E,$2D,$42,$B1	; $86F6C0
	db $2B,$B0,$57,$EE,$02,$03,$CE,$2F,$F5,$0E,$C0,$1F,$03,$1B,$03,$FE	; $86F6D0
	db $01,$F1,$10,$C0,$F2,$3C,$D1,$00,$FF,$0D,$F4,$1F,$B0,$4B,$02,$30	; $86F6E0
	db $41,$DF,$2B,$1D,$CC,$C4,$01,$2E,$B2,$22,$F0,$0E,$03,$1D,$B0,$C6	; $86F6F0
	db $E3,$3F,$23,$4B,$D2,$6F,$D4,$B0,$E0,$30,$BF,$2E,$E0,$0F,$1F,$D1	; $86F700
	db $C0,$03,$1D,$20,$11,$10,$F1,$D0,$21,$B0,$41,$31,$23,$3F,$16,$E3	; $86F710
	db $11,$1E,$B4,$E5,$E0,$FB,$32,$E0,$30,$0E,$1F,$B0,$1F,$E1,$0E,$F5	; $86F720
	db $91,$04,$3F,$FD,$B0,$CD,$00,$0E,$FB,$4F,$1D,$E0,$EB,$C0,$0F,$04	; $86F730
	db $FD,$F2,$DF,$0D,$14,$1F,$B0,$35,$D1,$11,$21,$1C,$E3,$21,$D0,$B4	; $86F740
	db $F1,$D4,$EF,$23,$EA,$21,$F1,$35,$C0,$E1,$10,$1E,$21,$0F,$20,$04	; $86F750
	db $0D,$B0,$36,$0C,$31,$23,$4C,$27,$AC,$CF,$B0,$45,$EA,$E3,$2A,$FD	; $86F760
	db $46,$AE,$23,$B0,$D1,$20,$4F,$CE,$15,$2E,$C0,$0E,$B0,$EA,$05,$4C	; $86F770
	db $B2,$40,$F1,$60,$30,$C4,$E4,$00,$C2,$1E,$FE,$3E,$3F,$F1,$B0,$EC	; $86F780
	db $D3,$F5,$2B,$5F,$F0,$21,$E3,$B0,$DF,$E3,$0B,$0F,$4D,$CC,$14,$13	; $86F790
	db $C0,$FF,$02,$00,$30,$D2,$10,$21,$C1,$C0,$41,$0F,$31,$2F,$02,$21	; $86F7A0
	db $CE,$43,$B0,$0E,$03,$0E,$CE,$04,$DC,$C4,$2A,$B0,$BF,$5F,$E0,$BE	; $86F7B0
	db $74,$E7,$3E,$2F,$B4,$42,$DE,$11,$D5,$CC,$41,$1C,$2E,$B0,$EF,$D0	; $86F7C0
	db $11,$EF,$12,$3C,$44,$1F,$B0,$FB,$12,$E4,$D0,$3C,$FE,$00,$0F,$B0	; $86F7D0
	db $B2,$B0,$B0,$6C,$0C,$21,$F3,$F4,$B0,$3C,$FC,$01,$2F,$D6,$E9,$11	; $86F7E0
	db $B4,$C0,$0D,$E2,$1E,$F4,$11,$01,$10,$10,$B0,$4E,$32,$0A,$05,$DE	; $86F7F0
	db $0D,$10,$EC,$C0,$02,$2E,$E2,$00,$3F,$13,$40,$00,$B0,$2F,$23,$10	; $86F800
	db $33,$B0,$2A,$12,$F3,$C0,$C1,$1F,$1F,$F1,$0C,$0F,$20,$E0,$B0,$02	; $86F810
	db $CC,$4E,$25,$EE,$24,$D2,$22,$B0,$10,$F2,$02,$F0,$0F,$02,$CE,$3A	; $86F820
	db $B0,$EE,$0E,$CE,$D0,$21,$AE,$30,$ED,$B0,$51,$03,$C5,$5E,$C0,$00	; $86F830
	db $4B,$DE,$C0,$13,$DE,$1F,$F2,$E4,$1E,$F2,$0F,$B0,$5C,$E3,$0E,$3C	; $86F840
	db $F2,$C3,$E1,$E1,$B0,$3F,$14,$EE,$20,$C4,$21,$E0,$1C,$B0,$52,$EE	; $86F850
	db $30,$23,$C2,$FA,$4F,$D0,$C0,$F1,$C0,$2F,$D0,$1E,$12,$E0,$4F,$B0	; $86F860
	db $23,$02,$E1,$31,$6E,$00,$EF,$E0,$B0,$FF,$EC,$F6,$C1,$1A,$05,$D9	; $86F870
	db $11,$B0,$0B,$4C,$A3,$FF,$15,$FC,$D1,$35,$B0,$FF,$2F,$45,$FE,$25	; $86F880
	db $CF,$0F,$FF,$B0,$1B,$2F,$CC,$01,$10,$FE,$B2,$D2,$B0,$0C,$40,$F2	; $86F890
	db $2F,$02,$FF,$13,$00,$B0,$0F,$51,$0D,$12,$F1,$2A,$22,$DF,$B0,$EF	; $86F8A0
	db $EE,$2E,$2F,$D2,$D4,$2F,$2F,$B0,$04,$2F,$15,$EE,$0D,$20,$FE,$FF	; $86F8B0
	db $B0,$0F,$CE,$22,$B2,$3F,$E2,$0C,$40,$A0,$9E,$62,$E0,$1F,$1E,$0B	; $86F8C0
	db $0D,$11,$B0,$C2,$EE,$10,$2D,$11,$C1,$2D,$F1,$B0,$DC,$41,$FF,$20	; $86F8D0
	db $20,$F2,$E3,$0F,$B0,$14,$11,$1F,$2F,$20,$CF,$31,$D0,$A0,$6E,$F1	; $86F8E0
	db $1B,$45,$CF,$40,$DD,$F3,$B0,$EF,$05,$0E,$1E,$B2,$1C,$03,$3F,$A0	; $86F8F0
	db $14,$0F,$FD,$00,$5E,$F1,$15,$FC,$B0,$01,$11,$11,$E2,$0C,$20,$0E	; $86F900
	db $CF,$B0,$20,$10,$EF,$F1,$1D,$22,$F0,$12,$A0,$B4,$10,$42,$1F,$3E	; $86F910
	db $F0,$EE,$9F,$A0,$E0,$2E,$C0,$3C,$ED,$F0,$F1,$F3,$B0,$F0,$1E,$F3	; $86F920
	db $FE,$0F,$20,$F0,$FF,$A0,$2F,$D2,$2E,$B0,$60,$CF,$DF,$03,$A0,$EF	; $86F930
	db $31,$C0,$3E,$13,$C0,$50,$2F,$90,$45,$25,$BF,$53,$FD,$25,$E9,$B6	; $86F940
	db $90,$23,$F3,$D1,$4C,$0D,$F1,$0F,$FF,$A0,$0F,$EF,$05,$EB,$21,$E0	; $86F950
	db $30,$F3,$90,$D4,$1E,$25,$1B,$F3,$5C,$0D,$53,$90,$CF,$E3,$E0,$1E	; $86F960
	db $D3,$00,$0F,$F4,$90,$DB,$1F,$FB,$E0,$02,$CB,$22,$2D,$90,$F3,$20	; $86F970
	db $01,$D6,$1E,$3E,$F6,$10,$90,$F2,$1A,$E0,$1D,$0D,$01,$0F,$2D,$90	; $86F980
	db $F3,$0F,$00,$E4,$1D,$13,$1B,$43,$90,$F0,$10,$F0,$03,$2F,$5E,$F3	; $86F990
	db $30,$90,$E0,$1E,$D5,$EF,$10,$0F,$DE,$F1,$80,$E4,$5F,$E3,$13,$53	; $86F9A0
	db $C3,$5E,$33,$84,$BF,$4F,$ED,$12,$B5,$D2,$F0,$D3,$80,$FF,$04,$2C	; $86F9B0
	db $21,$23,$E0,$34,$F5,$90,$0F,$0F,$0F,$23,$CD,$20,$E0,$FD,$80,$FE	; $86F9C0
	db $0F,$4F,$13,$04,$11,$10,$31,$80,$11,$D4,$0F,$10,$01,$DF,$F0,$5E	; $86F9D0
	db $80,$10,$C2,$2E,$10,$D1,$1E,$F2,$E0,$80,$42,$02,$F0,$02,$0F,$02	; $86F9E0
	db $FF,$01,$70,$2E,$FF,$0C,$0B,$01,$EE,$10,$FE,$70,$11,$C3,$20,$3B	; $86F9F0
	db $05,$2E,$00,$00,$60,$3F,$BF,$2C,$49,$0F,$D0,$C2,$0F,$50,$2B,$12	; $86FA00
	db $4D,$F1,$41,$E1,$E1,$22,$60,$D0,$3E,$3D,$C3,$20,$FD,$F0,$3F,$60	; $86FA10
	db $E1,$4F,$F2,$11,$01,$04,$00,$30,$50,$33,$4D,$22,$00,$0F,$F2,$D2	; $86FA20
	db $F0,$41,$FF,$4D,$F2,$AF,$1E,$0F,$20,$F2,$00,$00,$00,$04	; $86FA30
CODE_86FA3E:		; M=16 X=16
	stz.b $76		; $86FA3E: 64 76
	lda.w #$007F		; $86FA40: A9 7F 00
	sta.b $78		; $86FA43: 85 78
CODE_86FA45:		; M=16 X=16
	lda.b [$73]		; $86FA45: A7 73
	inc.b $73		; $86FA47: E6 73
	bit.w #$00E0		; $86FA49: 89 E0 00
	bne CODE_86FA5F		; $86FA4C: D0 11
	and.w #$001F		; $86FA4E: 29 1F 00
	tax		; $86FA51: AA
CODE_86FA52:		; M=16 X=16
	lda.b [$73]		; $86FA52: A7 73
	inc.b $73		; $86FA54: E6 73
	sta.b [$76]		; $86FA56: 87 76
	inc.b $76		; $86FA58: E6 76
	dex		; $86FA5A: CA
	bpl CODE_86FA52		; $86FA5B: 10 F5
	bra CODE_86FA45		; $86FA5D: 80 E6
CODE_86FA5F:		; M=16 X=16
	tay		; $86FA5F: A8
	and.w #$00F0		; $86FA60: 29 F0 00
	cmp.w #$0020		; $86FA63: C9 20 00
	bne CODE_86FA79		; $86FA66: D0 11
	tya		; $86FA68: 98
	and.w #$000F		; $86FA69: 29 0F 00
	tax		; $86FA6C: AA
	lda.w #$0000		; $86FA6D: A9 00 00
CODE_86FA70:		; M=16 X=16
	sta.b [$76]		; $86FA70: 87 76
	inc.b $76		; $86FA72: E6 76
	dex		; $86FA74: CA
	bpl CODE_86FA70		; $86FA75: 10 F9
	bra CODE_86FA45		; $86FA77: 80 CC
CODE_86FA79:		; M=16 X=16
	cmp.w #$0030		; $86FA79: C9 30 00
	bne CODE_86FA92		; $86FA7C: D0 14
	tya		; $86FA7E: 98
	and.w #$000F		; $86FA7F: 29 0F 00
	tax		; $86FA82: AA
	inx		; $86FA83: E8
	inx		; $86FA84: E8
	lda.b [$73]		; $86FA85: A7 73
	inc.b $73		; $86FA87: E6 73
CODE_86FA89:		; M=16 X=16
	sta.b [$76]		; $86FA89: 87 76
	inc.b $76		; $86FA8B: E6 76
	dex		; $86FA8D: CA
	bpl CODE_86FA89		; $86FA8E: 10 F9
	bra CODE_86FA45		; $86FA90: 80 B3
CODE_86FA92:		; M=16 X=16
	and.w #$00C0		; $86FA92: 29 C0 00
	cmp.w #$0040		; $86FA95: C9 40 00
	bne CODE_86FABF		; $86FA98: D0 25
	tya		; $86FA9A: 98
	lsr a		; $86FA9B: 4A
	lsr a		; $86FA9C: 4A
	lsr a		; $86FA9D: 4A
	and.w #$0007		; $86FA9E: 29 07 00
	inc a		; $86FAA1: 1A
	sta.b $79		; $86FAA2: 85 79
	tya		; $86FAA4: 98
	and.w #$0007		; $86FAA5: 29 07 00
	inc a		; $86FAA8: 1A
	inc a		; $86FAA9: 1A
	tay		; $86FAAA: A8
CODE_86FAAB:		; M=16 X=16
	lda.b $76		; $86FAAB: A5 76
	sec		; $86FAAD: 38
	sbc.b $79		; $86FAAE: E5 79
	tax		; $86FAB0: AA
CODE_86FAB1:		; M=16 X=16
	lda.l $7F0000,x		; $86FAB1: BF 00 00 7F
	inx		; $86FAB5: E8
	sta.b [$76]		; $86FAB6: 87 76
	inc.b $76		; $86FAB8: E6 76
	dey		; $86FABA: 88
	bne CODE_86FAB1		; $86FABB: D0 F4
	bra CODE_86FA45		; $86FABD: 80 86
CODE_86FABF:		; M=16 X=16
	tya		; $86FABF: 98
	and.w #$00F0		; $86FAC0: 29 F0 00
	cmp.w #$0080		; $86FAC3: C9 80 00
	bne CODE_86FADB		; $86FAC6: D0 13
	tya		; $86FAC8: 98
	and.w #$000F		; $86FAC9: 29 0F 00
	inc a		; $86FACC: 1A
	inc a		; $86FACD: 1A
	inc a		; $86FACE: 1A
	tay		; $86FACF: A8
	lda.b [$73]		; $86FAD0: A7 73
	inc.b $73		; $86FAD2: E6 73
	and.w #$00FF		; $86FAD4: 29 FF 00
	sta.b $79		; $86FAD7: 85 79
	bra CODE_86FAAB		; $86FAD9: 80 D0
CODE_86FADB:		; M=16 X=16
	cmp.w #$0090		; $86FADB: C9 90 00
	bne CODE_86FAF7		; $86FADE: D0 17
	lda.b [$73]		; $86FAE0: A7 73
	inc.b $73		; $86FAE2: E6 73
	and.w #$007F		; $86FAE4: 29 7F 00
	inc a		; $86FAE7: 1A
	sta.b $79		; $86FAE8: 85 79
	tya		; $86FAEA: 98
	xba		; $86FAEB: EB
	asl a		; $86FAEC: 0A
	xba		; $86FAED: EB
	and.w #$001F		; $86FAEE: 29 1F 00
	inc a		; $86FAF1: 1A
	inc a		; $86FAF2: 1A
	inc a		; $86FAF3: 1A
	tay		; $86FAF4: A8
	bra CODE_86FAAB		; $86FAF5: 80 B4
CODE_86FAF7:		; M=16 X=16
	cmp.w #$00A0		; $86FAF7: C9 A0 00
	bne CODE_86FB14		; $86FAFA: D0 18
	lda.b [$73]		; $86FAFC: A7 73
	inc.b $73		; $86FAFE: E6 73
	and.w #$003F		; $86FB00: 29 3F 00
	inc a		; $86FB03: 1A
	sta.b $79		; $86FB04: 85 79
	tya		; $86FB06: 98
	xba		; $86FB07: EB
	asl a		; $86FB08: 0A
	asl a		; $86FB09: 0A
	xba		; $86FB0A: EB
	and.w #$003F		; $86FB0B: 29 3F 00
	inc a		; $86FB0E: 1A
	inc a		; $86FB0F: 1A
	inc a		; $86FB10: 1A
	tay		; $86FB11: A8
	bra CODE_86FAAB		; $86FB12: 80 97
CODE_86FB14:		; M=16 X=16
	cmp.w #$00B0		; $86FB14: C9 B0 00
	bne CODE_86FB33		; $86FB17: D0 1A
	lda.b [$73]		; $86FB19: A7 73
	inc.b $73		; $86FB1B: E6 73
	and.w #$001F		; $86FB1D: 29 1F 00
	inc a		; $86FB20: 1A
	sta.b $79		; $86FB21: 85 79
	tya		; $86FB23: 98
	xba		; $86FB24: EB
	asl a		; $86FB25: 0A
	asl a		; $86FB26: 0A
	asl a		; $86FB27: 0A
	xba		; $86FB28: EB
	and.w #$007F		; $86FB29: 29 7F 00
	inc a		; $86FB2C: 1A
	inc a		; $86FB2D: 1A
	inc a		; $86FB2E: 1A
	tay		; $86FB2F: A8
	jmp.w $FAAB		; $86FB30: 4C AB FA
CODE_86FB33:		; M=16 X=16
	and.w #$00E0		; $86FB33: 29 E0 00
	cmp.w #$00C0		; $86FB36: C9 C0 00
	bne CODE_86FB60		; $86FB39: D0 25
	tya		; $86FB3B: 98
	lsr a		; $86FB3C: 4A
	lsr a		; $86FB3D: 4A
	and.w #$0007		; $86FB3E: 29 07 00
	inc a		; $86FB41: 1A
	sta.b $79		; $86FB42: 85 79
	tya		; $86FB44: 98
	and.w #$0003		; $86FB45: 29 03 00
	inc a		; $86FB48: 1A
	inc a		; $86FB49: 1A
	tay		; $86FB4A: A8
CODE_86FB4B:		; M=16 X=16
	lda.b $76		; $86FB4B: A5 76
	sec		; $86FB4D: 38
	sbc.b $79		; $86FB4E: E5 79
	tax		; $86FB50: AA
CODE_86FB51:		; M=16 X=16
	lda.l $7F0000,x		; $86FB51: BF 00 00 7F
	dex		; $86FB55: CA
	sta.b [$76]		; $86FB56: 87 76
	inc.b $76		; $86FB58: E6 76
	dey		; $86FB5A: 88
	bne CODE_86FB51		; $86FB5B: D0 F4
	jmp.w $FA45		; $86FB5D: 4C 45 FA
CODE_86FB60:		; M=16 X=16
	tya		; $86FB60: 98
	and.w #$00F0		; $86FB61: 29 F0 00
	cmp.w #$00E0		; $86FB64: C9 E0 00
	bne CODE_86FB7E		; $86FB67: D0 15
	tya		; $86FB69: 98
	and.w #$000F		; $86FB6A: 29 0F 00
	inc a		; $86FB6D: 1A
	inc a		; $86FB6E: 1A
	inc a		; $86FB6F: 1A
	tay		; $86FB70: A8
	lda.b [$73]		; $86FB71: A7 73
	inc.b $73		; $86FB73: E6 73
	and.w #$00FF		; $86FB75: 29 FF 00
	beq CODE_86FB95		; $86FB78: F0 1B
	sta.b $79		; $86FB7A: 85 79
	bra CODE_86FB4B		; $86FB7C: 80 CD
CODE_86FB7E:		; M=16 X=16
	lda.b [$73]		; $86FB7E: A7 73
	inc.b $73		; $86FB80: E6 73
	and.w #$007F		; $86FB82: 29 7F 00
	inc a		; $86FB85: 1A
	sta.b $79		; $86FB86: 85 79
	tya		; $86FB88: 98
	xba		; $86FB89: EB
	asl a		; $86FB8A: 0A
	xba		; $86FB8B: EB
	and.w #$001F		; $86FB8C: 29 1F 00
	inc a		; $86FB8F: 1A
	inc a		; $86FB90: 1A
	inc a		; $86FB91: 1A
	tay		; $86FB92: A8
	bra CODE_86FB4B		; $86FB93: 80 B6
CODE_86FB95:		; M=16 X=16
	rtl		; $86FB95: 6B
CODE_86FB96:		; M=16 X=16
	lda.w $160C		; $86FB96: AD 0C 16
	bne CODE_86FBE0		; $86FB99: D0 45
	stz.b $3B		; $86FB9B: 64 3B
	jsl.l $86FBA6		; $86FB9D: 22 A6 FB 86
	lda.w #$0002		; $86FBA1: A9 02 00
	sta.b $3B		; $86FBA4: 85 3B
CODE_86FBA6:		; M=16 X=16
	lda.w #$0032		; $86FBA6: A9 32 00
	sta.b $53		; $86FBA9: 85 53
CODE_86FBAB:		; M=16 X=16
	lda.b $3B		; $86FBAB: A5 3B
	beq CODE_86FBB2		; $86FBAD: F0 03
	lda.w #$0034		; $86FBAF: A9 34 00
CODE_86FBB2:		; M=16 X=16
	clc		; $86FBB2: 18
	adc.b $53		; $86FBB3: 65 53
	tay		; $86FBB5: A8
	lda.w $14E2,y		; $86FBB6: B9 E2 14
	cmp.w #$FFFE		; $86FBB9: C9 FE FF
	bne CODE_86FBDA		; $86FBBC: D0 1C
	lda.w $147A,y		; $86FBBE: B9 7A 14
	clc		; $86FBC1: 18
	adc.w #$000A		; $86FBC2: 69 0A 00
	sta.w $147A,y		; $86FBC5: 99 7A 14
	sec		; $86FBC8: 38
	sbc.w #$1000		; $86FBC9: E9 00 10
	bmi CODE_86FBD2		; $86FBCC: 30 04
	bvc CODE_86FBD4		; $86FBCE: 50 04
	bra CODE_86FBDA		; $86FBD0: 80 08
CODE_86FBD2:		; M=16 X=16
	bvc CODE_86FBDA		; $86FBD2: 50 06
CODE_86FBD4:		; M=16 X=16
	lda.w #$1000		; $86FBD4: A9 00 10
	sta.w $147A,y		; $86FBD7: 99 7A 14
CODE_86FBDA:		; M=16 X=16
	dec.b $53		; $86FBDA: C6 53
	dec.b $53		; $86FBDC: C6 53
	bpl CODE_86FBAB		; $86FBDE: 10 CB
CODE_86FBE0:		; M=16 X=16
	rtl		; $86FBE0: 6B
CODE_86FBE1:		; M=16 X=16
	lda.w $1651		; $86FBE1: AD 51 16
	cmp.w #$0006		; $86FBE4: C9 06 00
	beq CODE_86FC04		; $86FBE7: F0 1B
	lda.w $164F		; $86FBE9: AD 4F 16
	cmp.w #$0002		; $86FBEC: C9 02 00
	beq CODE_86FBF5		; $86FBEF: F0 04
	jsl.l $82FA31		; $86FBF1: 22 31 FA 82
CODE_86FBF5:		; M=16 X=16
	sep #$20		; $86FBF5: E2 20
	lda.b #$03		; $86FBF7: A9 03
	sta.w $2140		; $86FBF9: 8D 40 21
	rep #$30		; $86FBFC: C2 30
	lda.w #$0006		; $86FBFE: A9 06 00
	sta.w $1651		; $86FC01: 8D 51 16
CODE_86FC04:		; M=16 X=16
	rtl		; $86FC04: 6B
	db $AD,$51,$16,$C9,$07,$00,$F0,$1B,$AD,$4F,$16,$C9,$02,$00,$F0,$04	; $86FC05
	db $22,$31,$FA,$82,$E2,$20,$A9,$02,$8D,$40,$21,$C2,$30,$A9,$07,$00	; $86FC15
	db $8D,$51,$16,$6B	; $86FC25
CODE_86FC29:		; M=16 X=16
	stz.w $13D2		; $86FC29: 9C D2 13
	lda.w #$000C		; $86FC2C: A9 0C 00
	sta.w $13D4		; $86FC2F: 8D D4 13
	lda.w $129A		; $86FC32: AD 9A 12
	sta.w $13F6		; $86FC35: 8D F6 13
	asl a		; $86FC38: 0A
	asl a		; $86FC39: 0A
	tax		; $86FC3A: AA
	lda.l $838000,x		; $86FC3B: BF 00 80 83
	sta.w $13CE		; $86FC3F: 8D CE 13
	lda.w $129C		; $86FC42: AD 9C 12
	sta.w $13F8		; $86FC45: 8D F8 13
	asl a		; $86FC48: 0A
	asl a		; $86FC49: 0A
	tax		; $86FC4A: AA
	lda.l $838000,x		; $86FC4B: BF 00 80 83
	sta.w $13D0		; $86FC4F: 8D D0 13
	rtl		; $86FC52: 6B
CODE_86FC53:		; M=16 X=16
	jsl.l $85FF96		; $86FC53: 22 96 FF 85
	lda.b $5F		; $86FC57: A5 5F
	beq CODE_86FC6E		; $86FC59: F0 13
	lda.b $5B		; $86FC5B: A5 5B
	bne CODE_86FC6F		; $86FC5D: D0 10
	dec.w $0499		; $86FC5F: CE 99 04
	bpl CODE_86FC6E		; $86FC62: 10 0A
	lda.w #$0004		; $86FC64: A9 04 00
	sta.w $0499		; $86FC67: 8D 99 04
	lda.b $5F		; $86FC6A: A5 5F
	sta.b $57		; $86FC6C: 85 57
CODE_86FC6E:		; M=16 X=16
	rtl		; $86FC6E: 6B
CODE_86FC6F:		; M=16 X=16
	lda.w #$000F		; $86FC6F: A9 0F 00
	sta.w $0499		; $86FC72: 8D 99 04
	rtl		; $86FC75: 6B
CODE_86FC76:		; M=16 X=16
	jsl.l $80B90C		; $86FC76: 22 0C B9 80
	ora.b $00		; $86FC7A: 05 00
	lda.l $A50A01,x		; $86FC7C: BF 01 0A A5
	tsc		; $86FC80: 3B
	bne CODE_86FC89		; $86FC81: D0 06
	lda.w #$0014		; $86FC83: A9 14 00
	sta.w $047B		; $86FC86: 8D 7B 04
CODE_86FC89:		; M=16 X=16
	rtl		; $86FC89: 6B
CODE_86FC8A:		; M=16 X=16
	lda.w $12F0		; $86FC8A: AD F0 12
	xba		; $86FC8D: EB
	and.w #$FF00		; $86FC8E: 29 00 FF
	asl a		; $86FC91: 0A
	asl a		; $86FC92: 0A
	asl a		; $86FC93: 0A
	asl a		; $86FC94: 0A
	asl a		; $86FC95: 0A
	asl a		; $86FC96: 0A
	ora.w $12F6		; $86FC97: 0D F6 12
	sec		; $86FC9A: 38
	sbc.w $12F2		; $86FC9B: ED F2 12
	sta.b $53		; $86FC9E: 85 53
	rtl		; $86FCA0: 6B
CODE_86FCA1:		; M=16 X=16
	phx		; $86FCA1: DA
	lda.w $1608		; $86FCA2: AD 08 16
	asl a		; $86FCA5: 0A
	tax		; $86FCA6: AA
	lda.l $86FCAF,x		; $86FCA7: BF AF FC 86
	sta.b $53		; $86FCAB: 85 53
	plx		; $86FCAD: FA
	rtl		; $86FCAE: 6B
	db $2C,$01,$58,$02,$B0,$04,$1E,$00	; $86FCAF
CODE_86FCB7:		; M=16 X=16
	jsl.l $80F391		; $86FCB7: 22 91 F3 80
	lda.w $047D		; $86FCBB: AD 7D 04
	sec		; $86FCBE: 38
	sbc.w #$000F		; $86FCBF: E9 0F 00
	bmi CODE_86FCC8		; $86FCC2: 30 04
	bvc CODE_86FCCA		; $86FCC4: 50 04
	bra CODE_86FCD0		; $86FCC6: 80 08
CODE_86FCC8:		; M=16 X=16
	bvc CODE_86FCD0		; $86FCC8: 50 06
CODE_86FCCA:		; M=16 X=16
	lda.w #$0001		; $86FCCA: A9 01 00
	trb.w $1290		; $86FCCD: 1C 90 12
CODE_86FCD0:		; M=16 X=16
	inc.b $57		; $86FCD0: E6 57
	lda.w $1BE7		; $86FCD2: AD E7 1B
	sta.b $5B		; $86FCD5: 85 5B
	lda.b $F4		; $86FCD7: A5 F4
	bne CODE_86FCDF		; $86FCD9: D0 04
	jsl.l $8D847C		; $86FCDB: 22 7C 84 8D
CODE_86FCDF:		; M=16 X=16
	jml.l $89E95D		; $86FCDF: 5C 5D E9 89
CODE_86FCE3:		; M=16 X=16
	stx.b $0A		; $86FCE3: 86 0A
	ldx.w #$0000		; $86FCE5: A2 00 00
CODE_86FCE8:		; M=16 X=16
	lda.b $53,x		; $86FCE8: B5 53
	pha		; $86FCEA: 48
	inx		; $86FCEB: E8
	inx		; $86FCEC: E8
	cpx.w #$0004		; $86FCED: E0 04 00
	bne CODE_86FCE8		; $86FCF0: D0 F6
	ldx.b $0A		; $86FCF2: A6 0A
	stx.b $0A		; $86FCF4: 86 0A
	ldx.w #$0000		; $86FCF6: A2 00 00
CODE_86FCF9:		; M=16 X=16
	lda.b $33,x		; $86FCF9: B5 33
	pha		; $86FCFB: 48
	inx		; $86FCFC: E8
	inx		; $86FCFD: E8
	cpx.w #$0004		; $86FCFE: E0 04 00
	bne CODE_86FCF9		; $86FD01: D0 F6
	ldx.b $0A		; $86FD03: A6 0A
	ldy.b $3B		; $86FD05: A4 3B
	lda.w #$0000		; $86FD07: A9 00 00
	sta.w $13F2,y		; $86FD0A: 99 F2 13
	jsl.l $8B807D		; $86FD0D: 22 7D 80 8B
	lda.b $3B		; $86FD11: A5 3B
	tay		; $86FD13: A8
	lsr a		; $86FD14: 4A
	inc a		; $86FD15: 1A
	sta.b $53		; $86FD16: 85 53
	cmp.w $1296		; $86FD18: CD 96 12
	beq CODE_86FD69		; $86FD1B: F0 4C
	cmp.w $1298		; $86FD1D: CD 98 12
	beq CODE_86FD69		; $86FD20: F0 47
	stz.b $53		; $86FD22: 64 53
	lda.w $014A		; $86FD24: AD 4A 01
	sec		; $86FD27: 38
	sbc.w #$0002		; $86FD28: E9 02 00
	beq CODE_86FD35		; $86FD2B: F0 08
	bmi CODE_86FD33		; $86FD2D: 30 04
	bvs CODE_86FD35		; $86FD2F: 70 04
	bra CODE_86FD62		; $86FD31: 80 2F
CODE_86FD33:		; M=16 X=16
	bvs CODE_86FD62		; $86FD33: 70 2D
CODE_86FD35:		; M=16 X=16
	lda.w $160C		; $86FD35: AD 0C 16
	bne CODE_86FD62		; $86FD38: D0 28
	lda.w #$8000		; $86FD3A: A9 00 80
	sta.b $33		; $86FD3D: 85 33
	lda.w #$0083		; $86FD3F: A9 83 00
	sta.b $35		; $86FD42: 85 35
	lda.w $13B2,y		; $86FD44: B9 B2 13
	asl a		; $86FD47: 0A
	asl a		; $86FD48: 0A
	tay		; $86FD49: A8
	lda.b [$33],y		; $86FD4A: B7 33
	sta.b $33		; $86FD4C: 85 33
	ldy.w #$000A		; $86FD4E: A0 0A 00
	adc.b [$33],y		; $86FD51: 77 33
	sta.b $33		; $86FD53: 85 33
	lda.w #$0004		; $86FD55: A9 04 00
	sta.b $53		; $86FD58: 85 53
	jsl.l $8FF4D8		; $86FD5A: 22 D8 F4 8F
	jsl.l $8FE3B0		; $86FD5E: 22 B0 E3 8F
CODE_86FD62:		; M=16 X=16
	ldy.b $3B		; $86FD62: A4 3B
	lda.b $53		; $86FD64: A5 53
	sta.w $13F2,y		; $86FD66: 99 F2 13
CODE_86FD69:		; M=16 X=16
	stx.b $0A		; $86FD69: 86 0A
	ldx.w #$0002		; $86FD6B: A2 02 00
CODE_86FD6E:		; M=16 X=16
	pla		; $86FD6E: 68
	sta.b $33,x		; $86FD6F: 95 33
	dex		; $86FD71: CA
	dex		; $86FD72: CA
	bpl CODE_86FD6E		; $86FD73: 10 F9
	ldx.b $0A		; $86FD75: A6 0A
	stx.b $0A		; $86FD77: 86 0A
	ldx.w #$0002		; $86FD79: A2 02 00
CODE_86FD7C:		; M=16 X=16
	pla		; $86FD7C: 68
	sta.b $53,x		; $86FD7D: 95 53
	dex		; $86FD7F: CA
	dex		; $86FD80: CA
	bpl CODE_86FD7C		; $86FD81: 10 F9
	ldx.b $0A		; $86FD83: A6 0A
	rtl		; $86FD85: 6B
	db $BD,$DF,$0A,$85,$7D,$A9,$C0,$00,$85,$83,$22,$DB,$FC,$82,$A5,$94	; $86FD86
	db $9D,$DF,$0A,$BD,$FF,$0A,$85,$7D,$A9,$C0,$00,$85,$83,$22,$DB,$FC	; $86FD96
	db $82,$A5,$94,$9D,$FF,$0A,$8A,$4A,$CD,$BB,$0E,$D0,$0C,$A9,$FF,$FF	; $86FDA6
	db $8D,$BB,$0E,$A9,$08,$07,$9D,$5F,$0E,$BD,$7F,$11,$D0,$73,$BD,$DF	; $86FDB6
	db $0E,$89,$02,$00,$F0,$2A,$29,$FD,$FF,$9D,$DF,$0E,$22,$2D,$FE,$86	; $86FDC6
	db $9E,$7F,$0C,$A9,$08,$00,$9D,$FF,$0C,$A9,$5A,$00,$9D,$9F,$0C,$AD	; $86FDD6
	db $54,$01,$10,$06,$A9,$A6,$FF,$9D,$9F,$0C,$AD,$DF,$08,$9D,$BF,$0C	; $86FDE6
	db $A9,$E6,$84,$85,$33,$A9,$80,$00,$85,$35,$BD,$9F,$0C,$85,$53,$BD	; $86FDF6
	db $BF,$0C,$85,$57,$BD,$5F,$0C,$38,$E5,$6F,$9D,$5F,$0C,$10,$23,$9D	; $86FE06
	db $7F,$11,$A9,$F6,$0D,$85,$57,$8A,$4A,$CD,$A5,$04,$D0,$05,$A9,$68	; $86FE16
	db $0E,$85,$57,$22,$06,$B0,$80,$A9,$78,$00,$22,$8B,$AE,$80,$9D,$5F	; $86FE26
	db $0C,$6B,$BD,$DF,$0E,$89,$08,$00,$D0,$04,$5C,$D0,$FD,$88,$6B,$FF	; $86FE36
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FE46
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FE56
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FE66
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FE76
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FE86
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FE96
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FEA6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FEB6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FEC6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FED6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FEE6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FEF6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FF06
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FF16
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FF26
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FF36
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FF46
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FF56
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FF66
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FF76
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FF86
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FF96
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FFA6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FFB6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FFC6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FFD6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FFE6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; $86FFF6
