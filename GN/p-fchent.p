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

/* CONSISTENCIA DE FECHA DE ENTREGA */
DEF INPUT PARAMETER pFechaBase AS DATE.
DEF INPUT PARAMETER pHoraBase AS CHAR.
DEF INPUT PARAMETER pFchEnt AS DATE.
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF OUTPUT PARAMETER pError AS CHAR.

DEF SHARED VAR s-codcia AS INT.

DEF VAR pHoraCorte AS CHAR INIT '17:00:00' NO-UNDO.

IF pCodDiv = "00024" THEN pHoraCorte = "18:00:00".     /* Institucionales */

pError = "".
IF NUM-ENTRIES(pHoraBase,':') < 3 THEN pHoraBase = pHoraBase + ':00'.
/* Como mínimo un día */
IF pFchEnt - pFechaBase < 0 THEN DO:
    pError = 'Fecha de Entrega Errada' + CHR(10) + 'Debe ser por lo menos de hoy en adelante'.
END.
DEF VAR x-Minimo-1 AS INT INIT 1 NO-UNDO.
DEF VAR x-Minimo-2 AS INT INIT 2 NO-UNDO.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = pCodDiv
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-divi AND gn-divi.campo-log[8] = YES     /* Control de Despacho */
    THEN ASSIGN
    x-Minimo-1 = x-Minimo-1 + 1
    x-Minimo-2 = x-Minimo-2 + 1.
/* RHC 03/02/2017 */
/*IF pCodAlm = '11' OR pCodAlm = '11e' THEN ASSIGN x-Minimo-1 = 2 x-Minimo-2 = 3.*/
IF pHoraBase > pHoraCorte THEN DO:
    /* Como mínimo dos días */
    IF pFchEnt - pFechaBase < x-Minimo-2 THEN DO:
        pError = 'Fecha de Entrega Errada' + CHR(10) + 'Operaciones necesita por lo menos ' + TRIM(STRING(X-Minimo-2)) + ' día(s) para gestionar el pedido'.
    END.
END.
ELSE DO:
    /* Como mínimo un día */
    IF pFchEnt - pFechaBase < x-Minimo-1 THEN DO:
        pError = 'Fecha de Entrega Errada' + CHR(10) + 'Operaciones necesita por lo menos ' + TRIM(STRING(X-Minimo-1)) + ' día(s) para gestionar el pedido'.
    END.
END.

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
         HEIGHT             = 4.08
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


