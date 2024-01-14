if t = 'A8' then target := a8 else
  if t = 'C64' then target := c64 else
    if t = 'C4P' then target := c4p else
      if t = 'F256' then
      begin
        target := f256;
        F256Outtype := 'BIN';
      end
      else
      if t = 'F256PGX' then
      begin
        target := f256;
        F256Outtype := 'PGX';
      end
      if t = 'F256PGZ' then
      begin
        target := f256;
        F256Outtype := 'PGZ';
      end
      else
        if t = 'RAW' then target := raw else
          Syntax(3);
