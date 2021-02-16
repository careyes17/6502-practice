
    processor 6502
    include "vcs.h"
    include "macro.h"




PATTERN         = $80                  ; storage location (1st byte in RAM)
TIMETOCHANGE    = 20                   ; speed of "animation" - change as desired



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
    lda #0
    sta PATTERN            ; The binary PF 'pattern'

    lda #$45
    sta COLUPF             ; set the playfield color

    ldy #0                 ; "speed" counter

    ; set playfield reflected across y-axis, using D0 = 1
    lda #%00000001
    sta CTRLPF



StartOfFrame

   ; Start of vertical blank processing
    lda #0
    sta VBLANK



    lda #2
    sta VSYNC



    sta WSYNC
    sta WSYNC
    sta WSYNC               ; 3 scanlines of VSYNC signal



    lda #0

    sta VSYNC           


; 37 scanlines of vertical blank...

    ldx #0

VerticalBlank   sta WSYNC

    inx

    cpx #37

    bne VerticalBlank


IteratePattern
        ; Handle a change in the pattern once every 20 frames
        ; and write the pattern to the PF1 register

                iny                    ; increment speed count by one
                cpy #TIMETOCHANGE      ; has it reached our "change point"?
                bne notyet             ; no, so branch past

                ldy #0                 ; reset speed count
                inc PATTERN            ; switch to next pattern

notyet

                lda PATTERN            ; use our saved pattern
                sta PF1                ; as the playfield shape



; Do 192 scanlines of color-changing (our picture)
 
    ldx #192 ; 192 scanlines of picture...

scanlines
    sta WSYNC
    stx COLUBK             ; change background color (rainbow effect)
    dex
    bne scanlines


    ; reset background color to black
    sta WSYNC
    ldx #0
    stx COLUBK

    ; prevent playfield from going above 192 scanlines
    lda #0
    sta PF1


; Overscan blanking
                lda #%01000010
                sta VBLANK          ; end of screen - enter blanking



   ; 30 scanlines of overscan...



                ldx #0
Overscan        
                sta WSYNC
                inx
                cpx #30
                bne Overscan

                jmp StartOfFrame

            ORG $FFFA


InterruptVectors
            .word Reset          ; NMI
            .word Reset          ; RESET
            .word Reset          ; IRQ
END