&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Informacion de SUNAT

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEF INPUT  PARAMETER pRuc AS CHAR.
DEF INPUT  PARAMETER pEMail AS CHAR.
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

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
         HEIGHT             = 4.23
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE x-url AS CHAR NO-UNDO.
DEFINE VARIABLE x-xml AS LONGCHAR NO-UNDO.
DEFINE VARIABLE x-texto AS CHAR NO-UNDO.
DEFINE VARIABLE x-status AS CHAR NO-UNDO.
DEFINE VARIABLE hDoc AS HANDLE NO-UNDO.
DEFINE VARIABLE x-url-addressconsult AS CHAR NO-UNDO.

x-url-addressconsult = "http://192.168.100.221:7000/api/server/continental/email".
x-url = TRIM(x-url-addressconsult).

x-url = x-url + "/" + TRIM(pRUC) + '/' + TRIM(pEMail) .

pError = "ERROR DE CONEXION" + CHR(10) + x-url-addressconsult.

CREATE X-DOCUMENT hDoc.
hDoc:LOAD("FILE", x-url, FALSE).
hDoc:SAVE("LONGCHAR",x-xml).
x-texto = CAPS(STRING(x-xml)).
/* Status */
RUN ReturnValue ("status", OUTPUT x-Status).
IF x-Status = "OK" THEN pError = "".
ELSE pError = x-Status.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ReturnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReturnValue Procedure 
PROCEDURE ReturnValue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER pTipo AS CHAR.
    DEF OUTPUT PARAMETER pValor AS CHAR.

    DEFINE VARIABLE x-pos1 AS INT NO-UNDO.
    DEFINE VARIABLE x-pos2 AS INT NO-UNDO.

    pValor = ''.
    DEF VAR x-Marcador-1 AS CHAR NO-UNDO.
    DEF VAR x-Marcador-2 AS CHAR NO-UNDO.

    x-Marcador-1 = "<" + TRIM(pTipo) + ">".
    x-Marcador-2 = "</" + TRIM(pTipo) + ">".
    x-pos1 = INDEX(x-texto,x-Marcador-1).
    IF x-pos1 > 0 THEN DO:
        x-pos1 = x-pos1 + LENGTH(x-Marcador-1).
        x-pos2 = INDEX(x-texto,x-Marcador-2).
        pValor = TRIM(SUBSTRING(x-texto,x-pos1,x-pos2 - x-pos1)).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

