
/*
	mulSMALLINT
	divmulSMALLINT
*/


.proc	mulSMALLINT

	jsr imulWORD

	lda :STACKORIGIN-1+STACKWIDTH,x	; t1
	bpl @+
		sec
		lda eax+2
		sbc :STACKORIGIN,x
		sta eax+2
		lda eax+3
		sbc :STACKORIGIN+STACKWIDTH,x
		sta eax+3
@
	lda :STACKORIGIN+STACKWIDTH,x	; t2
	bpl @+
		sec
		lda eax+2
		sbc :STACKORIGIN-1,x
		sta eax+2
		lda eax+3
		sbc :STACKORIGIN-1+STACKWIDTH,x
		sta eax+3
@
	jmp movaBX_EAX
.endp


.proc	divmulSMALLINT

SHORTREAL
	ldy <divSHORTREAL
	lda >divSHORTREAL
	bne skp

MOD	mva #{jsr} _mod

	lda :STACKORIGIN+STACKWIDTH,x	; divisor sign
	spl
	jsr negWORD

DIV	ldy <idivWORD
	lda >idivWORD

skp	sty addr
	sta addr+1

	ldy #0

	lda :STACKORIGIN-1+STACKWIDTH,x	; dividend sign
	bpl @+
	jsr negWORD1
	iny
@
	lda :STACKORIGIN+STACKWIDTH,x	; divisor sign
	bpl @+
	jsr negWORD
	iny
@
	tya
	and #1
	pha

	jsr $ffff			; idiv cx
addr	equ *-2

	jsr movaBX_EAX

_mod	bit movZTMP_aBX			; mod
	mva #{bit} _mod

	pla
	seq
	jmp negCARD1

	rts
.endp
