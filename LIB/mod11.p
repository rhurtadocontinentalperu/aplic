&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Digito Verificador

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       : MOD11
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT  PARAMETER pCodBarra AS CHAR.
DEF OUTPUT PARAMETER pDigito   AS INT.

pCodBarra = TRIM(pCodBarra).
IF TRUE <> (pCodBarra > '') THEN DO:
    pDigito = -1.
    RETURN.
END.

DEF VAR x-Incremento AS INT INIT 1 NO-UNDO.
DEF VAR x-Factor AS INT INIT 2 NO-UNDO.
DEF VAR x-Valor  AS INT INIT 0 NO-UNDO.

DEF VAR k AS INT NO-UNDO.

DO k = LENGTH(pCodBarra) TO 1 BY -1:
    x-Valor = x-valor + INTEGER(SUBSTRING(pCodBarra, k, 1)) * x-Factor.
    x-Factor = x-Factor + x-Incremento.
    IF x-Factor = 10 THEN x-Incremento = -1.
    IF x-Factor = 2  THEN x-Incremento = 1.
END.
pDigito = x-Valor MODULO 11.

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


