    processor 6502
    include "../../lib/vcs.asm"
    include "../../lib/macro.asm"

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

    ;init stack
    ldx #$FF
    txs

START

    ; Start of vertical blank processing
    lda #0
    sta VBLANK

    lda #2
    sta VSYNC

    ; 3 scanlines of VSYNCH signal...
    sta WSYNC
    sta WSYNC
    sta WSYNC

    lda #0
    sta VSYNC

    ldy #37 ; 37 scanlines of vertical blank...
vblankscanlines
    sta WSYNC
    dey
    bne vblankscanlines


    ; middle 192 scanlines
    ldy #192 ; 192 scanlines of picture...
    ldx #20 ; just for color variation
scanlines
    sta WSYNC
    SLEEP 3
    iny
    sty COLUBK
    dey
    SLEEP 3
    dex
    stx COLUBK
    SLEEP 3
    iny
    sty COLUBK
    dey
    SLEEP 3
    stx COLUBK
    SLEEP 3
    iny
    sty COLUBK
    dey
    SLEEP 3
    stx COLUBK
    SLEEP 3
    iny
    sty COLUBK
    dey
    SLEEP 3
    stx COLUBK
    dey
    bne scanlines


    sta WSYNC
    ; reset background color to black
    ldx #0
    stx COLUBK


    ; overscan start
    lda #%01000010
    sta VBLANK ; end of screen - enter blanking


    ldy #30 ; 30 scanlines of overscan...
overscanlines
    sta WSYNC
    dey
    bne overscanlines

    jmp START ; start main loop again

    ; interupt vectors
    ORG $FFFA
InterruptVectors
    .word START ; NMI
    .word START ; RESET
    .word START ; IRQ
END
