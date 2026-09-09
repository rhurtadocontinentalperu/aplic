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

/* Valida si el formato de hora está correcto */
/* Solo acepta formatos de 24 horas */
DEF INPUT PARAMETER pCadena AS CHAR.    /* Puede ser HH:MM o HH:MM:SS */
DEF OUTPUT PARAMETER pMensaje AS CHAR.

pMensaje = "Formato de hora errado" + CHR(10) + 'Debe ser HH:MM o HH:MM:SS, formato de 24 horas'.

IF INDEX(pCadena, ':') = 0 THEN RETURN.
IF NUM-ENTRIES(pCadena,':') > 3 THEN RETURN.

DEF VAR xHora AS INT NO-UNDO.
DEF VAR xMinutos AS INT NO-UNDO.
DEF VAR xSegundos AS INT NO-UNDO.

ASSIGN 
    xHora = INTEGER(ENTRY(1,pCadena,':'))
    xMinutos = INTEGER(ENTRY(2,pCadena,':'))
    NO-ERROR.
IF ERROR-STATUS:ERROR THEN RETURN.

IF NUM-ENTRIES(pCadena,':') > 2 THEN DO:
    ASSIGN
        xSegundos = INTEGER(ENTRY(3,pCadena,':'))
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN.
END.
IF xHora <= 0 OR xHora > 24 THEN RETURN.
IF xMinutos > 59 THEN RETURN.
IF xSegundos > 59 THEN RETURN.
pMensaje = "".

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
         HEIGHT             = 3.62
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


