	db "NHLPA Hockey '93     "		; title (21 bytes)
	db $30		; map mode: LoROM, FastROM
	db $00		; cartridge type: ROM only
	db $09		; ROM size: 512 KB
	db $00		; SRAM size: none
	db $01		; country: USA
	db $69		; licensee: Electronic Arts
	db $00		; version
	dw $B75A		; checksum complement
	dw $48A5		; checksum
	db $FF,$FF,$FF,$FF		; native mode vectors:
	dw VBjsr&$FFFF		; COP
	dw BRKHalt&$FFFF		; BRK
	dw VBjsr&$FFFF		; ABORT
	dw VBjsr&$FFFF		; NMI
	dw Start&$FFFF		; (unused)
	dw HBjsr&$FFFF		; IRQ
	db $FF,$FF,$FF,$FF		; emulation mode vectors:
	dw VBjsr&$FFFF		; COP
	dw VBjsr&$FFFF		; (unused)
	dw VBjsr&$FFFF		; ABORT
	dw VBjsr&$FFFF		; NMI
	dw Start&$FFFF		; RESET
	dw HBjsr&$FFFF		; IRQ/BRK
