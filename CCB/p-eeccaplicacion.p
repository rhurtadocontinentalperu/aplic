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

/* Cargamos cancelaciones detalladas */
DEF VAR x-CodDoc AS CHAR NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DEF VAR x-Factor AS INT NO-UNDO.

FOR EACH ccbdcaja USE-INDEX Llave03 NO-LOCK WHERE ccbdcaja.codcia = s-codcia
    AND LOOKUP(ccbdcaja.codref, x-Cargos) > 0
    AND ccbdcaja.codcli = pCodCli
    AND ccbdcaja.fchdoc >= pFechaD
    AND ccbdcaja.fchdoc <= pFechaH
    BREAK BY ccbdcaja.coddoc BY ccbdcaja.nrodoc:
    CREATE w-report.
    ASSIGN
        w-report.Task-No = pTask-No
        w-report.Llave-C = pLLave-C
        w-report.Campo-C[1] = ccbdcaja.coddiv
        w-report.Campo-C[2] = ccbdcaja.coddoc
        w-report.Campo-C[3] = ccbdcaja.nrodoc
        w-report.Campo-C[4] = ccbdcaja.codref
        w-report.Campo-C[5] = ccbdcaja.nroref
        w-report.Campo-D[1] = ccbdcaja.fchdoc
        w-report.Campo-I[1] = ccbdcaja.codmon.
    x-Factor = (IF ccbdcaja.coddoc = "CJE" THEN -1 ELSE 1).
    IF ccbdcaja.codmon = 1 
        THEN ASSIGN w-report.Campo-F[1] = (ccbdcaja.imptot * x-Factor).
        ELSE ASSIGN w-report.Campo-F[2] = (ccbdcaja.imptot * x-Factor).
    /* Veamos si es un CJE */
    IF LAST-OF(ccbdcaja.coddoc) OR LAST-OF(ccbdcaja.nrodoc) THEN DO:
        IF ccbdcaja.coddoc = "CJE" THEN DO:
            x-Factor = 1.
            FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
                AND ccbcdocu.coddoc = "LET"
                AND ccbcdocu.codref = ccbdcaja.coddoc
                AND ccbcdocu.nroref = ccbdcaja.nrodoc:
                CREATE w-report.
                ASSIGN
                    w-report.Task-No = pTask-No
                    w-report.Llave-C = pLLave-C
                    w-report.Campo-C[1] = ccbdcaja.coddiv
                    w-report.Campo-C[2] = ccbdcaja.coddoc
                    w-report.Campo-C[3] = ccbdcaja.nrodoc
                    w-report.Campo-C[4] = ccbcdocu.coddoc
                    w-report.Campo-C[5] = ccbcdocu.nrodoc
                    w-report.Campo-D[1] = ccbdcaja.fchdoc
                    w-report.Campo-I[1] = ccbcdocu.codmon.
                IF ccbcdocu.codmon = 1 
                    THEN ASSIGN w-report.Campo-F[1] = (ccbcdocu.imptot * x-Factor).
                    ELSE ASSIGN w-report.Campo-F[2] = (ccbcdocu.imptot * x-Factor).
            END.
        END.
    END.
END.

/* DO k = 1 TO NUM-ENTRIES(x-Cargos):                                                      */
/*     x-CodDoc = ENTRY(k, x-Cargos).                                                      */
/*     FOR EACH ccbdcaja NO-LOCK WHERE ccbdcaja.codcia = s-codcia                          */
/*         AND ccbdcaja.codref = x-CodDoc                                                  */
/*         AND ccbdcaja.codcli = pCodCli                                                   */
/*         AND ccbdcaja.fchdoc >= pFechaD                                                  */
/*         AND ccbdcaja.fchdoc <= pFechaH                                                  */
/*         BREAK BY ccbdcaja.coddoc BY ccbdcaja.nrodoc:                                    */
/*         CREATE w-report.                                                                */
/*         ASSIGN                                                                          */
/*             w-report.Task-No = pTask-No                                                 */
/*             w-report.Llave-C = pLLave-C                                                 */
/*             w-report.Campo-C[1] = ccbdcaja.coddiv                                       */
/*             w-report.Campo-C[2] = ccbdcaja.coddoc                                       */
/*             w-report.Campo-C[3] = ccbdcaja.nrodoc                                       */
/*             w-report.Campo-C[4] = ccbdcaja.codref                                       */
/*             w-report.Campo-C[5] = ccbdcaja.nroref                                       */
/*             w-report.Campo-D[1] = ccbdcaja.fchdoc                                       */
/*             w-report.Campo-I[1] = ccbdcaja.codmon.                                      */
/*         x-Factor = (IF ccbdcaja.coddoc = "CJE" THEN -1 ELSE 1).                         */
/*         IF ccbdcaja.codmon = 1                                                          */
/*             THEN ASSIGN w-report.Campo-F[1] = (ccbdcaja.imptot * x-Factor).             */
/*             ELSE ASSIGN w-report.Campo-F[2] = (ccbdcaja.imptot * x-Factor).             */
/*         /* Veamos si es un CJE */                                                       */
/*         IF LAST-OF(ccbdcaja.coddoc) OR LAST-OF(ccbdcaja.nrodoc) THEN DO:                */
/*             IF ccbdcaja.coddoc = "CJE" THEN DO:                                         */
/*                 x-Factor = 1.                                                           */
/*                 FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia              */
/*                     AND ccbcdocu.coddoc = "LET"                                         */
/*                     AND ccbcdocu.codref = ccbdcaja.coddoc                               */
/*                     AND ccbcdocu.nroref = ccbdcaja.nrodoc:                              */
/*                     CREATE w-report.                                                    */
/*                     ASSIGN                                                              */
/*                         w-report.Task-No = pTask-No                                     */
/*                         w-report.Llave-C = pLLave-C                                     */
/*                         w-report.Campo-C[1] = ccbdcaja.coddiv                           */
/*                         w-report.Campo-C[2] = ccbdcaja.coddoc                           */
/*                         w-report.Campo-C[3] = ccbdcaja.nrodoc                           */
/*                         w-report.Campo-C[4] = ccbcdocu.coddoc                           */
/*                         w-report.Campo-C[5] = ccbcdocu.nrodoc                           */
/*                         w-report.Campo-D[1] = ccbdcaja.fchdoc                           */
/*                         w-report.Campo-I[1] = ccbcdocu.codmon.                          */
/*                     IF ccbcdocu.codmon = 1                                              */
/*                         THEN ASSIGN w-report.Campo-F[1] = (ccbcdocu.imptot * x-Factor). */
/*                         ELSE ASSIGN w-report.Campo-F[2] = (ccbcdocu.imptot * x-Factor). */
/*                 END.                                                                    */
/*             END.                                                                        */
/*         END.                                                                            */
/*     END.                                                                                */
/* END.                                                                                    */
FOR EACH w-report WHERE w-report.Task-No = pTask-No
    AND w-report.Llave-C = pLLave-C
    AND w-report.Campo-C[1] = "*666*":
    DELETE w-report.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


