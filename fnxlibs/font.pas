
unit font;

// ------------------------------------
interface
// ------------------------------------

uses f256;

procedure Init(idx: byte; addr: word);


// ------------------------------------
implementation
// ------------------------------------

procedure Init(idx: byte; addr: word);
begin
    move(pointer(addr),pointer((idx and 1)*$0800+FONT_MEMORY_BANK0),$0800)
end;

end.
