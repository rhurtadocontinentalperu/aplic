&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Calculo del digito verificar, valido para EAN 13
    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER tcCodigo AS CHAR.
DEF OUTPUT PARAMETER tcDigito AS CHAR.

DEF VAR lcRet AS CHAR NO-UNDO.
DEF VAR lnI AS INT NO-UNDO.
DEF VAR lnCheckSum AS INT NO-UNDO.
DEF VAR lnAux AS INT NO-UNDO.


lcRet = TRIM(tcCodigo).
IF LENGTH(lcRet) <> 12 THEN DO:
    MESSAGE 'La longitud de la cadena debe ser de 12 dígitos'
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
lnCheckSum = 0.
DO lnI = 1 TO 12:
    IF lnI MODULO 2 = 0 THEN lnCheckSum = lnCheckSum + INTEGER(SUBSTRING(lcRet,lnI,1)) * 3.
    ELSE lnCheckSum = lnCheckSum + INTEGER(SUBSTRING(lcRet,lnI,1)) * 1.
END.
lnAux = lnCheckSum MODULO 10.
tcDigito = STRING (IF lnAux = 0 THEN 0 ELSE (10 - lnAux), '9').
lcRet = lcRet + tcDigito.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


