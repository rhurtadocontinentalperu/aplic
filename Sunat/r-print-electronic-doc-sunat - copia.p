&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-ccbcdocu FOR CcbCDocu.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.
DEFINE BUFFER x-ccbccaja FOR CcbCCaja.
DEFINE BUFFER x-ccbcdocu FOR CcbCDocu.
DEFINE BUFFER x-ccbdcaja FOR CcbDCaja.
DEFINE BUFFER x-felogerrores FOR FELogErrores.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : r-bole01.p
    Purpose     : Impresion de Fact/Boletas 
    Syntax      : xxxxxxxxxxxx
    Description :
    Author(s)   :
    Created     :
    Notes       : SOLO PARA VENTAS MAYORISTAS 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-user-id AS CHAR.
/*DEF SHARED VAR s-coddiv  AS CHAR.*/

DEFINE SHARED VAR pRCID AS INT.

DEFINE STREAM log-epos.

/* Definimos REPORT BUILDER */
DEFINE VAR s-task-no AS INT NO-UNDO.

DEF VAR RB-REPORT-LIBRARY AS CHAR.
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "ticket comprobante electronico".
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

/* Variable para la impresión */
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
DEFINE VAR lDirCliente AS CHAR.
DEFINE VAR lDirCliente1 AS CHAR.

DEFINE VAR lHashCodePDF417 AS LONGCHAR.
DEFINE VAR lMoneda AS CHAR.
DEFINE VAR lSignoMoneda AS CHAR.
/* QR */
DEFINE VAR lPathGraficoQR AS CHAR FORMAT 'x(200)'.
DEFINE VAR lDataQR AS CHAR FORMAT 'x(255)'.
DEFINE VAR lOrdenCompra AS CHAR.

/* paginas */
DEFINE VAR lTotItems AS INT.
DEFINE VAR lItemsxPagina AS INT.
DEFINE VAR lxTotPags AS INT.
DEFINE VAR lTotPags AS INT.
DEFINE VAR lLineasTotales AS INT.

DEFINE VAR lDigitoVerificador AS INT.

/* Anticipos */
DEFINE VAR x-anticipo1 AS CHAR.
DEFINE VAR x-anticipo2 AS CHAR.
DEFINE VAR x-anticipo3 AS CHAR.
DEFINE VAR x-anticipo4 AS CHAR.
DEFINE VAR x-anticipo-vvta AS DEC.
DEFINE VAR x-anticipo-igv AS DEC.
DEFINE VAR x-anticipo-total AS DEC.
DEFINE VAR x-operaciones-gravadas AS DEC.
DEFINE VAR x-total-igv AS DEC.
DEFINE VAR x-total-a-pagar AS DEC.
DEFINE VAR x-anticipo AS CHAR.

DEFINE VAR lFiler1 AS CHAR.
DEFINE VAR lTotRecibido AS DEC.
DEFINE VAR lFpagosx AS DEC.
DEFINE VAR lCajera AS CHAR.
DEFINE VAR x-Lineas AS INT.
DEFINE VAR x-LinxArt AS INT.
DEFINE VAR x-codbrr  AS CHARACTER   NO-UNDO FORMAT 'X(60)'.
DEFINE VAR lCodHash AS CHAR INIT "".
DEFINE VAR x-reimpresion AS CHAR INIT "".
DEFINE VAR x-tienda-nro AS CHAR INIT "".
DEFINE VAR lOpeGratuitas AS DEC.
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
DEFINE VAR lOrdenDespacho AS CHAR INIT "" NO-UNDO.

DEFINE VAR x-retval AS CHAR.
DEFINE VAR x-enviar-guia-remision AS LOG.

DEFINE VAR cImprimeDirecto AS CHAR INIT "No" NO-UNDO. 
DEFINE VAR lCaracxlinea AS INT INIT 45.  /* Valido para impresion de Ticket */
DEFINE VAR X-EnLetras AS CHAR FORMAT "x(60)" NO-UNDO.

DEFINE VAR x-filer AS CHAR.
DEFINE VAR x-electronica AS CHAR INIT "ELECTRONICA".
DEFINE VAR x-version AS CHAR.

DEFINE VAR lGuia AS CHAR INIT "".
DEFINE VAR lPedido AS CHAR INIT "".
DEFINE VAR lFmaPgo AS CHAR INIT "".

DEF VAR X-Cheque   AS CHAR    NO-UNDO.
/*MLR* 28/12/07 ***/
DEF VAR cNroIC LIKE CcbDCaja.Nrodoc NO-UNDO.
DEF VAR X-CANCEL   AS CHAR FORMAT "X(10)".
DEF VAR X-SOL      AS DECI INIT 0.
DEF VAR X-DOL      AS DECI INIT 0.
DEF VAR X-VUE      AS DECI INIT 0.
DEF VAR x-TarCreSol AS DEC INIT 0 NO-UNDO.
DEF VAR x-TarCreDol AS DEC INIT 0 NO-UNDO.

/* Para GRE */
DEFINE BUFFER x-gre_header FOR gre_header.
DEFINE BUFFER x-gre_detail FOR gre_detail.
DEFINE BUFFER x-almacen FOR almacen.
DEFINE BUFFER x-ccbadocu FOR ccbadocu.

DEFINE BUFFER b-w-report FOR w-report.

DEFINE VAR pError AS CHAR.
DEFINE VAR cTextoQR AS LONGCHAR.
DEFINE VAR cPathGraficoQR AS CHAR.
DEFINE VAR cTextoResolucionSunat AS CHAR.

DEFINE VAR cOrden AS CHAR.
DEFINE VAR cOrdenLabel AS CHAR.
DEFINE VAR cOrdenRef AS CHAR.
DEFINE VAR cOrdenRefLabel AS CHAR.

DEFINE VAR cAgenciaTransporte AS CHAR.
DEFINE VAR cDireccionEntrega AS CHAR.
DEFINE VAR cObservaciones AS CHAR.
DEFINE VAR cObservacionDeEnvio AS CHAR.
DEFINE VAR cContacto AS CHAR.
DEFINE VAR cHora AS CHAR.
DEFINE VAR cCopia AS CHAR.
DEFINE VAR cCopias AS CHAR.
DEFINE VAR cSerieNumeroGRE AS CHAR.
DEFINE VAR cMensajeAdicional AS CHAR.
DEFINE VAR cUsuarioImpresion AS CHAR.
DEFINE VAR cCrossDocking AS CHAR.
DEFINE VAR cAlmacenDestino AS CHAR.

DEFINE TEMP-TABLE tTagsEstadoDoc
    FIELD   cTag    AS  CHAR    FORMAT 'x(100)'
    FIELD   cValue  AS  CHAR    FORMAT 'x(255)'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-PRINT_fget-data-qr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD PRINT_fget-data-qr Procedure 
FUNCTION PRINT_fget-data-qr RETURNS CHARACTER ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_fget-descripcion-articulo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD PRINT_fget-descripcion-articulo Procedure 
FUNCTION PRINT_fget-descripcion-articulo RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR, INPUT pCodDoc AS CHAR, INPUT pCondCred AS CHAR, INPUT pTipoFac AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_fget-documento-origen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD PRINT_fget-documento-origen Procedure 
FUNCTION PRINT_fget-documento-origen RETURNS CHARACTER
  ( INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_fget-fecha-emision-ref) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD PRINT_fget-fecha-emision-ref Procedure 
FUNCTION PRINT_fget-fecha-emision-ref RETURNS DATE
  (INPUT lxDoctoRef AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_fget-prefijo-serie) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD PRINT_fget-prefijo-serie Procedure 
FUNCTION PRINT_fget-prefijo-serie RETURNS CHARACTER
      (INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR, INPUT pDivision AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_flog-epos-txt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD PRINT_flog-epos-txt Procedure 
FUNCTION PRINT_flog-epos-txt RETURNS CHARACTER
  (INPUT pTexto AS CHAR)  FORWARD.

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
      TABLE: b-ccbcdocu B "?" ? INTEGRAL CcbCDocu
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
      TABLE: x-ccbccaja B "?" ? INTEGRAL CcbCCaja
      TABLE: x-ccbcdocu B "?" ? INTEGRAL CcbCDocu
      TABLE: x-ccbdcaja B "?" ? INTEGRAL CcbDCaja
      TABLE: x-felogerrores B "?" ? INTEGRAL FELogErrores
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 18.04
         WIDTH              = 67.86.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-getValueTag) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValueTag Procedure 
PROCEDURE getValueTag :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pContent AS LONGCHAR.
    DEFINE INPUT PARAMETER pTagInicial AS CHAR.
    DEFINE INPUT PARAMETER ptagFinal AS CHAR.
    DEFINE OUTPUT PARAMETER pRetVal AS LONGCHAR.

    DEFINE VAR iPosInicial AS INT.
    DEFINE VAR iPosFinal AS INT.

    iPosInicial = INDEX(pContent,pTagInicial).
    IF iPosInicial > 0 THEN DO:
        iPosFinal = INDEX(pContent,pTagFinal).
        IF iPosFinal > 0 THEN DO:
            pRetVal = SUBSTRING(pContent,iPosInicial + LENGTH(pTagInicial),(iPosFinal - (iPosInicial + LENGTH(pTagInicial))) ).
        END.
        ELSE DO:
            pRetVal = SUBSTRING(pContent,iPosInicial + LENGTH(pTagInicial) ).
        END.

        pRetVal = TRIM(pRetVal).

        IF pRetVal = ? THEN pRetVal = "".
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_Anticipos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRINT_Anticipos Procedure 
PROCEDURE PRINT_Anticipos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

x-anticipo1 = "".
x-anticipo2 = "".
x-anticipo3 = "".
x-anticipo4 = "".

x-anticipo-vvta = 0.
x-anticipo-igv = 0.
x-anticipo-total = 0.

DEFINE VAR x-retval AS CHAR.
DEFINE VAR x-sec AS INT.
DEFINE VAR x-hMaster AS HANDLE NO-UNDO.

IF (ccbcdocu.coddoc = 'FAC' OR ccbcdocu.coddoc = 'BOL') THEN DO:
    RUN gn/master-library.r PERSISTENT SET x-hMaster.

    RUN anticipos-aplicados-despacho IN x-hMaster (INPUT ccbcdocu.coddoc,
                                                   INPUT ccbcdocu.nrodoc,
                                                   OUTPUT x-retval).
    DELETE PROCEDURE x-hMaster.

    REPEAT x-sec = 1 TO NUM-ENTRIES(x-retval,"*"):
        x-anticipo = TRIM(ENTRY(x-sec,x-retval,"*")).
        IF x-sec = 1 THEN x-anticipo1 = ENTRY(x-sec,x-retval,"*").
        IF x-sec = 2 THEN x-anticipo2 = ENTRY(x-sec,x-retval,"*").
        IF x-sec = 3 THEN x-anticipo3 = ENTRY(x-sec,x-retval,"*").
        IF x-sec = 4 THEN x-anticipo4 = ENTRY(x-sec,x-retval,"*").
        x-anticipo-vvta = x-anticipo-vvta + DECIMAL(TRIM(ENTRY(9,x-anticipo,"|"))).
        x-anticipo-igv = x-anticipo-igv + DECIMAL(TRIM(ENTRY(10,x-anticipo,"|"))).
        x-anticipo-total = x-anticipo-total + DECIMAL(TRIM(ENTRY(7,x-anticipo,"|"))).
    END.
END.
/* 21/03/2023: */
x-operaciones-gravadas  = Ccbcdocu.TotalValorVentaNetoOpGravadas.
x-total-igv             = CcbCDocu.TotalIGV.
x-total-a-pagar         = Ccbcdocu.TotalVenta.
/*x-operaciones-gravadas = ccbcdocu.impvta.*/
/*x-total-igv = ccbcdocu.impigv.*/
/*x-total-a-pagar = ccbcdocu.imptot.*/
IF x-anticipo-total > 0 THEN DO:
    x-anticipo-vvta = IF( x-anticipo-vvta >= x-operaciones-gravadas) THEN x-operaciones-gravadas ELSE x-anticipo-vvta.
    x-operaciones-gravadas = x-operaciones-gravadas - x-anticipo-vvta.
    x-total-igv = x-total-igv - x-anticipo-igv.
    x-total-a-pagar = x-total-a-pagar - x-anticipo-total.
    IF x-total-a-pagar < 0 THEN x-total-a-pagar = 0.
    IF x-total-igv < 0 OR x-total-a-pagar = 0 THEN x-total-igv = 0.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_Carga-Impresion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRINT_Carga-Impresion Procedure 
PROCEDURE PRINT_Carga-Impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pVersion AS CHAR.
DEFINE INPUT PARAMETER pFormatoTck AS LOG.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.

x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (INICIO) : "  + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (Cargando data) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

/* ******************************************************************************************************** */
/* creo el temporal */ 
/* ******************************************************************************************************** */
REPEAT:
    s-task-no = RANDOM(1, 999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK) THEN DO:
        CREATE w-report.
        ASSIGN w-report.task-no = s-task-no.
        LEAVE.
    END.
END.
/* ******************************************************************************************************** */
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
ELSE DO:
    lDataQR = PRINT_fget-data-qr().
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
        lTelfTienda     = gn-divi.teldiv
        cImprimeDirecto = GN-DIVI.Campo-Char[7].    /* OJO */

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
IF TRIM(ccbcdocu.nomcli) <> ". ., ." THEN DO:
    lCliente = TRIM(ccbcdocu.nomcli).
END.
IF TRUE <> (lDocCliente > "") THEN DO:
   lDocCliente =  "00000000".
END.
lDirCliente = TRIM(ccbcdocu.dircli).
IF LENGTH(lDirCliente) > 50 THEN DO:    
    lDirCliente1 = SUBSTRING(lDirCliente,51).
    lDirCliente = SUBSTRING(lDirCliente,1,50).
END.
IF ccbcdocu.coddoc = 'FAC' THEN DO :
    lNombreDocumento = "FACTURA".
    lNroDocumento = "F".    
END.
IF ccbcdocu.coddoc = 'N/C' OR ccbcdocu.coddoc = 'N/D' THEN DO :
    lNombreDocumento = IF ( ccbcdocu.coddoc = 'N/C') THEN "NOTA DE CREDITO" ELSE "NOTA DE DEBITO".
    lNroDocumento = IF (ccbcdocu.codref = 'BOL') THEN "B" ELSE "F".    
    /* ------------------- */
   lDocReferencia   = PRINT_fget-documento-origen(ccbcdocu.coddoc, ccbcdocu.nrodoc).    /*F001002233*/
   /* Tipo de Motivo */
   lTipoMotivo     = 'OTROS CONCEPTOS'.     

   /* Motivo */
   lMotivo   = IF (ccbcdocu.glosa = ?) THEN "POR ERROR EN EL REGISTRO DE LA INFORMACION" ELSE TRIM(ccbcdocu.glosa).
   IF ccbcdocu.cndcre <> 'D' THEN DO:
       FIND FIRST ccbtabla WHERE ccbtabla.codcia = s-codcia AND 
           ccbtabla.tabla = ccbcdocu.coddoc AND 
           ccbtabla.codigo = ccbcdocu.codcta
           NO-LOCK NO-ERROR.
       IF AVAILABLE ccbtabla THEN DO:
           IF ccbtabla.libre_c01 <> ? AND ccbtabla.libre_c01 <> '' THEN lTipoMotivo = ccbtabla.libre_c01.
           /* Buscarlo en la tabla de la SUNAT  */
           CASE Ccbcdocu.CodDoc:
               WHEN 'N/C' THEN DO:
                   FIND Pl-Tabla WHERE Pl-Tabla.CodCia = 000 AND 
                       Pl-Tabla.Tabla = "66" AND 
                       Pl-Tabla.Codigo = Ccbtabla.Libre_c01 NO-LOCK NO-ERROR.
                   IF AVAILABLE Pl-Tabla THEN lTipoMotivo = CAPS(Pl-Tabla.Nombre).
               END.
               WHEN 'N/D' THEN DO:
                   FIND Pl-Tabla WHERE Pl-Tabla.CodCia = 000 AND 
                       Pl-Tabla.Tabla = "67" AND 
                       Pl-Tabla.Codigo = Ccbtabla.Libre_c01 NO-LOCK NO-ERROR.
                   IF AVAILABLE Pl-Tabla THEN lTipoMotivo = CAPS(Pl-Tabla.Nombre).
               END.
               OTHERWISE DO:
                   IF lTipoMotivo = '01' THEN lTipoMotivo = 'ANULACION DE LA OPERACION'.
                   IF lTipoMotivo = '02' THEN lTipoMotivo = 'ANULACION POR ERROR EN EL RUC'.
                   IF lTipoMotivo = '03' THEN lTipoMotivo = 'CORRECCION POR ERROR EN LA DESCRIPCION'.
                   IF lTipoMotivo = '04' THEN lTipoMotivo = 'DESCUENTO GLOBAL'.
                   IF lTipoMotivo = '05' THEN lTipoMotivo = 'DESCUENTO POR ITEM'.
                   IF lTipoMotivo = '06' THEN lTipoMotivo = 'DEVOLUCION TOTAL'.
                   IF lTipoMotivo = '07' THEN lTipoMotivo = 'DEVOLUCION POR ITEM'.
                   IF lTipoMotivo = '08' THEN lTipoMotivo = 'BONIFICACION'.
                   IF lTipoMotivo = '09' THEN lTipoMotivo = 'DISMINUCION EN EL VALOR'.
                   IF lTipoMotivo = '10' THEN lTipoMotivo = 'OTROS CONCEPTOS'.
               END.
           END CASE.
       END.
   END.

   /* Referencia */
   lFEmisDocRef    = PRINT_fget-fecha-emision-ref(lDocReferencia). /*lDocumentoRef = F001002233*/
   lReferencia     = IF(SUBSTRING(lDocReferencia,1,1)="B") THEN "BOLETA DE VENTA ELECTRONICA"
                       ELSE "FACTURA ELECTRONICA".
   lReferencia1     = SUBSTRING(lDocReferencia,1,4) + " - " + SUBSTRING(lDocReferencia,5).
   lReferencia1     = lReferencia1 + " - " + IF(lFEmisDocRef = ?) THEN "" 
                                           ELSE STRING(lFEmisDocRef,"99/99/9999").
END.

x-operaciones-gravadas = Ccbcdocu.TotalValorVentaNetoOpGravadas.
x-total-igv = Ccbcdocu.TotalIGV.
x-total-a-pagar = Ccbcdocu.TotalVenta.

/* 23/02/2023 Datos de la O/M */
lOrdenDespacho = "".
IF LOOKUP(Ccbcdocu.coddoc, "FAC,BOL") > 0 AND Ccbcdocu.Libre_c01 = "O/M"
    THEN lOrdenDespacho = Ccbcdocu.Libre_c01 + " " + Ccbcdocu.Libre_c02.

/* ******************************************************************************************************** */
/* Anticipos, en este procedimiento puede modificar */
/* ******************************************************************************************************** */
RUN PRINT_Anticipos.
/* ******************************************************************************************************** */
RUN lib/_numero(x-total-a-pagar, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = "SON : " + X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " SOLES" ELSE " DOLARES AMERICANOS").

/* Digito verificador del cliente antes de anteponerle RUC ¢ DNI*/
RUN lib/calcula-digito-verificador (INPUT lDocCliente, OUTPUT lDigitoVerificador).

IF LENGTH(lDocCliente) = 8 THEN DO :
    lDocCliente = "DNI - " + lDocCliente.
END.
ELSE DO:
    lDocCliente = "RUC - " + lDocCliente.
END.

/* Guia Remision */
IF (ccbcdocu.coddoc = 'N/C' OR ccbcdocu.coddoc = 'N/D') THEN DO:
    /**/
END.
ELSE DO:
    RUN PRINT_consignar-guia-remision (INPUT ccbcdocu.divori, OUTPUT lGuia).
END.

lPedido = IF (ccbcdocu.coddoc = 'N/C' OR ccbcdocu.coddoc = 'N/D') THEN "" ELSE ccbcdocu.codped + " - " + ccbcdocu.nroped.
lFmaPgo = IF (AVAILABLE gn-convt) THEN TRIM(gn-convt.nombr) ELSE "".
lMoneda = IF (ccbcdocu.codmon = 2) THEN "DOLARES AMERICANOS" ELSE "SOLES".
lSignoMoneda = IF (ccbcdocu.codmon = 2) THEN "$" ELSE "S/".

lNombreDocumento = lNombreDocumento.
lNroDocumento = lNroDocumento + SUBSTRING(ccbcdocu.nrodoc,1,3) + "-" + SUBSTRING(ccbcdocu.nrodoc,4).

lOrdenCompra = "".
IF ccbcdocu.NroOrd <> ? AND ccbcdocu.NroOrd <> '' THEN DO:
    lOrdenCompra = "O.COMPRA :" + TRIM(ccbcdocu.NroOrd).
END.
/* ******************************************************************************************************** */
/* QR Code */
/* ******************************************************************************************************** */
lPathGraficoQR = "".
RUN PRINT_code-qr (INPUT lDataQR, OUTPUT lPathGraficoQR).
/* ******************************************************************************************************** */
lMoneda = IF (ccbcdocu.codmon = 2) THEN "US$" ELSE "S/".
/* 899 : Operaciones Gratuitas */
lOpeGratuitas = Ccbcdocu.TotalValorVentaNetoOpGratuitas.
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
        IF AVAILABLE ix-ccbdmov THEN lRefNotaCrededito = SUBSTRING(ix-ccbdmov.nrodoc,1,3) + "-" + SUBSTRING(ix-ccbdmov.nrodoc,4) .
        lTotRecibido = lTotRecibido + ccbccaja.impnac[6].
    END.
    /* VALES */
    IF ccbccaja.impnac[10] > 0 THEN lTotRecibido = lTotRecibido + ccbccaja.impnac[10].
END.

lImpLetras = "".
lImpLetras1 = "".
lImpLetras = X-EnLetras.
IF pFormatoTck = YES THEN DO:
    lImpLetras = SUBSTRING(X-EnLetras,1,lCaracxlinea).
    IF LENGTH(x-EnLetras) > lCaracxLinea THEN lImpLetras1 = SUBSTRING(X-EnLetras,lCaracxlinea + 1).
END.

FIND FIRST _user WHERE _user._userid = ccbcdocu.usuario NO-LOCK NO-ERROR.

lTotItems = 0.

/* ******************************************************************************************************** */
/* Ic - 25Nov2019, imprimir en el documento electronico descuento logistico*/
/* ******************************************************************************************************** */
RUN PRINT_otros-descuentos (OUTPUT x-retval).
/* ******************************************************************************************************** */

DEFINE VAR lxDescripcion AS CHAR.
DEFINE VAR lxDesMat AS CHAR.
DEFINE VAR lxDesMar AS CHAR.
DEFINE VAR x-dscto1 AS DEC.

FOR EACH ccbddocu OF ccbcdocu NO-LOCK BREAK BY Ccbddocu.NroItm:
    FIND FIRST almmmatg OF ccbddocu NO-LOCK NO-ERROR.
    FIND FIRST facdpedi WHERE Facdpedi.codcia = Ccbcdocu.codcia AND Facdpedi.coddoc = Ccbcdocu.codped
        AND Facdpedi.nroped = Ccbcdocu.nroped AND Facdpedi.codmat = ccbddocu.codmat NO-LOCK NO-ERROR.
    lxDescripcion = PRINT_fget-descripcion-articulo(ccbddocu.codmat, ccbcdocu.coddoc, ccbcdocu.cndcre, ccbcdocu.tpofac).
    lxDesMat = ENTRY(1,lxDescripcion,"|").
    lxDesMar = ENTRY(2,lxDescripcion,"|").
    CREATE w-report.
    ASSIGN  
        w-report.task-no = s-task-no
        w-report.llave-c = Ccbcdocu.coddoc + Ccbcdocu.nrodoc
        w-report.campo-c[1] = SUBSTRING(ccbddocu.codmat,1,6)
        w-report.campo-c[2] = SUBSTRING(lxDesMat,1,40) /*SUBSTRING(almmmatg.desmat,1,40)*/
        /*w-report.campo-f[1] = CcbDDocu.MontoBaseIGV + CcbDDocu.ImporteIGV*/
        w-report.campo-f[1] = Ccbddocu.cImporteTotalConImpuesto
        w-report.campo-c[3] = IF (AVAILABLE almmmatg) THEN STRING(almmmatg.codbrr,'9999999999999') ELSE ""
        w-report.campo-c[4] = SUBSTRING(lxDesMar,1,40)  /*SUBSTRING(almmmatg.desmar,1,40)*/
        w-report.campo-c[5] = SUBSTRING(Ccbddocu.undvta,1,5)
        w-report.campo-f[2] = Ccbddocu.candes
        /*w-report.campo-f[3] = Ccbddocu.preuni*/
        w-report.campo-f[3] = Ccbddocu.ImporteUnitarioConImpuesto
        w-report.campo-c[30] = lPathGraficoQR /* lHashCodePDF417*/ /*lCodHash*/
        w-report.campo-d[1] = ccbcdocu.fchdoc
        w-report.campo-d[2] = ccbcdocu.fchvto
        w-report.campo-c[6] = ccbcdocu.horcie
        w-report.campo-c[7] = ccbcdocu.coddiv
        w-report.campo-c[8] = lTelfTienda
        w-report.campo-c[9] = ccbcdocu.usuario /*+ " " + IF(AVAILABLE _user) THEN _user._user-name ELSE ""*/
        w-report.campo-c[10] = lCliente
        w-report.campo-c[11] = lDocCliente
        w-report.campo-i[1] = Ccbddocu.NroItm
        w-report.llave-i    = Ccbddocu.NroItm.
    /* ARMAMOS LA LINEA DE DESCUENTOS */    
    IF Ccbddocu.FactorDescuento > 0 THEN DO:
        ASSIGN
            x-dscto1 = Ccbddocu.FactorDescuento * 100
            w-report.campo-f[4] = x-dscto1
            w-report.campo-f[5] = Ccbddocu.impdto.
        IF AVAILABLE facdpedi THEN DO:
            IF facdpedi.libre_c04 <> '' AND facdpedi.libre_c04 <> ?  THEN DO:
                IF facdpedi.libre_c04 = 'VOL'  THEN w-report.campo-c[29] = "DSCTO x VOLUM ". /*x-lin1A = "DSCTO x VOLUM ".*/
                IF facdpedi.libre_c04 = 'PROM' THEN w-report.campo-c[29] = "DSCTO PROMOC. ". /*x-lin1A = "DSCTO PROMOC. ".*/
            END.
        END.
    END.
    /* Datos de la cabecera y pie de pagina */
    ASSIGN  
        /* Op. Gravadas */
        w-report.campo-f[6] = Ccbcdocu.TotalValorVentaNetoOpGravadas
        /* Op. Gratuitas */
        w-report.campo-f[7] = Ccbcdocu.TotalValorVentaNetoOpGratuitas
        /* Op. Exoneradas */
        w-report.campo-f[8] = Ccbcdocu.TotalValorVentaNetoOpExoneradas
        /* Op. Inafectas */
        w-report.campo-f[9] = Ccbcdocu.TotalValorVentaNetoOpNoGravada
        /* Total Dsctos */
        w-report.campo-f[10] = ccbcdocu.impdto2
        /* ISC */
        w-report.campo-f[11] = ccbcdocu.impisc
        /* % IGV */
        w-report.campo-f[12] = ccbcdocu.porigv
        /* IGV */
        w-report.campo-f[13] = CcbCDocu.TotalIGV
        /* Total a Pagar */
        w-report.campo-f[14] = Ccbcdocu.TotalVenta.
    ASSIGN
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
    /* RHC 15/08/19 BOLSAS PLASTICAS: OTROS TRIBUTOS */
    ASSIGN w-report.Campo-f[30] = Ccbcdocu.TotalMontoICBPER.
    ASSIGN w-report.Campo-c[28] = x-retval.
    lTotItems = lTotItems + 1.
END.
/* Pagina Completas */
lLineasTotales = 16.
IF ccbcdocu.coddoc = 'N/C' OR ccbcdocu.coddoc = 'N/D' THEN lLineasTotales = 20.
lItemsxPagina = 47.
lTotPags = TRUNCATE(lTotItems / lItemsxPagina,0).
lxTotPags = TRUNCATE(lTotItems / lItemsxPagina,0).
/* Si quedan items adicionales */
IF (lTotPags * lItemsxPagina) <> lTotItems   THEN lTotPags = lTotPags + 1.
/* Si los totales van a ir en otra pagina */
IF (lTotItems - (lxTotPags * lItemsxPagina)) > (lItemsxPagina - lLineasTotales) THEN lTotPags = lTotPags + 1.

x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (Cargando data - linea adicionales) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

/* RHC 15/02/2019 Lineas adicionales */
/* SOLO PARA BIZLINKS */
/* Buscamos configuración de Proveedor de Fact. Electroc. */
FIND FIRST VtaDTabla WHERE VtaDTabla.CodCia = s-CodCia AND
    VtaDTabla.Tabla = 'SUNATPRV' AND
    VtaDTabla.Tipo = pCodDiv AND
    CAN-FIND(FIRST VtaCTabla OF VtaDTabla NO-LOCK)
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaDTabla AND VtaDTabla.Llave = "BL" THEN DO: 
    IF LOOKUP(Ccbcdocu.CodDoc, 'BOL,FAC,N/D') > 0 THEN DO:
        w-report.Campo-c[22] = "ABONAR EN LAS SIGUIENTES CUENTAS RECAUDADORAS:".
        w-report.Campo-c[23] = "BCP SOLES: 191-1532467-0-63  (CCI 002-191-001532467063-55)".
        w-report.Campo-c[24] = "BCP DOLARES: 191-1524222-1-91 (CCI 002-191-001524222191-57".
    END.
    /* RHC 19/02/2019 Caso de DETRACCION */
    IF LOOKUP(Ccbcdocu.CodDoc, 'BOL,FAC') > 0 AND Ccbcdocu.TpoFac = "S" THEN DO:
        FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK, FIRST almmserv NO-LOCK WHERE almmserv.CodCia = Ccbddocu.codcia AND
            almmserv.codmat = Ccbddocu.codmat AND
            almmserv.AftDetraccion = YES:
            /* Solo para importes mayores a S/700.00 */
            DEF VAR x-ImpTot AS DEC NO-UNDO.
            x-ImpTot = Ccbcdocu.ImpTot.
            IF Ccbcdocu.CodMon = 2  THEN x-ImpTot = x-ImpTot * Ccbcdocu.TpoCmb.
            IF x-ImpTot > 700 THEN DO:
                w-report.Campo-c[25] = "OPERACIONES SUJETAS A SPOT CON EL GOBIERNO CENTRAL D.LEG. 940".
                w-report.Campo-c[26] = "BANCO DE LA NACIÓN SOLES: 00-000-439630 (DETRACCIONES)".
            END.
            LEAVE.
        END.
    END.
END.
IF lookup(Ccbcdocu.FmaPgo,'899,900') > 0 THEN w-report.Campo-c[27] = Ccbcdocu.Glosa.

x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (Data cargada) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_code-qr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRINT_code-qr Procedure 
PROCEDURE PRINT_code-qr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER sDataQR AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER sPathGraficoQR AS CHAR NO-UNDO.


DEFINE VAR hSunatLibrary AS HANDLE NO-UNDO.

RUN sunat/sunat-library PERSISTENT SET hSunatLibrary.

RUN GenerateCodeQR IN hSunatLibrary (INPUT sDataQr, OUTPUT sPathGraficoQR).

DELETE PROCEDURE hSunatLibrary.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_consignar-guia-remision) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRINT_consignar-guia-remision Procedure 
PROCEDURE PRINT_consignar-guia-remision :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pDivision AS CHAR.
DEFINE OUTPUT PARAMETER x-guia-remision AS CHAR.

DEFINE VAR x-enviar-guia-remision AS LOG.

RUN sunat/p-consignar-guia-de-remision (INPUT pDivision, OUTPUT x-enviar-guia-remision).

x-guia-remision = "".

IF x-enviar-guia-remision = YES THEN DO:
    DEFINE BUFFER bx-ccbcdocu FOR ccbcdocu.
     FOR EACH bx-ccbcdocu WHERE bx-ccbcdocu.codcia = s-codcia AND                                   
                                 bx-ccbcdocu.coddoc = 'G/R' AND                                     
                                 bx-ccbcdocu.codref = ccbcdocu.coddoc AND                           
                                 bx-ccbcdocu.nroref = ccbcdocu.nrodoc                               
                                 NO-LOCK :                                                          
         x-guia-remision = x-guia-remision + IF(x-guia-remision <> "") THEN " / " ELSE "".                                        
         x-guia-remision = x-guia-remision + SUBSTRING(bx-ccbcdocu.nrodoc,1,3) + "-" + SUBSTRING(bx-ccbcdocu.nrodoc,4). 
     END.                                                                                           
    RELEASE bx-ccbcdocu.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_Datos-Cheque) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRINT_Datos-Cheque Procedure 
PROCEDURE PRINT_Datos-Cheque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Verifica que la cancelación se realizó con CHEQUE */
x-cheque = "".
IF CcbCDocu.Flgest = 'C' THEN DO:
    FOR EACH CcbDCaja WHERE CcbDCaja.CodCia = s-codcia AND
            CcbDCaja.CodRef = CcbCDocu.Coddoc AND
            CcbDCaja.NroRef = CcbCDocu.Nrodoc NO-LOCK,
        FIRST ccbccaja WHERE
            ccbccaja.codcia = ccbdcaja.codcia AND
            ccbccaja.coddiv = ccbdcaja.coddiv AND
            ccbccaja.coddoc = ccbdcaja.coddoc AND
            ccbccaja.nrodoc = ccbdcaja.nrodoc NO-LOCK:
        cNroIC = CcbDCaja.Nrodoc.
        x-cheque = TRIM(CcbCCaja.Voucher[2]) + TRIM(CcbCCaja.Voucher[3]).
        IF CcbCCaja.CodBco[2] > '' THEN DO:
            FIND cb-tabl WHERE cb-tabl.Tabla = "04" AND cb-tabl.codigo = CcbCCaja.CodBco[2] NO-LOCK NO-ERROR.
            IF AVAILABLE cb-tabl THEN x-cheque = x-cheque + " " + TRIM(cb-tabl.Nombre).
        END.
        IF CcbCCaja.CodBco[3] > '' THEN DO:
            FIND cb-tabl WHERE cb-tabl.Tabla = "04" AND cb-tabl.codigo = CcbCCaja.CodBco[3] NO-LOCK NO-ERROR.
            IF AVAILABLE cb-tabl THEN x-cheque = x-cheque + " " + TRIM(cb-tabl.Nombre).
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
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_enviar-impresion-qr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRINT_enviar-impresion-qr Procedure 
PROCEDURE PRINT_enviar-impresion-qr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pImprimeDirecto AS LOG.
DEFINE INPUT PARAMETER pNombreImpresora AS CHAR.
DEFINE INPUT PARAMETER pVersion AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE INPUT PARAMETER pFormatoTck AS LOG.
DEFINE OUTPUT PARAMETER pError AS CHAR NO-UNDO.

DEFINE VAR lImpresora AS CHAR INIT "".
DEFINE VAR lPuerto AS CHAR INIT "".
DEFINE VAR x-filer AS CHAR.

DEFINE VAR x-terminal-server AS LOG.

x-filer = PRINT_flog-epos-txt ("IMPRIMIR DOCMTO (BUSCANDO CONFIGURACIONES) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

/* se esta ejecutando en TERMINAL Server ?*/
RUN lib/_es-terminal-server.p(OUTPUT x-terminal-server).

FIND FacCorre WHERE FacCorre.CodCia = Ccbcdocu.codcia AND 
    FacCorre.CodDiv = Ccbcdocu.coddiv AND
    FacCorre.CodDoc = ccbcdocu.coddoc AND
    FacCorre.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroDoc, 1, 3)) 
    NO-LOCK NO-ERROR.

/* Suspendido temporalmente.....???????????????????????????????????????????????????? */
x-terminal-server = NO.

CASE TRUE:
    WHEN pImprimeDirecto = YES AND LOOKUP(cImprimeDirecto, 'Si,Yes') > 0 THEN DO:
        IF x-terminal-server = YES THEN DO:

            x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (IMPRESION DIRECTA - TERMINAL SERVER) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

            IF pNombreImpresora > "" THEN DO:
                lImpresora = pNombreImpresora.
            END.
            ELSE DO:
                IF AVAILABLE FacCorre THEN lImpresora = FacCorre.Printer.
            END.    

            /* Ubicar la impresora en el terminal server */
            RUN lib/_impresora-terminal-server.p(INPUT-OUTPUT lImpresora, OUTPUT lPuerto).

            /* */
            IF lImpresora <> "" THEN s-port-name = lImpresora.
        END.
        /* Si no ubico la impresora en el terminal server, ubical la impresora predeterminada */
        IF lImpresora = ""  THEN DO:
            IF x-terminal-server = YES THEN DO:
                x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (IMPRESION DIRECTA - TERMINAL SERVER) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
            END.
            ELSE DO:
                x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (IMPRESION DIRECTA - NO TERMINAL SERVER - IMPRESORA PREDETERMINADA) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
            END.            
            /* 1 */
            DEF VAR success AS LOGICAL.
            /* 2 Capturo la impresora por defecto */
            RUN lib/_default_printer.p (OUTPUT s-printer-name, OUTPUT s-port-name, OUTPUT success).
            /* 3 */
            IF success = NO THEN DO:
                x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (IMPRESION DIRECTA - NO TERMINAL SERVER - IMPRESORA PREDETERMINADA - NO HAY) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
                pError = "NO hay una impresora por defecto definida".
                RETURN 'ADM-ERROR'.
            END.
            /* 4 De acuerdo al sistema operativo transformamos el puerto de impresión */
            RUN lib/_port-name-v2.p (s-Printer-Name, OUTPUT s-Port-Name).
        END.
    END.
    OTHERWISE DO:
        IF x-terminal-server = YES THEN DO:
            IF pNombreImpresora > "" THEN DO:
                lImpresora = pNombreImpresora.                
            END.
            ELSE DO:
                IF AVAILABLE FacCorre THEN lImpresora = FacCorre.Printer.
            END.                

            /* Ubicar la impresora en el terminal server */
            RUN lib/_impresora-terminal-server.p(INPUT-OUTPUT lImpresora, OUTPUT lPuerto).

            /* */
            IF lImpresora <> "" THEN s-port-name = lImpresora.
        END.
        /* Si no ubico la impresora en el terminal server, ubical la impresora predeterminada */
        IF TRUE <> (lImpresora > "")  THEN DO:
            IF x-terminal-server = YES THEN DO:
                x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (IMPRESION NO DIRECTA - TERMINAL SERVER) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
            END.
            ELSE DO:
                x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (IMPRESION NO DIRECTA - NO TERMINAL SERVER) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
            END.
            
            /* Si se envía un nombre se toma ese, si no se toma el de la tabla de correlativos */
            IF pNombreImpresora > "" THEN DO:
                s-printer-name = pNombreImpresora.
                IF x-terminal-server = YES THEN DO:
                    x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (IMPRESION NO DIRECTA - TERMINAL SERVER - IMPRESORA ENVIADA) : " + pNombreImpresora + " - " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
                END.
                ELSE DO:
                    x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (IMPRESION NO DIRECTA - NO TERMINAL SERVER - IMPRESORA ENVIADA) : " + pNombreImpresora + " - " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
                END.
            END.
            ELSE DO:
                IF AVAILABLE FacCorre THEN DO:
                    s-printer-name = FacCorre.Printer.
                    IF x-terminal-server = YES THEN DO:
                        x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (IMPRESION NO DIRECTA - TERMINAL SERVER - IMPRESORA EN EL FACCORRE) : " + s-printer-name + " - " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
                    END.
                    ELSE DO:
                        x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (IMPRESION NO DIRECTA - NO TERMINAL SERVER - IMPRESORA EN EL FACCORRE) : " + s-printer-name + " - " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
                    END.
                END.                   
            END.    

            IF pImprimeDirecto = YES AND s-printer-name > "" THEN DO:
                RUN lib/_port-name-v2.p (s-printer-name, OUTPUT s-port-name).
                IF s-port-name = '' THEN DO:
                    pError = 'NO está definida la impresora ' + CHR(10) +
                        'División: ' + Ccbcdocu.coddiv + CHR(10) +
                        'Documento: ' + Ccbcdocu.coddoc + CHR(10) +
                        'N° Serie: ' + SUBSTRING(CcbCDocu.NroDoc, 1, 3) + CHR(10) +
                        'Impresora: ' + s-printer-name + ' <<<'.
                    RETURN 'ADM-ERROR'.
                END.
            END.
            ELSE DO:
                /**/
                RUN bin/_prnctr.
                IF s-salida-impresion = 0 THEN RETURN 'OK'.     /* Usuario NO desea imprimir */
                RUN lib/_port-name-v2.p (s-printer-name, OUTPUT s-port-name).
            END.
        END.
    END.
END CASE.

IF ccbcdocu.fmapgo = '899' THEN lNombreDocumento = "BONIFICACION".
IF ccbcdocu.fmapgo = '899' THEN x-electronica = "PROMOCIONAL".

x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (Inicia-Impresora) : " + s-printer-name + ":" + s-port-name + " " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

x-version = "".
IF pVersion = 'O' THEN x-version = "ORIGINAL".
IF pVersion = 'C' THEN x-version = "COPIA".
IF pVersion = 'R' THEN x-version = "RE-IMPRESION".
IF pVersion = 'L' THEN x-version = "CLIENTE".
IF pVersion = 'A' THEN x-version = "CONTROL ADMINISTRATIVO".

/* ****************************************************************************** */
/* RHC Resolución y dirección web */
/* ****************************************************************************** */
DEF VAR pResolucion AS CHAR NO-UNDO.
DEF VAR pWeb AS CHAR NO-UNDO.

ASSIGN
    pResolucion = "018-005-0002649/SUNAT"
    pWeb = "http://asp402r.paperless.com.pe/BoletaContinental/".
FIND FIRST VtaDTabla WHERE VtaDTabla.CodCia = s-codcia AND
    VtaDTabla.Tabla = 'SUNATPRV' AND 
    VtaDTabla.Tipo = pCodDiv AND
    CAN-FIND(FIRST VtaCTabla OF VtaDTabla NO-LOCK)
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaDTabla THEN DO:
    FIND FIRST VtaCTabla OF VtaDTabla NO-LOCK NO-ERROR.
    IF VtaCTabla.Libre_c01 > '' THEN pResolucion = VtaCTabla.Libre_c01.
    IF VtaCTabla.Libre_c02 > '' THEN pWeb        = VtaCTabla.Libre_c02.
END.

x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (Parametros del ReportBuilder) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

/* ****************************************************************************** */
/* ****************************************************************************** */
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
                        "~npDirCliente = " + lDirCliente +
                        "~npDirCliente1 = " + lDirCliente1 +
                        "~npGuia = " + lGuia +
                        "~npPedido = " + lPedido +
                        "~npFmaPgo = " + lFmaPgo +
                        "~npTipoVta = " + trim(ccbcdocu.tipo) +
                        "~npCodVendedor = " + trim(ccbcdocu.codven) +
                        "~npCajera = " + trim(ccbcdocu.usuario) +
                        "~npSignoMoneda = " + lSignoMoneda +
                        "~npOrdenCompra = " + lOrdenCompra +
                        "~npTotPaginas = " + STRING(lTotPags) + 
                        "~npVersion = " + x-version + 
                        "~npDigitoVerificador = " + STRING(lDigitoVerificador) +
                        "~npMoneda = " + lMoneda +
                        "~npResolucion = " + pResolucion +
                        "~npWeb = " + pWeb +
                        "~npAnticipo1 = " + x-anticipo1 +
                        "~npAnticipo2 = " + x-anticipo2 +
                        "~npAnticipo3 = " + x-anticipo3 +
                        "~npAnticipo4 = " + x-anticipo4 +
                        "~npElectronica = " + x-Electronica +
                        "~npOrdenDespacho = " + lOrdenDespacho
                        .

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
IF NOT (cDatabaseName = ? OR cHostName = ? OR cNetworkProto = ? OR cPortNumber = ?) THEN DO:
    DEFINE VAR x-rb-user AS CHAR.
    DEFINE VAR x-rb-pass AS CHAR.

    RUN lib/RB_credenciales(OUTPUT x-rb-user, OUTPUT x-rb-pass).

    IF x-rb-user = "**NOUSER**" THEN DO:
        pError = "No se pudieron ubicar las credenciales para" + CHR(10) +
                "la conexion del REPORTBUILDER" + CHR(10) +
                "--------------------------------------------" + CHR(10) +
                "Comunicarse con el area de sistemas - desarrollo".
        RETURN "ADM-ERROR".
    END.

   ASSIGN
       cNewConnString =
       "-db" + cDelimeter + cDatabaseName + cDelimeter +
       "-H" + cDelimeter + cHostName + cDelimeter +
       "-N" + cDelimeter + cNetworkProto + cDelimeter +
       "-S" + cDelimeter + cPortNumber + cDelimeter +
       "-U " + x-rb-user  + cDelimeter + cDelimeter +
       "-P " + x-rb-pass + cDelimeter + cDelimeter.

   IF cOtherParams > '' THEN cNewConnString = cNewConnString + cOtherParams + cDelimeter.
   RB-DB-CONNECTION = cNewConnString.
END.

ASSIGN
/*     RB-REPORT-NAME = IF (pFormatoTck = YES ) THEN "ticket comprobante electronico" ELSE "docto venta electronico" */
    RB-BEGIN-PAGE = s-pagina-inicial
    RB-END-PAGE = s-pagina-final
    RB-PRINTER-NAME = s-port-name       /*s-printer-name*/
    RB-OUTPUT-FILE = s-print-file
    RB-NUMBER-COPIES = s-nro-copias.

/* ************************************************* */
/* 09/03/2023 Formato para venta itinerante D.Llican */
/* ************************************************* */
/* IF LOOKUP(pCodDiv, '00600,00601') > 0 THEN RB-REPORT-NAME = "Docto Venta Electronico PrePrint". */
/* ****************************************************************************** */
/* 25/03/2023: El formato de impresión depende de la configuración de la división */
/* ****************************************************************************** */
/* FIND FacTabla WHERE FacTabla.CodCia = s-codcia AND                            */
/*     FacTabla.Tabla = "CFG_FMT_MAY_MOSTRADOR" AND                              */
/*     FacTabla.Codigo = pCodDiv                                                 */
/*     NO-LOCK NO-ERROR.                                                         */
/* IF AVAILABLE FacTabla THEN DO:                                                */
/*     CASE FacTabla.Campo-C[1]:                                                 */
/*         WHEN "TICKET" THEN RB-REPORT-NAME = "ticket comprobante electronico". */
/*         WHEN "A41" THEN RB-REPORT-NAME = "docto venta electronico".           */
/*         WHEN "A42" THEN RB-REPORT-NAME = "Docto Venta Electronico PrePrint".  */
/*     END CASE.                                                                 */
/* END.                                                                          */
/* ****************************************************************************** */
/* ****************************************************************************** */

CASE s-salida-impresion:
  WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
  WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
  WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
END CASE.

x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (Inicia Impresion ReportBuilder) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

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

x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (Termino Impresion ReportBuilder) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (Eliminado el temporal - INICIO) " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

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

x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (Eliminando el Temporal - FIN) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (FINAL) : " + s-printer-name + ":" + s-port-name + " " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_Enviar-Sunat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRINT_Enviar-Sunat Procedure 
PROCEDURE PRINT_Enviar-Sunat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER lRetVal AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = ccbcdocu.codcia AND
    FELogComprobantes.coddiv = ccbcdocu.coddiv AND
    FELogComprobantes.coddoc = ccbcdocu.coddoc AND
    FELogComprobantes.nrodoc = ccbcdocu.nrodoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FELogComprobantes THEN DO:
    RUN PRINT_log-txt("IMPRIMIR DOCMTO (ENVIANDO A SUNAT - INICIO) : " + ccbcdocu.coddiv + " " + 
                ccbcdocu.coddoc + " " + ccbcdocu.nrodoc + " me percaté que no se habia enviado a SUNAT").
    RUN sunat\progress-to-ppll-v3( INPUT Ccbcdocu.coddiv,
                                   INPUT Ccbcdocu.coddoc,
                                   INPUT Ccbcdocu.nrodoc,
                                   INPUT-OUTPUT TABLE T-FELogErrores,
                                   OUTPUT lRetVal ).
    IF RETURN-VALUE = 'PLAN-B' THEN DO:
        RETURN 'PLAN-B'.
    END.
    IF CAPS(lRetVal) <> 'OK' THEN DO:
        RUN PRINT_log-txt("IMPRIMIR DOCMTO (ENVIANDO A SUNAT - FIN) : " + ccbcdocu.coddiv + " " + 
                    ccbcdocu.coddoc + " " + ccbcdocu.nrodoc + " hubo problemas de enviooo a SUNAT").
        pError = "Hubo problemas al enviar el documento a SUNAT" + CHR(10) + "(" + lRetVal + ")".
        RETURN 'ADM-ERROR'.
    END.
    RUN PRINT_log-txt("IMPRIMIR DOCMTO (ENVIADO A SUNAT) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + 
                ccbcdocu.nrodoc + " se envio a SUNAT").
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_Graba-Log) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRINT_Graba-Log Procedure 
PROCEDURE PRINT_Graba-Log :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pVersion AS CHAR.

DEFINE VAR x-filer AS CHAR.

IF pVersion = "R" THEN DO:
    x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (LOG DE REIMPRESION - INICIO) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
    RUN lib/logtabla ("ccbcdocu",ccbcdocu.coddoc + '|' + ccbcdocu.nrodoc, "REIMPRESION").
    x-filer = PRINT_flog-epos-txt("IMPRIMIR DOCMTO (LOG DE REIMPRESION - FIN) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_GRE_cargar_data) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRINT_GRE_cargar_data Procedure 
PROCEDURE PRINT_GRE_cargar_data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR l-ubica AS LOG.
DEFINE VAR iCount AS INT.
DEFINE VAR cSerieNumero AS CHAR.
DEFINE VAR curlCDR AS CHAR.

DEFINE VAR v-result AS CHAR.
DEFINE VAR v-response AS LONGCHAR.
DEFINE VAR v-content AS LONGCHAR.
DEFINE VAR cTagInicial AS CHAR.
DEFINE VAR cTagFinal AS CHAR.
DEFINE VAR cTexto AS LONGCHAR.

DEFINE VAR cSerieNumeroDoc AS CHAR.

DEFINE VAR lPathGraficoQR AS CHAR.

l-ubica = YES.
/*Cargando en el temporal del sistema*/
REPEAT WHILE L-Ubica:
   s-task-no = RANDOM(900000,999999).
   FIND FIRST b-w-report WHERE b-w-report.task-no = s-task-no NO-LOCK NO-ERROR.
   IF NOT AVAILABLE b-w-report THEN L-Ubica = NO.
END.

IF l-ubica = YES THEN DO:
    /*  */
    RETURN "ADM-ERROR".
END.

/* QR */
EMPTY TEMP-TABLE tTagsEstadoDoc.

cTextoQR = "".
cTextoResolucionSunat = "".

FIND FIRST gre_header_qr WHERE gre_header_qr.ncorrelativo = x-gre_header.ncorrelatio NO-LOCK NO-ERROR.

IF AVAILABLE gre_header_qr THEN DO:
    cTextoQR = TRIM(gre_header_qr.data_qr).
END.
IF TRUE <> (cTextoQR > "") THEN DO:
    /* Si el QR no esta grabado lo recuperamos en linea */
    cSerieNumero = STRING(x-gre_header.serieGuia,"999") + STRING(x-gre_header.numeroGuia,"99999999").

    RUN gn/p-estado-documento-electronico-v3.r(INPUT "G/R",
                        INPUT cSerieNumero,
                        INPUT "",
                        INPUT "ESTADO DOCUMENTO",
                        INPUT-OUTPUT TABLE tTagsEstadoDoc).

    /* Tag del link del CDR : xmlFileSunatUrl */
    FIND FIRST tTagsEstadoDoc WHERE tTagsEstadoDoc.cTag = 'xmlFileSunatUrl' NO-LOCK NO-ERROR.
    IF AVAILABLE tTagsEstadoDoc THEN DO:

        curlCDR = TRIM( tTagsEstadoDoc.cValue).    

        RUN lib\http-get-contenido.p(cUrlCDR,output v-result,output v-response,output v-content).

        IF v-result = "1:Success"  THEN DO:
            /* Sacar el el texto para generar el QR */

            cTagInicial = "<cac:DocumentReference>".
            cTagFinal = "</cac:DocumentReference>".

            RUN getValueTag(v-content,cTagInicial,cTagFinal, OUTPUT cTexto).

            IF NOT (TRUE <> (cTexto > "")) THEN DO:
                cTagInicial = "<cbc:DocumentDescription>".
                cTagFinal = "</cbc:DocumentDescription>".

                RUN getValueTAG(cTexto,cTagInicial,cTagFinal, OUTPUT cTextoQR).            
            END.
        END.
    END.
END.

/* Imangen del QR */
lPathGraficoQR = "".

IF TRUE <> (cTextoQR > "") THEN cTextoQR = "NO EXISTEN DATOS DEL QR".

RUN PRINT_code-qr (INPUT STRING(cTextoQR), OUTPUT lPathGraficoQR).

cPathGraficoQR = lPathGraficoQR.

/* Datos extras */
cOrden  = "".
cOrdenLabel = "".
cOrdenRef = "".
cOrdenRefLabel = "".
cSerieNumero = STRING(x-gre_header.serieGuia,"999") + STRING(x-gre_header.numeroGuia,"99999999").
cDireccionEntrega = "".
cAgenciaTransporte = "".
cContacto = "".
cHora = "".
cObservacionDeEnvio = "".
cObservaciones = "".
cSerieNumeroGRE = "".
cMensajeAdicional = "".
cUsuarioImpresion = USERID("dictdb").
cCrossDocking = "".

/*lItemsxPagina = 30.*/
lItemsxPagina = 26.

FIND FIRST _user WHERE _user._Userid = cUsuarioImpresion NO-LOCK NO-ERROR.
IF AVAILABLE _user THEN cUsuarioImpresion = cUsuarioImpresion + " " + TRIM(_user._user-name).

DEFINE VAR iQtyImpresiones AS INT INIT 0.

FOR EACH gre_header_impresiones WHERE gre_header_impresiones.ncorrelativo = x-gre_header.ncorrelatio NO-LOCK:
    iQtyImpresiones = iQtyImpresiones + 1.
END.

IF iQtyImpresiones > 0 THEN DO:
    cMensajeAdicional = "RE-IMPRESION (" + STRING(iQtyImpresiones) + ")".
END.

IF x-gre_header.m_tpomov = "GRVTA" THEN DO:
    cSerieNumeroDoc = STRING(x-gre_header.m_nroser,"999") + STRING(x-gre_header.m_nrodoc,"99999999").
    IF x-gre_header.m_coddoc = 'FAI' THEN cSerieNumeroDoc = STRING(x-gre_header.m_nroser,"999") + STRING(x-gre_header.m_nrodoc,"999999").
    /* Vta */
    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = 1 AND ccbcdocu.coddoc = x-gre_header.m_coddoc AND
                        ccbcdocu.nrodoc = cSerieNumeroDoc NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcdocu THEN DO:
        cOrden = ccbcdocu.libre_c01 + " " + ccbcdocu.libre_c02.                           
        cOrdenRef = ccbcdocu.nroord.
        /**/
        cOrdenLabel = "ORDEN DESPACHO : ".
        cOrdenRefLabel = "ORDEN DE COMPRA : ".    
    END.
    /* Agencia de Transporte */        
    /* 
        Punto de llegada :  - Sede del cliente
                            - Agencia de transporte
    */
    FIND FIRST x-ccbadocu WHERE x-ccbadocu.codcia = 1 AND
                                x-ccbadocu.coddiv = ccbcdocu.divori AND
                                x-ccbadocu.coddoc = ccbcdocu.libre_c01 AND  /* O/D */
                                x-ccbadocu.nrodoc = ccbcdocu.libre_c02 NO-LOCK NO-ERROR.
    IF AVAILABLE x-ccbadocu THEN DO:
        /* Agencia de transporte */
        IF NOT (TRUE <> (x-ccbadocu.libre_c[20] > "")) THEN DO:
            /* Si tiene SEDE es agencia de transporte */
            cAgenciaTransporte = x-ccbadocu.libre_c[10].
            cDireccionEntrega = x-ccbadocu.libre_c[13].     /* Direccion del Cliente */
        END.
        cContacto = x-ccbadocu.libre_c[14].
        cHora = x-ccbadocu.libre_c[15].
        cObservacionDeEnvio = x-ccbadocu.libre_c[16].
        /*lItemsxPagina = 29.*/
    END.
    IF cAgenciaTransporte = "" THEN DO:
        /* Sede del cliente */
        FIND FIRST gn-clieD WHERE gn-clieD.codcia = 0 AND gn-clieD.codcli = ccbcdocu.codcli AND
                                    gn-clieD.sede = ccbcdocu.sede NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clieD THEN DO:
            cDireccionEntrega = TRIM(gn-clieD.dirCli).
        END.                       
    END.
END.
ELSE DO:
    /*GRTRA*/
    IF x-gre_header.m_coddoc = 'OTR' THEN DO:
        cSerieNumeroDoc = STRING(x-gre_header.m_nroser,"999") + STRING(x-gre_header.m_nrodoc,"999999").
        cOrdenLabel = "ORDEN TRANSFERENCIA : ".        
        cOrden = x-gre_header.m_coddoc + " " + cSerieNumeroDoc.

        FIND FIRST faccpedi WHERE faccpedi.codcia = 1 AND faccpedi.coddoc = x-gre_header.m_coddoc AND
                                    faccpedi.nroped = cSerieNumeroDoc NO-LOCK NO-ERROR.
        IF AVAILABLE faccpedi THEN DO:        
            cOrdenRef = faccpedi.codref + " " + faccpedi.nroref.
            cOrdenRefLabel = "R/A : ".
        END.
    END.
END.

/* Almacen de Destino */
cAlmacenDestino = "".
IF NOT (TRUE <> (x-gre_header.m_codalmdes > "")) THEN DO:
    cAlmacenDestino = x-gre_header.m_codalmdes.
    FIND FIRST x-almacen WHERE x-almacen.codcia = s-codcia AND x-almacen.codalm = x-gre_header.m_codalmdes NO-LOCK NO-ERROR.
    IF AVAILABLE x-almacen THEN DO:
        cAlmacenDestino = cAlmacenDestino + " " + x-almacen.descripcion.
    END.
END.

/* CrossDocking */
IF x-gre_header.m_crossdocking THEN DO:
    IF NOT (TRUE <> (x-gre_header.m_almacenXD > "")) THEN DO:
        cCrossDocking = "CROSSDOCKING :" + x-gre_header.m_almacenXD.
        FIND FIRST x-almacen WHERE x-almacen.codcia = s-codcia AND x-almacen.codalm = x-gre_header.m_almacenXD NO-LOCK NO-ERROR.
        IF AVAILABLE x-almacen THEN DO:
            cCrossDocking = cCrossDocking + " " + x-almacen.descripcion.
        END.
    END.
END.

/* URL consulta del documento */
cTextoResolucionSunat = "Representacion Impresa de la Guia de remision Remitente Electronica, consulte en ".
FIND FIRST factabla WHERE factabla.codcia = 1 AND factabla.tabla = "CONFIG-FE-BIZLINKS" AND factabla.codigo = "TODOS" NO-LOCK NO-ERROR.
IF AVAILABLE factabla THEN DO:
    cTextoResolucionSunat = cTextoResolucionSunat + factabla.campo-c[3].
END.
cObservaciones = x-gre_header.observaciones.
cSerieNumeroGRE = "T" + STRING(x-gre_header.serieGuia,"999") + "-" + STRING(x-gre_header.numeroGuia,"99999999").

/* Paginado */
lTotItems = 0.
lxTotPags = 1.
lTotPags = 0.
lLineasTotales = 0.

/* Numero total de Items */
FOR EACH x-gre_detail WHERE x-gre_detail.ncorrelativo = x-gre_header.ncorrelatio NO-LOCK:
    lTotItems = lTotItems + 1.
END.

lTotPags = TRUNCATE(lTotItems / lItemsxPagina,0).
IF (lTotItems / lItemsxPagina) > lTotPags THEN lTotPags = lTotPags + 1.
lxTotPags = 0.

DEFINE VAR cTextoPags AS CHAR.
DEFINE VAR iCountItem AS INT.

FOR EACH x-gre_detail WHERE x-gre_detail.ncorrelativo = x-gre_header.ncorrelatio NO-LOCK BY x-gre_detail.ncorrelativo BY x-gre_detail.nroitm :
    FIND FIRST almmmatg WHERE almmmatg.codcia = 1 AND almmmatg.codmat = x-gre_detail.codmat NO-LOCK NO-ERROR.    
    
    iCountItem = iCountItem + 1.
    IF iCountItem = 1 OR iCountItem > lItemsxPagina THEN DO:
        lxTotPags = lxTotPags + 1.
        iCountItem = 1.
    END.            
        
    cTextoPags = "PAGINA " + STRING(lxTotPags) + " DE " + STRING(lTotPags).

    CREATE b-w-report.
        ASSIGN b-w-report.task-no = s-task-no
                b-w-report.llave-c = cTextoPags /*"T" + STRING(x-gre_header.serieGuia,"999") + "-" + STRING(x-gre_header.numeroGuia,"99999999")*/
                b-w-report.campo-c[1] = CAPS(x-gre_header.descripcionMotivoTraslado)
                b-w-report.campo-c[2] = IF(x-gre_header.modalidadTraslado = '02') THEN "TRANSPORTE PRIVADO" ELSE "TRANSPORTE PUBLICO"
                b-w-report.campo-c[3] = IF(x-gre_header.indTransbordoProgramado = 0) THEN "NO" ELSE "SI"
                b-w-report.campo-c[4] = x-gre_header.numeroDocumentoDestinatario
                b-w-report.campo-c[5] = x-gre_header.razonSocialDestinatario
                b-w-report.campo-c[6] = x-gre_header.unidadMedidaPesoBruto
                b-w-report.campo-c[7] = x-gre_header.direccionPtoPartida
                b-w-report.campo-c[8] = x-gre_header.ubigeoPtoPartida
                b-w-report.campo-c[9] = x-gre_header.direccionPtoLlegada
                b-w-report.campo-c[10] = x-gre_header.ubigeoPtoLlegada
                b-w-report.campo-c[11] = IF(x-gre_header.modalidadTraslado = '02') THEN "" ELSE x-gre_header.numeroRucTransportista         /* Que vaya solo si es publico */
                b-w-report.campo-c[12] = IF(x-gre_header.modalidadTraslado = '02') THEN "" ELSE x-gre_header.razonSocialTransportista      /*  */
                b-w-report.campo-c[13] = x-gre_header.numeroPlacaVehiculoPrin
                b-w-report.campo-c[14] = x-gre_header.numeroDocumentoConductor
                b-w-report.campo-c[15] = x-gre_header.nombreConductor + " " + x-gre_header.apellidoConductor
                b-w-report.campo-c[16] = x-gre_header.tarjetaUnicaCirculacionPrin
                b-w-report.campo-c[17] = x-gre_header.numeroLicencia
                b-w-report.campo-c[20] = x-gre_detail.codmat
                b-w-report.campo-c[21] = x-gre_detail.codund
                b-w-report.campo-c[22] = IF(AVAILABLE almmmatg) THEN CAPS(almmmatg.desmat) ELSE "¿NO EXISTE?"
                b-w-report.campo-c[23] = IF(AVAILABLE almmmatg) THEN CAPS(almmmatg.desmar) ELSE "¿VARIOS?"
                b-w-report.campo-c[24] = "" /*x-gre_header.observaciones*/
                b-w-report.campo-c[25] = IF(x-gre_header.indTrasVehiculoCatM1L = YES) THEN "SI" ELSE "NO"
                b-w-report.campo-c[26] = x-gre_header.numeroPlacaVehiculoSec1
                b-w-report.campo-c[27] = x-gre_header.tarjetaUnicaCirculacionSec1
                b-w-report.campo-d[1] = date(x-gre_header.fechahora_envio_a_sunat)  /* emision*/
                b-w-report.campo-d[2] = x-gre_header.fechaInicioTraslado        /* Inicio traslado */
                b-w-report.campo-d[3] = x-gre_header.fechaentregaBienes
                b-w-report.campo-d[4] = ?
                b-w-report.campo-d[5] = ?
                b-w-report.campo-d[6] = ?
                b-w-report.campo-f[1] = x-gre_header.pesoBrutoTotalBienes
                b-w-report.campo-f[2] = 0
                b-w-report.campo-f[3] = 0
                b-w-report.campo-f[4] = 0
                b-w-report.campo-f[5] = 0
                b-w-report.campo-f[20] = x-gre_detail.candes
                b-w-report.campo-f[21] = 0                
                b-w-report.campo-i[1] = x-gre_detail.nroitm
                b-w-report.campo-i[2] = x-gre_header.numeroBultos
                b-w-report.campo-i[3] = 0
                b-w-report.campo-i[4] = 0
                b-w-report.campo-i[5] = 0
                b-w-report.campo-c[30] = lPathGraficoQR
            .

END.

RELEASE b-w-report NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_GRE_impresion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRINT_GRE_impresion Procedure 
PROCEDURE PRINT_GRE_impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pSerieGuia AS INT.
DEFINE INPUT PARAMETER pNumeroGuia AS INT.
DEFINE INPUT PARAMETER pNombreImpresora AS CHAR.        /* Si viene vacio pide la impresora */
DEFINE INPUT PARAMETER pCopias AS CHAR.     /* EMISOR,REMITENTE,ARCHIVO --> 3 copias */
DEFINE OUTPUT PARAMETER pRetVal AS CHAR.

FIND FIRST x-gre_header WHERE x-gre_header.serieGuia = pSerieGuia AND
                                x-gre_header.numeroGuia = pNumeroGuia NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-gre_header THEN DO:
    pRetVal = "No existe la GRE " + STRING(pSerieGuia,"999") + "-" + STRING(pNumeroGuia,"99999999").
    RETURN "ADM-ERROR".
END.

IF TRUE <> (pNombreImpresora > "") THEN DO:
    RUN bin/_prnctr.
    IF s-salida-impresion = 0 THEN RETURN 'OK'.     /* Usuario NO desea imprimir */    
END.
ELSE DO:
    s-printer-name = pNombreImpresora.
    s-salida-impresion = 2.
    /* Falta verificar que la impresora exista */
END.

RUN lib/_port-name-v2.p (s-printer-name, OUTPUT s-port-name).

lTotItems = 0.
lItemsxPagina = 28.
lxTotPags = 0.
lTotPags = 0.
lLineasTotales = 0.

/**/
RUN PRINT_GRE_cargar_data.

IF RETURN-VALUE = "ADM-ERROR" THEN DO:
    RETURN "ADM-ERROR".
END.

cCopias = pCopias.

RUN PRINT_GRE_imprimir.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_GRE_imprimir) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRINT_GRE_imprimir Procedure 
PROCEDURE PRINT_GRE_imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cDatabaseName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cHostName        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNetworkProto    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPortNumber      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cOtherParams     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNewConnString   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDelimeter       AS CHARACTER NO-UNDO.

DEFINE VAR iCopias AS INT.
DEFINE VAR iCopia AS INT.

GET-KEY-VALUE SECTION "RBParametros" KEY "cDatabaseName" VALUE cDatabaseName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cHostName" VALUE cHostName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cNetworkProto" VALUE cNetworkProto.
GET-KEY-VALUE SECTION "RBParametros" KEY "cPortNumber" VALUE cPortNumber.
GET-KEY-VALUE SECTION "RBParametros" KEY "cOtherParams" VALUE cOtherParams.

ASSIGN cDelimeter = CHR(32).
IF NOT (cDatabaseName = ? OR cHostName = ? OR cNetworkProto = ? OR cPortNumber = ?) THEN DO:
    DEFINE VAR x-rb-user AS CHAR.
    DEFINE VAR x-rb-pass AS CHAR.

    RUN lib/RB_credenciales(OUTPUT x-rb-user, OUTPUT x-rb-pass).

    IF x-rb-user = "**NOUSER**" THEN DO:
        pError = "No se pudieron ubicar las credenciales para" + CHR(10) +
                "la conexion del REPORTBUILDER" + CHR(10) +
                "--------------------------------------------" + CHR(10) +
                "Comunicarse con el area de sistemas - desarrollo".
        RETURN "ADM-ERROR".
    END.

    /*cHostName = "192.168.100.208".*/

   ASSIGN
       cNewConnString =
       "-db" + cDelimeter + cDatabaseName + cDelimeter +
       "-H" + cDelimeter + cHostName + cDelimeter +
       "-N" + cDelimeter + cNetworkProto + cDelimeter +
       "-S" + cDelimeter + cPortNumber + cDelimeter +
       "-U " + x-rb-user  + cDelimeter + cDelimeter +
       "-P " + x-rb-pass + cDelimeter + cDelimeter.

   IF cOtherParams > '' THEN cNewConnString = cNewConnString + cOtherParams + cDelimeter.
   RB-DB-CONNECTION = cNewConnString.
END.
/*MESSAGE cNewConnString.*/
ASSIGN
    RB-REPORT-LIBRARY = s-report-library + "gre/gre_rpt.prl"
    RB-REPORT-NAME = "gre_A4"
    RB-INCLUDE-RECORDS = "O"
    RB-FILTER = " w-report.task-no = " + STRING(s-task-no) /*+  
                  " AND w-report.llave-c = '" + "T" + STRING(x-gre_header.serieGuia,"999") + "-" + STRING(x-gre_header.numeroGuia,"99999999") + "'"*/
    RB-BEGIN-PAGE = s-pagina-inicial
    RB-END-PAGE = s-pagina-final
    RB-PRINTER-NAME = s-port-name       /*s-printer-name*/
    RB-OUTPUT-FILE = s-print-file
    RB-NUMBER-COPIES = s-nro-copias.
                               .
IF USERID("DICTDB") = "ADMIN" OR USERID("DICTDB") = "MASTER" THEN DO:
    /*s-salida-impresion = 1.*/
END.

CASE s-salida-impresion:
  WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
  WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
  WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
END CASE.

IF s-salida-impresion <> 2 THEN DO:
    cCopias = "DIGITAL".
END.

iCopias = NUM-ENTRIES(cCopias,",").

REPEAT iCopia = 1 TO iCopias:
    cCopia = ENTRY(iCopia,cCopias,",").

    ASSIGN RB-OTHER-PARAMETERS = "cDataQR = " + cPathGraficoQR +
                                    "~ncTextoResolucionSunat= " + cTextoResolucionSunat +
                                    "~ncOrden= " + cOrden + 
                                    "~ncOrdenLabel= " + cOrdenLabel +
                                    "~ncOrdenRef= " + cOrdenRef +
                                    "~ncOrdenRefLabel= " + cOrdenRefLabel +
                                    "~ncDireccionEntrega= " + cDireccionEntrega +
                                    "~ncAgenciaTransporte= " + cAgenciaTransporte +
                                    "~ncContacto= " + cContacto +
                                    "~ncHora= " + cHora +
                                    "~ncObservacionDeEnvio=" + cObservacionDeEnvio + 
                                    "~ncObservaciones= " + cObservaciones +
                                    "~ncSerieNumeroGRE= " + cSerieNumeroGRE +
                                    "~ncCopia= " + cCopia +
                                    "~ncMensajeAdicional= " + cMensajeAdicional + 
                                    "~ncUsuarioImpresion= " + cUsuarioImpresion + 
                                    "~ncAlmacenDestino= " + cAlmacenDestino +
                                    "~ncCrossDocking= " + cCrossDocking.
    
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
END.

/* */
CREATE gre_header_impresiones.
    ASSIGN gre_header_impresiones.ncorrelativo = x-gre_header.ncorrelatio
            gre_header_impresiones.usuario = USERID("dictdb")
            gre_header_impresiones.numid_log = pRCID
            gre_header_impresiones.copias = cCopia.

RELEASE gre_header_impresiones.

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


RETURN 'OK'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_Imprimir-Comprobante) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRINT_Imprimir-Comprobante Procedure 
PROCEDURE PRINT_Imprimir-Comprobante :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE INPUT PARAMETER pVersion   AS CHAR.
/* pVersion:
    "O": ORIGINAL 
    "C": COPIA 
    "R": RE-IMPRESION 
    "L" : CLiente
    "A" : Control Administrativo
   pImprimeDirecto:
    YES: Pre-definida en el correlativo
    NO:  Seleccionar
   pFormatoTck
    YES : Formato TICKET
    NO : Formato A4
*/    
DEFINE INPUT PARAMETER pFormatoTck AS LOG.      /* YES Ticketera   NO Hoja A4 */
DEFINE INPUT PARAMETER pImprimeDirecto AS LOG.
DEFINE INPUT PARAMETER pNombreImpresora AS CHAR.
DEFINE OUTPUT PARAMETER pError AS CHAR NO-UNDO.

DEFINE VAR cImprimeDirecto AS CHAR INIT "No" NO-UNDO. 
DEFINE VAR x-electronica AS CHAR INIT "ELECTRONICA".

/* ****************************************************************************************** */
/* Buscamos Comprobante */
/* ****************************************************************************************** */
FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
    ccbcdocu.coddiv = pCodDiv AND 
    ccbcdocu.coddoc = pCodDoc AND 
    ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN DO:
    pError = "Documento " + pCodDoc + " " + pNroDoc + " NO registrado".
    RETURN 'ADM-ERROR'.
END.
IF ccbcdocu.flgest = 'A' THEN DO:
    pError = "Documento (" + pCodDoc + "-" + pNroDoc + ") está ANULADO".
    RETURN "ADM-ERROR".
END.

/* ****************************************************************************************** */
/* Ic - 21Dic2016, si no tiene HASH, intentar enviarlo a PPLL */
/* ****************************************************************************************** */
DEFINE VAR lVeces AS INT.
DEFINE VAR lSec1 AS INT.
DEFINE VAR lRetVal AS CHAR.

DEFINE VAR x-suspension AS LOG INIT NO.

IF s-user-id = 'ADMIN' OR USERID("DICTDB") = "MASTER" THEN DO: 
    MESSAGE "Esta en MODO - ADMIN/MASTER, no verifica envio de comprobante".
END.
/* Liberado */
x-suspension = NO.
/* Ic - 21Dic2016 - FIN  */
IF x-suspension = NO THEN DO:
    IF NOT (s-user-id = 'ADMIN' OR USERID("DICTDB") = 'MASTER') THEN DO:
        RUN PRINT_Enviar-Sunat (OUTPUT lRetVal, OUTPUT pError).
        IF RETURN-VALUE = 'PLAN-B' THEN x-Suspension = YES.
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    END.
END.
/* ****************************************************************************************** */
/* Ic - 28Nov2016, Verificar si el documento tiene HASH para la impresion */
/* RHC 30/05/18 saltamos esta parte para hacer pruebas del sistema */
/* ****************************************************************************************** */
DEFINE VAR x-nro-ic AS CHAR.

IF s-user-id = 'ADMIN' OR USERID("DICTDB") = 'MASTER' THEN x-suspension = YES.

IF x-suspension = NO THEN DO:
    RUN PRINT_Verifica-Hash (OUTPUT pError).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
END.
/* ****************************************************************************************** */

/* */
DEF VAR C-MONEDA   AS CHAR FORMAT "x(8)"  NO-UNDO.
DEF VAR C-NomCon   AS CHAR FORMAT "X(40)".
DEF VAR C-DESALM   AS CHAR NO-UNDO FORMAT "X(40)".
DEF VAR X-EnLetras AS CHAR FORMAT "x(60)" NO-UNDO.
/* */
/* Variables Promociones */
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
IF AVAILABLE gn-ConVt THEN ASSIGN C-NomCon = gn-ConVt.Nombr.
/* ****************************************************************************************** */
/* Verifica que la cancelación se realizó con CHEQUE */
/* ****************************************************************************************** */
RUN PRINT_Datos-Cheque.
/* ****************************************************************************************** */
/* ****************************************************************************************** */
/* ****************************************************************************************** */
/* LOGICA PRINCIPAL */
/* ****************************************************************************************** */
/* ****************************************************************************************** */
ASSIGN
    RB-REPORT-NAME = IF (pFormatoTck = YES ) THEN "ticket comprobante electronico" ELSE "docto venta electronico".
/* ************************************************* */
/* 09/03/2023 Formato para venta itinerante D.Llican */
/* ************************************************* */
IF LOOKUP(pCodDiv, '00600,00601') > 0 THEN RB-REPORT-NAME = "Docto Venta Electronico PrePrint".
/* ****************************************************************************** */
/* 25/03/2023: El formato de impresión depende de la configuración de la división */
/* ****************************************************************************** */
FIND FacTabla WHERE FacTabla.CodCia = s-codcia AND
    FacTabla.Tabla = "CFG_FMT_MAY_MOSTRADOR" AND
    FacTabla.Codigo = pCodDiv
    NO-LOCK NO-ERROR.
IF AVAILABLE FacTabla THEN DO:
    CASE FacTabla.Campo-C[1]:
        WHEN "TICKET" THEN ASSIGN RB-REPORT-NAME = "ticket comprobante electronico" pFormatoTCK = YES.
        WHEN "A41" THEN ASSIGN RB-REPORT-NAME = "docto venta electronico" pFormatoTCK = NO.
        WHEN "A42" THEN ASSIGN RB-REPORT-NAME = "Docto Venta Electronico PrePrint" pFormatoTCK = NO.
    END CASE.
END.
/* ****************************************************************************** */
/* ****************************************************************************** */
RUN PRINT_Carga-Impresion (INPUT pVersion,
                           INPUT pFormatoTCK,
                           INPUT pCodDiv).
/* ****************************************************************************************** */
RUN PRINT_Graba-Log (INPUT pVersion).
/* ****************************************************************************************** */
RUN PRINT_enviar-impresion-QR (INPUT pImprimeDirecto,
                               INPUT pNombreImpresora,
                               INPUT pVersion,
                               INPUT pCodDiv,
                               INPUT pFormatoTck,
                               OUTPUT pError).
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
/* ****************************************************************************************** */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_log-txt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRINT_log-txt Procedure 
PROCEDURE PRINT_log-txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pTexto AS CHAR.

DEFINE VAR y-filer AS CHAR.

y-filer = PRINT_flog-epos-txt(pTexto).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_otros-descuentos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRINT_otros-descuentos Procedure 
PROCEDURE PRINT_otros-descuentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

DEFINE VAR x-dscto-otros AS CHAR.
DEFINE VAR x-dscto-otros-tabla AS CHAR INIT "TIPO_DSCTO".

pRetVal = "".

IF NOT (TRUE <> (ccbcdocu.dcto_otros_mot > "")) AND ccbcdocu.dcto_otros_pv > 0 THEN DO:

    pRetVal = "DESCUENTO POR " + TRIM(ccbcdocu.dcto_otros_mot) + " = " + 
                        TRIM(STRING(ccbcdocu.dcto_otros_pv,"->,>>>,>>9.99")).

    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
        vtatabla.tabla = x-dscto-otros-tabla AND
        vtatabla.llave_c1 = ccbcdocu.dcto_otros_mot NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN DO:
        IF NOT (TRUE <> (vtatabla.libre_c01 > "")) THEN DO:
            pRetVal = TRIM(vtatabla.libre_c01) + " = " + TRIM(STRING(ccbcdocu.dcto_otros_pv,"->,>>>,>>9.99")).
        END.
    END.
    IF ccbcdocu.codmon = 2 THEN DO:
        pRetVal = CAPS(pRetVal) + " DOLARES AMERICANOS".
    END.
    ELSE DO:
        pRetVal = CAPS(pRetVal) + " SOLES".
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_Verifica-Hash) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PRINT_Verifica-Hash Procedure 
PROCEDURE PRINT_Verifica-Hash :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

DEF VAR x-nro-ic AS CHAR NO-UNDO.

    FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = ccbcdocu.codcia AND
        FELogComprobantes.coddiv = ccbcdocu.coddiv AND
        FELogComprobantes.coddoc = ccbcdocu.coddoc AND
        FELogComprobantes.nrodoc = ccbcdocu.nrodoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FELogComprobantes THEN DO:
        /* No esta registrado en FELOGCOMPROBANTES */
        RUN PRINT_log-txt("IMPRIMIR DOCMTO (verifica doc) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + 
                    ccbcdocu.nrodoc + " Aun no enviado a SUNAT").
        FIND FIRST x-ccbdcaja WHERE x-ccbdcaja.codcia = s-codcia AND
            x-ccbdcaja.codref = ccbcdocu.coddoc AND 
            x-ccbdcaja.nroref = ccbcdocu.nrodoc NO-LOCK NO-ERROR.
        IF AVAILABLE x-ccbdcaja THEN DO:
            RUN PRINT_log-txt("IMPRIMIR DOCMTO (verifica doc - Debe anular el Ingreso a caja) : " + 
                        ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc + " Aun no enviado a SUNAT").
            x-nro-ic = x-ccbdcaja.nrodoc.
            pError = "Documento no enviado a SUNAT " + CHR(10) +
                    "Por favor ANULAR la cobranza realizada (I/C nro : " + x-nro-ic + ")" + CHR(10) +
                    "y luego vuelva a cobrar el comprobante (" + ccbcdocu.coddoc + " - " + ccbcdocu.nrodoc + ")".
            RETURN "ADM-ERROR".
        END.
        ELSE DO:
            MESSAGE "Documento aún no ha sido enviado a SUNAT" SKIP(1)
                "Se procede a CERRAR el SISTEMA por SEGURIDAD. Volver a entrar y repita el proceso."
                VIEW-AS ALERT-BOX ERROR.
            QUIT.
        END.
    END.
    IF TRUE <> (FELogComprobantes.codhash > "") THEN DO:
        /* Esta registrado en FELOGCOMPROBANTES, pero no tiene HASH */
        RUN PRINT_log-txt("IMPRIMIR DOCMTO (verifica hash) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + 
                    ccbcdocu.nrodoc + " No tiene el HASH").
        FIND FIRST x-ccbdcaja WHERE x-ccbdcaja.codcia = s-codcia AND
            x-ccbdcaja.codref = ccbcdocu.coddoc AND 
            x-ccbdcaja.nroref = ccbcdocu.nrodoc NO-LOCK NO-ERROR.
        IF AVAILABLE x-ccbdcaja THEN DO:
            RUN PRINT_log-txt("IMPRIMIR DOCMTO (verifica hash - Debe anular el ingreso a caja) : " + ccbcdocu.coddiv + " " + 
                        ccbcdocu.coddoc + " " + ccbcdocu.nrodoc + " No tiene el HASH").
            x-nro-ic = x-ccbdcaja.nrodoc.
            pError = "Documento no tiene el timbre (HASH) " + CHR(10) +
                    "Por favor ANULAR la cobranza realizada (I/C nro : " + x-nro-ic + ")" + CHR(10) +
                    "y luego vuelva a cobrar el comprobante (" + ccbcdocu.coddoc + " - " + ccbcdocu.nrodoc + ")".
            RETURN "ADM-ERROR".
        END.
        ELSE DO:
            MESSAGE "El documento NO TIENE el timbre(HASH) de seguridad de la SUNAT " SKIP(1)
                "Se procede a CERRAR el SISTEMA por SEGURIDAD. Volver a entrar y repita el proceso."
                VIEW-AS ALERT-BOX ERROR.
            QUIT.
        END.
    END.

    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-PRINT_fget-data-qr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION PRINT_fget-data-qr Procedure 
FUNCTION PRINT_fget-data-qr RETURNS CHARACTER () :

DEFINE VAR x-retval AS CHAR INIT "".

DEFINE VAR hSunatLibrary AS HANDLE NO-UNDO.

RUN sunat/sunat-library PERSISTENT SET hSunatLibrary.

RUN GetDataQR IN hSunatLibrary (INPUT Ccbcdocu.CodDoc, INPUT Ccbcdocu.NroDoc, OUTPUT x-RetVal).

DELETE PROCEDURE hSunatLibrary.

RETURN x-retval.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_fget-descripcion-articulo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION PRINT_fget-descripcion-articulo Procedure 
FUNCTION PRINT_fget-descripcion-articulo RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR, INPUT pCodDoc AS CHAR, INPUT pCondCred AS CHAR, INPUT pTipoFac AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  22Jul2016 : Segungo valor es la MARCA Descripcion|Marca
------------------------------------------------------------------------------*/

    DEFINE VAR lRetVal AS CHAR INIT " | ".

    DEFINE BUFFER bz-almmmatg FOR almmmatg.

    FIND FIRST bz-almmmatg WHERE bz-almmmatg.codcia = s-codcia AND 
                                bz-almmmatg.codmat = pCodMat
                                NO-LOCK NO-ERROR.
    IF AVAILABLE bz-almmmatg THEN lRetVal = TRIM(almmmatg.desmat) + "|" + TRIM(almmmatg.desmar).

    IF pCoddoc = 'N/C' OR pCoddoc = 'N/D' THEN DO:
        /* Notas de Credito / Debito que no es devolucion de Mercaderia */
        IF pCondCred <> 'D' THEN DO:
            FIND FIRST ccbtabla WHERE ccbtabla.codcia = s-codcia AND 
                                        ccbtabla.tabla = pCoddoc AND 
                                        ccbtabla.codigo = pCodmat
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE ccbtabla THEN DO:
                lRetVal = TRIM(ccbtabla.nombre) + "| ".
            END.
        END.
    END.
    ELSE DO:
        IF pTipoFac = 'S' /*OR pTipoFac = 'A' */ THEN DO:
            /* Factura de Servicios o Anticipo de campaña */
            FIND FIRST almmserv WHERE almmserv.codcia = s-codcia AND 
                                        almmserv.codmat = pCodMat 
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE almmserv THEN DO:
                lRetVal = TRIM(almmserv.desmat) + "| ".
            END.
        END.        
    END.

    RELEASE bz-almmmatg.


  RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_fget-documento-origen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION PRINT_fget-documento-origen Procedure 
FUNCTION PRINT_fget-documento-origen RETURNS CHARACTER
  ( INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Se debe enviar N/C o N/D
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lRetVal AS CHAR.

    DEFINE VAR hSunatLibrary AS HANDLE NO-UNDO.

    RUN sunat/sunat-library PERSISTENT SET hSunatLibrary.

    RUN GetSourceDocument IN hSunatLibrary (INPUT pTipoDoc, INPUT pNroDoc, OUTPUT lRetVal).

    DELETE PROCEDURE hSunatLibrary.

    RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_fget-fecha-emision-ref) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION PRINT_fget-fecha-emision-ref Procedure 
FUNCTION PRINT_fget-fecha-emision-ref RETURNS DATE
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

&IF DEFINED(EXCLUDE-PRINT_fget-prefijo-serie) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION PRINT_fget-prefijo-serie Procedure 
FUNCTION PRINT_fget-prefijo-serie RETURNS CHARACTER
      (INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR, INPUT pDivision AS CHAR) :

DEFINE VAR lxRet AS CHAR.

DEFINE VAR hSunatLibrary AS HANDLE NO-UNDO.

RUN sunat/sunat-library PERSISTENT SET hSunatLibrary.

RUN GetSerialPrefix IN hSunatLibrary (INPUT pTipoDoc, INPUT pNroDoc, INPUT pDivision, OUTPUT lxRet).

DELETE PROCEDURE hSunatLibrary.

RETURN lxRet.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-PRINT_flog-epos-txt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION PRINT_flog-epos-txt Procedure 
FUNCTION PRINT_flog-epos-txt RETURNS CHARACTER
  (INPUT pTexto AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR hSunatLibrary AS HANDLE NO-UNDO.

RUN sunat/sunat-library PERSISTENT SET hSunatLibrary.

RUN GenerateLogEposTxt IN hSunatLibrary (INPUT pTexto).

DELETE PROCEDURE hSunatLibrary.

RETURN "".  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

