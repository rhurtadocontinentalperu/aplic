&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE T-VALES NO-UNDO LIKE VtaVales.
DEFINE SHARED TEMP-TABLE T-VVALE NO-UNDO LIKE VtaVVale.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEF INPUT  PARAMETER Moneda    AS INTEGER.
DEF INPUT  PARAMETER Importe   AS DECIMAL.
DEF INPUT  PARAMETER Retencion AS DECIMAL.
DEF INPUT  PARAMETER wnomcli   AS CHAR.
DEF INPUT  PARAMETER PgoTarjCr AS CHARACTER.
DEF INPUT  PARAMETER pBanco    AS CHAR.
DEF INPUT  PARAMETER pTarjeta  AS CHAR.
DEF INPUT  PARAMETER pCodPro   AS CHAR.
DEF INPUT  PARAMETER pDNIClie  AS CHAR.
DEF INPUT  PARAMETER pRowid    AS ROWID.
DEF OUTPUT PARAMETER OK        AS LOGICAL.

/* Local Variable Definitions ---                                       */
OK = NO.
DEFINE VAR lDnixVale AS CHAR INIT "".
DEFINE VAR lPassxVale AS CHAR INIT "".

DEFINE SHARED VARIABLE s-codcli LIKE gn-clie.codcli.

DEF SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.

DEF SHARED VAR s-CodCia AS INT.
DEF SHARED VAR s-CodDiv AS CHAR.
DEF SHARED VAR s-CodDoc AS CHAR.
DEF SHARED VAR s-ptovta AS INT.
DEF SHARED VAR cl-codcia AS INT.

DEF VAR x-SaldoNC AS DEC NO-UNDO.
DEF VAR x-SaldoAR AS DEC NO-UNDO.
DEF VAR fSumSol AS DECIMAL NO-UNDO.
DEF VAR fSumDol AS DECIMAL NO-UNDO.

DEFINE NEW SHARED VARIABLE fathWH AS HANDLE NO-UNDO.

/* Se usa para las retenciones */
DEFINE SHARED TEMP-TABLE wrk_ret NO-UNDO
    FIELDS CodCia LIKE CcbDCaja.CodCia
    FIELDS CodCli LIKE CcbCDocu.CodCli
    FIELDS CodDoc LIKE CcbCDocu.CodDoc COLUMN-LABEL "Tipo  "
    FIELDS NroDoc LIKE CcbCDocu.NroDoc COLUMN-LABEL "Documento " FORMAT "x(10)"
    FIELDS CodRef LIKE CcbDCaja.CodRef
    FIELDS NroRef LIKE CcbDCaja.NroRef
    FIELDS FchDoc LIKE CcbCDocu.FchDoc COLUMN-LABEL "    Fecha    !    Emisión    "
    FIELDS FchVto LIKE CcbCDocu.FchVto COLUMN-LABEL "    Fecha    ! Vencimiento"
    FIELDS CodMon AS CHARACTER COLUMN-LABEL "Moneda" FORMAT "x(3)"
    FIELDS ImpTot LIKE CcbDCaja.ImpTot COLUMN-LABEL "Importe Total"
    FIELDS ImpRet LIKE CcbDCaja.ImpTot COLUMN-LABEL "Importe!a Retener"
    FIELDS FchRet AS DATE
    FIELDS NroRet AS CHARACTER
    INDEX ind01 CodRef NroRef.

/* Se usa para las Notas de Crédito */
DEFINE SHARED TEMP-TABLE wrk_dcaja NO-UNDO LIKE ccbdcaja.

/* **************************************************************** */
/* RHC 14/04/2015 10% DESCUENTO POR ARTE SOLO POR LA PRIMERA COMPRA */
/* **************************************************************** */
FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.

/* RHC 13/04/2015 Antes de cancelar hay que ver si tiene consumos ARTE (Linea 014) */
DEF VAR pOk AS CHAR.
RUN vta2/d-registro-arte (ROWID(Faccpedi), OUTPUT pOk).
IF pOk = 'ADM-ERROR' THEN RETURN.
FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.
pDNIClie = Faccpedi.Atencion.        /* <<< OJO: ACTUALIZAMOS EL DNI <<< */
/* ******************************************************************************* */
DEF VAR pPrimeraCompra LIKE BaseArte.SwPrimeraCompra    INIT NO NO-UNDO.
DEF VAR pSaldoPuntos LIKE BaseArte.SaldoPuntos          INIT 0  NO-UNDO.
DEF VAR pImporteArte LIKE Facdpedi.ImpLin               INIT 0  NO-UNDO.

FOR EACH Facdpedi OF Faccpedi NO-LOCK, 
    FIRST Almmmatg OF Facdpedi NO-LOCK WHERE Almmmatg.CodFam = '014':
    /* Total Descontado */
    /*pImporteArte = pImporteArte + (Facdpedi.ImpLin - Facdpedi.ImpDto2).*/
    pImporteArte = pImporteArte + Facdpedi.ImpLin.
END.
/*MESSAGE s-coddiv pdniclie pimportearte. RETURN.*/
FIND BaseArte WHERE BaseArte.CodCia = s-codcia
    AND BaseArte.CodDiv = s-coddiv
    AND BaseArte.NroDocumento = pDNIClie
    NO-LOCK NO-ERROR.
IF AVAILABLE BaseArte AND BaseArte.SwPrimeraCompra = YES 
    THEN DO:
    /* Se va a aplicar un 10% de descuento ADICIONAL al final */
    Importe = Importe - ROUND(pImporteArte *  10.00 / 100, 2).
    pPrimeraCompra = YES. 
/*     FOR EACH Facdpedi OF Faccpedi NO-LOCK,                                */
/*         FIRST Almmmatg OF Facdpedi NO-LOCK WHERE Almmmatg.CodFam = '014': */
/*                                                                           */
/*         Importe = Importe  -                                              */
/*             ROUND(Facdpedi.CanPed * Facdpedi.PreUni * 10.00 / 100, 2).    */
/*         pPrimeraCompra = YES.                                             */
/*         /* Al final hay que recalcular el pedido y el comprobante */      */
/*     END.                                                                  */
END.
IF AVAILABLE BaseArte AND BaseArte.SwPrimeraCompra = NO
    THEN DO:
    /* Los PUNTOS se van a aplicar como un descuento ADICIONAL al final */
    pSaldoPuntos = TRUNCATE(MINIMUM(BaseArte.SaldoPuntos, pImporteArte), 0).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCCaja

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define QUERY-STRING-D-Dialog FOR EACH CcbCCaja SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH CcbCCaja SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog CcbCCaja
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog CcbCCaja


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-8 RECT-32 RECT-9 RECT-7 RECT-5 RECT-4 ~
RECT-10 RECT-6 FILL-IN_ImpNac1 FILL-IN_ImpUsa1 FILL-IN_ImpNac4 ~
FILL-IN_ImpUsa4 BUTTON-Tickets BUTTON-TpoCmb Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_NomCli FILL-IN_MonNac ~
FILL-IN_SaldoNac FILL-IN_MonUSA FILL-IN_SaldoUSA FILL-IN_EmiCheq ~
FILL-IN_ImpNac1 FILL-IN_ImpUsa1 FILL-IN_ImpNac2 FILL-IN_ImpUsa2 ~
FILL-IN_Voucher2 FILL-IN_CodBco2 FILL-IN-NroCta FILL-IN_FecPres ~
FILL-IN_ImpNac4 FILL-IN_ImpUsa4 FILL-IN_Voucher4a FILL-IN_Voucher4b ~
FILL-IN_Voucher4c FILL-IN_CodBco4 COMBO_TarjCred FILL-IN-4 FILL-IN_ImpNac5 ~
FILL-IN_ImpUsa5 FILL-IN_Voucher5 FILL-IN_CodBco5 FILL-IN-5 FILL-IN_SaldoBD ~
FILL-IN_ImpNac6 FILL-IN_ImpUsa6 FILL-IN_ImpNac7 FILL-IN_ImpUsa7 ~
FILL-IN_Voucher7 FILL-IN_SaldoAR FILL-IN_ImpNac8 FILL-IN_ImpUsa8 ~
FILL-IN_Voucher8 FILL-IN_CodBco8 FILL-IN-8 FILL-IN_ImpNac9 FILL-IN_ImpUsa9 ~
FILL-IN_Voucher4 FILL-IN_ImpNac10 FILL-IN_ImpUsa10 FILL-IN_PuntosNac ~
FILL-IN_PuntosUsa FILL-IN-SaldoPuntos RADIO-SET_Codmon FILL-IN_VueNac ~
FILL-IN_VueUsa FILL-IN_T_Venta FILL-IN-coddoc FILL-IN-nrodoc ~
FILL-IN_T_Compra 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv95 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_r-dcaja1-02 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-dcaja1-02 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_tab95 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-Tickets 
     LABEL "Tickets" 
     SIZE 15 BY .96.

DEFINE BUTTON BUTTON-TpoCmb 
     LABEL "Modificar Tipo Cambio" 
     SIZE 18 BY .96.

DEFINE VARIABLE COMBO_TarjCred AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 9 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17 BY .69
     BGCOLOR 8 FGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN-8 AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .69
     BGCOLOR 8 FGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN-coddoc AS CHARACTER FORMAT "XXX":U 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-NroCta AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 17 BY .69
     BGCOLOR 8 FGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN-nrodoc AS CHARACTER FORMAT "xxx-xxxxxx":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-SaldoPuntos AS DECIMAL FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Puntos Arte Acumulados" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodBco2 AS CHARACTER FORMAT "x(5)" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69
     BGCOLOR 8 FGCOLOR 8 .

DEFINE VARIABLE FILL-IN_CodBco4 AS CHARACTER FORMAT "x(5)" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69.

DEFINE VARIABLE FILL-IN_CodBco5 AS CHARACTER FORMAT "x(5)" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69
     BGCOLOR 8 FGCOLOR 8 .

DEFINE VARIABLE FILL-IN_CodBco8 AS CHARACTER FORMAT "x(5)" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69
     BGCOLOR 8 FGCOLOR 8 .

DEFINE VARIABLE FILL-IN_EmiCheq AS CHARACTER FORMAT "X(256)":U 
     LABEL "Emisor Cheque" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_FecPres AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .69
     BGCOLOR 8 FGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpNac1 AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     LABEL "Efectivo" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69.

DEFINE VARIABLE FILL-IN_ImpNac10 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     LABEL "Vales de Consumo" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpNac2 AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     LABEL "Cheque" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69
     BGCOLOR 8 FGCOLOR 8 .

DEFINE VARIABLE FILL-IN_ImpNac4 AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     LABEL "Tarjeta de Crédito" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69.

DEFINE VARIABLE FILL-IN_ImpNac5 AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     LABEL "Boleta de Depósito" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69
     BGCOLOR 8 FGCOLOR 8 .

DEFINE VARIABLE FILL-IN_ImpNac6 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     LABEL "Nota de Crédito" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpNac7 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     LABEL "Anticipos" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69
     BGCOLOR 8 FGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpNac8 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     LABEL "Comisiones" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69
     BGCOLOR 8 FGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpNac9 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Retenciones" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69
     BGCOLOR 8 FGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpUsa1 AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69.

DEFINE VARIABLE FILL-IN_ImpUsa10 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpUsa2 AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69
     BGCOLOR 8 FGCOLOR 8 .

DEFINE VARIABLE FILL-IN_ImpUsa4 AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69.

DEFINE VARIABLE FILL-IN_ImpUsa5 AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69
     BGCOLOR 8 FGCOLOR 8 .

DEFINE VARIABLE FILL-IN_ImpUsa6 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpUsa7 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69
     BGCOLOR 8 FGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpUsa8 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69
     BGCOLOR 8 FGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpUsa9 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69
     BGCOLOR 8 FGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN_MonNac AS CHARACTER FORMAT "x(3)":U INITIAL "S/." 
     LABEL "Saldo a pagar" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN_MonUSA AS CHARACTER FORMAT "x(3)":U INITIAL "US$" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 71 BY .81
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_PuntosNac AS DECIMAL FORMAT ">>>,>>9" INITIAL 0 
     LABEL "Puntos ARTE" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81.

DEFINE VARIABLE FILL-IN_PuntosUsa AS DECIMAL FORMAT ">>>,>>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81
     BGCOLOR 8 FGCOLOR 8 .

DEFINE VARIABLE FILL-IN_SaldoAR AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .69
     BGCOLOR 8 FGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN_SaldoBD AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .69
     BGCOLOR 8 FGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN_SaldoNac AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN_SaldoUSA AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN_T_Compra AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     LABEL "Tipo Cambio Compra" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 9 .

DEFINE VARIABLE FILL-IN_T_Venta AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     LABEL "Tipo Cambio Venta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 9 .

DEFINE VARIABLE FILL-IN_Voucher2 AS CHARACTER FORMAT "x(8)" 
     VIEW-AS FILL-IN 
     SIZE 15.72 BY .69
     BGCOLOR 8 FGCOLOR 8 .

DEFINE VARIABLE FILL-IN_Voucher4 AS CHARACTER FORMAT "x(16)" 
     LABEL "# de Tarjeta de Crédito" 
     VIEW-AS FILL-IN 
     SIZE 15.72 BY .69.

DEFINE VARIABLE FILL-IN_Voucher4a AS CHARACTER FORMAT "999999" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69.

DEFINE VARIABLE FILL-IN_Voucher4b AS CHARACTER FORMAT "x(6)" INITIAL "xxxxxx" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .69.

DEFINE VARIABLE FILL-IN_Voucher4c AS CHARACTER FORMAT "9999" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69.

DEFINE VARIABLE FILL-IN_Voucher5 AS CHARACTER FORMAT "XXX-XXXXXX" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .69
     BGCOLOR 8 FGCOLOR 8 .

DEFINE VARIABLE FILL-IN_Voucher7 AS CHARACTER FORMAT "xxx-xxxxxx":U 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .69
     BGCOLOR 8 FGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN_Voucher8 AS CHARACTER FORMAT "x(16)" 
     VIEW-AS FILL-IN 
     SIZE 15.72 BY .69
     BGCOLOR 8 FGCOLOR 8 .

DEFINE VARIABLE FILL-IN_VueNac AS DECIMAL FORMAT "->>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69.

DEFINE VARIABLE FILL-IN_VueUsa AS DECIMAL FORMAT "->>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69.

DEFINE VARIABLE RADIO-SET_Codmon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 6.14 BY .96 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18 BY 8.92.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90.57 BY 1.62.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90.57 BY 1.38.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90.57 BY 1.54.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90.57 BY .96.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26 BY 8.92.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 12 BY 8.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 6.29 BY 8.92.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      CcbCCaja SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN_NomCli AT ROW 1.38 COL 11 COLON-ALIGNED
     FILL-IN_MonNac AT ROW 3 COL 11 COLON-ALIGNED
     FILL-IN_SaldoNac AT ROW 3 COL 16 COLON-ALIGNED NO-LABEL
     FILL-IN_MonUSA AT ROW 3 COL 27 COLON-ALIGNED NO-LABEL
     FILL-IN_SaldoUSA AT ROW 3 COL 32 COLON-ALIGNED NO-LABEL
     FILL-IN_EmiCheq AT ROW 3 COL 76 COLON-ALIGNED
     FILL-IN_ImpNac1 AT ROW 5.35 COL 14 COLON-ALIGNED
     FILL-IN_ImpUsa1 AT ROW 5.35 COL 26 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac2 AT ROW 6.12 COL 14 COLON-ALIGNED
     FILL-IN_ImpUsa2 AT ROW 6.12 COL 28 NO-LABEL
     FILL-IN_Voucher2 AT ROW 6.12 COL 38 COLON-ALIGNED NO-LABEL
     FILL-IN_CodBco2 AT ROW 6.12 COL 55.29 COLON-ALIGNED NO-LABEL
     FILL-IN-NroCta AT ROW 6.12 COL 61.72 COLON-ALIGNED NO-LABEL
     FILL-IN_FecPres AT ROW 6.12 COL 78.29 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac4 AT ROW 6.88 COL 14 COLON-ALIGNED
     FILL-IN_ImpUsa4 AT ROW 6.88 COL 26 COLON-ALIGNED NO-LABEL
     FILL-IN_Voucher4a AT ROW 6.88 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     FILL-IN_Voucher4b AT ROW 6.88 COL 44 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     FILL-IN_Voucher4c AT ROW 6.88 COL 50 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     FILL-IN_CodBco4 AT ROW 6.88 COL 55.29 COLON-ALIGNED NO-LABEL
     COMBO_TarjCred AT ROW 6.88 COL 61.72 COLON-ALIGNED NO-LABEL
     FILL-IN-4 AT ROW 6.88 COL 79 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac5 AT ROW 7.65 COL 14 COLON-ALIGNED
     FILL-IN_ImpUsa5 AT ROW 7.65 COL 26 COLON-ALIGNED NO-LABEL
     FILL-IN_Voucher5 AT ROW 7.65 COL 38 COLON-ALIGNED NO-LABEL
     FILL-IN_CodBco5 AT ROW 7.65 COL 55.29 COLON-ALIGNED NO-LABEL
     FILL-IN-5 AT ROW 7.65 COL 61.72 COLON-ALIGNED NO-LABEL
     FILL-IN_SaldoBD AT ROW 7.65 COL 78.29 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac6 AT ROW 8.42 COL 14 COLON-ALIGNED
     FILL-IN_ImpUsa6 AT ROW 8.42 COL 26 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac7 AT ROW 9.19 COL 14 COLON-ALIGNED
     FILL-IN_ImpUsa7 AT ROW 9.19 COL 26 COLON-ALIGNED NO-LABEL
     FILL-IN_Voucher7 AT ROW 9.19 COL 38 COLON-ALIGNED NO-LABEL
     FILL-IN_SaldoAR AT ROW 9.19 COL 61.72 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac8 AT ROW 9.96 COL 14 COLON-ALIGNED
     FILL-IN_ImpUsa8 AT ROW 9.96 COL 26 COLON-ALIGNED NO-LABEL
     FILL-IN_Voucher8 AT ROW 9.96 COL 38 COLON-ALIGNED NO-LABEL
     FILL-IN_CodBco8 AT ROW 9.96 COL 55.29 COLON-ALIGNED NO-LABEL
     FILL-IN-8 AT ROW 9.96 COL 61.72 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac9 AT ROW 10.69 COL 14 COLON-ALIGNED
     FILL-IN_ImpUsa9 AT ROW 10.69 COL 26 COLON-ALIGNED NO-LABEL
     FILL-IN_Voucher4 AT ROW 10.81 COL 72 COLON-ALIGNED
     BUTTON-Tickets AT ROW 11.19 COL 40 WIDGET-ID 2
     FILL-IN_ImpNac10 AT ROW 11.42 COL 14 COLON-ALIGNED
     FILL-IN_ImpUsa10 AT ROW 11.42 COL 26 COLON-ALIGNED NO-LABEL
     FILL-IN_PuntosNac AT ROW 12.15 COL 14 COLON-ALIGNED WIDGET-ID 10
     FILL-IN_PuntosUsa AT ROW 12.15 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     FILL-IN-SaldoPuntos AT ROW 12.15 COL 72 COLON-ALIGNED WIDGET-ID 14
     BUTTON-TpoCmb AT ROW 13.5 COL 39
     RADIO-SET_Codmon AT ROW 13.54 COL 8.72 NO-LABEL
     FILL-IN_VueNac AT ROW 13.62 COL 14 COLON-ALIGNED NO-LABEL
     FILL-IN_VueUsa AT ROW 13.62 COL 26 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 14.85 COL 2
     Btn_Cancel AT ROW 14.85 COL 14
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME D-Dialog
     FILL-IN_T_Venta AT ROW 14.85 COL 46 COLON-ALIGNED PASSWORD-FIELD 
     FILL-IN-coddoc AT ROW 15.04 COL 67 COLON-ALIGNED
     FILL-IN-nrodoc AT ROW 15.04 COL 71.14 COLON-ALIGNED NO-LABEL
     FILL-IN_T_Compra AT ROW 15.62 COL 46 COLON-ALIGNED
     "En US$" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 4.5 COL 29
     "En S/." VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 4.5 COL 18
     "Banco" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 4.5 COL 57.43
     "Nro. Cta. Cte./Referencia" VIEW-AS TEXT
          SIZE 17.29 BY .5 AT ROW 4.5 COL 64
     "Numero Documento" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 4.5 COL 39.86
     "F.Presen" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 4.5 COL 81.86
     "Vuelto" VIEW-AS TEXT
          SIZE 5.14 BY .5 AT ROW 13.69 COL 3
     RECT-8 AT ROW 4.19 COL 27
     RECT-32 AT ROW 1 COL 1
     RECT-9 AT ROW 4.19 COL 57
     RECT-7 AT ROW 4.19 COL 1
     RECT-5 AT ROW 2.65 COL 1
     RECT-4 AT ROW 13.31 COL 1
     RECT-10 AT ROW 4.19 COL 39
     RECT-6 AT ROW 4.19 COL 1
     SPACE(4.99) SKIP(19.76)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Forma de Cancelación".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-VALES T "SHARED" NO-UNDO INTEGRAL VtaVales
      TABLE: T-VVALE T "SHARED" NO-UNDO INTEGRAL VtaVVale
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX COMBO_TarjCred IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-8 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-coddoc IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroCta IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-nrodoc IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-SaldoPuntos IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodBco2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodBco4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN_CodBco4:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_CodBco5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodBco8 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_EmiCheq IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_FecPres IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpNac10 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpNac2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpNac5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpNac6 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpNac7 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpNac8 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpNac9 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpUsa10 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpUsa2 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN_ImpUsa5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpUsa6 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpUsa7 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpUsa8 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpUsa9 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_MonNac IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_MonUSA IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_PuntosNac IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_PuntosUsa IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_SaldoAR IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_SaldoBD IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_SaldoNac IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_SaldoUSA IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_T_Compra IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_T_Venta IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Voucher2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Voucher4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Voucher4a IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Voucher4b IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Voucher4c IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN_Voucher4c:AUTO-RESIZE IN FRAME D-Dialog      = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_Voucher5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Voucher7 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Voucher8 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_VueNac IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_VueUsa IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET RADIO-SET_Codmon IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "integral.CcbCCaja"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Forma de Cancelación */
DO:  
    /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
    APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancelar */
DO:
    OK = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:

    DEFINE VAR T-Saldo AS DECI INIT 0 NO-UNDO.
    DEFINE VAR F-Tot AS DECI INIT 0 NO-UNDO.

    DEFINE VAR Ffchret AS DATE NO-UNDO.
    DEFINE VAR Cnroret AS CHAR NO-UNDO.

    ASSIGN
        FILL-IN_ImpNac1
        FILL-IN_ImpNac2
        FILL-IN_ImpNac4
        FILL-IN_ImpNac5
        FILL-IN_ImpNac6
        FILL-IN_ImpNac7
        FILL-IN_ImpNac8
        FILL-IN_ImpNac9
        FILL-IN_ImpNac10
        FILL-IN_ImpUsa1
        FILL-IN_ImpUsa2
        FILL-IN_ImpUsa4
        FILL-IN_ImpUsa5
        FILL-IN_ImpUsa6
        FILL-IN_ImpUsa7
        FILL-IN_ImpUsa8
        FILL-IN_ImpUsa9
        FILL-IN_ImpUsa10
        FILL-IN_Voucher2
        FILL-IN_Voucher4
        FILL-IN_Voucher5
        FILL-IN_Voucher7
        FILL-IN_Voucher8
        FILL-IN_CodBco2
        FILL-IN_CodBco4
        FILL-IN_CodBco5
        FILL-IN_CodBco8
        FILL-IN_VueNac
        FILL-IN_VueUsa
        FILL-IN_T_Venta
        FILL-IN_T_Compra
        FILL-IN_EmiCheq
        FILL-IN_FecPres
        RADIO-SET_CodMon
        COMBO_TarjCred
        FILL-IN_PuntosNac FILL-IN_PuntosUsa.

    /* Pago con Tarjeta de Credito */
    IF FILL-IN_ImpNac4 <> 0 OR FILL-IN_ImpUsa4 <> 0 THEN DO:
        IF FILL-IN_ImpNac4 <> 0 AND
            FILL-IN_ImpNac4 - 2.00 > FILL-IN_SaldoNac THEN DO:
            MESSAGE
                "El monto es mayor al saldo a pagar"
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO FILL-IN_ImpNac4.
            RETURN NO-APPLY.
        END.
        IF FILL-IN_ImpUsa4 <> 0 AND
            FILL-IN_ImpUsa4 - 2.00 > FILL-IN_SaldoUSA THEN DO:
            MESSAGE
                "El monto es mayor al saldo a pagar"
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO FILL-IN_ImpUsa4.
            RETURN NO-APPLY.
        END.
        IF FILL-IN_Voucher4:SCREEN-VALUE EQ "" THEN DO:
            MESSAGE
                "Ingrese el nro de la tarjeta de crédito"
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO FILL-IN_Voucher4.
            RETURN NO-APPLY.
        END.
        IF COMBO_TarjCred:SCREEN-VALUE EQ ? OR
            COMBO_TarjCred:SCREEN-VALUE EQ "" THEN DO:
            MESSAGE
                "Seleccione una tarjeta de crédito"
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO COMBO_TarjCred.
            RETURN NO-APPLY.
        END.
    END.

    IF FILL-IN_VueUsa < 0 OR FILL-IN_VueNac < 0 THEN DO:
        MESSAGE "El pago no cubre el monto adeudado" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    /* Verifica Vuelto */
    IF RADIO-SET_Codmon = 1 THEN DO:
        IF FILL-IN_VueNac + (FILL-IN_VueUSA * FILL-IN_T_Compra) >
            (FILL-IN_ImpNac1 + (FILL-IN_ImpUsa1 * FILL-IN_T_Compra) /* + 2 */ ) THEN DO:
            MESSAGE
                "Solo se permiten vueltos para cancelaciones en efectivo"
                VIEW-AS ALERT-BOX.
            RETURN NO-APPLY.
        END.
    END.
    ELSE DO:
        IF (FILL-IN_VueNac / FILL-IN_T_Venta) + FILL-IN_VueUSA >
            ((FILL-IN_ImpNac1 / FILL-IN_T_Venta) + FILL-IN_ImpUsa1 /* + 2 */ ) THEN DO:
            MESSAGE
                "Solo se permiten vueltos para cancelaciones en efectivo"
                VIEW-AS ALERT-BOX.
            RETURN NO-APPLY.
        END.
    END.

    /* CONSISTENCIAS ADICIONALES RHC 10.02.11 */
    DEF VAR x-Importe-Vales-1 AS DEC NO-UNDO.
    DEF VAR x-Importe-Vales-2 AS DEC NO-UNDO.
    CASE TRUE:
        WHEN pCodPro <> "" THEN DO:
            IF FILL-IN_ImpNac10 + FILL-IN_ImpUsa10 <= 0 THEN DO:
                MESSAGE 'NO se ha registrado pagos con vales de consumo'
                    VIEW-AS ALERT-BOX ERROR.
                RETURN NO-APPLY.
            END.
            IF pCodPro = '10003814' THEN DO:
                /* Tope el monto de los vales */
                /* Todo a soles */
                ASSIGN
                    x-Importe-Vales-1 = 0
                    x-Importe-Vales-2 = 0.
                x-Importe-Vales-1 = FILL-IN_ImpNac10 + FILL-IN_ImpUsa10 * FILL-IN_T_Compra.
                x-Importe-Vales-2 = FILL-IN_ImpNac1  + FILL-IN_ImpUsa1 * FILL-IN_T_Compra.
                IF x-Importe-Vales-2 > 0 THEN x-Importe-Vales-2 = x-Importe-Vales-2 - FILL-IN_VueNac.
                IF x-Importe-Vales-2 / (x-Importe-Vales-2 + x-Importe-Vales-1) * 100 > 50.00 THEN DO:
                    MESSAGE 'El importe en efectivo no puede superar el 50% de la compra total'
                        VIEW-AS ALERT-BOX ERROR.
                    APPLY 'ENTRY' TO FILL-IN_ImpNac1.
                    RETURN NO-APPLY.
                END.
            END.
        END.
    END CASE.
    
    OUTPUT TO COM1.
    PUT CONTROL CHR(7).
    OUTPUT CLOSE.
    
    EMPTY TEMP-TABLE T-CcbCCaja.

    CREATE T-CcbCCaja.
    ASSIGN
        T-CcbCCaja.CodBco[4] = FILL-IN_CodBco4
        T-CcbCCaja.CodBco[5] = FILL-IN_CodBco5
        T-CcbCCaja.CodBco[8] = FILL-IN_CodBco8
        T-CcbCCaja.ImpNac[1] = FILL-IN_ImpNac1 
        T-CcbCCaja.ImpNac[4] = FILL-IN_ImpNac4
        T-CcbCCaja.ImpNac[5] = FILL-IN_ImpNac5
        T-CcbCCaja.ImpNac[6] = FILL-IN_ImpNac6
        T-CcbCCaja.ImpNac[7] = FILL-IN_ImpNac7
        T-CcbCCaja.ImpNac[8] = FILL-IN_ImpNac8
        T-CcbCCaja.ImpNac[9] = FILL-IN_ImpNac9
        T-CcbCCaja.ImpNac[10] = FILL-IN_ImpNac10
        T-CcbCCaja.ImpUsa[1] = FILL-IN_ImpUsa1 
        T-CcbCCaja.ImpUsa[4] = FILL-IN_ImpUsa4
        T-CcbCCaja.ImpUsa[5] = FILL-IN_ImpUsa5
        T-CcbCCaja.ImpUsa[6] = FILL-IN_ImpUsa6
        T-CcbCCaja.ImpUsa[7] = FILL-IN_ImpUsa7
        T-CcbCCaja.ImpUsa[8] = FILL-IN_ImpUsa8
        T-CcbCCaja.ImpUsa[9] = FILL-IN_ImpUsa9
        T-CcbCCaja.ImpUsa[10] = FILL-IN_ImpUsa10
        T-CcbCCaja.Voucher[4]= FILL-IN_Voucher4 
        T-CcbCCaja.Voucher[5]= FILL-IN_Voucher5
        T-CcbCCaja.Voucher[7]= FILL-IN_Voucher7
        T-CcbCCaja.Voucher[8]= FILL-IN_Voucher8
        T-CcbCCaja.VueNac    = FILL-IN_VueNac
        T-CcbCCaja.VueUsa    = FILL-IN_VueUsa.
    /* RHC 14/04/2015 PUNTOS ARTE */
    ASSIGN
        T-CcbCCaja.PuntosNac = FILL-IN_PuntosNac
        T-CcbCCaja.PuntosUsa = FILL-IN_PuntosUsa.
    /* ************************** */
    /* Ic 20Nov2013 - Para vales de Utilex pedir DNI y frase*/
    ASSIGN  
        T-CcbCCaja.codbco[1]= lDnixVale 
        T-CcbCCaja.codbco[6]= lPassxVale.
    IF Moneda = 1 THEN T-CcbCCaja.TpoCmb = FILL-IN_T_Compra.
    IF Moneda = 2 THEN T-CcbCCaja.TpoCmb = FILL-IN_T_Venta.
    IF FILL-IN_FecPres <> ? THEN DO:
        IF FILL-IN_FecPres = TODAY THEN
            ASSIGN
                T-CcbCCaja.CodBco[2] = FILL-IN_CodBco2 
                T-CcbCCaja.ImpNac[2] = FILL-IN_ImpNac2
                T-CcbCCaja.ImpUsa[2] = FILL-IN_ImpUsa2
                T-CcbCCaja.Voucher[2]= FILL-IN_Voucher2
                T-CcbCCaja.FchVto[2] = FILL-IN_FecPres.
        ELSE
            ASSIGN
                T-CcbCCaja.CodBco[3] = FILL-IN_CodBco2 
                T-CcbCCaja.ImpNac[3] = FILL-IN_ImpNac2
                T-CcbCCaja.ImpUsa[3] = FILL-IN_ImpUsa2
                T-CcbCCaja.Voucher[3]= FILL-IN_Voucher2
                T-CcbCCaja.FchVto[3] = FILL-IN_FecPres.
        T-CcbCCaja.Voucher[10]= FILL-IN_EmiCheq.
    END.

    /* Guarda la tarjeta de credito */
    T-CcbCCaja.Voucher[9] = COMBO_TarjCred.

    IF CAN-FIND(FIRST wrk_ret) THEN DO:
        RUN proc_return_data IN h_r-dcaja1-02
            (OUTPUT Ffchret, OUTPUT Cnroret).
        FOR EACH wrk_ret:
            wrk_ret.FchRet = Ffchret.
            wrk_ret.NroRet = Cnroret.
        END.
    END.

    /* RHC 14/04/2015 REGENERAMOS EL PEDIDO DE ACUERDO A LOS PARAMETROS */
    RUN Recalcula-Pedido-Arte (FILL-IN_PuntosNac) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'ERROR al momento de actualizar los PUNTOS ARTE' SKIP
            'Grabación abortada' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    OK = YES.

    /*Imprime*/


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Tickets
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Tickets D-Dialog
ON CHOOSE OF BUTTON-Tickets IN FRAME D-Dialog /* Tickets */
DO:
    lDnixVale = "".
    lPassxVale = "" .

    RUN vtamin/d-tticketsv3 (INPUT pCodPro, 
                           INPUT FILL-IN_SaldoNac,
                           INPUT FILL-IN_SaldoUsa,
                           OUTPUT FILL-IN_ImpNac10, 
                           OUTPUT FILL-IN_ImpUSA10,
                           OUTPUT lDnixVale,
                           OUTPUT lPassxVale).
    DISPLAY FILL-IN_ImpNac10  FILL-IN_ImpUSA10 WITH FRAME {&FRAME-NAME}.
    RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-TpoCmb D-Dialog
ON CHOOSE OF BUTTON-TpoCmb IN FRAME D-Dialog /* Modificar Tipo Cambio */
DO:
    RUN proc_ModificaTpoCmb.
    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodBco2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco2 D-Dialog
ON LEAVE OF FILL-IN_CodBco2 IN FRAME D-Dialog
DO:
    IF FILL-IN_CodBco2 = SELF:SCREEN-VALUE THEN RETURN.
    ASSIGN {&SELF-NAME}.
    FIND cb-tabl WHERE
        cb-tabl.Tabla = "04" AND
        cb-tabl.codigo = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-tabl THEN DO:
        MESSAGE
            "Banco no registrado"
        VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco2 D-Dialog
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_CodBco2 IN FRAME D-Dialog
OR F8 OF FILL-IN_CodBco2 DO:
    ASSIGN
        input-var-1 = "04"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?.
    RUN lkup/c-tablas ("Bancos").
    IF output-var-1 <> ? THEN DO:
        FIND cb-tabl WHERE ROWID(cb-tabl) = output-var-1 NO-LOCK NO-ERROR.
        IF AVAILABLE cb-tabl THEN SELF:SCREEN-VALUE = cb-tabl.codigo.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodBco4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco4 D-Dialog
ON LEAVE OF FILL-IN_CodBco4 IN FRAME D-Dialog
DO:

    IF FILL-IN_CodBco4 = SELF:SCREEN-VALUE THEN RETURN.
    ASSIGN {&SELF-NAME}.
    FIND cb-tabl WHERE
        cb-tabl.Tabla = "04" AND
        cb-tabl.codigo = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE cb-tabl THEN
        FILL-IN-4:SCREEN-VALUE = cb-tabl.Nombre.
    ELSE FILL-IN-4:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco4 D-Dialog
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_CodBco4 IN FRAME D-Dialog
OR F8 OF FILL-IN_CodBco2 DO:
    ASSIGN
        input-var-1 = "04"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?.
    RUN lkup/c-tablas ("Bancos").
    IF output-var-1 <> ?THEN DO:
        FIND cb-tabl WHERE ROWID(cb-tabl) = output-var-1 NO-LOCK NO-ERROR.
        IF AVAILABLE cb-tabl THEN SELF:SCREEN-VALUE = cb-tabl.codigo.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodBco5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco5 D-Dialog
ON LEAVE OF FILL-IN_CodBco5 IN FRAME D-Dialog
DO:
    IF FILL-IN_CodBco5 = SELF:SCREEN-VALUE THEN RETURN.
    ASSIGN {&SELF-NAME}.
    FIND cb-tabl WHERE
        cb-tabl.Tabla = "04" AND
        cb-tabl.codigo = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE cb-tabl THEN
        FILL-IN-5:SCREEN-VALUE = cb-tabl.Nombre.
    ELSE FILL-IN-5:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco5 D-Dialog
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_CodBco5 IN FRAME D-Dialog
OR F8 OF FILL-IN_CodBco2 DO:
    ASSIGN
        input-var-1 = "04"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?.
    RUN lkup/c-tablas ("Bancos").
    IF output-var-1 <> ? THEN DO:
        FIND cb-tabl WHERE ROWID(cb-tabl) = output-var-1 NO-LOCK NO-ERROR.
        IF AVAILABLE cb-tabl THEN SELF:SCREEN-VALUE = cb-tabl.codigo.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodBco8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco8 D-Dialog
ON LEAVE OF FILL-IN_CodBco8 IN FRAME D-Dialog
DO:
    IF FILL-IN_CodBco8 = SELF:SCREEN-VALUE THEN RETURN.
    ASSIGN {&SELF-NAME}.
    FIND cb-tabl WHERE
        cb-tabl.Tabla = "04" AND
        cb-tabl.codigo = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE cb-tabl THEN
        FILL-IN-8:SCREEN-VALUE = cb-tabl.Nombre.
    ELSE FILL-IN-8:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco8 D-Dialog
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_CodBco8 IN FRAME D-Dialog
OR F8 OF FILL-IN_CodBco2 DO:
    ASSIGN
        input-var-1 = "04"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?.
    RUN lkup/c-tablas ("Bancos").
    IF output-var-1 <> ? THEN DO:
        FIND cb-tabl WHERE ROWID(cb-tabl) = output-var-1 NO-LOCK NO-ERROR.
        IF AVAILABLE cb-tabl THEN SELF:SCREEN-VALUE = cb-tabl.codigo.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpNac1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac1 D-Dialog
ON LEAVE OF FILL-IN_ImpNac1 IN FRAME D-Dialog /* Efectivo */
DO:
   RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpNac10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac10 D-Dialog
ON LEAVE OF FILL-IN_ImpNac10 IN FRAME D-Dialog /* Vales de Consumo */
DO:
    RUN Calculo.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpNac2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac2 D-Dialog
ON LEAVE OF FILL-IN_ImpNac2 IN FRAME D-Dialog /* Cheque */
DO:

    IF DECI(FILL-IN_ImpNac2:SCREEN-VALUE) = FILL-IN_ImpNac2 THEN RETURN.

    ASSIGN FILL-IN_ImpNac2. 

    IF FILL-IN_ImpNac2 > 0 THEN
        FILL-IN_ImpUsa2:SENSITIVE = FALSE.
    ELSE FILL-IN_ImpUsa2:SENSITIVE = TRUE.

    RUN _habilita.
    RUN Calculo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpNac4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac4 D-Dialog
ON LEAVE OF FILL-IN_ImpNac4 IN FRAME D-Dialog /* Tarjeta de Crédito */
DO:

    ASSIGN FILL-IN_ImpNac4. 

    IF FILL-IN_ImpNac4 > 0 THEN
        FILL-IN_ImpUsa4:SENSITIVE = FALSE.
    ELSE FILL-IN_ImpUsa4:SENSITIVE = TRUE.

    RUN _habilita.
    RUN Calculo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpNac5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac5 D-Dialog
ON LEAVE OF FILL-IN_ImpNac5 IN FRAME D-Dialog /* Boleta de Depósito */
DO:

    ASSIGN FILL-IN_ImpNac5.
    IF FILL-IN_ImpNac5 > FILL-IN_SaldoBD THEN DO:
        MESSAGE
            "Este monto es mayor al saldo" SKIP
            "de la boleta de deposito"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    RUN Calculo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpNac6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac6 D-Dialog
ON LEAVE OF FILL-IN_ImpNac6 IN FRAME D-Dialog /* Nota de Crédito */
DO:

    ASSIGN FILL-IN_ImpNac6.    

    IF FILL-IN_ImpNac6 > x-SaldoNC THEN DO:
        MESSAGE
            "El monto es mayor al saldo" SKIP
            "de la Nota de Credito"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    RUN Calculo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpNac7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac7 D-Dialog
ON LEAVE OF FILL-IN_ImpNac7 IN FRAME D-Dialog /* Anticipos */
DO:

    ASSIGN FILL-IN_ImpNac7.    

    IF FILL-IN_ImpNac7 > x-SaldoAR THEN DO:
        MESSAGE
            "El monto es mayor al saldo del Anticipo"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    RUN Calculo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpNac8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac8 D-Dialog
ON LEAVE OF FILL-IN_ImpNac8 IN FRAME D-Dialog /* Comisiones */
DO:

    ASSIGN FILL-IN_ImpNac8.    

    RUN Calculo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpUsa1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpUsa1 D-Dialog
ON LEAVE OF FILL-IN_ImpUsa1 IN FRAME D-Dialog
DO:
    RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpUsa2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpUsa2 D-Dialog
ON LEAVE OF FILL-IN_ImpUsa2 IN FRAME D-Dialog
DO:
  
    IF DECI(FILL-IN_ImpUsa2:SCREEN-VALUE) =  FILL-IN_ImpUsa2 THEN RETURN .
  
    ASSIGN FILL-IN_ImpUsa2.

    IF FILL-IN_ImpUsa2 > 0 THEN
        FILL-IN_ImpNac2:SENSITIVE = FALSE.
    ELSE FILL-IN_ImpNac2:SENSITIVE = TRUE.
  
    RUN _habilita.
    RUN Calculo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpUsa4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpUsa4 D-Dialog
ON LEAVE OF FILL-IN_ImpUsa4 IN FRAME D-Dialog
DO:

    ASSIGN FILL-IN_ImpUsa4.

    IF FILL-IN_ImpUsa4 > 0 THEN
        FILL-IN_ImpNac4 :SENSITIVE = FALSE.
    ELSE FILL-IN_ImpNac4 :SENSITIVE = TRUE.

    RUN _habilita.
    RUN Calculo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpUsa5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpUsa5 D-Dialog
ON LEAVE OF FILL-IN_ImpUsa5 IN FRAME D-Dialog
DO:

    ASSIGN FILL-IN_ImpUsa5.
    IF FILL-IN_ImpUsa5 > FILL-IN_SaldoBD THEN DO:
        MESSAGE
            "Este monto es mayor al saldo" SKIP
            "de la boleta de deposito"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    RUN Calculo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpUsa6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpUsa6 D-Dialog
ON LEAVE OF FILL-IN_ImpUsa6 IN FRAME D-Dialog
DO:
    ASSIGN FILL-IN_ImpUsa6.

    IF FILL-IN_ImpUsa6 > x-SaldoNC THEN DO:
        MESSAGE
            "El monto es mayor al saldo" SKIP
            "de la Nota de Credito"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    RUN Calculo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpUsa7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpUsa7 D-Dialog
ON LEAVE OF FILL-IN_ImpUsa7 IN FRAME D-Dialog
DO:
    ASSIGN FILL-IN_ImpUsa7.

    IF FILL-IN_ImpUsa7 > x-SaldoAR THEN DO:
        MESSAGE
            "El monto es mayor al saldo del Anticipo"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    RUN Calculo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpUsa8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpUsa8 D-Dialog
ON LEAVE OF FILL-IN_ImpUsa8 IN FRAME D-Dialog
DO:
    ASSIGN FILL-IN_ImpUsa8.

    RUN Calculo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_PuntosNac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_PuntosNac D-Dialog
ON LEAVE OF FILL-IN_PuntosNac IN FRAME D-Dialog /* Puntos ARTE */
DO:
  IF INPUT {&self-name} > pSaldoPuntos THEN DO:
      DISPLAY pSaldoPuntos @ {&self-name} WITH FRAME {&FRAME-NAME}.
      MESSAGE 'NO se puede aplicar mas de' pSaldoPuntos 'puntos'
          VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Voucher2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher2 D-Dialog
ON LEAVE OF FILL-IN_Voucher2 IN FRAME D-Dialog
DO:

    IF SELF:SCREEN-VALUE NE "" THEN DO:
        FIND FIRST CcbCdocu WHERE
            CcbCdocu.Codcia = S-CODCIA AND
            CcbCdocu.CodDoc = "CHC" AND
            CcbCdocu.Nrodoc = SELF:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF AVAILABLE CcbCDocu THEN DO:
            MESSAGE
                "Numero de Cheque Registrado" 
                VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Voucher4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher4 D-Dialog
ON LEAVE OF FILL-IN_Voucher4 IN FRAME D-Dialog /* # de Tarjeta de Crédito */
DO:

    IF FILL-IN_Voucher4:SCREEN-VALUE = FILL-IN_Voucher4 THEN RETURN.

    IF INPUT FILL-IN_Voucher4 = "" THEN DO:
        MESSAGE
            "Ingrese el numero de la Tarjeta de Crédito"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Voucher4a
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher4a D-Dialog
ON LEAVE OF FILL-IN_Voucher4a IN FRAME D-Dialog
DO:
    IF LENGTH(SELF:SCREEN-VALUE) <> 6 THEN DO:
        MESSAGE 'Debe ingresar los 6 primeros dígitos' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
        
    IF FILL-IN_Voucher4a:SCREEN-VALUE = FILL-IN_Voucher4a THEN RETURN.
    /* Armamos # de tarjeta */
    DEF VAR x-Ok AS LOG NO-UNDO.
    x-Ok = NO.

    FILL-IN_Voucher4:SCREEN-VALUE = FILL-IN_Voucher4a:SCREEN-VALUE + "xxxxxx" + FILL-IN_Voucher4c:SCREEN-VALUE.
    FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia
        AND FacTabla.tabla = "TC"
        AND LENGTH(FacTabla.codigo) <= 2
        BY FacTabla.Campo-C[1] DESC:
        IF SELF:SCREEN-VALUE BEGINS FacTabla.Campo-C[1] THEN DO:
            CASE TRUE:
                WHEN FacTabla.Valor[3] = 16 THEN FILL-IN_Voucher4c:FORMAT = "9999".
                WHEN FacTabla.Valor[3] = 14 THEN FILL-IN_Voucher4c:FORMAT = "99".
            END CASE.
            COMBO_TarjCred:SCREEN-VALUE = FacTabla.Codigo + " " + FacTabla.Nombre.
            x-Ok = YES.
            LEAVE.
        END.
    END.

    IF x-Ok = NO THEN DO:
        MESSAGE 'Debe ingresar número válidos' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    IF INPUT FILL-IN_Voucher4a = "" THEN DO:
        MESSAGE
            "Ingrese el numero de la Tarjeta de Crédito"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Voucher4b
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher4b D-Dialog
ON LEAVE OF FILL-IN_Voucher4b IN FRAME D-Dialog
DO:

    IF FILL-IN_Voucher4:SCREEN-VALUE = FILL-IN_Voucher4 THEN RETURN.

    IF INPUT FILL-IN_Voucher4 = "" THEN DO:
        MESSAGE
            "Ingrese el numero de la Tarjeta de Crédito"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Voucher4c
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher4c D-Dialog
ON LEAVE OF FILL-IN_Voucher4c IN FRAME D-Dialog
DO:
    IF FILL-IN_Voucher4c:SCREEN-VALUE = FILL-IN_Voucher4c THEN RETURN.
    IF FILL-IN_Voucher4c:FORMAT = "9999"
        AND LENGTH(SELF:SCREEN-VALUE) <> 4
        THEN DO:
        MESSAGE 'Debe ingresar los 4 últimos dígitos' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    IF FILL-IN_Voucher4c:FORMAT = "99"
        AND LENGTH(SELF:SCREEN-VALUE) <> 2
        THEN DO:
        MESSAGE 'Debe ingresar los 2 últimos dígitos' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    /* Armamos # de tarjeta */
    FILL-IN_Voucher4:SCREEN-VALUE = FILL-IN_Voucher4a:SCREEN-VALUE + "xxxxxx" + FILL-IN_Voucher4c:SCREEN-VALUE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Voucher5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher5 D-Dialog
ON LEAVE OF FILL-IN_Voucher5 IN FRAME D-Dialog
DO:

    IF INPUT FILL-IN_Voucher5 = FILL-IN_Voucher5 THEN RETURN.
    
    ASSIGN FILL-IN_Voucher5.

    IF FILL-IN_Voucher5 = "" THEN DO:
        ASSIGN
            FILL-IN_ImpNac5 = 0
            FILL-IN_ImpUsa5 = 0
            FILL-IN_SaldoBD = 0
            FILL-IN_CodBco5 = ""
            FILL-IN-5       = ""
            FILL-IN_ImpUsa5:SENSITIVE = FALSE
            FILL-IN_ImpNac5:SENSITIVE = FALSE
            FILL-IN-5:SENSITIVE = FALSE.
        DO WITH FRAME {&FRAME-NAME}:
            DISPLAY
                FILL-IN_CodBco5
                FILL-IN_SaldoBD
                FILL-IN_ImpNac5
                FILL-IN_ImpUsa5
                FILL-IN_Voucher5.
        END.
        RUN _habilita.
        RUN Calculo.
        RETURN.
    END.

    FIND CcbCDocu WHERE 
        CcbCDocu.CodCia = S-CodCia AND  
        CcbCDocu.CodDiv = s-CodDiv AND
        CcbCDocu.CodDoc = "BD" AND  
        CcbCDocu.CodCli = s-CodCli AND  
        CcbCDocu.nrodoc = FILL-IN_Voucher5
        NO-LOCK NO-ERROR.
    IF AVAILABLE CcbCDocu THEN DO:
        IF CcbCDocu.FlgEst = "C" THEN DO:
            MESSAGE
                "Boleta Deposito Nro." CcbCDocu.nrodoc SKIP
                "esta Cancelado  " VIEW-AS ALERT-BOX ERROR.
                RETURN NO-APPLY.
        END.
        IF CcbCDocu.FlgEst <> "P" THEN DO:
            MESSAGE
                "Boleta Deposito Nro." CcbCDocu.nrodoc SKIP
                "NO está aprobada" VIEW-AS ALERT-BOX ERROR.
                RETURN NO-APPLY.
        END.
        IF CcbCDocu.CodMon = 1 THEN DO:
            ASSIGN
                FILL-IN_ImpNac5 = CcbCDocu.SdoAct
                FILL-IN_ImpUsa5 = 0
                FILL-IN_ImpNac5:SENSITIVE = TRUE
                FILL-IN_ImpUsa5:SENSITIVE = FALSE.
        END.
        ELSE DO:
            ASSIGN
                FILL-IN_ImpUsa5 = CcbCDocu.SdoAct
                FILL-IN_ImpNac5 = 0
                FILL-IN_ImpNac5:SENSITIVE = FALSE
                FILL-IN_ImpUsa5:SENSITIVE = TRUE.
        END.
        ASSIGN FILL-IN_SaldoBD = CcbCDocu.SdoAct.
        FIND cb-tabl WHERE
            cb-tabl.Tabla = "04" AND
            cb-tabl.codigo = CcbCDocu.FlgAte
            NO-LOCK NO-ERROR.
        IF AVAILABLE cb-tabl THEN
            ASSIGN
                FILL-IN_CodBco5 = cb-tabl.codigo
                FILL-IN-5 = cb-tabl.Nombre.
        ELSE 
            ASSIGN
                FILL-IN_CodBco5 = ""
                FILL-IN-5 = "".
        DO WITH FRAME {&FRAME-NAME}:     
            DISPLAY
                FILL-IN_ImpNac5
                FILL-IN_ImpUsa5
                FILL-IN_CodBco5
                FILL-IN-5                
                FILL-IN_SaldoBD.
        END.
    END.
    ELSE DO:
        MESSAGE
            "Nro. de Documento no Registrado" SKIP
            "o no pertenece al Cliente Seleccionado"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    RUN _habilita.
    RUN Calculo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Voucher7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher7 D-Dialog
ON LEAVE OF FILL-IN_Voucher7 IN FRAME D-Dialog
DO:
    ASSIGN FILL-IN_Voucher7.
    IF FILL-IN_Voucher7 <> '' THEN DO:
        FIND FIRST CcbCDocu WHERE
            CcbCDocu.CodCia = s-codcia AND
            CcbCDocu.CodDoc = 'A/R' AND
            CcbCDocu.NroDoc = FILL-IN_Voucher7
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE CcbCDocu THEN DO:
            MESSAGE 'Anticipo no registrado' VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        IF CcbCDocu.Codcli <> s-CodCli THEN DO:
            MESSAGE
                'Anticipo no corresponde al cliente'
                VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        IF CcbCDocu.FlgEst = 'C' THEN DO:
            MESSAGE
                'Documento se encuentra asignado ' +
                CcbCDocu.CodRef + '-' + CcbCDocu.NroRef
                VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        x-SaldoAR = CcbCDocu.SdoAct.
        IF CcbCDocu.Codmon = 1 THEN DO WITH FRAME {&FRAME-NAME}:
            ASSIGN
                FILL-IN_ImpNac7:SENSITIVE = TRUE
                FILL-IN_ImpUsa7:SENSITIVE = FALSE
                FILL-IN_SaldoAR:SCREEN-VALUE =
                    'Saldo Ant S/.' + STRING(ccbcdocu.sdoact)
                FILL-IN_ImpNac7 = x-SaldoAR
                FILL-IN_ImpUsa7 = 0.
            DISPLAY FILL-IN_ImpNac7 FILL-IN_ImpUsa7.
        END.
        ELSE DO WITH FRAME {&FRAME-NAME}:
            ASSIGN
                FILL-IN_ImpNac7:SENSITIVE = FALSE
                FILL-IN_ImpUsa7:SENSITIVE = TRUE
                FILL-IN_SaldoAR:SCREEN-VALUE =
                    'Saldo Ant US$' + STRING(ccbcdocu.sdoact)
                FILL-IN_ImpNac7 = 0
                FILL-IN_ImpUsa7 = x-SaldoAR.
            DISPLAY FILL-IN_ImpNac7 FILL-IN_ImpUSA7.
        END.  
        FILL-IN_Voucher7:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        RUN _habilita.
        RUN Calculo.
    END.
    ELSE DO:
        ASSIGN
            FILL-IN_ImpNac7:SENSITIVE = FALSE
            FILL-IN_ImpUsa7:SENSITIVE = FALSE
            FILL-IN_SaldoAR:SCREEN-VALUE = ""
            x-SaldoAR = 0
            FILL-IN_ImpNac7 = 0
            FILL-IN_ImpUsa7 = 0.
        DO WITH FRAME {&FRAME-NAME}:            
            DISPLAY FILL-IN_ImpNac7 FILL-IN_ImpUsa7.
        END.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET_Codmon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET_Codmon D-Dialog
ON VALUE-CHANGED OF RADIO-SET_Codmon IN FRAME D-Dialog
DO:

    ASSIGN RADIO-SET_Codmon.

    FILL-IN_VueNac = 0.
    FILL-IN_VueUsa = 0.

    IF RADIO-SET_Codmon = 1 THEN DO:
        IF Moneda = 1 THEN FILL-IN_VueNac =
            fSumSol + (ROUND(fSumDol * FILL-IN_T_Compra,2) - FILL-IN_SaldoNac).
        IF Moneda = 2 THEN FILL-IN_VueNac =
            fSumSol + (ROUND(fSumDol * FILL-IN_T_Venta,2) - FILL-IN_SaldoNac).
    END.
    ELSE DO:
        IF Moneda = 1 THEN FILL-IN_VueUSA =
            fSumDol + (ROUND(fSumSol / FILL-IN_T_Compra,2) - FILL-IN_SaldoUSA).
        IF Moneda = 2 THEN FILL-IN_VueUSA =
            fSumDol + (ROUND(fSumSol / FILL-IN_T_Venta,2) - FILL-IN_SaldoUSA).
    END.
    DISPLAY FILL-IN_VueNac FILL-IN_VueUsa WITH FRAME D-Dialog.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-free/objects/tab95.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'LABEL-FONT = 4,
                     LABEL-FGCOLOR = 0,
                     FOLDER-BGCOLOR = 8,
                     FOLDER-PARENT-BGCOLOR = 8,
                     LABELS = Retenciones|Notas de Crédito':U ,
             OUTPUT h_tab95 ).
       RUN set-position IN h_tab95 ( 16.58 , 2.00 ) NO-ERROR.
       RUN set-size IN h_tab95 ( 7.88 , 89.00 ) NO-ERROR.

       /* Links to SmartTab95 h_tab95. */
       RUN add-link IN adm-broker-hdl ( h_tab95 , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_tab95 ,
             FILL-IN_T_Compra:HANDLE , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/r-dcaja1-02.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_r-dcaja1-02 ).
       RUN set-position IN h_r-dcaja1-02 ( 17.73 , 3.00 ) NO-ERROR.
       RUN set-size IN h_r-dcaja1-02 ( 6.50 , 87.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv95.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv95 ).
       RUN set-position IN h_p-updv95 ( 17.92 , 73.00 ) NO-ERROR.
       RUN set-size IN h_p-updv95 ( 3.65 , 14.00 ) NO-ERROR.

       /* Links to SmartBrowser h_r-dcaja1-02. */
       RUN add-link IN adm-broker-hdl ( h_p-updv95 , 'TableIO':U , h_r-dcaja1-02 ).

       /* Links to SmartPanel h_p-updv95. */
       RUN add-link IN adm-broker-hdl ( h_r-dcaja1-02 , 'State':U , h_p-updv95 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_r-dcaja1-02 ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv95 ,
             h_r-dcaja1-02 , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/t-dcaja1-02.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-dcaja1-02 ).
       RUN set-position IN h_t-dcaja1-02 ( 17.73 , 4.00 ) NO-ERROR.
       RUN set-size IN h_t-dcaja1-02 ( 6.50 , 64.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 19.00 , 72.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 4.23 , 16.00 ) NO-ERROR.

       /* Links to SmartBrowser h_t-dcaja1-02. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_t-dcaja1-02 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-dcaja1-02 ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             h_t-dcaja1-02 , 'AFTER':U ).
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculo D-Dialog 
PROCEDURE Calculo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME D-Dialog:

    ASSIGN
        FILL-IN_ImpNac1
        FILL-IN_ImpNac2
        FILL-IN_ImpNac4
        FILL-IN_ImpNac5
        FILL-IN_ImpNac6
        FILL-IN_ImpNac7
        FILL-IN_ImpNac8
        FILL-IN_ImpNac9
        FILL-IN_ImpNac10
        FILL-IN_ImpUsa1
        FILL-IN_ImpUsa2
        FILL-IN_ImpUsa4
        FILL-IN_ImpUsa5
        FILL-IN_ImpUsa6
        FILL-IN_ImpUsa7
        FILL-IN_ImpUsa8
        FILL-IN_ImpUsa9
        FILL-IN_ImpUsa10
        FILL-IN_PuntosNac
        FILL-IN_PuntosUsa.

    fSumSol =
        (FILL-IN_ImpNac1 + FILL-IN_ImpNac2 + FILL-IN_ImpNac4 +
        FILL-IN_ImpNac5 + FILL-IN_ImpNac6 + FILL-IN_ImpNac7 +
        FILL-IN_ImpNac8 + FILL-IN_ImpNac9 + FILL-IN_ImpNac10) +
        FILL-IN_PuntosNac.

    fSumDol =
        (FILL-IN_ImpUsa1 + FILL-IN_ImpUsa2 + FILL-IN_ImpUsa4 +
        FILL-IN_ImpUsa5 + FILL-IN_ImpUsa6 + FILL-IN_ImpUsa7 +
        FILL-IN_ImpUsa8 + FILL-IN_ImpUsa9 + FILL-IN_ImpUsa10) +
        FILL-IN_PuntosUsa.

    APPLY "VALUE-CHANGED" TO RADIO-SET_Codmon.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Clave-Comisiones D-Dialog 
PROCEDURE Clave-Comisiones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR s-coddoc AS CHAR INIT 'I/C' NO-UNDO.
  
  {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY FILL-IN_NomCli FILL-IN_MonNac FILL-IN_SaldoNac FILL-IN_MonUSA 
          FILL-IN_SaldoUSA FILL-IN_EmiCheq FILL-IN_ImpNac1 FILL-IN_ImpUsa1 
          FILL-IN_ImpNac2 FILL-IN_ImpUsa2 FILL-IN_Voucher2 FILL-IN_CodBco2 
          FILL-IN-NroCta FILL-IN_FecPres FILL-IN_ImpNac4 FILL-IN_ImpUsa4 
          FILL-IN_Voucher4a FILL-IN_Voucher4b FILL-IN_Voucher4c FILL-IN_CodBco4 
          COMBO_TarjCred FILL-IN-4 FILL-IN_ImpNac5 FILL-IN_ImpUsa5 
          FILL-IN_Voucher5 FILL-IN_CodBco5 FILL-IN-5 FILL-IN_SaldoBD 
          FILL-IN_ImpNac6 FILL-IN_ImpUsa6 FILL-IN_ImpNac7 FILL-IN_ImpUsa7 
          FILL-IN_Voucher7 FILL-IN_SaldoAR FILL-IN_ImpNac8 FILL-IN_ImpUsa8 
          FILL-IN_Voucher8 FILL-IN_CodBco8 FILL-IN-8 FILL-IN_ImpNac9 
          FILL-IN_ImpUsa9 FILL-IN_Voucher4 FILL-IN_ImpNac10 FILL-IN_ImpUsa10 
          FILL-IN_PuntosNac FILL-IN_PuntosUsa FILL-IN-SaldoPuntos 
          RADIO-SET_Codmon FILL-IN_VueNac FILL-IN_VueUsa FILL-IN_T_Venta 
          FILL-IN-coddoc FILL-IN-nrodoc FILL-IN_T_Compra 
      WITH FRAME D-Dialog.
  ENABLE RECT-8 RECT-32 RECT-9 RECT-7 RECT-5 RECT-4 RECT-10 RECT-6 
         FILL-IN_ImpNac1 FILL-IN_ImpUsa1 FILL-IN_ImpNac4 FILL-IN_ImpUsa4 
         BUTTON-Tickets BUTTON-TpoCmb Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  fathWH = THIS-PROCEDURE.
  DEFINE VARIABLE answer AS LOGICAL NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN FILL-IN_NomCli = wnomcli.
      /* Tipo de Cambio Caja */
      FIND LAST Gn-tccja WHERE Gn-tccja.Fecha <= TODAY NO-LOCK NO-ERROR.
      IF AVAILABLE Gn-TcCja THEN DO:
          FILL-IN_T_Compra = Gn-Tccja.Compra.
          FILL-IN_T_Venta = Gn-Tccja.Venta.
          IF Moneda = 1 THEN
              ASSIGN
              FILL-IN_SaldoNac = Importe
              FILL-IN_SaldoUSA = ROUND(Importe / ROUND(Gn-Tccja.Compra,3),2).
          ELSE
              ASSIGN
                  FILL-IN_SaldoNac = ROUND(Importe * ROUND(Gn-Tccja.Venta,3),2)
                  FILL-IN_SaldoUSA = Importe.
      END.
      ELSE DO:
          FILL-IN_T_Compra = 0.
          FILL-IN_T_Venta = 0.
          IF Moneda = 1 THEN
              ASSIGN
              FILL-IN_SaldoNac = Importe
              FILL-IN_SaldoUSA = 0.
          ELSE
              ASSIGN
                  FILL-IN_SaldoNac = 0
                  FILL-IN_SaldoUSA = Importe.
      END.
      /* Retenciones Siempre en Soles */
      FILL-IN_ImpNac9 = Retencion.

      IF Moneda = 1 THEN FILL-IN_ImpNac1 = Importe - Retencion.
      ELSE FILL-IN_ImpUsa1 = Importe - ROUND((Retencion / FILL-IN_T_Venta),2).
      DISPLAY
          FILL-IN_NomCli
          FILL-IN_SaldoNac
          FILL-IN_SaldoUSA
          FILL-IN_ImpNac1
          FILL-IN_ImpUSA1
          FILL-IN_T_Compra
          FILL-IN_T_Venta
          FILL-IN_ImpNac9
          FILL-IN_ImpUsa9
          RADIO-SET_Codmon.

      /* ******* PUNTOS ARTE ********** */
      FILL-IN_PuntosNac = pSaldoPuntos.
      IF AVAILABLE BaseArte THEN FILL-IN-SaldoPuntos = BaseArte.SaldoPuntos.
      IF Moneda = 1 THEN FILL-IN_ImpNac1 = Importe - FILL-IN_PuntosNac.
      IF FILL-IN_PuntosNac > 0 THEN FILL-IN_PuntosNac:SENSITIVE = YES.
      DISPLAY FILL-IN_ImpNac1 FILL-IN_PuntosNac FILL-IN-SaldoPuntos.
      /* ****************************** */

      RUN calculo.

      FIND faccorre WHERE faccorre.codcia = s-codcia AND
          faccorre.coddoc = s-Coddoc AND
          faccorre.NroSer = s-ptovta EXCLUSIVE-LOCK.
      DISPLAY
          STRING(faccorre.nroser, "999") +
          STRING(FacCorre.Correlativo, "999999") @ FILL-IN-nrodoc
          s-CodDoc @ FILL-IN-coddoc.

      FOR EACH FacTabla WHERE
          FacTabla.CodCia = s-CodCia AND
          FacTabla.Tabla = "TC" AND
          FacTabla.Codigo <> "00" AND
          LENGTH(FacTabla.Codigo) <= 2 NO-LOCK:
          answer = COMBO_TarjCred:ADD-LAST(FacTabla.Codigo +
              " " + FacTabla.Nombre).
      END.

      /* SI ES UN VALE DE CONSUMO TIENE PROVEEDOR */
      /*IF pCodPro <> "" THEN ASSIGN BUTTON-Tickets:VISIBLE = YES BUTTON-Tickets:SENSITIVE = YES.*/
  END.

  EMPTY TEMP-TABLE T-VVALE.
  EMPTY TEMP-TABLE T-VALES.

  APPLY "ENTRY" TO FILL-IN_ImpNac1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros D-Dialog 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_ModificaTpoCmb D-Dialog 
PROCEDURE proc_ModificaTpoCmb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {adm/i-DocPssw.i s-CodCia ""TCB"" ""UPD""}

    DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        UPDATE
            SKIP(.3)
            FILL-IN_T_Venta     COLON 13
            FILL-IN_T_Compra    COLON 13
            SPACE(2)
            SKIP(.2)
            WITH FRAME f-TpoCmb CENTERED VIEW-AS DIALOG-BOX THREE-D
                SIDE-LABEL TITLE "Tipo de Cambio".
        DISPLAY
            FILL-IN_T_Venta
            FILL-IN_T_Compra
            WITH FRAME {&FRAME-NAME}.
        /* Retenciones Siempre en Soles */
        IF Moneda = 2 THEN DO:
            FILL-IN_ImpUsa1 = Importe - ROUND((Retencion / FILL-IN_T_Venta),2).
            DISPLAY FILL-IN_ImpUsa1 WITH FRAME {&FRAME-NAME}.
        END.
    END.
    HIDE FRAME f-TpoCmb.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_total6 D-Dialog 
PROCEDURE proc_total6 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUFFER b_wrk FOR wrk_dcaja.

    FILL-IN_ImpNac6 = 0.
    FILL-IN_ImpUSA6 = 0.

    FOR EACH b_wrk NO-LOCK,
        FIRST CcbCDocu WHERE CcbCDocu.CodCia = b_wrk.CodCia
        AND CcbCDocu.CodCli = b_wrk.CodCli
        AND CcbCDocu.CodDoc = b_wrk.CodRef
        AND CcbCDocu.NroDoc = b_wrk.NroRef NO-LOCK:
        IF CcbCDocu.CodMon = 1 THEN FILL-IN_ImpNac6 = FILL-IN_ImpNac6 + b_wrk.ImpTot.
        ELSE FILL-IN_ImpUSA6 = FILL-IN_ImpUSA6 + b_wrk.ImpTot.
    END.

    DO WITH FRAME {&FRAME-NAME}:
        DISPLAY FILL-IN_ImpNac6 FILL-IN_ImpUSA6.
    END.

    RUN dispatch IN h_r-dcaja1-02 ('open-query':U).
    RUN dispatch IN h_r-dcaja1-02 ('row-available':U).

    RUN proc_total IN h_r-dcaja1-02.
    RUN proc_total9.
    RUN Calculo.
    /*RUN ccb/r-tick500 (ROWID(ccbcdocu)).*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_total9 D-Dialog 
PROCEDURE proc_total9 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUFFER b_wrk FOR wrk_ret.

    FILL-IN_ImpNac9 = 0.

    FOR EACH b_wrk NO-LOCK:
        FILL-IN_ImpNac9 = FILL-IN_ImpNac9 + b_wrk.ImpRet.
    END.

    DO WITH FRAME {&FRAME-NAME}:
        DISPLAY FILL-IN_ImpNac9.
    END.

    RUN Calculo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcula-Pedido-Arte D-Dialog 
PROCEDURE Recalcula-Pedido-Arte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER FILL-IN_PuntosNac AS DEC.

IF pPrimeraCompra = NO AND FILL-IN_PuntosNac <= 0 THEN RETURN.
FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid EXCLUSIVE-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    MESSAGE 'NO se pudo actualizar los descuentos por puntos en el pedido mostrador' SKIP
        'Grabación abortada' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
DEF VAR fSaldoPorRepartir AS DEC NO-UNDO.
DEF VAR fParaAplicar AS DEC NO-UNDO.
DEF VAR fFactor AS DEC DECIMALS 6 NO-UNDO.

IF pPrimeraCompra = YES THEN DO:
    ASSIGN
        Faccpedi.Libre_d01 = ROUND(pImporteArte *  10.00 / 100, 2)
        Faccpedi.ImpDto2   = Faccpedi.ImpDto2 + Faccpedi.Libre_d01
        fSaldoPorRepartir = Faccpedi.Libre_d01.
    /* Repartimos 10% de descuento por productos de Arte */
    FOR EACH Facdpedi OF Faccpedi, FIRST Almmmatg OF Facdpedi NO-LOCK WHERE Almmmatg.codfam = '014':
        fParaAplicar = MINIMUM(ROUND((Facdpedi.ImpLin - Facdpedi.ImpDto2) * 0.10, 2), fSaldoPorRepartir).
        Facdpedi.ImpDto2 = Facdpedi.ImpDto2 + fParaAplicar.
        fSaldoPorRepartir = fSaldoPorRepartir - fParaAplicar.
    END.
END.
IF pPrimeraCompra = NO THEN DO:
    ASSIGN
        Faccpedi.Libre_d01 = FILL-IN_PuntosNac
        Faccpedi.ImpDto2   = Faccpedi.ImpDto2 + Faccpedi.Libre_d01
        fSaldoPorRepartir = Faccpedi.Libre_d01.
    /* Repartimos 10% de descuento por productos de Arte */
    FOR EACH Facdpedi OF Faccpedi, FIRST Almmmatg OF Facdpedi NO-LOCK WHERE Almmmatg.codfam = '014':
        fFactor = (Facdpedi.ImpLin - Facdpedi.ImpDto2) / pImporteArte.
        fParaAplicar = MINIMUM(ROUND((Facdpedi.ImpLin - Facdpedi.ImpDto2) * fFactor, 2), fSaldoPorRepartir).
        Facdpedi.ImpDto2 = Facdpedi.ImpDto2 + fParaAplicar.
        fSaldoPorRepartir = fSaldoPorRepartir - fParaAplicar.
    END.
END.

{vta2/graba-totales-pedido-utilex.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CASE HANDLE-CAMPO:name:
        WHEN "FILL-IN_Voucher5" THEN 
            ASSIGN
                input-var-1 = s-CodCli
                input-var-2 = "P"
                input-var-3 = "Autorizada".
        WHEN "FILL-IN_Voucher6" THEN 
            ASSIGN
                input-var-1 = 'N/C'
                input-var-2 = s-CodCli
                input-var-3 = "P".            
        WHEN "FILL-IN_Voucher7" THEN 
            ASSIGN
                input-var-1 = 'A/R'
                input-var-2 = s-CodCli
                input-var-3 = 'P'.
        /*
            ASSIGN
                input-var-1 = ""
                input-var-2 = ""
                input-var-3 = "".
         */      
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "CcbCCaja"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _habilita D-Dialog 
PROCEDURE _habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:

    IF FILL-IN_ImpNac2 <> 0 OR FILL-IN_ImpUsa2 <> 0 THEN DO:
        ASSIGN
            FILL-IN_EmiCheq:SCREEN-VALUE = s-CodCli
            FILL-IN_Voucher2:SENSITIVE = TRUE 
            FILL-IN_CodBco2:SENSITIVE = TRUE
            FILL-IN-NroCta:SENSITIVE = s-coddiv = "00000"
            FILL-IN_FecPres:SENSITIVE = TRUE.
            FILL-IN_EmiCheq:SENSITIVE = TRUE.
    END.
    ELSE DO:
        ASSIGN
            FILL-IN_Voucher2:SCREEN-VALUE = "" 
            FILL-IN_CodBco2:SCREEN-VALUE = "" 
            FILL-IN_FecPres:SCREEN-VALUE = ""
            FILL-IN_EmiCheq:SCREEN-VALUE = ""
            FILL-IN_Voucher2:SENSITIVE = FALSE 
            FILL-IN_CodBco2:SENSITIVE = FALSE
            FILL-IN-NroCta:SENSITIVE = FALSE 
            FILL-IN_FecPres:SENSITIVE = FALSE
            FILL-IN_EmiCheq:SENSITIVE = FALSE.
    END.
    
    IF FILL-IN_ImpNac4 <> 0 OR FILL-IN_ImpUsa4 <> 0 THEN DO:
        /*RDP01 - Habilita campos para cupones*/
        ASSIGN
            FILL-IN_Voucher4a:SENSITIVE = TRUE 
            FILL-IN_Voucher4c:SENSITIVE = TRUE .
            /*FILL-IN_Voucher4:SENSITIVE = TRUE.*/
        IF PgoTarjCr <> 'T'  THEN
            ASSIGN 
                FILL-IN_CodBco4:SENSITIVE = TRUE.
                /*COMBO_TarjCred:SENSITIVE = TRUE.*/
    END.
    ELSE DO:
        ASSIGN
            FILL-IN_Voucher4:SCREEN-VALUE = "" 
            FILL-IN_CodBco4:SCREEN-VALUE = ""
            COMBO_TarjCred:SCREEN-VALUE = ""
            FILL-IN-4:SCREEN-VALUE = ""
            FILL-IN_Voucher4:SENSITIVE = FALSE 
            FILL-IN_CodBco4:SENSITIVE = FALSE
            COMBO_TarjCred:SENSITIVE = FALSE.
    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

