IF LAST-OF (SUBSTRING(cbddmov.codcta,1,{1})) AND x-conreg > 0
            AND LOOKUP(STRING({1}), x-long-niveles) <> 0 THEN DO:
    {O:\SRC\CBD\b_print.i "NUMPAG"}.
    IF {1} > 2 THEN
        UNDERLINE STREAM report x-debe x-haber
                            x-deudor x-acreedor WITH FRAME f-cab.
    
    FIND cuentas WHERE cuentas.codcta = SUBSTR(cbddmov.codcta,1,{1})
                 AND cuentas.CodCia = y-CodCia NO-LOCK NO-ERROR.
    IF AVAILABLE cuentas THEN x-nomcta = cuentas.nomcta.
    x-nomcta = "CUENTA " + SUBSTR(cbddmov.codcta,1,{1}) 
                + " " + x-nomcta.
    DISPLAY STREAM report "   TOTAL" @ cbddmov.codcta
                                                         x-nomcta   @ x-nomcta
         ACCUM SUB-TOTAL BY SUBSTR(cbddmov.codcta,1,{1}) x-debe     @ x-debe
         ACCUM SUB-TOTAL BY SUBSTR(cbddmov.codcta,1,{1}) x-haber    @ x-haber
         ACCUM SUB-TOTAL BY SUBSTR(cbddmov.codcta,1,{1}) x-deudor   @ x-deudor
         ACCUM SUB-TOTAL BY SUBSTR(cbddmov.codcta,1,{1}) x-acreedor @ x-acreedor
        WITH FRAME f-cab.
    IF {1} > 2 THEN
        UNDERLINE STREAM report cbddmov.codcta x-nomcta x-debe x-haber
                            x-deudor x-acreedor WITH FRAME f-cab.
    ELSE DO:
        x-conreg = 0.
        DOWN STREAM report 1 WITH FRAME f-cab.
        DISPLAY STREAM report "========" @ cbddmov.codcta
                "========================================" @ x-nomcta
                "===============" @ x-debe
                "===============" @ x-haber
                "===============" @ x-deudor
                "===============" @ x-acreedor
            WITH FRAME f-cab.
        DOWN STREAM report 1 WITH FRAME f-cab.
    END.
END.
