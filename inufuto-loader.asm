; z80dasm 1.2.0
; command line: z80dasm output.bin

	org 00100h

	call 01a61h
	call 01a70h
	cp 0c9h
	jr nz,$-5
	call 01a70h
	cp 0c9h
	jr z,$-5
	ld l,a
	call 01a70h
	ld h,a
	push hl
	call 01a70h
	ld c,a
	call 01a70h
	ld b,a
	call 01a70h
	ld (hl),a
	inc hl
	dec bc
	ld a,b
	or c
	jr nz,$-8
	call 01aaah
	pop hl
	jp (hl)
