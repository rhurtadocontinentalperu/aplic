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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.

pTask-No = 0.

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


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fSituacion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSituacion Procedure 
FUNCTION fSituacion RETURNS CHARACTER
  ( INPUT cFlgSit AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fUbicacion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fUbicacion Procedure 
FUNCTION fUbicacion RETURNS CHARACTER
  ( INPUT cFlgUbi AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 5.15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

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
DEF VAR x-Factor AS INT NO-UNDO.
FOR EACH ccbcdocu NO-LOCK USE-INDEX llave06 WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.codcli = pCodCli
    AND LOOKUP(ccbcdocu.coddoc, x-Cargos) > 0
    AND ccbcdocu.fchdoc >= 01/01/2010
    AND ccbcdocu.fchdoc <= pFechaH
    AND LOOKUP(ccbcdocu.flgest, 'A,X') = 0:
    IF ccbcdocu.flgest = "C" AND ccbcdocu.fchcan < pFechaD THEN NEXT.
    x-Factor = 1.
    CREATE w-report.
    ASSIGN
        w-report.Task-No = pTask-No
        w-report.Llave-C = pLLave-C
        w-report.Campo-C[1] = "Debe"
        w-report.Campo-C[2] = ccbcdocu.coddiv
        w-report.Campo-C[3] = ccbcdocu.coddoc
        w-report.Campo-C[4] = ccbcdocu.nrodoc
        w-report.Campo-D[1] = ccbcdocu.fchdoc
        w-report.Campo-D[2] = ccbcdocu.fchvto
        w-report.Campo-I[1] = ccbcdocu.codmon.
    IF ccbcdocu.coddoc = "LET" THEN
        ASSIGN
        w-report.Campo-C[5] = fUbicacion( ccbcdocu.flgubi )
        w-report.Campo-C[6] = fSituacion( ccbcdocu.flgsit )
        w-report.Campo-C[7] = ccbcdocu.nrosal
        w-report.Campo-C[8] = ccbcdocu.codcta.
    ASSIGN 
        w-report.Campo-F[1] = ccbcdocu.imptot * x-Factor
        w-report.Campo-F[2] = ccbcdocu.imptot * x-Factor.
    /* Actualizamos los saldos a una fecha */
    FOR EACH ccbdcaja NO-LOCK WHERE ccbdcaja.codcia = s-codcia
        AND ccbdcaja.codref = w-report.Campo-C[3]
        AND ccbdcaja.nroref = w-report.Campo-C[4]
        AND ccbdcaja.fchdoc <= pFechaH
        BY ccbdcaja.fchdoc:
        w-report.Campo-F[2] = w-report.Campo-F[2] - ccbdcaja.imptot.
        w-report.Campo-D[3] = ccbdcaja.fchdoc.
        /* CASO MUY ESPECIAL */
        IF ccbdcaja.coddoc = "A/C" AND ccbdcaja.nrodoc BEGINS "*" THEN DO:
            w-report.Campo-F[2] = w-report.Campo-F[2] - (ccbdcaja.imptot * x-Factor).
        END.
    END.
    IF w-report.Campo-F[2] <= 0 /*AND w-report.Campo-D[3] < pFechaD*/ THEN DELETE w-report.
END.
FOR EACH w-report WHERE w-report.Task-No = pTask-No
    AND w-report.Llave-C = pLLave-C
    AND w-report.Campo-C[1] = "*666*":
    DELETE w-report.
END.
/* ************************************************************************ */
/* ************* 2ro Los Movimientos al Haber (Abonos) ******************** */
/* ************************************************************************ */
FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.codcli = pCodCli
    AND LOOKUP(ccbcdocu.coddoc, x-Abonos) > 0
    AND ccbcdocu.fchdoc >= 01/01/2010
    AND ccbcdocu.fchdoc <= pFechaH
    AND LOOKUP(ccbcdocu.flgest, 'A,X') = 0:
    IF ccbcdocu.flgest = "C" AND ccbcdocu.fchcan < pFechaD THEN NEXT.
    x-Factor = -1.
    CREATE w-report.
    ASSIGN
        w-report.Task-No = pTask-No
        w-report.Llave-C = pLLave-C
        w-report.Campo-C[1] = "Haber"
        w-report.Campo-C[2] = ccbcdocu.coddiv
        w-report.Campo-C[3] = ccbcdocu.coddoc
        w-report.Campo-C[4] = ccbcdocu.nrodoc
        w-report.Campo-D[1] = ccbcdocu.fchdoc
        w-report.Campo-D[2] = ccbcdocu.fchvto
        w-report.Campo-I[1] = ccbcdocu.codmon.
    ASSIGN 
        w-report.Campo-F[1] = ccbcdocu.imptot * x-Factor
        w-report.Campo-F[2] = ccbcdocu.imptot * x-Factor.
    FOR EACH CCBDMOV NO-LOCK WHERE CCBDMOV.CodCia = s-CodCia
        AND CCBDMOV.CodDoc = w-report.Campo-C[3]
        AND CCBDMOV.NroDoc = w-report.Campo-C[4] 
        AND CCBDMOV.FchMov <= pFechaH
        BY CCBDMOV.FchMov:
        w-report.Campo-F[2] = w-report.Campo-F[2] - (ccbdmov.imptot * x-Factor).
        w-report.Campo-D[3] = CCBDMOV.FchMov.
    END.
    IF w-report.Campo-F[2] >= 0 /*AND w-report.Campo-D[3] < pFechaD*/ THEN DELETE w-report.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fSituacion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSituacion Procedure 
FUNCTION fSituacion RETURNS CHARACTER
  ( INPUT cFlgSit AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE cflgsit:
    WHEN 'T' THEN RETURN 'Transito'.
    WHEN 'C' THEN RETURN 'Cobranza Libre'.
    WHEN 'G' THEN RETURN 'Cobranza Garantia'.
    WHEN 'D' THEN RETURN 'Descuento'.
    WHEN 'P' THEN RETURN 'Protestada'.
  END CASE.
  RETURN cflgsit.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fUbicacion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fUbicacion Procedure 
FUNCTION fUbicacion RETURNS CHARACTER
  ( INPUT cFlgUbi AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE cflgubi:
    WHEN 'C' THEN RETURN 'Cartera'.
    WHEN 'B' THEN RETURN 'Banco'.
  END CASE.
  RETURN cflgubi.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

