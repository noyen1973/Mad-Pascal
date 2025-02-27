
function opt_BP2_ADR(i: integer): Boolean;
var p, q: integer;
    tmp: string;
begin

    Result := true;

// -----------------------------------------------------------------------------
// ===				    BP2 -> ADR.
// -----------------------------------------------------------------------------

    if lda_a(i) and (lda_stack(i) = false) and						// lda TB				; 0
       add_stack(i+1) and								// add :STACKORIGIN			; 1
       sta_bp2(i+2) and									// sta :bp2				; 2
       lda_a(i+3) and (lda_stack(i+3) = false) and					// lda TB+1				; 3
       adc_stack(i+4) and								// adc :STACKORIGIN+STACKWIDTH		; 4
       sta_bp2_1(i+5) and 		 						// sta :bp2+1				; 5
       ldy_im_0(i+6) then								// ldy #$00				; 6
    begin

     tmp:=#9'sta ' + copy(listing[i+1], 6, 256);


// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------	// CARDINAL
// -----------------------------------------------------------------------------

     for p:=i-1 downto 0 do
      if listing[p] = tmp then begin


    if (p > 1) and
       lda(p-2) and (lda_stack(p-2) = false) and 					// lda  				; p-2		#-CARDINAL
       add_im(p-1) and									// add #				; p-1
											// sta :STACKORIGIN			; p
       lda(p+1) and									// lda 					; p+1
       adc_im(p+2) and									// adc #				; p+2
       asl_stack(p+3) and								// asl :STACKORIGIN			; p+3
       rol_a(p+4) and									// rol @				; p+4
       asl_stack(p+5) and								// asl :STACKORIGIN			; p+5
       rol_a(p+6) and									// rol @				; p+6
       sta_stack(p+7) then								// sta :STACKORIGIN+STACKWIDTH		; p+7
      begin

	q:=GetWORD(p-1, p+2);

	q:=q * 4;

	if q < 63 then begin
	  listing[i+6]  := #9'ldy #$' + IntToHex(q, 2);

	  listing[p-1] := '';

	  listing[p+2] := '';

 	  Result:=false; Break;
        end;

      end;

// -----------------------------------------------------------------------------

       Break;
      end else	// for p:=
        if onBreak(p) then Break;

     if Result = false then exit(false);


// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------	// WORD
// -----------------------------------------------------------------------------


     for p:=i-1 downto 0 do
      if listing[p] = tmp then begin


    if (p > 1) and
       lda(p-2) and (lda_stack(p-2) = false) and					// lda  				; p-2		#+WORD
       add_im(p-1) and									// add #				; p-1
											// sta :STACKORIGIN			; p
       lda(p+1) and									// lda 					; p+1
       adc_im_0(p+2) and								// adc #$00				; p+2
       asl_stack(p+3) and								// asl :STACKORIGIN			; p+3
       rol_a(p+4) and									// rol @				; p+4
       sta_stack(p+5) then								// sta :STACKORIGIN+STACKWIDTH		; p+5
      begin

	q:=GetWORD(p-1, p+2);

	q:=q * 2;

	if q < 127 then begin
	  listing[i+6]  := #9'ldy #$' + IntToHex(q, 2);

	  listing[p-1] := '';

	  listing[p+2] := '';

 	  Result:=false; Break;
        end;

      end;


// -----------------------------------------------------------------------------

       Break;
      end else	// for p:=
        if onBreak(p) then Break;

     if Result = false then exit(false);


// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------	// BYTE
// -----------------------------------------------------------------------------
(*
     for p:=i-1 downto 0 do
      if listing[p] = tmp then begin


{
    if (p > 1) and
       (lda_stack(p-2) = false) and (sub_stack(p-1) = false) and			// lda #				; p-2		#-BYTE
       (lda_im(p-2) and sub(p-1) and (sub_im(p-1) = false)) and				// sub					; p-1
											// sta :STACKORIGIN			; p
       lda(p+1) and									// lda 					; p+1
       sbc(p+2) and									// sbc 					; p+2
       sta_stack(p+3) then								// sta :STACKORIGIN+STACKWIDTH		; p+3
      begin
	listing[i+3]  := '';
	listing[i+4]  := '';
	listing[i+5]  := '';

	listing[p+1] := '';
	listing[p+2] := '';
	listing[p+3] := '';

	Result:=false; Break;
      end;
}

// -----------------------------------------------------------------------------

       Break;
      end else	// for p:=
        if onBreak(p) or (listing[p] = #9'asl ' + copy(listing[i], 6, 256)) then Break;
*)


// -----------------------------------------------------------------------------

     if Result = false then exit(false);
    end;

end;		// function