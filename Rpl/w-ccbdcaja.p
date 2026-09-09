TRIGGER PROCEDURE FOR REPLICATION-WRITE OF ccbdcaja.
/*
FIND ccbccaja OF ccbdcaja NO-LOCK NO-ERROR.
IF AVAILABLE ccbccaja THEN DO:
    DEF VAR X-CanalVenta AS CHAR INIT "MIN" NO-UNDO.
    FIND gn-divi WHERE gn-divi.codcia = ccbccaja.codcia AND 
        gn-divi.coddiv = ccbccaja.coddiv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN x-CanalVenta = gn-divi.CanalVenta.

    {rpl/reptrig.i
    &Table  = ccbdcaja
    &Key    =  "string(ccbdcaja.codcia,'999') + string(ccbdcaja.coddoc,'x(3)') ~
        + string(ccbdcaja.nrodoc,'x(15)') + string(ccbdcaja.codref,'x(3)') ~
        + string(ccbdcaja.nroref,'x(15)')"
    &Prg    = r-ccbdcaja
    &Event  = WRITE
    &FlgDB0 = NO
    &FlgDB1 = TRUE      
    &FlgDB2 = TRUE
    &FlgDB3 = TRUE
    &FlgDB4 = TRUE
    &FlgDB5 = TRUE
    &FlgDB6 = TRUE
    &FlgDB7 = TRUE
    &FlgDB8 = TRUE
    &FlgDB9 = TRUE
    &FlgDB10 = TRUE
    &FlgDB11 = TRUE
    &FlgDB12 = TRUE
    &FlgDB13 = TRUE
    &FlgDB14 = TRUE
    &FlgDB15 = TRUE
    &FlgDB16 = TRUE
    &FlgDB17 = TRUE
    &FlgDB18 = TRUE
    &FlgDB19 = "(IF x-CanalVenta = 'FER' THEN NO ELSE YES)"
    &FlgDB20 = TRUE
    &FlgDB30 = TRUE   /* SERVIDOR ATE */
    }
END.
*/
