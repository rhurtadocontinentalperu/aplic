DEF VAR pTask-No AS INT NO-UNDO.
DEF VAR pLlave-C AS CHAR INIT 'ADMIN' NO-UNDO.
DEF VAR s-codcia AS INT INIT 001 NO-UNDO.
DEF VAR pcodcli AS CHAR INIT '10166475762' NO-UNDO.
DEF VAR x-Cargos AS CHAR INIT 'LET,BOL,CHQ,FAC,TCK,N/D' NO-UNDO.
DEF VAR x-Abonos AS CHAR INIT 'N/C,A/R,BD,A/C' NO-UNDO.
DEF VAR pFechaH AS DATE NO-UNDO.
DEF VAR pFechaD AS DATE NO-UNDO.
DEF VAR pSaldoInicialSoles AS DEC NO-UNDO.
DEF VAR pSaldoInicialDolares AS DEC NO-UNDO.
DEF TEMP-TABLE t-report LIKE w-report.

ASSIGN
    pFechaD = 02/01/2014
    pFechaH = TODAY.

REPEAT:
    pTask-No = RANDOM(1,999999).
    IF NOT CAN-FIND(FIRST t-report WHERE t-report.task-no = pTask-No
                AND t-report.llave-c = pLlave-C
                NO-LOCK)
        THEN DO:
        CREATE t-report.
        ASSIGN
            t-report.task-no = pTask-No
            t-report.llave-c = pLlave-C
            t-report.Campo-C[1] = "*666*".
        LEAVE.
    END.
END.

/* ************************************************************************ */
/* ***************** 1ro Los Movimientos al Debe (Cargos) ***************** */
/* ************************************************************************ */
FOR EACH ccbcdocu NO-LOCK USE-INDEX Llave06 WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.codcli = pCodCli
    AND LOOKUP(ccbcdocu.coddoc, x-Cargos) > 0
    AND ccbcdocu.fchdoc >= 01/01/2010
    AND ccbcdocu.fchdoc <= pFechaH
    AND LOOKUP(ccbcdocu.flgest, 'A,X') = 0:
    IF ccbcdocu.flgest = "C" AND ccbcdocu.fchcan < pFechaD THEN NEXT.
    CREATE t-report.
    ASSIGN
        t-report.Task-No = pTask-No
        t-report.Llave-C = pLLave-C
        t-report.Campo-C[1] = "Debe"
        t-report.Llave-I = 1    /* Orden de Impresion */
        t-report.Campo-C[2] = ccbcdocu.coddiv
        t-report.Campo-C[3] = ccbcdocu.coddoc
        t-report.Campo-C[4] = ccbcdocu.nrodoc
        t-report.Campo-D[1] = ccbcdocu.fchdoc
        t-report.Campo-D[2] = ccbcdocu.fchvto
        t-report.Campo-I[1] = ccbcdocu.codmon
        t-report.Campo-F[1] = ccbcdocu.imptot /*+ ccbcdocu.imptot2*/  /* Importe + Anticipo Campaña */
        t-report.Campo-F[2] = ccbcdocu.imptot /*+ ccbcdocu.imptot2*/.  /* Saldo */
    /* Actualizamos los saldos a una fecha */
    IF t-report.Campo-D[1] < pFechaD THEN DO:
        FOR EACH ccbdcaja NO-LOCK WHERE ccbdcaja.codcia = s-codcia
            AND ccbdcaja.codref = t-report.Campo-C[3]
            AND ccbdcaja.nroref = t-report.Campo-C[4]
            AND ccbdcaja.fchdoc < pFechaD:
            t-report.Campo-F[1] = t-report.Campo-F[1] - ccbdcaja.imptot.
            t-report.Campo-F[2] = t-report.Campo-F[2] - ccbdcaja.imptot.
            /* CASO MUY ESPECIAL */
            IF ccbdcaja.coddoc = "A/C" AND ccbdcaja.nrodoc BEGINS "*" THEN DO:
                t-report.Campo-F[1] = t-report.Campo-F[1] - ccbdcaja.imptot.
                t-report.Campo-F[2] = t-report.Campo-F[2] - ccbdcaja.imptot.
            END.
        END.
        IF t-report.Campo-F[2] <= 0 THEN DELETE t-report.
    END.
END.
FOR EACH t-report WHERE t-report.Task-No = pTask-No
    AND t-report.Llave-C = pLLave-C
    AND t-report.Campo-C[1] = "*666*":
    DELETE t-report.
END.
ASSIGN
    pSaldoInicialSoles = 0
    pSaldoInicialDolares = 0.
FOR EACH t-report WHERE t-report.Campo-D[1] < pFechaD:
    IF t-report.Campo-I[1] = 1 THEN DO:
        IF t-report.Campo-C[1] = "Debe"
            THEN pSaldoInicialSoles = pSaldoInicialSoles + t-report.Campo-F[2].
            ELSE pSaldoInicialSoles = pSaldoInicialSoles - t-report.Campo-F[2].
    END.
    ELSE DO:
        IF t-report.Campo-C[1] = "Debe"
            THEN pSaldoInicialDolares = pSaldoInicialDolares + t-report.Campo-F[2].
            ELSE pSaldoInicialDolares = pSaldoInicialDolares - t-report.Campo-F[2].
    END.
/*     DISPLAY                       */
/*         campo-d[1]                */
/*         campo-c[3] FORMAT 'x(5)'  */
/*         campo-c[4] FORMAT 'x(15)' */
/*         campo-f[2].               */

END.
MESSAGE 'importes cargos' SKIP
    'soles' pSaldoInicialSoles SKIP
    'dolares' pSaldoInicialDolares.
/* RETURN.                                                                             */
/* ************************************************************************ */
/* ************* 2ro Los Movimientos al Haber (Abonos) ******************** */
/* ************************************************************************ */
FOR EACH ccbcdocu NO-LOCK USE-INDEX Llave06 WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.codcli = pCodCli
    AND LOOKUP(ccbcdocu.coddoc, x-Abonos) > 0
    AND ccbcdocu.fchdoc >= 01/01/2010
    AND ccbcdocu.fchdoc <= pFechaH
    AND LOOKUP(ccbcdocu.flgest, 'A,X') = 0:
    IF ccbcdocu.flgest = "C" AND ccbcdocu.fchcan < pFechaD THEN NEXT.
    CREATE t-report.
    ASSIGN
        t-report.Task-No = pTask-No
        t-report.Llave-C = pLLave-C
        t-report.Campo-C[1] = "Haber"
        t-report.Llave-I = 2    /* Orden de Impresion */
        t-report.Campo-C[2] = ccbcdocu.coddiv
        t-report.Campo-C[3] = ccbcdocu.coddoc
        t-report.Campo-C[4] = ccbcdocu.nrodoc
        t-report.Campo-D[1] = ccbcdocu.fchdoc
        t-report.Campo-D[2] = ccbcdocu.fchvto
        t-report.Campo-I[1] = ccbcdocu.codmon
        t-report.Campo-F[1] = ccbcdocu.imptot   /* Importe */
        t-report.Campo-F[2] = ccbcdocu.imptot.  /* Saldo */
    /* Actualizamos los saldos de los Abonos */
    FOR EACH CCBDMOV NO-LOCK USE-INDEX Llave03 WHERE CCBDMOV.CodCia = s-CodCia
        AND CCBDMOV.CodDoc = t-report.Campo-C[3]
        AND CCBDMOV.NroDoc = t-report.Campo-C[4] 
        AND CCBDMOV.FchMov <= pFechaH:
        t-report.Campo-F[1] = t-report.Campo-F[1] - ccbdmov.imptot.
        t-report.Campo-F[2] = t-report.Campo-F[2] - ccbdmov.imptot.
    END.
    /*IF t-report.Campo-F[2] <= 0 THEN DELETE t-report.*/
END.
ASSIGN
    pSaldoInicialSoles = 0
    pSaldoInicialDolares = 0.
FOR EACH t-report WHERE t-report.Campo-D[1] < pFechaD AND t-report.Campo-C[1] = "Haber":
    IF t-report.Campo-I[1] = 1 THEN DO:
        IF t-report.Campo-C[1] = "Debe" 
            THEN pSaldoInicialSoles = pSaldoInicialSoles + t-report.Campo-F[2].
            ELSE pSaldoInicialSoles = pSaldoInicialSoles - t-report.Campo-F[2].
    END.
    ELSE DO:
        IF t-report.Campo-C[1] = "Debe" 
            THEN pSaldoInicialDolares = pSaldoInicialDolares + t-report.Campo-F[2].
            ELSE pSaldoInicialDolares = pSaldoInicialDolares - t-report.Campo-F[2].
    END.
    DISPLAY 
        campo-d[1]
        campo-c[3] FORMAT 'x(5)'
        campo-c[4] FORMAT 'x(15)'
        campo-f[2].
END.
MESSAGE 'importes abonos' SKIP
    'soles' pSaldoInicialSoles SKIP
    'dolares' pSaldoInicialDolares.
RETURN.
/* ************************************************************************ */
/* **************************** Saldo Inicial ***************************** */
/* ************************************************************************ */
ASSIGN
    pSaldoInicialSoles = 0
    pSaldoInicialDolares = 0.
FOR EACH t-report WHERE t-report.Task-No = pTask-No
    AND t-report.Llave-C = pLLave-C
    AND t-report.Campo-D[1] < pFechaD:
    IF t-report.Campo-I[1] = 1 THEN DO:
        IF t-report.Campo-C[1] = "Debe" 
            THEN pSaldoInicialSoles = pSaldoInicialSoles + t-report.Campo-F[2].
            ELSE pSaldoInicialSoles = pSaldoInicialSoles - t-report.Campo-F[2].
    END.
    ELSE DO:
        IF t-report.Campo-C[1] = "Debe" 
            THEN pSaldoInicialDolares = pSaldoInicialDolares + t-report.Campo-F[2].
            ELSE pSaldoInicialDolares = pSaldoInicialDolares - t-report.Campo-F[2].
    END.
    t-report.Campo-C[5] = "NO".     /* NO se imprime en el reporte */
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

DO k = 1 TO NUM-ENTRIES(x-Cargos):
    x-CodDoc = ENTRY(k, x-Cargos).
    FOR EACH ccbdcaja NO-LOCK WHERE ccbdcaja.codcia = s-codcia
        AND ccbdcaja.codref = x-CodDoc
        AND ccbdcaja.codcli = pCodCli
        /*AND ccbdcaja.fchdoc >= 01/01/2011*/
        AND ccbdcaja.fchdoc >= pFechaD
        AND ccbdcaja.fchdoc <= pFechaH:
        FIND t-report WHERE t-report.Task-No = pTask-No
            AND t-report.Llave-C = pLLave-C
            AND t-report.Campo-C[1] = "Haber"
            AND t-report.Llave-I    = 3     /* OJO */
            AND t-report.Campo-C[3] = ccbdcaja.coddoc
            AND t-report.Campo-C[4] = ccbdcaja.nrodoc
            AND t-report.Campo-I[1] = ccbdcaja.codmon
            NO-ERROR.
        IF NOT AVAILABLE t-report THEN CREATE t-report.
        ASSIGN
            t-report.Task-No = pTask-No
            t-report.Llave-C = pLLave-C
            t-report.Campo-C[1] = "Haber"
            t-report.Llave-I = 3    /* Orden de Impresion */
            t-report.Campo-C[2] = ccbdcaja.coddiv
            t-report.Campo-C[3] = ccbdcaja.coddoc
            t-report.Campo-C[4] = ccbdcaja.nrodoc
            t-report.Campo-D[1] = ccbdcaja.fchdoc
            t-report.Campo-I[1] = ccbdcaja.codmon
            t-report.Campo-F[1] = t-report.Campo-F[1] + ccbdcaja.imptot.
    END.
END.
