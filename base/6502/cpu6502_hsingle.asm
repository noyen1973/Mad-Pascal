; JAVA IEEE-32 (IEEE-754)
; David Schmenk
; https://sourceforge.net/projects/vm02/
; http://vm02.cvs.sourceforge.net/viewvc/vm02/vm02/src/

/*
	org eax

FP1MAN0	.ds 1
FP1MAN1	.ds 1
FP1MAN2	.ds 1
FP1MAN3	.ds 1

	org ztmp8

FP1SGN	.ds 1
FP1EXP	.ds 1

	org edx

FP2MAN0	.ds 1
FP2MAN1	.ds 1
FP2MAN2	.ds 1
FP2MAN3	.ds 1

	org ztmp10

FP2SGN	.ds 1
FP2EXP	.ds 1

	org ecx

FPMAN0	.ds 1
FPMAN1	.ds 1
FPMAN2	.ds 1
FPMAN3	.ds 1

	org bp2

FPSGN	.ds 1
FPEXP	.ds 1

*/

@rx	= bp+1

MIN_EXPONENT	= 10
MAX_EXPONENT	= 255


.proc	NEGINT

	LDA	#$00
	SEC

enter	SBC	FPMAN0
	STA	FPMAN0
	LDA	#$00
	SBC	FPMAN1
	STA	FPMAN1
	LDA	#$00
	SBC	FPMAN2
	STA	FPMAN2
	LDA	#$00
	SBC	FPMAN3
	STA	FPMAN3
	RTS
.endp


.proc	FROUND
FADD:	LDA	#$00
	STA	FP2SGN

	lda :STACKORIGIN,x
	STA	FP2MAN0
	lda :STACKORIGIN+STACKWIDTH,x
	STA	FP2MAN1
	lda :STACKORIGIN+STACKWIDTH*2,x
	CMP	#$80		; SET CARRY FROM MSB
	ORA	#$80		; SET HIDDEN BIT
	STA	FP2MAN2
	lda :STACKORIGIN+STACKWIDTH*3,x
	EOR	FP2SGN		; TOGGLE SIGN FOR FSUB
	ROL
	STA	FP2EXP
	LDA	#$00
	STA	FPSGN
	BCC	@+
	SBC	FP2MAN0
	STA	FP2MAN0
	LDA	#$00
	SBC	FP2MAN1
	STA	FP2MAN1
	LDA	#$00
	SBC	FP2MAN2
	STA	FP2MAN2
	LDA	#$FF
@	STA	FP2MAN3
	lda #$00
	STA	FP1MAN0
	STA	FP1MAN1
	CMP	#$80		; SET CARRY FROM MSB
	ORA	#$80		; SET HIDDEN BIT
	STA	FP1MAN2

	lda :STACKORIGIN+STACKWIDTH*3,x
	and #$80
	ora #$3f		; 0.5 / -0.5

	inx

	jsr FSUB.enter

	dex

	rts
.endp


.proc	FSUB
	LDA	#$80		; TOGGLE SIGN
	BNE	@+
FADD:	LDA	#$00
@	STA	FP2SGN
;	stx @rx

	lda :STACKORIGIN,x
	STA	FP2MAN0
	lda :STACKORIGIN+STACKWIDTH,x
	STA	FP2MAN1
	lda :STACKORIGIN+STACKWIDTH*2,x
	CMP	#$80		; SET CARRY FROM MSB
	ORA	#$80		; SET HIDDEN BIT
	STA	FP2MAN2
	lda :STACKORIGIN+STACKWIDTH*3,x
	EOR	FP2SGN		; TOGGLE SIGN FOR FSUB
	ROL
	STA	FP2EXP
	LDA	#$00
	STA	FPSGN
	BCC	@+
	SBC	FP2MAN0
	STA	FP2MAN0
	LDA	#$00
	SBC	FP2MAN1
	STA	FP2MAN1
	LDA	#$00
	SBC	FP2MAN2
	STA	FP2MAN2
	LDA	#$FF
@	STA	FP2MAN3
	lda :STACKORIGIN-1,x
	STA	FP1MAN0
	lda :STACKORIGIN-1+STACKWIDTH,x
	STA	FP1MAN1
	lda :STACKORIGIN-1+STACKWIDTH*2,x
	CMP	#$80		; SET CARRY FROM MSB
	ORA	#$80		; SET HIDDEN BIT
	STA	FP1MAN2
	lda :STACKORIGIN-1+STACKWIDTH*3,x
enter	ROL
	STA	FP1EXP
	LDA	#$00
	BCC	@+
	SBC	FP1MAN0
	STA	FP1MAN0
	LDA	#$00
	SBC	FP1MAN1
	STA	FP1MAN1
	LDA	#$00
	SBC	FP1MAN2
	STA	FP1MAN2
	LDA	#$FF
@	STA	FP1MAN3
	LDA	FP1EXP		; CALCULATE WHICH MANTISSA TO SHIFT
	STA	FPEXP
	SEC
	SBC	FP2EXP
	BEQ	FADDMAN
	BCS	@+
	EOR	#$FF
	TAY
	INY
	LDA	FP2EXP
	STA	FPEXP
	LDA	FP1MAN3
	CPY	#24		; KEEP SHIFT RANGE VALID
	BCC	FP1SHFT
	LDA	#$00
	STA	FP1MAN3
	STA	FP1MAN2
	STA	FP1MAN1
	STA	FP1MAN0
	BEQ	FADDMAN
FP1SHFT:	CMP	#$80	; SHIFT FP1 DOWN
	ROR
	ROR	FP1MAN2
	ROR	FP1MAN1
	ROR	FP1MAN0
	DEY
	BNE	FP1SHFT
	STA	FP1MAN3
	JMP	FADDMAN

@	TAY
	LDA	FP2MAN3
	CPY	#24		; KEEP SHIFT RANGE VALID
	BCC	FP2SHFT
	LDA	#$00
	STA	FP2MAN3
	STA	FP2MAN2
	STA	FP2MAN1
	STA	FP2MAN0
	BEQ	FADDMAN
FP2SHFT:	CMP	#$80	; SHIFT FP2 DOWN
	ROR
	ROR	FP2MAN2
	ROR	FP2MAN1
	ROR	FP2MAN0
	DEY
	BNE	FP2SHFT
	STA	FP2MAN3
FADDMAN:	LDA	FP1MAN0
	CLC
	ADC	FP2MAN0
	STA	FPMAN0
	LDA	FP1MAN1
	ADC	FP2MAN1
	STA	FPMAN1
	LDA	FP1MAN2
	ADC	FP2MAN2
	STA	FPMAN2
	LDA	FP1MAN3
	ADC	FP2MAN3
	STA	FPMAN3
	BPL	FPNORM

	LDA	#$80
	STA	FPSGN

	JSR	NEGINT

	jmp FPNORM
.endp


.proc	FPNORM
	BEQ	FPNORMLEFT	; NORMALIZE FP, A = FPMANT3
FPNORMRIGHT:	INC	FPEXP
	LSR
	STA	FPMAN3
	ROR	FPMAN2
	ROR	FPMAN1
	LDA	FPMAN0
	ROR
	ADC	#$00
	STA	FPMAN0
	LDA	FPMAN1
	ADC	#$00
	STA	FPMAN1
	LDA	FPMAN2
	ADC	#$00
	STA	FPMAN2
	LDA	FPMAN3
	ADC	#$00
	BNE	FPNORMRIGHT
	LDA	FPEXP
	ASL	FPMAN2
	LSR
	ORA	FPSGN

;	ldx @rx
	sta :STACKORIGIN-1+STACKWIDTH*3,x
	LDA	FPMAN2
	ROR
	sta :STACKORIGIN-1+STACKWIDTH*2,x

	lda :STACKORIGIN-1+STACKWIDTH*3,x
	asl @
	tay
	lda :STACKORIGIN-1+STACKWIDTH*2,x
	spl
	iny
	cpy #MIN_EXPONENT	; to small 6.018531E-36
	bcc zero
	cpy #MAX_EXPONENT
	beq zero		; number is infinity (if the mantissa is zero) or a NaN (if the mantissa is non-zero)

	LDA	FPMAN1
	sta :STACKORIGIN-1+STACKWIDTH,x
	LDA	FPMAN0
	sta :STACKORIGIN-1,x
	rts

FPNORMLEFT:	LDA	FPMAN2
	BNE	FPNORMLEFT1
	LDA	FPMAN1
	BNE	FPNORMLEFT8
	LDA	FPMAN0
	BNE	FPNORMLEFT16

;	ldx @rx			; RESULT IS ZERO
zero	lda #0

	sta :STACKORIGIN-1,x
	sta :STACKORIGIN-1+STACKWIDTH,x
	sta :STACKORIGIN-1+STACKWIDTH*2,x
	sta :STACKORIGIN-1+STACKWIDTH*3,x
	rts

FPNORMLEFT16:	TAY
	LDA	FPEXP
	SEC
	SBC	#$10
	STA	FPEXP
	LDA	#$00
	STA	FPMAN1
	STA	FPMAN0
	TYA
	BNE	FPNORMLEFT1
FPNORMLEFT8:	TAY
	LDA	FPMAN0
	STA	FPMAN1
	LDA	FPEXP
	SEC
	SBC	#$08
	STA	FPEXP
	LDA	#$00
	STA	FPMAN0
	TYA
FPNORMLEFT1:	BMI	FPNORMDONE
@	DEC	FPEXP
	ASL	FPMAN0
	ROL	FPMAN1
	ROL
	BPL	@-
FPNORMDONE:	ASL
	TAY
	LDA	FPEXP
	LSR
	ORA	FPSGN

;	ldx @rx
	sta :STACKORIGIN-1+STACKWIDTH*3,x
	TYA
	ROR
	sta :STACKORIGIN-1+STACKWIDTH*2,x

	lda :STACKORIGIN-1+STACKWIDTH*3,x
	asl @
	tay
	lda :STACKORIGIN-1+STACKWIDTH*2,x
	spl
	iny
	cpy #MIN_EXPONENT	; to small 6.018531E-36
	bcc zero
	cpy #MAX_EXPONENT
	beq zero		; number is infinity (if the mantissa is zero) or a NaN (if the mantissa is non-zero)

	LDA	FPMAN1
	sta :STACKORIGIN-1+STACKWIDTH,x
	LDA	FPMAN0
	sta :STACKORIGIN-1,x

	rts
.endp


.proc	FMUL

	stx @rx

	lda :STACKORIGIN,x
	STA	FP2MAN0
	lda :STACKORIGIN+STACKWIDTH,x
	STA	FP2MAN1
	lda :STACKORIGIN+STACKWIDTH*2,x
	CMP	#$80		; SET CARRY FROM MSB
	ORA	#$80		; SET HIDDEN BIT
	STA	FP2MAN2
 	lda :STACKORIGIN+STACKWIDTH*3,x
	ROL
	STA	FP2EXP
	BNE	@+

; MUL BY ZERO, RESULT ZERO
;	LDA	#$00
ZERO:	STA :STACKORIGIN-1,x
	STA :STACKORIGIN-1+STACKWIDTH,x
	STA :STACKORIGIN-1+STACKWIDTH*2,x
	STA :STACKORIGIN-1+STACKWIDTH*3,x
	rts

@	LDA	#$00
	ROR
	STA	FPSGN
	lda :STACKORIGIN-1,x
	STA	FP1MAN0
	lda :STACKORIGIN-1+STACKWIDTH,x
	STA	FP1MAN1
	lda :STACKORIGIN-1+STACKWIDTH*2,x
	CMP	#$80		; SET CARRY FROM MSB
	ORA	#$80		; SET HIDDEN BIT
	STA	FP1MAN2
	lda :STACKORIGIN-1+STACKWIDTH*3,x
	ROL
	STA	FP1EXP
	BEQ	ZERO		; MUL BY ZERO, RESULT ZERO

	LDA	#$00
	ROR
	EOR	FPSGN
	STA	FPSGN
	LDA	FP1EXP
	CLC			; ADD EXPONENTS
	ADC	FP2EXP
	SEC			; SUBTRACT BIAS
	SBC	#$7F
	STA	FPEXP
	LDX	#$00
	STX	FPMAN0
	STX	FPMAN1
	STX	FPMAN2
	STX	FPMAN3
	STX	TMP
FMULNEXTBYTE:	LDA	FP1MAN0,X
	BNE	@+
	LDX	FPMAN1		; SHORT CIRCUIT BYTE OF ZERO BITS
	STX	FPMAN0
	LDX	FPMAN2
	STX	FPMAN1
	LDX	FPMAN3
	STX	FPMAN2
	STA	FPMAN3
	INC	TMP
	LDX	TMP
	CPX	#$03
	BNE	FMULNEXTBYTE

	ldx @rx
	LDA	FPMAN3
	JMP	FPNORM

@	EOR	#$FF
	LDX	#$08
FMULTSTBITS:	LSR	FPMAN3
	ROR	FPMAN2
	ROR	FPMAN1
	ROR	FPMAN0
	LSR
	BCS	FMULNEXTTST
	TAY
	LDA	FP2MAN0
	ADC	FPMAN0
	STA	FPMAN0
	LDA	FP2MAN1
	ADC	FPMAN1
	STA	FPMAN1
	LDA	FP2MAN2
	ADC	FPMAN2
	STA	FPMAN2
	LDA	#$00
	ADC	FPMAN3
	STA	FPMAN3
	TYA
FMULNEXTTST:	DEX
	BNE	FMULTSTBITS
	INC	TMP
	LDX	TMP
	CPX	#$03
	BNE	FMULNEXTBYTE

	ldx @rx
	LDA	FPMAN3
	JMP	FPNORM
.endp


.proc	FDIV

	stx @rx

	lda :STACKORIGIN,x
	STA	FP2MAN0
	lda :STACKORIGIN+STACKWIDTH,x
	STA	FP2MAN1
	lda :STACKORIGIN+STACKWIDTH*2,x
	CMP	#$80		; SET CARRY FROM MSB
	ORA	#$80		; SET HIDDEN BIT
	STA	FP2MAN2
	lda :STACKORIGIN+STACKWIDTH*3,x
	ROL
	STA	FP2EXP
	BNE	@+

;	LDA	#$00
ZERO:	STA :STACKORIGIN-1,x
	STA :STACKORIGIN-1+STACKWIDTH,x
	STA :STACKORIGIN-1+STACKWIDTH*2,x
	STA :STACKORIGIN-1+STACKWIDTH*3,x
	rts
;	LDA	#23		; DIVIDE BY ZERO, ERROR
;	JMP	SYSTHROW

@	LDA	#$00
	ROR
	STA	FPSGN
	lda :STACKORIGIN-1,x
	STA	FP1MAN0
	lda :STACKORIGIN-1+STACKWIDTH,x
	STA	FP1MAN1
	lda :STACKORIGIN-1+STACKWIDTH*2,x
	CMP	#$80		; SET CARRY FROM MSB
	ORA	#$80		; SET HIDDEN BIT
	STA	FP1MAN2
	lda :STACKORIGIN-1+STACKWIDTH*3,x
	ROL
	STA	FP1EXP
	BEQ	ZERO		; DIVIDE ZERO, RESULT ZERO

	LDA	#$00
	STA	FP1MAN3
	ROR
	EOR	FPSGN
	STA	FPSGN
	LDA	FP1EXP
	SEC			; SUBTRACT EXPONENTS
	SBC	FP2EXP
	CLC
	ADC	#$7F		; ADD BACK BIAS
	STA	FPEXP

	LDX	#24		; #BITS
FDIVLOOP:	LDA	FP1MAN0
	SEC
	SBC	FP2MAN0
	STA	TMP
	LDA	FP1MAN1
	SBC	FP2MAN1
	STA	TMP+1
	LDA	FP1MAN2
	SBC	FP2MAN2
	TAY
	LDA	FP1MAN3
	SBC	#$00
	BCC	FDIVNEXTBIT
	STA	FP1MAN3
	STY	FP1MAN2
	LDA	TMP+1
	STA	FP1MAN1
	LDA	TMP
	STA	FP1MAN0
FDIVNEXTBIT:	ROL	FPMAN0
	ROL	FPMAN1
	ROL	FPMAN2
	ASL	FP1MAN0
	ROL	FP1MAN1
	ROL	FP1MAN2
	ROL	FP1MAN3
	DEX
	BNE	FDIVLOOP

	ldx @rx
	LDA	#$00
	JMP	FPNORM
.endp


.proc	FCMPL
FCMPG:
	CLV

	LDA	:STACKORIGIN+STACKWIDTH*3,X	; COMPARE SIGNS
	AND	#$80
	STA	FP2SGN
	LDA	:STACKORIGIN-1+STACKWIDTH*3,X
	AND	#$80
	CMP	FP2SGN
	BCC	FCMPGTSGN
	BEQ	@+
	BCS	FCMPLTSGN
@	LDA	:STACKORIGIN-1+STACKWIDTH*3,X	; COMPARE AS MAGNITUDE
	CMP	:STACKORIGIN+STACKWIDTH*3,X
	BCC	FCMPLT
	BEQ	@+
	BCS	FCMPGT
@	LDA	:STACKORIGIN-1+STACKWIDTH*2,X
	CMP	:STACKORIGIN+STACKWIDTH*2,X
	BCC	FCMPLT
	BEQ	@+
	BCS	FCMPGT
@	LDA	:STACKORIGIN-1+STACKWIDTH,X
	CMP	:STACKORIGIN+STACKWIDTH,X
	BCC	FCMPLT
	BEQ	@+
	BCS	FCMPGT
@	LDA	:STACKORIGIN-1,X
	CMP	:STACKORIGIN,X
	BCC	FCMPLT
	BEQ	FCMPEQ
	BCS	FCMPGT
FCMPEQ:	LDA #0			; EQUAL
	RTS

FCMPGT:	LDA	FP2SGN		; FLIP RESULT IF NEGATIVE #S
	BMI	FCMPLTSGN
FCMPGTSGN:	LDA	#$01	; GREATER THAN
	RTS

FCMPLT:	LDA	FP2SGN		; FLIP RESULT IF NEGATIVE #S
	BMI	FCMPGTSGN
FCMPLTSGN:	LDA	#$FF	; LESS THAN
	RTS
.endp


.proc	F2I

	lda :STACKORIGIN,x
	STA	FPMAN0
	lda :STACKORIGIN+STACKWIDTH,x
	STA	FPMAN1
	lda :STACKORIGIN+STACKWIDTH*2,x
	CMP	#$80		; SET CARRY FROM MSB
	ORA	#$80		; SET HIDDEN BIT
	STA	FPMAN2
	lda :STACKORIGIN+STACKWIDTH*3,x
	ROL	@
	STA	FPEXP
	LDA	#$00
	ROR	@
	STA	FPSGN
	LDA	FPEXP		; CHECK FOR LESS THAN ONE
	SEC
	SBC	#$7F
	BCS	@+

ZERO:	LDA	#$00		; RETURN ZERO
	STA :STACKORIGIN,x
	STA :STACKORIGIN+STACKWIDTH,x
	STA :STACKORIGIN+STACKWIDTH*2,x
	STA :STACKORIGIN+STACKWIDTH*3,x
	rts

@	CMP	#23
	BCS	F2ISHL
	STA	FPEXP
	LDA	#23
	SEC
	SBC	FPEXP
	TAY			; SHIFT MANTISSA RIGHT
	LDA	FPMAN2
F2ISHR:	LSR	@
	ROR	FPMAN1
	ROR	FPMAN0
	DEY
	BNE	F2ISHR
	STA	FPMAN2
	STY	FPMAN3
F2ICHKNEG:	LDA	FPSGN
	BPL	@+		; CHECK FOR NEGATIVE
	ASL	@		; LDA #$00; SEC

	JSR	NEGINT.enter

@	LDA	FPMAN3
	STA :STACKORIGIN+STACKWIDTH*3,x
	LDA	FPMAN2
	STA :STACKORIGIN+STACKWIDTH*2,x
	LDA	FPMAN1
	STA :STACKORIGIN+STACKWIDTH,x
	LDA	FPMAN0
	STA :STACKORIGIN,x
	rts

F2ISHL:	CMP	#32
	BCC	@+
	LDA	#$FF		; OVERFLOW, STORE MAXINT
	STA	FPMAN0
	STA	FPMAN1
	STA	FPMAN2
	LSR	@
	STA	FPMAN3
	BNE	F2ICHKNEG
@	SEC
	SBC	#23
	BNE	@+
	STA	FPMAN3
	BEQ	F2ICHKNEG
@	TAY			; SHIFT MANTISSA LEFT
	LDA	#$00
@	ASL	FPMAN0
	ROL	FPMAN1
	ROL	FPMAN2
	ROL	@
	DEY
	BNE	@-
	STA	FPMAN3
	BEQ	F2ICHKNEG
.endp


.proc	I2F
;	stx @rx

	lda :STACKORIGIN,x
	STA	FPMAN0
	lda :STACKORIGIN+STACKWIDTH,x
	STA	FPMAN1
	lda :STACKORIGIN+STACKWIDTH*2,x
	STA	FPMAN2
	lda :STACKORIGIN+STACKWIDTH*3,x
	STA	FPMAN3
	AND	#$80
	STA	FPSGN
	BPL	@+
;	LDX	#FPMAN0
	JSR	NEGINT
@	LDA	#$7F+23
	STA	FPEXP

	inx			; ten zabieg zapisze pod :STACKORIGIN,x
				; zamiast :STACKORIGIN-1,x
	LDA	FPMAN3
	JSR	FPNORM

	dex
	rts
.endp
