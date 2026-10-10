; $82B86C-$82CD9F  ROM $1386C-$14D9F: SPAList, the animation tables (93G frames93.asm SPAList). Starts at SPAList (boundary moved from
; $82C000), ends before the packed rink tiles. SPA (sort object field) is an offset in this table. Each SPA table: 8 words = offset
; of the frame list for each direction (facedir 0-7, from the table start), 1 word of attributes (bit 0 = the animation loops),
; then the frame lists: pairs of (sprite frame, delay in frames); a negative delay marks the last frame (updateanim, bank80_E000).
; Frames are SPF base + n (SNES frame numbering, see ram93snes.asm). Each table is asserted against its SPA constant.
org $82B86C
SPAList:		;93G SPAList
	dw 0		; $82B86C (SPA 0 = no animation)

SPAgready_table:		;SPA $0002 (93G SPAgready)
	dw .d0-SPAgready_table		; $82B86E direction 0
	dw .d1-SPAgready_table		; $82B870 direction 1
	dw .d2-SPAgready_table		; $82B872 direction 2
	dw .d3-SPAgready_table		; $82B874 direction 3
	dw .d4-SPAgready_table		; $82B876 direction 4
	dw .d5-SPAgready_table		; $82B878 direction 5
	dw .d6-SPAgready_table		; $82B87A direction 6
	dw .d7-SPAgready_table		; $82B87C direction 7
	dw 1		; $82B87E attributes: loops
.d0:	dw SPFGoalie,180,SPFgready,10,SPFgready+1,10,SPFgready,10,SPFgready+1,10,SPFGoalie,240,SPFgready,10,SPFgready+1,10		; $82B880
	dw SPFgready,-10		; $82B8A0
.d1:	dw SPFGoalie+3,130,SPFgready+2,10,SPFgready+3,10,SPFgready+2,10,SPFgready+3,10,SPFGoalie+3,300,SPFgready+2,10,SPFgready+3,10		; $82B8A4
	dw SPFgready+2,-10		; $82B8C4
.d2:	dw SPFGoalie+6,210,SPFgready+4,10,SPFgready+5,10,SPFgready+4,10,SPFgready+5,10,SPFGoalie+6,120,SPFgready+4,10,SPFgready+5,10		; $82B8C8
	dw SPFgready+4,-10		; $82B8E8
.d3:	dw SPFGoalie+9,100,SPFgready+6,10,SPFgready+7,10,SPFgready+6,10,SPFgready+7,10,SPFGoalie+9,200,SPFgready+6,10,SPFgready+7,10		; $82B8EC
	dw SPFgready+6,-10		; $82B90C
.d4:	dw SPFGoalie+12,240,SPFgready+8,10,SPFgready+9,10,SPFgready+8,10,SPFgready+9,10,SPFGoalie+12,60,SPFgready+8,10,SPFgready+9,10		; $82B910
	dw SPFgready+8,-10		; $82B930
.d5:	dw SPFGoalie+15,180,SPFgready+10,10,SPFgready+11,10,SPFgready+10,10,SPFgready+11,10,SPFGoalie+15,240,SPFgready+10,10,SPFgready+11,10		; $82B934
	dw SPFgready+10,-10		; $82B954
.d6:	dw SPFGoalie+18,120,SPFgready+12,10,SPFgready+13,10,SPFgready+12,10,SPFgready+13,10,SPFGoalie+18,120,SPFgready+12,10,SPFgready+13,10		; $82B958
	dw SPFgready+12,-10		; $82B978
.d7:	dw SPFGoalie+21,180,SPFgready+14,10,SPFgready+15,10,SPFgready+14,10,SPFgready+15,10,SPFGoalie+21,180,SPFgready+14,10,SPFgready+15,10		; $82B97C
	dw SPFgready+14,-10		; $82B99C
	assert SPAgready_table-SPAList == SPAgready

SPAgready2_table:		;SPA $0134 (93G SPAgready2)
	dw .d0-SPAgready2_table		; $82B9A0 direction 0
	dw .d1-SPAgready2_table		; $82B9A2 direction 1
	dw .d2-SPAgready2_table		; $82B9A4 direction 2
	dw .d3-SPAgready2_table		; $82B9A6 direction 3
	dw .d4-SPAgready2_table		; $82B9A8 direction 4
	dw .d5-SPAgready2_table		; $82B9AA direction 5
	dw .d6-SPAgready2_table		; $82B9AC direction 6
	dw .d7-SPAgready2_table		; $82B9AE direction 7
	dw 0		; $82B9B0 attributes
.d0:	dw SPFGoalie,-30		; $82B9B2
.d1:	dw SPFGoalie+3,-30		; $82B9B6
.d2:	dw SPFGoalie+6,-30		; $82B9BA
.d3:	dw SPFGoalie+9,-30		; $82B9BE
.d4:	dw SPFGoalie+12,-30		; $82B9C2
.d5:	dw SPFGoalie+15,-30		; $82B9C6
.d6:	dw SPFGoalie+18,-30		; $82B9CA
.d7:	dw SPFGoalie+21,-30		; $82B9CE
	assert SPAgready2_table-SPAList == SPAgready2

SPAgglover_table:		;SPA $0166 (93G SPAgglover)
	dw .d0-SPAgglover_table		; $82B9D2 direction 0
	dw .d1-SPAgglover_table		; $82B9D4 direction 1
	dw .d2-SPAgglover_table		; $82B9D6 direction 2
	dw .d3-SPAgglover_table		; $82B9D8 direction 3
	dw .d4-SPAgglover_table		; $82B9DA direction 4
	dw .d5-SPAgglover_table		; $82B9DC direction 5
	dw .d6-SPAgglover_table		; $82B9DE direction 6
	dw .d7-SPAgglover_table		; $82B9E0 direction 7
	dw 0		; $82B9E2 attributes
.d0:	dw SPFGoalie+1,-32		; $82B9E4
.d1:	dw SPFGoalie+4,-32		; $82B9E8
.d2:	dw SPFGoalie+7,-32		; $82B9EC
.d3:	dw SPFGoalie+10,-32		; $82B9F0
.d4:	dw SPFGoalie+13,-32		; $82B9F4
.d5:	dw SPFGoalie+16,-32		; $82B9F8
.d6:	dw SPFGoalie+19,-32		; $82B9FC
.d7:	dw SPFGoalie+22,-32		; $82BA00
	assert SPAgglover_table-SPAList == SPAgglover

SPAgglovel_table:		;SPA $0198 (93G SPAgglovel)
	dw .d0-SPAgglovel_table		; $82BA04 direction 0
	dw .d1-SPAgglovel_table		; $82BA06 direction 1
	dw .d2-SPAgglovel_table		; $82BA08 direction 2
	dw .d3-SPAgglovel_table		; $82BA0A direction 3
	dw .d4-SPAgglovel_table		; $82BA0C direction 4
	dw .d5-SPAgglovel_table		; $82BA0E direction 5
	dw .d6-SPAgglovel_table		; $82BA10 direction 6
	dw .d7-SPAgglovel_table		; $82BA12 direction 7
	dw 0		; $82BA14 attributes
.d0:	dw SPFGoalie+2,-32		; $82BA16
.d1:	dw SPFGoalie+5,-32		; $82BA1A
.d2:	dw SPFGoalie+8,-32		; $82BA1E
.d3:	dw SPFGoalie+11,-32		; $82BA22
.d4:	dw SPFGoalie+14,-32		; $82BA26
.d5:	dw SPFGoalie+17,-32		; $82BA2A
.d6:	dw SPFGoalie+20,-32		; $82BA2E
.d7:	dw SPFGoalie+23,-32		; $82BA32
	assert SPAgglovel_table-SPAList == SPAgglovel

SPAgstickr_table:		;SPA $01CA (93G SPAgstickr)
	dw .d0-SPAgstickr_table		; $82BA36 direction 0
	dw .d1-SPAgstickr_table		; $82BA38 direction 1
	dw .d2-SPAgstickr_table		; $82BA3A direction 2
	dw .d3-SPAgstickr_table		; $82BA3C direction 3
	dw .d4-SPAgstickr_table		; $82BA3E direction 4
	dw .d5-SPAgstickr_table		; $82BA40 direction 5
	dw .d6-SPAgstickr_table		; $82BA42 direction 6
	dw .d7-SPAgstickr_table		; $82BA44 direction 7
	dw 0		; $82BA46 attributes
.d0:	dw SPFGoalie+64,-32		; $82BA48
.d1:	dw SPFGoalie+66,-32		; $82BA4C
.d2:	dw SPFGoalie+68,-32		; $82BA50
.d3:	dw SPFGoalie+70,-32		; $82BA54
.d4:	dw SPFGoalie+72,-32		; $82BA58
.d5:	dw SPFGoalie+74,-32		; $82BA5C
.d6:	dw SPFGoalie+76,-32		; $82BA60
.d7:	dw SPFGoalie+78,-32		; $82BA64
	assert SPAgstickr_table-SPAList == SPAgstickr

SPAgstickl_table:		;SPA $01FC (93G SPAgstickl)
	dw .d0-SPAgstickl_table		; $82BA68 direction 0
	dw .d1-SPAgstickl_table		; $82BA6A direction 1
	dw .d2-SPAgstickl_table		; $82BA6C direction 2
	dw .d3-SPAgstickl_table		; $82BA6E direction 3
	dw .d4-SPAgstickl_table		; $82BA70 direction 4
	dw .d5-SPAgstickl_table		; $82BA72 direction 5
	dw .d6-SPAgstickl_table		; $82BA74 direction 6
	dw .d7-SPAgstickl_table		; $82BA76 direction 7
	dw 0		; $82BA78 attributes
.d0:	dw SPFGoalie+65,-32		; $82BA7A
.d1:	dw SPFGoalie+67,-32		; $82BA7E
.d2:	dw SPFGoalie+69,-32		; $82BA82
.d3:	dw SPFGoalie+71,-32		; $82BA86
.d4:	dw SPFGoalie+73,-32		; $82BA8A
.d5:	dw SPFGoalie+75,-32		; $82BA8E
.d6:	dw SPFGoalie+77,-32		; $82BA92
.d7:	dw SPFGoalie+79,-32		; $82BA96
	assert SPAgstickl_table-SPAList == SPAgstickl

SPAgstackr_table:		;SPA $022E (93G SPAgstackr)
	dw .d0-SPAgstackr_table		; $82BA9A direction 0
	dw .d1-SPAgstackr_table		; $82BA9C direction 1
	dw .d2-SPAgstackr_table		; $82BA9E direction 2
	dw .d3-SPAgstackr_table		; $82BAA0 direction 3
	dw .d4-SPAgstackr_table		; $82BAA2 direction 4
	dw .d5-SPAgstackr_table		; $82BAA4 direction 5
	dw .d6-SPAgstackr_table		; $82BAA6 direction 6
	dw .d7-SPAgstackr_table		; $82BAA8 direction 7
	dw 0		; $82BAAA attributes
.d0:	dw SPFGoalie+40,8,SPFGoalie+41,-20		; $82BAAC
.d1:	dw SPFGoalie+42,8,SPFGoalie+43,-20		; $82BAB4
.d2:	dw SPFGoalie+42,8,SPFGoalie+43,-20		; $82BABC
.d3:	dw SPFGoalie+44,8,SPFGoalie+45,-20		; $82BAC4
.d4:	dw SPFGoalie+46,8,SPFGoalie+47,-20		; $82BACC
.d5:	dw SPFGoalie+48,8,SPFGoalie+49,-20		; $82BAD4
.d6:	dw SPFGoalie+48,8,SPFGoalie+49,-20		; $82BADC
.d7:	dw SPFGoalie+50,8,SPFGoalie+51,-20		; $82BAE4
	assert SPAgstackr_table-SPAList == SPAgstackr

SPAgstackl_table:		;SPA $0280 (93G SPAgstackl)
	dw .d0-SPAgstackl_table		; $82BAEC direction 0
	dw .d1-SPAgstackl_table		; $82BAEE direction 1
	dw .d2-SPAgstackl_table		; $82BAF0 direction 2
	dw .d3-SPAgstackl_table		; $82BAF2 direction 3
	dw .d4-SPAgstackl_table		; $82BAF4 direction 4
	dw .d5-SPAgstackl_table		; $82BAF6 direction 5
	dw .d6-SPAgstackl_table		; $82BAF8 direction 6
	dw .d7-SPAgstackl_table		; $82BAFA direction 7
	dw 0		; $82BAFC attributes
.d0:	dw SPFGoalie+52,8,SPFGoalie+53,-20		; $82BAFE
.d1:	dw SPFGoalie+54,8,SPFGoalie+55,-20		; $82BB06
.d2:	dw SPFGoalie+54,8,SPFGoalie+55,-20		; $82BB0E
.d3:	dw SPFGoalie+56,8,SPFGoalie+57,-20		; $82BB16
.d4:	dw SPFGoalie+58,8,SPFGoalie+59,-20		; $82BB1E
.d5:	dw SPFGoalie+60,8,SPFGoalie+61,-20		; $82BB26
.d6:	dw SPFGoalie+60,8,SPFGoalie+61,-20		; $82BB2E
.d7:	dw SPFGoalie+62,8,SPFGoalie+63,-20		; $82BB36
	assert SPAgstackl_table-SPAList == SPAgstackl

SPAgswing_table:		;SPA $02D2 (93G SPAgswing)
	dw .d0-SPAgswing_table		; $82BB3E direction 0
	dw .d1-SPAgswing_table		; $82BB40 direction 1
	dw .d2-SPAgswing_table		; $82BB42 direction 2
	dw .d3-SPAgswing_table		; $82BB44 direction 3
	dw .d4-SPAgswing_table		; $82BB46 direction 4
	dw .d5-SPAgswing_table		; $82BB48 direction 5
	dw .d6-SPAgswing_table		; $82BB4A direction 6
	dw .d7-SPAgswing_table		; $82BB4C direction 7
	dw 0		; $82BB4E attributes
.d0:	dw SPFGoalie+24,5,SPFGoalie+25,8,SPFGoalie+24,-16		; $82BB50
.d1:	dw SPFGoalie+26,5,SPFGoalie+27,8,SPFGoalie+26,-16		; $82BB5C
.d2:	dw SPFGoalie+28,5,SPFGoalie+29,8,SPFGoalie+28,-16		; $82BB68
.d3:	dw SPFGoalie+30,5,SPFGoalie+31,8,SPFGoalie+30,-16		; $82BB74
.d4:	dw SPFGoalie+32,5,SPFGoalie+33,8,SPFGoalie+32,-16		; $82BB80
.d5:	dw SPFGoalie+34,5,SPFGoalie+35,8,SPFGoalie+34,-16		; $82BB8C
.d6:	dw SPFGoalie+36,5,SPFGoalie+37,8,SPFGoalie+36,-16		; $82BB98
.d7:	dw SPFGoalie+38,5,SPFGoalie+39,8,SPFGoalie+38,-16		; $82BBA4
	assert SPAgswing_table-SPAList == SPAgswing

SPAgskate_table:		;SPA $0344 (93G SPAgskate)
	dw .d0-SPAgskate_table		; $82BBB0 direction 0
	dw .d1-SPAgskate_table		; $82BBB2 direction 1
	dw .d2-SPAgskate_table		; $82BBB4 direction 2
	dw .d3-SPAgskate_table		; $82BBB6 direction 3
	dw .d4-SPAgskate_table		; $82BBB8 direction 4
	dw .d5-SPAgskate_table		; $82BBBA direction 5
	dw .d6-SPAgskate_table		; $82BBBC direction 6
	dw .d7-SPAgskate_table		; $82BBBE direction 7
	dw 1		; $82BBC0 attributes: loops
.d0:	dw SPFGoalie+80,10,SPFGoalie+81,10,SPFGoalie+82,10,SPFGoalie+83,-15		; $82BBC2
.d1:	dw SPFGoalie+84,10,SPFGoalie+85,10,SPFGoalie+86,10,SPFGoalie+87,-15		; $82BBD2
.d2:	dw SPFGoalie+88,10,SPFGoalie+89,10,SPFGoalie+90,10,SPFGoalie+91,-15		; $82BBE2
.d3:	dw SPFGoalie+92,10,SPFGoalie+93,10,SPFGoalie+94,10,SPFGoalie+95,-15		; $82BBF2
.d4:	dw SPFGoalie+96,10,SPFGoalie+97,10,SPFGoalie+98,10,SPFGoalie+99,-15		; $82BC02
.d5:	dw SPFGoalie+100,10,SPFGoalie+101,10,SPFGoalie+102,10,SPFGoalie+103,-15		; $82BC12
.d6:	dw SPFGoalie+104,10,SPFGoalie+105,10,SPFGoalie+106,10,SPFGoalie+107,-15		; $82BC22
.d7:	dw SPFGoalie+108,10,SPFGoalie+109,10,SPFGoalie+110,10,SPFGoalie+111,-15		; $82BC32
	assert SPAgskate_table-SPAList == SPAgskate

SPApflip_table:		;SPA $03D6 (93G SPApflip)
	dw .d0-SPApflip_table		; $82BC42 direction 0
	dw .d1-SPApflip_table		; $82BC44 direction 1
	dw .d2-SPApflip_table		; $82BC46 direction 2
	dw .d3-SPApflip_table		; $82BC48 direction 3
	dw .d4-SPApflip_table		; $82BC4A direction 4
	dw .d5-SPApflip_table		; $82BC4C direction 5
	dw .d6-SPApflip_table		; $82BC4E direction 6
	dw .d7-SPApflip_table		; $82BC50 direction 7
	dw 1		; $82BC52 attributes: loops
.d0:	dw SPFpuck+2,4,SPFpuck+3,4,SPFpuck+4,4,SPFpuck+5,4,SPFpuck+6,4,SPFpuck+3,4,SPFpuck+7,4,SPFpuck+1,-4		; $82BC54
.d1:	dw SPFpuck+9,2,SPFpuck+1,2,SPFpuck+8,2,SPFpuck+5,2,SPFpuck+10,2,SPFpuck+5,2,SPFpuck+8,2,SPFpuck+1,-2		; $82BC74
.d2:	dw SPFpuck+4,2,SPFpuck+3,2,SPFpuck+2,2,SPFpuck+1,2,SPFpuck+7,2,SPFpuck+3,2,SPFpuck+6,2,SPFpuck+5,-2		; $82BC94
.d3:	dw SPFpuck+8,4,SPFpuck+1,4,SPFpuck+9,4,SPFpuck+1,4,SPFpuck+8,4,SPFpuck+5,4,SPFpuck+10,4,SPFpuck+5,-4		; $82BCB4
.d4:	dw SPFpuck+1,-4096		; $82BCD4
.d5:	dw SPFpuck+1,-4096		; $82BCD8
.d6:	dw SPFpuck+5,-4096		; $82BCDC
.d7:	dw SPFpuck+5,-4096		; $82BCE0
	assert SPApflip_table-SPAList == SPApflip

SPAglide_table:		;SPA $0478 (93G SPAglide)
	dw .d0-SPAglide_table		; $82BCE4 direction 0
	dw .d1-SPAglide_table		; $82BCE6 direction 1
	dw .d2-SPAglide_table		; $82BCE8 direction 2
	dw .d3-SPAglide_table		; $82BCEA direction 3
	dw .d4-SPAglide_table		; $82BCEC direction 4
	dw .d5-SPAglide_table		; $82BCEE direction 5
	dw .d6-SPAglide_table		; $82BCF0 direction 6
	dw .d7-SPAglide_table		; $82BCF2 direction 7
	dw 0		; $82BCF4 attributes
.d0:	dw SPFskatewp,-8		; $82BCF6
.d1:	dw SPFskatewp+5,-8		; $82BCFA
.d2:	dw SPFskatewp+10,-8		; $82BCFE
.d3:	dw SPFskatewp+15,-8		; $82BD02
.d4:	dw SPFskatewp+20,-8		; $82BD06
.d5:	dw SPFskatewp+25,-8		; $82BD0A
.d6:	dw SPFskatewp+30,-8		; $82BD0E
.d7:	dw SPFskatewp+35,-8		; $82BD12
	assert SPAglide_table-SPAList == SPAglide

SPAskatewp_table:		;SPA $04AA (93G SPAskatewp)
	dw .d0-SPAskatewp_table		; $82BD16 direction 0
	dw .d1-SPAskatewp_table		; $82BD18 direction 1
	dw .d2-SPAskatewp_table		; $82BD1A direction 2
	dw .d3-SPAskatewp_table		; $82BD1C direction 3
	dw .d4-SPAskatewp_table		; $82BD1E direction 4
	dw .d5-SPAskatewp_table		; $82BD20 direction 5
	dw .d6-SPAskatewp_table		; $82BD22 direction 6
	dw .d7-SPAskatewp_table		; $82BD24 direction 7
	dw 0		; $82BD26 attributes
.d0:	dw SPFskatewp+1,10,SPFskatewp+2,10,SPFskatewp+3,10,SPFskatewp+4,10,SPFskatewp,-15		; $82BD28
.d1:	dw SPFskatewp+6,10,SPFskatewp+7,10,SPFskatewp+8,10,SPFskatewp+9,10,SPFskatewp+5,-15		; $82BD3C
.d2:	dw SPFskatewp+11,10,SPFskatewp+12,10,SPFskatewp+13,10,SPFskatewp+14,10,SPFskatewp+10,-15		; $82BD50
.d3:	dw SPFskatewp+16,10,SPFskatewp+17,10,SPFskatewp+18,10,SPFskatewp+19,10,SPFskatewp+15,-15		; $82BD64
.d4:	dw SPFskatewp+21,10,SPFskatewp+22,10,SPFskatewp+23,10,SPFskatewp+24,10,SPFskatewp+20,-15		; $82BD78
.d5:	dw SPFskatewp+26,10,SPFskatewp+27,10,SPFskatewp+28,10,SPFskatewp+29,10,SPFskatewp+25,-15		; $82BD8C
.d6:	dw SPFskatewp+31,10,SPFskatewp+32,10,SPFskatewp+33,10,SPFskatewp+34,10,SPFskatewp+30,-15		; $82BDA0
.d7:	dw SPFskatewp+36,10,SPFskatewp+37,10,SPFskatewp+38,10,SPFskatewp+39,10,SPFskatewp+35,-15		; $82BDB4
	assert SPAskatewp_table-SPAList == SPAskatewp

SPAskate_table:		;SPA $055C (93G SPAskate)
	dw .d0-SPAskate_table		; $82BDC8 direction 0
	dw .d1-SPAskate_table		; $82BDCA direction 1
	dw .d2-SPAskate_table		; $82BDCC direction 2
	dw .d3-SPAskate_table		; $82BDCE direction 3
	dw .d4-SPAskate_table		; $82BDD0 direction 4
	dw .d5-SPAskate_table		; $82BDD2 direction 5
	dw .d6-SPAskate_table		; $82BDD4 direction 6
	dw .d7-SPAskate_table		; $82BDD6 direction 7
	dw 0		; $82BDD8 attributes
.d0:	dw SPFskate+1,10,SPFskate+2,10,SPFskate+3,10,SPFskate+4,10,SPFskate,-15		; $82BDDA
.d1:	dw SPFskate+6,10,SPFskate+7,10,SPFskate+8,10,SPFskate+9,10,SPFskate+5,-15		; $82BDEE
.d2:	dw SPFskate+11,10,SPFskate+12,10,SPFskate+13,10,SPFskate+14,10,SPFskate+10,-15		; $82BE02
.d3:	dw SPFskate+16,10,SPFskate+17,10,SPFskate+18,10,SPFskate+19,10,SPFskate+15,-15		; $82BE16
.d4:	dw SPFskate+21,10,SPFskate+22,10,SPFskate+23,10,SPFskate+24,10,SPFskate+20,-15		; $82BE2A
.d5:	dw SPFskate+26,10,SPFskate+27,10,SPFskate+28,10,SPFskate+29,10,SPFskate+25,-15		; $82BE3E
.d6:	dw SPFskate+31,10,SPFskate+32,10,SPFskate+33,10,SPFskate+34,10,SPFskate+30,-15		; $82BE52
.d7:	dw SPFskate+36,10,SPFskate+37,10,SPFskate+38,10,SPFskate+39,10,SPFskate+35,-15		; $82BE66
	assert SPAskate_table-SPAList == SPAskate

SPAturnl_table:		;SPA $060E (93G SPAturnl)
	dw .d0-SPAturnl_table		; $82BE7A direction 0
	dw .d1-SPAturnl_table		; $82BE7C direction 1
	dw .d2-SPAturnl_table		; $82BE7E direction 2
	dw .d3-SPAturnl_table		; $82BE80 direction 3
	dw .d4-SPAturnl_table		; $82BE82 direction 4
	dw .d5-SPAturnl_table		; $82BE84 direction 5
	dw .d6-SPAturnl_table		; $82BE86 direction 6
	dw .d7-SPAturnl_table		; $82BE88 direction 7
	dw 0		; $82BE8A attributes
.d0:	dw SPFturnl,-18		; $82BE8C
.d1:	dw SPFturnl+1,-18		; $82BE90
.d2:	dw SPFturnl+2,-18		; $82BE94
.d3:	dw SPFturnl+3,-18		; $82BE98
.d4:	dw SPFturnl+4,-18		; $82BE9C
.d5:	dw SPFturnl+5,-18		; $82BEA0
.d6:	dw SPFturnl+6,-18		; $82BEA4
.d7:	dw SPFturnl+7,-18		; $82BEA8
	assert SPAturnl_table-SPAList == SPAturnl

SPAturnr_table:		;SPA $0640 (93G SPAturnr)
	dw .d0-SPAturnr_table		; $82BEAC direction 0
	dw .d1-SPAturnr_table		; $82BEAE direction 1
	dw .d2-SPAturnr_table		; $82BEB0 direction 2
	dw .d3-SPAturnr_table		; $82BEB2 direction 3
	dw .d4-SPAturnr_table		; $82BEB4 direction 4
	dw .d5-SPAturnr_table		; $82BEB6 direction 5
	dw .d6-SPAturnr_table		; $82BEB8 direction 6
	dw .d7-SPAturnr_table		; $82BEBA direction 7
	dw 0		; $82BEBC attributes
.d0:	dw SPFturnr,-18		; $82BEBE
.d1:	dw SPFturnr+1,-18		; $82BEC2
.d2:	dw SPFturnr+2,-18		; $82BEC6
.d3:	dw SPFturnr+3,-18		; $82BECA
.d4:	dw SPFturnr+4,-18		; $82BECE
.d5:	dw SPFturnr+5,-18		; $82BED2
.d6:	dw SPFturnr+6,-18		; $82BED6
.d7:	dw SPFturnr+7,-18		; $82BEDA
	assert SPAturnr_table-SPAList == SPAturnr

SPAstop_table:		;SPA $0672 (93G SPAstop)
	dw .d0-SPAstop_table		; $82BEDE direction 0
	dw .d1-SPAstop_table		; $82BEE0 direction 1
	dw .d2-SPAstop_table		; $82BEE2 direction 2
	dw .d3-SPAstop_table		; $82BEE4 direction 3
	dw .d4-SPAstop_table		; $82BEE6 direction 4
	dw .d5-SPAstop_table		; $82BEE8 direction 5
	dw .d6-SPAstop_table		; $82BEEA direction 6
	dw .d7-SPAstop_table		; $82BEEC direction 7
	dw 1		; $82BEEE attributes: loops
.d0:	dw SPFstop,4,SPFstop+1,-4		; $82BEF0
.d1:	dw SPFstop+2,4,SPFstop+3,-4		; $82BEF8
.d2:	dw SPFstop+4,4,SPFstop+5,-4		; $82BF00
.d3:	dw SPFstop+6,4,SPFstop+7,-4		; $82BF08
.d4:	dw SPFstop+8,4,SPFstop+9,-4		; $82BF10
.d5:	dw SPFstop+10,4,SPFstop+11,-4		; $82BF18
.d6:	dw SPFstop+12,4,SPFstop+13,-4		; $82BF20
.d7:	dw SPFstop+14,4,SPFstop+15,-4		; $82BF28
	assert SPAstop_table-SPAList == SPAstop

SPApassf_table:		;SPA $06C4 (93G SPApassf)
	dw .d0-SPApassf_table		; $82BF30 direction 0
	dw .d1-SPApassf_table		; $82BF32 direction 1
	dw .d2-SPApassf_table		; $82BF34 direction 2
	dw .d3-SPApassf_table		; $82BF36 direction 3
	dw .d4-SPApassf_table		; $82BF38 direction 4
	dw .d5-SPApassf_table		; $82BF3A direction 5
	dw .d6-SPApassf_table		; $82BF3C direction 6
	dw .d7-SPApassf_table		; $82BF3E direction 7
	dw 0		; $82BF40 attributes
.d0:	dw SPFswing+3,4,SPFswing+4,4,SPFswing+5,-20		; $82BF42
.d1:	dw SPFswing+9,4,SPFswing+10,4,SPFswing+11,-20		; $82BF4E
.d2:	dw SPFswing+15,4,SPFswing+16,4,SPFswing+17,-20		; $82BF5A
.d3:	dw SPFswing+21,4,SPFswing+22,4,SPFswing+23,-20		; $82BF66
.d4:	dw SPFswing+27,4,SPFswing+28,4,SPFswing+29,-20		; $82BF72
.d5:	dw SPFswing+33,4,SPFswing+34,4,SPFswing+35,-20		; $82BF7E
.d6:	dw SPFswing+39,4,SPFswing+40,4,SPFswing+41,-20		; $82BF8A
.d7:	dw SPFswing+45,4,SPFswing+46,4,SPFswing+47,-20		; $82BF96
	assert SPApassf_table-SPAList == SPApassf

SPApassb_table:		;SPA $0736 (93G SPApassb)
	dw .d0-SPApassb_table		; $82BFA2 direction 0
	dw .d1-SPApassb_table		; $82BFA4 direction 1
	dw .d2-SPApassb_table		; $82BFA6 direction 2
	dw .d3-SPApassb_table		; $82BFA8 direction 3
	dw .d4-SPApassb_table		; $82BFAA direction 4
	dw .d5-SPApassb_table		; $82BFAC direction 5
	dw .d6-SPApassb_table		; $82BFAE direction 6
	dw .d7-SPApassb_table		; $82BFB0 direction 7
	dw 0		; $82BFB2 attributes
.d0:	dw SPFswing+3,4,SPFswing+2,4,SPFswing+1,-20		; $82BFB4
.d1:	dw SPFswing+9,4,SPFswing+8,4,SPFswing+7,-20		; $82BFC0
.d2:	dw SPFswing+15,4,SPFswing+14,4,SPFswing+13,-20		; $82BFCC
.d3:	dw SPFswing+21,4,SPFswing+20,4,SPFswing+19,-20		; $82BFD8
.d4:	dw SPFswing+27,4,SPFswing+26,4,SPFswing+25,-20		; $82BFE4
.d5:	dw SPFswing+33,4,SPFswing+32,4,SPFswing+31,-20		; $82BFF0
.d6:	dw SPFswing+39,4,SPFswing+38,4,SPFswing+37,-20		; $82BFFC
.d7:	dw SPFswing+45,4,SPFswing+44,4,SPFswing+43,-20		; $82C008
	assert SPApassb_table-SPAList == SPApassb

SPAshotf_table:		;SPA $07A8 (93G SPAshotf)
	dw .d0-SPAshotf_table		; $82C014 direction 0
	dw .d1-SPAshotf_table		; $82C016 direction 1
	dw .d2-SPAshotf_table		; $82C018 direction 2
	dw .d3-SPAshotf_table		; $82C01A direction 3
	dw .d4-SPAshotf_table		; $82C01C direction 4
	dw .d5-SPAshotf_table		; $82C01E direction 5
	dw .d6-SPAshotf_table		; $82C020 direction 6
	dw .d7-SPAshotf_table		; $82C022 direction 7
	dw 0		; $82C024 attributes
.d0:	dw SPFswing+3,4,SPFswing+2,4,SPFswing+1,4,SPFswing,4,SPFswing+2,0,SPFswing+3,0,SPFswing+4,0,SPFswing+5,-20		; $82C026
.d1:	dw SPFswing+9,4,SPFswing+8,4,SPFswing+7,4,SPFswing+6,4,SPFswing+8,0,SPFswing+9,0,SPFswing+10,0,SPFswing+11,-20		; $82C046
.d2:	dw SPFswing+15,4,SPFswing+14,4,SPFswing+13,4,SPFswing+12,4,SPFswing+14,0,SPFswing+15,0,SPFswing+16,0,SPFswing+17,-20		; $82C066
.d3:	dw SPFswing+21,4,SPFswing+20,4,SPFswing+19,4,SPFswing+18,4,SPFswing+20,0,SPFswing+21,0,SPFswing+22,0,SPFswing+23,-20		; $82C086
.d4:	dw SPFswing+27,4,SPFswing+26,4,SPFswing+25,4,SPFswing+24,4,SPFswing+26,0,SPFswing+27,0,SPFswing+28,0,SPFswing+29,-20		; $82C0A6
.d5:	dw SPFswing+33,4,SPFswing+32,4,SPFswing+31,4,SPFswing+30,4,SPFswing+32,0,SPFswing+33,0,SPFswing+34,0,SPFswing+35,-20		; $82C0C6
.d6:	dw SPFswing+39,4,SPFswing+38,4,SPFswing+37,4,SPFswing+36,4,SPFswing+38,0,SPFswing+39,0,SPFswing+40,0,SPFswing+41,-20		; $82C0E6
.d7:	dw SPFswing+45,4,SPFswing+44,4,SPFswing+43,4,SPFswing+42,4,SPFswing+44,0,SPFswing+45,0,SPFswing+46,0,SPFswing+47,-20		; $82C106
	assert SPAshotf_table-SPAList == SPAshotf

SPAshotb_table:		;SPA $08BA (93G SPAshotb)
	dw .d0-SPAshotb_table		; $82C126 direction 0
	dw .d1-SPAshotb_table		; $82C128 direction 1
	dw .d2-SPAshotb_table		; $82C12A direction 2
	dw .d3-SPAshotb_table		; $82C12C direction 3
	dw .d4-SPAshotb_table		; $82C12E direction 4
	dw .d5-SPAshotb_table		; $82C130 direction 5
	dw .d6-SPAshotb_table		; $82C132 direction 6
	dw .d7-SPAshotb_table		; $82C134 direction 7
	dw 0		; $82C136 attributes
.d0:	dw SPFswing+3,4,SPFswing+4,4,SPFswing+5,4,SPFswing+5,4,SPFswing+4,0,SPFswing+3,0,SPFswing+2,0,SPFswing+1,-20		; $82C138
.d1:	dw SPFswing+9,4,SPFswing+10,4,SPFswing+11,4,SPFswing+11,4,SPFswing+10,0,SPFswing+9,0,SPFswing+8,0,SPFswing+7,-20		; $82C158
.d2:	dw SPFswing+15,4,SPFswing+16,4,SPFswing+17,4,SPFswing+17,4,SPFswing+16,0,SPFswing+15,0,SPFswing+14,0,SPFswing+13,-20		; $82C178
.d3:	dw SPFswing+21,4,SPFswing+22,4,SPFswing+23,4,SPFswing+23,4,SPFswing+22,0,SPFswing+21,0,SPFswing+20,0,SPFswing+19,-20		; $82C198
.d4:	dw SPFswing+27,4,SPFswing+28,4,SPFswing+29,4,SPFswing+29,4,SPFswing+28,0,SPFswing+27,0,SPFswing+26,0,SPFswing+25,-20		; $82C1B8
.d5:	dw SPFswing+33,4,SPFswing+34,4,SPFswing+35,4,SPFswing+35,4,SPFswing+34,0,SPFswing+33,0,SPFswing+32,0,SPFswing+31,-20		; $82C1D8
.d6:	dw SPFswing+39,4,SPFswing+40,4,SPFswing+41,4,SPFswing+41,4,SPFswing+40,0,SPFswing+39,0,SPFswing+38,0,SPFswing+37,-20		; $82C1F8
.d7:	dw SPFswing+45,4,SPFswing+46,4,SPFswing+47,4,SPFswing+47,4,SPFswing+46,0,SPFswing+45,0,SPFswing+44,0,SPFswing+43,-20		; $82C218
	assert SPAshotb_table-SPAList == SPAshotb

SPAglideback_table:		;SPA $09CC (93G SPAglideback)
	dw .d0-SPAglideback_table		; $82C238 direction 0
	dw .d1-SPAglideback_table		; $82C23A direction 1
	dw .d2-SPAglideback_table		; $82C23C direction 2
	dw .d3-SPAglideback_table		; $82C23E direction 3
	dw .d4-SPAglideback_table		; $82C240 direction 4
	dw .d5-SPAglideback_table		; $82C242 direction 5
	dw .d6-SPAglideback_table		; $82C244 direction 6
	dw .d7-SPAglideback_table		; $82C246 direction 7
	dw 0		; $82C248 attributes
.d0:	dw SPFskateb,-8		; $82C24A
.d1:	dw SPFskateb+3,-8		; $82C24E
.d2:	dw SPFskateb+6,-8		; $82C252
.d3:	dw SPFskateb+9,-8		; $82C256
.d4:	dw SPFskateb+12,-8		; $82C25A
.d5:	dw SPFskateb+15,-8		; $82C25E
.d6:	dw SPFskateb+18,-8		; $82C262
.d7:	dw SPFskateb+21,-8		; $82C266
	assert SPAglideback_table-SPAList == SPAglideback

SPAskateback_table:		;SPA $09FE (93G SPAskateback)
	dw .d0-SPAskateback_table		; $82C26A direction 0
	dw .d1-SPAskateback_table		; $82C26C direction 1
	dw .d2-SPAskateback_table		; $82C26E direction 2
	dw .d3-SPAskateback_table		; $82C270 direction 3
	dw .d4-SPAskateback_table		; $82C272 direction 4
	dw .d5-SPAskateback_table		; $82C274 direction 5
	dw .d6-SPAskateback_table		; $82C276 direction 6
	dw .d7-SPAskateback_table		; $82C278 direction 7
	dw 0		; $82C27A attributes
.d0:	dw SPFskateb,10,SPFskateb+1,10,SPFskateb,10,SPFskateb+2,-10		; $82C27C
.d1:	dw SPFskateb+3,10,SPFskateb+4,10,SPFskateb+3,10,SPFskateb+5,-10		; $82C28C
.d2:	dw SPFskateb+6,10,SPFskateb+7,10,SPFskateb+6,10,SPFskateb+8,-10		; $82C29C
.d3:	dw SPFskateb+9,10,SPFskateb+10,10,SPFskateb+9,10,SPFskateb+11,-10		; $82C2AC
.d4:	dw SPFskateb+12,10,SPFskateb+13,10,SPFskateb+12,10,SPFskateb+14,-10		; $82C2BC
.d5:	dw SPFskateb+15,10,SPFskateb+16,10,SPFskateb+15,10,SPFskateb+17,-10		; $82C2CC
.d6:	dw SPFskateb+18,10,SPFskateb+19,10,SPFskateb+18,10,SPFskateb+20,-10		; $82C2DC
.d7:	dw SPFskateb+21,10,SPFskateb+22,10,SPFskateb+21,10,SPFskateb+23,-10		; $82C2EC
	assert SPAskateback_table-SPAList == SPAskateback

SPAsweepchk_table:		;SPA $0A90 (93G SPAsweepchk)
	dw .d0-SPAsweepchk_table		; $82C2FC direction 0
	dw .d1-SPAsweepchk_table		; $82C2FE direction 1
	dw .d2-SPAsweepchk_table		; $82C300 direction 2
	dw .d3-SPAsweepchk_table		; $82C302 direction 3
	dw .d4-SPAsweepchk_table		; $82C304 direction 4
	dw .d5-SPAsweepchk_table		; $82C306 direction 5
	dw .d6-SPAsweepchk_table		; $82C308 direction 6
	dw .d7-SPAsweepchk_table		; $82C30A direction 7
	dw 0		; $82C30C attributes
.d0:	dw SPFsweep,4,SPFsweep+1,8,SPFsweep,-4		; $82C30E
.d1:	dw SPFsweep+2,4,SPFsweep+3,8,SPFsweep+2,-4		; $82C31A
.d2:	dw SPFsweep+4,4,SPFsweep+5,8,SPFsweep+4,-4		; $82C326
.d3:	dw SPFsweep+6,4,SPFsweep+7,8,SPFsweep+6,-4		; $82C332
.d4:	dw SPFsweep+8,4,SPFsweep+9,8,SPFsweep+8,-4		; $82C33E
.d5:	dw SPFsweep+10,4,SPFsweep+11,8,SPFsweep+10,-4		; $82C34A
.d6:	dw SPFsweep+12,4,SPFsweep+13,8,SPFsweep+12,-4		; $82C356
.d7:	dw SPFsweep+14,4,SPFsweep+15,8,SPFsweep+14,-4		; $82C362
	assert SPAsweepchk_table-SPAList == SPAsweepchk

SPAshoulderchkl_table:		;SPA $0B02 (93G SPAshoulderchkl)
	dw .d0-SPAshoulderchkl_table		; $82C36E direction 0
	dw .d1-SPAshoulderchkl_table		; $82C370 direction 1
	dw .d2-SPAshoulderchkl_table		; $82C372 direction 2
	dw .d3-SPAshoulderchkl_table		; $82C374 direction 3
	dw .d4-SPAshoulderchkl_table		; $82C376 direction 4
	dw .d5-SPAshoulderchkl_table		; $82C378 direction 5
	dw .d6-SPAshoulderchkl_table		; $82C37A direction 6
	dw .d7-SPAshoulderchkl_table		; $82C37C direction 7
	dw 0		; $82C37E attributes
.d0:	dw SPFshoulderl,-24		; $82C380
.d1:	dw SPFshoulderl+1,-24		; $82C384
.d2:	dw SPFshoulderl+2,-24		; $82C388
.d3:	dw SPFshoulderl+3,-24		; $82C38C
.d4:	dw SPFshoulderl+4,-24		; $82C390
.d5:	dw SPFshoulderl+5,-24		; $82C394
.d6:	dw SPFshoulderl+6,-24		; $82C398
.d7:	dw SPFshoulderl+7,-24		; $82C39C
	assert SPAshoulderchkl_table-SPAList == SPAshoulderchkl

SPAshoulderchkr_table:		;SPA $0B34 (93G SPAshoulderchkr)
	dw .d0-SPAshoulderchkr_table		; $82C3A0 direction 0
	dw .d1-SPAshoulderchkr_table		; $82C3A2 direction 1
	dw .d2-SPAshoulderchkr_table		; $82C3A4 direction 2
	dw .d3-SPAshoulderchkr_table		; $82C3A6 direction 3
	dw .d4-SPAshoulderchkr_table		; $82C3A8 direction 4
	dw .d5-SPAshoulderchkr_table		; $82C3AA direction 5
	dw .d6-SPAshoulderchkr_table		; $82C3AC direction 6
	dw .d7-SPAshoulderchkr_table		; $82C3AE direction 7
	dw 0		; $82C3B0 attributes
.d0:	dw SPFshoulderr,-24		; $82C3B2
.d1:	dw SPFshoulderr+1,-24		; $82C3B6
.d2:	dw SPFshoulderr+2,-24		; $82C3BA
.d3:	dw SPFshoulderr+3,-24		; $82C3BE
.d4:	dw SPFshoulderr+4,-24		; $82C3C2
.d5:	dw SPFshoulderr+5,-24		; $82C3C6
.d6:	dw SPFshoulderr+6,-24		; $82C3CA
.d7:	dw SPFshoulderr+7,-24		; $82C3CE
	assert SPAshoulderchkr_table-SPAList == SPAshoulderchkr

SPAhipchkl_table:		;SPA $0B66 (93G SPAhipchkl)
	dw .d0-SPAhipchkl_table		; $82C3D2 direction 0
	dw .d1-SPAhipchkl_table		; $82C3D4 direction 1
	dw .d2-SPAhipchkl_table		; $82C3D6 direction 2
	dw .d3-SPAhipchkl_table		; $82C3D8 direction 3
	dw .d4-SPAhipchkl_table		; $82C3DA direction 4
	dw .d5-SPAhipchkl_table		; $82C3DC direction 5
	dw .d6-SPAhipchkl_table		; $82C3DE direction 6
	dw .d7-SPAhipchkl_table		; $82C3E0 direction 7
	dw 0		; $82C3E2 attributes
.d0:	dw SPFhipl,-24		; $82C3E4
.d1:	dw SPFhipl+1,-24		; $82C3E8
.d2:	dw SPFhipl+2,-24		; $82C3EC
.d3:	dw SPFhipl+3,-24		; $82C3F0
.d4:	dw SPFhipl+4,-24		; $82C3F4
.d5:	dw SPFhipl+5,-24		; $82C3F8
.d6:	dw SPFhipl+6,-24		; $82C3FC
.d7:	dw SPFhipl+7,-24		; $82C400
	assert SPAhipchkl_table-SPAList == SPAhipchkl

SPAhipchkr_table:		;SPA $0B98 (93G SPAhipchkr)
	dw .d0-SPAhipchkr_table		; $82C404 direction 0
	dw .d1-SPAhipchkr_table		; $82C406 direction 1
	dw .d2-SPAhipchkr_table		; $82C408 direction 2
	dw .d3-SPAhipchkr_table		; $82C40A direction 3
	dw .d4-SPAhipchkr_table		; $82C40C direction 4
	dw .d5-SPAhipchkr_table		; $82C40E direction 5
	dw .d6-SPAhipchkr_table		; $82C410 direction 6
	dw .d7-SPAhipchkr_table		; $82C412 direction 7
	dw 0		; $82C414 attributes
.d0:	dw SPFhipr,-24		; $82C416
.d1:	dw SPFhipr+1,-24		; $82C41A
.d2:	dw SPFhipr+2,-24		; $82C41E
.d3:	dw SPFhipr+3,-24		; $82C422
.d4:	dw SPFhipr+4,-24		; $82C426
.d5:	dw SPFhipr+5,-24		; $82C42A
.d6:	dw SPFhipr+6,-24		; $82C42E
.d7:	dw SPFhipr+7,-24		; $82C432
	assert SPAhipchkr_table-SPAList == SPAhipchkr

SPAburst_table:		;SPA $0BCA (93G SPAburst)
	dw .d0-SPAburst_table		; $82C436 direction 0
	dw .d1-SPAburst_table		; $82C438 direction 1
	dw .d2-SPAburst_table		; $82C43A direction 2
	dw .d3-SPAburst_table		; $82C43C direction 3
	dw .d4-SPAburst_table		; $82C43E direction 4
	dw .d5-SPAburst_table		; $82C440 direction 5
	dw .d6-SPAburst_table		; $82C442 direction 6
	dw .d7-SPAburst_table		; $82C444 direction 7
	dw 0		; $82C446 attributes
.d0:	dw SPFskate,-24		; $82C448
.d1:	dw SPFskate+5,-24		; $82C44C
.d2:	dw SPFskate+10,-24		; $82C450
.d3:	dw SPFskate+15,-24		; $82C454
.d4:	dw SPFskate+20,-24		; $82C458
.d5:	dw SPFskate+25,-24		; $82C45C
.d6:	dw SPFskate+30,-24		; $82C460
.d7:	dw SPFskate+35,-24		; $82C464
	assert SPAburst_table-SPAList == SPAburst

SPAHold_table:		;SPA $0BFC (93G SPAHold)
	dw .d0-SPAHold_table		; $82C468 direction 0
	dw .d1-SPAHold_table		; $82C46A direction 1
	dw .d2-SPAHold_table		; $82C46C direction 2
	dw .d3-SPAHold_table		; $82C46E direction 3
	dw .d4-SPAHold_table		; $82C470 direction 4
	dw .d5-SPAHold_table		; $82C472 direction 5
	dw .d6-SPAHold_table		; $82C474 direction 6
	dw .d7-SPAHold_table		; $82C476 direction 7
	dw 0		; $82C478 attributes
.d0:	dw SPFhold,-30		; $82C47A
.d1:	dw SPFhold+1,-30		; $82C47E
.d2:	dw SPFhold+2,-30		; $82C482
.d3:	dw SPFhold+3,-30		; $82C486
.d4:	dw SPFhold+4,-30		; $82C48A
.d5:	dw SPFhold+5,-30		; $82C48E
.d6:	dw SPFhold+6,-30		; $82C492
.d7:	dw SPFhold+7,-30		; $82C496
	assert SPAHold_table-SPAList == SPAHold

SPAHold2_table:		;SPA $0C2E (93G SPAHold2)
	dw .d0-SPAHold2_table		; $82C49A direction 0
	dw .d1-SPAHold2_table		; $82C49C direction 1
	dw .d2-SPAHold2_table		; $82C49E direction 2
	dw .d3-SPAHold2_table		; $82C4A0 direction 3
	dw .d4-SPAHold2_table		; $82C4A2 direction 4
	dw .d5-SPAHold2_table		; $82C4A4 direction 5
	dw .d6-SPAHold2_table		; $82C4A6 direction 6
	dw .d7-SPAHold2_table		; $82C4A8 direction 7
	dw 0		; $82C4AA attributes
.d0:	dw SPFhold,-30		; $82C4AC
.d1:	dw SPFhold+1,-30		; $82C4B0
.d2:	dw SPFhold+2,-30		; $82C4B4
.d3:	dw SPFhold+3,-30		; $82C4B8
.d4:	dw SPFhold+4,-30		; $82C4BC
.d5:	dw SPFhold+5,-30		; $82C4C0
.d6:	dw SPFhold+6,-30		; $82C4C4
.d7:	dw SPFhold+7,-30		; $82C4C8
	assert SPAHold2_table-SPAList == SPAHold2

SPAflail_table:		;SPA $0C60 (93G SPAflail)
	dw .d0-SPAflail_table		; $82C4CC direction 0
	dw .d1-SPAflail_table		; $82C4CE direction 1
	dw .d2-SPAflail_table		; $82C4D0 direction 2
	dw .d3-SPAflail_table		; $82C4D2 direction 3
	dw .d4-SPAflail_table		; $82C4D4 direction 4
	dw .d5-SPAflail_table		; $82C4D6 direction 5
	dw .d6-SPAflail_table		; $82C4D8 direction 6
	dw .d7-SPAflail_table		; $82C4DA direction 7
	dw 0		; $82C4DC attributes
.d0:	dw SPFskate,-30		; $82C4DE
.d1:	dw SPFskate+5,-30		; $82C4E2
.d2:	dw SPFskate+10,-30		; $82C4E6
.d3:	dw SPFskate+15,-30		; $82C4EA
.d4:	dw SPFskate+20,-30		; $82C4EE
.d5:	dw SPFskate+25,-30		; $82C4F2
.d6:	dw SPFskate+30,-30		; $82C4F6
.d7:	dw SPFskate+35,-30		; $82C4FA
	assert SPAflail_table-SPAList == SPAflail

SPAfallfwd_table:		;SPA $0C92 (93G SPAfallfwd)
	dw .d0-SPAfallfwd_table		; $82C4FE direction 0
	dw .d1-SPAfallfwd_table		; $82C500 direction 1
	dw .d2-SPAfallfwd_table		; $82C502 direction 2
	dw .d3-SPAfallfwd_table		; $82C504 direction 3
	dw .d4-SPAfallfwd_table		; $82C506 direction 4
	dw .d5-SPAfallfwd_table		; $82C508 direction 5
	dw .d6-SPAfallfwd_table		; $82C50A direction 6
	dw .d7-SPAfallfwd_table		; $82C50C direction 7
	dw 0		; $82C50E attributes
.d0:	dw SPFfallfwd,6,SPFfallfwd+1,6,SPFfallfwd+2,100,SPFfallfwd+3,8,SPFduck,-8		; $82C510
.d1:	dw SPFfallfwd+4,6,SPFfallfwd+5,6,SPFfallfwd+6,100,SPFfallfwd+7,8,SPFduck+1,-8		; $82C524
.d2:	dw SPFfallfwd+8,6,SPFfallfwd+9,6,SPFfallfwd+10,100,SPFfallfwd+11,8,SPFduck+2,-8		; $82C538
.d3:	dw SPFfallfwd+12,6,SPFfallfwd+13,6,SPFfallfwd+14,100,SPFfallfwd+15,8,SPFduck+3,-8		; $82C54C
.d4:	dw SPFfallfwd+16,6,SPFfallfwd+17,6,SPFfallfwd+18,100,SPFfallfwd+19,8,SPFduck+4,-8		; $82C560
.d5:	dw SPFfallfwd+20,6,SPFfallfwd+21,6,SPFfallfwd+22,100,SPFfallfwd+23,8,SPFduck+5,-8		; $82C574
.d6:	dw SPFfallfwd+24,6,SPFfallfwd+25,6,SPFfallfwd+26,100,SPFfallfwd+27,8,SPFduck+6,-8		; $82C588
.d7:	dw SPFfallfwd+28,6,SPFfallfwd+29,6,SPFfallfwd+30,100,SPFfallfwd+31,8,SPFduck+7,-8		; $82C59C
	assert SPAfallfwd_table-SPAList == SPAfallfwd

SPAfallback_table:		;SPA $0D44 (93G SPAfallback)
	dw .d0-SPAfallback_table		; $82C5B0 direction 0
	dw .d1-SPAfallback_table		; $82C5B2 direction 1
	dw .d2-SPAfallback_table		; $82C5B4 direction 2
	dw .d3-SPAfallback_table		; $82C5B6 direction 3
	dw .d4-SPAfallback_table		; $82C5B8 direction 4
	dw .d5-SPAfallback_table		; $82C5BA direction 5
	dw .d6-SPAfallback_table		; $82C5BC direction 6
	dw .d7-SPAfallback_table		; $82C5BE direction 7
	dw 0		; $82C5C0 attributes
.d0:	dw SPFfallback,6,SPFfallback+1,6,SPFfallback+2,100,SPFfallback+3,8,SPFduck,-8		; $82C5C2
.d1:	dw SPFfallback+4,6,SPFfallback+5,6,SPFfallback+6,100,SPFfallback+7,8,SPFduck+1,-8		; $82C5D6
.d2:	dw SPFfallback+8,6,SPFfallback+9,6,SPFfallback+10,100,SPFfallback+11,8,SPFduck+2,-8		; $82C5EA
.d3:	dw SPFfallback+12,6,SPFfallback+13,6,SPFfallback+14,100,SPFfallback+15,8,SPFduck+3,-8		; $82C5FE
.d4:	dw SPFfallback+16,6,SPFfallback+17,6,SPFfallback+18,100,SPFfallback+19,8,SPFduck+4,-8		; $82C612
.d5:	dw SPFfallback+20,6,SPFfallback+21,6,SPFfallback+22,100,SPFfallback+23,8,SPFduck+5,-8		; $82C626
.d6:	dw SPFfallback+24,6,SPFfallback+25,6,SPFfallback+26,100,SPFfallback+27,8,SPFduck+6,-8		; $82C63A
.d7:	dw SPFfallback+28,6,SPFfallback+29,6,SPFfallback+30,100,SPFfallback+31,8,SPFduck+7,-8		; $82C64E
	assert SPAfallback_table-SPAList == SPAfallback

SPAcelebrate_table:		;SPA $0DF6 (93G SPAcelebrate)
	dw .d0-SPAcelebrate_table		; $82C662 direction 0
	dw .d1-SPAcelebrate_table		; $82C664 direction 1
	dw .d2-SPAcelebrate_table		; $82C666 direction 2
	dw .d3-SPAcelebrate_table		; $82C668 direction 3
	dw .d4-SPAcelebrate_table		; $82C66A direction 4
	dw .d5-SPAcelebrate_table		; $82C66C direction 5
	dw .d6-SPAcelebrate_table		; $82C66E direction 6
	dw .d7-SPAcelebrate_table		; $82C670 direction 7
	dw 0		; $82C672 attributes
.d0:	dw SPFcelebrate,12,SPFcelebrate+1,40,SPFcelebrate,-5		; $82C674
.d1:	dw SPFcelebrate+2,12,SPFcelebrate+3,40,SPFcelebrate+2,-5		; $82C680
.d2:	dw SPFcelebrate+4,12,SPFcelebrate+5,40,SPFcelebrate+4,-5		; $82C68C
.d3:	dw SPFcelebrate+6,12,SPFcelebrate+7,40,SPFcelebrate+6,-5		; $82C698
.d4:	dw SPFcelebrate+8,12,SPFcelebrate+9,40,SPFcelebrate+8,-5		; $82C6A4
.d5:	dw SPFcelebrate+10,12,SPFcelebrate+11,40,SPFcelebrate+10,-5		; $82C6B0
.d6:	dw SPFcelebrate+12,12,SPFcelebrate+13,40,SPFcelebrate+12,-5		; $82C6BC
.d7:	dw SPFcelebrate+14,12,SPFcelebrate+15,40,SPFcelebrate+14,-5		; $82C6C8
	assert SPAcelebrate_table-SPAList == SPAcelebrate

SPApump_table:		;SPA $0E68 (93G SPApump)
	dw .d0-SPApump_table		; $82C6D4 direction 0
	dw .d1-SPApump_table		; $82C6D6 direction 1
	dw .d2-SPApump_table		; $82C6D8 direction 2
	dw .d3-SPApump_table		; $82C6DA direction 3
	dw .d4-SPApump_table		; $82C6DC direction 4
	dw .d5-SPApump_table		; $82C6DE direction 5
	dw .d6-SPApump_table		; $82C6E0 direction 6
	dw .d7-SPApump_table		; $82C6E2 direction 7
	dw 0		; $82C6E4 attributes
.d0:	dw SPFpump,8,SPFpump+1,8,SPFpump,-8		; $82C6E6
.d1:	dw SPFpump+2,8,SPFpump+3,8,SPFpump+2,-8		; $82C6F2
.d2:	dw SPFpump+4,8,SPFpump+5,8,SPFpump+4,-8		; $82C6FE
.d3:	dw SPFpump+6,8,SPFpump+7,8,SPFpump+6,-8		; $82C70A
.d4:	dw SPFpump+8,8,SPFpump+9,8,SPFpump+8,-8		; $82C716
.d5:	dw SPFpump+10,8,SPFpump+11,8,SPFpump+10,-8		; $82C722
.d6:	dw SPFpump+12,8,SPFpump+13,8,SPFpump+12,-8		; $82C72E
.d7:	dw SPFpump+14,8,SPFpump+15,8,SPFpump+14,-8		; $82C73A
	assert SPApump_table-SPAList == SPApump

SPAfight_table:		;SPA $0EDA (93G SPAfight)
	dw .d0-SPAfight_table		; $82C746 direction 0
	dw .d0-SPAfight_table		; $82C748 direction 1
	dw .d0-SPAfight_table		; $82C74A direction 2
	dw .d3-SPAfight_table		; $82C74C direction 3
	dw .d3-SPAfight_table		; $82C74E direction 4
	dw .d3-SPAfight_table		; $82C750 direction 5
	dw .d3-SPAfight_table		; $82C752 direction 6
	dw .d3-SPAfight_table		; $82C754 direction 7
	dw 0		; $82C756 attributes
.d0:	dw SPFfight,8,SPFfight+1,8,SPFfight+2,8,SPFfight+3,-6		; $82C758
.d3:	dw SPFfight,8,SPFfight+1,8,SPFfight+2,8,SPFfight+8,-6		; $82C768
	assert SPAfight_table-SPAList == SPAfight

SPAfgrab_table:		;SPA $0F0C (93G SPAfgrab)
	dw .d0-SPAfgrab_table		; $82C778 direction 0
	dw .d0-SPAfgrab_table		; $82C77A direction 1
	dw .d0-SPAfgrab_table		; $82C77C direction 2
	dw .d3-SPAfgrab_table		; $82C77E direction 3
	dw .d3-SPAfgrab_table		; $82C780 direction 4
	dw .d3-SPAfgrab_table		; $82C782 direction 5
	dw .d3-SPAfgrab_table		; $82C784 direction 6
	dw .d3-SPAfgrab_table		; $82C786 direction 7
	dw 0		; $82C788 attributes
.d0:	dw SPFfight+4,28,SPFfight+3,-4		; $82C78A
.d3:	dw SPFfight+9,28,SPFfight+8,-4		; $82C792
	assert SPAfgrab_table-SPAList == SPAfgrab

SPAfheld_table:		;SPA $0F2E (93G SPAfheld)
	dw .d0-SPAfheld_table		; $82C79A direction 0
	dw .d0-SPAfheld_table		; $82C79C direction 1
	dw .d0-SPAfheld_table		; $82C79E direction 2
	dw .d3-SPAfheld_table		; $82C7A0 direction 3
	dw .d3-SPAfheld_table		; $82C7A2 direction 4
	dw .d3-SPAfheld_table		; $82C7A4 direction 5
	dw .d3-SPAfheld_table		; $82C7A6 direction 6
	dw .d3-SPAfheld_table		; $82C7A8 direction 7
	dw 0		; $82C7AA attributes
.d0:	dw SPFfight+4,30,SPFfight+3,-4		; $82C7AC
.d3:	dw SPFfight+9,30,SPFfight+8,-4		; $82C7B4
	assert SPAfheld_table-SPAList == SPAfheld

SPAfhigh_table:		;SPA $0F50 (93G SPAfhigh)
	dw .d0-SPAfhigh_table		; $82C7BC direction 0
	dw .d0-SPAfhigh_table		; $82C7BE direction 1
	dw .d0-SPAfhigh_table		; $82C7C0 direction 2
	dw .d3-SPAfhigh_table		; $82C7C2 direction 3
	dw .d3-SPAfhigh_table		; $82C7C4 direction 4
	dw .d3-SPAfhigh_table		; $82C7C6 direction 5
	dw .d3-SPAfhigh_table		; $82C7C8 direction 6
	dw .d3-SPAfhigh_table		; $82C7CA direction 7
	dw 0		; $82C7CC attributes
.d0:	dw SPFfight+5,6,SPFfight+6,16,SPFfight+5,4,SPFfight+3,-16		; $82C7CE
.d3:	dw SPFfight+10,6,SPFfight+11,16,SPFfight+10,4,SPFfight+8,-16		; $82C7DE
	assert SPAfhigh_table-SPAList == SPAfhigh

SPAflow_table:		;SPA $0F82 (93G SPAflow)
	dw .d0-SPAflow_table		; $82C7EE direction 0
	dw .d0-SPAflow_table		; $82C7F0 direction 1
	dw .d0-SPAflow_table		; $82C7F2 direction 2
	dw .d3-SPAflow_table		; $82C7F4 direction 3
	dw .d3-SPAflow_table		; $82C7F6 direction 4
	dw .d3-SPAflow_table		; $82C7F8 direction 5
	dw .d3-SPAflow_table		; $82C7FA direction 6
	dw .d3-SPAflow_table		; $82C7FC direction 7
	dw 0		; $82C7FE attributes
.d0:	dw SPFfight+5,6,SPFfight+7,16,SPFfight+5,4,SPFfight+3,-16		; $82C800
.d3:	dw SPFfight+10,6,SPFfight+12,16,SPFfight+10,4,SPFfight+8,-16		; $82C810
	assert SPAflow_table-SPAList == SPAflow

SPAfhith_table:		;SPA $0FB4 (93G SPAfhith)
	dw .d0-SPAfhith_table		; $82C820 direction 0
	dw .d0-SPAfhith_table		; $82C822 direction 1
	dw .d0-SPAfhith_table		; $82C824 direction 2
	dw .d3-SPAfhith_table		; $82C826 direction 3
	dw .d3-SPAfhith_table		; $82C828 direction 4
	dw .d3-SPAfhith_table		; $82C82A direction 5
	dw .d3-SPAfhith_table		; $82C82C direction 6
	dw .d3-SPAfhith_table		; $82C82E direction 7
	dw 0		; $82C830 attributes
.d0:	dw SPFfight+14,16,SPFfight+3,-8		; $82C832
.d3:	dw SPFfight+14,16,SPFfight+8,-8		; $82C83A
	assert SPAfhith_table-SPAList == SPAfhith

SPAfhitl_table:		;SPA $0FD6 (93G SPAfhitl)
	dw .d0-SPAfhitl_table		; $82C842 direction 0
	dw .d0-SPAfhitl_table		; $82C844 direction 1
	dw .d0-SPAfhitl_table		; $82C846 direction 2
	dw .d3-SPAfhitl_table		; $82C848 direction 3
	dw .d3-SPAfhitl_table		; $82C84A direction 4
	dw .d3-SPAfhitl_table		; $82C84C direction 5
	dw .d3-SPAfhitl_table		; $82C84E direction 6
	dw .d3-SPAfhitl_table		; $82C850 direction 7
	dw 0		; $82C852 attributes
.d0:	dw SPFfight+13,16,SPFfight+3,-8		; $82C854
.d3:	dw SPFfight+13,16,SPFfight+8,-8		; $82C85C
	assert SPAfhitl_table-SPAList == SPAfhitl

SPAffall_table:		;SPA $0FF8 (93G SPAffall)
	dw .d0-SPAffall_table		; $82C864 direction 0
	dw .d0-SPAffall_table		; $82C866 direction 1
	dw .d0-SPAffall_table		; $82C868 direction 2
	dw .d0-SPAffall_table		; $82C86A direction 3
	dw .d0-SPAffall_table		; $82C86C direction 4
	dw .d0-SPAffall_table		; $82C86E direction 5
	dw .d0-SPAffall_table		; $82C870 direction 6
	dw .d0-SPAffall_table		; $82C872 direction 7
	dw 0		; $82C874 attributes
.d0:	dw SPFfight+14,8,SPFfight+15,8,SPFfight+16,200,SPFfight+16,-2		; $82C876
	assert SPAffall_table-SPAList == SPAffall

SPAwallright_table:		;SPA $101A (93G SPAwallright)
	dw .d0-SPAwallright_table		; $82C886 direction 0
	dw .d1-SPAwallright_table		; $82C888 direction 1
	dw .d1-SPAwallright_table		; $82C88A direction 2
	dw .d3-SPAwallright_table		; $82C88C direction 3
	dw .d3-SPAwallright_table		; $82C88E direction 4
	dw .d3-SPAwallright_table		; $82C890 direction 5
	dw .d3-SPAwallright_table		; $82C892 direction 6
	dw SPAwallleft_table-SPAwallright_table		; $82C894 direction 7: points at the next table header (93G: skipped)
	dw 0		; $82C896 attributes
.d0:	dw SPFPen+4,8,SPFPen+5,8,SPFPen+6,-8		; $82C898
.d1:	dw SPFPen,8,SPFPen+1,8,SPFPen+2,8,SPFPen+3,-8		; $82C8A4
.d3:	dw SPFPen+3,8,SPFPen+2,8,SPFPen+1,8,SPFPen,-8		; $82C8B4
	assert SPAwallright_table-SPAList == SPAwallright

SPAwallleft_table:		;SPA $1058 (93G SPAwallleft)
	dw .d0-SPAwallleft_table		; $82C8C4 direction 0
	dw .d1-SPAwallleft_table		; $82C8C6 direction 1
	dw .d1-SPAwallleft_table		; $82C8C8 direction 2
	dw .d3-SPAwallleft_table		; $82C8CA direction 3
	dw .d3-SPAwallleft_table		; $82C8CC direction 4
	dw .d3-SPAwallleft_table		; $82C8CE direction 5
	dw .d3-SPAwallleft_table		; $82C8D0 direction 6
	dw SPAfaceoff_table-SPAwallleft_table		; $82C8D2 direction 7: points at the next table header (93G: skipped)
	dw 0		; $82C8D4 attributes
.d0:	dw SPFPen+6,8,SPFPen+5,8,SPFPen+4,-8		; $82C8D6
.d1:	dw SPFPen+3,8,SPFPen+2,8,SPFPen+1,8,SPFPen,-8		; $82C8E2
.d3:	dw SPFPen,8,SPFPen+1,8,SPFPen+2,8,SPFPen+3,-8		; $82C8F2
	assert SPAwallleft_table-SPAList == SPAwallleft

SPAfaceoff_table:		;SPA $1096 (93G SPAfaceoff)
	dw .d0-SPAfaceoff_table		; $82C902 direction 0
	dw .d1-SPAfaceoff_table		; $82C904 direction 1
	dw .d1-SPAfaceoff_table		; $82C906 direction 2
	dw .d1-SPAfaceoff_table		; $82C908 direction 3
	dw .d1-SPAfaceoff_table		; $82C90A direction 4
	dw .d1-SPAfaceoff_table		; $82C90C direction 5
	dw .d1-SPAfaceoff_table		; $82C90E direction 6
	dw .d1-SPAfaceoff_table		; $82C910 direction 7
	dw 0		; $82C912 attributes
.d0:	dw SPFskatewp,2,SPFsweep+1,10,SPFsweep,-6		; $82C914
.d1:	dw SPFskatewp+20,2,SPFsweep+9,10,SPFsweep+8,-6		; $82C920
	assert SPAfaceoff_table-SPAList == SPAfaceoff

SPAfaceoffr_table:		;SPA $10C0 (93G SPAfaceoffr)
	dw .d0-SPAfaceoffr_table		; $82C92C direction 0
	dw .d1-SPAfaceoffr_table		; $82C92E direction 1
	dw .d1-SPAfaceoffr_table		; $82C930 direction 2
	dw .d1-SPAfaceoffr_table		; $82C932 direction 3
	dw .d1-SPAfaceoffr_table		; $82C934 direction 4
	dw .d1-SPAfaceoffr_table		; $82C936 direction 5
	dw .d1-SPAfaceoffr_table		; $82C938 direction 6
	dw .d1-SPAfaceoffr_table		; $82C93A direction 7
	dw 0		; $82C93C attributes
.d0:	dw SPFskatewp,-5		; $82C93E
.d1:	dw SPFskatewp+20,-5		; $82C942
	assert SPAfaceoffr_table-SPAList == SPAfaceoffr

SPAsiren_table:		;SPA $10DA (93G SPAsiren)
	dw .d0-SPAsiren_table		; $82C946 direction 0
	dw .d0-SPAsiren_table		; $82C948 direction 1
	dw .d0-SPAsiren_table		; $82C94A direction 2
	dw .d0-SPAsiren_table		; $82C94C direction 3
	dw .d0-SPAsiren_table		; $82C94E direction 4
	dw .d0-SPAsiren_table		; $82C950 direction 5
	dw .d0-SPAsiren_table		; $82C952 direction 6
	dw .d0-SPAsiren_table		; $82C954 direction 7
	dw 1		; $82C956 attributes: loops
.d0:	dw SPFSiren,3,SPFSiren+1,3,SPFSiren+2,3,SPFSiren+3,3,SPFSiren+4,3,SPFSiren+5,3,SPFSiren+6,3,SPFSiren+7,3		; $82C958
	dw SPFSiren+8,3,SPFSiren+9,3,SPFSiren+10,3,SPFSiren+11,3,SPFSiren+12,3,SPFSiren+13,-3		; $82C978
	assert SPAsiren_table-SPAList == SPAsiren

SPAstanley_table:		;SPA $1124 (93G SPAstanley)
	dw .d0-SPAstanley_table		; $82C990 direction 0
	dw .d1-SPAstanley_table		; $82C992 direction 1
	dw .d2-SPAstanley_table		; $82C994 direction 2
	dw .d3-SPAstanley_table		; $82C996 direction 3
	dw .d4-SPAstanley_table		; $82C998 direction 4
	dw .d5-SPAstanley_table		; $82C99A direction 5
	dw .d6-SPAstanley_table		; $82C99C direction 6
	dw .d7-SPAstanley_table		; $82C99E direction 7
	dw 1		; $82C9A0 attributes: loops
.d0:	dw SPFcup,-30		; $82C9A2
.d1:	dw SPFcup+1,-30		; $82C9A6
.d2:	dw SPFcup+2,-30		; $82C9AA
.d3:	dw SPFcup+3,-30		; $82C9AE
.d4:	dw SPFcup+4,-30		; $82C9B2
.d5:	dw SPFcup+5,-30		; $82C9B6
.d6:	dw SPFcup+6,-30		; $82C9BA
.d7:	dw SPFcup+7,-30		; $82C9BE
	assert SPAstanley_table-SPAList == SPAstanley

SPAfinjury_table:		;SPA $1156 (93G SPAfinjury)
	dw .d0-SPAfinjury_table		; $82C9C2 direction 0
	dw .d0-SPAfinjury_table		; $82C9C4 direction 1
	dw .d0-SPAfinjury_table		; $82C9C6 direction 2
	dw .d0-SPAfinjury_table		; $82C9C8 direction 3
	dw .d0-SPAfinjury_table		; $82C9CA direction 4
	dw .d0-SPAfinjury_table		; $82C9CC direction 5
	dw .d0-SPAfinjury_table		; $82C9CE direction 6
	dw .d0-SPAfinjury_table		; $82C9D0 direction 7
	dw 0		; $82C9D2 attributes
.d0:	dw SPFfight+14,8,SPFfight+15,8,SPFfight+16,20,SPFfinjury,8,SPFfinjury+1,8,SPFfinjury+2,8,SPFfinjury+3,10,SPFfinjury+4,10		; $82C9D4
	dw SPFfinjury+5,10,SPFfinjury+3,10,SPFfinjury+4,10,SPFfinjury+5,10,SPFfinjury+3,10,SPFfinjury+4,10,SPFfinjury+5,10,SPFfinjury+3,10		; $82C9F4
	dw SPFfinjury+4,10,SPFfinjury+5,-400		; $82CA14
	assert SPAfinjury_table-SPAList == SPAfinjury

SPAflip_table:		;SPA $11B0 (93G SPAflip)
	dw .d0-SPAflip_table		; $82CA1C direction 0
	dw .d1-SPAflip_table		; $82CA1E direction 1
	dw .d2-SPAflip_table		; $82CA20 direction 2
	dw .d3-SPAflip_table		; $82CA22 direction 3
	dw .d4-SPAflip_table		; $82CA24 direction 4
	dw .d5-SPAflip_table		; $82CA26 direction 5
	dw .d6-SPAflip_table		; $82CA28 direction 6
	dw .d7-SPAflip_table		; $82CA2A direction 7
	dw 0		; $82CA2C attributes
.d0:	dw SPFflip,6,SPFflip+1,6,SPFflip+2,6,SPFflip+3,6,SPFfallback+2,100,SPFfallback+3,8,SPFduck,-8		; $82CA2E
.d1:	dw SPFflip,6,SPFflip+1,6,SPFflip+2,6,SPFflip+3,6,SPFfallback+6,100,SPFfallback+7,8,SPFduck+1,-8		; $82CA4A
.d2:	dw SPFflip,6,SPFflip+1,6,SPFflip+2,6,SPFflip+3,6,SPFfallback+10,100,SPFfallback+11,8,SPFduck+2,-8		; $82CA66
.d3:	dw SPFflip+4,6,SPFflip+5,6,SPFflip+6,6,SPFflip+7,6,SPFfallback+14,100,SPFfallback+15,8,SPFduck+3,-8		; $82CA82
.d4:	dw SPFflip+4,6,SPFflip+5,6,SPFflip+6,6,SPFflip+7,6,SPFfallback+18,100,SPFfallback+19,8,SPFduck+4,-8		; $82CA9E
.d5:	dw SPFflip+4,6,SPFflip+5,6,SPFflip+6,6,SPFflip+7,6,SPFfallback+22,100,SPFfallback+23,8,SPFduck+5,-8		; $82CABA
.d6:	dw SPFflip+4,6,SPFflip+5,6,SPFflip+6,6,SPFflip+7,6,SPFfallback+26,100,SPFfallback+27,8,SPFduck+6,-8		; $82CAD6
.d7:	dw SPFflip,6,SPFflip+1,6,SPFflip+2,6,SPFflip+3,6,SPFfallback+30,100,SPFfallback+31,8,SPFduck+7,-8		; $82CAF2
	assert SPAflip_table-SPAList == SPAflip

SPAstumble_table:		;SPA $12A2 (93G SPAstumble)
	dw .d0-SPAstumble_table		; $82CB0E direction 0
	dw .d1-SPAstumble_table		; $82CB10 direction 1
	dw .d2-SPAstumble_table		; $82CB12 direction 2
	dw .d3-SPAstumble_table		; $82CB14 direction 3
	dw .d4-SPAstumble_table		; $82CB16 direction 4
	dw .d5-SPAstumble_table		; $82CB18 direction 5
	dw .d6-SPAstumble_table		; $82CB1A direction 6
	dw .d7-SPAstumble_table		; $82CB1C direction 7
	dw 0		; $82CB1E attributes
.d0:	dw SPFstumble,6,SPFstumble+1,6,SPFstumble+2,8,SPFstumble+1,6,SPFstumble,-6		; $82CB20
.d1:	dw SPFstumble+3,6,SPFstumble+4,6,SPFstumble+5,8,SPFstumble+4,6,SPFstumble+3,-6		; $82CB34
.d2:	dw SPFstumble+6,6,SPFstumble+7,6,SPFstumble+8,8,SPFstumble+7,6,SPFstumble+6,-6		; $82CB48
.d3:	dw SPFstumble+9,6,SPFstumble+10,6,SPFstumble+11,8,SPFstumble+10,6,SPFstumble+9,-6		; $82CB5C
.d4:	dw SPFstumble+12,6,SPFstumble+13,6,SPFstumble+14,8,SPFstumble+13,6,SPFstumble+12,-6		; $82CB70
.d5:	dw SPFstumble+15,6,SPFstumble+16,6,SPFstumble+17,8,SPFstumble+16,6,SPFstumble+15,-6		; $82CB84
.d6:	dw SPFstumble+18,6,SPFstumble+19,6,SPFstumble+20,8,SPFstumble+19,6,SPFstumble+18,-6		; $82CB98
.d7:	dw SPFstumble+21,6,SPFstumble+22,6,SPFstumble+23,8,SPFstumble+22,6,SPFstumble+21,-6		; $82CBAC
	assert SPAstumble_table-SPAList == SPAstumble

SPAhook_table:		;SPA $1354 (93G SPAhook)
	dw .d0-SPAhook_table		; $82CBC0 direction 0
	dw .d1-SPAhook_table		; $82CBC2 direction 1
	dw .d2-SPAhook_table		; $82CBC4 direction 2
	dw .d3-SPAhook_table		; $82CBC6 direction 3
	dw .d4-SPAhook_table		; $82CBC8 direction 4
	dw .d5-SPAhook_table		; $82CBCA direction 5
	dw .d6-SPAhook_table		; $82CBCC direction 6
	dw .d7-SPAhook_table		; $82CBCE direction 7
	dw 0		; $82CBD0 attributes
.d0:	dw SPFhook,-30		; $82CBD2
.d1:	dw SPFhook+2,-30		; $82CBD6
.d2:	dw SPFhook+4,-30		; $82CBDA
.d3:	dw SPFhook+6,-30		; $82CBDE
.d4:	dw SPFhook+8,-30		; $82CBE2
.d5:	dw SPFhook+10,-30		; $82CBE6
.d6:	dw SPFhook+12,-30		; $82CBEA
.d7:	dw SPFhook+14,-30		; $82CBEE
	assert SPAhook_table-SPAList == SPAhook

SPAhook2_table:		;SPA $1386 (93G SPAhook2)
	dw .d0-SPAhook2_table		; $82CBF2 direction 0
	dw .d1-SPAhook2_table		; $82CBF4 direction 1
	dw .d2-SPAhook2_table		; $82CBF6 direction 2
	dw .d3-SPAhook2_table		; $82CBF8 direction 3
	dw .d4-SPAhook2_table		; $82CBFA direction 4
	dw .d5-SPAhook2_table		; $82CBFC direction 5
	dw .d6-SPAhook2_table		; $82CBFE direction 6
	dw .d7-SPAhook2_table		; $82CC00 direction 7
	dw 0		; $82CC02 attributes
.d0:	dw SPFhook,9,SPFhook+1,9,SPFhook,9,SPFhook+1,-9		; $82CC04
.d1:	dw SPFhook+2,9,SPFhook+3,9,SPFhook+2,9,SPFhook+3,-9		; $82CC14
.d2:	dw SPFhook+4,9,SPFhook+5,9,SPFhook+4,9,SPFhook+5,-9		; $82CC24
.d3:	dw SPFhook+6,9,SPFhook+7,9,SPFhook+6,9,SPFhook+7,-9		; $82CC34
.d4:	dw SPFhook+8,9,SPFhook+9,9,SPFhook+8,9,SPFhook+9,-9		; $82CC44
.d5:	dw SPFhook+10,9,SPFhook+11,9,SPFhook+10,9,SPFhook+11,-9		; $82CC54
.d6:	dw SPFhook+12,9,SPFhook+13,9,SPFhook+12,9,SPFhook+13,-9		; $82CC64
.d7:	dw SPFhook+14,9,SPFhook+15,9,SPFhook+14,9,SPFhook+15,-9		; $82CC74
	assert SPAhook2_table-SPAList == SPAhook2

SPAcatch_table:		;SPA $1418 (93G SPAcatch)
	dw .d0-SPAcatch_table		; $82CC84 direction 0
	dw .d1-SPAcatch_table		; $82CC86 direction 1
	dw .d2-SPAcatch_table		; $82CC88 direction 2
	dw .d3-SPAcatch_table		; $82CC8A direction 3
	dw .d4-SPAcatch_table		; $82CC8C direction 4
	dw .d5-SPAcatch_table		; $82CC8E direction 5
	dw .d6-SPAcatch_table		; $82CC90 direction 6
	dw .d7-SPAcatch_table		; $82CC92 direction 7
	dw 0		; $82CC94 attributes
.d0:	dw SPFcatch,6,SPFcatch+1,-6		; $82CC96
.d1:	dw SPFcatch+2,6,SPFcatch+3,-6		; $82CC9E
.d2:	dw SPFcatch+4,6,SPFcatch+5,-6		; $82CCA6
.d3:	dw SPFcatch+6,6,SPFcatch+7,-6		; $82CCAE
.d4:	dw SPFcatch+8,6,SPFcatch+9,-6		; $82CCB6
.d5:	dw SPFcatch+10,6,SPFcatch+11,-6		; $82CCBE
.d6:	dw SPFcatch+12,6,SPFcatch+13,-6		; $82CCC6
.d7:	dw SPFcatch+14,6,SPFcatch+15,-6		; $82CCCE
	assert SPAcatch_table-SPAList == SPAcatch

SPAbglass_table:		;SPA $146A (93G SPAbglass)
	dw .d0-SPAbglass_table		; $82CCD6 direction 0
	dw .d0-SPAbglass_table		; $82CCD8 direction 1
	dw .d0-SPAbglass_table		; $82CCDA direction 2
	dw .d0-SPAbglass_table		; $82CCDC direction 3
	dw .d0-SPAbglass_table		; $82CCDE direction 4
	dw .d0-SPAbglass_table		; $82CCE0 direction 5
	dw .d0-SPAbglass_table		; $82CCE2 direction 6
	dw .d0-SPAbglass_table		; $82CCE4 direction 7
	dw 0		; $82CCE6 attributes
.d0:	dw SPFbglass,8,SPFbglass+1,8,SPFbglass+2,8,SPFbglass+3,8,SPFbglass+4,-1000		; $82CCE8
	assert SPAbglass_table-SPAList == SPAbglass

SPAgdive_table:		;SPA $1490 (93G SPAgdive)
	dw .d0-SPAgdive_table		; $82CCFC direction 0
	dw .d1-SPAgdive_table		; $82CCFE direction 1
	dw .d2-SPAgdive_table		; $82CD00 direction 2
	dw .d3-SPAgdive_table		; $82CD02 direction 3
	dw .d4-SPAgdive_table		; $82CD04 direction 4
	dw .d5-SPAgdive_table		; $82CD06 direction 5
	dw .d6-SPAgdive_table		; $82CD08 direction 6
	dw .d7-SPAgdive_table		; $82CD0A direction 7
	dw 0		; $82CD0C attributes
.d0:	dw SPFgdive,8,SPFgdive+1,48,SPFgdive,-8		; $82CD0E
.d1:	dw SPFgdive+2,8,SPFgdive+3,48,SPFgdive+2,-8		; $82CD1A
.d2:	dw SPFgdive+4,8,SPFgdive+5,48,SPFgdive+4,-8		; $82CD26
.d3:	dw SPFgdive+6,8,SPFgdive+7,48,SPFgdive+6,-8		; $82CD32
.d4:	dw SPFgdive+8,8,SPFgdive+9,48,SPFgdive+8,-8		; $82CD3E
.d5:	dw SPFgdive+10,8,SPFgdive+11,48,SPFgdive+10,-8		; $82CD4A
.d6:	dw SPFgdive+12,8,SPFgdive+13,48,SPFgdive+12,-8		; $82CD56
.d7:	dw SPFgdive+14,8,SPFgdive+15,48,SPFgdive+14,-8		; $82CD62
	assert SPAgdive_table-SPAList == SPAgdive

SPAinjury1_table:		;SPA $1502 (93G SPAinjury1)
	dw .d0-SPAinjury1_table		; $82CD6E direction 0
	dw .d0-SPAinjury1_table		; $82CD70 direction 1
	dw .d0-SPAinjury1_table		; $82CD72 direction 2
	dw .d3-SPAinjury1_table		; $82CD74 direction 3
	dw .d3-SPAinjury1_table		; $82CD76 direction 4
	dw .d3-SPAinjury1_table		; $82CD78 direction 5
	dw .d3-SPAinjury1_table		; $82CD7A direction 6
	dw .d0-SPAinjury1_table		; $82CD7C direction 7
	dw 0		; $82CD7E attributes
.d0:	dw SPFfallback,20,SPFfallback+1,20,SPFfallback+2,1000,SPFfallback+2,-1000		; $82CD80
.d3:	dw SPFfallback+16,20,SPFfallback+17,20,SPFfallback+18,1000,SPFfallback+18,-1000		; $82CD90
	assert SPAinjury1_table-SPAList == SPAinjury1
SPAListEnd:
