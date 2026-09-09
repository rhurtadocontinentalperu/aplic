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
/*
Convierte un string para ser impreso con
fuente True Type "PF Interleaved 2 of 5" 
ó "PF Interleaved 2 of 5 Wide" 
ó "PF Interleaved 2 of 5 Text"   
Solo caracteres numéricos

RUN lib/StrToI2of5 (tcString, OUTPUT lcRet)

Ejemplo 4: Para pasar el número 123456789 al formato de código Interleaved 2 of 5 
(este código solo acepta números de longitud par, si la longitud es impar, 
justifica con un "0" (cero) a la izquierda) con las tres fuentes True Type disponibles:

lcTexto = "123456789"
lcCodBar = _StrToI2of5(lcTexto)
*-- I 2de5 Normal
? lcCodBar FONT "PF Interleaved 2 of 5",36
*-- I 2de5 Ancho
? lcCodBar FONT "PF Interleaved 2 of 5 Wide",36
*-- I 2de5 con lectura humana (Human Readable)
? lcCodBar FONT "PF Interleavev 2 of 5 Text",36
*/

DEF INPUT PARAMETER tcString AS CHAR.
DEF OUTPUT PARAMETER lcRet AS CHAR.

DEF VAR lcStart AS CHAR.
DEF VAR lcStop AS CHAR.
DEF VAR lcCheck AS CHAR.
DEF VAR lcCar AS CHAR.
DEF VAR lnLong AS INT.
DEF VAR lnI AS INT.
DEF VAR lnSum AS INT.
DEF VAR lnAux AS INT.
DEF VAR lnCount AS INT.

ASSIGN
    lcStart = CHR(40)
    lcStop = CHR(41)
    lcRet = TRIM(tcString).
/*--- Genero dígito de control */
ASSIGN
    lnLong = LENGTH(lcRet)
    lnSum = 0
    lnCount = 1.
DO lnI = lnLong TO 1 BY -1:
    lnSum = lnSum + INTEGER(SUBSTRING(lcRet,lnI,1)) * 
            IF (lnCount MODULO 2) = 0 THEN 1 ELSE 3.
    lnCount = lnCount + 1.
END.
lnAux = lnSum MODULO 10.
lcRet = lcRet + TRIM(STRING( IF lnAux = 0 THEN 0 ELSE 10 - lnAux )).
lnLong = LENGTH(lcRet).
/*--- La longitud debe ser par */
IF lnLong MODULO 2 <> 0
    THEN ASSIGN
            lcRet = '0' + lcRet
            lnLong = LENGTH(lcRet).
/*--- Convierto los pares a caracteres */
lcCar = ''.
DO lnI = 1 TO lnLong BY 2:
    IF INTEGER(SUBSTRING(lcRet,lnI,2)) < 50
        THEN lcCar = lcCar + CHR(INTEGER(SUBSTRING(lcRet,lnI,2)) + 48).
        ELSE lcCar = lcCar + CHR(INTEGER(SUBSTRING(lcRet,lnI,2)) + 142).
END.
/*--- Armo código */
lcRet = lcStart + lcCar + lcStop.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


