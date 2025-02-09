
  opt l-

/* -----------------------------------------------------------------------
/*                        CPU 6502 Run Time Library - Foenix F256
/* -----------------------------------------------------------------------

@AllocMem
@FreeMem

*/

MAXSIZE = 4
EOL = $0D
@buf  = $0200   ; lo addr = 0 !!!

fracpart = eax

; -----------------------------------------------------------------------

.enum e@file
  eof = 1, open, assign
.ende

.struct s@file
pfname  .word               ; pointer to string with filename
record  .word               ; record size
chanel  .byte               ; channel *$10
status  .byte               ; status bit 0..7
buffer  .word               ; load/write buffer
nrecord .word               ; number of records for load/write
numread .word               ; pointer to variable, length of loaded data
.ends

; -----------------------------------------------------------------------

  icl 'runtime\macros.asm'

; -----------------------------------------------------------------------

  icl 'rtl_default.asm'
  
; -----------------------------------------------------------------------

  icl 'f256\f256.hea'
	icl 'f256\clrscr.asm'     ; @clrscr
  icl 'f256\putchar.asm'	  ; @putchar
	icl 'f256\putpixel.asm'		; @putpixel

; -----------------------------------------------------------------------

  opt l+
