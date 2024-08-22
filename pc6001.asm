; cartridge hello world demo
; from http://p6ers.net/mm/pc-6001/dev/4keprom/index.html

putchar: .equ $1075
cls:     .equ $1dfb
locate:  .equ $116d
putstr:  .equ $30cf
console: .equ $1cf6
cnsmain: .equ $1d52

#define VRAM_WIDTH 32
#define VRAM_HEIGHT 24
#define CHAR_HEIGHT 8
#define VRAM_ROW_SIZE VRAM_WIDTH * CHAR_HEIGHT

; globals
console1: .equ $fda2
console2: .equ $fda3
console3: .equ $fda6
key_click_enabled: .equ $fa2d
; The last value BASIC wrote to $b0 (VRAM set)
port_b0: .equ $fa27

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

    ;ld hl, $0a08 ; some kind of coordinate system, low byte row, high byte column?
    ; $0101 - top left, $0201 - first row, one column to the right?
    ;call locate
    ;ld hl, msg_hello
    ;call putstr

    ; now try to get into graphics mode
    ld a, (port_b0)
    and $f9 ; clear the vram address bits 1, 2 - point to $c000
    out ($b0), a

    ; write attribute bytes
    ld hl, $c000
    ld bc, 512 ; why 512? inufuto did it too
set_attributes:
    ld (hl), $8c ; green yellow blue red (mode 3)
    inc hl
    dec bc
    ld a, c
    or b
    jr nz, set_attributes

    ; wipe the display portion of VRAM
    ld hl, $c200
    ld bc, VRAM_ROW_SIZE * VRAM_HEIGHT ; or 128 x 192 divided by 4 = 6144
erase_vram:
    ld (hl), 0b01101001 ; blue yellow yellow blue
    inc hl
    dec bc
    ld a, c
    or b
    jr nz, erase_vram

    ; let's go, copy the image into ram
    ld hl, PIC
    ld de, $c200 ; start of vram
    ld bc, (PIC_LEN)
blast_image:
    ; ldi would be faster, but something is up
    ld a, (hl)
    ld (de), a
    inc de
    inc hl
    dec bc
    ld a, c
    or b
    jr nz, blast_image

loop:
    jr loop

msg_hello:
    .db "Hello PC-6001!", $00 ; 14 characters long

.include "meules.asm"

; video notes:
;   - PORT $b0: http://000.la.coocan.jp/p6/tech.html#b0
;       - port $b0 bits 2 and 1 control the display VRAM address
;       - can read the current value from work area, but out doesn't set it
;       - Original device screen mode: 00=C000h 01=E000h 10=8000h 11=A000h	
;   - original recipe screen modes: http://000.la.coocan.jp/p6/tech.html#mc6847
;       - there are other modes but these are the ones they kept for mk2
;       - mode 1: 32x16 4-colour char mode
;       - mode 2: 64x48 8-colour semigraphics mode
;       - mode 3: 128x192 4-colour graphics mode (i think this is what we want)
;       - mode 4: 256x192 2-colour graphics mode
;   - ATTRIBUTE bytes
;       - each line is broken into 32 columns?
;       - attribute byte controls 12 lines of that column? with "16 lines in between?" what
;       - 32 bytes: 1 line, MSB is left side of screen

; in antiair:
;    ld a,(0fa27h)  (port b0h last written value)
;    and 0f9h       (clear bits 1 and 2)
;    out (0b0h),a   (write register. vram top is now $c000. ah so this is how the pages work)

; oh i get it now. the palettes are the first 512 bytes of the video ram,
; starting at $c000. actual pixels start at $c200!!!
; fucking google translate.