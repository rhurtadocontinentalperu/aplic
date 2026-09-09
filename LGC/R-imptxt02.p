&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : r-impcmp.p
    Purpose     : 

    Syntax      :

    Description : Imprime Orden de Compra

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER X-ROWID AS ROWID.

DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-RUCCIA AS INT.
DEFINE SHARED VARIABLE PV-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE cl-CODCIA AS INTEGER.
DEF SHARED VAR S-NomCia AS CHAR.
DEF VAR C-ConPgo   AS CHAR FORMAT "X(50)" NO-UNDO.
DEF VAR X-EnLetras AS CHAR FORMAT "X(100)" NO-UNDO.
DEF VAR I-NroItm AS INTEGER NO-UNDO.
DEF VAR C-Moneda AS CHAR INIT "S/." FORMAT "X(3)".
DEF VAR C-UNIT0   AS DECIMAL INIT 0.
DEF VAR C-UNIT1   AS DECIMAL INIT 0.
DEF VAR C-UNIT2   AS DECIMAL INIT 0.
DEF VAR C-IGV     AS DECIMAL INIT 0.
DEF SHARED VAR s-coddiv LIKE gn-divi.coddiv.
DEF        VAR W-DIRALM AS CHAR FORMAT "X(50)".
DEF        VAR W-TLFALM AS CHAR FORMAT "X(13)".
DEF VAR N-ITEM     AS INTEGER INIT 0 NO-UNDO.
DEF VAR X-NRO      AS CHARACTER.

DEFINE STREAM Reporte.

FIND LG-COCmp WHERE ROWID(LG-COCmp) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE LG-COCmp THEN RETURN.

IF LG-COCmp.Codmon = 2 THEN C-Moneda = "US$".
FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA 
              AND  gn-prov.CodPro = LG-COCmp.CodPro 
             NO-LOCK NO-ERROR.

FIND gn-ConCp WHERE gn-ConCp.Codig = LG-COCmp.CndCmp NO-LOCK NO-ERROR.
IF AVAILABLE gn-ConCp THEN C-ConPgo = Gn-ConCp.Nombr.

FIND Almacen WHERE Almacen.CodCia = LG-COCmp.CodCia 
              AND  Almacen.CodAlm = LG-COCmp.CodAlm 
             NO-LOCK NO-ERROR.


/* Valida que todos articulos de la OC tenga CodBarra */
RUN val_codbarr.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    /*MESSAGE 'Existen Articulos que no tiene CodBarra' VIEW-AS ALERT-BOX ERROR.*/
    RETURN.
END.

/* DEF VAR X-MARGEN AS DECI INIT 0.  */
/* DEF VAR X-UNDMIN AS CHAR INIT "". */
/* DEF VAR X-equival AS DECI INIT 0. */
/* DEF VAR X-precon AS DECI INIT 0.  */
/* DEF VAR X-porce AS char INIT "%". */



/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(LG-COCmp.ImpTot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = "SON : " + X-EnLetras + (IF LG-COCmp.Codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/************************  DEFINICION DE FRAMES  *******************************/

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
         HEIGHT             = 6.12
         WIDTH              = 39.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
def var cotfile as char init "".
def var x-file  as char init "".
DEF VAR Rpta-1 AS LOG NO-UNDO.

DEFINE VARIABLE cCodEmi AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCodRec AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNroSec AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNroDoc AS CHARACTER   NO-UNDO.

DEFINE VARIABLE dFchDoc AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dFchMax AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dFchSol AS DECIMAL     NO-UNDO.

DEFINE VARIABLE cPtoCmp AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCodFac AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dImpVta AS DECIMAL     NO-UNDO.
DEFINE VARIABLE cMonCmp AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cMonFac AS CHARACTER   NO-UNDO.

DEFINE VARIABLE dImpTot AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dCanPed AS DECIMAL     NO-UNDO.
DEFINE VARIABLE iDiasFac AS INTEGER     NO-UNDO.

DEFINE VARIABLE cLinea01 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLinea02 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLinea03 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLinea04 AS CHARACTER   NO-UNDO.

DEFINE VARIABLE x_archivo AS CHARACTER  NO-UNDO.

cotfile = "OC" + "-" + STRING(LG-COCmp.NroDoc, "999999") + ".txt".

/* SYSTEM-DIALOG GET-FILE x-File FILTERS '*.txt' '*.txt' */
/*     INITIAL-FILTER 1 ASK-OVERWRITE CREATE-TEST-FILE   */
/*     DEFAULT-EXTENSION 'txt'                           */
/*     RETURN-TO-START-DIR SAVE-AS                       */
/*     TITLE 'Guardar en' USE-FILENAME                   */
/*     UPDATE Rpta-1.                                    */
/*                                                       */
/* IF Rpta-1 = NO THEN RETURN.                           */
/*                                                       */
/* MESSAGE "x-file " x-file.                             */

/*Código Emisor - Cliente Continental*/
FIND FIRST gn-clied WHERE gn-clied.codcia = cl-codcia
    AND gn-clied.codcli = '20100038146' NO-LOCK NO-ERROR.
IF AVAIL gn-clied THEN cCodEmi = gn-clied.libre_C01.


/*Códigp Receptor*/
FIND gn-prov WHERE gn-prov.codcia = pv-codcia
    AND gn-prov.codpro = lg-cocmp.codpro NO-LOCK NO-ERROR.
IF AVAIL gn-prov THEN cCodRec = STRING(gn-prov.libre_c05,"X(13)").

/*Número Doc*/
cNroDoc = STRING(LG-COCmp.NroDoc, "999999").

/*Fechas*/
dFchDoc = ((YEAR(FchDoc) * 10000) + (MONTH(FchDoc) * 100) + DAY(FchDoc)) * 10000.
dFchMax = ((YEAR(FchVto) * 10000) + (MONTH(FchVto) * 100) + DAY(FchVto)) * 10000.
dFchSol = ((YEAR(FchEnt) * 10000) + (MONTH(FchEnt) * 100) + DAY(FchEnt)) * 10000.

/*Punto Compra*/
FIND almacen WHERE almacen.codcia = s-codcia 
    AND almacen.codalm = lg-cocmp.codalm NO-LOCK NO-ERROR.
IF AVAIL almacen THEN cPtoCmp = Almacen.Campo-C[5] .

/*Documentos*/
cCodFac = cCodEmi.
dImpVta = LG-COCmp.ImpIgv.
IF LG-COCmp.Codmon = 1 THEN 
    ASSIGN 
        cMonCmp = 'PEN'
        cMonFac = 'PEN'.
ELSE ASSIGN
        cMonCmp = 'USD'
        cMonFac = 'USD'.
ASSIGN 
    dImpTot  = LG-COCmp.ImpNet
    cNroSec  = STRING(NEXT-VALUE(edi_sec_ocompras),"9999999999").

/*    cNroSec  = STRING(LG-COCmp.NroRef,"9999").*/
    
/*Condición Pago*/
FIND FIRST gn-concp WHERE Gn-ConCp.Codig = LG-COCmp.CndCmp NO-LOCK NO-ERROR.
IF AVAIL gn-concp THEN iDiasFac = gn-concp.totdias.
ELSE iDiasFac = 0.

x-file = '\\inf252\C$\Archivos de programa\Automatizacion\OutBox\continentalcompe\' + cotfile.
x-file = '\\Xpu7\OutBox\continentalcompe\' + cotfile.
/*x-file = 'C:\Users\rdiaz\Documents\Nextel\' + cotfile.*/
OUTPUT STREAM Report TO VALUE(x-file) /*PAGED PAGE-SIZE 31*/.

PUT STREAM REPORT 'ENC,'   + cCodEmi + ',' + cCodRec + ',' + cNroSec + ',' + '220' + ',' + '77508222200000' + cNroDoc + '1,' + 'ORDERS' + ',' + '9' FORMAT "X(100)" SKIP.
PUT STREAM REPORT 'DTM,'   + STRING(dFchDoc,'999999999999') + ',' + STRING(dFchMax,'999999999999') + ',' + ',' + STRING(dFchSol,'999999999999')  FORMAT "X(100)" SKIP.
PUT STREAM REPORT 'BYOC,'  + cCodEmi + ',' + ',' + ',' + cPtoCmp            FORMAT "X(50)" SKIP.
PUT STREAM REPORT 'SUSR,'  + cCodRec    FORMAT "X(50)" SKIP.
PUT STREAM REPORT 'DPGR,'  + cPtoCmp    FORMAT "X(50)" SKIP.
PUT STREAM REPORT 'IVAD,'  + cCodFac    FORMAT "X(50)" SKIP.
PUT STREAM REPORT 'ITO,'   + cCodFac    FORMAT "X(50)" SKIP.
PUT STREAM REPORT 'TAXMOA,' + TRIM(STRING(dImpVta,'>>>>>>>>>>>>>>9.999'))   FORMAT "X(50)" SKIP.
PUT STREAM REPORT 'CUX,'    + cMonCmp + ',' + cMonFac  FORMAT "X(50)" SKIP.
PUT STREAM REPORT 'PATPCD,' + '9' + ',' + TRIM(STRING(iDiasFac,">>9"))  FORMAT "X(50)" SKIP.
PUT STREAM REPORT 'MOA,'    + TRIM(STRING(dImptot,'>>>>>>>>>>>>>>9.999'))    FORMAT "X(50)" SKIP.

/*Detalle*/
DEFINE VARIABLE iNroLin AS INTEGER     NO-UNDO INIT 1.
DEFINE VARIABLE dImpLin AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dPreBru AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dPreNet AS DECIMAL     NO-UNDO.
DEFINE VARIABLE cUndCmp AS CHARACTER   NO-UNDO.
DEFINE VARIABLE lCodBarra AS CHARACTER NO-UNDO.

iNroLin = 1.
FOR EACH LG-DOCmp WHERE LG-DOCmp.CodCia = LG-COCmp.CodCia
    AND  LG-DOCmp.TpoDoc = LG-COCmp.TpoDoc
    AND  LG-DOCmp.NroDoc = LG-COCmp.NroDoc NO-LOCK,
    FIRST Almmmatg OF LG-DOCmp NO-LOCK
        BREAK BY LG-DOCmp.NroDoc
            BY LG-DOCmp.ArtPro
            BY Almmmatg.CodMat:

    cUndCmp = 'NAR'.

    dImpLin = LG-DOCmp.ImpTot / (1 + LG-DOCmp.IgvMat / 100).
/*     dPreBru = LG-DOCmp.PreUni / (1 + LG-DOCmp.ImpTot / 100). */
    dPreBru = LG-DOCmp.PreUni .
    dPreNet = ( LG-DOCmp.ImpTot / LG-DOCmp.CanPedi) / (1 + LG-DOCmp.IgvMat / 100).
    
    /* Equivalencia EDI - Cesar Iman */
    dCanPed = LG-DOCmp.CanPedi.
    IF almmmatg.Libre_d01 > 0 THEN DO :
        dCanPed = LG-DOCmp.CanPedi / almmmatg.Libre_d01.
        dPreBru = dPreBru * almmmatg.Libre_d01.
    END.

    /* Obtengo el codigo de barra de la tabla intermedia IC 08/Nov/2012 */
    /*
    FIND FIRST proveedor_articulo WHERE proveedor_articulo.codcia = s-codcia AND 
        proveedor_articulo.codpro = LG-COCmp.CodPro AND 
        proveedor_articulo.codmat = LG-DOCmp.codmat NO-LOCK NO-ERROR.

    lCodBarra = "".
    IF AVAILABLE proveedor_articulo THEN lCodBarra = proveedor_articulo.codbarra.
    */

    lCodBarra = "".

    FIND FIRST proveedor_articulo WHERE proveedor_articulo.codcia = s-codcia AND 
        proveedor_articulo.codpro = LG-COCmp.CodPro AND 
        proveedor_articulo.codmat = LG-DOCmp.codmat NO-LOCK NO-ERROR.

    IF AVAILABLE proveedor_articulo THEN DO:
        IF NOT (proveedor_articulo.codbarra = ? OR proveedor_articulo.codbarra = '') THEN lCodBarra = proveedor_articulo.codbarra.
    END.

    IF lCodBarra = ? OR lCodBarra = '' THEN DO:
        IF AVAILABLE almmmatg THEN DO:
               IF NOT (almmmatg.codbrr = ? OR almmmatg.codbrr = '') THEN lCodBarra = almmmatg.codbrr.
        END.
    END.
    IF lCodBarra = ? OR lCodBarra = '' THEN DO:
        /* Envia Codigo INTERNO */
        lCodBarra = LG-DOCmp.codmat.
    END.

    /*cLinea01 = 'LIN,' + STRING(iNroLin) + ',' + STRING(Almmmatg.codbrr) + ',' + 'EN' + ',' + almmmatg.codmat.*/
    /*cLinea02 = 'QTY,' + TRIM(STRING(LG-DOCmp.CanPedi,'>>>>>>>>>>>9.999')) + ',' + cUndCmp.  */
    cLinea01 = 'LIN,' + STRING(iNroLin) + ',' + STRING(lCodBarra) + ',' + 'EN' + ',' + almmmatg.codmat.
    cLinea02 = 'QTY,' + TRIM(STRING(dCanPed ,'>>>>>>>>>>>9.999')) + ',' + cUndCmp.  
    cLinea03 = 'MOA,' + TRIM(STRING(dImpLin,'>>>>>>>>>>>>>>9.999')).
    cLinea04 = 'PRI,' + TRIM(STRING(dPreBru,'>>>>>>>>>>9.9999')) + ',' + TRIM(STRING(dPreNet,'>>>>>>>>>>9.9999')) .

    cLinea01 = REPLACE(cLinea01,CHR(10),"").
    cLinea02 = REPLACE(cLinea02,CHR(10),"").
    cLinea03 = REPLACE(cLinea03,CHR(10),"").
    cLinea04 = REPLACE(cLinea04,CHR(10),"").

    iNroLin = iNroLin + 1.
    PUT STREAM REPORT cLinea01 FORMAT "X(100)" SKIP.
    PUT STREAM REPORT cLinea02 FORMAT "X(100)" SKIP.
    PUT STREAM REPORT cLinea03 FORMAT "X(100)" SKIP.
    PUT STREAM REPORT cLinea04 FORMAT "X(100)" SKIP.

END.

OUTPUT STREAM Report CLOSE.

MESSAGE SKIP
        "Orden de Compra ha sido Generada y guardada :" cotfile
        view-as alert-box information
        title cotfile.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-val_codbarr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE val_codbarr Procedure 
PROCEDURE val_codbarr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
  Purpose:     Valida que todos los articulos de la orden de compra
            Tengan EAN
  Parameters:  <none>
  Notes:       Cesar Iman Namuche
------------------------------------------------------------------------------*/

/*
FOR EACH LG-DOCmp WHERE LG-DOCmp.CodCia = LG-COCmp.CodCia
    AND  LG-DOCmp.TpoDoc = LG-COCmp.TpoDoc
    AND  LG-DOCmp.NroDoc = LG-COCmp.NroDoc NO-LOCK,
    FIRST Almmmatg OF LG-DOCmp NO-LOCK
        BREAK BY LG-DOCmp.NroDoc
            BY LG-DOCmp.ArtPro
            BY Almmmatg.CodMat:
    
    IF Almmmatg.codbrr = ? OR Almmmatg.codbrr = '' THEN DO:
        MESSAGE 'Este articulo(' Almmmatg.CodMat ') NO tiene Codigo de Barra' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.    
    END.         
END.
*/

DEFINE VAR lCodBarras AS LOGICAL.

FOR EACH LG-DOCmp WHERE LG-DOCmp.CodCia = LG-COCmp.CodCia
    AND  LG-DOCmp.TpoDoc = LG-COCmp.TpoDoc
    AND  LG-DOCmp.NroDoc = LG-COCmp.NroDoc NO-LOCK. 

    lCodBarras = YES.

    FIND FIRST proveedor_articulo WHERE proveedor_articulo.codcia = s-codcia AND 
        proveedor_articulo.codpro = LG-COCmp.CodPro AND 
        proveedor_articulo.codmat = LG-DOCmp.codmat NO-LOCK NO-ERROR.

    IF NOT AVAILABLE proveedor_articulo OR proveedor_articulo.codbarra = ? OR proveedor_articulo.codbarra = '' THEN DO:
        lCodBarras = NO.
    END.
    
    IF lCodBarras = NO THEN DO:
        lCodBarras = YES.
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND almmmatg.codmat = LG-DOCmp.codmat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almmmatg OR almmmatg.codbrr = ? OR almmmatg.codbrr = '' THEN DO:
               lCodBarras = NO.
        END.
    END.
    IF lCodBarras = NO THEN DO:
        MESSAGE 'Este articulo(' LG-DOCmp.codmat ') NO tiene Codigo de Barra(PROVEEDOR-ARTICULO)' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.    
    END.
END.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

