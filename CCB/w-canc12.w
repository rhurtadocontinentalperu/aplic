&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win

/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE T-VVALE LIKE integral.VtaVVale.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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
DEF INPUT  PARAMETER Moneda  AS INTEGER.
DEF INPUT  PARAMETER Importe AS DECIMAL.
DEF INPUT  PARAMETER wtipCom AS CHAR.
DEF INPUT  PARAMETER wcodcli AS CHAR.
DEF INPUT  PARAMETER wnomcli AS CHAR.
DEF OUTPUT PARAMETER OK      AS LOGICAL.

/* Local Variable Definitions ---                                       */
OK = NO.

DEF SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR S-CODDOC AS CHAR.
DEF SHARED VAR S-PTOVTA AS INT.
DEF SHARED VAR S-CODDIV AS CHAR.
DEF SHARED VAR S-CODTER AS CHAR.
DEF SHARED VAR S-USER-ID AS CHAR.


DEF VAR X-SdoNac AS DEC NO-UNDO.
DEF VAR X-SdoUsa AS DEC NO-UNDO.
DEF VAR X-SdoNc  AS DEC NO-UNDO.
DEF VAR X-Correc AS DEC NO-UNDO.

DEFINE VAR fSumSol AS DECIMAL NO-UNDO.
DEFINE VAR fSumDol AS DECIMAL NO-UNDO.

DEFINE VAR x-coddoc AS CHAR INIT "".
DEFINE VAR x-tipo   AS DECI INIT 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-9 RECT-8 RECT-7 RECT-6 RECT-4 RECT-34 ~
RECT-10 RECT-32 RECT-5 F-CLIECHE FILL-IN_ImpNac1 FILL-IN_ImpUsa1 ~
FILL-IN_ImpNac4 FILL-IN_ImpUsa4 FILL-IN_Voucher4 x-TarjetaCredito ~
FILL-IN_ImpNac5 FILL-IN_ImpUsa5 FILL-IN_Voucher5 FILL-IN_ImpNac6 ~
FILL-IN_ImpUsa6 FILL-IN_Voucher6 BUTTON-3 R-Codmon Btn_Done Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-cliente F-CLIECHE X-CodMon X-SdoAct ~
y-CodMon y-SdoAct F-NroRec FILL-IN_ImpNac1 FILL-IN_ImpUsa1 FILL-IN_ImpNac2 ~
FILL-IN_ImpUsa2 FILL-IN_Voucher2 FILL-IN_CodBco2 FILL-IN-3 F-Presen ~
FILL-IN_ImpNac4 FILL-IN_ImpUsa4 FILL-IN_Voucher4 FILL-IN_CodBco4 ~
x-TarjetaCredito FILL-IN-4 FILL-IN_ImpNac5 FILL-IN_ImpUsa5 FILL-IN_Voucher5 ~
FILL-IN_CodBco5 FILL-IN-5 FILL-IN_Saldo FILL-IN_ImpNac6 FILL-IN_ImpUsa6 ~
FILL-IN_Voucher6 FILL-IN_ImpNac7 FILL-IN_ImpUsa7 R-Codmon FILL-IN_VueNac ~
FILL-IN_VueUsa FILL-IN_T_Venta F-TipCom FILL-IN_T_Compra F-Numfac 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY DEFAULT 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancel" 
     SIZE 15 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Done" 
     SIZE 15 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-3 
     LABEL "Ingresar Vales de Compra" 
     SIZE 19 BY .96.

DEFINE VARIABLE x-TarjetaCredito AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Visa","Mastercard","American Express","Dinners" 
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE F-CLIECHE AS CHARACTER FORMAT "X(256)":U 
     LABEL "Emisor Cheque" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE F-cliente AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 52.86 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE F-NroRec AS CHARACTER FORMAT "X(256)":U 
     LABEL "RECIBO" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-Numfac AS CHARACTER FORMAT "X(256)":U 
     LABEL "Numero" 
     VIEW-AS FILL-IN 
     SIZE 13.14 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-Presen AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .69 NO-UNDO.

DEFINE VARIABLE F-TipCom AS CHARACTER FORMAT "X(256)":U 
     LABEL "Comprobante" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(10)":U 
     VIEW-AS FILL-IN 
     SIZE 17 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 9 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodBco2 AS CHARACTER FORMAT "x(5)" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69.

DEFINE VARIABLE FILL-IN_CodBco4 AS CHARACTER FORMAT "x(5)" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69.

DEFINE VARIABLE FILL-IN_CodBco5 AS CHARACTER FORMAT "x(5)" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69.

DEFINE VARIABLE FILL-IN_ImpNac1 AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69.

DEFINE VARIABLE FILL-IN_ImpNac2 AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69.

DEFINE VARIABLE FILL-IN_ImpNac4 AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69.

DEFINE VARIABLE FILL-IN_ImpNac5 AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69.

DEFINE VARIABLE FILL-IN_ImpNac6 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpNac7 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpUsa1 AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69.

DEFINE VARIABLE FILL-IN_ImpUsa2 AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69.

DEFINE VARIABLE FILL-IN_ImpUsa4 AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69.

DEFINE VARIABLE FILL-IN_ImpUsa5 AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69.

DEFINE VARIABLE FILL-IN_ImpUsa6 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpUsa7 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_Saldo AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .69
     BGCOLOR 7  NO-UNDO.

DEFINE VARIABLE FILL-IN_T_Compra AS DECIMAL FORMAT "->>,>>9.999" INITIAL 0 
     LABEL "T/C Compra" 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .69
     BGCOLOR 15 FGCOLOR 9 .

DEFINE VARIABLE FILL-IN_T_Venta AS DECIMAL FORMAT "->>,>>9.999" INITIAL 0 
     LABEL "T/C Venta" 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .69
     BGCOLOR 15 FGCOLOR 9 .

DEFINE VARIABLE FILL-IN_Voucher2 AS CHARACTER FORMAT "x(8)" 
     VIEW-AS FILL-IN 
     SIZE 15.72 BY .69.

DEFINE VARIABLE FILL-IN_Voucher4 AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 15.72 BY .69.

DEFINE VARIABLE FILL-IN_Voucher5 AS CHARACTER FORMAT "XXXXXXXXX" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69.

DEFINE VARIABLE FILL-IN_Voucher6 AS CHARACTER FORMAT "xxx-xxxxxx":U 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_VueNac AS DECIMAL FORMAT "->>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69.

DEFINE VARIABLE FILL-IN_VueUsa AS DECIMAL FORMAT "->>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69.

DEFINE VARIABLE X-CodMon AS CHARACTER FORMAT "x(3)":U 
     LABEL "Saldo a pagar" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE X-SdoAct AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE y-CodMon AS CHARACTER FORMAT "x(3)":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE y-SdoAct AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE R-Codmon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 6.14 BY .96 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 18.14 BY 7.96.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 92 BY 1.62.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 92 BY 1.35.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 92 BY 1.38.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 92 BY 1.54.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 92 BY .96.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 12 BY 7.96.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 12 BY 7.96.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 6.29 BY 7.96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-cliente AT ROW 1.38 COL 13 COLON-ALIGNED
     F-CLIECHE AT ROW 1.38 COL 78.14 COLON-ALIGNED
     X-CodMon AT ROW 3 COL 13 COLON-ALIGNED
     X-SdoAct AT ROW 3 COL 18 COLON-ALIGNED NO-LABEL
     y-CodMon AT ROW 3 COL 29 COLON-ALIGNED NO-LABEL
     y-SdoAct AT ROW 3 COL 34 COLON-ALIGNED NO-LABEL
     F-NroRec AT ROW 3 COL 76.86 COLON-ALIGNED
     FILL-IN_ImpNac1 AT ROW 5.35 COL 16 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpUsa1 AT ROW 5.35 COL 28 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac2 AT ROW 6.12 COL 16 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpUsa2 AT ROW 6.12 COL 30 NO-LABEL
     FILL-IN_Voucher2 AT ROW 6.12 COL 39.57 COLON-ALIGNED NO-LABEL
     FILL-IN_CodBco2 AT ROW 6.12 COL 57.29 COLON-ALIGNED NO-LABEL
     FILL-IN-3 AT ROW 6.12 COL 63.72 COLON-ALIGNED NO-LABEL
     F-Presen AT ROW 6.12 COL 80.29 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac4 AT ROW 6.88 COL 16 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpUsa4 AT ROW 6.88 COL 28 COLON-ALIGNED NO-LABEL
     FILL-IN_Voucher4 AT ROW 6.92 COL 39.72 COLON-ALIGNED NO-LABEL
     FILL-IN_CodBco4 AT ROW 6.92 COL 57.29 COLON-ALIGNED NO-LABEL
     x-TarjetaCredito AT ROW 6.92 COL 63.72 COLON-ALIGNED NO-LABEL
     FILL-IN-4 AT ROW 6.96 COL 81 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac5 AT ROW 7.73 COL 16 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpUsa5 AT ROW 7.73 COL 28 COLON-ALIGNED NO-LABEL
     FILL-IN_Voucher5 AT ROW 7.73 COL 39.57 COLON-ALIGNED NO-LABEL
     FILL-IN_CodBco5 AT ROW 7.73 COL 57.29 COLON-ALIGNED NO-LABEL
     FILL-IN-5 AT ROW 7.73 COL 63.72 COLON-ALIGNED NO-LABEL
     FILL-IN_Saldo AT ROW 7.73 COL 80.29 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac6 AT ROW 8.58 COL 16 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpUsa6 AT ROW 8.58 COL 28 COLON-ALIGNED NO-LABEL
     FILL-IN_Voucher6 AT ROW 8.58 COL 39.57 COLON-ALIGNED NO-LABEL
     BUTTON-3 AT ROW 9.65 COL 66
     FILL-IN_ImpNac7 AT ROW 9.85 COL 16 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpUsa7 AT ROW 9.85 COL 28 COLON-ALIGNED NO-LABEL
     R-Codmon AT ROW 11.04 COL 10.72 NO-LABEL
     FILL-IN_VueNac AT ROW 11.12 COL 16 COLON-ALIGNED NO-LABEL
     FILL-IN_VueUsa AT ROW 11.12 COL 28 COLON-ALIGNED NO-LABEL
     FILL-IN_T_Venta AT ROW 12.42 COL 53.43 COLON-ALIGNED
     F-TipCom AT ROW 12.42 COL 76.14 COLON-ALIGNED
     Btn_Done AT ROW 12.54 COL 2
     Btn_Cancel AT ROW 12.54 COL 19
     FILL-IN_T_Compra AT ROW 13.19 COL 53.29 COLON-ALIGNED
     F-Numfac AT ROW 13.19 COL 76.14 COLON-ALIGNED
     "Nota de Credito" VIEW-AS TEXT
          SIZE 11.86 BY .65 AT ROW 8.65 COL 4
     RECT-9 AT ROW 4.19 COL 59
     RECT-8 AT ROW 4.19 COL 29
     RECT-7 AT ROW 4.19 COL 17
     RECT-6 AT ROW 4.19 COL 1
     RECT-4 AT ROW 10.81 COL 1
     RECT-34 AT ROW 9.46 COL 1
     RECT-10 AT ROW 4.19 COL 41
     RECT-32 AT ROW 1 COL 1
     RECT-5 AT ROW 2.65 COL 1
     "Vuelto" VIEW-AS TEXT
          SIZE 6.14 BY .5 AT ROW 11.31 COL 3.86
     "Efectivo" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 5.54 COL 4
     "Numero Documento" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 4.5 COL 41.86
     "Cheque" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 6.31 COL 4
     "Banco" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 4.5 COL 59.43
     "En S/." VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 4.5 COL 20
     "Nro. Cta. Cte./Referencia" VIEW-AS TEXT
          SIZE 17.29 BY .5 AT ROW 4.5 COL 66
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Vales de Compra" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 9.85 COL 4
     "Tarjeta de Credito" VIEW-AS TEXT
          SIZE 12.72 BY .5 AT ROW 7.12 COL 3.72
     "En US$" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 4.5 COL 31
     "F.Presen" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 4.5 COL 83.86
     "Boleta Deposito" VIEW-AS TEXT
          SIZE 13 BY .65 AT ROW 7.81 COL 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 93.14 BY 17
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-VVALE T "SHARED" ? integral VtaVVale
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "FORMA DE CANCELACION"
         HEIGHT             = 13.42
         WIDTH              = 93.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 93.14
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 93.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   L-To-R                                                               */
/* SETTINGS FOR FILL-IN F-cliente IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NroRec IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Numfac IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Presen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TipCom IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-4:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodBco2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodBco4 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN_CodBco4:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_CodBco5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpNac2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpNac7 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpUsa2 IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN_ImpUsa7 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Saldo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_T_Compra IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_T_Venta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Voucher2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_VueNac IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_VueUsa IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN X-CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN X-SdoAct IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN y-CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN y-SdoAct IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* FORMA DE CANCELACION */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* FORMA DE CANCELACION */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancel */
DO:
  OK = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Done */
DO:
  IF FILL-IN_ImpNac1 <> DECI(FILL-IN_ImpNac1:SCREEN-VALUE) OR
     FILL-IN_ImpNac2 <> DECI(FILL-IN_ImpNac2:SCREEN-VALUE) OR
     FILL-IN_ImpNac4 <> DECI(FILL-IN_ImpNac4:SCREEN-VALUE) OR
     FILL-IN_ImpNac5 <> DECI(FILL-IN_ImpNac5:SCREEN-VALUE) OR
     FILL-IN_ImpNac6 <> DECI(FILL-IN_ImpNac6:SCREEN-VALUE) OR
     FILL-IN_ImpNac7 <> DECI(FILL-IN_ImpNac7:SCREEN-VALUE) OR
     FILL-IN_ImpUsa1 <> DECI(FILL-IN_ImpUsa1:SCREEN-VALUE) OR
     FILL-IN_ImpUsa2 <> DECI(FILL-IN_ImpUsa2:SCREEN-VALUE) OR
     FILL-IN_ImpUsa4 <> DECI(FILL-IN_ImpUsa4:SCREEN-VALUE) OR
     FILL-IN_ImpUsa5 <> DECI(FILL-IN_ImpUsa5:SCREEN-VALUE) OR
     FILL-IN_ImpUsa6 <> DECI(FILL-IN_ImpUsa6:SCREEN-VALUE) OR
     FILL-IN_ImpUsa7 <> DECI(FILL-IN_ImpUsa7:SCREEN-VALUE)  
  THEN DO:
    MESSAGE "Operacion Cancelada , Debe hacer Click sobre el Boton Aceptar" 
    VIEW-AS ALERT-BOX ERROR. 
    DO WITH FRAME {&FRAME-NAME}:
     DISPLAY FILL-IN_VueNac.  
     DISPLAY FILL-IN_VueUsa. 
    END.
    RETURN NO-APPLY.
  END.  
  IF FILL-IN_ImpNac2 <> 0 OR 
     FILL-IN_ImpUsa2 <> 0 THEN DO:
     IF F-ClieChe:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Emisor de Cheque No registrado " 
        VIEW-AS ALERT-BOX ERROR.  
        APPLY "ENTRY" TO F-ClieChe.
        RETURN NO-APPLY.
     END.
     IF FILL-IN_Voucher2:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Numero de Cheque No Registrado " 
        VIEW-AS ALERT-BOX ERROR.  
        APPLY "ENTRY" TO FILL-IN_Voucher2.
        RETURN NO-APPLY.
     END.
     IF LENGTH(TRIM(FILL-IN_Voucher2:SCREEN-VALUE)) <> 8 THEN DO:
        MESSAGE "Numero de Cheque debe tener 8 digitos " 
        VIEW-AS ALERT-BOX ERROR.  
        APPLY "ENTRY" TO FILL-IN_Voucher2.
        RETURN NO-APPLY.
     END.
     IF F-Presen = ? OR F-Presen < TODAY THEN DO:
        MESSAGE "Fecha de Presentacion No Valida " 
        VIEW-AS ALERT-BOX ERROR.  
        APPLY "ENTRY" TO F-Presen.
        RETURN NO-APPLY.
     END.
     IF F-Presen - TODAY > 30 THEN DO:
        MESSAGE "Fecha de Presentacion No Valida, Excede los 30 dias de Ley " 
        VIEW-AS ALERT-BOX ERROR.  
        APPLY "ENTRY" TO F-Presen.
        RETURN NO-APPLY.
     END.

  END.
  IF F-ClieChe:SCREEN-VALUE <> "" THEN DO:
     FIND gn-clie WHERE gn-clie.CodCia = 0 
                   AND  gn-clie.CodCli = F-ClieChe:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE "Emisor de Cheque No Existe" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO F-ClieChe.
        RETURN NO-APPLY.   
     END.
     DEFINE VAR T-Saldo AS DECI INIT 0.
     DEFINE VAR F-Tot AS DECI INIT 0.     
     IF gn-clie.MonLC = 2 THEN F-Tot = FILL-IN_ImpNac2 / FacCfgGn.TpoCmb[1] + FILL-IN_ImpUsa2.
     IF gn-clie.MonLC = 1 THEN F-Tot = FILL-IN_ImpUsa2 * FacCfgGn.TpoCmb[1] + FILL-IN_ImpNac2.     
     RUN vta\lincre.r(gn-clie.CodCli,F-Tot,OUTPUT T-SALDO).
     IF RETURN-VALUE <> "OK" THEN DO:
            MESSAGE "LINEA CREDITO  : " (IF gn-clie.MonLC = 1 THEN "S/. " ELSE "US$ " ) 
                                     STRING(gn-clie.ImpLC,"ZZ,ZZZ,ZZ9.99") SKIP
                 "USADO                 : " (IF gn-clie.MonLC = 1 THEN "S/. " ELSE "US$ " ) 
                                     STRING(T-SALDO,"ZZ,ZZZ,ZZ9.99") SKIP
                 "CREDITO DISPONIBLE    : " (IF gn-clie.MonLC = 1 THEN "S/. " ELSE "US$ " ) 
                                     STRING(gn-clie.ImpLC - T-SALDO,"-Z,ZZZ,ZZ9.99")
                 VIEW-AS ALERT-BOX ERROR. 
         APPLY "ENTRY" TO F-ClieChe.
         RETURN NO-APPLY.   
     END.          
  END.
  
  
  ASSIGN
    FILL-IN_CodBco2 FILL-IN_CodBco4 FILL-IN_ImpNac1 FILL-IN_ImpNac2 FILL-IN_ImpNac5
    FILL-IN_ImpNac5 FILL-IN_ImpUsa1 FILL-IN_ImpUsa2 FILL-IN_ImpUsa4 FILL-IN_ImpUsa5
    FILL-IN_T_Venta FILL-IN_T_Compra FILL-IN_Voucher2 FILL-IN_Voucher4 FILL-IN_VueNac FILL-IN_VueUsa
    FILL-IN_ImpNac6 FILL-IN_ImpUsa6 FILL-IN_Voucher6 F-Presen R-Codmon
    x-SdoAct
    x-TarjetaCredito.

    IF Moneda = 1 THEN x-tipo = FILL-IN_T_Compra.
    IF Moneda = 2 THEN x-tipo = FILL-IN_T_Venta.
     
  /**** Verifica si el documento esta registrado    ****/
   FIND CcbCDocu WHERE CcbCDocu.CodCia = S-CODCIA
                  AND  CcbCDocu.CodDoc = F-TipCom:SCREEN-VALUE  
                  AND  CcbCDocu.NroDoc = F-Numfac:SCREEN-VALUE  
                 NO-LOCK NO-ERROR.
    IF AVAILABLE CcbCDocu THEN DO:
       MESSAGE "Documento ya esta REGISTRADO" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO FILL-IN_ImpNac1 IN FRAME {&FRAME-NAME}.
       RETURN NO-APPLY.
    END.
  /*****************************************************/
  
  /*RUN Calculo.*/
  
  IF FILL-IN_VueUsa < 0 OR 
     FILL-IN_VueNac < 0 THEN DO:
    MESSAGE "El pago no cubre el monto adeudado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.


  /* CONSISTENCIA DE LOS VALES DE COMPRA */
  IF (FILL-IN_ImpNac7 + FILL-IN_ImpUsa7 <> 0)
    AND (FILL-IN_VueNac + FILL-IN_VueUsa) <> 0
    AND (FILL-IN_ImpNac1 + FILL-IN_ImpNac2 + FILL-IN_ImpNac4 + 
            FILL-IN_ImpNac5 + FILL-IN_ImpNac6 + FILL-IN_ImpUsa1 + 
            FILL-IN_ImpUsa2 + FILL-IN_ImpUsa4 + FILL-IN_ImpUsa5 + 
            FILL-IN_ImpUsa6) = 0
  THEN DO:
    MESSAGE 'NO se puede dar vuelto por vales de compra' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.    

  
  OUTPUT TO COM1.
  PUT CONTROL CHR(7).
  OUTPUT TO CLOSE.
  FOR EACH T-CcbCCaja:
    DELETE T-CcbCCaja.
  END.
  
  CREATE T-CcbCCaja.
  ASSIGN
    T-CcbCCaja.CodBco[4] = FILL-IN_CodBco4
    T-CcbCCaja.CodBco[5] = FILL-IN_CodBco5
    T-CcbCCaja.ImpNac[1] = FILL-IN_ImpNac1 
    T-CcbCCaja.ImpNac[4] = FILL-IN_ImpNac4
    T-CcbCCaja.ImpNac[5] = FILL-IN_ImpNac5
    T-CcbCCaja.ImpNac[6] = FILL-IN_ImpNac6
    T-CcbCCaja.ImpNac[7] = FILL-IN_ImpNac7
    T-CcbCCaja.ImpUsa[1] = FILL-IN_ImpUsa1 
    T-CcbCCaja.ImpUsa[4] = FILL-IN_ImpUsa4
    T-CcbCCaja.ImpUsa[5] = FILL-IN_ImpUsa5
    T-CcbCCaja.ImpUsa[6] = FILL-IN_ImpUsa6
    T-CcbCCaja.ImpUsa[7] = FILL-IN_ImpUsa7
    T-CcbCCaja.TpoCmb    = x-tipo 
    T-CcbCCaja.Voucher[4]= FILL-IN_Voucher4 
    T-CcbCCaja.Voucher[5]= FILL-IN_Voucher5
    T-CcbCCaja.Voucher[6]= FILL-IN_Voucher6
    T-CcbCCaja.VueNac    = FILL-IN_VueNac 
    T-CcbCCaja.VueUsa    = FILL-IN_VueUsa.

    IF F-Presen <> ? THEN DO:
        IF F-Presen = TODAY THEN ASSIGN
            T-CcbCCaja.CodBco[2] = FILL-IN_CodBco2 
            T-CcbCCaja.ImpNac[2] = FILL-IN_ImpNac2
            T-CcbCCaja.ImpUsa[2] = FILL-IN_ImpUsa2
            T-CcbCCaja.Voucher[2]= FILL-IN_Voucher2
            T-CcbCCaja.Voucher[10]= F-ClieChe:SCREEN-VALUE
            T-CcbCCaja.FchVto[2] = F-Presen.
        ELSE ASSIGN
            T-CcbCCaja.CodBco[3] = FILL-IN_CodBco2 
            T-CcbCCaja.ImpNac[3] = FILL-IN_ImpNac2
            T-CcbCCaja.ImpUsa[3] = FILL-IN_ImpUsa2
            T-CcbCCaja.Voucher[3]= FILL-IN_Voucher2
            T-CcbCCaja.Voucher[10]= F-ClieChe:SCREEN-VALUE            
            T-CcbCCaja.FchVto[3] = F-Presen.
    END.        
    /* Guardamos la tarjeta de credito */
    T-CcbCCaja.Voucher[8] = x-TarjetaCredito.
    
    IF FILL-IN_Voucher5 <> "" AND FILL-IN_Voucher5 <> "" AND
       (FILL-IN_ImpNac5 + FILL-IN_ImpUsa5) > 0 THEN DO:
        FIND ccbboldep WHERE ccbboldep.CodCia = S-CodCia 
                       AND  ccbboldep.CodDoc = "BD" 
                       AND  ccbboldep.CodCli = wcodcli
                       AND  ccbboldep.nrodoc = FILL-IN_Voucher5
                      EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL ccbboldep THEN DO:
          IF CcbBolDep.CodMon = 1 THEN
              ASSIGN 
              CcbBolDep.SdoAct = CcbBolDep.SdoAct - (FILL-IN_ImpNac5 + (FILL-IN_ImpUsa5 * x-tipo)).
          ELSE
              ASSIGN
              CcbBolDep.SdoAct = CcbBolDep.SdoAct - (FILL-IN_ImpUsa5 + (FILL-IN_ImpNac5 / x-tipo)).
          IF CcbBolDep.SdoAct <= 0 THEN CcbBolDep.FlgEst = "C".
        END.
        RELEASE ccbboldep.
    END.

  OK = YES.

  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Ingresar Vales de Compra */
DO:
  RUN ccb/d-tvvale (OUTPUT FILL-IN_ImpNac7, OUTPUT FILL-IN_ImpUsa7).
  DISPLAY FILL-IN_ImpNac7 FILL-IN_ImpUsa7 WITH FRAME {&FRAME-NAME}.
  RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Presen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Presen W-Win
ON LEAVE OF F-Presen IN FRAME F-Main
DO:
  ASSIGN F-Presen.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodBco2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco2 W-Win
ON LEAVE OF FILL-IN_CodBco2 IN FRAME F-Main
DO:
  ASSIGN {&SELF-NAME}.
  FIND cb-tabl WHERE cb-tabl.Tabla = "04" AND cb-tabl.codigo = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE cb-tabl
  THEN FILL-IN-3:SCREEN-VALUE = cb-tabl.Nombre.
  ELSE FILL-IN-3:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco2 W-Win
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_CodBco2 IN FRAME F-Main
OR F8 OF FILL-IN_CodBco2
DO:
  ASSIGN
    input-var-1 = "04"
    input-var-2 = ""
    input-var-3 = ""
    output-var-1 = ?.
  RUN lkup/c-tablas ("Bancos").
  IF output-var-1 <> ?
  THEN DO:
    FIND cb-tabl WHERE ROWID(cb-tabl) = output-var-1 NO-LOCK NO-ERROR.
    IF AVAILABLE cb-tabl
    THEN SELF:SCREEN-VALUE = cb-tabl.codigo.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodBco4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco4 W-Win
ON LEAVE OF FILL-IN_CodBco4 IN FRAME F-Main
DO:
  ASSIGN {&SELF-NAME}.
  FIND cb-tabl WHERE cb-tabl.Tabla = "04" AND cb-tabl.codigo = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE cb-tabl
  THEN FILL-IN-4:SCREEN-VALUE = cb-tabl.Nombre.
  ELSE FILL-IN-4:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco4 W-Win
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_CodBco4 IN FRAME F-Main
OR F8 OF FILL-IN_CodBco2
DO:
  ASSIGN
    input-var-1 = "04"
    input-var-2 = ""
    input-var-3 = ""
    output-var-1 = ?.
  RUN lkup/c-tablas ("Bancos").
  IF output-var-1 <> ?
  THEN DO:
    FIND cb-tabl WHERE ROWID(cb-tabl) = output-var-1 NO-LOCK NO-ERROR.
    IF AVAILABLE cb-tabl
    THEN SELF:SCREEN-VALUE = cb-tabl.codigo.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodBco5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco5 W-Win
ON LEAVE OF FILL-IN_CodBco5 IN FRAME F-Main
DO:
  ASSIGN {&SELF-NAME}.
  FIND cb-tabl WHERE cb-tabl.Tabla = "04" AND cb-tabl.codigo = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE cb-tabl
  THEN FILL-IN-5:SCREEN-VALUE = cb-tabl.Nombre.
  ELSE FILL-IN-5:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco5 W-Win
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_CodBco5 IN FRAME F-Main
OR F8 OF FILL-IN_CodBco2
DO:
  ASSIGN
    input-var-1 = "04"
    input-var-2 = ""
    input-var-3 = ""
    output-var-1 = ?.
  RUN lkup/c-tablas ("Bancos").
  IF output-var-1 <> ?
  THEN DO:
    FIND cb-tabl WHERE ROWID(cb-tabl) = output-var-1 NO-LOCK NO-ERROR.
    IF AVAILABLE cb-tabl
    THEN SELF:SCREEN-VALUE = cb-tabl.codigo.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpNac1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac1 W-Win
ON LEAVE OF FILL-IN_ImpNac1 IN FRAME F-Main
DO:
   RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpNac2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac2 W-Win
ON LEAVE OF FILL-IN_ImpNac2 IN FRAME F-Main
DO:
    IF DECI(FILL-IN_ImpNac2:SCREEN-VALUE) =  FILL-IN_ImpNac2 THEN RETURN .
  
    IF DECI(FILL-IN_ImpNac2:SCREEN-VALUE) <  0 THEN DO: /*RETURN.*/
         MESSAGE "Operacion Incorrecta, Vuelva a intentar " VIEW-AS ALERT-BOX ERROR.
         DO WITH FRAME {&FRAME-NAME}:
             DISPLAY FILL-IN_ImpNac2.  
         END.   
         RETURN NO-APPLY.
    END.
  
    ASSIGN FILL-IN_ImpNac2. 
    
    IF FILL-IN_ImpNac2 > 0 THEN DO:
        FILL-IN_ImpUsa1 = 0.
        FILL-IN_ImpUsa2 = 0.
        DO WITH FRAME {&FRAME-NAME}:
           DISPLAY FILL-IN_ImpUsa1 FILL-IN_ImpUsa2 FILL-IN_ImpNac2.
        END.  
        FILL-IN_ImpUsa1:SENSITIVE = FALSE.
        FILL-IN_ImpUsa2:SENSITIVE = FALSE.
    END.
    IF FILL-IN_ImpNac2 = 0 THEN DO:
        FILL-IN_ImpUsa1 = 0.
        FILL-IN_ImpUsa2 = 0.
        DO WITH FRAME {&FRAME-NAME}:
           DISPLAY FILL-IN_ImpUsa1 FILL-IN_ImpUsa2 FILL-IN_ImpNac2.
        END.  
        FILL-IN_ImpUsa1:SENSITIVE = YES.
        FILL-IN_ImpUsa2:SENSITIVE = YES.
    END.

    RUN _habilita.
   RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpNac4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac4 W-Win
ON LEAVE OF FILL-IN_ImpNac4 IN FRAME F-Main
DO:
    ASSIGN FILL-IN_ImpNac4.
    RUN _habilita.
  RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpNac5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac5 W-Win
ON LEAVE OF FILL-IN_ImpNac5 IN FRAME F-Main
DO:
    ASSIGN FILL-IN_ImpNac5.
    IF FILL-IN_ImpNac5 > FILL-IN_Saldo THEN DO:
       MESSAGE " Este monto es mayor al saldo " SKIP
               "   de la boleta de deposito   " VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.   
    RUN _habilita.
    RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpNac6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac6 W-Win
ON LEAVE OF FILL-IN_ImpNac6 IN FRAME F-Main
DO:
    ASSIGN FILL-IN_ImpNac6.
    IF FILL-IN_ImpNac6 > X-SdoNC THEN DO:
       MESSAGE " Este monto es mayor al saldo " SKIP
               "   de la Nota de Credito   " VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.   
    RUN _habilita.
    RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpNac7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac7 W-Win
ON LEAVE OF FILL-IN_ImpNac7 IN FRAME F-Main
DO:
    ASSIGN FILL-IN_ImpNac6.
    IF FILL-IN_ImpNac6 > X-SdoNC THEN DO:
       MESSAGE " Este monto es mayor al saldo " SKIP
               "   de la Nota de Credito   " VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.   
    RUN _habilita.
    RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpUsa1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpUsa1 W-Win
ON LEAVE OF FILL-IN_ImpUsa1 IN FRAME F-Main
DO:
  RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpUsa2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpUsa2 W-Win
ON LEAVE OF FILL-IN_ImpUsa2 IN FRAME F-Main
DO:
  
    IF DECI(FILL-IN_ImpUsa2:SCREEN-VALUE) =  FILL-IN_ImpUsa2 THEN RETURN .
  
    IF DECI(FILL-IN_ImpUsa2:SCREEN-VALUE) <  0 THEN DO: /*RETURN.*/
         MESSAGE "Operacion Incorrecta, Vuelva a intentar " VIEW-AS ALERT-BOX ERROR.
         DO WITH FRAME {&FRAME-NAME}:
             DISPLAY FILL-IN_ImpUsa2.  
         END.   
         RETURN NO-APPLY.
    END.

    ASSIGN FILL-IN_ImpUsa2.
  
    
    IF FILL-IN_ImpUsa2 > 0 THEN DO:
        FILL-IN_ImpUsa1 = 0.
        FILL-IN_ImpNac2 = 0.
        DO WITH FRAME {&FRAME-NAME}:
           DISPLAY FILL-IN_ImpUsa1 FILL-IN_ImpUsa2 FILL-IN_ImpNac2.
        END.  
        FILL-IN_ImpUsa1:SENSITIVE = FALSE.
        FILL-IN_ImpNac2:SENSITIVE = FALSE.
    END.
    IF FILL-IN_ImpUsa2 = 0 THEN DO:
        FILL-IN_ImpUsa1 = 0.
        FILL-IN_ImpNac2 = 0.
        DO WITH FRAME {&FRAME-NAME}:
           DISPLAY FILL-IN_ImpUsa1 FILL-IN_ImpUsa2 FILL-IN_ImpNac2.
        END.  
        FILL-IN_ImpUsa1:SENSITIVE = TRUE.
        FILL-IN_ImpNac2:SENSITIVE = TRUE.
    END.

  
  
    RUN _habilita.
  RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpUsa4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpUsa4 W-Win
ON LEAVE OF FILL-IN_ImpUsa4 IN FRAME F-Main
DO:
    ASSIGN FILL-IN_ImpUsa4.
    RUN _habilita.
  RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpUsa5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpUsa5 W-Win
ON LEAVE OF FILL-IN_ImpUsa5 IN FRAME F-Main
DO:
   ASSIGN FILL-IN_ImpUsa5.
   IF FILL-IN_ImpUsa5 > FILL-IN_Saldo THEN DO:
      MESSAGE " ESTE MONTO ES MAYOR AL SALDO " SKIP
              "   DE LA BOLETA DE DEPOSITO   " VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END. 
   RUN _habilita.
   RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpUsa6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpUsa6 W-Win
ON LEAVE OF FILL-IN_ImpUsa6 IN FRAME F-Main
DO:
   ASSIGN FILL-IN_ImpUsa6.
   IF FILL-IN_ImpUsa6 > X-SdoNC THEN DO:
      MESSAGE " ESTE MONTO ES MAYOR AL SALDO " SKIP
              "   DE LA NOTA DE CREDITO   " VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END. 
   RUN _habilita.
   RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpUsa7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpUsa7 W-Win
ON LEAVE OF FILL-IN_ImpUsa7 IN FRAME F-Main
DO:
   ASSIGN FILL-IN_ImpUsa6.
   IF FILL-IN_ImpUsa6 > X-SdoNC THEN DO:
      MESSAGE " ESTE MONTO ES MAYOR AL SALDO " SKIP
              "   DE LA NOTA DE CREDITO   " VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END. 
   RUN _habilita.
   RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Voucher2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher2 W-Win
ON LEAVE OF FILL-IN_Voucher2 IN FRAME F-Main
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN NO-APPLY.
  FIND CcbCdocu WHERE CcbCdocu.Codcia = S-CODCIA AND
                      CcbCdocu.CodDoc = "CHC" AND
                      CcbCdocu.Nrodoc = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE CcbCDocu THEN DO:
     MESSAGE "Numero de Cheque Registrado " 
     VIEW-AS ALERT-BOX ERROR.  
     RETURN NO-APPLY.    
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Voucher5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher5 W-Win
ON LEAVE OF FILL-IN_Voucher5 IN FRAME F-Main
DO:
   IF FILL-IN_Voucher5:SCREEN-VALUE =  FILL-IN_Voucher5 THEN RETURN .
 
   ASSIGN FILL-IN_Voucher5.

   IF FILL-IN_Voucher5 = "" THEN DO:
    ASSIGN FILL-IN_ImpNac5 = 0
           FILL-IN_ImpUsa5 = 0
           FILL-IN_Saldo   = 0
           FILL-IN_CodBco5 = ""
           FILL-IN-5       = ""
           FILL-IN_ImpUsa5:SENSITIVE = TRUE
           FILL-IN_ImpNac5:SENSITIVE = TRUE
           FILL-IN_CodBco5:SENSITIVE = FALSE
           FILL-IN-5:SENSITIVE = FALSE.
        
     DO WITH FRAME {&FRAME-NAME}:     
           DISPLAY FILL-IN_Saldo
                   FILL-IN_ImpNac5
                   FILL-IN_ImpUsa5
                   FILL-IN_Voucher5.
                   
     END.
     RUN _habilita.
     RUN Calculo.
     RETURN.
   END.
  
    
   FIND ccbboldep WHERE 
        ccbboldep.CodCia = S-CodCia AND  
        ccbboldep.CodDoc = "BD" AND  
        ccbboldep.CodCli = wcodcli AND  
        ccbboldep.nrodoc = FILL-IN_Voucher5 NO-LOCK NO-ERROR.
                  
   IF AVAILABLE ccbboldep THEN DO:
        IF CcbBolDep.FlgEst = "C" THEN DO:
            MESSAGE " Boleta Deposito Nro. " ccbboldep.nrodoc SKIP
                    "        esta Cancelado  " VIEW-AS ALERT-BOX ERROR.
                    RETURN NO-APPLY.
        END.
        IF CcbBolDep.CodMon = 1 THEN DO:
           ASSIGN FILL-IN_ImpNac5 = CcbBolDep.SdoAct
                  FILL-IN_ImpUsa5:SENSITIVE = FALSE
                  FILL-IN_ImpUsa1 = 0.
        END.
        ELSE DO:
           ASSIGN FILL-IN_ImpUsa5 = CcbBolDep.SdoAct
                  FILL-IN_ImpNac5:SENSITIVE = FALSE
                  FILL-IN_ImpUsa1 = 0. 
        END.          
        
        ASSIGN FILL-IN_Saldo = CcbBolDep.SdoAct.
               
        DO WITH FRAME {&FRAME-NAME}:     
           DISPLAY FILL-IN_Saldo
                   FILL-IN_ImpNac5
                   FILL-IN_ImpUsa5
                   FILL-IN_ImpUsa1.
        END.
        FIND cb-tabl WHERE cb-tabl.Tabla = "04" 
                      AND  cb-tabl.codigo = CcbBolDep.CodBco
                     NO-LOCK NO-ERROR.
        IF AVAILABLE cb-tabl THEN 
            ASSIGN 
                FILL-IN_CodBco5:SCREEN-VALUE = cb-tabl.codigo
                FILL-IN-5:SCREEN-VALUE = cb-tabl.Nombre.
        ELSE 
            ASSIGN
                FILL-IN_CodBco5:SCREEN-VALUE = ""
                FILL-IN-5:SCREEN-VALUE = "".  
   END.
   ELSE DO:
       MESSAGE "Nro. de Documento no Registrado" skip
               "o no pertenece al Cliente Seleccionado" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
   END.
   
   RUN _habilita.
   RUN Calculo.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Voucher6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher6 W-Win
ON LEAVE OF FILL-IN_Voucher6 IN FRAME F-Main
DO:
  ASSIGN
     FILL-IN_Voucher6.
  IF FILL-IN_Voucher6 <> ' ' THEN DO:
     FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
          CcbCDocu.CodDoc = 'N/C' AND CcbCDocu.NroDoc = FILL-IN_Voucher6 NO-LOCK NO-ERROR.
     IF NOT AVAILABLE CcbCDocu THEN DO:
        MESSAGE 'Nota de Credito no existe' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.
/*   IF CcbCDocu.Codcli <> wcodcli THEN DO:
        MESSAGE 'Nota de Credito no corresponde al cliente' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.*/
     IF CcbCDocu.FlgEst = 'C' THEN DO:
        MESSAGE 'Documento se encuentra asignado ' + CcbCDocu.CodRef + '-' + CcbCDocu.NroRef
                VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.
     IF CcbCDocu.Codmon = 1 THEN
        DO WITH FRAME {&FRAME-NAME}:
           DISPLAY CcbCDocu.SdoAct @ FILL-IN_ImpNac6.
           FILL-IN_ImpUsa6:SENSITIVE = FALSE.
        END.   
     ELSE
        DO WITH FRAME {&FRAME-NAME}:
           DISPLAY CcbCDocu.SdoAct @ FILL-IN_ImpUsa6.
           FILL-IN_ImpNac6:SENSITIVE = FALSE.
        END.  
     X-SdoNc  = CcbCDocu.SdoAct.      
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME X-SdoAct
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-SdoAct W-Win
ON LEAVE OF X-SdoAct IN FRAME F-Main
DO:
  ASSIGN X-SdoAct.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME y-SdoAct
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL y-SdoAct W-Win
ON LEAVE OF y-SdoAct IN FRAME F-Main
DO:
  ASSIGN X-SdoAct.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculo W-Win 
PROCEDURE Calculo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
   ASSIGN
        FILL-IN_ImpNac1 FILL-IN_ImpNac2 FILL-IN_ImpNac4 FILL-IN_ImpNac5 
        FILL-IN_ImpNac6 FILL-IN_ImpNac7
        FILL-IN_ImpUsa1 FILL-IN_ImpUsa2 FILL-IN_ImpUsa4 FILL-IN_ImpUsa5 
        FILL-IN_ImpUsa6 FILL-IN_ImpUsa7
        FILL-IN_CodBco2  FILL-IN_CodBco4
        FILL-IN_Voucher2 FILL-IN_Voucher4
        FILL-IN_T_Venta
        FILL-IN_T_Compra  .
        
   fSumSol = (FILL-IN_ImpNac1 + FILL-IN_ImpNac2 + 
              FILL-IN_ImpNac4 + FILL-IN_ImpNac5 + 
              FILL-IN_ImpNac6 + FILL-IN_ImpNac7). 
              
   fSumDol = (FILL-IN_ImpUsa1 + FILL-IN_ImpUsa2 + 
              FILL-IN_ImpUsa4 + FILL-IN_ImpUsa5 + 
              FILL-IN_ImpUsa6 + FILL-IN_ImpUsa7).
              
   FILL-IN_VueNac = 0.
   FILL-IN_VueUsa = 0.
   IF R-Codmon = 1 THEN
      IF Moneda = 1 THEN FILL-IN_VueNac = ROUND(fSumSol + ROUND( fSumDol * FILL-IN_T_Compra, 2 ) - X-SdoNac, 2).
      IF Moneda = 2 THEN FILL-IN_VueNac = ROUND(fSumSol + ROUND( fSumDol * FILL-IN_T_Venta, 2 ) - X-SdoNac, 2).
   DISPLAY FILL-IN_VueNac FILL-IN_VueUsa WITH FRAME {&FRAME-NAME}.
END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  DISPLAY F-cliente F-CLIECHE X-CodMon X-SdoAct y-CodMon y-SdoAct F-NroRec 
          FILL-IN_ImpNac1 FILL-IN_ImpUsa1 FILL-IN_ImpNac2 FILL-IN_ImpUsa2 
          FILL-IN_Voucher2 FILL-IN_CodBco2 FILL-IN-3 F-Presen FILL-IN_ImpNac4 
          FILL-IN_ImpUsa4 FILL-IN_Voucher4 FILL-IN_CodBco4 x-TarjetaCredito 
          FILL-IN-4 FILL-IN_ImpNac5 FILL-IN_ImpUsa5 FILL-IN_Voucher5 
          FILL-IN_CodBco5 FILL-IN-5 FILL-IN_Saldo FILL-IN_ImpNac6 
          FILL-IN_ImpUsa6 FILL-IN_Voucher6 FILL-IN_ImpNac7 FILL-IN_ImpUsa7 
          R-Codmon FILL-IN_VueNac FILL-IN_VueUsa FILL-IN_T_Venta F-TipCom 
          FILL-IN_T_Compra F-Numfac 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-9 RECT-8 RECT-7 RECT-6 RECT-4 RECT-34 RECT-10 RECT-32 RECT-5 
         F-CLIECHE FILL-IN_ImpNac1 FILL-IN_ImpUsa1 FILL-IN_ImpNac4 
         FILL-IN_ImpUsa4 FILL-IN_Voucher4 x-TarjetaCredito FILL-IN_ImpNac5 
         FILL-IN_ImpUsa5 FILL-IN_Voucher5 FILL-IN_ImpNac6 FILL-IN_ImpUsa6 
         FILL-IN_Voucher6 BUTTON-3 R-Codmon Btn_Done Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND FIRST ccbdterm WHERE CcbDTerm.CodCia = s-codcia 
                       AND  CcbDTerm.CodDiv = s-coddiv 
                       AND  CcbDTerm.CodDoc = wtipCom 
                       AND  CcbDTerm.CodTer = s-codter NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ccbdterm
  THEN DO:
      MESSAGE "Documento no esta configurada en este terminal " wtipcom
      VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.

  s-ptovta = ccbdterm.nroser.
  FIND faccorre WHERE faccorre.codcia = s-codcia AND faccorre.CodDiv = s-coddiv AND
       faccorre.coddoc = wtipCom AND faccorre.NroSer = s-ptovta NO-LOCK.


  DO WITH FRAME {&FRAME-NAME}:
     R-Codmon = 1.
     display STRING(faccorre.nroser, "999") + STRING(FacCorre.Correlativo, "999999") @ F-Numfac
             wtipCom @ F-TipCom R-Codmon.      
    ASSIGN
        X-CodMon:SCREEN-VALUE = (IF Moneda = 1 THEN "S/." ELSE "US$")
        y-CodMon:SCREEN-VALUE = (IF Moneda = 1 THEN "US$" ELSE "S/.")
        X-SdoAct:SCREEN-VALUE = STRING(Importe)
        F-cliente:SCREEN-VALUE = wnomcli.
    IF Moneda = 1
    THEN FILL-IN_ImpNac1:SCREEN-VALUE = STRING(Importe).
    ELSE FILL-IN_ImpUsa1:SCREEN-VALUE = STRING(Importe).
    /* Tipo de Cambio */
    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.

    FIND LAST Gn-tccja WHERE Gn-tccja.Fecha <= TODAY
                             NO-LOCK NO-ERROR.
    
    IF AVAILABLE Gn-TcCja THEN DO:    
        FILL-IN_T_Compra:SCREEN-VALUE = STRING(Gn-Tccja.Compra).
        FILL-IN_T_Venta:SCREEN-VALUE = STRING(Gn-Tccja.Venta).
        
        IF Moneda = 1
        THEN ASSIGN
                X-SdoNac = Importe
                X-SdoUsa = ROUND(Importe / ROUND(Gn-Tccja.Compra, 3), 2)
                Y-SdoAct:SCREEN-VALUE = STRING(ROUND(Importe / ROUND(Gn-Tccja.Compra, 3), 2)).

        ELSE ASSIGN
                X-SdoUsa = Importe
                X-SdoNac = ROUND(Importe * ROUND(Gn-Tccja.Venta, 3), 2)
                y-SdoAct:SCREEN-VALUE = STRING(ROUND(Importe * ROUND(Gn-Tccja.Venta, 3), 2)).

    END.
    ELSE DO:
        ASSIGN
            FILL-IN_T_Venta:SCREEN-VALUE = "".
            FILL-IN_T_Compra:SCREEN-VALUE = "".
        IF Moneda = 1
        THEN ASSIGN
                X-SdoNac = Importe
                X-SdoUsa = 0.
        ELSE ASSIGN
                X-SdoUsa = Importe
                X-SdoNac = 0.
    END.

        ASSIGN FILL-IN_Voucher2:SENSITIVE = FALSE 
               FILL-IN_CodBco2:SENSITIVE = FALSE 
               F-Presen:SENSITIVE = FALSE
              /*FILL-IN_Voucher4:SENSITIVE = FALSE */
               FILL-IN_CodBco4:SENSITIVE = FALSE.
            /* FILL-IN_Voucher5:SENSITIVE = FALSE 
               FILL-IN_CodBco5:SENSITIVE = FALSE. */
               R-CODMON:SENSITIVE = FALSE.
               F-CLIECHE:SENSITIVE = FALSE.
  END.
  /* LIMPIAMOS TEMPORAL VALES DE COMPRA */
  FOR EACH T-VVALE:
    DELETE T-VVALE.
  END.

  APPLY "ENTRY" TO FILL-IN_ImpNac1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _Habilita W-Win 
PROCEDURE _Habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    IF FILL-IN_ImpNac2 <> 0 OR FILL-IN_ImpUsa2 <> 0 THEN DO:
        ASSIGN FILL-IN_Voucher2:SENSITIVE = TRUE 
               FILL-IN_CodBco2:SENSITIVE = TRUE 
               F-Presen:SENSITIVE = TRUE.
               F-ClieChe:SENSITIVE = TRUE.
        APPLY "ENTRY" TO FILL-IN_Voucher2.
        RETURN NO-APPLY.
    END.
    ELSE DO:
        ASSIGN FILL-IN_Voucher2:SCREEN-VALUE = "" 
               FILL-IN_CodBco2:SCREEN-VALUE = "" 
               F-Presen:SCREEN-VALUE = ""
               FILL-IN-3:SCREEN-VALUE = ""
               F-ClieChe:SCREEN-VALUE = ""
               FILL-IN_Voucher2:SENSITIVE = FALSE 
               FILL-IN_CodBco2:SENSITIVE = FALSE 
               F-Presen:SENSITIVE = FALSE
               F-ClieChe:SENSITIVE = FALSE.
    END.
    /*
    IF FILL-IN_ImpNac4 <> 0 OR FILL-IN_ImpUsa4 <> 0 THEN DO:
        ASSIGN FILL-IN_Voucher4:SENSITIVE = TRUE 
               FILL-IN_CodBco4:SENSITIVE = TRUE.
        APPLY "ENTRY" TO FILL-IN_Voucher4.
        RETURN NO-APPLY.
    END.
    ELSE DO:
        ASSIGN FILL-IN_Voucher4:SCREEN-VALUE = "" 
               FILL-IN_CodBco4:SCREEN-VALUE = ""
               FILL-IN-4:SCREEN-VALUE = ""
               FILL-IN_Voucher4:SENSITIVE = FALSE 
               FILL-IN_CodBco4:SENSITIVE = FALSE.
    END.
    */
    
     IF  FILL-IN_ImpNac2 + FILL-IN_ImpUsa2 + FILL-IN_ImpNac4 + 
         FILL-IN_ImpUsa4 + FILL-IN_ImpNac5 + FILL-IN_ImpUsa5 > 0 THEN DO:
         FILL-IN_ImpUsa1 = 0.
         FILL-IN_ImpUsa1:SENSITIVE = FALSE .
         DISPLAY FILL-IN_ImpUsa1.
     END.
     ELSE DO:
       FILL-IN_ImpUsa1:SENSITIVE = TRUE .
                  DISPLAY FILL-IN_ImpUsa1.
     END. 

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


