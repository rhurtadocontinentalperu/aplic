&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Genera un dígito verificador

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pCaracteres AS CHAR.
DEF OUTPUT PARAMETER pDigito AS INT.

IF pCaracteres = '' THEN DO:
    pDigito = -1.
    RETURN.
END.

/* Todos deben ser numéricos */
DEF VAR k AS INT NO-UNDO.
DO k = 1 TO LENGTH(pCaracteres):
    IF INDEX('0123456789', SUBSTRING(pCaracteres, k, 1)) = 0 THEN DO:
        pDigito = -1.
        RETURN.
    END.
END.

/* Acumulamos los impares y multiplicamos por 3 */
DEF VAR x-Impares AS INT NO-UNDO.
DO k = 1 TO LENGTH(pCaracteres) BY 2:
    x-Impares = x-Impares + INTEGER(SUBSTRING(pCaracteres, k, 1)).
END.
x-Impares = x-Impares * 3.
/* Acumulamos los pares */
DEF VAR x-Pares AS INT NO-UNDO.
IF LENGTH(pCaracteres) > 1 THEN DO:
    DO k = 2 TO LENGTH(pCaracteres) BY 2:
        x-Pares = x-Pares + INTEGER(SUBSTRING(pCaracteres, k, 1)).
    END.
END.
/* Acumulamos ambos valores */
pDigito = x-Impares + x-Pares.
/* Buscamos cuanto falta para llegar a la siguiente decena */
pDigito = 10 - ( pDigito MODULO 10 ).
IF pDigito = 10 THEN pDigito = 0.

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
         HEIGHT             = 4.31
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


