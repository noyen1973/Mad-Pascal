
unit font;

// ------------------------------------
interface
// ------------------------------------

uses f256;

procedure Init(idx: byte; addr: word); register; assembler;


// ------------------------------------
implementation
// ------------------------------------

procedure Init(idx: byte; addr: word); register; assembler;
// var
//     fnt: ^byte absolute $C000;
//     src: ^byte;
//     i: word;
// begin
//     IOPAGE_CTRL := iopPage1;

//     src := pointer(addr);

//     if idx = 1 then
//         fnt := fnt + $800;

//     for i := 0 to 1023 do begin
//         fnt^ := src^;
//         inc(fnt);
//         inc(src);
//     end;
// end;
asm
        phx
        phy

        ldy IOPAGE_CTRL
        phy

        ldx #@iopagectrl(iopPage1)
        stx IOPAGE_CTRL

        lda :edx
        asl
        asl
        asl
        ora #>FONT_MEMORY_BANK0
        sta :edx+1
        lda #<FONT_MEMORY_BANK0
        sta :edx
        ldx #8
        ldy #0
_1
        lda (:ecx),y
        sta (:edx),y
        iny
        bne _1
        inc :ecx+1
        inc :edx+1
        dex
        bne _1

        ply
        sty IOPAGE_CTRL

        ply
        plx
end;

end.
