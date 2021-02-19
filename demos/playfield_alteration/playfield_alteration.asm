
    processor 6502
    include "../../lib/vcs.h"
    include "../../lib/macro.h"

    ; vars
PATTERN         = $80                  ; storage location (1st byte in RAM)
TIMETOCHANGE    = 20                   ; speed of "animation" - change as desired


    ; rom code start
    SEG
    ORG $F000


INIT

    ; clearing ram and TIA
Reset
    ldx #0 
    lda #0 
Clear           
    sta 0,x 
    inx 
    bne Clear



    ; init values

    ; init stack
    ldx #$FF
    txs

    lda #0
    sta PATTERN ; The binary PF 'pattern'

    lda #$45
    sta COLUPF ; set the playfield color

    ldy #0 ; "speed" counter

    ; set playfield reflected across y-axis, using D0 = 1
    lda #%00000001
    sta CTRLPF



START

    ; Start of vertical blank processing
    lda #0
    sta VBLANK

    lda #2
    sta VSYNC

    ; 3 scanlines of VSYNC signal
    sta WSYNC
    sta WSYNC
    sta WSYNC

    lda #0
    sta VSYNC           


    ; 37 scanlines of vertical blank...
    ldx #0
VerticalBlank
    sta WSYNC
    inx
    cpx #37
    bne VerticalBlank


IteratePattern
    ; Handle a change in the pattern once every 20 frames
    ; and write the pattern to the PF1 register
    iny ; increment speed count by one
    cpy #TIMETOCHANGE
    bne notyet ; no, so branch past

    ldy #0 ; reset speed count
    inc PATTERN ; switch to next pattern
notyet
    lda PATTERN ; use saved pattern



    ; Do 192 scanlines of color-changing (our picture)
    ldx #192 ; 192 scanlines of picture...

scanlines
    sta WSYNC
    sta PF1 ; start displaying playfield shape
    stx COLUBK ; change background color (rainbow effect)
    dex
    bne scanlines

    ; reset background color to black
    ldx #0
    stx COLUBK

    ; prevent playfield from going above 192 scanlines
    lda #0
    sta PF1


    ; Overscan blanking
    lda #%01000010
    sta VBLANK ; end of screen - enter blanking


   ; 30 scanlines of overscan...
    ldx #0
Overscan        
    sta WSYNC
    inx
    cpx #30
    bne Overscan

    jmp START


    ;interupt vectors
    ORG $FFFA
InterruptVectors
    .word Reset ; NMI
    .word Reset ; RESET
    .word Reset ; IRQ
END