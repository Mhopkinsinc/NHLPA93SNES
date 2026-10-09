; NHLPA 93 SNES RAM map (WRAM $7E0000-$7FFFFF, low 8K mirrored at $0000-$1FFF in banks $00-$3F/$80-$BF).
; Not a queue segment: no ROM bytes. Add names freely as segments are transcribed. Define each name once.
; Prefer NHL92 Genesis / NHLPA93 Genesis RAM names when the variable plays the same role.
; Format:  !Name = $xxxx   (asar define)  or  Name = $7Exxxx

; Direct page $00-$18: vblank / irq bookkeeping (from VBjsr, vb2, HBjsr in bank80)
vcount		= $00	; 32-bit frame counter, +1 per vblank in vb2_main. 93G vcount (word there)
brightness	= $04	; INIDISP shadow (0-15 brightness, $80 forced blank), written each vblank by vb2
fadeout		= $06	; nonzero: vb2 steps brightness down every 4 frames until 0. SNES stand-in for 93G cramfade
fadein		= $08	; 1: vb2 steps brightness up every 4 frames to 15; >1: delay count before fading in
vbactive	= $12	; nonzero while the vbint handler runs (or while main code holds vblank off): VBjsr skips it
vbint		= $14	; address (bank $80) of the vblank handler VBjsr jumps to. 93G vbint
hbint		= $16	; address (bank $80) of the H/V-timer IRQ handler HBjsr jumps to. Default HBdefault
hcount		= $18	; +1 per IRQ that is not a timer IRQ (HBdefault); cleared every vblank
