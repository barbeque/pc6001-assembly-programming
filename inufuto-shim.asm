; shim that loads an Inufuto game into main RAM and then
; runs it

; format: { destination address } { length } { rest of game content }

; do NOT assemble this as is, nothing will happen
putchar: .equ $1075
cls:     .equ $1dfb
locate:  .equ $116d
putstr:  .equ $30cf

.org $4000
.db "AB"
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
    jp (hl) ; run game

loop:
    jr loop

msg_hello:
    .db "Loading game", $00

game:
    ; db statements will be placed here by extractor script