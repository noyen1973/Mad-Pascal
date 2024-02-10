
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
    move(pointer(addr),pointer(idx*$0800+FONT_MEMORY_BANK0),$0800)
end;

end.
