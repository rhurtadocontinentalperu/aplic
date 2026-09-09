&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Valor del figito verificador público
                  Edenred

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
         HEIGHT             = 4.81
         WIDTH              = 53.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER pCodBarra AS CHAR.
DEF OUTPUT PARAMETER pDigito AS INT.

IF LENGTH(pCodBarra) < 26 THEN DO:
    pDigito = -1.
    RETURN.
END.

DEF VAR j AS INT NO-UNDO.
DEF VAR x-Valor AS INT INIT 0 NO-UNDO.

DO j = 1 TO 26:
    IF j = 1 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 1.
    IF j = 2 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 2.
    IF j = 3 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 3.
    IF j = 4 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 4.
    IF j = 5 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 5.
    IF j = 6 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 6.
    IF j = 7 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 7.
    IF j = 8 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 8.
    IF j = 9 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 9.
    IF j = 10 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 10.
    IF j = 11 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 11.
    IF j = 12 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 12.
    IF j = 13 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 13.
    IF j = 14 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 13.
    IF j = 15 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 12.
    IF j = 16 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 11.
    IF j = 17 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 10.
    IF j = 18 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 9.
    IF j = 19 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 8.
    IF j = 20 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 7.
    IF j = 21 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 6.
    IF j = 22 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 5.
    IF j = 23 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 4.
    IF j = 24 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 3.
    IF j = 25 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 2.
    IF j = 26 THEN x-Valor = x-Valor + INTEGER(SUBSTRING(pCodBarra,j,1)) * 1.
END.

pDigito = x-Valor MODULO 10.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


