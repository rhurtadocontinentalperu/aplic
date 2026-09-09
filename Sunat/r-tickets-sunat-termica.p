&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : r-bole01.p
    Purpose     : Impresion de Fact/Boletas 
    Syntax      :
    Description :
    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE INPUT PARAMETER pVersion   AS CHAR.
DEFINE INPUT PARAMETER pImprimeDirecto AS LOG.
/* pVersion:
    "O": ORIGINAL 
    "C": COPIA 
   pImprimeDirecto:
    YES: Pre-definida en el correlativo
    NO:  Seleccionar
*/    

DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv  AS CHAR.


FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                    ccbcdocu.coddiv = pCodDiv AND 
                    ccbcdocu.coddoc = pCodDoc AND 
                    ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.

IF NOT AVAILABLE ccbcdocu THEN RETURN.

/* 
    Ic - 21Dic2016, si no tiene HASH, intentar enviar el a PPLL
*/
DEFINE VAR lVeces AS INT.
DEFINE VAR lSec1 AS INT.
DEFINE VAR lRetVal AS CHAR.

lVeces = 5.
REPEAT lSec1 = 1 TO lVeces:
    FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = ccbcdocu.codcia AND 
                                        FELogComprobantes.coddiv = ccbcdocu.coddiv AND 
                                        FELogComprobantes.coddoc = ccbcdocu.coddoc AND 
                                        FELogComprobantes.nrodoc = ccbcdocu.nrodoc
                                        NO-LOCK NO-ERROR.
    IF AVAILABLE FELogComprobantes THEN DO:
        lSec1 = lVeces + 5.
    END.
    ELSE DO:
        lRetVal = "".
        /*RUN sunat/progress-to-ppll(ROWID(ccbcdocu), OUTPUT lRetVal).*/
        RUN sunat/progress-to-ppll-v21(ROWID(ccbcdocu), INPUT-OUTPUT TABLE T-FELogErrores, OUTPUT lRetVal).
        RUN grabar-log-errores.
    END.
END.
/* Ic - 21Dic2016 - FIN  */

/* Ic - 28Nov2016, Verificar si el documento tiene HASH para la impresion */
FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = ccbcdocu.codcia AND 
                                    FELogComprobantes.coddiv = ccbcdocu.coddiv AND 
                                    FELogComprobantes.coddoc = ccbcdocu.coddoc AND 
                                    FELogComprobantes.nrodoc = ccbcdocu.nrodoc
                                    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FELogComprobantes THEN DO:
    MESSAGE "Documento aun no ha sido enviado a SUNAT" SKIP(1)
        "Se procede a CERRAR el SISTEMA por SEGURIDAD. Volver a entrar y repita el proceso."
        VIEW-AS ALERT-BOX ERROR.
    QUIT.

END.
IF TRUE <> (FELogComprobantes.codhash > "") THEN DO:
    MESSAGE "El documento NO TIENE el timbre(HASH) de seguridad de la SUNAT " SKIP(1)
        "Se procede a CERRAR el SISTEMA por SEGURIDAD. Volver a entrar y repita el proceso."
        VIEW-AS ALERT-BOX ERROR.
    QUIT.

END.
/* Ic - 28Nov2016 - Fin */

DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.

/*
DEF VAR C-NomCon   AS CHAR FORMAT "X(40)".
DEF VAR X-EnLetras AS CHAR FORMAT "x(60)" NO-UNDO.
DEF VAR x-Percepcion AS CHAR FORMAT "x(60)" NO-UNDO.
DEF VAR X-Cheque   AS CHAR    NO-UNDO.
DEF VAR C-MONEDA   AS CHAR FORMAT "x(8)"  NO-UNDO.
DEF VAR N-Item     AS INTEGER NO-UNDO.
DEF VAR X-impbrt   AS DECIMAL NO-UNDO.
DEF VAR X-dscto1   AS DECIMAL NO-UNDO.
DEF VAR X-preuni   AS DECIMAL NO-UNDO.
DEF VAR C-DESALM   AS CHAR NO-UNDO FORMAT "X(40)".
DEF VAR X-PUNTOS   AS CHAR FORMAT "X(40)".
DEF VAR X-LIN1     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN1A    AS CHAR FORMAT "X(40)".
DEF VAR X-LIN2     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN3     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN4     AS CHAR FORMAT "X(30)".
DEF VAR X-LIN4A    AS CHAR FORMAT "X(30)".
DEF VAR X-LIN5     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN6     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN7     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN8     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN9     AS CHAR FORMAT "X(40)".
DEF VAR X-LIN10    AS CHAR FORMAT "X(30)".
DEF VAR X-LIN11    AS CHAR FORMAT "X(40)".
DEF VAR x-Lin12    AS CHAR FORMAT 'x(40)'.
DEF VAR x-lin13   AS CHAR FORMAT 'x(40)'.
DEF VAR X-MAQ      AS CHAR FORMAT "X(40)".
DEF VAR X-CANCEL   AS CHAR FORMAT "X(10)".
*/
DEF VAR X-SOL      AS DECI INIT 0.
DEF VAR X-DOL      AS DECI INIT 0.
DEF VAR X-VUE      AS DECI INIT 0.
DEF VAR x-TarCreSol AS DEC INIT 0 NO-UNDO.
DEF VAR x-TarCreDol AS DEC INIT 0 NO-UNDO.

/* */
DEF VAR C-MONEDA   AS CHAR FORMAT "x(8)"  NO-UNDO.
DEF VAR C-NomCon   AS CHAR FORMAT "X(40)".
DEF VAR C-DESALM   AS CHAR NO-UNDO FORMAT "X(40)".
DEF VAR X-EnLetras AS CHAR FORMAT "x(60)" NO-UNDO.
DEF VAR X-Cheque   AS CHAR    NO-UNDO.
DEF VAR X-CANCEL   AS CHAR FORMAT "X(10)".
/* */

/*Variables Promociones*/
DEF VAR x-promo01 AS CHARACTER NO-UNDO FORMAT 'X(40)'.
DEF VAR x-promo02 AS CHARACTER NO-UNDO FORMAT 'X(40)'.

C-MONEDA = IF ccbcdocu.codmon = 1 THEN "SOLES" ELSE "DOLARES".
C-NomCon = "".

FIND FIRST Ccbddocu OF Ccbcdocu NO-LOCK NO-ERROR.
IF AVAIL CcbDdocu THEN DO:
    FIND Almacen WHERE Almacen.CodCia = ccbcdocu.codcia 
                  AND  Almacen.CodAlm = CcbDDocu.AlmDes 
                 NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN 
        ASSIGN C-DESALM = Almacen.CodAlm + " - " + Almacen.Descripcion.
END.
ELSE DO:
    FIND Almacen WHERE Almacen.CodCia = ccbcdocu.codcia 
                  AND  Almacen.CodAlm = ccbcdocu.codalm 
                 NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN 
        ASSIGN C-DESALM = Almacen.CodAlm + " - " + Almacen.Descripcion.
END.

FIND gn-ConVt WHERE gn-ConVt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
IF AVAILABLE gn-ConVt THEN 
   ASSIGN C-NomCon = gn-ConVt.Nombr.

/************************  PUNTEROS EN POSICION  *******************************/
RUN bin/_numero(ccbcdocu.imptot, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = "SON : " + X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " SOLES" ELSE " DOLARES AMERICANOS").
 
/*MLR* 28/12/07 ***/
DEF VAR cNroIC LIKE CcbDCaja.Nrodoc NO-UNDO.

/* Verifica que la cancelación se realizó con CHEQUE */
x-cheque = "".
IF CcbCDocu.Flgest = 'C' THEN DO:
    FOR EACH CcbDCaja WHERE
        CcbDCaja.CodCia = s-codcia AND
        CcbDCaja.CodRef = CcbCDocu.Coddoc AND
        CcbDCaja.NroRef = CcbCDocu.Nrodoc NO-LOCK,
        FIRST ccbccaja WHERE
        ccbccaja.codcia = ccbdcaja.codcia AND
        ccbccaja.coddiv = ccbdcaja.coddiv AND
        ccbccaja.coddoc = ccbdcaja.coddoc AND
        ccbccaja.nrodoc = ccbdcaja.nrodoc NO-LOCK:
        cNroIC = CcbDCaja.Nrodoc.

         x-cheque = TRIM(CcbCCaja.Voucher[2]) + TRIM(CcbCCaja.Voucher[3]).
         IF CcbCCaja.CodBco[2] <> '' THEN DO:
            FIND cb-tabl WHERE cb-tabl.Tabla = "04" AND cb-tabl.codigo = CcbCCaja.CodBco[2]
                         NO-LOCK NO-ERROR.
            IF AVAILABLE cb-tabl THEN
               x-cheque = x-cheque + " " + TRIM(cb-tabl.Nombre).
         END.
         IF CcbCCaja.CodBco[3] <> '' THEN DO:
            FIND cb-tabl WHERE cb-tabl.Tabla = "04" AND cb-tabl.codigo = CcbCCaja.CodBco[3]
                         NO-LOCK NO-ERROR.
            IF AVAILABLE cb-tabl THEN 
               x-cheque = x-cheque + " " + TRIM(cb-tabl.Nombre).
         END.
         IF CcbcCaja.ImpNac[1] + CcbCCaja.ImpUsa[1] > 0 Then x-cancel = x-cancel + ",Efectivo".
         IF CcbcCaja.ImpNac[2] + CcbCCaja.ImpUsa[2] + CcbcCaja.ImpNac[3] + CcbCCaja.ImpUsa[3] > 0 Then x-cancel = x-cancel + ",Cheque".
         IF CcbcCaja.ImpNac[4] + CcbCCaja.ImpUsa[4] > 0 Then x-cancel = x-cancel + ",Tarjeta".
         x-sol = CcbcCaja.ImpNac[1] + CcbcCaja.ImpNac[2] + CcbcCaja.ImpNac[3] + CcbcCaja.ImpNac[4].
         x-dol = CcbcCaja.ImpUsa[1] + CcbcCaja.ImpUsa[2] + CcbcCaja.ImpUsa[3] + CcbcCaja.ImpUsa[4].
         x-vue = CcbCCaja.VueNac .
         x-TarCreSol = CcbcCaja.ImpNac[4].
         x-TarCreDol = CcbcCaja.ImpUsa[4].
   END.
/*
  FIND FIRST CcbDCaja WHERE
        CcbDCaja.CodCia = s-codcia AND
        CcbDCaja.CodRef = CcbCDocu.Coddoc AND
        CcbDCaja.NroRef = CcbCDocu.Nrodoc NO-LOCK NO-ERROR.
  IF AVAILABLE CcbDCaja THEN DO:
      FIND FIRST ccbccaja OF ccbdcaja NO-LOCK.
  END.
*/

END.

/* Caracteres x Linea */
DEFINE VAR lCaracxlinea AS INT INIT 45.

/* ---------------------------------------------------------------- */

/*{src/bin/_prns.i}*/

DEFINE VAR s-task-no AS INT.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "aplic/alm/rbalm.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "ticket venta electronico".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

/* capturamos ruta inicial */
DEF VAR S-REPORT-LIBRARY AS CHAR.
GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE s-report-library.

RB-REPORT-LIBRARY = s-report-library + "vta2/rbvta2.prl".

DEFINE VAR lNombreTienda AS CHAR.
DEFINE VAR lSlogan AS CHAR.
DEFINE VAR lSlogan2 AS CHAR.
DEFINE VAR lEmpresa AS CHAR.
DEFINE VAR lRUC AS CHAR.
DEFINE VAR lDirEmpresa AS CHAR.
DEFINE VAR lDirEmpresa2 AS CHAR.
DEFINE VAR lDirTienda AS CHAR.
DEFINE VAR lDirTienda1 AS CHAR.
DEFINE VAR lDirTienda2 AS CHAR.
DEFINE VAR lTelfTienda AS CHAR.

DEFINE VAR lNombreDocumento AS CHAR.
DEFINE VAR lNroDocumento AS CHAR.
DEFINE VAR lCliente AS CHAR.
DEFINE VAR lDocCliente AS CHAR.

DEFINE VAR lHashCodePDF417 AS LONGCHAR.
DEFINE VAR lMoneda AS CHAR.

/* QR */
DEFINE VAR lPathGraficoQR AS CHAR FORMAT 'x(200)'.
DEFINE VAR lDataQR AS CHAR FORMAT 'x(255)'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-fCentrado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCentrado Procedure 
FUNCTION fCentrado RETURNS CHARACTER
  ( INPUT pDatos AS CHAR, INPUT pWidth AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fCentrar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCentrar Procedure 
FUNCTION fCentrar RETURNS INTEGER
    ( INPUT pDatos AS CHAR, INPUT pWidth AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-documento-origen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-documento-origen Procedure 
FUNCTION fget-documento-origen RETURNS CHARACTER
  ( INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-fecha-emision-ref) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-fecha-emision-ref Procedure 
FUNCTION fget-fecha-emision-ref RETURNS DATE
  (INPUT lxDoctoRef AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 5.69
         WIDTH              = 49.29.
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
/*
IF pImpresora = YES THEN DO:
    FIND FacCorre WHERE 
         FacCorre.CodCia = Ccbcdocu.codcia AND 
         FacCorre.CodDiv = Ccbcdocu.coddiv AND
         FacCorre.CodDoc = ccbcdocu.coddoc AND
         FacCorre.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroDoc, 1, 3)) NO-LOCK.

    IF USERID("integral") = "MASTER" THEN DO:
        RUN lib/_port-name ("Tickets", OUTPUT s-port-name).
    END.
    ELSE DO:
        RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name).
    END.
    IF s-port-name = '' THEN DO:
        MESSAGE 'NO está definida la impresora por defecto' SKIP
            'División:' Ccbcdocu.coddiv SKIP
            'Documento:' Ccbcdocu.coddoc SKIP
            'N° Serie:' SUBSTRING(CcbCDocu.NroDoc, 1, 3) SKIP
            'Impresora:' FacCorre.Printer
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    IF s-OpSys = 'WinVista'
    THEN OUTPUT TO PRINTER VALUE(s-port-name).
    ELSE OUTPUT TO VALUE(s-port-name).
END.
ELSE DO:
    DEF VAR answer AS LOGICAL NO-UNDO.
    SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
    IF NOT answer THEN RETURN.
    OUTPUT TO PRINTER.
END.
*/

/* --------------------------------------------------------------------------- */
RUN bin/_prnctr.p.
IF s-salida-impresion = 0 THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
/* creo el temporal */ 
REPEAT:
    s-task-no = RANDOM(1, 999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no
                    AND w-report.llave-c = s-user-id NO-LOCK)
        THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no.
        LEAVE.
    END.
END.

DEFINE VAR lFiler1 AS CHAR.
DEFINE VAR lTotRecibido AS DEC.
DEFINE VAR lFpagosx AS DEC.

DEFINE VAR lCajera AS CHAR.
DEFINE VAR x-Lineas AS INT.
DEFINE VAR x-LinxArt AS INT.
DEF VAR x-codbrr  AS CHARACTER   NO-UNDO FORMAT 'X(60)'.
DEFINE VAR lCodHash AS CHAR INIT "".
DEFINE VAR x-reimpresion AS CHAR INIT "".
DEFINE VAR x-tienda-nro AS CHAR INIT "".

DEFINE VAR lOpeGratuitas AS DEC.
DEFINE VAR lTotalPagar AS DEC.
DEFINE VAR lRefNotaCrededito AS CHAR.
DEFINE VAR lMonedaTxt AS CHAR.
DEFINE VAR lImpLetras AS CHAR.
DEFINE VAR lImpLetras1 AS CHAR.
DEFINE VAR lTipoMotivo AS CHAR INIT "".
DEFINE VAR lMotivo AS CHAR INIT "".
DEFINE VAR lDocReferencia AS CHAR INIT "".
DEFINE VAR lReferencia AS CHAR INIT "".
DEFINE VAR lReferencia1 AS CHAR INIT "".
DEFINE VAR lFEmisDocRef AS DATE.

lDataQR = "".

FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = ccbcdocu.codcia AND
                                    FELogComprobantes.coddiv = ccbcdocu.coddiv AND 
                                    FELogComprobantes.coddoc = ccbcdocu.coddoc AND 
                                    FELogComprobantes.nrodoc = ccbcdocu.nrodoc
                                    NO-LOCK NO-ERROR.
IF AVAILABLE FELogComprobantes THEN DO:
    lCodHash =  IF (FELogComprobantes.codhash = ?) THEN "" ELSE TRIM(FELogComprobantes.codhash).
    lDataQR =  IF (FELogComprobantes.dataQR = ?) THEN "" ELSE TRIM(FELogComprobantes.dataQR).
END.

lDirEmpresa = "CAL. RENE DESCARTES Nro. 114 URBANIZA.".
lDirEmpresa2= "SANTA RAQUEL II ETAPA  - LIMA-LIMA-ATE".
x-reimpresion = IF (pVersion = 'C') THEN "RE-IMPRESION" ELSE "".
x-tienda-nro = TRIM(ccbcdocu.coddiv).

FIND Gn-Divi WHERE Gn-Divi.codcia = Ccbcdocu.codcia
    AND Gn-Divi.coddiv = Ccbcdocu.coddiv
    NO-LOCK NO-ERROR.
IF AVAILABLE Gn-Divi THEN 
    ASSIGN 
        lNombreTienda   = CAPS(GN-DIVI.DesDiv)
        lDirTienda      = TRIM(GN-DIVI.DirDiv)
        lDirTienda2     = GN-DIVI.FaxDiv
        lTelfTienda     = gn-divi.teldiv.

lDirTienda1 = "".
IF LENGTH(lDirTienda) > lCaracxlinea  THEN DO:
    lDirTienda1 = SUBSTRING(lDirTienda,lCaracxlinea + 1).
    lDirTienda = SUBSTRING(lDirTienda,1,lCaracxlinea).
END.

lNroDocumento = "B".
lNombreDocumento = "BOLETA DE VENTA".
lCliente = "".

lDocCliente = IF (ccbcdocu.ruccli = ?) THEN "" ELSE trim(ccbcdocu.ruccli).
lDocCliente = IF (lDocCliente = "") THEN TRIM(ccbcdocu.codant) ELSE lDocCliente.
/*lDocCliente = IF (SUBSTRING(ccbcdocu.codcli,1,7) = "1111111") THEN "" ELSE lDocCliente.*/

IF TRIM(ccbcdocu.nomcli) <> ". ., ." THEN DO:
    lCliente = TRIM(ccbcdocu.nomcli).
END.
IF (ccbcdocu.codcli="11111111111") OR lDocCliente = "" THEN DO:
   lDocCliente =  "00000000".
END.

IF ccbcdocu.coddoc = 'FAC' THEN DO :
    lNombreDocumento = "FACTURA".
    lNroDocumento = "F".    
END.
IF ccbcdocu.coddoc = 'N/C' OR ccbcdocu.coddoc = 'N/D' THEN DO :
    lNombreDocumento = IF ( ccbcdocu.coddoc = 'N/C') THEN "NOTA DE CREDITO" ELSE "NOTA DE DEBITO".
    lNroDocumento = IF (ccbcdocu.codref = 'BOL') THEN "B" ELSE "F".    
    /* ------------------- */
   lDocReferencia   = fget-documento-origen(ccbcdocu.coddoc, ccbcdocu.nrodoc).    /*F001002233*/
   /* Tipo de Motivo */
   lTipoMotivo     = 'Otros Conceptos'.     

   /* Motivo */
   lMotivo   = IF (ccbcdocu.glosa = ?) THEN "ERROR EN EL REGISTRO DE LA INFORMACION" ELSE TRIM(ccbcdocu.glosa).
   IF ccbcdocu.cndcre <> 'D' THEN DO:
       FIND FIRST ccbtabla WHERE ccbtabla.codcia = s-codcia AND 
                                   ccbtabla.tabla = ccbcdocu.coddoc AND 
                                   ccbtabla.codigo = ccbcdocu.codcta
                                   NO-LOCK NO-ERROR.
       IF AVAILABLE ccbtabla THEN DO:
           IF ccbtabla.libre_c01 <> ? AND ccbtabla.libre_c01 <> '' THEN lMotivo = ccbtabla.libre_c01.
           /* Buscarlo en la tabla de la SUNAT  */
       END.
   END.

   /* Referencia */
   lFEmisDocRef    = fget-fecha-emision-ref(lDocReferencia). /*lDocumentoRef = F001002233*/
   lReferencia     = IF(SUBSTRING(lDocReferencia,1,1)="B") THEN "BOLETA DE VENTA ELECTRONICA"
                       ELSE "FACTURA ELECTRONICA".
   lReferencia1     = SUBSTRING(lDocReferencia,1,4) + " - " + SUBSTRING(lDocReferencia,5).
   lReferencia1     = lReferencia1 + " - " + IF(lFEmisDocRef = ?) THEN "" 
                                           ELSE STRING(lFEmisDocRef,"99/99/9999").

END.

IF LENGTH(lDocCliente)=8 THEN DO :
    lDocCliente = "DNI - " + lDocCliente.
END.
ELSE DO:
    lDocCliente = "RUC - " + lDocCliente.
END.

lNombreDocumento = lNombreDocumento + " ELECTRONICA".
lNroDocumento = lNroDocumento + SUBSTRING(ccbcdocu.nrodoc,1,3) + 
                    "-" + SUBSTRING(ccbcdocu.nrodoc,4).

/* QR codie */
/*RUN hash-barras(INPUT lCodHash).*/

lPathGraficoQR = "".
RUN code-qr (INPUT lDataQR, OUTPUT lPathGraficoQR).

lMoneda = IF (ccbcdocu.codmon = 2) THEN "US$" ELSE "S/".

/* 899 : Operaciones Gratuitas */
lOpeGratuitas = 0.
lTotalPagar = ccbcdocu.imptot.
IF ccbcdocu.fmapgo = '899' THEN DO:
    lOpeGratuitas = ccbcdocu.impbrt.
END.

/* EFECTIVO */
lTotRecibido = 0.
lFpagosx    = 0.

IF AVAILABLE ccbccaja THEN DO:
    IF TRIM(lMoneda) = 'S/' THEN DO:
        lFpagosx = IF (ccbccaja.impnac[1] > 0) THEN  ccbccaja.impnac[1] ELSE 0.
        lFpagosx = lFpagosx + IF (ccbccaja.impnac[5] > 0) THEN  ccbccaja.impnac[5] ELSE 0.
        lFpagosx = lFpagosx + IF (ccbccaja.impnac[7] > 0) THEN  ccbccaja.impnac[7] ELSE 0.
        lMonedaTxt = "SOLES".
    END.
    ELSE DO:
        lFpagosx = IF (ccbccaja.impusa[1] > 0) THEN  ccbccaja.impusa[1] ELSE 0.
        lFpagosx = lFpagosx + IF (ccbccaja.impusa[5] > 0) THEN  ccbccaja.impusa[5] ELSE 0.
        lFpagosx = lFpagosx + IF (ccbccaja.impusa[7] > 0) THEN  ccbccaja.impusa[7] ELSE 0.
        lMonedaTxt = "DOLARES".
        lFpagosx = lFpagosx * ccbccaja.tpocmb.
    END.
    lTotRecibido = lFpagosx.

    /* TARJETA */
    IF ccbccaja.impnac[4] > 0 THEN DO:
        lTotRecibido = lTotRecibido + ccbccaja.impnac[4] .
    END.
    /* NOTA DE CREDITO */
    lRefNotaCrededito = "".
    IF ccbccaja.impnac[6] > 0 THEN DO:
        /* Buscar la N/C */
        DEFINE BUFFER ix-ccbdmov FOR ccbdmov.
        FIND FIRST ix-ccbdmov WHERE ix-ccbdmov.codcia = s-codcia AND 
                                        ix-ccbdmov.codref = ccbccaja.coddoc AND 
                                        ix-ccbdmov.nroref = ccbccaja.nrodoc AND 
                                        ix-ccbdmov.coddoc = 'N/C' NO-LOCK NO-ERROR.
        IF AVAILABLE ix-ccbdmov THEN DO:
            lRefNotaCrededito = SUBSTRING(ix-ccbdmov.nrodoc,1,3) + "-" + 
                                 SUBSTRING(ix-ccbdmov.nrodoc,4) .
        END.
        RELEASE ix-ccbdmov.

        lTotRecibido = lTotRecibido + ccbccaja.impnac[6].
    END.
    /* VALES */
    IF ccbccaja.impnac[10] > 0 THEN DO:
        lTotRecibido = lTotRecibido + ccbccaja.impnac[10].
    END.
END.

lImpLetras = "".
lImpLetras1 = "".
lImpLetras = SUBSTRING(X-EnLetras,1,lCaracxlinea).
IF LENGTH(x-EnLetras) > lCaracxLinea THEN DO:
    lImpLetras1 = SUBSTRING(X-EnLetras,lCaracxlinea + 1).
END.

FIND FIRST _user WHERE _user._userid = ccbcdocu.usuario NO-LOCK NO-ERROR.

/* ------------------------------------------------------------------------------------ */
FOR EACH ccbddocu OF ccbcdocu NO-LOCK,
    FIRST almmmatg OF ccbddocu NO-LOCK ,
    FIRST facdpedi NO-LOCK WHERE Facdpedi.codcia = Ccbcdocu.codcia
    AND Facdpedi.coddoc = Ccbcdocu.codped
    AND Facdpedi.nroped = Ccbcdocu.nroped
    AND Facdpedi.codmat = ccbddocu.codmat
    BREAK BY Facdpedi.Libre_c05 BY Ccbddocu.NroItm:
    IF FIRST-OF(Facdpedi.Libre_c05) THEN DO:
        IF Facdpedi.Libre_c05 = 'OF' THEN DO:
            DISPLAY 'PROMOCIONES' SKIP.
        END.
    END.
    /*MESSAGE lPathGraficoQR.*/
    CREATE w-report.
    ASSIGN  w-report.task-no = s-task-no
            w-report.llave-c = Ccbcdocu.coddoc + Ccbcdocu.nrodoc 
            w-report.campo-c[1] = SUBSTRING(ccbddocu.codmat,1,6)
            w-report.campo-c[2] = SUBSTRING(almmmatg.desmat,1,40)
            w-report.campo-f[1] = ccbddocu.implin
            w-report.campo-c[3] = STRING(almmmatg.codbrr,'9999999999999')
            w-report.campo-c[4] = SUBSTRING(almmmatg.desmar,1,40)
            w-report.campo-c[5] = SUBSTRING(Ccbddocu.undvta,1,5)
            w-report.campo-f[2] = Ccbddocu.candes
            w-report.campo-f[3] = Ccbddocu.preuni
            w-report.campo-c[30] = lPathGraficoQR /* lHashCodePDF417*/ /*lCodHash*/
            w-report.campo-d[1] = ccbcdocu.fchdoc
            w-report.campo-c[6] = ccbcdocu.horcie
            w-report.campo-c[7] = ccbcdocu.coddiv
            w-report.campo-c[8] = lTelfTienda
            w-report.campo-c[9] = ccbcdocu.usuario + " " + IF(AVAILABLE _user) THEN _user._user-name ELSE ""
            w-report.campo-c[10] = lCliente
            w-report.campo-c[11] = lDocCliente.

    /* ARMAMOS LA LINEA DE DESCUENTOS */    
    IF Ccbddocu.Por_Dsctos[3] > 0 THEN DO:
        /*x-lin1A = FILL(" ",14).*/
        IF facdpedi.libre_c04 <> '' AND facdpedi.libre_c04 <> ?  THEN DO:
            IF facdpedi.libre_c04 = 'VOL'  THEN w-report.campo-c[29] = "DSCTO x VOLUM ". /*x-lin1A = "DSCTO x VOLUM ".*/
            IF facdpedi.libre_c04 = 'PROM' THEN w-report.campo-c[29] = "DSCTO PROMOC. ". /*x-lin1A = "DSCTO PROMOC. ".*/
        END.

        ASSIGN  w-report.campo-f[4] = Ccbddocu.Por_Dsctos[3]
                w-report.campo-f[5] = Ccbddocu.impdto.
    END.
    /* Datos de la cabecera y pie de pagina */
    ASSIGN  w-report.campo-f[6] = IF (ccbcdocu.porigv > 0) THEN ccbcdocu.impvta ELSE 0
            w-report.campo-f[7] = lOpeGratuitas
            w-report.campo-f[8] = ccbcdocu.impexo
            w-report.campo-f[9] = IF (ccbcdocu.porigv > 0) THEN 0 ELSE ccbcdocu.impvta
            w-report.campo-f[10] = ccbcdocu.impdto2
            w-report.campo-f[11] = ccbcdocu.impisc
            w-report.campo-f[12] = ccbcdocu.porigv
            w-report.campo-f[13] = ccbcdocu.impigv
            w-report.campo-f[14] = lTotalPagar
            w-report.campo-f[15] = lFpagosx 
            w-report.campo-c[12] = lMonedaTxt
            w-report.campo-f[16] = IF (AVAILABLE ccbccaja) THEN ccbccaja.tpocmb ELSE 0
            w-report.campo-f[17] = IF (AVAILABLE ccbccaja) THEN ccbccaja.impnac[4] ELSE 0            /* Tarjeta - Importe */
            w-report.campo-c[13] = IF (AVAILABLE ccbccaja) THEN TRIM(ccbccaja.voucher[9]) ELSE ""    /* Tarjeta - Nro */
            w-report.campo-f[18] = IF (AVAILABLE ccbccaja) THEN ccbccaja.impnac[6] ELSE 0           /* N/C - Importe */
            w-report.campo-c[14] = lRefNotaCrededito            /* N/C - Nro */
            w-report.campo-f[19] = IF (AVAILABLE ccbccaja) THEN ccbccaja.impnac[10] ELSE 0          /* Vales - Importe */
            w-report.campo-f[20] = IF (AVAILABLE ccbccaja) THEN ccbccaja.vuenac ELSE 0              /* Vuelto */
            w-report.campo-f[21] = lTotRecibido
            w-report.campo-c[15] = lImpLetras
            w-report.campo-c[16] = lImpLetras1
            w-report.campo-c[17] = IF (ccbcdocu.coddoc = 'N/C' OR ccbcdocu.coddoc = 'N/D') THEN ccbcdocu.coddoc ELSE ""
            w-report.campo-c[18] = lTipoMotivo
            w-report.campo-c[19] = lMotivo
            w-report.campo-c[20] = lReferencia
            w-report.campo-c[21] = lReferencia1
            /* campo-c[30 Y 29] esta ocupados */.
END.

RUN Graba-Log.

RUN enviar-impresion-termica.

SESSION:SET-WAIT-STATE('').

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Calcula-Promociones) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-Promociones Procedure 
PROCEDURE Calcula-Promociones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN.     /* NO VÁLIDA */

    DEFINE VARIABLE iDivision   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNroCupones AS INTEGER     NO-UNDO.
    x-promo01 = ''.
    x-promo02 = ''.

    iDivision = (ccbcdocu.imptot / 50).
    IF (INT(iDivision) > iDivision) THEN iDivision = INT(ccbcdocu.imptot / 50) - 1.
    ELSE iDivision = INT(iDivision).

    /*Numero de Vales*/    
    x-promo01 = STRING((iDivision) ,'99') + ' Ticket(s) de Sorteo'.
    /*Verifica cuantos*/
    FOR EACH b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia
        AND b-ccbcdocu.coddiv = s-coddiv 
        AND LOOKUP(b-ccbcdocu.coddoc,'FAC,BOL,TCK') > 0
        AND b-ccbcdocu.flgest <> 'A'
        /*AND b-ccbcdocu.codalm = s-codalm*/
        AND b-ccbcdocu.imptot >= 150.00
        AND b-ccbcdocu.fchdoc >= 01/01/2011 
        AND b-ccbcdocu.fchdoc <= 02/15/2011 NO-LOCK:
        iNroCupones = iNroCupones + 1.
    END.
    IF iNroCupones < 50 AND
        ccbcdocu.imptot >= 150.00 AND
        ccbcdocu.fchdoc >= 01/01/2011 AND
        ccbcdocu.fchdoc <= 02/15/2011 THEN x-promo02 = 'Una memoria KINGSTON de 4GB'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Code-qr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Code-qr Procedure 
PROCEDURE Code-qr :
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

tcText = sDataQR.
tcFile = SESSION:TEMP-DIRECTORY + ENTRY(3,tcText,"|") + "-" + ENTRY(4,tcText,"|") + "-" + ENTRY(9,tcText,"|") + ".jpg".
tnSize = 4.
tnType = 1.

sPathGraficoQR = "".

RUN SetConfiguration(INPUT tnSize, INPUT tnType, OUTPUT iReturn).
RUN GenerateFile(INPUT tcText, OUTPUT tcFile, OUTPUT iReturn).

sPathGraficoQR = tcFile.

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


PROCEDURE GenerateFile EXTERNAL "BarCodeLibrary.DLL":
        DEFINE INPUT PARAMETER p-cData AS CHARACTER.
        DEFINE OUTPUT PARAMETER p-cFileName AS CHARACTER.
        DEFINE RETURN PARAMETER p-iReturn AS LONG.
END PROCEDURE.

PROCEDURE SetConfiguration EXTERNAL "BarCodeLibrary.DLL":
    DEFINE INPUT PARAMETER p-nSize AS LONG.
    DEFINE INPUT PARAMETER p-nImageType AS LONG.
    DEFINE RETURN PARAMETER p-iReturn AS LONG.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enviar-impresion-termica) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviar-impresion-termica Procedure 
PROCEDURE enviar-impresion-termica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RB-INCLUDE-RECORDS = "O".

RB-FILTER = " w-report.task-no = " + STRING(s-task-no) +  
              " AND w-report.llave-c = '" + ccbcdocu.coddoc + ccbcdocu.nrodoc + "'".

RB-OTHER-PARAMETERS = "s-nomcia = CONTINENTAL SAC" +
                        "~npNombreTienda= " + lNombreTienda + 
                        "~npDirEmpresa = " + lDirEmpresa + 
                        "~npDirEmpresa2 = " + lDirEmpresa2 + 
                        "~npNombreDocumento = " + lNombreDocumento + 
                        "~npDirTienda = " + lDirTienda + 
                        "~npDirTienda1 = " + lDirTienda1 +
                        "~npDirTienda2 = " + lDirTienda2 +
                        "~npNroDocumento = " + lNroDocumento +
                        "~npMoneda = " + lMoneda .

DEFINE VARIABLE cDatabaseName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cHostName        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNetworkProto    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPortNumber      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cOtherParams     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNewConnString   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDelimeter       AS CHARACTER NO-UNDO.

GET-KEY-VALUE SECTION "RBParametros" KEY "cDatabaseName" VALUE cDatabaseName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cHostName" VALUE cHostName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cNetworkProto" VALUE cNetworkProto.
GET-KEY-VALUE SECTION "RBParametros" KEY "cPortNumber" VALUE cPortNumber.
GET-KEY-VALUE SECTION "RBParametros" KEY "cOtherParams" VALUE cOtherParams.

ASSIGN cDelimeter = CHR(32).
IF NOT (cDatabaseName = ? OR
   cHostName = ? OR
   cNetworkProto = ? OR
   cPortNumber = ?) THEN DO:
   ASSIGN
       cNewConnString =
       "-db" + cDelimeter + cDatabaseName + cDelimeter +
       "-H" + cDelimeter + cHostName + cDelimeter +
       "-N" + cDelimeter + cNetworkProto + cDelimeter +
       "-S" + cDelimeter + cPortNumber + cDelimeter.
   RB-DB-CONNECTION = cNewConnString.
END.


ASSIGN
      RB-REPORT-NAME = "ticket venta electronico"
      RB-BEGIN-PAGE = s-pagina-inicial
      RB-END-PAGE = s-pagina-final
      RB-PRINTER-NAME = s-printer-name
      RB-OUTPUT-FILE = s-print-file
      RB-NUMBER-COPIES = s-nro-copias.
  CASE s-salida-impresion:
      WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
      WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
      WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
  END CASE.

  RUN aderb/_prntrb2 (RB-REPORT-LIBRARY,
                      RB-REPORT-NAME,
                      RB-DB-CONNECTION,
                      RB-INCLUDE-RECORDS,
                      RB-FILTER,
                      RB-MEMO-FILE,
                      RB-PRINT-DESTINATION,
                      RB-PRINTER-NAME,
                      RB-PRINTER-PORT,
                      RB-OUTPUT-FILE,
                      RB-NUMBER-COPIES,
                      RB-BEGIN-PAGE,
                      RB-END-PAGE,
                      RB-TEST-PATTERN,
                      RB-WINDOW-TITLE,
                      RB-DISPLAY-ERRORS,
                      RB-DISPLAY-STATUS,
                      RB-NO-WAIT,
                      RB-OTHER-PARAMETERS,
                      "").

/* Borar el temporal */

DEF BUFFER B-w-report FOR w-report.
DEFINE VAR lRowId AS ROWID.

FOR EACH w-report WHERE w-report.task-no = s-task-no NO-LOCK:
    lRowId = ROWID(w-report).
    FIND FIRST b-w-report WHERE ROWID(b-w-report) = lRowid EXCLUSIVE NO-ERROR.
    IF AVAILABLE b-w-report THEN DO:
        DELETE b-w-report.            
    END.    
END.
RELEASE B-w-report.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Graba-Log) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Log Procedure 
PROCEDURE Graba-Log :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF pVersion = "C" THEN DO:
    RUN lib/logtabla ("ccbcdocu",ccbcdocu.coddoc + '|' + ccbcdocu.nrodoc, "REIMPRESION").
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-grabar-log-errores) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-log-errores Procedure 
PROCEDURE grabar-log-errores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH T-FeLogErrores:
    CREATE FeLogErrores.
    BUFFER-COPY T-FeLogErrores TO FeLogErrores NO-ERROR.
    DELETE T-FeLogErrores.
END.
IF AVAILABLE(FeLogErrores) THEN RELEASE FeLogErrores.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hash-barras) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hash-barras Procedure 
PROCEDURE hash-barras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER sCodHash AS CHAR NO-UNDO.
    
    lHashCodePDF417 = "".

    DEFINE VAR lRetPdf417 AS CHAR.
    DEFINE VAR lFilas AS INT.
    DEFINE VAR lColumnas AS INT.
    DEFINE VAR lstrPDF417 AS CHAR.
    DEFINE VAR lAscii AS INT.
    DEFINE VAR lSec AS INT.
    DEFINE VAR lSec2 AS INT.
    DEFINE VAR lRetVal AS INT.
    DEFINE VAR sRetVal AS CHAR.

    DEFINE VAR lMode AS INT INIT 2.
    DEFINE VAR lErrorCorrLeve AS INT INIT 5.
    DEFINE VAR lRows AS INT INIT 3.
    DEFINE VAR lColumns AS INT INIT 5.
    DEFINE VAR lTruncateSymbol AS INT INIT 0.
    DEFINE VAR lHandleTilde AS INT INIT 1.

    RUN PDF417Encode (INPUT sCodHash, INPUT lMode, INPUT lErrorCorrLeve, INPUT lRows, INPUT lColumns, INPUT lTruncateSymbol, INPUT lHandleTilde, OUTPUT lRetVal).    
    RUN PDF417GetCols(OUTPUT lColumnas).
    RUN PDF417GetRows(OUTPUT lFilas).
    /*MESSAGE lRetVal lFilas lColumnas.*/

    lstrPDF417 = "".
    REPEAT lSec = 0 TO lFilas - 1 :
        REPEAT lSec2 = 0 TO lColumnas - 1 :
            RUN PDF417GetCharAt(INPUT lSec, INPUT lSec2, OUTPUT lAscii).
            /*lstrPDF417 = lstrPDF417 + CHR(lAscii).*/
            lHashCodePDF417 = lHashCodePDF417 + CHR(lAscii).
        END.
    END.
    /*sHashBarras = lstrPDF417.*/

     RELEASE EXTERNAL PROCEDURE "PDF417font.dll" .

END PROCEDURE.

PROCEDURE PDF417Encode EXTERNAL "PDF417font.dll" PERSISTENT :
    DEFINE INPUT PARAMETER sCode AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER iMode AS LONG NO-UNDO.
    DEFINE INPUT PARAMETER iErrorCorrectionLevel AS LONG NO-UNDO.
    DEFINE INPUT PARAMETER iRows AS LONG NO-UNDO.
    DEFINE INPUT PARAMETER iColumns AS LONG NO-UNDO.
    DEFINE INPUT PARAMETER iTruncateSymbol AS LONG NO-UNDO.
    DEFINE INPUT PARAMETER iHandleTilde AS LONG NO-UNDO.
    DEFINE RETURN PARAMETER iValor AS LONG.
END PROCEDURE.

PROCEDURE PDF417GetCharAt EXTERNAL "PDF417font.dll"  PERSISTENT :
    DEFINE INPUT PARAMETER iRowIndex AS LONG NO-UNDO.
    DEFINE INPUT PARAMETER iColIndex AS LONG NO-UNDO.
    DEFINE RETURN PARAMETER sRetVal AS LONG NO-UNDO.
END PROCEDURE.

PROCEDURE PDF417GetCols EXTERNAL "PDF417font.dll"  PERSISTENT :
    DEFINE RETURN PARAMETER iValor AS LONG NO-UNDO.
END PROCEDURE.

PROCEDURE PDF417GetRows EXTERNAL "PDF417font.dll"  PERSISTENT :
    DEFINE RETURN PARAMETER iValor AS LONG NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-fCentrado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCentrado Procedure 
FUNCTION fCentrado RETURNS CHARACTER
  ( INPUT pDatos AS CHAR, INPUT pWidth AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lDato AS CHAR.
    DEFINE VAR lRetVal AS CHAR.                                                
    DEFINE VAR lLenDato AS INT.

    lDato = TRIM(pdatos).
    lLenDato = LENGTH(lDato).
    IF LENGTH(lDato) <= pWidth THEN DO:
        lRetVal = FILL(" ", INTEGER(pWidth / 2) - INTEGER(lLenDato / 2) ) + lDato.
    END.
    ELSE lRetVal = SUBSTRING(lDato,1,pWidth).

  RETURN lRetVal.          

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fCentrar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCentrar Procedure 
FUNCTION fCentrar RETURNS INTEGER
    ( INPUT pDatos AS CHAR, INPUT pWidth AS INT ) :
  /*------------------------------------------------------------------------------
    Purpose:  
      Notes:  
  ------------------------------------------------------------------------------*/

      DEFINE VAR lDato AS CHAR.
      DEFINE VAR lRetVal AS INT.

      lDato = TRIM(pdatos).
      IF LENGTH(lDato) < pWidth THEN DO:
          lRetVal = INTEGER(pWidth / 2) - INTEGER(LENGTH(lDato) / 2).
      END.
      ELSE lRetVal = 1.

    RETURN lRetVal.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-documento-origen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-documento-origen Procedure 
FUNCTION fget-documento-origen RETURNS CHARACTER
  ( INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Se debe enviar N/C o N/D
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR lRetVal AS CHAR.

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
        IF fx-ccbcdocu.codref = 'FAC' OR fx-ccbcdocu.codref = 'BOL' OR 
                fx-ccbcdocu.codref = 'TCK' THEN DO:

            IF fx-ccbcdocu.codref = 'FAC' THEN lRetVal = 'F' + fx-ccbcdocu.nroref.
            IF fx-ccbcdocu.codref = 'BOL' OR fx-ccbcdocu.codref = 'TCK' THEN lRetVal = 'B' + fx-ccbcdocu.nroref.        

        END.
        ELSE DO:
            IF fx-ccbcdocu.codref = 'LET' THEN DO:
                /* No deberia darse, pero x siaca */
                lRetVal = fget-documento-origen(fx-ccbcdocu.codref, fx-ccbcdocu.nroref).
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
                        lRetVal = fget-documento-origen("LET", lDocLetra).
                    END.
                    ELSE DO:
                        IF lDocBoleta  <> "" THEN lRetVal = lDocBoleta.
                        IF lDocFactura  <> "" THEN lRetVal = lDocFactura.
                    END.
                END.
                /* 
                    Puede que hayan CLA : Canje x letra adelantada, pero el dia que salte ese error
                    ya se programa...
                */
            END.
        END.
    END.

    RELEASE fx-ccbcdocu.
    RELEASE fx-ccbdmvto.

    RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-fecha-emision-ref) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-fecha-emision-ref Procedure 
FUNCTION fget-fecha-emision-ref RETURNS DATE
  (INPUT lxDoctoRef AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
/* Fecha de Emision de la referencia */
DEFINE VAR lxCodRef AS CHAR INIT "".
DEFINE VAR lxNroRef AS CHAR INIT "".
DEFINE VAR lxlDate AS DATE INIT ?.

IF SUBSTRING(lxDoctoRef,1,1)="F" THEN DO:
    lxCodRef = 'FAC'.
END.
lxNroRef = SUBSTRING(lxDoctoRef,2,3) + SUBSTRING(lxDoctoRef,5).

DEFINE BUFFER ix-ccbcdocu FOR ccbcdocu.

/* Lo busco como FACTURA */
FIND FIRST ix-ccbcdocu WHERE ix-ccbcdocu.codcia = s-codcia AND 
                                ix-ccbcdocu.coddoc = lxCodRef AND 
                                ix-ccbcdocu.nrodoc = lxNroRef
                                NO-LOCK NO-ERROR.
IF NOT AVAILABLE ix-ccbcdocu THEN DO:
    IF SUBSTRING(lxDoctoRef,1,1)="B" THEN DO:
        /* Lo busco como BOLETA */
        lxCodRef = 'BOL'.
        FIND FIRST ix-ccbcdocu WHERE ix-ccbcdocu.codcia = s-codcia AND 
                                        ix-ccbcdocu.coddoc = lxCodRef AND 
                                        ix-ccbcdocu.nrodoc = lxNroRef
                                        NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ix-ccbcdocu THEN DO:
            /* Lo busco como TICKET */
            lxCodRef = 'TCK'.
            FIND FIRST ix-ccbcdocu WHERE ix-ccbcdocu.codcia = s-codcia AND 
                                            ix-ccbcdocu.coddoc = lxCodRef AND 
                                            ix-ccbcdocu.nrodoc = lxNroRef
                                            NO-LOCK NO-ERROR.
        END.
    END.
END.

IF AVAILABLE ix-ccbcdocu THEN DO:
    lxlDate = ix-ccbcdocu.fchdoc.
END.

RELEASE ix-ccbcdocu.

RETURN lxlDate.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

