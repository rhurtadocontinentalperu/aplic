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

RUN lib/_StrToEan13 (tcString, tlCheckD, OUTPUT lcCod)

PARAMETROS:
   tcString: Caracter de 12 dígitos (0..9)
   tlCheckD: TRUE  Solo genera el dígito de control
             FALSR Genera dígito y caracteres a imprimir
   lcRet; Caracter de retorno
   
Ejemplo 3: Para pasar el país Argentina ("779"), la empresa "1234" y el producto "01234" 
al formato de código de barra Código EAN-13 (solo paso 12 caracteres, 
ya que la función agrega y codifica el dígito de control):

lcTexto = "779123401234"
lcCodBar = _StrToEAN13(lcTexto)
? lcCodBar FONT "PF EAN P72",72
*/

DEF INPUT PARAMETER tcString AS CHAR.
DEF INPUT PARAMETER tlCheckD AS LOG.
DEF OUTPUT PARAMETER lcCod AS CHAR.

DEF VAR lcLat AS CHAR.
DEF VAR lcMed AS CHAR.
DEF VAR lcRet AS CHAR.
DEF VAR lcJuego AS CHAR.
DEF VAR lcIni AS CHAR.
DEF VAR lcResto AS CHAR.
DEF VAR lnI AS INT.
DEF VAR lnCheckSum AS INT.
DEF VAR lnAux AS INT.
DEF VAR laJuego AS CHAR EXTENT 10.
DEF VAR lnPri AS INT.

lcRet = TRIM(tcString).
IF LENGTH(lcRet) <> 12 THEN DO:
    /* Error en parámetro debe tener un largo = 12 */
    RETURN.
END.
/* Genero dígito de control */
lnCheckSum = 0.
DO lnI = 1 TO 12:
    IF lnI MODULO 2  = 0 
    THEN lnCheckSum = lnCheckSum + INTEGER( SUBSTRING(lcRet, lnI, 1) ) * 3.
    ELSE lnCheckSum = lnCheckSum + INTEGER( SUBSTRING(lcRet, lnI, 1)) * 1.
END.
ASSIGN
    lnAux = lnCheckSum MODULO 10
    lcRet = lcRet + TRIM( STRING(IF lnAux = 0 THEN 0 ELSE 10 - lnAux) ).
/* Si solo genero dígito de control */
IF tlCheckD THEN DO:
    lcCod = lcRet.
    RETURN.
END.

/* Para imprimir con fuente True Type PF_EAN_PXX
   1er. dígito (lnPri) */
lnPri = INTEGER( SUBSTRING(lcRet, 1, 1) ).
/* Tabla de Juegos de Caracteres
   según 'lnPri' (¡NO CAMBIAR!) */
ASSIGN
    laJuego[1] = 'AAAAAACCCCCC'   /* 0 */
    laJuego[2] = 'AABABBCCCCCC'   /* 1 */
    laJuego[3] = 'AABBABCCCCCC'   /* 2 */
    laJuego[4] = 'AABBBACCCCCC'   /* 3 */
    laJuego[5] = 'ABAABBCCCCCC'   /* 4 */
    laJuego[6] = 'ABBAABCCCCCC'   /* 5 */
    laJuego[7] = 'ABBBAACCCCCC'   /* 6 */
    laJuego[8] = 'ABABABCCCCCC'   /* 7 */
    laJuego[9] = 'ABABBACCCCCC'   /* 8 */
    laJuego[10] = 'ABBABACCCCCC'.  /* 9 */
/*--- Caracter inicial (fuera del código) */
lcIni = CHR(lnPri + 35).
/*--- Caracteres lateral y central */
lcLat = CHR(33).
lcMed = CHR(45).
/*--- Resto de los caracteres */
lcResto = SUBSTRING(lcRet, 2, 12).
DO lnI = 1 TO 12:
    lcJuego = SUBSTRING( laJuego[lnPri + 1], lnI, 1).
    CASE lcJuego:
        WHEN 'A' THEN OVERLAY(lcResto, lnI, 1) = CHR(INTEGER(SUBSTRING(lcResto,lnI,1)) + 48).
        WHEN 'B' THEN OVERLAY(lcResto, lnI, 1) = CHR(INTEGER(SUBSTRING(lcResto,lnI,1)) + 65).
        WHEN 'C' THEN OVERLAY(lcResto, lnI, 1) = CHR(INTEGER(SUBSTRING(lcResto,lnI,1)) + 97).
    END CASE.
END.
/*--- Armo código */
lcCod = lcIni + lcLat + SUBSTRING(lcResto,1,6) + lcMed + SUBSTRING(lcResto,7,6) + lcLat.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


