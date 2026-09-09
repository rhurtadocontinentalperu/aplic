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

DEF INPUT PARAMETER cadenaTexto AS CHAR.
DEF INPUT PARAMETER sustituirPor AS CHAR.
DEF OUTPUT PARAMETER cadenaResultado AS CHAR.

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

DEF VAR tamanoCadena AS INT NO-UNDO.
DEF VAR i AS INT NO-UNDO.
DEF VAR caracteresValidos AS CHAR NO-UNDO.
DEF VAR caracterActual AS CHAR NO-UNDO.
  
tamanoCadena = LENGTH(cadenaTexto).
If tamanoCadena > 0 THEN DO:
    caracteresValidos = ' 0123456789abcdefghijklmnñopqrstuvwxyABCDEFGHIJKLMNÑOPQRSTUVWXY'.
    caracteresValidos = caracteresValidos + "áéíóúÁÉÍÓÚüÜ@'".
    DO i = 1 TO tamanoCadena:
        caracterActual = SUBSTRING(cadenaTexto, i, 1).
        IF INDEX(caracteresValidos, caracterActual) > 0 THEN
            cadenaResultado = cadenaResultado + caracterActual.
        ELSE 
            cadenaResultado = cadenaResultado + sustituirPor.
    END.
END.
/* Si la cadena de resultados tiene mas de un espacio en blanco intermedio
solo se queda con un espacio en blanco */
DEF VAR CadenaLimpia AS CHAR NO-UNDO.
DEF VAR CuentaEspacios AS INTE NO-UNDO.

cadenaResultado = TRIM(cadenaResultado).
DO i = 1 TO LENGTH(cadenaResultado):
    IF SUBSTRING(cadenaResultado,i,1) = " " THEN CuentaEspacios = CuentaEspacios + 1.
    ELSE CuentaEspacios = 0.
    IF CuentaEspacios <= 1 THEN CadenaLimpia = CadenaLimpia + SUBSTRING(cadenaResultado,i,1).
END.
cadenaResultado = CadenaLimpia.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


