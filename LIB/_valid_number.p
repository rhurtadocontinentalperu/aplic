&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Verificar que es una cadena numérica

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/*
Sintaxis:
RUN lib/_only_numbers.p (
    INPUT pNumber,      /* En caracteres */
    OUTPUT pLongitud,   /* Longitud del pNumber */
    OUTPUT pError).     /* Mensaje de error */

*/

DEF INPUT-OUTPUT PARAMETER pNumber AS CHAR.
DEF OUTPUT PARAMETER pLongitud AS INT.
DEF OUTPUT PARAMETER pError AS CHAR.

DEF VAR cValidos AS CHAR INIT "1234567890" NO-UNDO.

DEF VAR iPosicion AS INT NO-UNDO.
DEF VAR cCaracter AS CHAR NO-UNDO.

pError = "".

pNumber = TRIM(pNumber).
pLongitud = LENGTH(pNumber).

IF TRUE <> (pNumber > '') OR pLongitud = 0 THEN DO:
    pError = "Debe ingresar un número válido".
    RETURN.
END.
DO iPosicion = 1 TO pLongitud:
    cCaracter = SUBSTRING(pNumber,iPosicion,1).
    IF INDEX(cValidos, cCaracter ) = 0 THEN DO:
        pError = "Caracter NO válido: " + cCaracter + CHR(10) +
            "Debe ingresar un numérico".
        RETURN.
    END.
END.
RETURN.

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
         HEIGHT             = 3.88
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


