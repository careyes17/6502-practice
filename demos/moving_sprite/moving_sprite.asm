
    processor 6502
    include "../../lib/vcs.asm"
    include "../../lib/macro.asm"

    ; compiler pointer var declarations
    SEG.U vars
    ORG $80

SpriteXPosition ds 1

    ; rom code 
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

    ;init values

    ; init stack
    ldx #$FF
    txs

    ; set the playfield color
    lda #$45
    sta COLUPF

    ; set playfield reflected across y-axis, using D0 = 1
    lda #%00000001
    sta CTRLPF

    ; init player colors
    lda #$56
    sta COLUP0
    lda #$67
    sta COLUP1


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


    ; Do 192 scanlines of color-changing (our picture)
    ; 8 (top) + 176 (middle) + 8 (bottom) = 192 lines

    ldx #0 ; 192 scanlines of picture counter

    ; setting playfield values
    lda #%11111111
    sta PF0
    sta PF1
    sta PF2
Top8Lines
    sta WSYNC
    stx COLUBK
    inx
    cpx #8
    bne Top8Lines


    ; middle scanlines
    lda #$45
    sta COLUBK

    ; sprite position alteration
    inc SpriteXPosition
    ldx SpriteXPosition
    cpx #160
    bcc LT160
    ldx #0
    stx SpriteXPosition
LT160
    jsr PositionSprite
    sta WSYNC

    ; middle scanline border calculation
    lda #%00010000 ; PF0 is mirrored <--- direction, low 4 bits ignored
    sta PF0
    lda #0
    sta PF1
    sta PF2
MiddleLines     
    ; draw two sprites on the playfield
    stx GRP0 ; modify sprite 0 shape
    stx GRP1 ; modify sprite 1 shape

    sta WSYNC
    stx COLUBK

    inx
    cpx #184
    bne MiddleLines


    ; sprite cleanup
    lda #0
    sta GRP0 ; modify sprite 0 shape
    sta GRP1 ; modify sprite 1 shape

    ; bottom 8 scanlines
    lda #%11111111
    sta PF0
    sta PF1
    sta PF2
Bottom8Lines
    sta WSYNC
    stx COLUBK
    inx
    cpx #192
    bne Bottom8Lines


    ; reset background color to black
    ldx #0
    stx COLUBK

    ; prevent playfield from going above 192 scanlines
    lda #0
    sta PF0
    sta PF1
    sta PF2


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


    ; rough sprite positioning
Divide15
.POS	SET 0
	REPEAT 256
	    .byte (.POS / 15) + 1
.POS	SET .POS + 1
    REPEND

PositionSprite
    sta WSYNC
    ; Pass X register holding desired X position of sprite!

    lda Divide15,x			; xPosition / 15
    tax
SimpleLoop	    
    dex
    bne SimpleLoop
    sta RESP0			; start drawing the sprite
    rts

    ;interupt vectors
    ORG $FFFA
InterruptVectors
    .word Reset          ; NMI
    .word Reset          ; RESET
    .word Reset          ; IRQ
END