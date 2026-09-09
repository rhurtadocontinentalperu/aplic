&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pLlave-C AS CHAR.
DEF INPUT PARAMETER pFechaD AS DATE.
DEF INPUT PARAMETER pFechaH AS DATE.
DEF OUTPUT PARAMETER pTask-No AS INT.
DEF OUTPUT PARAMETER pSaldoInicialSoles AS DEC.
DEF OUTPUT PARAMETER pSaldoInicialDolares AS DEC.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.

pTask-No = 0.
pSaldoInicialSoles = 0.
pSaldoInicialDolares = 0.

DEF VAR x-Cargos AS CHAR INIT 'LET,BOL,CHQ,FAC,TCK,N/D' NO-UNDO.
DEF VAR x-Abonos AS CHAR INIT 'N/C,A/R,BD,A/C' NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 3.81
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE BUFFER b-report FOR w-report.
REPEAT:
    pTask-No = RANDOM(1,999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = pTask-No
                AND w-report.llave-c = pLlave-C
                NO-LOCK)
        THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.task-no = pTask-No
            w-report.llave-c = pLlave-C
            w-report.Campo-C[1] = "*666*".
        LEAVE.
    END.
END.

/* ************************************************************************ */
/* ***************** 1ro Los Movimientos al Debe (Cargos) ***************** */
/* ************************************************************************ */
FOR EACH ccbcdocu NO-LOCK USE-INDEX Llave06 WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.codcli = pCodCli
    AND LOOKUP(ccbcdocu.flgest, 'A,X') = 0:
    /* FILTROS */
    IF NOT LOOKUP(ccbcdocu.coddoc, x-Cargos) > 0 THEN NEXT.
    IF NOT (ccbcdocu.fchdoc >= 01/01/2010 AND ccbcdocu.fchdoc <= pFechaH) THEN NEXT.
    IF ccbcdocu.flgest = "C" AND ccbcdocu.fchcan < pFechaD THEN NEXT.
    CREATE w-report.
    ASSIGN
        w-report.Task-No = pTask-No
        w-report.Llave-C = pLLave-C
        w-report.Campo-C[1] = "Debe"
        w-report.Llave-I = 1    /* Orden de Impresion */
        w-report.Campo-C[2] = ccbcdocu.coddiv
        w-report.Campo-C[3] = ccbcdocu.coddoc
        w-report.Campo-C[4] = ccbcdocu.nrodoc
        w-report.Campo-D[1] = ccbcdocu.fchdoc
        w-report.Campo-D[2] = ccbcdocu.fchvto
        w-report.Campo-I[1] = ccbcdocu.codmon
        w-report.Campo-F[1] = ccbcdocu.imptot /*+ ccbcdocu.imptot2*/  /* Importe + Anticipo Campaña */
        w-report.Campo-F[2] = ccbcdocu.imptot /*+ ccbcdocu.imptot2*/.  /* Saldo */
    /* Actualizamos los saldos a una fecha */
    IF w-report.Campo-D[1] < pFechaD THEN DO:
        FOR EACH ccbdcaja NO-LOCK WHERE ccbdcaja.codcia = s-codcia
            AND ccbdcaja.codref = w-report.Campo-C[3]
            AND ccbdcaja.nroref = w-report.Campo-C[4]
            AND ccbdcaja.fchdoc < pFechaD:
            w-report.Campo-F[1] = w-report.Campo-F[1] - ccbdcaja.imptot.
            w-report.Campo-F[2] = w-report.Campo-F[2] - ccbdcaja.imptot.
            /* CASO MUY ESPECIAL */
            IF ccbdcaja.coddoc = "A/C" AND ccbdcaja.nrodoc BEGINS "*" THEN DO:
                w-report.Campo-F[1] = w-report.Campo-F[1] - ccbdcaja.imptot.
                w-report.Campo-F[2] = w-report.Campo-F[2] - ccbdcaja.imptot.
            END.
        END.
        IF w-report.Campo-F[2] <= 0 THEN DELETE w-report.
    END.
END.
FOR EACH w-report WHERE w-report.Task-No = pTask-No
    AND w-report.Llave-C = pLLave-C
    AND w-report.Campo-C[1] = "*666*":
    DELETE w-report.
END.
/* ************************************************************************ */
/* ************* 2ro Los Movimientos al Haber (Abonos) ******************** */
/* ************************************************************************ */
FOR EACH ccbcdocu NO-LOCK USE-INDEX Llave06 WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.codcli = pCodCli
    AND LOOKUP(ccbcdocu.flgest, 'A,X') = 0:
    /* FILTROS */
    IF NOT LOOKUP(ccbcdocu.coddoc, x-Abonos) > 0 THEN NEXT.
    IF NOT (ccbcdocu.fchdoc >= 01/01/2010 AND ccbcdocu.fchdoc <= pFechaH) THEN NEXT.
    IF ccbcdocu.flgest = "C" AND ccbcdocu.fchcan < pFechaD THEN NEXT.
    CREATE w-report.
    ASSIGN
        w-report.Task-No = pTask-No
        w-report.Llave-C = pLLave-C
        w-report.Campo-C[1] = "Haber"
        w-report.Llave-I = 2    /* Orden de Impresion */
        w-report.Campo-C[2] = ccbcdocu.coddiv
        w-report.Campo-C[3] = ccbcdocu.coddoc
        w-report.Campo-C[4] = ccbcdocu.nrodoc
        w-report.Campo-D[1] = ccbcdocu.fchdoc
        w-report.Campo-D[2] = ccbcdocu.fchvto
        w-report.Campo-I[1] = ccbcdocu.codmon
        w-report.Campo-F[1] = ccbcdocu.imptot   /* Importe */
        w-report.Campo-F[2] = ccbcdocu.imptot.  /* Saldo */
    /* Actualizamos los saldos de los Abonos */
    FOR EACH CCBDMOV NO-LOCK USE-INDEX Llave03 WHERE CCBDMOV.CodCia = s-CodCia
        AND CCBDMOV.CodDoc = w-report.Campo-C[3]
        AND CCBDMOV.NroDoc = w-report.Campo-C[4] 
        AND CCBDMOV.FchMov <= pFechaH:
        w-report.Campo-F[1] = w-report.Campo-F[1] - ccbdmov.imptot.
        w-report.Campo-F[2] = w-report.Campo-F[2] - ccbdmov.imptot.
    END.
    IF w-report.Campo-F[2] <= 0 THEN DELETE w-report.
END.
/* ************************************************************************ */
/* **************************** Saldo Inicial ***************************** */
/* ************************************************************************ */
ASSIGN
    pSaldoInicialSoles = 0
    pSaldoInicialDolares = 0.
FOR EACH w-report WHERE w-report.Task-No = pTask-No
    AND w-report.Llave-C = pLLave-C
    AND w-report.Campo-D[1] < pFechaD:
    IF w-report.Campo-I[1] = 1 THEN DO:
        IF w-report.Campo-C[1] = "Debe" 
            THEN pSaldoInicialSoles = pSaldoInicialSoles + w-report.Campo-F[2].
            ELSE pSaldoInicialSoles = pSaldoInicialSoles - w-report.Campo-F[2].
    END.
    ELSE DO:
        IF w-report.Campo-C[1] = "Debe" 
            THEN pSaldoInicialDolares = pSaldoInicialDolares + w-report.Campo-F[2].
            ELSE pSaldoInicialDolares = pSaldoInicialDolares - w-report.Campo-F[2].
    END.
    w-report.Campo-C[5] = "NO".     /* NO se imprime en el reporte */
END.
/* Saldos antes del 01/01/2011 */
/*
FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.codcli = pCodCli
    AND LOOKUP(ccbcdocu.coddoc, x-Cargos) > 0
    AND ccbcdocu.flgest = "P"
    AND ccbcdocu.fchdoc < 01/01/2011:
    IF ccbcdocu.codmon = 1 THEN pSaldoInicialSoles = pSaldoInicialSoles + ccbcdocu.sdoact.
    ELSE pSaldoInicialDolares = pSaldoInicialDolares + ccbcdocu.sdoact.
END.
FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.codcli = pCodCli
    AND LOOKUP(ccbcdocu.coddoc, x-Abonos) > 0
    AND ccbcdocu.flgest = "P"
    AND ccbcdocu.fchdoc < 01/01/2011:
    IF ccbcdocu.codmon = 1 THEN pSaldoInicialSoles = pSaldoInicialSoles - ccbcdocu.sdoact.
    ELSE pSaldoInicialDolares = pSaldoInicialDolares - ccbcdocu.sdoact.
END.
*/
/* ************************************************************************ */
/* *************** 3ro Cargamos cancelaciones resumidas ******************* */
/* ************************************************************************ */
DEF VAR x-CodDoc AS CHAR NO-UNDO.
DEF VAR k AS INT NO-UNDO.

FOR EACH Ccbdcaja USE-INDEX Llave03 NO-LOCK WHERE ccbdcaja.codcia = s-codcia
    AND ccbdcaja.codcli = pCodCli
    AND ccbdcaja.fchdoc >= pFechaD
    AND ccbdcaja.fchdoc <= pFechaH:
    IF NOT LOOKUP(ccbdcaja.codref, x-Cargos) > 0 THEN NEXT.
    FIND w-report WHERE w-report.Task-No = pTask-No
        AND w-report.Llave-C = pLLave-C
        AND w-report.Campo-C[1] = "Haber"
        AND w-report.Llave-I    = 3     /* OJO */
        AND w-report.Campo-C[3] = ccbdcaja.coddoc
        AND w-report.Campo-C[4] = ccbdcaja.nrodoc
        AND w-report.Campo-I[1] = ccbdcaja.codmon
        NO-ERROR.
    IF NOT AVAILABLE w-report THEN CREATE w-report.
    ASSIGN
        w-report.Task-No = pTask-No
        w-report.Llave-C = pLLave-C
        w-report.Campo-C[1] = "Haber"
        w-report.Llave-I = 3    /* Orden de Impresion */
        w-report.Campo-C[2] = ccbdcaja.coddiv
        w-report.Campo-C[3] = ccbdcaja.coddoc
        w-report.Campo-C[4] = ccbdcaja.nrodoc
        w-report.Campo-D[1] = ccbdcaja.fchdoc
        w-report.Campo-I[1] = ccbdcaja.codmon
        w-report.Campo-F[1] = w-report.Campo-F[1] + ccbdcaja.imptot.
END.
/* DO k = 1 TO NUM-ENTRIES(x-Cargos):                                       */
/*     x-CodDoc = ENTRY(k, x-Cargos).                                       */
/*     FOR EACH ccbdcaja NO-LOCK WHERE ccbdcaja.codcia = s-codcia           */
/*         AND ccbdcaja.codref = x-CodDoc                                   */
/*         AND ccbdcaja.codcli = pCodCli                                    */
/*         AND ccbdcaja.fchdoc >= pFechaD                                   */
/*         AND ccbdcaja.fchdoc <= pFechaH:                                  */
/*         FIND w-report WHERE w-report.Task-No = pTask-No                  */
/*             AND w-report.Llave-C = pLLave-C                              */
/*             AND w-report.Campo-C[1] = "Haber"                            */
/*             AND w-report.Llave-I    = 3     /* OJO */                    */
/*             AND w-report.Campo-C[3] = ccbdcaja.coddoc                    */
/*             AND w-report.Campo-C[4] = ccbdcaja.nrodoc                    */
/*             AND w-report.Campo-I[1] = ccbdcaja.codmon                    */
/*             NO-ERROR.                                                    */
/*         IF NOT AVAILABLE w-report THEN CREATE w-report.                  */
/*         ASSIGN                                                           */
/*             w-report.Task-No = pTask-No                                  */
/*             w-report.Llave-C = pLLave-C                                  */
/*             w-report.Campo-C[1] = "Haber"                                */
/*             w-report.Llave-I = 3    /* Orden de Impresion */             */
/*             w-report.Campo-C[2] = ccbdcaja.coddiv                        */
/*             w-report.Campo-C[3] = ccbdcaja.coddoc                        */
/*             w-report.Campo-C[4] = ccbdcaja.nrodoc                        */
/*             w-report.Campo-D[1] = ccbdcaja.fchdoc                        */
/*             w-report.Campo-I[1] = ccbdcaja.codmon                        */
/*             w-report.Campo-F[1] = w-report.Campo-F[1] + ccbdcaja.imptot. */
/*     END.                                                                 */
/* END.                                                                     */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


