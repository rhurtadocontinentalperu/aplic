TRIGGER PROCEDURE FOR REPLICATION-DELETE OF faccpedi.

/*
    DEF VAR lDivisiones AS CHAR NO-UNDO.

    DEF VAR X-CanalVenta AS CHAR INIT "MIN" NO-UNDO.
    FIND gn-divi WHERE gn-divi.codcia = faccpedi.codcia AND gn-divi.coddiv = faccpedi.coddiv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN x-CanalVenta = gn-divi.CanalVenta.

    /*IF LOOKUP(Faccpedi.CodDoc, 'COT,PED,O/D,P/M,OTR,ODC,O/M') > 0 THEN DO:*/
        {rpl/reptrig.i
        &Table  = faccpedi
        &Key    = "string(faccpedi.codcia,'999') + string(faccpedi.coddiv,'x(5)') + ~
            string(faccpedi.coddoc,'x(3)') + faccpedi.nroped"
        &Prg    = r-faccpedi
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
        &FlgDB18 = TRUE   /* AREQUIPA */
        &FlgDB19 = TRUE     /*"(IF x-CanalVenta = 'FER' THEN NO ELSE YES)"*/
        &FlgDB20 = TRUE   /* SERVIDOR CENTRAL */
        &FlgDB30 = TRUE
        }
    /*END.*/

*/
