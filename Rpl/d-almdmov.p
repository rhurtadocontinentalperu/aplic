TRIGGER PROCEDURE FOR REPLICATION-DELETE OF almdmov.
/*
    FIND almacen WHERE almacen.codcia = almdmov.codcia
        AND almacen.codalm = almdmov.codalm NO-LOCK NO-ERROR.
    IF AVAILABLE almacen THEN DO:
    {rpl/reptrig.i
    &Table  = almdmov
    &Key    =  "string(almdmov.codcia,'999') + string(almdmov.codalm,'x(5)') + ~
        string(almdmov.tipmov,'x(1)') + string(almdmov.codmov,'99') + ~
        string(almdmov.nroser, '999') + string(almdmov.nrodoc, '999999999') + ~
        string(almdmov.codmat, 'x(6)')"
    &Prg    = r-almdmov
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
    &FlgDB18 = "NOT LOOKUP(almacen.coddiv,'00060,00061,00062,00063,10060') > 0"     /* AREQUIPA */
    &FlgDB19 = "NOT LOOKUP(almacen.coddiv,'00069') > 0"   /* TRUJILLO */
    &FlgDB20 = TRUE   /* SERVIDOR CENTRAL */
    &FlgDB30 = TRUE
    }
    END.
*/
