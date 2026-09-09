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
fuente True Type "PF EAN P36" ó "PF EAN P72"

RUN lib/_StrToEan8 (tcString, tlChekD, OUTPUT lcCod)

PARAMETROS:
  tcString: Caracter de 7 dígitos (0..9)
  tlCheckD: .T. Solo genera el dígito de control
            .F. Genera dígito y caracteres a imprimir
  lcCod:    Caracter de retorno.
*/  

DEF INPUT PARAMETER tcString AS CHAR.
DEF INPUT PARAMETER tlCheckD AS LOG.
DEF OUTPUT PARAMETER lcCod AS CHAR.

DEF VAR lcLat AS CHAR.
DEF VAR lcMed AS CHAR.
DEF VAR lcRet AS CHAR.
DEF VAR lcIni AS CHAR.
DEF VAR lnI AS INT.
DEF VAR lnCheckSum AS INT.
DEF VAR lnAux AS INT.

lcRet = TRIM(tcString).
IF LENGTH(lcRet) <> 7 THEN DO:
    /*--- Error en parámetro */
    /*--- debe tener un largo = 7 */
    RETURN.
END.
/*--- Genero dígito de control */
lnCheckSum = 0.
DO lnI = 1 TO 7:
    IF lnI MODULO 2 = 0
        THEN lnCheckSum = lnCheckSum + INTEGER(SUBSTRING(lcRet,lnI,1)) * 1.
        ELSE lnCheckSum = lnCheckSum + INTEGER(SUBSTRING(lcRet,lnI,1)) * 3.
END.
lnAux = lnCheckSum MODULO 10.
lcRet = lcRet + TRIM(STRING( IF lnAux = 0 THEN 0 ELSE 10 - lnAux )).
IF tlCheckD THEN DO:
    /*--- Si solo genero dígito de control */
    lcCod = LcRet.
    RETURN.
END.
/*--- Para imprimir con fuente True Type PF_EAN_PXX */
/*--- Caracteres lateral y central */
lcLat = CHR(33).
lcMed = CHR(45).
/*--- Caracteres */
DO lnI = 1 TO 8:
    IF lnI <= 4
        THEN OVERLAY(lcRet, lnI, 1) = CHR(INTEGER(SUBSTRING(lcRet,lnI,1)) + 48).
        ELSE OVERLAY(lcRet, lnI, 1) = CHR(INTEGER(SUBSTRING(lcRet,lnI,1)) + 97).
END.
/*--- Armo código */
lcCod = lcLat + SUBSTRING(lcRet,1,4) + lcMed + SUBSTRING(lcRet,5,4) + lcLat.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


