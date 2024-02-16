
.proc   @putchar (.byte a) .reg
        phx
        phy

        ldy IOPAGE_CTRL
        phy

        cmp #eol
        bne _1

        jsr @cursorLimits

        stz CursorColumn
        inc CursorRow

        jsr @cursorLimits
        jsr @resetCursorPointer
        bra _XIT

_1      ldx #@iopagectrl(iopPage2)
        stx IOPAGE_CTRL

        sta (scrnCursor)

        inc IOPAGE_CTRL

        lda Main.Crt.TextAttr
        sta (scrnCursor)

        inc CursorColumn
        inc scrnCursor
        bne _XIT

        inc scrnCursor+1
        lda scrnCursor+1             ; lazy check for overrun
        cmp #>(CS_TEXT_MEM_PTR+80*60)
        bne _XIT

        jsr @cursorLimits
        jsr @resetCursorPointer

_XIT    pla
        sta IOPAGE_CTRL

        ply
        plx
        rts
.endp


.proc   @cursorLimits
        lda MASTER_CTRL_H
        and #@masterctrlh(mcTextDoubleX)        ; check screen mode for double-x (40 or 80 columns)
        beq _1

        ldx #40
        .by $2C
_1      ldx #80
        stx tempzp

_next1  lda CursorColumn
        cmp tempzp
        bcc _chkRow

        sec
        sbc tempzp
        sta CursorColumn
        inc CursorRow

        bra _next1

_chkRow lda MASTER_CTRL_H
        and #@masterctrlh(mcTextDoubleY)        ; check screen mode for double-y (30 or 60 rows)
        beq _2

        ldx #30
        .by $2C
_2      ldx #60
        stx tempzp

_next2  lda CursorRow
        cmp tempzp
        bcc _XIT

        jsr @scroll
        bra _next2

_XIT    rts
.endp


.proc   @scroll
        ldx #@iopagectrl(iopPage2)      ;; DEBUG: $217C
        stx IOPAGE_CTRL

        lda #>CS_TEXT_MEM_PTR
        sta scrnCursor+1
        lda #<CS_TEXT_MEM_PTR
        sta scrnCursor

        lda MASTER_CTRL_H
        and #@masterctrlh(mcTextDoubleX)        ; check screen mode for double-x (40 or 80 columns)
        beq _in640x480

        lda #>(CS_TEXT_MEM_PTR+40)
        sta tempzp+3
        lda #<(CS_TEXT_MEM_PTR+40)
        sta tempzp+2

        ldx #29
_next1  ldy #39
_next2  lda (tempzp+2),Y                        ; move the text map up one line for this row
        sta (scrnCursor),Y

        inc IOPAGE_CTRL

        lda (tempzp+2),Y                        ; move the text color map up
        sta (scrnCursor),Y

        dec IOPAGE_CTRL

        dey
        bpl _next2

        lda scrnCursor
        clc
        adc #40
        sta scrnCursor
        lda scrnCursor+1
        adc #0
        sta scrnCursor+1

        lda tempzp+2
        clc
        adc #40
        sta tempzp+2
        lda tempzp+3
        adc #0
        sta tempzp+3

        dex
        bne _next1

        ldy #39
        lda #' '
_next3  sta (scrnCursor),Y

        inc IOPAGE_CTRL

        pha
        lda #$00
        sta (scrnCursor),Y
        pla

        dec IOPAGE_CTRL

        dey
        bpl _next3

        bra _XIT

_in640x480:
        lda #>(CS_TEXT_MEM_PTR+80)
        sta tempzp+3
        lda #<(CS_TEXT_MEM_PTR+80)
        sta tempzp+2

        ldx #59
_next4  ldy #79
_next5  lda (tempzp+2),Y                        ; move the text map up one line for this row
        sta (scrnCursor),Y

        inc IOPAGE_CTRL

        lda (tempzp+2),Y                        ; move the text color map up
        sta (scrnCursor),Y

        dec IOPAGE_CTRL

        dey
        bpl _next5

        lda scrnCursor
        clc
        adc #80
        sta scrnCursor
        lda scrnCursor+1
        adc #0
        sta scrnCursor+1

        lda tempzp+2
        clc
        adc #80
        sta tempzp+2
        lda tempzp+3
        adc #0
        sta tempzp+3

        dex
        bne _next4

        ldy #79
        lda #' '
_next6  sta (scrnCursor),Y

        inc IOPAGE_CTRL

        pha
        lda #$00
        sta (scrnCursor),Y
        pla

        dec IOPAGE_CTRL

        dey
        bpl _next6

_XIT    dec CursorRow
        rts
.endp


.proc   @resetCursorPointer
        lda #>CS_TEXT_MEM_PTR
        sta scrnCursor+1
        lda #<CS_TEXT_MEM_PTR
        sta scrnCursor

        lda MASTER_CTRL_H
        and #@masterctrlh(mcTextDoubleX)        ; check screen mode for double-x (40 or 80 columns)
        beq _in640x480

        ldx #40
        .by $2C
_in640x480:
        ldx #80
        stx tempzp

        ldy CursorRow
        beq _XIT

_next1  lda scrnCursor
        clc
        adc tempzp
        sta scrnCursor
        lda scrnCursor+1
        adc #0
        sta scrnCursor+1

        dey
        bne _next1

_XIT    rts
        .endp
