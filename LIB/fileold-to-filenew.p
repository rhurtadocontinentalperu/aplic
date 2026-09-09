&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Transformar un archivo texto en otro sin caracteres especials

    Syntax      : RUN (INPUT ArchivoOrigen, OUTPUT ArchivoDestino)

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


DEF INPUT PARAMETER pOrigen AS CHAR.
DEF OUTPUT PARAMETER pDestino AS CHAR.

/* verificamos el origen */
DEF VAR cOrigen AS CHAR.
DEF VAR cDestino AS CHAR.

cOrigen = SEARCH(pOrigen).
IF cOrigen = ? THEN DO:
    MESSAGE 'NO se encontró el archivo' pOrigen VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

/* el archivo destino se grabará en una carpeta temporal */
pDestino = SESSION:TEMP-DIRECTORY.
DEF VAR k AS INT.
DO  k = LENGTH(cOrigen) TO 1 BY -1:
    IF LOOKUP(SUBSTRING(cOrigen, k, 1), '/,\,:') > 0 THEN LEAVE.
    cDestino = SUBSTRING(cOrigen, k, 1) + cDestino.
END.
pDestino = pDestino + cDestino.
pDestino = REPLACE(pDestino, '.', '-new.').

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
         HEIGHT             = 3.65
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* importamos el archivo origen */
DEF TEMP-TABLE tOrigen 
    FIELD Campo-C AS CHAR FORMAT 'x(254)'.

INPUT FROM VALUE(cOrigen).
REPEAT:
    CREATE tOrigen.
    IMPORT UNFORMATTED tOrigen.
END.
INPUT CLOSE.

/* eliminamos los caracteres espaciales */
DEF VAR j AS INT.
FOR EACH tOrigen:
    DO j = 1 TO 31:
        IF j = 9 THEN tOrigen.Campo-C = REPLACE(tOrigen.Campo-C, CHR(j), '        ').
        ELSE tOrigen.Campo-C = REPLACE(tOrigen.Campo-C, CHR(j), '').
    END.
    tOrigen.Campo-C = REPLACE(tOrigen.Campo-C, CHR(127), '').
    tOrigen.Campo-C = REPLACE(tOrigen.Campo-C, CHR(129), '').
    tOrigen.Campo-C = REPLACE(tOrigen.Campo-C, CHR(141), '').
    tOrigen.Campo-C = REPLACE(tOrigen.Campo-C, CHR(143), '').
    tOrigen.Campo-C = REPLACE(tOrigen.Campo-C, CHR(144), '').
    tOrigen.Campo-C = REPLACE(tOrigen.Campo-C, CHR(157), '').
END.

/* exportamos el archivo */
OUTPUT TO VALUE(pDestino).
FOR EACH tOrigen:
    PUT UNFORMATTED tOrigen.Campo-C SKIP.
END.
OUTPUT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


