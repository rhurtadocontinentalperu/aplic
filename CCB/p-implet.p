&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : p-implet.p
    Purpose     : Impresion de Letras

    Syntax      :

    Description :

    Author(s)   : Miguel Landeo
    Created     : 12/Oct/2007
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
/* ***************************  Definitions  ************************** */

DEFINE INPUT PARAMETER para_RowID AS ROWID.

DEFINE SHARED VARIABLE s-user-id AS CHAR.
DEFINE SHARED VARIABLE cl-codcia AS INT.

DEFINE VARIABLE cNroRef AS CHAR NO-UNDO.
DEFINE VARIABLE cImpLetras AS CHAR FORMAT "x(60)" NO-UNDO.
DEFINE VARIABLE s-task-no AS INT INITIAL 0 NO-UNDO.

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
         HEIGHT             = 4.96
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

FIND FIRST ccbcmvto WHERE ROWID(ccbcmvto) = para_RowID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcmvto THEN RETURN.

FOR EACH CcbDMvto WHERE
    CcbDMvto.CodCia = CcbCMvto.CodCia AND
    CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
    CcbDMvto.NroDoc = CcbCMvto.NroDoc AND
    CcbDMvto.TpoRef = "O" NO-LOCK:
    IF cNroRef = "" THEN cNroRef = CcbDMvto.NroRef.
    ELSE cNroRef = cNroRef + "," + CcbDMvto.NroRef.
END.

IF NUM-ENTRIES(cNroRef) > 1 THEN cNroRef = "-".

FOR EACH CCBDMVTO NO-LOCK WHERE
    CCBDMVTO.codcia = ccbcmvto.codcia AND
    CcbDMvto.CodDoc = CcbcMvto.CodDoc AND
    CCBDMVTO.nrodoc = ccbcmvto.nrodoc AND
    CCBDMVTO.CodCli = ccbcmvto.codcli AND
    CCBDMVTO.codRef = "LET"           AND
    CCBDMVTO.TpoRef = 'L'
    BREAK BY ccbdmvto.nroref:

    RUN bin/_numero(ccbdmvto.imptot, 2, 1, OUTPUT cImpLetras).
    cImpLetras = cImpLetras +
        IF ccbcmvto.codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS".

    IF NOT AVAILABLE gn-clie THEN
        FIND gn-clie WHERE
            gn-clie.CodCia = cl-codcia AND
            gn-clie.CodCli = CCBDMVTO.CodCli NO-LOCK NO-ERROR.

    IF s-task-no = 0 THEN REPEAT:
        s-task-no = RANDOM(1, 999999).
        IF NOT CAN-FIND(FIRST w-report WHERE
            w-report.task-no = s-task-no AND
            w-report.Llave-C = s-user-id NO-LOCK) THEN LEAVE.
    END.

    CREATE w-report.
    ASSIGN
        w-report.Task-No = s-task-no                /* ID Tarea */
        w-report.Llave-C = s-user-id                /* ID Usuario */
        w-report.Campo-C[1] = ccbdmvto.NroRef       /* Número Letra */
        w-report.Campo-C[2] = cNroRef               /* Ref Girador */
        w-report.Campo-D[1] = ccbdmvto.fchemi       /* Fecha Giro */
        w-report.Campo-D[2] = ccbdmvto.fchvto       /* Fecha Vencimiento */
        w-report.Campo-C[3] =                       /* Moneda */
            IF ccbcmvto.codmon = 1
            THEN "S/" ELSE "US$"
        w-report.Campo-F[1] = ccbdmvto.imptot       /* Importe */
        w-report.Campo-C[4] = cImpLetras.           /* Importe Letras */

    IF AVAILABLE gn-clie THEN
        ASSIGN
            w-report.Campo-C[5] = gn-clie.NomCli 
            w-report.Campo-C[6] = gn-clie.DirCli 
            w-report.Campo-C[7] = gn-clie.Ruc 
            w-report.Campo-C[8] = gn-clie.Telfnos[1]
            w-report.Campo-C[9] = gn-clie.Aval1[1]
            w-report.Campo-C[10] = gn-clie.Aval1[2]
            w-report.Campo-C[11] = gn-clie.Aval1[3]
            w-report.Campo-C[12] = gn-clie.Aval1[4].
END.

/* Rutina Impresión de Letras */
/*RD01-Cambio de formato de letra
RUN ccb\r-letform(s-task-no, s-user-id).
*/
/*RD01-Nuevo formato de impresion de letras*/
RUN ccb\r-letform2(s-task-no, s-user-id).

FOR EACH w-report WHERE
    w-report.task-no = s-task-no AND
    w-report.Llave-C = s-user-id:
    DELETE w-report.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


