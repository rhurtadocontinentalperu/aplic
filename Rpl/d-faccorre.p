TRIGGER PROCEDURE FOR REPLICATION-DELETE OF faccorre.

/*
DEF VAR X-CanalVenta AS CHAR INIT "MIN" NO-UNDO.

FIND gn-divi WHERE gn-divi.codcia = faccorre.codcia AND gn-divi.coddiv = faccorre.coddiv NO-LOCK NO-ERROR.
IF AVAILABLE gn-divi THEN x-CanalVenta = gn-divi.CanalVenta.

{rpl/reptrig.i
    &Table  = faccorre
    &Key    =  "string(faccorre.codcia,'999') + string(faccorre.coddoc,'x(3)') ~
        + string(faccorre.nroser,'999')"
    &Prg    = r-faccorre
    &Event  = DELETE
    &FlgDB0 = NO
    &FlgDB1 = YES   /* EXPO-ENERO NO REPLICA */
    &FlgDB2 = "NOT LOOKUP(faccorre.coddiv,'00023') > 0"
    &FlgDB3 = "NOT LOOKUP(faccorre.coddiv,'00027') > 0"
    &FlgDB4 = "NOT LOOKUP(faccorre.coddiv,'00502') > 0"
    &FlgDB5 = "NOT LOOKUP(faccorre.coddiv,'00503') > 0"
    &FlgDB6 = "NOT LOOKUP(faccorre.coddiv,'00504') > 0"
    &FlgDB7 = "NOT LOOKUP(faccorre.coddiv,'00505') > 0"
    &FlgDB8 = "NOT LOOKUP(faccorre.coddiv,'00507') > 0"
    &FlgDB9 = "NOT LOOKUP(faccorre.coddiv,'00508') > 0"
    &FlgDB10 = "NOT LOOKUP(faccorre.coddiv,'00065') > 0"
    &FlgDB11 = "NOT LOOKUP(faccorre.coddiv,'00510') > 0"
    &FlgDB12 = "NOT LOOKUP(faccorre.coddiv,'00511') > 0"
    &FlgDB13 = "NOT LOOKUP(faccorre.coddiv,'00512') > 0"
    &FlgDB14 = "NOT LOOKUP(faccorre.coddiv,'00513') > 0"
    &FlgDB15 = "NOT LOOKUP(faccorre.coddiv,'00514') > 0"
    &FlgDB16 = "NOT LOOKUP(faccorre.coddiv,'00516') > 0"    /* BELLAVISTA */
    &FlgDB17 = "NOT x-CanalVenta = 'MIN'"
    &FlgDB18 = "NOT LOOKUP(faccorre.coddiv,'00060,00061,00062,00063,10060') > 0"     /* AREQUIPA */
    &FlgDB19 = "(IF x-CanalVenta = 'FER' THEN NO ELSE YES)"
    &FlgDB20 = "NOT x-CanalVenta = 'MIN'"   /*"NOT LOOKUP(faccorre.coddiv, '00023,00027,00501,00502,00503,00510') > 0"    /* SERVIDOR UTILEX */*/
    &FlgDB30 = TRUE
}
*/
