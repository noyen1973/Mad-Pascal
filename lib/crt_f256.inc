
procedure ClrEol;
(*
@description:
ClrEol clears the current line, starting from the cursor position, to the end of the window.

The cursor doesn't move.
*)
begin
    asm
    _try:
        ; numerator = scrnCursor - TEXTMEM
        lda scrnCursor
        sta DIVU_NUMR
        sec
        lda scrnCursor+1
        sbc #>CS_TEXT_MEM_PTR
        sta DIVU_NUMR+1

        ; denominator = ScreenWidth
        mwa MAIN.SYSTEM.ScreenWidth DIVU_DENOM

        ; check if there is a remainder
        lda DIVU_RESULT_R
        beq _done

        ; draw a space character
        lda #32
        jsr @putchar
        bra _try

    _done:
    end;
end;


procedure CursorOff;
(*
@description: Hide cursor
*)
begin
    asm
        lda CURSOR_CTRL
        ora #%1
        sta CURSOR_CTRL
    end;
end;


procedure CursorOn;
(*
@description: Display cursor
*)
begin
    asm
        lda CURSOR_CTRL
        and #~%1
        sta CURSOR_CTRL
    end;
end;


procedure ClrScr;
(*
@description: Clear screen
*)
begin
    asm
        jsr @clrscr
    end;
end;


procedure DelLine;
(*
@description: Delete line at cursor position
*)
begin

end;


procedure InsLine;
(*
@description: Insert an empty line at cursor position
*)
begin

end;


function ReadKey: char; assembler;
(*
@description: Read key from keybuffer

@returns: char
*)
asm

end;


procedure TextBackground(a: byte); assembler;
(*
@description: Set text background

@param: a - color value 0..255
*)
asm
    lda CursorColor
    and #%11110000
    ora a
    sta CursorColor
end;


procedure TextColor(a: byte); assembler;
(*
@description: Set text color

@param: a - color value 0..255
*)
asm
    lda CursorColor
    and #15
    sta CursorColor
    lda a
    asl
    asl
    asl
    asl
    ora CursorColor
    sta CursorColor
end;


procedure Delay(count: word); assembler;
(*
@description: Waits a specified number of milliseconds

@param: count - number of milliseconds
*)
asm
    ldy #$90

loop	dey
    bne loop

end;


function Keypressed: Boolean; assembler;
(*
@description: Check if there is a keypress in the keybuffer

@returns: TRUE key has been pressed
@returns: FALSE otherwise
*)
asm

end;


procedure GotoXY(x,y: byte); assembler;
(*
@description:
Set cursor position on screen.


GotoXY positions the cursor at (X,Y), X in horizontal, Y in vertical direction relative to

the origin of the current window. The origin is located at (1,1), the upper-left corner of the window.

@param: x - horizontal positions (1..40)
@param: y - vertical positions (1..24)
*)

asm
    lda x
    dec
    pha

    lda y
    dec
    sta MULU_A
    stz MULU_A+1

    lda MAIN.SYSTEM.ScreenWidth
    sta MULU_B
    stz MULU_B+1

    pla
    clc
    adc MULU_RESULT
    sta scrnCursor
    lda MULU_RESULT+1
    adc #>CS_TEXT_MEM_PTR
    sta scrnCursor+1
end;


function WhereX: byte; assembler;
(*
@description: Return X (horizontal) cursor position

@returns: byte (1..40)
*)

asm
    ; numerator = scrnCursor - TEXTMEM
    lda scrnCursor
    sta DIVU_NUMR
    sec
    lda scrnCursor+1
    sbc #>CS_TEXT_MEM_PTR
    sta DIVU_NUMR+1

    ; denominator = ScreenWidth
    mwa MAIN.SYSTEM.ScreenWidth DIVU_DENOM

    ; remainder is the column number
    lda DIVU_RESULT_R
    inc
    sta Result
end;


function WhereY: byte; assembler;
(*
@description: Return Y (vertical) cursor position

@returns: byte (1..24)
*)

asm
    ; numerator = scrnCursor - TEXTMEM
    lda scrnCursor
    sta DIVU_NUMR
    sec
    lda scrnCursor+1
    sbc #>CS_TEXT_MEM_PTR
    sta DIVU_NUMR+1

    ; denominator = ScreenWidth
    mwa MAIN.SYSTEM.ScreenWidth DIVU_DENOM

    ; quotient is the row number
    lda DIVU_RESULT_Q
    inc
    sta Result
end;


procedure TextMode(Mode: byte); assembler;
(*
@description: Reset E: device

@param: Mode - unused value
*)
asm
    lda Mode
    cmp #BW40
    beq _320x240
    cmp #CO40
    beq _320x240
    cmp #BW80
    beq _640x480
    cmp #CO80
    beq _640x480

; default is 640x480, 80x60
_640x480:
    lda #80
    sta system.ScreenWidth
    lda #60
    sta system.ScreenHeight

    lda #1	; text only
    ldy #0	; regular text
    jmp _done

; 320x40, 40x30
_320x240:
    lda #40
    sta system.ScreenWidth
    lda #30
    sta system.ScreenHeight

    lda #1	; text only
    ldy #%110	; double x and y text

_done:
    sta MASTER_CTRL_L
    sty MASTER_CTRL_H

; give monitor time to resync
    ldy #20
_delay:
    inc
    bne _delay
    dey
    bne _delay
end;


procedure NoSound; assembler;
(*
@description: Reset POKEY
*)
asm

end;


procedure Sound(Chan,Freq,Dist,Vol: byte); assembler;
(*
@description: Plays sound

@param: Chan - channel (0..3) primary POKEY, (4..7) secondary POKEY
@param: Freq - frequency (0..255)
@param: Dist - distortion (0,2,4,6,8,10,12,14)
@param: Vol - volume (0..15)
*)
asm

end;
