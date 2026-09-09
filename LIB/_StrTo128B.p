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
fuente True Type "PF Barcode 128"
Caracteres numéricos y alfabeticos (mayúsculas y minúsculas)
Si un caracter es no válido lo remplaza por espacio

RUN lib/_StrTo128B ('Codigo 128 B', OUTPUT X)

Ejemplo 1: Para pasar el texto "Esto es un ejemplo" al formato de código de barra Código 128 B:

lcTexto = "Esto es un ejemplo"
lcCodBar = _StrTo128B(lcTexto)
? lcCodBar FONT "PF Barcode 128",36
*/

DEF INPUT PARAMETER tcString AS CHAR.
DEF OUTPUT PARAMETER lcRet AS CHAR.

DEF VAR lcStart AS CHAR.
DEF VAR lcStop AS CHAR.
DEF VAR lcCheck AS CHAR.
DEF VAR lnLong AS INT.
DEF VAR lnI AS INT.
DEF VAR lnCheckSum AS INT.
DEF VAR lnAsc AS INT.

ASSIGN
    lcStart = CHR(104 + 32)
    lcStop = CHR(106 + 32)
    lnCheckSum = ASC(lcStart) - 32
    lcRet = tcString
    lnLong = LENGTH(lcRet).

DO lnI = 1 TO lnLong:
    lnAsc = ASC( SUBSTRING(lcRet, lnI, 1) ) - 32.
    IF NOT (lnAsc > 0 AND lnAsc < 99) THEN DO:
        OVERLAY(lcRet, lnI, 1) = CHR(32).
        /*lcRet = STUFF(lcRet,lnI,1,CHR(32))*/
        lnAsc = ASC( SUBSTRING(lcRet, lnI, 1) ) - 32.
    END.
    lnCheckSum = lnCheckSum + (lnAsc * lnI).
END.
lcCheck = CHR( (lnCheckSum MODULO 103) + 32).
lcRet = lcStart + lcRet + lcCheck + lcStop.
/* Esto es para cambiar los espacios y caracteres invalidos */
lcRet = REPLACE(lcRet,CHR(32),CHR(232)).
lcRet = REPLACE(lcRet,CHR(127),CHR(192)).
lcRet = REPLACE(lcRet,CHR(128),CHR(193)).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


