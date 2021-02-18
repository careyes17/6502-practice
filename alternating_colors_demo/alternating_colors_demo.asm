    processor 6502
    include "vcs.asm"
    include "macro.asm"
    SEG
    ORG $F000

start
    jsr drawtop
    jsr drawgame
    jsr drawbottom
    jmp start

drawtop:
vblank
    ; Start of vertical blank processing
    lda #0
    sta VBLANK

    lda #2
    sta VSYNC

    
vsynch
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

    rts


drawgame:
    ldy #192 ; 192 scanlines of picture...
    ldx #20 ; just for color variation

scanlines
    sta WSYNC
    nop
    nop
    nop
    iny
    sty COLUBK
    dey
    nop
    nop
    nop
    dex
    stx COLUBK
    nop
    nop
    nop
    iny
    sty COLUBK
    dey
    nop
    nop
    nop
    stx COLUBK
    nop
    nop
    nop
    iny
    sty COLUBK
    dey
    nop
    stx COLUBK
    dey
    bne scanlines


    sta WSYNC
    ldx #0
    stx COLUBK

    rts

drawbottom:
overscan
    lda #%01000010
    sta VBLANK ; end of screen - enter blanking


    ldy #30 ; 30 scanlines of overscan...
overscanlines
    sta WSYNC
    dey
    bne overscanlines

    rts

    ORG $FFFA
    
    .word start ; NMI
    .word start ; RESET
    .word start ; IRQ

end
