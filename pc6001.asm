; cartridge hello world demo
; from http://p6ers.net/mm/pc-6001/dev/4keprom/index.html

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

loop:
    jr loop

msg_hello:
    .db "Hello PC-6001", $00
