        PROCESSOR 6502
        include "../../lib/vcs.h"
        include "../../lib/macro.h"

        ; segment for variables
        ; variables here do not end up in ROM
        SEG.U VARS    
        ; RAM starts at $80
        ORG $80             

        ; segment for code (the ROM)
        SEG CODE    
        ORG $F000

InitSystem:
        ; set RAM, TIA registers and CPU registers to 0
        CLEAN_START   

Main:
        jsr VerticalSync    ; Jump to SubRoutine VerticalSync
        jsr VerticalBlank   ; Jump to SubRoutine VerticalBlank
        jsr Kernel          ; Jump to SubRoutine Kernel
        jsr OverScan        ; Jump to SubRoutine OverScan
        jmp Main            ; JuMP to Main

VerticalSync:
        lda #2      ; LoaD Accumulator with 2 so D1=1
        ldx #49     ; LoaD X with 49
        sta WSYNC   ; Wait for SYNC (halts CPU until end of scanline)
        sta VSYNC   ; Accumulator D1=1, turns on Vertical Sync signal
        stx TIM64T  ; set timer to go off in 41 scanlines (49 * 64) / 76
        sta WSYNC   ; Wait for Sync - halts CPU until end of 1st scanline of VSYNC
        sta WSYNC   ; wait until end of 2nd scanline of VSYNC
        lda #0      ; LoaD Accumulator with 0 so D1=0
        sta WSYNC   ; wait until end of 3rd scanline of VSYNC
        sta VSYNC   ; Accumulator D1=0, turns off Vertical Sync signal
        rts         ; ReTurn from Subroutine 
    
    
        ;game logic can resides here
VerticalBlank:
        rts             ; ReTurn from Subroutine


        ; the 192 scanlines for the game
Kernel:
        sta WSYNC       ; Wait for SYNC (halts CPU until end of scanline)
        lda INTIM       ; check the timer
        bne Kernel      ; Branch if its Not Equal to 0
        ; turn on the display
        sta VBLANK      ; Accumulator D1=0, turns off Vertical Blank signal (image output on)

        ; draw the screen
        ldx #192        ; Load X with 192
KernelLoop:
        sta WSYNC       ; Wait for SYNC (halts CPU until end of scanline)
        stx COLUBK      ; STore X into TIA's background color register
        dex             ; DEcrement X by 1
        bne KernelLoop  ; Branch if Not Equal to 0
        rts             ; ReTurn from Subroutine

OverScan:
        sta WSYNC   ; Wait for SYNC (halts CPU until end of scanline)
        lda #2      ; LoaD Accumulator with 2 so D1=1
        sta VBLANK  ; STore Accumulator to VBLANK, D1=1 turns image output off
        lda #32     ; set timer for 27 scanlines, 32 = ((27 * 76) / 64)
        sta TIM64T  ; set timer to go off in 27 scanlines
        
        ; game logic can go here
    
OSwait:
        sta WSYNC   ; Wait for SYNC (halts CPU until end of scanline)
        lda INTIM   ; Check the timer
        bne OSwait  ; Branch if its Not Equal to 0
        rts         ; ReTurn from Subroutine
    

        ORG $FFFA ; set address to 6507 Interrupt Vectors 
        .WORD InitSystem ; NMI
        .WORD InitSystem ; RESET
        .WORD InitSystem ; IRQ        
