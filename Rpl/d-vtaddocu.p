TRIGGER PROCEDURE FOR REPLICATION-DELETE OF vtaddocu.
/*
DEF VAR X-CanalVenta AS CHAR INIT "MIN" NO-UNDO.

FIND FIRST vtacdocu OF vtaddocu NO-LOCK NO-ERROR.
IF AVAILABLE vtacdocu THEN DO:
    FIND gn-divi WHERE gn-divi.codcia = vtacdocu.codcia AND 
        gn-divi.coddiv = vtacdocu.coddiv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN x-CanalVenta = gn-divi.CanalVenta.

    {rpl/reptrig.i
    &Table  = vtaddocu
    &Key    = "string(vtaddocu.codcia,'999') + ~
        string(vtaddocu.codped,'x(3)') + string(vtaddocu.nroped,'x(12)') + ~
        string(vtaddocu.codmat,'x(6)') + vtaddocu.almdes"
    &Prg    = r-vtaddocu
    &Event  = DELETE
    &FlgDB0 = NO
    &FlgDB1 = TRUE    /* Plaza Lima Norte 00501 */
    &FlgDB2 = TRUE    /* Surquillo 00023 */
    &FlgDB3 = TRUE    /* Chorrillos 00027 */
    &FlgDB4 = TRUE    /* San Borja 00502 */
    &FlgDB5 = TRUE    /* La Molina 00503 */
    &FlgDB6 = TRUE    /* Beneficiencia 00504 */
    &FlgDB7 = TRUE    /* Feria Plaza Norte 00505 */
    &FlgDB8 = TRUE    /* La Rambla 00507 */
    &FlgDB9 = TRUE    /* San Isidro 00508 */
    &FlgDB10 = TRUE   /* Chiclayo 00065 */
    &FlgDB11 = TRUE   /* Atocongo 00510 */
    &FlgDB12 = TRUE   /* Angamos 00511 */
    &FlgDB13 = TRUE   /* Salaverry 00512 */
    &FlgDB14 = TRUE   /* Centro Civico 00513 */
    &FlgDB15 = TRUE   /* Primavera 00514 */
    &FlgDB16 = TRUE
    &FlgDB17 = TRUE
    &FlgDB18 = "(IF LOOKUP(vtacdocu.divdes, '00060,00061,00062,00063,10060') > 0 THEN NO ELSE YES)"   /* AREQUIPA */
    &FlgDB19 = "(IF x-CanalVenta = 'FER' THEN NO ELSE YES)"
    &FlgDB20 = TRUE   /* SERVIDOR CENTRAL */
    &FlgDB30 = TRUE
    }
END.
*/
