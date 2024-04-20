; z80dasm 1.2.0
; command line: z80dasm -l output.bin

	org 00100h

	call 01a61h ; motor on
l0103h:
	call 01a70h ; read byte from tape into A
	cp 0c9h
	jr nz,l0103h
l010ah:
	call 01a70h
	cp 0c9h
	jr z,l010ah ; wait until the c9c9c9 delimiter stops
	ld l,a      ; divine target address for dump
	call 01a70h
	ld h,a
	push hl
	call 01a70h
	ld c,a
	call 01a70h
	ld b,a      ; load remaining record length
l011fh:
	call 01a70h
	ld (hl),a
	inc hl
	dec bc
	ld a,b
	or c
	jr nz,l011fh ; still more to read?
	call 01aaah  ; stop motor
	pop hl
	jp (hl)      ; jump to first byte written
