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

/* Sintaxis:

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN <libreria> PERSISTENT SET hProc.

RUN <libreria>.rutina_interna IN hProc (input  buffer tt-excel:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

DELETE PROCEDURE hProc.

*/


DEF SHARED VAR s-codcia AS INTE.

DEF STREAM sLogEpos.

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
         HEIGHT             = 7.73
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-GenerateCodeQR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GenerateCodeQR Procedure 
PROCEDURE GenerateCodeQR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER sDataQR AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER sPathGraficoQR AS CHAR NO-UNDO.

DEFINE VAR tnSize AS INT.
DEFINE VAR tnType AS INT.
DEFINE VAR tcText AS CHAR.
DEFINE VAR tcFile AS CHAR.
DEFINE VAR iReturn AS INT.
DEFINE VAR cFileImg AS CHAR.

DEFINE VAR x-tmpdir AS CHAR.

tcText = "".
tcFile = "".
sPathGraficoQR = "".   
/*
IF NUM-ENTRIES(sDataQR,"|") >= 9 THEN DO:
    tcText = sDataQR.
    x-tmpdir = LC(SESSION:TEMP-DIRECTORY).
    x-tmpdir = IF (INDEX(x-tmpdir,"\documents and settings") > 0) THEN ".\" ELSE x-tmpdir.
    tcFile = x-tmpdir + ENTRY(3,tcText,"|") + "-" + ENTRY(4,tcText,"|") + "-" + ENTRY(9,tcText,"|") + ".jpg".
END.
*/

x-tmpdir = LC(SESSION:TEMP-DIRECTORY).
x-tmpdir = IF (INDEX(x-tmpdir,"\documents and settings") > 0) THEN ".\" ELSE x-tmpdir.

IF NUM-ENTRIES(sDataQR,"|") >= 9 THEN DO:
    tcText = sDataQR.
    tcFile = x-tmpdir + ENTRY(3,tcText,"|") + "-" + ENTRY(4,tcText,"|") + "-" + ENTRY(9,tcText,"|") + ".jpg".
END.
ELSE DO:
    
    cFileImg = REPLACE(STRING(NOW,"99/99/9999 hh:mm:ss"),"/","-").
    cFileImg = REPLACE(cFileImg,":","-").
    cFileImg = REPLACE(cFileImg," ","_").
    cFileImg = cFileImg + "_" + string(RANDOM(1,999),"999").

    tcText = sDataQR.
    tcFile = x-tmpdir + cFileImg + ".jpg".
END.

tnSize = 4.
tnType = 1.

IF tcFile <> "" THEN DO:
    RUN SetConfiguration(INPUT tnSize, INPUT tnType, OUTPUT iReturn).
    RUN GenerateFile(INPUT tcText, OUTPUT tcFile, OUTPUT iReturn).

    sPathGraficoQR = tcFile.

END.

RELEASE EXTERNAL PROCEDURE "BarCodeLibrary.DLL". 

END PROCEDURE.

/*
  *   tnSize: Imagen Size [2..12] (default = 4)
  *     2 = 66 x 66 (in pixels)
  *     3 = 99 x 99
  *     4 = 132 x 132
  *     5 = 165 x 165
  *     6 = 198 x 198
  *     7 = 231 x 231
  *     8 = 264 x 264
  *     9 = 297 x 297
  *    10 = 330 x 330
  *    11 = 363 x 363
  *    12 = 396 x 396
  *   tnType: Imagen Type [BMP, JPG or PNG] (default = 0)
  *     0 = BMP
  *     1 = JPG
  *     2 = PNG
*/


/* ************************************************** */
PROCEDURE GenerateFile EXTERNAL "BarCodeLibrary.DLL":
/* ************************************************** */

    DEFINE INPUT PARAMETER p-cData AS CHARACTER.
    DEFINE OUTPUT PARAMETER p-cFileName AS CHARACTER.
    DEFINE RETURN PARAMETER p-iReturn AS LONG.

END PROCEDURE.

/* ************************************************** */
PROCEDURE SetConfiguration EXTERNAL "BarCodeLibrary.DLL":
/* ************************************************** */

    DEFINE INPUT PARAMETER p-nSize AS LONG.
    DEFINE INPUT PARAMETER p-nImageType AS LONG.
    DEFINE RETURN PARAMETER p-iReturn AS LONG.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GenerateLogEposTxt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GenerateLogEposTxt Procedure 
PROCEDURE GenerateLogEposTxt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pTexto AS CHAR.

DEFINE BUFFER x-factabla FOR factabla.

DEFINE VAR lPCName AS CHAR.  

RUN lib/_pc-name.p(OUTPUT lPcName).

/* IP de la PC */
DEFINE VAR x-ip AS CHAR.
DEFINE VAR x-pc AS CHAR.
DEFINE VAR x-archivo AS CHAR.
DEFINE VAR x-file AS CHAR.
DEFINE VAR x-linea AS CHAR.

RUN lib/_get_ip.r(OUTPUT x-pc, OUTPUT x-ip).

FIND FIRST x-factabla WHERE x-factabla.codcia = s-codcia 
    AND x-factabla.tabla = 'TXTLOGEPOS'
    AND x-factabla.codigo = 'ALL'
    NO-LOCK NO-ERROR.
IF AVAILABLE x-factabla AND x-factabla.campo-l[1] = YES THEN DO:
    x-file = STRING(TODAY,"99/99/9999").
    x-file = REPLACE(x-file,"/","").
    x-file = REPLACE(x-file,":","").

    x-archivo = SESSION:TEMP-DIRECTORY + "conect-epos-" + x-file + ".txt".

    OUTPUT STREAM sLogEpos TO VALUE(x-archivo) APPEND.

    x-linea = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"hh:mm:ss") + 
        " (" + lPCName + "-" + x-pc + ":" + x-ip + ") - " + TRIM(pTexto).

    PUT STREAM sLogEpos x-linea FORMAT 'x(300)' SKIP.

    OUTPUT STREAM sLogEpos CLOSE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetDataQR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetDataQR Procedure 
PROCEDURE GetDataQR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF OUTPUT PARAMETER x-retval AS CHAR.

DEF BUFFER b-Ccbcdocu FOR Ccbcdocu.

FIND b-Ccbcdocu WHERE b-Ccbcdocu.codcia = s-codcia AND
    b-Ccbcdocu.coddoc = pCodDoc AND
    b-Ccbcdocu.nrodoc = pNroDoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE b-Ccbcdocu THEN RETURN.

DEFINE VAR x-ruc-cli AS CHAR.
DEFINE VAR x-tipo-ide AS CHAR.
DEFINE VAR x-Importe-maximo-boleta AS DEC INIT 700.
DEFINE VAR x-emision AS CHAR INIT "".

DEFINE VAR cRucEmpresa AS CHAR.
DEFINE VAR cSerieSunat AS CHAR.
DEFINE VAR cCorrelativoSunat AS CHAR.
DEFINE VAR cTipoDoctoSunat AS CHAR.

cRucEmpresa = "20100038146".
x-emision = SUBSTRING(STRING(b-ccbcdocu.fchdoc,"99-99-9999"),7,4) + "-".
x-emision = x-emision + SUBSTRING(STRING(b-ccbcdocu.fchdoc,"99-99-9999"),4,2) + "-" .
x-emision = x-emision + SUBSTRING(STRING(b-ccbcdocu.fchdoc,"99-99-9999"),1,2).

x-Ruc-Cli = IF (b-ccbcdocu.ruccli = ?) THEN "" ELSE TRIM(b-ccbcdocu.ruccli).
x-Tipo-Ide = '6'.

/* UTF-8 */
IF b-ccbcdocu.coddoc = 'BOL' THEN DO:
    IF b-ccbcdocu.imptot > x-Importe-maximo-boleta THEN DO:
        IF x-Ruc-Cli = "" THEN DO:
            x-Ruc-Cli = IF (b-ccbcdocu.codant = ?) THEN "" ELSE TRIM(b-ccbcdocu.codant).
            x-Tipo-Ide = '1'.
            IF x-Ruc-Cli = "" OR x-Ruc-Cli BEGINS "11111" THEN DO:
                x-Ruc-Cli = "12345678".            
            END.
            ELSE DO:
                /* 8 Digitos de DNI */
                x-Ruc-Cli = "00000000" + x-Ruc-Cli.            
                x-Ruc-Cli = SUBSTRING(x-Ruc-Cli, (LENGTH(x-Ruc-Cli) - 8) + 1).
            END.
        END.
        ELSE DO:
            IF LENGTH(x-Ruc-Cli) = 11 AND SUBSTRING(x-Ruc-Cli,1,3) = '000' THEN DO:
                /* Es DNI */
                x-Ruc-Cli = STRING(INTEGER(x-Ruc-Cli),"99999999").
                x-Tipo-Ide = '1'.
            END.    
        END.
    END.
    ELSE DO: 
        IF LENGTH(x-Ruc-Cli) = 11 AND SUBSTRING(x-Ruc-Cli,1,3) = '000' THEN DO:
            x-Ruc-Cli = '0'.
            x-Tipo-Ide = '0'.
        END.
        IF LENGTH(x-Ruc-Cli) <> 11 THEN x-Ruc-Cli = '0'.    
        IF LENGTH(x-Ruc-Cli) <> 11 THEN x-Tipo-Ide = '0'.    
    END.
END.

/* Prefijo de la serie del documento electronico */
RUN GetSerialPrefix (b-ccbcdocu.coddoc, b-ccbcdocu.nrodoc, b-ccbcdocu.coddiv, OUTPUT cSerieSunat).

cSerieSunat = cSerieSunat  +  SUBSTRING(b-ccbcdocu.nrodoc,1,3).
cCorrelativoSunat   = SUBSTRING(b-ccbcdocu.nrodoc,4).

IF b-ccbcdocu.coddoc = 'FAC' THEN cTipoDoctoSunat     = '01'.
IF b-ccbcdocu.coddoc = 'BOL' THEN cTipoDoctoSunat     = '03'.
IF b-ccbcdocu.coddoc = 'N/C' THEN cTipoDoctoSunat     = '07'.
IF b-ccbcdocu.coddoc = 'N/D' THEN cTipoDoctoSunat     = '08'. 

x-retval = cRucEmpresa + "|" + cTipoDoctoSunat + "|" + cSerieSunat + "|" + cCorrelativoSunat + "|" + 
            TRIM(STRING(b-ccbcdocu.impigv,">>,>>>,>>9.99")) + "|" + TRIM(STRING(b-ccbcdocu.imptot,">>>,>>>,>>9.99")) + "|" +
            x-emision + "|" + x-tipo-ide + "|" + x-ruc-cli + "|".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetSerialPrefix) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetSerialPrefix Procedure 
PROCEDURE GetSerialPrefix :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pTipoDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF INPUT PARAMETER pDivision AS CHAR.
DEF OUTPUT PARAMETER lxRet AS CHAR.

lxRet = '?'.

DEFINE BUFFER z-ccbcdocu FOR ccbcdocu.            

IF pTipoDoc = 'N/C' OR pTipoDoc = 'N/D' THEN DO:
    IF pDivision > "" THEN DO:
        FIND FIRST z-ccbcdocu WHERE z-ccbcdocu.codcia = s-codcia AND 
                                    z-ccbcdocu.coddiv = pDivision AND
                                    z-ccbcdocu.coddoc = pTipoDoc AND 
                                    z-ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
    END.
    ELSE DO:
        FIND FIRST z-ccbcdocu WHERE z-ccbcdocu.codcia = s-codcia AND 
                                    z-ccbcdocu.coddoc = pTipoDoc AND 
                                    z-ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
    END.
    IF AVAILABLE z-ccbcdocu THEN DO:
        IF z-ccbcdocu.codref = 'LET' THEN DO:
            /* la Referencia es una LETRA, es un CANJE */
            /* Devuelve el documento Original F001001255 o B145001248 */
            RUN GetSourceDocument (z-ccbcdocu.codref, z-ccbcdocu.nroref, OUTPUT lxRet).
            lxRet = SUBSTRING(lxRet,1,1).
        END.
        ELSE DO:
            RUN GetSerialPrefix (z-ccbcdocu.codref, z-ccbcdocu.nroref, "", OUTPUT lxRet).
        END.
    END.
    ELSE lxRet = '?'.
END.
ELSE DO:
    IF pTipoDoc = 'FAC' THEN lxRet = 'F'.
    IF pTipoDoc = 'BOL' OR pTipoDoc = 'TCK' THEN lxRet = 'B'.        
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetSourceDocument) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetSourceDocument Procedure 
PROCEDURE GetSourceDocument :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pTipoDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER lRetVal AS CHAR.

DEFINE VAR lDocFactura AS CHAR.
DEFINE VAR lDocBoleta AS CHAR.
DEFINE VAR lDocLetra AS CHAR.

lRetVal = "?".

DEFINE BUFFER fx-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER fx-ccbdmvto FOR ccbdmvto.

FIND FIRST fx-ccbcdocu USE-INDEX llave01 WHERE fx-ccbcdocu.codcia = s-codcia AND 
    fx-ccbcdocu.coddoc = pTipoDoc AND 
    fx-ccbcdocu.nrodoc = pNroDoc 
    NO-LOCK NO-ERROR.
IF AVAILABLE fx-ccbcdocu THEN DO:    
    IF fx-ccbcdocu.codref = 'FAC' OR fx-ccbcdocu.codref = 'BOL' OR fx-ccbcdocu.codref = 'TCK' THEN DO:
        IF fx-ccbcdocu.codref = 'FAC' THEN lRetVal = 'F' + fx-ccbcdocu.nroref.
        IF fx-ccbcdocu.codref = 'BOL' OR fx-ccbcdocu.codref = 'TCK' THEN lRetVal = 'B' + fx-ccbcdocu.nroref.        
    END.
    ELSE DO:
        IF fx-ccbcdocu.codref = 'LET' THEN DO:
            /* No deberia darse, pero x siaca */
            RUN GetSourceDocument (fx-ccbcdocu.codref, fx-ccbcdocu.nroref, OUTPUT lRetVal).
        END.
        ELSE DO:
            IF fx-ccbcdocu.codref = 'CJE' OR fx-ccbcdocu.codref = 'RNV' OR fx-ccbcdocu.codref = 'REF' THEN DO:
                /* Si en CANJE, RENOVACION y REFINANCIACION */
                lDocFactura = "".
                lDocBoleta = "".
                lDocLetra = "".
                FOR EACH fx-ccbdmvto WHERE fx-ccbdmvto.codcia = s-codcia AND 
                    fx-ccbdmvto.coddoc = fx-ccbcdocu.codref AND 
                    fx-ccbdmvto.nrodoc = fx-ccbcdocu.nroref NO-LOCK:
                    IF fx-ccbdmvto.nroref <> pnroDoc THEN DO:
                        IF fx-ccbdmvto.codref = 'FAC' AND lDocFactura = "" THEN lDocFactura = "F" + fx-ccbdmvto.nroref.
                        IF fx-ccbdmvto.codref = 'BOL' AND lDocBoleta = "" THEN lDocBoleta = "B" + fx-ccbdmvto.nroref.
                        IF fx-ccbdmvto.codref = 'LET' AND lDocLetra = "" THEN lDocLetra = fx-ccbdmvto.nroref.
                    END.
                END.
                IF lDocFactura  = "" AND lDocBoleta = "" AND lDocLetra <> "" THEN DO:
                    /* es una LETRA */
                    RUN GetSourceDocument ("LET", lDocLetra, OUTPUT lRetVal).
                END.
                ELSE DO:
                    IF lDocBoleta  > "" THEN lRetVal = lDocBoleta.
                    IF lDocFactura > "" THEN lRetVal = lDocFactura.
                END.
            END.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

