; cartridge hello world demo
; from http://p6ers.net/mm/pc-6001/dev/4keprom/index.html

putchar: .equ $1075
cls:     .equ $1dfb
locate:  .equ $116d
putstr:  .equ $30cf
console: .equ $1cf6
cnsmain: .equ $1d52

; globals
console1: .equ $fda2
console2: .equ $fda3
console3: .equ $fda6
key_click_enabled: .equ $fa2d

.org $4000
.db "AB"
.dw main

main:
    ; disable key click sound
    xor a
    ld (key_click_enabled), a

    ; hide the f-key bar
    ld (console3), a
    call cnsmain

    ; clear the screen
    call cls

    ld hl, $0a08 ; some kind of coordinate system, low byte row, high byte column?
    ; $0101 - top left, $0201 - first row, one column to the right?
    call locate
    ld hl, msg_hello
    call putstr

loop:
    jr loop

msg_hello:
    .db "Hello PC-6001!", $00 ; 14 characters long