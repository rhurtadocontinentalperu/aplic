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
Convierte un string para ser impreso con fuente True Type "PF Barcode 128"
Solo caracteres numéricos

RUN lib/_StrTo128C ('12345678', OUTPUT X)
Para pasar el número 12345678 al formato de código de barra Código 128 C 
(este código solo acepta números de longitud par, si la longitud es impar, 
justifica con un "0" (cero) a la izquierda)

Ejemplo 2: Para pasar el número 12345678 al formato de código de barra Código 128 C (este código solo acepta números de longitud par, si la longitud es impar, justifica con un "0" (cero) a la izquierda):

lcTexto = "12345678"
lcCodBar = _StrTo128C(lcTexto)
? lcCodBar FONT "PF Barcode 128",36
*/

DEF INPUT PARAMETER tcString AS CHAR.
DEF OUTPUT PARAMETER lcRet AS CHAR.

DEF VAR lcStart AS CHAR.
DEF VAR lcStop AS CHAR.
/*DEF VAR lcRet AS CHAR.*/
DEF VAR lcCheck AS CHAR.
DEF VAR lcCar AS CHAR.
DEF VAR lnLong AS INT.
DEF VAR lnI AS INT.
DEF VAR lnCheckSum AS INT.
DEF VAR lnAsc AS INT.

ASSIGN
    lcStart = CHR(105 + 32)
    lcStop = CHR(106 + 32)
    lnCheckSum = ASC(lcStart) - 32
    lcRet = TRIM(tcString)
    lnLong = LENGTH(lcRet).

/* La longitud debe ser par */
IF lnLong MODULO 2 <> 0 THEN DO:
    lcRet = '0' + lcRet.
    lnLong = LENGTH(lcRet).
END.

/* Convierto los pares a caracteres */
lcCar = ''.
DO lnI = 1 TO lnLong BY 2:
    lcCar = lcCar + CHR( INTEGER( SUBSTRING(lcRet, lnI, 2) ) + 32 ).
END.
ASSIGN
    lcRet = lcCar
    lnLong = LENGTH(lcRet).
DO lnI = 1 TO lnLong:
    ASSIGN
        lnAsc = ASC( SUBSTRING (lcRet, lnI, 1 ) ) - 32
        lnCheckSum = lnCheckSum + (lnAsc * lnI).
END.
ASSIGN
    lcCheck = CHR( ( lnCheckSum MODULO 103 ) + 32)
    lcRet = lcStart + lcRet + lcCheck + lcStop.
/* Esto es para cambiar los espacios y caracteres invalidos */
lcret = REPLACE(lcRet, CHR(32), CHR(232) ).
lcRet = REPLACE(lcRet, CHR(32), CHR(232) ).
lcRet = REPLACE(lcRet, CHR(127), CHR(192) ).
lcRet = REPLACE(lcRet, CHR(128), CHR(193) ).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


