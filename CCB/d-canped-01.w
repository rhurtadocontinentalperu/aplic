&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
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
DEF INPUT  PARAMETER wcodcli   AS CHAR.
DEF INPUT  PARAMETER wnomcli   AS CHAR.
DEF INPUT  PARAMETER Contado   AS LOGICAL.
DEF INPUT  PARAMETER PgoTarjCr AS CHARACTER.
DEF OUTPUT PARAMETER OK        AS LOGICAL.

/* Local Variable Definitions ---                                       */
OK = NO.

DEF SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.

DEF SHARED VAR s-CodCia AS INT.
DEF SHARED VAR s-CodDoc AS CHAR.
DEF SHARED VAR s-ptovta AS INT.
DEF SHARED VAR cl-codcia AS INT.

DEF VAR x-SaldoNC AS DEC NO-UNDO.
DEF VAR x-SaldoAR AS DEC NO-UNDO.

DEFINE VAR fSumSol AS DECIMAL NO-UNDO.
DEFINE VAR fSumDol AS DECIMAL NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-9 RECT-6 RECT-7 RECT-4 RECT-8 RECT-10 ~
RECT-5 RECT-32 FILL-IN_ImpNac1 FILL-IN_ImpUsa1 FILL-IN_ImpNac2 ~
FILL-IN_ImpUsa2 FILL-IN_ImpNac4 FILL-IN_ImpUsa4 FILL-IN_Voucher5 ~
FILL-IN_Voucher6 FILL-IN_Voucher7 FILL-IN_ImpNac8 FILL-IN_ImpUsa8 ~
FILL-IN_Voucher8 FILL-IN_CodBco8 BUTTON-Vales BUTTON-TpoCmb ~
RADIO-SET_Codmon Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_NomCli FILL-IN_MonNac ~
FILL-IN_SaldoNac FILL-IN_MonUSA FILL-IN_SaldoUSA FILL-IN_EmiCheq ~
FILL-IN_ImpNac1 FILL-IN_ImpUsa1 FILL-IN_ImpNac2 FILL-IN_ImpUsa2 ~
FILL-IN_Voucher2 FILL-IN_CodBco2 FILL-IN-3 FILL-IN_FecPres FILL-IN_ImpNac4 ~
FILL-IN_ImpUsa4 FILL-IN_Voucher4 FILL-IN_CodBco4 COMBO_TarjCred FILL-IN-4 ~
FILL-IN_ImpNac5 FILL-IN_ImpUsa5 FILL-IN_Voucher5 FILL-IN_CodBco5 FILL-IN-5 ~
FILL-IN_SaldoBD FILL-IN_ImpNac6 FILL-IN_ImpUsa6 FILL-IN_Voucher6 ~
FILL-IN_SaldoNC FILL-IN_ImpNac7 FILL-IN_ImpUsa7 FILL-IN_Voucher7 ~
FILL-IN_SaldoAR FILL-IN_ImpNac8 FILL-IN_ImpUsa8 FILL-IN_Voucher8 ~
FILL-IN_CodBco8 FILL-IN-8 FILL-IN_ImpNac9 FILL-IN_ImpUsa9 FILL-IN_ImpNac10 ~
FILL-IN_ImpUsa10 RADIO-SET_Codmon FILL-IN_VueNac FILL-IN_VueUsa ~
FILL-IN_T_Venta FILL-IN-coddoc FILL-IN-nrodoc FILL-IN_T_Compra 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

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

DEFINE BUTTON BUTTON-TpoCmb 
     LABEL "Modificar Tipo Cambio" 
     SIZE 18 BY .96.

DEFINE BUTTON BUTTON-Vales 
     LABEL "Vales de Consumo" 
     SIZE 16 BY .96.

DEFINE VARIABLE COMBO_TarjCred AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(10)":U 
     VIEW-AS FILL-IN 
     SIZE 17 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 9 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-8 AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-coddoc AS CHARACTER FORMAT "XXX":U 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-nrodoc AS CHARACTER FORMAT "xxx-xxxxxx":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN_CodBco2 AS CHARACTER FORMAT "x(5)" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69.

DEFINE VARIABLE FILL-IN_CodBco4 AS CHARACTER FORMAT "x(5)" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69.

DEFINE VARIABLE FILL-IN_CodBco5 AS CHARACTER FORMAT "x(5)" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69.

DEFINE VARIABLE FILL-IN_CodBco8 AS CHARACTER FORMAT "x(5)" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69.

DEFINE VARIABLE FILL-IN_EmiCheq AS CHARACTER FORMAT "X(256)":U 
     LABEL "Emisor Cheque" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_FecPres AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .69 NO-UNDO.

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
     SIZE 9.29 BY .69.

DEFINE VARIABLE FILL-IN_ImpNac4 AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     LABEL "Tarjeta de Crédito" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69.

DEFINE VARIABLE FILL-IN_ImpNac5 AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     LABEL "Boleta de Depósito" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69.

DEFINE VARIABLE FILL-IN_ImpNac6 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     LABEL "Nota de Crédito" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpNac7 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     LABEL "Anticipos" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpNac8 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     LABEL "Comisiones" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpNac9 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     LABEL "Retenciones" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpUsa1 AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69.

DEFINE VARIABLE FILL-IN_ImpUsa10 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69 NO-UNDO.

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

DEFINE VARIABLE FILL-IN_ImpUsa8 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpUsa9 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69 NO-UNDO.

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

DEFINE VARIABLE FILL-IN_SaldoAR AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .69
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN_SaldoBD AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_SaldoNac AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN_SaldoNC AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .69
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN_SaldoUSA AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

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

DEFINE VARIABLE FILL-IN_Voucher5 AS CHARACTER FORMAT "XXX-XXXXXX" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .69.

DEFINE VARIABLE FILL-IN_Voucher6 AS CHARACTER FORMAT "xxx-xxxxxx":U 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_Voucher7 AS CHARACTER FORMAT "xxx-xxxxxx":U 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_Voucher8 AS CHARACTER FORMAT "x(16)" 
     VIEW-AS FILL-IN 
     SIZE 15.72 BY .69.

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
     SIZE 18 BY 8.35.

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
     SIZE 26 BY 8.35.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 12 BY 8.35.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 6.29 BY 8.35.

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
     FILL-IN-3 AT ROW 6.12 COL 61.72 COLON-ALIGNED NO-LABEL
     FILL-IN_FecPres AT ROW 6.12 COL 78.29 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac4 AT ROW 6.88 COL 14 COLON-ALIGNED
     FILL-IN_ImpUsa4 AT ROW 6.88 COL 26 COLON-ALIGNED NO-LABEL
     FILL-IN_Voucher4 AT ROW 6.88 COL 38 COLON-ALIGNED NO-LABEL
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
     FILL-IN_Voucher6 AT ROW 8.42 COL 38 COLON-ALIGNED NO-LABEL
     FILL-IN_SaldoNC AT ROW 8.42 COL 61.72 COLON-ALIGNED NO-LABEL
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
     BUTTON-Vales AT ROW 11.19 COL 40
     FILL-IN_ImpNac10 AT ROW 11.42 COL 14 COLON-ALIGNED
     FILL-IN_ImpUsa10 AT ROW 11.42 COL 26 COLON-ALIGNED NO-LABEL
     BUTTON-TpoCmb AT ROW 12.73 COL 39
     RADIO-SET_Codmon AT ROW 12.77 COL 8.72 NO-LABEL
     FILL-IN_VueNac AT ROW 12.85 COL 14 COLON-ALIGNED NO-LABEL
     FILL-IN_VueUsa AT ROW 12.85 COL 26 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 14.08 COL 2
     Btn_Cancel AT ROW 14.08 COL 14.14
     FILL-IN_T_Venta AT ROW 14.08 COL 46 COLON-ALIGNED
     FILL-IN-coddoc AT ROW 14.27 COL 67 COLON-ALIGNED
     FILL-IN-nrodoc AT ROW 14.27 COL 71.14 COLON-ALIGNED NO-LABEL
     FILL-IN_T_Compra AT ROW 14.85 COL 46 COLON-ALIGNED
     "F.Presen" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 4.5 COL 81.86
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME D-Dialog
     "En S/." VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 4.5 COL 18
     "Nro. Cta. Cte./Referencia" VIEW-AS TEXT
          SIZE 17.29 BY .5 AT ROW 4.5 COL 64
     "En US$" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 4.5 COL 29
     "Banco" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 4.5 COL 57.43
     "Numero Documento" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 4.5 COL 39.86
     "Vuelto" VIEW-AS TEXT
          SIZE 5.14 BY .5 AT ROW 12.92 COL 3
     RECT-9 AT ROW 4.19 COL 57
     RECT-6 AT ROW 4.19 COL 1
     RECT-7 AT ROW 4.19 COL 1
     RECT-4 AT ROW 12.54 COL 1
     RECT-8 AT ROW 4.19 COL 27
     RECT-10 AT ROW 4.19 COL 39
     RECT-5 AT ROW 2.65 COL 1
     RECT-32 AT ROW 1 COL 1
     SPACE(0.00) SKIP(13.33)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Forma de Cancelación".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
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
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-8 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-coddoc IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-nrodoc IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodBco2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodBco4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN_CodBco4:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_CodBco5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_EmiCheq IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_FecPres IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpNac10 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpNac5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpNac6 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpNac7 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpNac9 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpUsa10 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpUsa2 IN FRAME D-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN_ImpUsa5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpUsa6 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpUsa7 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpUsa9 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_MonNac IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_MonUSA IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_SaldoAR IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_SaldoBD IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_SaldoNac IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_SaldoNC IN FRAME D-Dialog
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
/* SETTINGS FOR FILL-IN FILL-IN_VueNac IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_VueUsa IN FRAME D-Dialog
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
ON GO OF FRAME D-Dialog /* Forma de Cancelación */
DO:
    APPLY "CHOOSE" TO Btn_OK.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

    DEFINE VAR T-Saldo AS DECI INIT 0.
    DEFINE VAR F-Tot AS DECI INIT 0.

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
        FILL-IN_Voucher6
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
        COMBO_TarjCred.

    /* Cheque */
    IF FILL-IN_ImpNac2 <> 0 OR FILL-IN_ImpUsa2 <> 0 THEN DO:
        IF FILL-IN_EmiCheq:SCREEN-VALUE = "" THEN DO:
            MESSAGE
                "Ingrese el Emisor del Cheque"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FILL-IN_EmiCheq.
            RETURN NO-APPLY.
        END.
        ELSE DO:
            FIND gn-clie WHERE
                gn-clie.CodCia = cl-codcia AND
                gn-clie.CodCli = FILL-IN_EmiCheq:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-clie THEN DO:
                MESSAGE
                    "Emisor de Cheque No Existe"
                    VIEW-AS ALERT-BOX ERROR.
                APPLY "ENTRY" TO FILL-IN_EmiCheq.
                RETURN NO-APPLY.   
            END.
/*ML01* 04/OCT/2007 No consistencia Línea de Crédito ***
            /* Tipo de Cambio */
            FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
            IF AVAILABLE FacCfgGn THEN DO:
                IF gn-clie.MonLC = 2 THEN
                    F-Tot = FILL-IN_ImpNac2 / FacCfgGn.TpoCmb[1] + FILL-IN_ImpUsa2.
                IF gn-clie.MonLC = 1 THEN
                    F-Tot = FILL-IN_ImpUsa2 * FacCfgGn.TpoCmb[1] + FILL-IN_ImpNac2.
            END.
            RUN vta\lincre.r(gn-clie.CodCli,F-Tot,OUTPUT T-SALDO).
            IF RETURN-VALUE <> "OK" THEN DO:
                MESSAGE
                    "LINEA CREDITO       : "
                        (IF gn-clie.MonLC = 1 THEN "S/. " ELSE "US$ ") 
                        STRING(gn-clie.ImpLC,"ZZ,ZZZ,ZZ9.99") SKIP
                    "USADO              : "
                        (IF gn-clie.MonLC = 1 THEN "S/. " ELSE "US$ ") 
                        STRING(T-SALDO,"ZZ,ZZZ,ZZ9.99") SKIP
                    "CREDITO DISPONIBLE : "
                        (IF gn-clie.MonLC = 1 THEN "S/. " ELSE "US$ ") 
                        STRING(gn-clie.ImpLC - T-SALDO,"-Z,ZZZ,ZZ9.99")
                    VIEW-AS ALERT-BOX ERROR.
                APPLY "ENTRY" TO FILL-IN_EmiCheq.
                RETURN NO-APPLY.
            END.
*** *ML01*/
        END.
        IF FILL-IN_Voucher2:SCREEN-VALUE = "" THEN DO:
            MESSAGE
                "Ingrese el Número del Cheque"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FILL-IN_Voucher2.
            RETURN NO-APPLY.
        END.
        IF LENGTH(TRIM(FILL-IN_Voucher2:SCREEN-VALUE)) <> 8 THEN DO:
            MESSAGE
                "Número de Cheque debe tener 8 dígitos"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FILL-IN_Voucher2.
            RETURN NO-APPLY.
        END.
        IF INPUT FILL-IN_FecPres = ? OR INPUT FILL-IN_FecPres < TODAY THEN DO:
            MESSAGE
                "Fecha de Presentación No Válida"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FILL-IN_FecPres.
            RETURN NO-APPLY.
        END.
        IF INPUT FILL-IN_FecPres - TODAY > 30 THEN DO:
            MESSAGE
                "Fecha de Presentación No Válida, Excede los 30 días de Ley"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO FILL-IN_FecPres.
            RETURN NO-APPLY.
        END.
    END.

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

    /* Pago con Boletas de Depósito */
    IF FILL-IN_ImpNac5 <> 0 OR FILL-IN_ImpUsa5 <> 0 THEN DO:
        IF FILL-IN_ImpNac5 > FILL-IN_SaldoBD THEN DO:
            MESSAGE
                "El monto es mayor al saldo" SKIP
                "de la Boleta de Depósito"
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO FILL-IN_ImpNac5.
            RETURN NO-APPLY.
        END.
        IF FILL-IN_ImpUsa5 > FILL-IN_SaldoBD THEN DO:
            MESSAGE
                "El monto es mayor al saldo" SKIP
                "de la Boleta de Depósito"
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO FILL-IN_ImpUsa5.
            RETURN NO-APPLY.
        END.
    END.

    /* Monto para NC */
    IF FILL-IN_ImpNac6 <> 0 OR FILL-IN_ImpUsa6 <> 0 THEN DO:
        IF FILL-IN_ImpNac6 > x-SaldoNC THEN DO:
            MESSAGE
                "El monto es mayor al saldo" SKIP
                "de la Nota de Crédito"
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO FILL-IN_ImpNac6.
            RETURN NO-APPLY.
        END.
        IF FILL-IN_ImpUsa6 > x-SaldoNC THEN DO:
            MESSAGE
                "El monto es mayor al saldo" SKIP
                "de la Nota de Crédito"
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO FILL-IN_ImpUsa6.
            RETURN NO-APPLY.
        END.
    END.

    /* Monto para Anticipos */
    IF FILL-IN_ImpNac7 <> 0 OR FILL-IN_ImpUsa7 <> 0 THEN DO:
        IF FILL-IN_ImpNac7 > x-SaldoAR THEN DO:
            MESSAGE
                "El monto es mayor al saldo del Anticipo"
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO FILL-IN_ImpNac7.
            RETURN NO-APPLY.
        END.
        IF FILL-IN_ImpUsa7 > x-SaldoAR THEN DO:
            MESSAGE
                "El monto es mayor al saldo del Anticipo"
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO FILL-IN_ImpUsa7.
            RETURN NO-APPLY.
        END.
    END.

    IF FILL-IN_VueUsa < 0 OR FILL-IN_VueNac < 0 THEN DO:
        MESSAGE "El pago no cubre el monto adeudado" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    /* Verifica Vuelto */
    IF (FILL-IN_ImpNac2 + FILL-IN_ImpNac4 + FILL-IN_ImpNac5 +
        FILL-IN_ImpNac6 + FILL-IN_ImpNac7 + FILL-IN_ImpNac8 >
        FILL-IN_SaldoNac AND FILL-IN_VueNac > 2.00) OR
        (FILL-IN_ImpUsa2 + FILL-IN_ImpUsa4 + FILL-IN_ImpUsa5 +
        FILL-IN_ImpUsa6 + FILL-IN_ImpUsa7 + FILL-IN_ImpUsa8 >
        FILL-IN_SaldoUSA AND FILL-IN_VueUSA > 2.00) THEN DO:
        MESSAGE
            "Solo se permiten vueltos para cancelaciones en efectivo"
            VIEW-AS ALERT-BOX.
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
        T-CcbCCaja.Voucher[6]= FILL-IN_Voucher6
        T-CcbCCaja.Voucher[7]= FILL-IN_Voucher7
        T-CcbCCaja.Voucher[8]= FILL-IN_Voucher8
        T-CcbCCaja.VueNac    = FILL-IN_VueNac
        T-CcbCCaja.VueUsa    = FILL-IN_VueUsa.

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

    OK = YES.

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


&Scoped-define SELF-NAME BUTTON-Vales
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Vales D-Dialog
ON CHOOSE OF BUTTON-Vales IN FRAME D-Dialog /* Vales de Consumo */
DO:
    RUN CCB\D-TVVALE(OUTPUT FILL-IN_ImpNac10, OUTPUT FILL-IN_ImpUSA10).
    DISPLAY FILL-IN_ImpNac10  FILL-IN_ImpUSA10 WITH FRAME {&FRAME-NAME}.
    RUN Calculo.
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
    IF AVAILABLE cb-tabl THEN
        FILL-IN-3:SCREEN-VALUE = cb-tabl.Nombre.
    ELSE FILL-IN-3:SCREEN-VALUE = "".
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
ON LEAVE OF FILL-IN_Voucher4 IN FRAME D-Dialog
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


&Scoped-define SELF-NAME FILL-IN_Voucher5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher5 D-Dialog
ON LEAVE OF FILL-IN_Voucher5 IN FRAME D-Dialog
DO:

    IF FILL-IN_Voucher5:SCREEN-VALUE = FILL-IN_Voucher5 THEN RETURN.
 
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

    FIND ccbboldep WHERE 
        ccbboldep.CodCia = S-CodCia AND  
        ccbboldep.CodDoc = "BD" AND  
        ccbboldep.CodCli = wcodcli AND  
        ccbboldep.nrodoc = FILL-IN_Voucher5
        NO-LOCK NO-ERROR.
    IF AVAILABLE ccbboldep THEN DO:
        IF CcbBolDep.FlgEst = "C" THEN DO:
            MESSAGE
                "Boleta Deposito Nro." ccbboldep.nrodoc SKIP
                "esta Cancelado  " VIEW-AS ALERT-BOX ERROR.
                RETURN NO-APPLY.
        END.
        IF CcbBolDep.FlgEst <> "P" THEN DO:
            MESSAGE
                "Boleta Deposito Nro." ccbboldep.nrodoc SKIP
                "NO está aprobada" VIEW-AS ALERT-BOX ERROR.
                RETURN NO-APPLY.
        END.
        IF CcbBolDep.CodMon = 1 THEN DO:
            ASSIGN
                FILL-IN_ImpNac5 = CcbBolDep.SdoAct
                FILL-IN_ImpUsa5 = 0
                FILL-IN_ImpNac5:SENSITIVE = TRUE
                FILL-IN_ImpUsa5:SENSITIVE = FALSE.
        END.
        ELSE DO:
            ASSIGN
                FILL-IN_ImpUsa5 = CcbBolDep.SdoAct
                FILL-IN_ImpNac5 = 0
                FILL-IN_ImpNac5:SENSITIVE = FALSE
                FILL-IN_ImpUsa5:SENSITIVE = TRUE.
        END.
        ASSIGN FILL-IN_SaldoBD = CcbBolDep.SdoAct.
        FIND cb-tabl WHERE
            cb-tabl.Tabla = "04" AND
            cb-tabl.codigo = CcbBolDep.CodBco
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


&Scoped-define SELF-NAME FILL-IN_Voucher6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher6 D-Dialog
ON LEAVE OF FILL-IN_Voucher6 IN FRAME D-Dialog
DO:
    ASSIGN FILL-IN_Voucher6.
    IF FILL-IN_Voucher6 <> '' THEN DO:
        FIND FIRST CcbCDocu WHERE
            CcbCDocu.CodCia = s-codcia AND
            CcbCDocu.CodDoc = 'N/C' AND
            CcbCDocu.NroDoc = FILL-IN_Voucher6
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE CcbCDocu THEN DO:
            MESSAGE 'Nota de Credito no existe' VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        IF CcbCDocu.Codcli <> wcodcli THEN DO:
            MESSAGE
                'Nota de Credito no corresponde al cliente'
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
        x-SaldoNC = CcbCDocu.SdoAct.
        IF CcbCDocu.Codmon = 1 THEN DO WITH FRAME {&FRAME-NAME}:
            ASSIGN
                FILL-IN_ImpNac6:SENSITIVE = TRUE
                FILL-IN_ImpUsa6:SENSITIVE = FALSE
                FILL-IN_SaldoNC:SCREEN-VALUE =
                    'Saldo N/C S/.' + STRING(ccbcdocu.sdoact)
                FILL-IN_ImpNac6 = x-SaldoNC
                FILL-IN_ImpUsa6 = 0.
            DISPLAY FILL-IN_ImpNac6 FILL-IN_ImpUsa6.
        END.
        ELSE DO WITH FRAME {&FRAME-NAME}:
            ASSIGN
                FILL-IN_ImpNac6:SENSITIVE = FALSE
                FILL-IN_ImpUsa6:SENSITIVE = TRUE
                FILL-IN_SaldoNC:SCREEN-VALUE =
                    'Saldo N/C US$' + STRING(ccbcdocu.sdoact)
                FILL-IN_ImpNac6 = 0
                FILL-IN_ImpUsa6 = x-SaldoNC.
            DISPLAY FILL-IN_ImpNac6 FILL-IN_ImpUSA6.
        END.  
        RUN _habilita.
        RUN Calculo.
    END.
    ELSE DO:
        ASSIGN
            FILL-IN_ImpNac6:SENSITIVE = FALSE
            FILL-IN_ImpUsa6:SENSITIVE = FALSE
            FILL-IN_SaldoNC:SCREEN-VALUE = ""
            x-SaldoNC = 0
            FILL-IN_ImpNac6 = 0
            FILL-IN_ImpUsa6 = 0.
        DO WITH FRAME {&FRAME-NAME}:            
            DISPLAY FILL-IN_ImpNac6 FILL-IN_ImpUsa6.
        END.
    END.

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
        IF CcbCDocu.Codcli <> wcodcli THEN DO:
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
        FILL-IN_ImpUsa10.

    fSumSol =
        (FILL-IN_ImpNac1 + FILL-IN_ImpNac2 + FILL-IN_ImpNac4 +
        FILL-IN_ImpNac5 + FILL-IN_ImpNac6 + FILL-IN_ImpNac7 +
        FILL-IN_ImpNac8 + FILL-IN_ImpNac9 + FILL-IN_ImpNac10).

    fSumDol =
        (FILL-IN_ImpUsa1 + FILL-IN_ImpUsa2 + FILL-IN_ImpUsa4 +
        FILL-IN_ImpUsa5 + FILL-IN_ImpUsa6 + FILL-IN_ImpUsa7 +
        FILL-IN_ImpUsa8 + FILL-IN_ImpUsa9 + FILL-IN_ImpUsa10).

    APPLY "VALUE-CHANGED" TO RADIO-SET_Codmon.

END.

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
          FILL-IN-3 FILL-IN_FecPres FILL-IN_ImpNac4 FILL-IN_ImpUsa4 
          FILL-IN_Voucher4 FILL-IN_CodBco4 COMBO_TarjCred FILL-IN-4 
          FILL-IN_ImpNac5 FILL-IN_ImpUsa5 FILL-IN_Voucher5 FILL-IN_CodBco5 
          FILL-IN-5 FILL-IN_SaldoBD FILL-IN_ImpNac6 FILL-IN_ImpUsa6 
          FILL-IN_Voucher6 FILL-IN_SaldoNC FILL-IN_ImpNac7 FILL-IN_ImpUsa7 
          FILL-IN_Voucher7 FILL-IN_SaldoAR FILL-IN_ImpNac8 FILL-IN_ImpUsa8 
          FILL-IN_Voucher8 FILL-IN_CodBco8 FILL-IN-8 FILL-IN_ImpNac9 
          FILL-IN_ImpUsa9 FILL-IN_ImpNac10 FILL-IN_ImpUsa10 RADIO-SET_Codmon 
          FILL-IN_VueNac FILL-IN_VueUsa FILL-IN_T_Venta FILL-IN-coddoc 
          FILL-IN-nrodoc FILL-IN_T_Compra 
      WITH FRAME D-Dialog.
  ENABLE RECT-9 RECT-6 RECT-7 RECT-4 RECT-8 RECT-10 RECT-5 RECT-32 
         FILL-IN_ImpNac1 FILL-IN_ImpUsa1 FILL-IN_ImpNac2 FILL-IN_ImpUsa2 
         FILL-IN_ImpNac4 FILL-IN_ImpUsa4 FILL-IN_Voucher5 FILL-IN_Voucher6 
         FILL-IN_Voucher7 FILL-IN_ImpNac8 FILL-IN_ImpUsa8 FILL-IN_Voucher8 
         FILL-IN_CodBco8 BUTTON-Vales BUTTON-TpoCmb RADIO-SET_Codmon Btn_OK 
         Btn_Cancel 
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

    DEFINE VARIABLE answer AS LOGICAL NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:

        ASSIGN FILL-IN_NomCli = wnomcli.

        /* Tipo de Cambio Caja */
        FIND LAST Gn-tccja WHERE
            Gn-tccja.Fecha <= TODAY NO-LOCK NO-ERROR.
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

        FIND faccorre WHERE
            faccorre.codcia = s-codcia AND
            faccorre.coddoc = s-Coddoc AND
            faccorre.NroSer = s-ptovta EXCLUSIVE-LOCK.
        DISPLAY
            STRING(faccorre.nroser, "999") +
            STRING(FacCorre.Correlativo, "999999") @ FILL-IN-nrodoc
            s-CodDoc @ FILL-IN-coddoc.

        /* Tarjetas de Crédito */
        IF Contado THEN DO:
            FOR EACH FacTabla WHERE
                FacTabla.CodCia = s-CodCia AND
                FacTabla.Tabla = "TC" AND
                FacTabla.Codigo <> "00" AND
                LENGTH(FacTabla.Codigo) <= 2 NO-LOCK:
                answer = COMBO_TarjCred:ADD-LAST(FacTabla.Codigo +
                    " " + FacTabla.Nombre).
            END.
            IF PgoTarjCr = "T" THEN DO:
                FILL-IN_ImpNac1:SENSITIVE = FALSE.
                FILL-IN_ImpUsa1:SENSITIVE = FALSE.
                FILL-IN_ImpNac2:SENSITIVE = FALSE.
                FILL-IN_ImpUsa2:SENSITIVE = FALSE.
                FILL-IN_ImpNac8:SENSITIVE = FALSE.
                FILL-IN_ImpUsa8:SENSITIVE = FALSE.
                FILL-IN_voucher5:SENSITIVE = FALSE.
                FILL-IN_voucher6:SENSITIVE = FALSE.
                FILL-IN_voucher7:SENSITIVE = FALSE.
                FILL-IN_voucher8:SENSITIVE = FALSE.
                FILL-IN_CodBco8:SENSITIVE = FALSE.
                BUTTON-Vales:SENSITIVE = FALSE.
                FILL-IN_ImpNac4 = FILL-IN_ImpNac1.
                FILL-IN_ImpUSA4 = FILL-IN_ImpUSA1.
                FILL-IN_ImpNac1 = 0.
                FILL-IN_ImpUSA1 = 0.
                DISPLAY
                    FILL-IN_ImpNac4
                    FILL-IN_ImpUSA4
                    FILL-IN_ImpNac1
                    FILL-IN_ImpUSA1.
            END.
            ELSE DO:
                FILL-IN_ImpNac4:SENSITIVE = FALSE.
                FILL-IN_ImpUsa4:SENSITIVE = FALSE.
                BUTTON-Vales:SENSITIVE =
                    CAN-FIND(FIRST VtaCvale WHERE
                    vtacvale.codcia = s-codcia AND
                    vtacvale.nroser >= 0).
            END.
        END.
        ELSE DO:
            FILL-IN_ImpNac4:SENSITIVE = FALSE.
            FILL-IN_ImpUsa4:SENSITIVE = FALSE.
            BUTTON-Vales:SENSITIVE =
                CAN-FIND(FIRST VtaCvale WHERE
                vtacvale.codcia = s-codcia AND
                vtacvale.nroser >= 0).
        END.

    END.

    FOR EACH T-VVALE:
        DELETE T-VVALE.
    END.

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
            DISPLAY FILL-IN_ImpUsa1.
        END.
    END.
    HIDE FRAME f-TpoCmb.

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
                input-var-1 = wcodcli
                input-var-2 = "P"
                input-var-3 = "Autorizada".
        WHEN "FILL-IN_Voucher6" THEN 
            ASSIGN
                input-var-1 = 'N/C'
                input-var-2 = wcodcli
                input-var-3 = "P".            
        WHEN "FILL-IN_Voucher7" THEN 
            ASSIGN
                input-var-1 = 'A/R'
                input-var-2 = wcodcli
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
            FILL-IN_EmiCheq:SCREEN-VALUE = wcodcli
            FILL-IN_Voucher2:SENSITIVE = TRUE 
            FILL-IN_CodBco2:SENSITIVE = TRUE
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
            FILL-IN_FecPres:SENSITIVE = FALSE
            FILL-IN_EmiCheq:SENSITIVE = FALSE.
    END.

    IF FILL-IN_ImpNac4 <> 0 OR FILL-IN_ImpUsa4 <> 0 THEN DO:
        ASSIGN
            FILL-IN_Voucher4:SENSITIVE = TRUE 
            FILL-IN_CodBco4:SENSITIVE = TRUE
            COMBO_TarjCred:SENSITIVE = TRUE.
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

