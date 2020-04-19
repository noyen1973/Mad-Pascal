
; unit MISC: DetectMem
; by Tebe

.proc	@xmsWriteBuf (.word ptr1, ptr2) .var

ptr1 = dx	; buffer	(2)

ptr2 = cx	; count		(2)
pos = cx+2	; position	(2) pointer

ptr3 = eax	; position	(4)

	txa:pha

	ldy #0			; przepisz POSITION spod wskaznika
	lda (pos),y
	sta ptr3
	iny
	lda (pos),y
	sta ptr3+1
	iny
	lda (pos),y
	sta ptr3+2
	iny
	lda (pos),y
	sta ptr3+3

lp1	lda portb		; wylacz dodatkowe banki
	and #1
	ora #$fe
	sta portb

	ldy #0			; przepisz 256b z BUFFER do @BUF
	mva:rne (dx),y @buf,y+

	jsr @xmsBank		; wlacz dodatkowy bank

	lda ptr2+1
	beq lp2

	lda ztmp+1		; jesli przekraczamy granice banku $7FFF
	cmp #$7f
	bne skp
	lda ztmp
	beq skp

	lda #0			; to realizuj wyjatek NEXTBANK, kopiuj 256b
	jsr nextBank
	jmp skp2

skp	mva:rne @buf,y (ztmp),y+

skp2	inc dx+1		// inc(dx, $100)

	inl ptr3+1		// inc(position, $100)

	dec ptr2+1
	bne lp1

lp2	lda ztmp+1		; zakonczenie kopiowania
	cmp #$7f		; jesli przekraczamy granice banku $7FFF
	bne skp_

	lda ztmp
	add ptr2
	bcc skp_

	lda ptr2		; to realizuj wyjatek NEXTBANK, kopiuj PTR2 bajtow
	jsr nextBank
	jmp quit

skp_	ldy #0
lp3	lda @buf,y
	sta (ztmp),y

	iny
	cpy ptr2
	bne lp3

quit	lda portb
	and #1
	ora #$fe
	sta portb

	jmp @xmsUpdatePosition

.local	nextBank

	sta max

	mwa ztmp dst

	ldy #0
mv0	lda @buf,y
	sta $ffff,y
dst	equ *-2
	iny
	inc ztmp
	bne mv0

	lda portb
	and #1
	ora MAIN.MISC.ADR.BANKS+1,x
	sta portb

	ldx #0
mv1	cpy #0
max	equ *-1
	beq stp
	lda @buf,y
	sta $4000,x
	inx
	iny
	bne mv1
stp	rts
.endl

.endp
