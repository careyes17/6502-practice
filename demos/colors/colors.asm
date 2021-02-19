
    processor 6502
    include "../../lib/vcs.h"
    include "../../lib/macro.h"

    ; rom code start
    SEG
    ORG $F000

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

    ; 192 scanlines of picture...
    ldx #192
scanlines
    sta WSYNC
    dex
    stx COLUBK
    bne scanlines

    ; reseting background color to black
    lda #0
    sta COLUBK

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
    .word START          ; NMI
    .word START          ; RESET
    .word START          ; IRQ
END
