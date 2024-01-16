
program spritetest;

uses sprite, f256;

var
    sprite00 : array[0..255] of byte =
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
    // InitGraph(ord(masterctrll(mcGraphicsOn+mcSpriteOn)),ord(masterctrlh.mcVideoMode240));

    sprite.Init(0,ord(spritectrl(scEnable+scLUT0+scDEPTH0+scSIZE_16)),@sprite00);
    sprite.Pos(0,100,100);
end.
