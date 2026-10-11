; frames: the SPA animation tables.
; Bank $82. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $82B86E

SPAgready_table:		;SPA $0002
	dw .d0-SPAgready_table		; direction 0
	dw .d1-SPAgready_table		; direction 1
	dw .d2-SPAgready_table		; direction 2
	dw .d3-SPAgready_table		; direction 3
	dw .d4-SPAgready_table		; direction 4
	dw .d5-SPAgready_table		; direction 5
	dw .d6-SPAgready_table		; direction 6
	dw .d7-SPAgready_table		; direction 7
	dw 1		; attributes: loops
.d0:	dw SPFGoalie,180,SPFgready,10,SPFgready+1,10,SPFgready,10,SPFgready+1,10,SPFGoalie,240,SPFgready,10,SPFgready+1,10
	dw SPFgready,-10
.d1:	dw SPFGoalie+3,130,SPFgready+2,10,SPFgready+3,10,SPFgready+2,10,SPFgready+3,10,SPFGoalie+3,300,SPFgready+2,10,SPFgready+3,10
	dw SPFgready+2,-10
.d2:	dw SPFGoalie+6,210,SPFgready+4,10,SPFgready+5,10,SPFgready+4,10,SPFgready+5,10,SPFGoalie+6,120,SPFgready+4,10,SPFgready+5,10
	dw SPFgready+4,-10
.d3:	dw SPFGoalie+9,100,SPFgready+6,10,SPFgready+7,10,SPFgready+6,10,SPFgready+7,10,SPFGoalie+9,200,SPFgready+6,10,SPFgready+7,10
	dw SPFgready+6,-10
.d4:	dw SPFGoalie+12,240,SPFgready+8,10,SPFgready+9,10,SPFgready+8,10,SPFgready+9,10,SPFGoalie+12,60,SPFgready+8,10,SPFgready+9,10
	dw SPFgready+8,-10
.d5:	dw SPFGoalie+15,180,SPFgready+10,10,SPFgready+11,10,SPFgready+10,10,SPFgready+11,10,SPFGoalie+15,240,SPFgready+10,10,SPFgready+11,10
	dw SPFgready+10,-10
.d6:	dw SPFGoalie+18,120,SPFgready+12,10,SPFgready+13,10,SPFgready+12,10,SPFgready+13,10,SPFGoalie+18,120,SPFgready+12,10,SPFgready+13,10
	dw SPFgready+12,-10
.d7:	dw SPFGoalie+21,180,SPFgready+14,10,SPFgready+15,10,SPFgready+14,10,SPFgready+15,10,SPFGoalie+21,180,SPFgready+14,10,SPFgready+15,10
	dw SPFgready+14,-10
	assert SPAgready_table-SPAList == SPAgready

SPAgready2_table:		;SPA $0134
	dw .d0-SPAgready2_table		; direction 0
	dw .d1-SPAgready2_table		; direction 1
	dw .d2-SPAgready2_table		; direction 2
	dw .d3-SPAgready2_table		; direction 3
	dw .d4-SPAgready2_table		; direction 4
	dw .d5-SPAgready2_table		; direction 5
	dw .d6-SPAgready2_table		; direction 6
	dw .d7-SPAgready2_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFGoalie,-30
.d1:	dw SPFGoalie+3,-30
.d2:	dw SPFGoalie+6,-30
.d3:	dw SPFGoalie+9,-30
.d4:	dw SPFGoalie+12,-30
.d5:	dw SPFGoalie+15,-30
.d6:	dw SPFGoalie+18,-30
.d7:	dw SPFGoalie+21,-30
	assert SPAgready2_table-SPAList == SPAgready2

SPAgglover_table:		;SPA $0166
	dw .d0-SPAgglover_table		; direction 0
	dw .d1-SPAgglover_table		; direction 1
	dw .d2-SPAgglover_table		; direction 2
	dw .d3-SPAgglover_table		; direction 3
	dw .d4-SPAgglover_table		; direction 4
	dw .d5-SPAgglover_table		; direction 5
	dw .d6-SPAgglover_table		; direction 6
	dw .d7-SPAgglover_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFGoalie+1,-32
.d1:	dw SPFGoalie+4,-32
.d2:	dw SPFGoalie+7,-32
.d3:	dw SPFGoalie+10,-32
.d4:	dw SPFGoalie+13,-32
.d5:	dw SPFGoalie+16,-32
.d6:	dw SPFGoalie+19,-32
.d7:	dw SPFGoalie+22,-32
	assert SPAgglover_table-SPAList == SPAgglover

SPAgglovel_table:		;SPA $0198
	dw .d0-SPAgglovel_table		; direction 0
	dw .d1-SPAgglovel_table		; direction 1
	dw .d2-SPAgglovel_table		; direction 2
	dw .d3-SPAgglovel_table		; direction 3
	dw .d4-SPAgglovel_table		; direction 4
	dw .d5-SPAgglovel_table		; direction 5
	dw .d6-SPAgglovel_table		; direction 6
	dw .d7-SPAgglovel_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFGoalie+2,-32
.d1:	dw SPFGoalie+5,-32
.d2:	dw SPFGoalie+8,-32
.d3:	dw SPFGoalie+11,-32
.d4:	dw SPFGoalie+14,-32
.d5:	dw SPFGoalie+17,-32
.d6:	dw SPFGoalie+20,-32
.d7:	dw SPFGoalie+23,-32
	assert SPAgglovel_table-SPAList == SPAgglovel

SPAgstickr_table:		;SPA $01CA
	dw .d0-SPAgstickr_table		; direction 0
	dw .d1-SPAgstickr_table		; direction 1
	dw .d2-SPAgstickr_table		; direction 2
	dw .d3-SPAgstickr_table		; direction 3
	dw .d4-SPAgstickr_table		; direction 4
	dw .d5-SPAgstickr_table		; direction 5
	dw .d6-SPAgstickr_table		; direction 6
	dw .d7-SPAgstickr_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFGoalie+64,-32
.d1:	dw SPFGoalie+66,-32
.d2:	dw SPFGoalie+68,-32
.d3:	dw SPFGoalie+70,-32
.d4:	dw SPFGoalie+72,-32
.d5:	dw SPFGoalie+74,-32
.d6:	dw SPFGoalie+76,-32
.d7:	dw SPFGoalie+78,-32
	assert SPAgstickr_table-SPAList == SPAgstickr

SPAgstickl_table:		;SPA $01FC
	dw .d0-SPAgstickl_table		; direction 0
	dw .d1-SPAgstickl_table		; direction 1
	dw .d2-SPAgstickl_table		; direction 2
	dw .d3-SPAgstickl_table		; direction 3
	dw .d4-SPAgstickl_table		; direction 4
	dw .d5-SPAgstickl_table		; direction 5
	dw .d6-SPAgstickl_table		; direction 6
	dw .d7-SPAgstickl_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFGoalie+65,-32
.d1:	dw SPFGoalie+67,-32
.d2:	dw SPFGoalie+69,-32
.d3:	dw SPFGoalie+71,-32
.d4:	dw SPFGoalie+73,-32
.d5:	dw SPFGoalie+75,-32
.d6:	dw SPFGoalie+77,-32
.d7:	dw SPFGoalie+79,-32
	assert SPAgstickl_table-SPAList == SPAgstickl

SPAgstackr_table:		;SPA $022E
	dw .d0-SPAgstackr_table		; direction 0
	dw .d1-SPAgstackr_table		; direction 1
	dw .d2-SPAgstackr_table		; direction 2
	dw .d3-SPAgstackr_table		; direction 3
	dw .d4-SPAgstackr_table		; direction 4
	dw .d5-SPAgstackr_table		; direction 5
	dw .d6-SPAgstackr_table		; direction 6
	dw .d7-SPAgstackr_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFGoalie+40,8,SPFGoalie+41,-20
.d1:	dw SPFGoalie+42,8,SPFGoalie+43,-20
.d2:	dw SPFGoalie+42,8,SPFGoalie+43,-20
.d3:	dw SPFGoalie+44,8,SPFGoalie+45,-20
.d4:	dw SPFGoalie+46,8,SPFGoalie+47,-20
.d5:	dw SPFGoalie+48,8,SPFGoalie+49,-20
.d6:	dw SPFGoalie+48,8,SPFGoalie+49,-20
.d7:	dw SPFGoalie+50,8,SPFGoalie+51,-20
	assert SPAgstackr_table-SPAList == SPAgstackr

SPAgstackl_table:		;SPA $0280
	dw .d0-SPAgstackl_table		; direction 0
	dw .d1-SPAgstackl_table		; direction 1
	dw .d2-SPAgstackl_table		; direction 2
	dw .d3-SPAgstackl_table		; direction 3
	dw .d4-SPAgstackl_table		; direction 4
	dw .d5-SPAgstackl_table		; direction 5
	dw .d6-SPAgstackl_table		; direction 6
	dw .d7-SPAgstackl_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFGoalie+52,8,SPFGoalie+53,-20
.d1:	dw SPFGoalie+54,8,SPFGoalie+55,-20
.d2:	dw SPFGoalie+54,8,SPFGoalie+55,-20
.d3:	dw SPFGoalie+56,8,SPFGoalie+57,-20
.d4:	dw SPFGoalie+58,8,SPFGoalie+59,-20
.d5:	dw SPFGoalie+60,8,SPFGoalie+61,-20
.d6:	dw SPFGoalie+60,8,SPFGoalie+61,-20
.d7:	dw SPFGoalie+62,8,SPFGoalie+63,-20
	assert SPAgstackl_table-SPAList == SPAgstackl

SPAgswing_table:		;SPA $02D2
	dw .d0-SPAgswing_table		; direction 0
	dw .d1-SPAgswing_table		; direction 1
	dw .d2-SPAgswing_table		; direction 2
	dw .d3-SPAgswing_table		; direction 3
	dw .d4-SPAgswing_table		; direction 4
	dw .d5-SPAgswing_table		; direction 5
	dw .d6-SPAgswing_table		; direction 6
	dw .d7-SPAgswing_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFGoalie+24,5,SPFGoalie+25,8,SPFGoalie+24,-16
.d1:	dw SPFGoalie+26,5,SPFGoalie+27,8,SPFGoalie+26,-16
.d2:	dw SPFGoalie+28,5,SPFGoalie+29,8,SPFGoalie+28,-16
.d3:	dw SPFGoalie+30,5,SPFGoalie+31,8,SPFGoalie+30,-16
.d4:	dw SPFGoalie+32,5,SPFGoalie+33,8,SPFGoalie+32,-16
.d5:	dw SPFGoalie+34,5,SPFGoalie+35,8,SPFGoalie+34,-16
.d6:	dw SPFGoalie+36,5,SPFGoalie+37,8,SPFGoalie+36,-16
.d7:	dw SPFGoalie+38,5,SPFGoalie+39,8,SPFGoalie+38,-16
	assert SPAgswing_table-SPAList == SPAgswing

SPAgskate_table:		;SPA $0344
	dw .d0-SPAgskate_table		; direction 0
	dw .d1-SPAgskate_table		; direction 1
	dw .d2-SPAgskate_table		; direction 2
	dw .d3-SPAgskate_table		; direction 3
	dw .d4-SPAgskate_table		; direction 4
	dw .d5-SPAgskate_table		; direction 5
	dw .d6-SPAgskate_table		; direction 6
	dw .d7-SPAgskate_table		; direction 7
	dw 1		; attributes: loops
.d0:	dw SPFGoalie+80,10,SPFGoalie+81,10,SPFGoalie+82,10,SPFGoalie+83,-15
.d1:	dw SPFGoalie+84,10,SPFGoalie+85,10,SPFGoalie+86,10,SPFGoalie+87,-15
.d2:	dw SPFGoalie+88,10,SPFGoalie+89,10,SPFGoalie+90,10,SPFGoalie+91,-15
.d3:	dw SPFGoalie+92,10,SPFGoalie+93,10,SPFGoalie+94,10,SPFGoalie+95,-15
.d4:	dw SPFGoalie+96,10,SPFGoalie+97,10,SPFGoalie+98,10,SPFGoalie+99,-15
.d5:	dw SPFGoalie+100,10,SPFGoalie+101,10,SPFGoalie+102,10,SPFGoalie+103,-15
.d6:	dw SPFGoalie+104,10,SPFGoalie+105,10,SPFGoalie+106,10,SPFGoalie+107,-15
.d7:	dw SPFGoalie+108,10,SPFGoalie+109,10,SPFGoalie+110,10,SPFGoalie+111,-15
	assert SPAgskate_table-SPAList == SPAgskate

SPApflip_table:		;SPA $03D6
	dw .d0-SPApflip_table		; direction 0
	dw .d1-SPApflip_table		; direction 1
	dw .d2-SPApflip_table		; direction 2
	dw .d3-SPApflip_table		; direction 3
	dw .d4-SPApflip_table		; direction 4
	dw .d5-SPApflip_table		; direction 5
	dw .d6-SPApflip_table		; direction 6
	dw .d7-SPApflip_table		; direction 7
	dw 1		; attributes: loops
.d0:	dw SPFpuck+2,4,SPFpuck+3,4,SPFpuck+4,4,SPFpuck+5,4,SPFpuck+6,4,SPFpuck+3,4,SPFpuck+7,4,SPFpuck+1,-4
.d1:	dw SPFpuck+9,2,SPFpuck+1,2,SPFpuck+8,2,SPFpuck+5,2,SPFpuck+10,2,SPFpuck+5,2,SPFpuck+8,2,SPFpuck+1,-2
.d2:	dw SPFpuck+4,2,SPFpuck+3,2,SPFpuck+2,2,SPFpuck+1,2,SPFpuck+7,2,SPFpuck+3,2,SPFpuck+6,2,SPFpuck+5,-2
.d3:	dw SPFpuck+8,4,SPFpuck+1,4,SPFpuck+9,4,SPFpuck+1,4,SPFpuck+8,4,SPFpuck+5,4,SPFpuck+10,4,SPFpuck+5,-4
.d4:	dw SPFpuck+1,-4096
.d5:	dw SPFpuck+1,-4096
.d6:	dw SPFpuck+5,-4096
.d7:	dw SPFpuck+5,-4096
	assert SPApflip_table-SPAList == SPApflip

SPAglide_table:		;SPA $0478
	dw .d0-SPAglide_table		; direction 0
	dw .d1-SPAglide_table		; direction 1
	dw .d2-SPAglide_table		; direction 2
	dw .d3-SPAglide_table		; direction 3
	dw .d4-SPAglide_table		; direction 4
	dw .d5-SPAglide_table		; direction 5
	dw .d6-SPAglide_table		; direction 6
	dw .d7-SPAglide_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFskatewp,-8
.d1:	dw SPFskatewp+5,-8
.d2:	dw SPFskatewp+10,-8
.d3:	dw SPFskatewp+15,-8
.d4:	dw SPFskatewp+20,-8
.d5:	dw SPFskatewp+25,-8
.d6:	dw SPFskatewp+30,-8
.d7:	dw SPFskatewp+35,-8
	assert SPAglide_table-SPAList == SPAglide

SPAskatewp_table:		;SPA $04AA
	dw .d0-SPAskatewp_table		; direction 0
	dw .d1-SPAskatewp_table		; direction 1
	dw .d2-SPAskatewp_table		; direction 2
	dw .d3-SPAskatewp_table		; direction 3
	dw .d4-SPAskatewp_table		; direction 4
	dw .d5-SPAskatewp_table		; direction 5
	dw .d6-SPAskatewp_table		; direction 6
	dw .d7-SPAskatewp_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFskatewp+1,10,SPFskatewp+2,10,SPFskatewp+3,10,SPFskatewp+4,10,SPFskatewp,-15
.d1:	dw SPFskatewp+6,10,SPFskatewp+7,10,SPFskatewp+8,10,SPFskatewp+9,10,SPFskatewp+5,-15
.d2:	dw SPFskatewp+11,10,SPFskatewp+12,10,SPFskatewp+13,10,SPFskatewp+14,10,SPFskatewp+10,-15
.d3:	dw SPFskatewp+16,10,SPFskatewp+17,10,SPFskatewp+18,10,SPFskatewp+19,10,SPFskatewp+15,-15
.d4:	dw SPFskatewp+21,10,SPFskatewp+22,10,SPFskatewp+23,10,SPFskatewp+24,10,SPFskatewp+20,-15
.d5:	dw SPFskatewp+26,10,SPFskatewp+27,10,SPFskatewp+28,10,SPFskatewp+29,10,SPFskatewp+25,-15
.d6:	dw SPFskatewp+31,10,SPFskatewp+32,10,SPFskatewp+33,10,SPFskatewp+34,10,SPFskatewp+30,-15
.d7:	dw SPFskatewp+36,10,SPFskatewp+37,10,SPFskatewp+38,10,SPFskatewp+39,10,SPFskatewp+35,-15
	assert SPAskatewp_table-SPAList == SPAskatewp

SPAskate_table:		;SPA $055C
	dw .d0-SPAskate_table		; direction 0
	dw .d1-SPAskate_table		; direction 1
	dw .d2-SPAskate_table		; direction 2
	dw .d3-SPAskate_table		; direction 3
	dw .d4-SPAskate_table		; direction 4
	dw .d5-SPAskate_table		; direction 5
	dw .d6-SPAskate_table		; direction 6
	dw .d7-SPAskate_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFskate+1,10,SPFskate+2,10,SPFskate+3,10,SPFskate+4,10,SPFskate,-15
.d1:	dw SPFskate+6,10,SPFskate+7,10,SPFskate+8,10,SPFskate+9,10,SPFskate+5,-15
.d2:	dw SPFskate+11,10,SPFskate+12,10,SPFskate+13,10,SPFskate+14,10,SPFskate+10,-15
.d3:	dw SPFskate+16,10,SPFskate+17,10,SPFskate+18,10,SPFskate+19,10,SPFskate+15,-15
.d4:	dw SPFskate+21,10,SPFskate+22,10,SPFskate+23,10,SPFskate+24,10,SPFskate+20,-15
.d5:	dw SPFskate+26,10,SPFskate+27,10,SPFskate+28,10,SPFskate+29,10,SPFskate+25,-15
.d6:	dw SPFskate+31,10,SPFskate+32,10,SPFskate+33,10,SPFskate+34,10,SPFskate+30,-15
.d7:	dw SPFskate+36,10,SPFskate+37,10,SPFskate+38,10,SPFskate+39,10,SPFskate+35,-15
	assert SPAskate_table-SPAList == SPAskate

SPAturnl_table:		;SPA $060E
	dw .d0-SPAturnl_table		; direction 0
	dw .d1-SPAturnl_table		; direction 1
	dw .d2-SPAturnl_table		; direction 2
	dw .d3-SPAturnl_table		; direction 3
	dw .d4-SPAturnl_table		; direction 4
	dw .d5-SPAturnl_table		; direction 5
	dw .d6-SPAturnl_table		; direction 6
	dw .d7-SPAturnl_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFturnl,-18
.d1:	dw SPFturnl+1,-18
.d2:	dw SPFturnl+2,-18
.d3:	dw SPFturnl+3,-18
.d4:	dw SPFturnl+4,-18
.d5:	dw SPFturnl+5,-18
.d6:	dw SPFturnl+6,-18
.d7:	dw SPFturnl+7,-18
	assert SPAturnl_table-SPAList == SPAturnl

SPAturnr_table:		;SPA $0640
	dw .d0-SPAturnr_table		; direction 0
	dw .d1-SPAturnr_table		; direction 1
	dw .d2-SPAturnr_table		; direction 2
	dw .d3-SPAturnr_table		; direction 3
	dw .d4-SPAturnr_table		; direction 4
	dw .d5-SPAturnr_table		; direction 5
	dw .d6-SPAturnr_table		; direction 6
	dw .d7-SPAturnr_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFturnr,-18
.d1:	dw SPFturnr+1,-18
.d2:	dw SPFturnr+2,-18
.d3:	dw SPFturnr+3,-18
.d4:	dw SPFturnr+4,-18
.d5:	dw SPFturnr+5,-18
.d6:	dw SPFturnr+6,-18
.d7:	dw SPFturnr+7,-18
	assert SPAturnr_table-SPAList == SPAturnr

SPAstop_table:		;SPA $0672
	dw .d0-SPAstop_table		; direction 0
	dw .d1-SPAstop_table		; direction 1
	dw .d2-SPAstop_table		; direction 2
	dw .d3-SPAstop_table		; direction 3
	dw .d4-SPAstop_table		; direction 4
	dw .d5-SPAstop_table		; direction 5
	dw .d6-SPAstop_table		; direction 6
	dw .d7-SPAstop_table		; direction 7
	dw 1		; attributes: loops
.d0:	dw SPFstop,4,SPFstop+1,-4
.d1:	dw SPFstop+2,4,SPFstop+3,-4
.d2:	dw SPFstop+4,4,SPFstop+5,-4
.d3:	dw SPFstop+6,4,SPFstop+7,-4
.d4:	dw SPFstop+8,4,SPFstop+9,-4
.d5:	dw SPFstop+10,4,SPFstop+11,-4
.d6:	dw SPFstop+12,4,SPFstop+13,-4
.d7:	dw SPFstop+14,4,SPFstop+15,-4
	assert SPAstop_table-SPAList == SPAstop

SPApassf_table:		;SPA $06C4
	dw .d0-SPApassf_table		; direction 0
	dw .d1-SPApassf_table		; direction 1
	dw .d2-SPApassf_table		; direction 2
	dw .d3-SPApassf_table		; direction 3
	dw .d4-SPApassf_table		; direction 4
	dw .d5-SPApassf_table		; direction 5
	dw .d6-SPApassf_table		; direction 6
	dw .d7-SPApassf_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFswing+3,4,SPFswing+4,4,SPFswing+5,-20
.d1:	dw SPFswing+9,4,SPFswing+10,4,SPFswing+11,-20
.d2:	dw SPFswing+15,4,SPFswing+16,4,SPFswing+17,-20
.d3:	dw SPFswing+21,4,SPFswing+22,4,SPFswing+23,-20
.d4:	dw SPFswing+27,4,SPFswing+28,4,SPFswing+29,-20
.d5:	dw SPFswing+33,4,SPFswing+34,4,SPFswing+35,-20
.d6:	dw SPFswing+39,4,SPFswing+40,4,SPFswing+41,-20
.d7:	dw SPFswing+45,4,SPFswing+46,4,SPFswing+47,-20
	assert SPApassf_table-SPAList == SPApassf

SPApassb_table:		;SPA $0736
	dw .d0-SPApassb_table		; direction 0
	dw .d1-SPApassb_table		; direction 1
	dw .d2-SPApassb_table		; direction 2
	dw .d3-SPApassb_table		; direction 3
	dw .d4-SPApassb_table		; direction 4
	dw .d5-SPApassb_table		; direction 5
	dw .d6-SPApassb_table		; direction 6
	dw .d7-SPApassb_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFswing+3,4,SPFswing+2,4,SPFswing+1,-20
.d1:	dw SPFswing+9,4,SPFswing+8,4,SPFswing+7,-20
.d2:	dw SPFswing+15,4,SPFswing+14,4,SPFswing+13,-20
.d3:	dw SPFswing+21,4,SPFswing+20,4,SPFswing+19,-20
.d4:	dw SPFswing+27,4,SPFswing+26,4,SPFswing+25,-20
.d5:	dw SPFswing+33,4,SPFswing+32,4,SPFswing+31,-20
.d6:	dw SPFswing+39,4,SPFswing+38,4,SPFswing+37,-20
.d7:	dw SPFswing+45,4,SPFswing+44,4,SPFswing+43,-20
	assert SPApassb_table-SPAList == SPApassb

SPAshotf_table:		;SPA $07A8
	dw .d0-SPAshotf_table		; direction 0
	dw .d1-SPAshotf_table		; direction 1
	dw .d2-SPAshotf_table		; direction 2
	dw .d3-SPAshotf_table		; direction 3
	dw .d4-SPAshotf_table		; direction 4
	dw .d5-SPAshotf_table		; direction 5
	dw .d6-SPAshotf_table		; direction 6
	dw .d7-SPAshotf_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFswing+3,4,SPFswing+2,4,SPFswing+1,4,SPFswing,4,SPFswing+2,0,SPFswing+3,0,SPFswing+4,0,SPFswing+5,-20
.d1:	dw SPFswing+9,4,SPFswing+8,4,SPFswing+7,4,SPFswing+6,4,SPFswing+8,0,SPFswing+9,0,SPFswing+10,0,SPFswing+11,-20
.d2:	dw SPFswing+15,4,SPFswing+14,4,SPFswing+13,4,SPFswing+12,4,SPFswing+14,0,SPFswing+15,0,SPFswing+16,0,SPFswing+17,-20
.d3:	dw SPFswing+21,4,SPFswing+20,4,SPFswing+19,4,SPFswing+18,4,SPFswing+20,0,SPFswing+21,0,SPFswing+22,0,SPFswing+23,-20
.d4:	dw SPFswing+27,4,SPFswing+26,4,SPFswing+25,4,SPFswing+24,4,SPFswing+26,0,SPFswing+27,0,SPFswing+28,0,SPFswing+29,-20
.d5:	dw SPFswing+33,4,SPFswing+32,4,SPFswing+31,4,SPFswing+30,4,SPFswing+32,0,SPFswing+33,0,SPFswing+34,0,SPFswing+35,-20
.d6:	dw SPFswing+39,4,SPFswing+38,4,SPFswing+37,4,SPFswing+36,4,SPFswing+38,0,SPFswing+39,0,SPFswing+40,0,SPFswing+41,-20
.d7:	dw SPFswing+45,4,SPFswing+44,4,SPFswing+43,4,SPFswing+42,4,SPFswing+44,0,SPFswing+45,0,SPFswing+46,0,SPFswing+47,-20
	assert SPAshotf_table-SPAList == SPAshotf

SPAshotb_table:		;SPA $08BA
	dw .d0-SPAshotb_table		; direction 0
	dw .d1-SPAshotb_table		; direction 1
	dw .d2-SPAshotb_table		; direction 2
	dw .d3-SPAshotb_table		; direction 3
	dw .d4-SPAshotb_table		; direction 4
	dw .d5-SPAshotb_table		; direction 5
	dw .d6-SPAshotb_table		; direction 6
	dw .d7-SPAshotb_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFswing+3,4,SPFswing+4,4,SPFswing+5,4,SPFswing+5,4,SPFswing+4,0,SPFswing+3,0,SPFswing+2,0,SPFswing+1,-20
.d1:	dw SPFswing+9,4,SPFswing+10,4,SPFswing+11,4,SPFswing+11,4,SPFswing+10,0,SPFswing+9,0,SPFswing+8,0,SPFswing+7,-20
.d2:	dw SPFswing+15,4,SPFswing+16,4,SPFswing+17,4,SPFswing+17,4,SPFswing+16,0,SPFswing+15,0,SPFswing+14,0,SPFswing+13,-20
.d3:	dw SPFswing+21,4,SPFswing+22,4,SPFswing+23,4,SPFswing+23,4,SPFswing+22,0,SPFswing+21,0,SPFswing+20,0,SPFswing+19,-20
.d4:	dw SPFswing+27,4,SPFswing+28,4,SPFswing+29,4,SPFswing+29,4,SPFswing+28,0,SPFswing+27,0,SPFswing+26,0,SPFswing+25,-20
.d5:	dw SPFswing+33,4,SPFswing+34,4,SPFswing+35,4,SPFswing+35,4,SPFswing+34,0,SPFswing+33,0,SPFswing+32,0,SPFswing+31,-20
.d6:	dw SPFswing+39,4,SPFswing+40,4,SPFswing+41,4,SPFswing+41,4,SPFswing+40,0,SPFswing+39,0,SPFswing+38,0,SPFswing+37,-20
.d7:	dw SPFswing+45,4,SPFswing+46,4,SPFswing+47,4,SPFswing+47,4,SPFswing+46,0,SPFswing+45,0,SPFswing+44,0,SPFswing+43,-20
	assert SPAshotb_table-SPAList == SPAshotb

SPAglideback_table:		;SPA $09CC
	dw .d0-SPAglideback_table		; direction 0
	dw .d1-SPAglideback_table		; direction 1
	dw .d2-SPAglideback_table		; direction 2
	dw .d3-SPAglideback_table		; direction 3
	dw .d4-SPAglideback_table		; direction 4
	dw .d5-SPAglideback_table		; direction 5
	dw .d6-SPAglideback_table		; direction 6
	dw .d7-SPAglideback_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFskateb,-8
.d1:	dw SPFskateb+3,-8
.d2:	dw SPFskateb+6,-8
.d3:	dw SPFskateb+9,-8
.d4:	dw SPFskateb+12,-8
.d5:	dw SPFskateb+15,-8
.d6:	dw SPFskateb+18,-8
.d7:	dw SPFskateb+21,-8
	assert SPAglideback_table-SPAList == SPAglideback

SPAskateback_table:		;SPA $09FE
	dw .d0-SPAskateback_table		; direction 0
	dw .d1-SPAskateback_table		; direction 1
	dw .d2-SPAskateback_table		; direction 2
	dw .d3-SPAskateback_table		; direction 3
	dw .d4-SPAskateback_table		; direction 4
	dw .d5-SPAskateback_table		; direction 5
	dw .d6-SPAskateback_table		; direction 6
	dw .d7-SPAskateback_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFskateb,10,SPFskateb+1,10,SPFskateb,10,SPFskateb+2,-10
.d1:	dw SPFskateb+3,10,SPFskateb+4,10,SPFskateb+3,10,SPFskateb+5,-10
.d2:	dw SPFskateb+6,10,SPFskateb+7,10,SPFskateb+6,10,SPFskateb+8,-10
.d3:	dw SPFskateb+9,10,SPFskateb+10,10,SPFskateb+9,10,SPFskateb+11,-10
.d4:	dw SPFskateb+12,10,SPFskateb+13,10,SPFskateb+12,10,SPFskateb+14,-10
.d5:	dw SPFskateb+15,10,SPFskateb+16,10,SPFskateb+15,10,SPFskateb+17,-10
.d6:	dw SPFskateb+18,10,SPFskateb+19,10,SPFskateb+18,10,SPFskateb+20,-10
.d7:	dw SPFskateb+21,10,SPFskateb+22,10,SPFskateb+21,10,SPFskateb+23,-10
	assert SPAskateback_table-SPAList == SPAskateback

SPAsweepchk_table:		;SPA $0A90
	dw .d0-SPAsweepchk_table		; direction 0
	dw .d1-SPAsweepchk_table		; direction 1
	dw .d2-SPAsweepchk_table		; direction 2
	dw .d3-SPAsweepchk_table		; direction 3
	dw .d4-SPAsweepchk_table		; direction 4
	dw .d5-SPAsweepchk_table		; direction 5
	dw .d6-SPAsweepchk_table		; direction 6
	dw .d7-SPAsweepchk_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFsweep,4,SPFsweep+1,8,SPFsweep,-4
.d1:	dw SPFsweep+2,4,SPFsweep+3,8,SPFsweep+2,-4
.d2:	dw SPFsweep+4,4,SPFsweep+5,8,SPFsweep+4,-4
.d3:	dw SPFsweep+6,4,SPFsweep+7,8,SPFsweep+6,-4
.d4:	dw SPFsweep+8,4,SPFsweep+9,8,SPFsweep+8,-4
.d5:	dw SPFsweep+10,4,SPFsweep+11,8,SPFsweep+10,-4
.d6:	dw SPFsweep+12,4,SPFsweep+13,8,SPFsweep+12,-4
.d7:	dw SPFsweep+14,4,SPFsweep+15,8,SPFsweep+14,-4
	assert SPAsweepchk_table-SPAList == SPAsweepchk

SPAshoulderchkl_table:		;SPA $0B02
	dw .d0-SPAshoulderchkl_table		; direction 0
	dw .d1-SPAshoulderchkl_table		; direction 1
	dw .d2-SPAshoulderchkl_table		; direction 2
	dw .d3-SPAshoulderchkl_table		; direction 3
	dw .d4-SPAshoulderchkl_table		; direction 4
	dw .d5-SPAshoulderchkl_table		; direction 5
	dw .d6-SPAshoulderchkl_table		; direction 6
	dw .d7-SPAshoulderchkl_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFshoulderl,-24
.d1:	dw SPFshoulderl+1,-24
.d2:	dw SPFshoulderl+2,-24
.d3:	dw SPFshoulderl+3,-24
.d4:	dw SPFshoulderl+4,-24
.d5:	dw SPFshoulderl+5,-24
.d6:	dw SPFshoulderl+6,-24
.d7:	dw SPFshoulderl+7,-24
	assert SPAshoulderchkl_table-SPAList == SPAshoulderchkl

SPAshoulderchkr_table:		;SPA $0B34
	dw .d0-SPAshoulderchkr_table		; direction 0
	dw .d1-SPAshoulderchkr_table		; direction 1
	dw .d2-SPAshoulderchkr_table		; direction 2
	dw .d3-SPAshoulderchkr_table		; direction 3
	dw .d4-SPAshoulderchkr_table		; direction 4
	dw .d5-SPAshoulderchkr_table		; direction 5
	dw .d6-SPAshoulderchkr_table		; direction 6
	dw .d7-SPAshoulderchkr_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFshoulderr,-24
.d1:	dw SPFshoulderr+1,-24
.d2:	dw SPFshoulderr+2,-24
.d3:	dw SPFshoulderr+3,-24
.d4:	dw SPFshoulderr+4,-24
.d5:	dw SPFshoulderr+5,-24
.d6:	dw SPFshoulderr+6,-24
.d7:	dw SPFshoulderr+7,-24
	assert SPAshoulderchkr_table-SPAList == SPAshoulderchkr

SPAhipchkl_table:		;SPA $0B66
	dw .d0-SPAhipchkl_table		; direction 0
	dw .d1-SPAhipchkl_table		; direction 1
	dw .d2-SPAhipchkl_table		; direction 2
	dw .d3-SPAhipchkl_table		; direction 3
	dw .d4-SPAhipchkl_table		; direction 4
	dw .d5-SPAhipchkl_table		; direction 5
	dw .d6-SPAhipchkl_table		; direction 6
	dw .d7-SPAhipchkl_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFhipl,-24
.d1:	dw SPFhipl+1,-24
.d2:	dw SPFhipl+2,-24
.d3:	dw SPFhipl+3,-24
.d4:	dw SPFhipl+4,-24
.d5:	dw SPFhipl+5,-24
.d6:	dw SPFhipl+6,-24
.d7:	dw SPFhipl+7,-24
	assert SPAhipchkl_table-SPAList == SPAhipchkl

SPAhipchkr_table:		;SPA $0B98
	dw .d0-SPAhipchkr_table		; direction 0
	dw .d1-SPAhipchkr_table		; direction 1
	dw .d2-SPAhipchkr_table		; direction 2
	dw .d3-SPAhipchkr_table		; direction 3
	dw .d4-SPAhipchkr_table		; direction 4
	dw .d5-SPAhipchkr_table		; direction 5
	dw .d6-SPAhipchkr_table		; direction 6
	dw .d7-SPAhipchkr_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFhipr,-24
.d1:	dw SPFhipr+1,-24
.d2:	dw SPFhipr+2,-24
.d3:	dw SPFhipr+3,-24
.d4:	dw SPFhipr+4,-24
.d5:	dw SPFhipr+5,-24
.d6:	dw SPFhipr+6,-24
.d7:	dw SPFhipr+7,-24
	assert SPAhipchkr_table-SPAList == SPAhipchkr

SPAburst_table:		;SPA $0BCA
	dw .d0-SPAburst_table		; direction 0
	dw .d1-SPAburst_table		; direction 1
	dw .d2-SPAburst_table		; direction 2
	dw .d3-SPAburst_table		; direction 3
	dw .d4-SPAburst_table		; direction 4
	dw .d5-SPAburst_table		; direction 5
	dw .d6-SPAburst_table		; direction 6
	dw .d7-SPAburst_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFskate,-24
.d1:	dw SPFskate+5,-24
.d2:	dw SPFskate+10,-24
.d3:	dw SPFskate+15,-24
.d4:	dw SPFskate+20,-24
.d5:	dw SPFskate+25,-24
.d6:	dw SPFskate+30,-24
.d7:	dw SPFskate+35,-24
	assert SPAburst_table-SPAList == SPAburst

SPAHold_table:		;SPA $0BFC
	dw .d0-SPAHold_table		; direction 0
	dw .d1-SPAHold_table		; direction 1
	dw .d2-SPAHold_table		; direction 2
	dw .d3-SPAHold_table		; direction 3
	dw .d4-SPAHold_table		; direction 4
	dw .d5-SPAHold_table		; direction 5
	dw .d6-SPAHold_table		; direction 6
	dw .d7-SPAHold_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFhold,-30
.d1:	dw SPFhold+1,-30
.d2:	dw SPFhold+2,-30
.d3:	dw SPFhold+3,-30
.d4:	dw SPFhold+4,-30
.d5:	dw SPFhold+5,-30
.d6:	dw SPFhold+6,-30
.d7:	dw SPFhold+7,-30
	assert SPAHold_table-SPAList == SPAHold

SPAHold2_table:		;SPA $0C2E
	dw .d0-SPAHold2_table		; direction 0
	dw .d1-SPAHold2_table		; direction 1
	dw .d2-SPAHold2_table		; direction 2
	dw .d3-SPAHold2_table		; direction 3
	dw .d4-SPAHold2_table		; direction 4
	dw .d5-SPAHold2_table		; direction 5
	dw .d6-SPAHold2_table		; direction 6
	dw .d7-SPAHold2_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFhold,-30
.d1:	dw SPFhold+1,-30
.d2:	dw SPFhold+2,-30
.d3:	dw SPFhold+3,-30
.d4:	dw SPFhold+4,-30
.d5:	dw SPFhold+5,-30
.d6:	dw SPFhold+6,-30
.d7:	dw SPFhold+7,-30
	assert SPAHold2_table-SPAList == SPAHold2

SPAflail_table:		;SPA $0C60
	dw .d0-SPAflail_table		; direction 0
	dw .d1-SPAflail_table		; direction 1
	dw .d2-SPAflail_table		; direction 2
	dw .d3-SPAflail_table		; direction 3
	dw .d4-SPAflail_table		; direction 4
	dw .d5-SPAflail_table		; direction 5
	dw .d6-SPAflail_table		; direction 6
	dw .d7-SPAflail_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFskate,-30
.d1:	dw SPFskate+5,-30
.d2:	dw SPFskate+10,-30
.d3:	dw SPFskate+15,-30
.d4:	dw SPFskate+20,-30
.d5:	dw SPFskate+25,-30
.d6:	dw SPFskate+30,-30
.d7:	dw SPFskate+35,-30
	assert SPAflail_table-SPAList == SPAflail

SPAfallfwd_table:		;SPA $0C92
	dw .d0-SPAfallfwd_table		; direction 0
	dw .d1-SPAfallfwd_table		; direction 1
	dw .d2-SPAfallfwd_table		; direction 2
	dw .d3-SPAfallfwd_table		; direction 3
	dw .d4-SPAfallfwd_table		; direction 4
	dw .d5-SPAfallfwd_table		; direction 5
	dw .d6-SPAfallfwd_table		; direction 6
	dw .d7-SPAfallfwd_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfallfwd,6,SPFfallfwd+1,6,SPFfallfwd+2,100,SPFfallfwd+3,8,SPFduck,-8
.d1:	dw SPFfallfwd+4,6,SPFfallfwd+5,6,SPFfallfwd+6,100,SPFfallfwd+7,8,SPFduck+1,-8
.d2:	dw SPFfallfwd+8,6,SPFfallfwd+9,6,SPFfallfwd+10,100,SPFfallfwd+11,8,SPFduck+2,-8
.d3:	dw SPFfallfwd+12,6,SPFfallfwd+13,6,SPFfallfwd+14,100,SPFfallfwd+15,8,SPFduck+3,-8
.d4:	dw SPFfallfwd+16,6,SPFfallfwd+17,6,SPFfallfwd+18,100,SPFfallfwd+19,8,SPFduck+4,-8
.d5:	dw SPFfallfwd+20,6,SPFfallfwd+21,6,SPFfallfwd+22,100,SPFfallfwd+23,8,SPFduck+5,-8
.d6:	dw SPFfallfwd+24,6,SPFfallfwd+25,6,SPFfallfwd+26,100,SPFfallfwd+27,8,SPFduck+6,-8
.d7:	dw SPFfallfwd+28,6,SPFfallfwd+29,6,SPFfallfwd+30,100,SPFfallfwd+31,8,SPFduck+7,-8
	assert SPAfallfwd_table-SPAList == SPAfallfwd

SPAfallback_table:		;SPA $0D44
	dw .d0-SPAfallback_table		; direction 0
	dw .d1-SPAfallback_table		; direction 1
	dw .d2-SPAfallback_table		; direction 2
	dw .d3-SPAfallback_table		; direction 3
	dw .d4-SPAfallback_table		; direction 4
	dw .d5-SPAfallback_table		; direction 5
	dw .d6-SPAfallback_table		; direction 6
	dw .d7-SPAfallback_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfallback,6,SPFfallback+1,6,SPFfallback+2,100,SPFfallback+3,8,SPFduck,-8
.d1:	dw SPFfallback+4,6,SPFfallback+5,6,SPFfallback+6,100,SPFfallback+7,8,SPFduck+1,-8
.d2:	dw SPFfallback+8,6,SPFfallback+9,6,SPFfallback+10,100,SPFfallback+11,8,SPFduck+2,-8
.d3:	dw SPFfallback+12,6,SPFfallback+13,6,SPFfallback+14,100,SPFfallback+15,8,SPFduck+3,-8
.d4:	dw SPFfallback+16,6,SPFfallback+17,6,SPFfallback+18,100,SPFfallback+19,8,SPFduck+4,-8
.d5:	dw SPFfallback+20,6,SPFfallback+21,6,SPFfallback+22,100,SPFfallback+23,8,SPFduck+5,-8
.d6:	dw SPFfallback+24,6,SPFfallback+25,6,SPFfallback+26,100,SPFfallback+27,8,SPFduck+6,-8
.d7:	dw SPFfallback+28,6,SPFfallback+29,6,SPFfallback+30,100,SPFfallback+31,8,SPFduck+7,-8
	assert SPAfallback_table-SPAList == SPAfallback

SPAcelebrate_table:		;SPA $0DF6
	dw .d0-SPAcelebrate_table		; direction 0
	dw .d1-SPAcelebrate_table		; direction 1
	dw .d2-SPAcelebrate_table		; direction 2
	dw .d3-SPAcelebrate_table		; direction 3
	dw .d4-SPAcelebrate_table		; direction 4
	dw .d5-SPAcelebrate_table		; direction 5
	dw .d6-SPAcelebrate_table		; direction 6
	dw .d7-SPAcelebrate_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFcelebrate,12,SPFcelebrate+1,40,SPFcelebrate,-5
.d1:	dw SPFcelebrate+2,12,SPFcelebrate+3,40,SPFcelebrate+2,-5
.d2:	dw SPFcelebrate+4,12,SPFcelebrate+5,40,SPFcelebrate+4,-5
.d3:	dw SPFcelebrate+6,12,SPFcelebrate+7,40,SPFcelebrate+6,-5
.d4:	dw SPFcelebrate+8,12,SPFcelebrate+9,40,SPFcelebrate+8,-5
.d5:	dw SPFcelebrate+10,12,SPFcelebrate+11,40,SPFcelebrate+10,-5
.d6:	dw SPFcelebrate+12,12,SPFcelebrate+13,40,SPFcelebrate+12,-5
.d7:	dw SPFcelebrate+14,12,SPFcelebrate+15,40,SPFcelebrate+14,-5
	assert SPAcelebrate_table-SPAList == SPAcelebrate

SPApump_table:		;SPA $0E68
	dw .d0-SPApump_table		; direction 0
	dw .d1-SPApump_table		; direction 1
	dw .d2-SPApump_table		; direction 2
	dw .d3-SPApump_table		; direction 3
	dw .d4-SPApump_table		; direction 4
	dw .d5-SPApump_table		; direction 5
	dw .d6-SPApump_table		; direction 6
	dw .d7-SPApump_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFpump,8,SPFpump+1,8,SPFpump,-8
.d1:	dw SPFpump+2,8,SPFpump+3,8,SPFpump+2,-8
.d2:	dw SPFpump+4,8,SPFpump+5,8,SPFpump+4,-8
.d3:	dw SPFpump+6,8,SPFpump+7,8,SPFpump+6,-8
.d4:	dw SPFpump+8,8,SPFpump+9,8,SPFpump+8,-8
.d5:	dw SPFpump+10,8,SPFpump+11,8,SPFpump+10,-8
.d6:	dw SPFpump+12,8,SPFpump+13,8,SPFpump+12,-8
.d7:	dw SPFpump+14,8,SPFpump+15,8,SPFpump+14,-8
	assert SPApump_table-SPAList == SPApump

SPAfight_table:		;SPA $0EDA
	dw .d0-SPAfight_table		; direction 0
	dw .d0-SPAfight_table		; direction 1
	dw .d0-SPAfight_table		; direction 2
	dw .d3-SPAfight_table		; direction 3
	dw .d3-SPAfight_table		; direction 4
	dw .d3-SPAfight_table		; direction 5
	dw .d3-SPAfight_table		; direction 6
	dw .d3-SPAfight_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfight,8,SPFfight+1,8,SPFfight+2,8,SPFfight+3,-6
.d3:	dw SPFfight,8,SPFfight+1,8,SPFfight+2,8,SPFfight+8,-6
	assert SPAfight_table-SPAList == SPAfight

SPAfgrab_table:		;SPA $0F0C
	dw .d0-SPAfgrab_table		; direction 0
	dw .d0-SPAfgrab_table		; direction 1
	dw .d0-SPAfgrab_table		; direction 2
	dw .d3-SPAfgrab_table		; direction 3
	dw .d3-SPAfgrab_table		; direction 4
	dw .d3-SPAfgrab_table		; direction 5
	dw .d3-SPAfgrab_table		; direction 6
	dw .d3-SPAfgrab_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfight+4,28,SPFfight+3,-4
.d3:	dw SPFfight+9,28,SPFfight+8,-4
	assert SPAfgrab_table-SPAList == SPAfgrab

SPAfheld_table:		;SPA $0F2E
	dw .d0-SPAfheld_table		; direction 0
	dw .d0-SPAfheld_table		; direction 1
	dw .d0-SPAfheld_table		; direction 2
	dw .d3-SPAfheld_table		; direction 3
	dw .d3-SPAfheld_table		; direction 4
	dw .d3-SPAfheld_table		; direction 5
	dw .d3-SPAfheld_table		; direction 6
	dw .d3-SPAfheld_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfight+4,30,SPFfight+3,-4
.d3:	dw SPFfight+9,30,SPFfight+8,-4
	assert SPAfheld_table-SPAList == SPAfheld

SPAfhigh_table:		;SPA $0F50
	dw .d0-SPAfhigh_table		; direction 0
	dw .d0-SPAfhigh_table		; direction 1
	dw .d0-SPAfhigh_table		; direction 2
	dw .d3-SPAfhigh_table		; direction 3
	dw .d3-SPAfhigh_table		; direction 4
	dw .d3-SPAfhigh_table		; direction 5
	dw .d3-SPAfhigh_table		; direction 6
	dw .d3-SPAfhigh_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfight+5,6,SPFfight+6,16,SPFfight+5,4,SPFfight+3,-16
.d3:	dw SPFfight+10,6,SPFfight+11,16,SPFfight+10,4,SPFfight+8,-16
	assert SPAfhigh_table-SPAList == SPAfhigh

SPAflow_table:		;SPA $0F82
	dw .d0-SPAflow_table		; direction 0
	dw .d0-SPAflow_table		; direction 1
	dw .d0-SPAflow_table		; direction 2
	dw .d3-SPAflow_table		; direction 3
	dw .d3-SPAflow_table		; direction 4
	dw .d3-SPAflow_table		; direction 5
	dw .d3-SPAflow_table		; direction 6
	dw .d3-SPAflow_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfight+5,6,SPFfight+7,16,SPFfight+5,4,SPFfight+3,-16
.d3:	dw SPFfight+10,6,SPFfight+12,16,SPFfight+10,4,SPFfight+8,-16
	assert SPAflow_table-SPAList == SPAflow

SPAfhith_table:		;SPA $0FB4
	dw .d0-SPAfhith_table		; direction 0
	dw .d0-SPAfhith_table		; direction 1
	dw .d0-SPAfhith_table		; direction 2
	dw .d3-SPAfhith_table		; direction 3
	dw .d3-SPAfhith_table		; direction 4
	dw .d3-SPAfhith_table		; direction 5
	dw .d3-SPAfhith_table		; direction 6
	dw .d3-SPAfhith_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfight+14,16,SPFfight+3,-8
.d3:	dw SPFfight+14,16,SPFfight+8,-8
	assert SPAfhith_table-SPAList == SPAfhith

SPAfhitl_table:		;SPA $0FD6
	dw .d0-SPAfhitl_table		; direction 0
	dw .d0-SPAfhitl_table		; direction 1
	dw .d0-SPAfhitl_table		; direction 2
	dw .d3-SPAfhitl_table		; direction 3
	dw .d3-SPAfhitl_table		; direction 4
	dw .d3-SPAfhitl_table		; direction 5
	dw .d3-SPAfhitl_table		; direction 6
	dw .d3-SPAfhitl_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfight+13,16,SPFfight+3,-8
.d3:	dw SPFfight+13,16,SPFfight+8,-8
	assert SPAfhitl_table-SPAList == SPAfhitl

SPAffall_table:		;SPA $0FF8
	dw .d0-SPAffall_table		; direction 0
	dw .d0-SPAffall_table		; direction 1
	dw .d0-SPAffall_table		; direction 2
	dw .d0-SPAffall_table		; direction 3
	dw .d0-SPAffall_table		; direction 4
	dw .d0-SPAffall_table		; direction 5
	dw .d0-SPAffall_table		; direction 6
	dw .d0-SPAffall_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfight+14,8,SPFfight+15,8,SPFfight+16,200,SPFfight+16,-2
	assert SPAffall_table-SPAList == SPAffall

SPAwallright_table:		;SPA $101A
	dw .d0-SPAwallright_table		; direction 0
	dw .d1-SPAwallright_table		; direction 1
	dw .d1-SPAwallright_table		; direction 2
	dw .d3-SPAwallright_table		; direction 3
	dw .d3-SPAwallright_table		; direction 4
	dw .d3-SPAwallright_table		; direction 5
	dw .d3-SPAwallright_table		; direction 6
	dw SPAwallleft_table-SPAwallright_table		; direction 7: points at the next table header
	dw 0		; attributes
.d0:	dw SPFPen+4,8,SPFPen+5,8,SPFPen+6,-8
.d1:	dw SPFPen,8,SPFPen+1,8,SPFPen+2,8,SPFPen+3,-8
.d3:	dw SPFPen+3,8,SPFPen+2,8,SPFPen+1,8,SPFPen,-8
	assert SPAwallright_table-SPAList == SPAwallright

SPAwallleft_table:		;SPA $1058
	dw .d0-SPAwallleft_table		; direction 0
	dw .d1-SPAwallleft_table		; direction 1
	dw .d1-SPAwallleft_table		; direction 2
	dw .d3-SPAwallleft_table		; direction 3
	dw .d3-SPAwallleft_table		; direction 4
	dw .d3-SPAwallleft_table		; direction 5
	dw .d3-SPAwallleft_table		; direction 6
	dw SPAfaceoff_table-SPAwallleft_table		; direction 7: points at the next table header
	dw 0		; attributes
.d0:	dw SPFPen+6,8,SPFPen+5,8,SPFPen+4,-8
.d1:	dw SPFPen+3,8,SPFPen+2,8,SPFPen+1,8,SPFPen,-8
.d3:	dw SPFPen,8,SPFPen+1,8,SPFPen+2,8,SPFPen+3,-8
	assert SPAwallleft_table-SPAList == SPAwallleft

SPAfaceoff_table:		;SPA $1096
	dw .d0-SPAfaceoff_table		; direction 0
	dw .d1-SPAfaceoff_table		; direction 1
	dw .d1-SPAfaceoff_table		; direction 2
	dw .d1-SPAfaceoff_table		; direction 3
	dw .d1-SPAfaceoff_table		; direction 4
	dw .d1-SPAfaceoff_table		; direction 5
	dw .d1-SPAfaceoff_table		; direction 6
	dw .d1-SPAfaceoff_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFskatewp,2,SPFsweep+1,10,SPFsweep,-6
.d1:	dw SPFskatewp+20,2,SPFsweep+9,10,SPFsweep+8,-6
	assert SPAfaceoff_table-SPAList == SPAfaceoff

SPAfaceoffr_table:		;SPA $10C0
	dw .d0-SPAfaceoffr_table		; direction 0
	dw .d1-SPAfaceoffr_table		; direction 1
	dw .d1-SPAfaceoffr_table		; direction 2
	dw .d1-SPAfaceoffr_table		; direction 3
	dw .d1-SPAfaceoffr_table		; direction 4
	dw .d1-SPAfaceoffr_table		; direction 5
	dw .d1-SPAfaceoffr_table		; direction 6
	dw .d1-SPAfaceoffr_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFskatewp,-5
.d1:	dw SPFskatewp+20,-5
	assert SPAfaceoffr_table-SPAList == SPAfaceoffr

SPAsiren_table:		;SPA $10DA
	dw .d0-SPAsiren_table		; direction 0
	dw .d0-SPAsiren_table		; direction 1
	dw .d0-SPAsiren_table		; direction 2
	dw .d0-SPAsiren_table		; direction 3
	dw .d0-SPAsiren_table		; direction 4
	dw .d0-SPAsiren_table		; direction 5
	dw .d0-SPAsiren_table		; direction 6
	dw .d0-SPAsiren_table		; direction 7
	dw 1		; attributes: loops
.d0:	dw SPFSiren,3,SPFSiren+1,3,SPFSiren+2,3,SPFSiren+3,3,SPFSiren+4,3,SPFSiren+5,3,SPFSiren+6,3,SPFSiren+7,3
	dw SPFSiren+8,3,SPFSiren+9,3,SPFSiren+10,3,SPFSiren+11,3,SPFSiren+12,3,SPFSiren+13,-3
	assert SPAsiren_table-SPAList == SPAsiren

SPAstanley_table:		;SPA $1124
	dw .d0-SPAstanley_table		; direction 0
	dw .d1-SPAstanley_table		; direction 1
	dw .d2-SPAstanley_table		; direction 2
	dw .d3-SPAstanley_table		; direction 3
	dw .d4-SPAstanley_table		; direction 4
	dw .d5-SPAstanley_table		; direction 5
	dw .d6-SPAstanley_table		; direction 6
	dw .d7-SPAstanley_table		; direction 7
	dw 1		; attributes: loops
.d0:	dw SPFcup,-30
.d1:	dw SPFcup+1,-30
.d2:	dw SPFcup+2,-30
.d3:	dw SPFcup+3,-30
.d4:	dw SPFcup+4,-30
.d5:	dw SPFcup+5,-30
.d6:	dw SPFcup+6,-30
.d7:	dw SPFcup+7,-30
	assert SPAstanley_table-SPAList == SPAstanley

SPAfinjury_table:		;SPA $1156
	dw .d0-SPAfinjury_table		; direction 0
	dw .d0-SPAfinjury_table		; direction 1
	dw .d0-SPAfinjury_table		; direction 2
	dw .d0-SPAfinjury_table		; direction 3
	dw .d0-SPAfinjury_table		; direction 4
	dw .d0-SPAfinjury_table		; direction 5
	dw .d0-SPAfinjury_table		; direction 6
	dw .d0-SPAfinjury_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfight+14,8,SPFfight+15,8,SPFfight+16,20,SPFfinjury,8,SPFfinjury+1,8,SPFfinjury+2,8,SPFfinjury+3,10,SPFfinjury+4,10
	dw SPFfinjury+5,10,SPFfinjury+3,10,SPFfinjury+4,10,SPFfinjury+5,10,SPFfinjury+3,10,SPFfinjury+4,10,SPFfinjury+5,10,SPFfinjury+3,10
	dw SPFfinjury+4,10,SPFfinjury+5,-400
	assert SPAfinjury_table-SPAList == SPAfinjury

SPAflip_table:		;SPA $11B0
	dw .d0-SPAflip_table		; direction 0
	dw .d1-SPAflip_table		; direction 1
	dw .d2-SPAflip_table		; direction 2
	dw .d3-SPAflip_table		; direction 3
	dw .d4-SPAflip_table		; direction 4
	dw .d5-SPAflip_table		; direction 5
	dw .d6-SPAflip_table		; direction 6
	dw .d7-SPAflip_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFflip,6,SPFflip+1,6,SPFflip+2,6,SPFflip+3,6,SPFfallback+2,100,SPFfallback+3,8,SPFduck,-8
.d1:	dw SPFflip,6,SPFflip+1,6,SPFflip+2,6,SPFflip+3,6,SPFfallback+6,100,SPFfallback+7,8,SPFduck+1,-8
.d2:	dw SPFflip,6,SPFflip+1,6,SPFflip+2,6,SPFflip+3,6,SPFfallback+10,100,SPFfallback+11,8,SPFduck+2,-8
.d3:	dw SPFflip+4,6,SPFflip+5,6,SPFflip+6,6,SPFflip+7,6,SPFfallback+14,100,SPFfallback+15,8,SPFduck+3,-8
.d4:	dw SPFflip+4,6,SPFflip+5,6,SPFflip+6,6,SPFflip+7,6,SPFfallback+18,100,SPFfallback+19,8,SPFduck+4,-8
.d5:	dw SPFflip+4,6,SPFflip+5,6,SPFflip+6,6,SPFflip+7,6,SPFfallback+22,100,SPFfallback+23,8,SPFduck+5,-8
.d6:	dw SPFflip+4,6,SPFflip+5,6,SPFflip+6,6,SPFflip+7,6,SPFfallback+26,100,SPFfallback+27,8,SPFduck+6,-8
.d7:	dw SPFflip,6,SPFflip+1,6,SPFflip+2,6,SPFflip+3,6,SPFfallback+30,100,SPFfallback+31,8,SPFduck+7,-8
	assert SPAflip_table-SPAList == SPAflip

SPAstumble_table:		;SPA $12A2
	dw .d0-SPAstumble_table		; direction 0
	dw .d1-SPAstumble_table		; direction 1
	dw .d2-SPAstumble_table		; direction 2
	dw .d3-SPAstumble_table		; direction 3
	dw .d4-SPAstumble_table		; direction 4
	dw .d5-SPAstumble_table		; direction 5
	dw .d6-SPAstumble_table		; direction 6
	dw .d7-SPAstumble_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFstumble,6,SPFstumble+1,6,SPFstumble+2,8,SPFstumble+1,6,SPFstumble,-6
.d1:	dw SPFstumble+3,6,SPFstumble+4,6,SPFstumble+5,8,SPFstumble+4,6,SPFstumble+3,-6
.d2:	dw SPFstumble+6,6,SPFstumble+7,6,SPFstumble+8,8,SPFstumble+7,6,SPFstumble+6,-6
.d3:	dw SPFstumble+9,6,SPFstumble+10,6,SPFstumble+11,8,SPFstumble+10,6,SPFstumble+9,-6
.d4:	dw SPFstumble+12,6,SPFstumble+13,6,SPFstumble+14,8,SPFstumble+13,6,SPFstumble+12,-6
.d5:	dw SPFstumble+15,6,SPFstumble+16,6,SPFstumble+17,8,SPFstumble+16,6,SPFstumble+15,-6
.d6:	dw SPFstumble+18,6,SPFstumble+19,6,SPFstumble+20,8,SPFstumble+19,6,SPFstumble+18,-6
.d7:	dw SPFstumble+21,6,SPFstumble+22,6,SPFstumble+23,8,SPFstumble+22,6,SPFstumble+21,-6
	assert SPAstumble_table-SPAList == SPAstumble

SPAhook_table:		;SPA $1354
	dw .d0-SPAhook_table		; direction 0
	dw .d1-SPAhook_table		; direction 1
	dw .d2-SPAhook_table		; direction 2
	dw .d3-SPAhook_table		; direction 3
	dw .d4-SPAhook_table		; direction 4
	dw .d5-SPAhook_table		; direction 5
	dw .d6-SPAhook_table		; direction 6
	dw .d7-SPAhook_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFhook,-30
.d1:	dw SPFhook+2,-30
.d2:	dw SPFhook+4,-30
.d3:	dw SPFhook+6,-30
.d4:	dw SPFhook+8,-30
.d5:	dw SPFhook+10,-30
.d6:	dw SPFhook+12,-30
.d7:	dw SPFhook+14,-30
	assert SPAhook_table-SPAList == SPAhook

SPAhook2_table:		;SPA $1386
	dw .d0-SPAhook2_table		; direction 0
	dw .d1-SPAhook2_table		; direction 1
	dw .d2-SPAhook2_table		; direction 2
	dw .d3-SPAhook2_table		; direction 3
	dw .d4-SPAhook2_table		; direction 4
	dw .d5-SPAhook2_table		; direction 5
	dw .d6-SPAhook2_table		; direction 6
	dw .d7-SPAhook2_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFhook,9,SPFhook+1,9,SPFhook,9,SPFhook+1,-9
.d1:	dw SPFhook+2,9,SPFhook+3,9,SPFhook+2,9,SPFhook+3,-9
.d2:	dw SPFhook+4,9,SPFhook+5,9,SPFhook+4,9,SPFhook+5,-9
.d3:	dw SPFhook+6,9,SPFhook+7,9,SPFhook+6,9,SPFhook+7,-9
.d4:	dw SPFhook+8,9,SPFhook+9,9,SPFhook+8,9,SPFhook+9,-9
.d5:	dw SPFhook+10,9,SPFhook+11,9,SPFhook+10,9,SPFhook+11,-9
.d6:	dw SPFhook+12,9,SPFhook+13,9,SPFhook+12,9,SPFhook+13,-9
.d7:	dw SPFhook+14,9,SPFhook+15,9,SPFhook+14,9,SPFhook+15,-9
	assert SPAhook2_table-SPAList == SPAhook2

SPAcatch_table:		;SPA $1418
	dw .d0-SPAcatch_table		; direction 0
	dw .d1-SPAcatch_table		; direction 1
	dw .d2-SPAcatch_table		; direction 2
	dw .d3-SPAcatch_table		; direction 3
	dw .d4-SPAcatch_table		; direction 4
	dw .d5-SPAcatch_table		; direction 5
	dw .d6-SPAcatch_table		; direction 6
	dw .d7-SPAcatch_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFcatch,6,SPFcatch+1,-6
.d1:	dw SPFcatch+2,6,SPFcatch+3,-6
.d2:	dw SPFcatch+4,6,SPFcatch+5,-6
.d3:	dw SPFcatch+6,6,SPFcatch+7,-6
.d4:	dw SPFcatch+8,6,SPFcatch+9,-6
.d5:	dw SPFcatch+10,6,SPFcatch+11,-6
.d6:	dw SPFcatch+12,6,SPFcatch+13,-6
.d7:	dw SPFcatch+14,6,SPFcatch+15,-6
	assert SPAcatch_table-SPAList == SPAcatch

SPAbglass_table:		;SPA $146A
	dw .d0-SPAbglass_table		; direction 0
	dw .d0-SPAbglass_table		; direction 1
	dw .d0-SPAbglass_table		; direction 2
	dw .d0-SPAbglass_table		; direction 3
	dw .d0-SPAbglass_table		; direction 4
	dw .d0-SPAbglass_table		; direction 5
	dw .d0-SPAbglass_table		; direction 6
	dw .d0-SPAbglass_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFbglass,8,SPFbglass+1,8,SPFbglass+2,8,SPFbglass+3,8,SPFbglass+4,-1000
	assert SPAbglass_table-SPAList == SPAbglass

SPAgdive_table:		;SPA $1490
	dw .d0-SPAgdive_table		; direction 0
	dw .d1-SPAgdive_table		; direction 1
	dw .d2-SPAgdive_table		; direction 2
	dw .d3-SPAgdive_table		; direction 3
	dw .d4-SPAgdive_table		; direction 4
	dw .d5-SPAgdive_table		; direction 5
	dw .d6-SPAgdive_table		; direction 6
	dw .d7-SPAgdive_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFgdive,8,SPFgdive+1,48,SPFgdive,-8
.d1:	dw SPFgdive+2,8,SPFgdive+3,48,SPFgdive+2,-8
.d2:	dw SPFgdive+4,8,SPFgdive+5,48,SPFgdive+4,-8
.d3:	dw SPFgdive+6,8,SPFgdive+7,48,SPFgdive+6,-8
.d4:	dw SPFgdive+8,8,SPFgdive+9,48,SPFgdive+8,-8
.d5:	dw SPFgdive+10,8,SPFgdive+11,48,SPFgdive+10,-8
.d6:	dw SPFgdive+12,8,SPFgdive+13,48,SPFgdive+12,-8
.d7:	dw SPFgdive+14,8,SPFgdive+15,48,SPFgdive+14,-8
	assert SPAgdive_table-SPAList == SPAgdive

SPAinjury1_table:		;SPA $1502
	dw .d0-SPAinjury1_table		; direction 0
	dw .d0-SPAinjury1_table		; direction 1
	dw .d0-SPAinjury1_table		; direction 2
	dw .d3-SPAinjury1_table		; direction 3
	dw .d3-SPAinjury1_table		; direction 4
	dw .d3-SPAinjury1_table		; direction 5
	dw .d3-SPAinjury1_table		; direction 6
	dw .d0-SPAinjury1_table		; direction 7
	dw 0		; attributes
.d0:	dw SPFfallback,20,SPFfallback+1,20,SPFfallback+2,1000,SPFfallback+2,-1000
.d3:	dw SPFfallback+16,20,SPFfallback+17,20,SPFfallback+18,1000,SPFfallback+18,-1000
	assert SPAinjury1_table-SPAList == SPAinjury1
SPAListEnd:
