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
    Syntax      : xxxxxxxxxxxx
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
DEFINE INPUT PARAMETER pFormatoTck AS LOG.
DEFINE INPUT PARAMETER pImprimeDirecto AS LOG.
DEFINE INPUT PARAMETER pNombreImpresora AS CHAR.

DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-codter  LIKE ccbcterm.codter.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv  AS CHAR.

/* 14/7/23: Impresión de BULTOS S.Leon */
DEF VAR x-Bultos AS INTE NO-UNDO.

DEFINE VAR cImprimeDirecto AS CHAR INIT "No" NO-UNDO. 

DEFINE VAR x-electronica AS CHAR INIT "ELECTRONICA".

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

FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
    ccbcdocu.coddiv = pCodDiv AND 
    ccbcdocu.coddoc = pCodDoc AND 
    ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN RETURN.
IF ccbcdocu.flgest = 'A' THEN DO:
    MESSAGE "Documento (" + pCodDoc + "-" + pNroDoc + ") esta ANULADO".
    RETURN "ADM-ERROR".
END.
/* 
    Ic - 21Dic2016, si no tiene HASH, intentar enviar el a PPLL
*/
DEFINE VAR lVeces AS INT.
DEFINE VAR lSec1 AS INT.
DEFINE VAR lRetVal AS CHAR.
DEFINE VAR y-filer AS CHAR.

DEFINE VAR x-suspension AS LOG INIT NO.
IF TODAY = DATE(01,04,2019) THEN DO:
    IF STRING(TIME,"HH:MM:SS") <= '16:00:00' THEN x-suspension = YES.
END.
IF s-user-id = 'ADMIN' OR USERID("DICTDB") = "master" THEN DO: 
    MESSAGE "Esta en MODO - ADMIN/MASTER, no verifica envio de comprobante".
END.
/* Liberado */
x-suspension = NO.
/* Ic - 21Dic2016 - FIN  */
RLOOP:
DO:
IF x-suspension = NO THEN DO:
    IF s-user-id = 'ADMIN' OR USERID("DICTDB") = 'MASTER' THEN DO:
        /* No verifica envio */
        MESSAGE "Estas en MODO : " USERID("DICTDB").
    END.
    ELSE DO:        
        FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = ccbcdocu.codcia AND
                                            FELogComprobantes.coddiv = ccbcdocu.coddiv AND
                                            FELogComprobantes.coddoc = ccbcdocu.coddoc AND
                                            FELogComprobantes.nrodoc = ccbcdocu.nrodoc
                                            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE FELogComprobantes THEN DO:
            RUN log-txt("IMPRIMIR DOCMTO (ENVIANDO A SUNAT - INICIO) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc + " me percate que no se habia enviado a SUNAT").
            RUN sunat\progress-to-ppll-v3( INPUT Ccbcdocu.coddiv,
                                           INPUT Ccbcdocu.coddoc,
                                           INPUT Ccbcdocu.nrodoc,
                                           INPUT-OUTPUT TABLE T-FELogErrores,
                                           OUTPUT lRetVal ).
            IF RETURN-VALUE = 'PLAN-B' THEN DO:
                x-Suspension = YES.
                LEAVE RLOOP.
            END.
            IF CAPS(lRetVal) <> 'OK' THEN DO:
                RUN log-txt("IMPRIMIR DOCMTO (ENVIANDO A SUNAT - FIN) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc + " hubo problemas de enviooo a SUNAT").
                MESSAGE "Hubo problemas al enviar el documento a SUNAT" SKIP
                        "(" + lRetVal + ")".
                RETURN.
            END.
            RUN log-txt("IMPRIMIR DOCMTO (ENVIADO A SUNAT) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc + " se envio a SUNAT").
        END.
    END.
END.
END.
y-filer = "".
DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER x-ccbdcaja FOR ccbdcaja.
DEFINE BUFFER x-ccbccaja FOR ccbccaja.
DEFINE BUFFER x-felogerrores FOR felogerrores.
DEFINE VAR x-nro-ic AS CHAR.
/* Ic - 28Nov2016, Verificar si el documento tiene HASH para la impresion */
/* RHC 30/05/18 saltamos esta parte para hacer pruebas del sistema */

IF s-user-id = 'ADMIN' OR USERID("DICTDB") = 'MASTER' THEN x-suspension = YES.

IF x-suspension = NO THEN DO:
    /*IF s-user-id <> 'ADMIN' AND pCodDoc <> "N/C" THEN DO:*/
        FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = ccbcdocu.codcia AND
            FELogComprobantes.coddiv = ccbcdocu.coddiv AND
            FELogComprobantes.coddoc = ccbcdocu.coddoc AND
            FELogComprobantes.nrodoc = ccbcdocu.nrodoc
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE FELogComprobantes THEN DO:
            /* No esta registrado en FELOGCOMPROBANTES */
            RUN log-txt("IMPRIMIR DOCMTO (verifica doc) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc + " Aun no enviado a SUNAT").
            FIND FIRST x-ccbdcaja WHERE x-ccbdcaja.codcia = s-codcia AND
                x-ccbdcaja.codref = ccbcdocu.coddoc AND 
                x-ccbdcaja.nroref = ccbcdocu.nrodoc NO-LOCK NO-ERROR.
            IF AVAILABLE x-ccbdcaja THEN DO:
                RUN log-txt("IMPRIMIR DOCMTO (verifica doc - Debe anular el Ingreso a caja) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc + " Aun no enviado a SUNAT").
                x-nro-ic = x-ccbdcaja.nrodoc.
                MESSAGE "Documento no enviado a SUNAT " SKIP
                        "Por favor ANULAR la cobranza realizada (I/C nro : " + x-nro-ic + ")" SKIP
                        "y luego vuelva a cobrar el comprobante (" + ccbcdocu.coddoc + " - " + ccbcdocu.nrodoc + ")"
                    VIEW-AS ALERT-BOX ERROR.
                RETURN "ADM-ERROR".
            END.
            ELSE DO:
                MESSAGE "Documento aun no ha sido enviado a SUNAT" SKIP(1)
                    "Se procede a CERRAR el SISTEMA por SEGURIDAD. Volver a entrar y repita el proceso."
                    VIEW-AS ALERT-BOX ERROR.
                QUIT.
            END.
        END.
        IF TRUE <> (FELogComprobantes.codhash > "") THEN DO:
            /* Esta registrado en FELOGCOMPROBANTES, pero no tiene HASH */
            RUN log-txt("IMPRIMIR DOCMTO (verifica hash) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc + " No tiene el HASH").
            FIND FIRST x-ccbdcaja WHERE x-ccbdcaja.codcia = s-codcia AND
                x-ccbdcaja.codref = ccbcdocu.coddoc AND 
                x-ccbdcaja.nroref = ccbcdocu.nrodoc NO-LOCK NO-ERROR.
            IF AVAILABLE x-ccbdcaja THEN DO:
                RUN log-txt("IMPRIMIR DOCMTO (verifica hash - Debe anular el ingreso a caja) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc + " No tiene el HASH").
                x-nro-ic = x-ccbdcaja.nrodoc.
                MESSAGE "Documento no tiene el timbre (HASH) " SKIP
                        "Por favor ANULAR la cobranza realizada (I/C nro : " + x-nro-ic + ")" SKIP
                        "y luego vuelva a cobrar el comprobante (" + ccbcdocu.coddoc + " - " + ccbcdocu.nrodoc + ")"
                    VIEW-AS ALERT-BOX ERROR.        
                RETURN "ADM-ERROR".
            END.
            ELSE DO:
                MESSAGE "El documento NO TIENE el timbre(HASH) de seguridad de la SUNAT " SKIP(1)
                    "Se procede a CERRAR el SISTEMA por SEGURIDAD. Volver a entrar y repita el proceso."
                    VIEW-AS ALERT-BOX ERROR.
                QUIT.
            END.
        END.
    /*END.*/
    /* Ic - 28Nov2016 - Fin */
END.

DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.

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
IF AVAILABLE gn-ConVt THEN ASSIGN C-NomCon = gn-ConVt.Nombr.

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
END.

/* Caracteres x Linea */
DEFINE VAR lCaracxlinea AS INT INIT 45.  /* Valido para impresion de Ticket */

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
DEFINE VAR x-version AS CHAR.

DEFINE stream log-epos.

/* Anticipos */
DEFINE VAR x-anticipo1 AS CHAR.
DEFINE VAR x-anticipo2 AS CHAR.
DEFINE VAR x-anticipo3 AS CHAR.
DEFINE VAR x-anticipo4 AS CHAR.

DEFINE VAR x-operaciones-gravadas AS DEC.
DEFINE VAR x-total-igv AS DEC.
DEFINE VAR x-total-a-pagar AS DEC.

DEFINE VAR x-anticipo-vvta AS DEC.
DEFINE VAR x-anticipo-igv AS DEC.
DEFINE VAR x-anticipo-total AS DEC.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-borrar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD borrar Procedure 
FUNCTION borrar RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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

&IF DEFINED(EXCLUDE-fget-data-qr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-data-qr Procedure 
FUNCTION fget-data-qr RETURNS CHARACTER ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-descripcion-articulo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-descripcion-articulo Procedure 
FUNCTION fget-descripcion-articulo RETURNS CHARACTER
  ( INPUT pCodMat AS CHAR, INPUT pCodDoc AS CHAR, INPUT pCondCred AS CHAR, INPUT pTipoFac AS CHAR )  FORWARD.

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

&IF DEFINED(EXCLUDE-fget-prefijo-serie) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fget-prefijo-serie Procedure 
FUNCTION fget-prefijo-serie RETURNS CHARACTER
      (INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR, INPUT pDivision AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-flog-epos-txt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD flog-epos-txt Procedure 
FUNCTION flog-epos-txt RETURNS CHARACTER
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
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 17.23
         WIDTH              = 63.43.
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
/* --------------------------------------------------------------------------- */
DEFINE VAR lGuia AS CHAR INIT "".
DEFINE VAR lPedido AS CHAR INIT "".
DEFINE VAR lFmaPgo AS CHAR INIT "".


SESSION:SET-WAIT-STATE('GENERAL').
RUN Carga-Impresion.

RUN Graba-Log.
RUN enviar-impresion-QR.

/* Eliminar el grafico QR - cuando haya tiempo */
/* ;-) */
SESSION:SET-WAIT-STATE('').

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-anticipos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE anticipos Procedure 
PROCEDURE anticipos :
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

DEFINE VAR x-anticipo AS CHAR.

IF (ccbcdocu.coddoc = 'FAC' OR ccbcdocu.coddoc = 'BOL') THEN DO:

    DEFINE VAR x-retval AS CHAR.
    DEFINE VAR x-sec AS INT.
    DEFINE VAR x-hProc AS HANDLE NO-UNDO.

    RUN gn/master-library.r PERSISTENT SET x-hProc.

    RUN anticipos-aplicados-despacho IN x-hProc (INPUT ccbcdocu.coddoc,
                                                 INPUT ccbcdocu.nrodoc,
                                                 OUTPUT x-retval).

    DELETE PROCEDURE x-hProc.

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

x-operaciones-gravadas = ccbcdocu.impvta.
x-total-igv = ccbcdocu.impigv.
x-total-a-pagar = ccbcdocu.imptot.

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

&IF DEFINED(EXCLUDE-Carga-Impresion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Impresion Procedure 
PROCEDURE Carga-Impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-filer AS CHAR.
x-filer = flog-epos-txt("IMPRIMIR DOCMTO (INICIO) : "  + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

x-filer = flog-epos-txt("IMPRIMIR DOCMTO (Cargando data) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
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
/*DEFINE VAR lTotalPagar AS DEC.*/
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
DEFINE VAR x-retval AS CHAR.
DEFINE VAR x-enviar-guia-remision AS LOG.

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
    lDataQR = fget-data-qr().
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
/*IF (ccbcdocu.codcli="11111111111") OR lDocCliente = "" THEN DO:*/
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
   lDocReferencia   = fget-documento-origen(ccbcdocu.coddoc, ccbcdocu.nrodoc).    /*F001002233*/
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
   lFEmisDocRef    = fget-fecha-emision-ref(lDocReferencia). /*lDocumentoRef = F001002233*/
   lReferencia     = IF(SUBSTRING(lDocReferencia,1,1)="B") THEN "BOLETA DE VENTA ELECTRONICA"
                       ELSE "FACTURA ELECTRONICA".
   lReferencia1     = SUBSTRING(lDocReferencia,1,4) + " - " + SUBSTRING(lDocReferencia,5).
   lReferencia1     = lReferencia1 + " - " + IF(lFEmisDocRef = ?) THEN "" 
                                           ELSE STRING(lFEmisDocRef,"99/99/9999").
END.

x-operaciones-gravadas = Ccbcdocu.TotalValorVentaNetoOpGravadas.
x-total-igv = Ccbcdocu.TotalIGV.
x-total-a-pagar = Ccbcdocu.TotalVenta.

/* Anticipos, en este procedimiento puede modificar */
RUN anticipos.

RUN lib/_numero(x-total-a-pagar, 2, 1, OUTPUT X-EnLetras).  /* ccbcdocu.imptot */
X-EnLetras = "SON : " + X-EnLetras + (IF ccbcdocu.codmon = 1 THEN " SOLES" ELSE " DOLARES AMERICANOS").

/* Digito verificador del cliente antes de anteponerle RUC ¢ DNI*/
RUN lib/calcula-digito-verificador.r(INPUT lDocCliente, OUTPUT lDigitoVerificador).

IF LENGTH(lDocCliente)=8 THEN DO :
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
    RUN consignar-guia-remision(INPUT ccbcdocu.divori, OUTPUT lGuia).
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
/* QR Code */
lPathGraficoQR = "".
RUN code-qr (INPUT lDataQR, OUTPUT lPathGraficoQR).
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
        FIND FIRST ix-ccbdmov WHERE ix-ccbdmov.codcia = s-codcia AND ix-ccbdmov.codref = ccbccaja.coddoc AND 
                                        ix-ccbdmov.nroref = ccbccaja.nrodoc AND ix-ccbdmov.coddoc = 'N/C' NO-LOCK NO-ERROR.
        IF AVAILABLE ix-ccbdmov THEN DO:
            lRefNotaCrededito = SUBSTRING(ix-ccbdmov.nrodoc,1,3) + "-" + SUBSTRING(ix-ccbdmov.nrodoc,4) .
        END.
        RELEASE ix-ccbdmov.

        lTotRecibido = lTotRecibido + ccbccaja.impnac[6].
    END.
    /* VALES */
    IF ccbccaja.impnac[10] > 0 THEN DO:
        lTotRecibido = lTotRecibido + ccbccaja.impnac[10].
    END.
END.
ELSE DO:
    /*MESSAGE "No existe el pago en Caja".*/
END.

lImpLetras = "".
lImpLetras1 = "".
lImpLetras = X-EnLetras.
IF pFormatoTck = YES THEN DO:
    lImpLetras = SUBSTRING(X-EnLetras,1,lCaracxlinea).
    IF LENGTH(x-EnLetras) > lCaracxLinea THEN DO:
        lImpLetras1 = SUBSTRING(X-EnLetras,lCaracxlinea + 1).
    END.
END.

FIND FIRST _user WHERE _user._userid = ccbcdocu.usuario NO-LOCK NO-ERROR.

lTotItems = 0.

/* --------------------------------------- */
/* Ic - 25Nov2019, imprimir en el documento electronico descuento logistico*/
RUN otros-descuentos(OUTPUT x-retval).

/* ------------------------------------------------------------------------------------ */
DEFINE VAR lxDescripcion AS CHAR.
DEFINE VAR lxDesMat AS CHAR.
DEFINE VAR lxDesMar AS CHAR.
DEFINE VAR x-dscto1 AS DEC.
FOR EACH ccbddocu OF ccbcdocu NO-LOCK BREAK BY Ccbddocu.NroItm:
    FIND FIRST almmmatg OF ccbddocu NO-LOCK NO-ERROR.
    FIND FIRST facdpedi WHERE Facdpedi.codcia = Ccbcdocu.codcia AND Facdpedi.coddoc = Ccbcdocu.codped
                            AND Facdpedi.nroped = Ccbcdocu.nroped AND Facdpedi.codmat = ccbddocu.codmat NO-LOCK NO-ERROR.
    lxDescripcion = fget-descripcion-articulo(ccbddocu.codmat, ccbcdocu.coddoc, ccbcdocu.cndcre, ccbcdocu.tpofac).
    lxDesMat = ENTRY(1,lxDescripcion,"|").
    lxDesMar = ENTRY(2,lxDescripcion,"|").
    CREATE w-report.
    ASSIGN  w-report.task-no = s-task-no
            w-report.llave-c = Ccbcdocu.coddoc + Ccbcdocu.nrodoc
            w-report.campo-c[1] = SUBSTRING(ccbddocu.codmat,1,6)
            w-report.campo-c[2] = SUBSTRING(lxDesMat,1,40) /*SUBSTRING(almmmatg.desmat,1,40)*/
            /*w-report.campo-f[1] = ccbddocu.implin - ccbddocu.impdto2    /* <<<< OJO: impdto2 Descuento Final <<<< */*/
            /*w-report.campo-f[1] = Ccbddocu.cImporteTotalConImpuesto*/
            w-report.campo-f[1] = CcbDDocu.MontoBaseIGV + CcbDDocu.ImporteIGV
            w-report.campo-c[3] = IF (AVAILABLE almmmatg) THEN STRING(almmmatg.codbrr,'9999999999999') ELSE ""
            w-report.campo-c[4] = SUBSTRING(lxDesMar,1,40)  /*SUBSTRING(almmmatg.desmar,1,40)*/
            w-report.campo-c[5] = SUBSTRING(Ccbddocu.undvta,1,5)
            w-report.campo-f[2] = Ccbddocu.candes
            w-report.campo-f[3] = Ccbddocu.preuni
            w-report.campo-c[30] = lPathGraficoQR /* lHashCodePDF417*/ /*lCodHash*/
            w-report.campo-d[1] = ccbcdocu.fchdoc
            w-report.campo-d[2] = ccbcdocu.fchvto
            w-report.campo-c[6] = ccbcdocu.horcie
            w-report.campo-c[7] = ccbcdocu.coddiv
            w-report.campo-c[8] = lTelfTienda
            w-report.campo-c[9] = ccbcdocu.usuario + " " + IF(AVAILABLE _user) THEN _user._user-name ELSE ""
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

x-filer = flog-epos-txt("IMPRIMIR DOCMTO (Cargando data - linea adicionales) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

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

/* 14/7/23: Impresión de BULTOS S.Leon */
x-Bultos = 0.
FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = Ccbcdocu.codcia AND
    CcbCBult.CodDoc = Ccbcdocu.libre_c01 AND
    CcbCBult.NroDoc = Ccbcdocu.libre_c02:
    x-Bultos = x-Bultos + CcbCBult.Bultos.
END.


x-filer = flog-epos-txt("IMPRIMIR DOCMTO (Data cargada) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

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

DEFINE VAR x-tmpdir AS CHAR.

tcText = "".
tcFile = "".
sPathGraficoQR = "".   

IF NUM-ENTRIES(sDataQR,"|") >= 9 THEN DO:
    tcText = sDataQR.
    x-tmpdir = LC(SESSION:TEMP-DIRECTORY).
    x-tmpdir = IF (INDEX(x-tmpdir,"\documents and settings") > 0) THEN ".\" ELSE x-tmpdir.
    /*tcFile = SESSION:TEMP-DIRECTORY + ENTRY(3,tcText,"|") + "-" + ENTRY(4,tcText,"|") + "-" + ENTRY(9,tcText,"|") + ".jpg".*/
    tcFile = x-tmpdir + ENTRY(3,tcText,"|") + "-" + ENTRY(4,tcText,"|") + "-" + ENTRY(9,tcText,"|") + ".jpg".
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

&IF DEFINED(EXCLUDE-consignar-guia-remision) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consignar-guia-remision Procedure 
PROCEDURE consignar-guia-remision :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pDivision AS CHAR.
DEFINE OUTPUT PARAMETER x-guia-remision AS CHAR.

DEFINE VAR x-enviar-guia-remision AS LOG.

RUN sunat/p-consignar-guia-de-remision.r(INPUT pDivision, OUTPUT x-enviar-guia-remision).

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

&IF DEFINED(EXCLUDE-enviar-impresion-qr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviar-impresion-qr Procedure 
PROCEDURE enviar-impresion-qr PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lImpresora AS CHAR INIT "".
DEFINE VAR lPuerto AS CHAR INIT "".
DEFINE VAR x-filer AS CHAR.

DEFINE VAR x-terminal-server AS LOG.

x-filer = flog-epos-txt("IMPRIMIR DOCMTO (BUSCANDO CONFIGURACIONES) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

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

            x-filer = flog-epos-txt("IMPRIMIR DOCMTO (IMPRESION DIRECTA - TERMINAL SERVER) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

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
                x-filer = flog-epos-txt("IMPRIMIR DOCMTO (IMPRESION DIRECTA - TERMINAL SERVER) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
            END.
            ELSE DO:
                x-filer = flog-epos-txt("IMPRIMIR DOCMTO (IMPRESION DIRECTA - NO TERMINAL SERVER - IMPRESORA PREDETERMINADA) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
            END.            
            /* 1 */
            DEF VAR success AS LOGICAL.
            /* 2 Capturo la impresora por defecto */
            RUN lib/_default_printer.p (OUTPUT s-printer-name, OUTPUT s-port-name, OUTPUT success).
            /* 3 */
            IF success = NO THEN DO:
                x-filer = flog-epos-txt("IMPRIMIR DOCMTO (IMPRESION DIRECTA - NO TERMINAL SERVER - IMPRESORA PREDETERMINADA - NO HAY) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
                MESSAGE "NO hay una impresora por defecto definida" VIEW-AS ALERT-BOX ERROR.
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
        IF lImpresora = ""  THEN DO:
            IF x-terminal-server = YES THEN DO:
                x-filer = flog-epos-txt("IMPRIMIR DOCMTO (IMPRESION NO DIRECTA - TERMINAL SERVER) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
            END.
            ELSE DO:
                x-filer = flog-epos-txt("IMPRIMIR DOCMTO (IMPRESION NO DIRECTA - NO TERMINAL SERVER) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
            END.
            
            /* Si se envía un nombre se toma ese, si no se toma el de la tabla de correlativos */
            IF pNombreImpresora > "" THEN DO:
                s-printer-name = pNombreImpresora.
                IF x-terminal-server = YES THEN DO:
                    x-filer = flog-epos-txt("IMPRIMIR DOCMTO (IMPRESION NO DIRECTA - TERMINAL SERVER - IMPRESORA ENVIADA) : " + pNombreImpresora + " - " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
                END.
                ELSE DO:
                    x-filer = flog-epos-txt("IMPRIMIR DOCMTO (IMPRESION NO DIRECTA - NO TERMINAL SERVER - IMPRESORA ENVIADA) : " + pNombreImpresora + " - " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
                END.
            END.
            ELSE DO:
                IF AVAILABLE FacCorre THEN DO:
                    s-printer-name = FacCorre.Printer.
                    IF x-terminal-server = YES THEN DO:
                        x-filer = flog-epos-txt("IMPRIMIR DOCMTO (IMPRESION NO DIRECTA - TERMINAL SERVER - IMPRESORA EN EL FACCORRE) : " + s-printer-name + " - " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
                    END.
                    ELSE DO:
                        x-filer = flog-epos-txt("IMPRIMIR DOCMTO (IMPRESION NO DIRECTA - NO TERMINAL SERVER - IMPRESORA EN EL FACCORRE) : " + s-printer-name + " - " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
                    END.
                END.                   
            END.    

            IF pImprimeDirecto = YES AND s-printer-name > "" THEN DO:
                RUN lib/_port-name-v2.p (s-printer-name, OUTPUT s-port-name).
                IF s-port-name = '' THEN DO:
                    MESSAGE 'NO está definida la impresora ' SKIP
                        'División:' Ccbcdocu.coddiv SKIP
                        'Documento:' Ccbcdocu.coddoc SKIP
                        'N° Serie:' SUBSTRING(CcbCDocu.NroDoc, 1, 3) SKIP
                        'Impresora:' s-printer-name '<<<'
                        VIEW-AS ALERT-BOX WARNING.
                    RETURN.
                END.
            END.
            ELSE DO:
                /**/
                RUN bin/_prnctr.p.
                IF s-salida-impresion = 0 THEN RETURN.
                RUN lib/_port-name-v2.p (s-printer-name, OUTPUT s-port-name).
            END.
        END.
    END.
END CASE.

IF ccbcdocu.fmapgo = '899' THEN lNombreDocumento = "BONIFICACION".
IF ccbcdocu.fmapgo = '899' THEN x-electronica = "PROMOCIONAL".

x-filer = flog-epos-txt("IMPRIMIR DOCMTO (Inicia-Impresora) : " + s-printer-name + ":" + s-port-name + " " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

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

x-filer = flog-epos-txt("IMPRIMIR DOCMTO (Parametros del ReportBuilder) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

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
                        "~npElectronica = " + x-Electronica
                        .
/* 14/7/23: Impresión de BULTOS S.Leon */
IF x-Bultos > 0 THEN RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + "~npNroBultos = BULTOS: " + STRING(x-Bultos).

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
        MESSAGE "No se pudieron ubicar las credenciales para" SKIP
                "la conexion del REPORTBUILDER" SKIP
                "--------------------------------------------" SKIP
                "Comunicarse con el area de sistemas - desarrollo"
            VIEW-AS ALERT-BOX INFORMATION.

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

/*    ASSIGN                                                */
/*        cNewConnString =                                  */
/*        "-db" + cDelimeter + cDatabaseName + cDelimeter + */
/*        "-H" + cDelimeter + cHostName + cDelimeter +      */
/*        "-N" + cDelimeter + cNetworkProto + cDelimeter +  */
/*        "-S" + cDelimeter + cPortNumber + cDelimeter.     */

   IF cOtherParams > '' THEN cNewConnString = cNewConnString + cOtherParams + cDelimeter.
   RB-DB-CONNECTION = cNewConnString.
END.

ASSIGN
    RB-REPORT-NAME = IF (pFormatoTck = YES ) THEN "ticket venta electronico" ELSE "docto venta electronico"
    RB-BEGIN-PAGE = s-pagina-inicial
    RB-END-PAGE = s-pagina-final
    RB-PRINTER-NAME = s-port-name       /*s-printer-name*/
    /*RB-PRINTER-PORT = s-port-name*/
    RB-OUTPUT-FILE = s-print-file
    RB-NUMBER-COPIES = s-nro-copias.
/* ************************************************* */
/* 09/03/2023 Formato para venta itinerante D.Llican */
/* ************************************************* */
IF LOOKUP(pCodDiv, '00600,00601') > 0 THEN RB-REPORT-NAME = "Docto Venta Electronico PrePrint".
/*RB-REPORT-NAME = "Docto Venta Electronico PrePrint".*/

CASE s-salida-impresion:
  WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
  WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
  WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
END CASE.

x-filer = flog-epos-txt("IMPRIMIR DOCMTO (Inicia Impresion ReportBuilder) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

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

x-filer = flog-epos-txt("IMPRIMIR DOCMTO (Termino Impresion ReportBuilder) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

x-filer = flog-epos-txt("IMPRIMIR DOCMTO (Eliminado el temporal - INICIO) " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

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

x-filer = flog-epos-txt("IMPRIMIR DOCMTO (Eliminando el Temporal - FIN) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

x-filer = flog-epos-txt("IMPRIMIR DOCMTO (FINAL) : " + s-printer-name + ":" + s-port-name + " " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).

/* ********************************************************************************************** */
/* 1/8/23: Log de control de impresiones */
/* ********************************************************************************************** */
CREATE Invoices_Printed.
ASSIGN
    Invoices_Printed.CodCia = s-codcia 
    Invoices_Printed.CodDoc = Ccbcdocu.coddoc
    Invoices_Printed.Date_Printed = NOW
    Invoices_Printed.NroDoc = Ccbcdocu.nrodoc
    Invoices_Printed.User_Printed = USERID("dictdb")
    Invoices_Printed.Version_Printed = pVersion.
RELEASE Invoices_Printed.
/* ********************************************************************************************** */
/* ********************************************************************************************** */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-port-name) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-port-name Procedure 
PROCEDURE get-port-name :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT-OUTPUT PARAMETER s-printer-name AS CHAR.
DEF OUTPUT PARAMETER s-port-name   AS CHAR.

DEF VAR s-printer-list  AS CHAR NO-UNDO.
DEF VAR s-port-list     AS CHAR NO-UNDO.
DEF VAR s-printer-count AS INT  NO-UNDO.
DEFINE VAR i AS INT.

s-port-name = ''.

IF s-printer-name = '' THEN DO:
    MESSAGE 'No hay una impresora definida' SKIP
        'Revise la configuración de documentos'
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

/* Definimos impresoras */
RUN aderb/_prlist ( OUTPUT s-printer-list,
                    OUTPUT s-port-list,
                    OUTPUT s-printer-count ).

iLoop:
DO i = 1 TO s-printer-count:
    
    IF INDEX(ENTRY(i, s-printer-list), s-printer-name) > 0
    THEN DO:
        
        s-printer-name = ENTRY(i, s-printer-list).

        /* Caso Impresión en Graphon */
        IF INDEX(s-printer-list,"@") > 0 THEN DO:
            s-port-name = ENTRY(i, s-port-list).
            s-port-name = REPLACE(S-PORT-NAME, ":", "").
            /*IF NUM-ENTRIES(s-port-name, "-") > 2 THEN LEAVE iloop.*/
            /*MESSAGE 1 ENTRY(i, s-printer-list) s-printer-name.*/
        END.
        /* Caso Windows - NO GRAPHON */
        ELSE DO:            
            s-port-name = ENTRY(i, s-port-list).
            s-port-name = REPLACE(S-PORT-NAME, ":", "").
            /*MESSAGE s-port-name.*/
            /*IF LOOKUP(s-port-name, 'LPT1,LPT2,LPT3,LPT4,LPT5,LPT6') = 0 THEN s-port-name = ENTRY(i, s-printer-list).*/
            /*MESSAGE s-port-name.*/
            /*MESSAGE 2 ENTRY(i, s-printer-list) s-printer-name.*/
            /*IF NUM-ENTRIES(s-port-name, "-") > 1 THEN LEAVE iloop.*/
        END.
    END.
END.
IF s-port-name = '' THEN DO:
   MESSAGE "Impresora" s-printer-name "NO está instalada" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.


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

DEFINE VAR x-filer AS CHAR.

IF pVersion = "R" THEN DO:
    x-filer = flog-epos-txt("IMPRIMIR DOCMTO (LOG DE REIMPRESION - INICIO) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
    RUN lib/logtabla ("ccbcdocu",ccbcdocu.coddoc + '|' + ccbcdocu.nrodoc, "REIMPRESION").
    x-filer = flog-epos-txt("IMPRIMIR DOCMTO (LOG DE REIMPRESION - FIN) : " + ccbcdocu.coddiv + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc).
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

&IF DEFINED(EXCLUDE-log-txt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE log-txt Procedure 
PROCEDURE log-txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pTexto AS CHAR.

DEFINE VAR y-filer AS CHAR.

y-filer = flog-epos-txt(pTexto).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-otros-descuentos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE otros-descuentos Procedure 
PROCEDURE otros-descuentos :
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
            pRetVal = TRIM(vtatabla.libre_c01) + " = " + 
                                TRIM(STRING(ccbcdocu.dcto_otros_pv,"->,>>>,>>9.99")).
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

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-borrar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION borrar Procedure 
FUNCTION borrar RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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

&IF DEFINED(EXCLUDE-fget-data-qr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-data-qr Procedure 
FUNCTION fget-data-qr RETURNS CHARACTER () :

DEFINE VAR x-ruc-cli AS CHAR.
DEFINE VAR x-tipo-ide AS CHAR.
DEFINE VAR x-Importe-maximo-boleta AS DEC INIT 700.
DEFINE VAR x-retval AS CHAR INIT "".
DEFINE VAR x-emision AS CHAR INIT "".

DEFINE VAR cRucEmpresa AS CHAR.
DEFINE VAR cSerieSunat AS CHAR.
DEFINE VAR cCorrelativoSunat AS CHAR.
DEFINE VAR cTipoDoctoSunat AS CHAR.

cRucEmpresa = "20100038146".
x-emision = SUBSTRING(STRING(ccbcdocu.fchdoc,"99-99-9999"),7,4) + "-".
x-emision = x-emision + SUBSTRING(STRING(ccbcdocu.fchdoc,"99-99-9999"),4,2) + "-" .
x-emision = x-emision + SUBSTRING(STRING(ccbcdocu.fchdoc,"99-99-9999"),1,2).

x-Ruc-Cli = IF (ccbcdocu.ruccli = ?) THEN "" ELSE TRIM(ccbcdocu.ruccli).
x-Tipo-Ide = '6'.
/* UTF-8 */

IF ccbcdocu.coddoc = 'BOL' THEN DO:
    IF ccbcdocu.imptot > x-Importe-maximo-boleta THEN DO:
        IF x-Ruc-Cli = "" THEN DO:
            x-Ruc-Cli = IF (ccbcdocu.codant = ?) THEN "" ELSE TRIM(ccbcdocu.codant).
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
cSerieSunat = fGet-prefijo-serie(ccbcdocu.coddoc, ccbcdocu.nrodoc, ccbcdocu.coddiv).

cSerieSunat = cSerieSunat  +  SUBSTRING(ccbcdocu.nrodoc,1,3).
cCorrelativoSunat   = SUBSTRING(ccbcdocu.nrodoc,4).

IF ccbcdocu.coddoc = 'FAC' THEN cTipoDoctoSunat     = '01'.
IF ccbcdocu.coddoc = 'BOL' THEN cTipoDoctoSunat     = '03'.
IF ccbcdocu.coddoc = 'N/C' THEN cTipoDoctoSunat     = '07'.
IF ccbcdocu.coddoc = 'N/D' THEN cTipoDoctoSunat     = '08'. 

x-retval = cRucEmpresa + "|" + cTipoDoctoSunat + "|" + cSerieSunat + "|" + cCorrelativoSunat + "|" + 
            TRIM(STRING(ccbcdocu.impigv,">>,>>>,>>9.99")) + "|" + TRIM(STRING(ccbcdocu.imptot,">>>,>>>,>>9.99")) + "|" +
            x-emision + "|" + x-tipo-ide + "|" + x-ruc-cli + "|".


RETURN x-retval.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fget-descripcion-articulo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-descripcion-articulo Procedure 
FUNCTION fget-descripcion-articulo RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-fget-prefijo-serie) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fget-prefijo-serie Procedure 
FUNCTION fget-prefijo-serie RETURNS CHARACTER
      (INPUT pTipoDoc AS CHAR, INPUT pNroDoc AS CHAR, INPUT pDivision AS CHAR) :

        DEFINE VAR lxRet AS CHAR.

        lxRet = '?'.

        IF pTipoDoc = 'N/C' OR pTipoDoc = 'N/D' THEN DO:

            DEFINE BUFFER z-ccbcdocu FOR ccbcdocu.            

            IF pDivision <> "" THEN DO:
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
                    lxRet = fget-documento-origen(z-ccbcdocu.codref, z-ccbcdocu.nroref).                
                    lxRet = SUBSTRING(lxRet,1,1).
                END.
                ELSE lxRet = fGet-Prefijo-Serie(z-ccbcdocu.codref, z-ccbcdocu.nroref, "").
            END.
            ELSE lxRet = '?'.

            /*RELEASE z-ccbcdocu.*/
        END.
        ELSE DO:
            IF pTipoDoc = 'FAC' THEN lxRet = 'F'.
            IF pTipoDoc = 'BOL' OR pTipoDoc = 'TCK' THEN lxRet = 'B'.        
        END.


      RETURN lxRet.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-flog-epos-txt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION flog-epos-txt Procedure 
FUNCTION flog-epos-txt RETURNS CHARACTER
  (INPUT pTexto AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE BUFFER x-factabla FOR factabla.

DEFINE VAR lPCName AS CHAR.  

/*
/* ---- */
DEFINE VAR lClientComputerName  AS CHAR.
DEFINE VAR lClientName          AS CHAR.
DEFINE VAR lComputerName        AS CHAR.

DEFINE VAR lPCName AS CHAR.

lClientComputerName = OS-GETENV ( "CLIENTCOMPUTERNAME").
lClientName         = OS-GETENV ( "CLIENTNAME").
lComputerName       = OS-GETENV ( "COMPUTERNAME").

lPcName = IF (lClientComputerName = ? OR lClientComputerName = "") THEN lClientName ELSE lClientComputerName.
lPCName = IF (CAPS(lPCName) = "CONSOLE") THEN "" ELSE lPCName.
lPCName = IF (lPCName = ? OR lPCName = "") THEN lComputerName ELSE lPCName.
/* ------ */
*/
  
RUN lib/_pc-name.p(OUTPUT lPcName).


/* IP de la PC */
DEFINE VAR x-ip AS CHAR.
DEFINE VAR x-pc AS CHAR.

RUN lib/_get_ip.r(OUTPUT x-pc, OUTPUT x-ip).

FIND FIRST x-factabla WHERE x-factabla.codcia = s-codcia 
                            and x-factabla.tabla = 'TXTLOGEPOS'
                            and x-factabla.codigo = 'ALL'
                            NO-LOCK NO-ERROR.

IF AVAILABLE x-factabla AND x-factabla.campo-l[1] = YES THEN DO:
    DEFINE VAR x-archivo AS CHAR.
    DEFINE VAR x-file AS CHAR.
    DEFINE VAR x-linea AS CHAR.

    x-file = STRING(TODAY,"99/99/9999").
    /*x-file = x-file + "-" + STRING(TIME,"HH:MM:SS").*/

    x-file = REPLACE(x-file,"/","").
    x-file = REPLACE(x-file,":","").

    x-archivo = session:TEMP-DIRECTORY + "conect-epos-" + x-file + ".txt".

    OUTPUT STREAM log-epos TO VALUE(x-archivo) APPEND.

    x-linea = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"hh:mm:ss") + " (" + lPCName + "-" + x-pc + ":" + x-ip + ") - " + TRIM(pTexto).

    PUT STREAM log-epos x-linea FORMAT 'x(300)' SKIP.

    OUTPUT STREAM LOG-epos CLOSE.
END.

RETURN "".  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

