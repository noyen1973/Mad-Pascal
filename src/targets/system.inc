//target.name

{$ifdef atari}
  {$i system_atari.inc}
{$endif}
{$ifdef c64}
  {$i system_c64.inc}
{$endif}
{$ifdef c4p}
  {$i system_c4p.inc}
{$endif}
{$ifdef f256}
  {$i system_f256.inc}
{$endif}
{$ifdef raw}
  {$i system_raw.inc}
{$endif}