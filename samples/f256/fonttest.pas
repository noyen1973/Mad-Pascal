
program fonttest;

uses font, f256;

var
    font00 : array[0..255] of byte =
    (
        $00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$01,$00,$00,$00,$00,
        $00,$00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$00,
        $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,
        $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,
        $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,
        $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,
        $00,$00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$00,
        $00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$01,$00,$00,$00,$00,
        $00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$00,$00,$00,$00,$00,$00,
        $00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00,
        $00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00,
        $00,$00,$00,$00,$00,$00,$03,$03,$03,$03,$00,$00,$00,$00,$00,$00,
        $00,$00,$00,$00,$00,$00,$03,$03,$03,$03,$00,$00,$00,$00,$00,$00,
        $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
        $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
        $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    );

begin
    // InitGraph(ord(masterctrll(mcGraphicsOn+mcBitmapOn)),ord(masterctrlh.mcVideoMode240));

    font.Init(0, @font00);
end.
