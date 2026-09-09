&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT PARAMETER para-recid AS RECID.

FIND cb-cmov WHERE RECID(cb-cmov) = para-recid NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cmov THEN RETURN.

DEFINE VARIABLE cListCta AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodOpe AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNroAst AS CHARACTER NO-UNDO.

DEFINE BUFFER b-cmov FOR cb-cmov.
DEFINE BUFFER b-dmov FOR cb-dmov.

cListCta = "421101,421102".

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
         HEIGHT             = 4.58
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Detalle del pago */
FOR EACH cb-dmov NO-LOCK WHERE
    cb-dmov.codcia = cb-cmov.codcia AND
    cb-dmov.periodo = cb-cmov.periodo AND
    cb-dmov.nromes = cb-cmov.NroMes AND
    cb-dmov.codope = cb-cmov.CodOpe AND
    cb-dmov.nroast = cb-cmov.NroAst USE-INDEX DMOV00:

    IF LOOKUP(cb-dmov.codcta,cListCta) = 0 THEN NEXT.

    /* Captura datos de la provisión */
    cCodOpe = TRIM(ENTRY(1, cb-dmov.NroRef, "-")).
    cNroAst = TRIM(ENTRY(2, cb-dmov.NroRef, "-")).

    /* Solo provisiones de compras */
    IF cCodOpe <> "060" THEN NEXT.

    /* Busca todos los documentos */
    FIND LAST b-dmov NO-LOCK WHERE
        b-dmov.codcia = cb-dmov.codcia AND
        b-dmov.periodo >= 0 AND
        b-dmov.codope = cCodOpe AND
        b-dmov.codcta = cb-dmov.codcta AND
        b-dmov.CodDoc = cb-dmov.coddoc AND
        b-dmov.NroDoc = cb-dmov.nrodoc AND
        b-dmov.CodAux = cb-dmov.codaux AND
        b-dmov.NroAst = cNroAst.
    IF AVAILABLE b-dmov THEN DO:
        /* Cabecera de la provisión */
        FIND b-cmov WHERE
            b-cmov.codcia = b-dmov.codcia AND
            b-cmov.periodo = b-dmov.periodo AND
            b-cmov.nromes = b-dmov.nromes AND
            b-cmov.codope = b-dmov.codope AND
            b-cmov.nroast = b-dmov.nroast
            EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE b-cmov THEN DO:
            ASSIGN
                b-cmov.nrotra = cb-cmov.nrotra
                b-cmov.fchmod = cb-cmov.fchmod.
            RELEASE b-cmov.
        END.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-proc_mensaje) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_mensaje Procedure 
PROCEDURE proc_mensaje :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER para_nrodoc AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER para_auxiliar AS CHARACTER NO-UNDO.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .96
     BGCOLOR 4 FGCOLOR 14  NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Auxiliar" 
     VIEW-AS FILL-IN 
     SIZE 27 BY .96
     BGCOLOR 4 FGCOLOR 14  NO-UNDO.

DEFINE FRAME Dialog-Frame
     Btn_OK AT ROW 9.65 COL 26
     FILL-IN-1 AT ROW 5.42 COL 19.43
     FILL-IN-2 AT ROW 6.58 COL 22.86
     "EXISTE UNA CANCELACIÓN PREVIA A LA DETRACCIÓN" VIEW-AS TEXT
          SIZE 51 BY 1.35 AT ROW 3.88 COL 7
     SPACE(7.13) SKIP(7.05)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 4 FGCOLOR 15 
         TITLE "AVISO!!!"
         DEFAULT-BUTTON Btn_OK.

FILL-IN-1 = para_nrodoc.
FILL-IN-2 = para_auxiliar.

DISPLAY FILL-IN-1 FILL-IN-2 WITH FRAME Dialog-Frame.
UPDATE Btn_OK  WITH FRAME Dialog-Frame.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

