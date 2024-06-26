; shim that loads an Inufuto game into main RAM and then
; runs it

; format: { destination address } { length } { rest of game content }

; do NOT assemble this as is, nothing will happen
putchar: .equ $1075
cls:     .equ $1dfb
locate:  .equ $116d
putstr:  .equ $30cf

; global variables
how_many_pages: .equ $fd8c ; How Many Pages?
end_of_user_area: .equ $fd8d ; End of the user area (2-byte)

; i/o ports
io_vram_bank: .equ $b0

.org $4000
.db "AB" ; PC-6001 compatible mode ("CD" for PC-6001mkII-only mode)
.dw main

main:
    call cls
    ld hl, msg_hello
    call putstr

    ; load game target address
    ld hl, (game)
    push hl

    ; load ROM length
    ld bc, (game + 2)

    ; set pointer to start of game in ROM (target)
    ld de, game + 4

copy_game:
    ; read from ROM
    ld a, (de)
    ; copy to RAM
    ld (hl), a

    inc hl
    inc de
    dec bc

    ; see if bc is zero yet
    ld a, b
    or c
    jr nz, copy_game

done_copying:
    pop hl

    ; if you want to return to BASIC before running this, uncomment the next line
    ; ret

    ; in page=2, the stack is moved downward so it can't
    ; be clobbered by the new video page
    ; it is usually at $f900
    ; forcibly correct the stack until we figure out what
    ; we are SUPPOSED to do
    ; ld sp, $df00
    ; it looks like canyon climber forcibly sets SP as well (to $dc51)
    ; that's what we'll do
    di
    ld sp, $dc51
    ei

    jp (hl) ; run game

msg_hello:
    .db "Loading game", $00

game:
    ; db statements will be placed here by extractor script
