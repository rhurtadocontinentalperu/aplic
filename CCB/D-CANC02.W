&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
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
DEF INPUT PARAMETER Importe  AS DEC.
DEF INPUT PARAMETER Moneda   AS DEC.
DEF INPUT PARAMETER s-TpoCmb AS DEC.
DEF INPUT  PARAMETER wcodcli AS CHAR.
DEF OUTPUT PARAMETER OK AS LOGICAL.

/* Local Variable Definitions ---                                       */
OK = NO.

DEF SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR X-SdoNac AS DEC NO-UNDO.
DEF VAR X-SdoUsa AS DEC NO-UNDO.
DEF VAR X-SdoNc  AS DEC NO-UNDO.

/*
DEF NEW SHARED VAR input-var-1 AS CHAR.
DEF NEW SHARED VAR input-var-2 AS CHAR.
DEF NEW SHARED VAR input-var-3 AS CHAR.
DEF NEW SHARED VAR output-var-1 AS ROWID.
DEF NEW SHARED VAR output-var-2 AS CHAR.
DEF NEW SHARED VAR output-var-3 AS CHAR.
*/

DEFINE VAR fSumSol AS DECIMAL NO-UNDO.
DEFINE VAR fSumDol AS DECIMAL NO-UNDO.

DEF NEW SHARED VAR CB-CODCIA AS INT.

FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCbd THEN CB-CODCIA = s-codcia.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCCaja

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH CcbCCaja SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog CcbCCaja
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog CcbCCaja


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-6 RECT-7 RECT-8 RECT-10 RECT-5 ~
F-CLIECHE FILL-IN_ImpNac1 FILL-IN_ImpUsa1 FILL-IN_ImpNac2 FILL-IN_Voucher2 ~
FILL-IN_CodBco2 FILL-IN_FchVto2 FILL-IN_ImpUsa2 FILL-IN_Voucher3 ~
FILL-IN_CodBco3 FILL-IN_FchVto3 FILL-IN_ImpNac4 FILL-IN_ImpUsa4 ~
FILL-IN_Voucher4 FILL-IN_ImpNac5 FILL-IN_ImpUsa5 FILL-IN_Voucher5 ~
FILL-IN_Codcta5 FILL-IN_ImpNac6 FILL-IN_ImpUsa6 FILL-IN_Voucher6 ~
FILL-IN_ImpNac7 FILL-IN_ImpUsa7 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS X-CodMon X-SdoAct y-CodMon y-SdoAct ~
F-CLIECHE FILL-IN_ImpNac1 FILL-IN_ImpUsa1 FILL-IN_ImpNac2 FILL-IN_Voucher2 ~
FILL-IN_CodBco2 FILL-IN-2 FILL-IN_FchVto2 FILL-IN_ImpUsa2 FILL-IN_ImpNac3 ~
FILL-IN_ImpUsa3 FILL-IN_Voucher3 FILL-IN_CodBco3 FILL-IN-3 FILL-IN_FchVto3 ~
FILL-IN_ImpNac4 FILL-IN_ImpUsa4 FILL-IN_Voucher4 FILL-IN_CodBco4 FILL-IN-4 ~
FILL-IN_ImpNac5 FILL-IN_ImpUsa5 FILL-IN_Voucher5 FILL-IN_Codcta5 FILL-IN-5 ~
FILL-IN_Saldo FILL-IN_ImpNac6 FILL-IN_ImpUsa6 FILL-IN_Voucher6 ~
FILL-IN_ImpNac7 FILL-IN_ImpUsa7 FILL-IN_Voucher7 FILL-IN_VueNac ~
FILL-IN_VueUsa R-Codmon FILL-IN_T_Venta FILL-IN_T_Compra 

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
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE F-CLIECHE AS CHARACTER FORMAT "X(256)":U 
     LABEL "Emisor Cheque" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81
     BGCOLOR 7  NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodBco2 AS CHARACTER FORMAT "x(5)" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81.

DEFINE VARIABLE FILL-IN_CodBco3 AS CHARACTER FORMAT "x(5)" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81.

DEFINE VARIABLE FILL-IN_CodBco4 AS CHARACTER FORMAT "x(5)" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81.

DEFINE VARIABLE FILL-IN_Codcta5 AS CHARACTER FORMAT "x(10)" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81.

DEFINE VARIABLE FILL-IN_FchVto2 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81.

DEFINE VARIABLE FILL-IN_FchVto3 AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81.

DEFINE VARIABLE FILL-IN_ImpNac1 AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81.

DEFINE VARIABLE FILL-IN_ImpNac2 AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81.

DEFINE VARIABLE FILL-IN_ImpNac3 AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81.

DEFINE VARIABLE FILL-IN_ImpNac4 AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81.

DEFINE VARIABLE FILL-IN_ImpNac5 AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81.

DEFINE VARIABLE FILL-IN_ImpNac6 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpNac7 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpUsa1 AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81.

DEFINE VARIABLE FILL-IN_ImpUsa2 AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81.

DEFINE VARIABLE FILL-IN_ImpUsa3 AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81.

DEFINE VARIABLE FILL-IN_ImpUsa4 AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81.

DEFINE VARIABLE FILL-IN_ImpUsa5 AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81.

DEFINE VARIABLE FILL-IN_ImpUsa6 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpUsa7 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Saldo AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .81
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

DEFINE VARIABLE FILL-IN_Voucher2 AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 15.72 BY .81.

DEFINE VARIABLE FILL-IN_Voucher3 AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 15.72 BY .81.

DEFINE VARIABLE FILL-IN_Voucher4 AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 15.72 BY .81.

DEFINE VARIABLE FILL-IN_Voucher5 AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 15.72 BY .81.

DEFINE VARIABLE FILL-IN_Voucher6 AS CHARACTER FORMAT "xxx-xxxxxx":U 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Voucher7 AS CHARACTER FORMAT "x(8)" 
     VIEW-AS FILL-IN 
     SIZE 15.72 BY .81.

DEFINE VARIABLE FILL-IN_VueNac AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81.

DEFINE VARIABLE FILL-IN_VueUsa AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81.

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
     SIZE 16.57 BY 8.65.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY 6.35.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY .96.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 10.57 BY 8.65.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 10.57 BY 8.65.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      CcbCCaja SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     X-CodMon AT ROW 1.54 COL 13.29 COLON-ALIGNED
     X-SdoAct AT ROW 1.54 COL 18.29 COLON-ALIGNED NO-LABEL
     y-CodMon AT ROW 1.54 COL 29.29 COLON-ALIGNED NO-LABEL
     y-SdoAct AT ROW 1.54 COL 34.29 COLON-ALIGNED NO-LABEL
     F-CLIECHE AT ROW 1.54 COL 72.29 COLON-ALIGNED
     FILL-IN_ImpNac1 AT ROW 3.69 COL 13.57 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpUsa1 AT ROW 3.69 COL 24.57 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac2 AT ROW 4.46 COL 13.57 COLON-ALIGNED NO-LABEL
     FILL-IN_Voucher2 AT ROW 4.46 COL 34.57 COLON-ALIGNED NO-LABEL
     FILL-IN_CodBco2 AT ROW 4.46 COL 51 COLON-ALIGNED NO-LABEL
     FILL-IN-2 AT ROW 4.46 COL 56 COLON-ALIGNED NO-LABEL
     FILL-IN_FchVto2 AT ROW 4.46 COL 71 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpUsa2 AT ROW 4.5 COL 24.57 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac3 AT ROW 5.23 COL 13.57 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpUsa3 AT ROW 5.23 COL 24.57 COLON-ALIGNED NO-LABEL
     FILL-IN_Voucher3 AT ROW 5.23 COL 34.57 COLON-ALIGNED NO-LABEL
     FILL-IN_CodBco3 AT ROW 5.23 COL 51 COLON-ALIGNED NO-LABEL
     FILL-IN-3 AT ROW 5.23 COL 56 COLON-ALIGNED NO-LABEL
     FILL-IN_FchVto3 AT ROW 5.23 COL 71 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac4 AT ROW 6 COL 13.57 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpUsa4 AT ROW 6 COL 24.57 COLON-ALIGNED NO-LABEL
     FILL-IN_Voucher4 AT ROW 6 COL 34.57 COLON-ALIGNED NO-LABEL
     FILL-IN_CodBco4 AT ROW 6 COL 51 COLON-ALIGNED NO-LABEL
     FILL-IN-4 AT ROW 6 COL 56 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac5 AT ROW 6.77 COL 13.57 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpUsa5 AT ROW 6.77 COL 24.57 COLON-ALIGNED NO-LABEL
     FILL-IN_Voucher5 AT ROW 6.77 COL 34.57 COLON-ALIGNED NO-LABEL
     FILL-IN_Codcta5 AT ROW 6.77 COL 51 COLON-ALIGNED NO-LABEL
     FILL-IN-5 AT ROW 6.77 COL 61 COLON-ALIGNED NO-LABEL
     FILL-IN_Saldo AT ROW 6.77 COL 78.29 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac6 AT ROW 7.62 COL 13.57 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpUsa6 AT ROW 7.62 COL 24.57 COLON-ALIGNED NO-LABEL
     FILL-IN_Voucher6 AT ROW 7.62 COL 34.57 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac7 AT ROW 8.5 COL 13.57 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpUsa7 AT ROW 8.5 COL 24.57 COLON-ALIGNED NO-LABEL
     FILL-IN_Voucher7 AT ROW 8.5 COL 34.57 COLON-ALIGNED NO-LABEL
     FILL-IN_VueNac AT ROW 10.04 COL 13.14 COLON-ALIGNED NO-LABEL
     FILL-IN_VueUsa AT ROW 10.04 COL 24.14 COLON-ALIGNED NO-LABEL
     R-Codmon AT ROW 10.12 COL 8.29 NO-LABEL
     FILL-IN_T_Venta AT ROW 11.08 COL 51.14 COLON-ALIGNED
     Btn_OK AT ROW 11.23 COL 5
     Btn_Cancel AT ROW 11.23 COL 20
     FILL-IN_T_Compra AT ROW 11.88 COL 51.43 COLON-ALIGNED
     RECT-6 AT ROW 2.54 COL 1
     RECT-7 AT ROW 2.54 COL 15
     RECT-8 AT ROW 2.54 COL 25.57
     "Efectivo" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.88 COL 2
     "Numero de referencia" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 2.81 COL 37.14
     "Banco/Cuenta" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 2.77 COL 53.14
     "F.Presentacion" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 2.69 COL 73.43
     "Cheque" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 4.65 COL 2
     "Comisiones" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 6.19 COL 2
     RECT-10 AT ROW 2.54 COL 36.14
     "Deposito al banco" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 6.96 COL 2
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME D-Dialog
     "Nota de Credito" VIEW-AS TEXT
          SIZE 11.86 BY .65 AT ROW 7.65 COL 1.86
     "Vuelto" VIEW-AS TEXT
          SIZE 5.57 BY .5 AT ROW 10.23 COL 2
     "En S/." VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 2.73 COL 18
     "En US$" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 2.77 COL 27.72
     "Cred. personal" VIEW-AS TEXT
          SIZE 11.86 BY .65 AT ROW 8.69 COL 2
     RECT-5 AT ROW 3.5 COL 1
     SPACE(0.71) SKIP(4.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Forma de Cancelacion".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   L-To-R                                                               */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodBco4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpNac3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpUsa3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Saldo IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_T_Compra IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_T_Venta IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Voucher7 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_VueNac IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_VueUsa IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET R-Codmon IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN X-CodMon IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN X-SdoAct IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN y-CodMon IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN y-SdoAct IN FRAME D-Dialog
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Forma de Cancelacion */
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
  ASSIGN
    FILL-IN_CodBco2 FILL-IN_CodBco3 FILL-IN_CodBco4 FILL-IN_Codcta5 
    FILL-IN_FchVto2 FILL-IN_FchVto3 
    FILL-IN_ImpNac1 FILL-IN_ImpNac2 FILL-IN_ImpNac3 FILL-IN_ImpNac4 
    FILL-IN_ImpNac5 FILL-IN_ImpNac7
    FILL-IN_ImpUsa1 FILL-IN_ImpUsa2 FILL-IN_ImpUsa3 FILL-IN_ImpUsa4 
    FILL-IN_ImpUsa5 FILL-IN_ImpUsa7
    FILL-IN_T_Compra FILL-IN_T_Venta 
    FILL-IN_Voucher2 FILL-IN_Voucher3 FILL-IN_Voucher4 
    FILL-IN_Voucher5 FILL-IN_ImpNac6 FILL-IN_ImpUsa6 FILL-IN_Voucher6 
    FILL-IN_Voucher7
    FILL-IN_VueNac FILL-IN_VueUsa 
    R-Codmon
    x-sdoact .
    

  IF FILL-IN_VueUsa < 0 OR 
     FILL-IN_VueNac < 0 THEN DO:
    MESSAGE "El pago no cubre el monto adeudado" VIEW-AS ALERT-BOX ERROR.
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

     IF FILL-IN_FchVto2 = ? OR FILL-IN_FchVto2 < TODAY THEN DO:
        MESSAGE "Fecha de Presentacion No Valida " 
        VIEW-AS ALERT-BOX ERROR.  
        APPLY "ENTRY" TO FILL-IN_FchVto2.
        RETURN NO-APPLY.
     END.
     IF FILL-IN_FchVto2 - TODAY > 60 THEN DO:
        MESSAGE "Fecha de Presentacion No Valida, Excede los 30 dias de Ley " 
        VIEW-AS ALERT-BOX ERROR.  
        APPLY "ENTRY" TO FILL-IN_FchVto2.
        RETURN NO-APPLY.
     END.
  END.
  
/*  /* CONSISTENCIA PRESTAMOS AL PERSONAL */
 *   IF FILL-IN_ImpNac7 <> 0 OR FILL-IN_ImpUsa7 <> 0 THEN DO:
 *     IF FILL-IN_Voucher7 = '' THEN DO:
 *         MESSAGE 'Ingrese el codigo del personal' VIEW-AS ALERT-BOX ERROR.
 *         APPLY 'ENTRRY':U TO FILL-IN_Voucher7.
 *         RETURN NO-APPLY.
 *     END.
 *   END.*/

  IF F-ClieChe:SCREEN-VALUE <> "" THEN DO:
     FIND gn-clie WHERE gn-clie.CodCia = 0 
                   AND  gn-clie.CodCli = F-ClieChe:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE "Emisor de Cheque No Existe" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO F-ClieChe.
        RETURN NO-APPLY.   
     END.
     IF gn-clie.ImpLc <= 0 THEN DO:
        MESSAGE "Emisor de Cheque No Tiene Linea de Credito" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO F-ClieChe.
        RETURN NO-APPLY.        
     END.
/*
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
*/     
  END.

  DEFINE VAR x-tipo   AS DECI INIT 0.

  IF Moneda = 1 THEN x-tipo = FILL-IN_T_Compra.
  IF Moneda = 2 THEN x-tipo = FILL-IN_T_Venta.


  FOR EACH T-CcbCCaja:
    DELETE T-CcbCCaja.
  END.
  CREATE T-CcbCCaja.
  ASSIGN
    T-CcbCCaja.CodBco[2] = FILL-IN_CodBco2
    T-CcbCCaja.CodBco[3] = FILL-IN_CodBco3
    T-CcbCCaja.CodBco[4] = FILL-IN_CodBco4
    T-CcbCCaja.Codcta[5] = FILL-IN_Codcta5 
    T-CcbCCaja.FchVto[2] = FILL-IN_FchVto2
    T-CcbCCaja.FchVto[3] = FILL-IN_FchVto3
    T-CcbCCaja.ImpNac[1] = FILL-IN_ImpNac1
    T-CcbCCaja.ImpNac[2] = FILL-IN_ImpNac2
    T-CcbCCaja.ImpNac[3] = FILL-IN_ImpNac3
    T-CcbCCaja.ImpNac[4] = FILL-IN_ImpNac4
    T-CcbCCaja.ImpNac[5] = FILL-IN_ImpNac5
    T-CcbCCaja.ImpNac[6] = FILL-IN_ImpNac6
    T-CcbCCaja.ImpNac[7] = FILL-IN_ImpNac7
    T-CcbCCaja.ImpUsa[1] = FILL-IN_ImpUsa1
    T-CcbCCaja.ImpUsa[2] = FILL-IN_ImpUsa2
    T-CcbCCaja.ImpUsa[3] = FILL-IN_ImpUsa3
    T-CcbCCaja.ImpUsa[4] = FILL-IN_ImpUsa4
    T-CcbCCaja.ImpUsa[5] = FILL-IN_ImpUsa5
    T-CcbCCaja.ImpUsa[6] = FILL-IN_ImpUsa6
    T-CcbCCaja.ImpUsa[7] = FILL-IN_ImpUsa7
    T-CcbCCaja.TpoCmb    = x-tipo
    T-CcbCCaja.Voucher[2]= FILL-IN_Voucher2
    T-CcbCCaja.Voucher[3]= FILL-IN_Voucher3
    T-CcbCCaja.Voucher[4]= FILL-IN_Voucher4
    T-CcbCCaja.Voucher[5]= FILL-IN_Voucher5
    T-CcbCCaja.Voucher[6]= FILL-IN_Voucher6
    T-CcbCCaja.Voucher[7]= FILL-IN_Voucher7
    T-CcbCCaja.VueNac    = FILL-IN_VueNac
    T-CcbCCaja.VueUsa    = FILL-IN_VueUsa.

   IF FILL-IN_FchVto2 <> ? THEN DO:
        IF FILL-IN_FchVto2 = TODAY THEN ASSIGN
            T-CcbCCaja.CodBco[2] = FILL-IN_CodBco2 
            T-CcbCCaja.ImpNac[2] = FILL-IN_ImpNac2
            T-CcbCCaja.ImpUsa[2] = FILL-IN_ImpUsa2
            T-CcbCCaja.Voucher[2]= FILL-IN_Voucher2
            T-CcbCCaja.Voucher[10]= F-ClieChe:SCREEN-VALUE
            T-CcbCCaja.FchVto[2] = FILL-IN_FchVto2

            T-CcbCCaja.CodBco[3] = ""
            T-CcbCCaja.ImpNac[3] = 0
            T-CcbCCaja.ImpUsa[3] = 0
            T-CcbCCaja.Voucher[3]= ""
            T-CcbCCaja.FchVto[3] = ?.


        ELSE ASSIGN
            T-CcbCCaja.CodBco[3] = FILL-IN_CodBco2 
            T-CcbCCaja.ImpNac[3] = FILL-IN_ImpNac2
            T-CcbCCaja.ImpUsa[3] = FILL-IN_ImpUsa2
            T-CcbCCaja.Voucher[3]= FILL-IN_Voucher2
            T-CcbCCaja.Voucher[10]= F-ClieChe:SCREEN-VALUE            
            T-CcbCCaja.FchVto[3] = FILL-IN_FchVto2

            T-CcbCCaja.CodBco[2] = ""
            T-CcbCCaja.ImpNac[2] = 0
            T-CcbCCaja.ImpUsa[2] = 0
            T-CcbCCaja.Voucher[2]= ""
            T-CcbCCaja.FchVto[2] = ?.

    END.    


    IF FILL-IN_Voucher5 <> "" AND 
       (FILL-IN_ImpNac5 + FILL-IN_ImpUsa5) <> 0 THEN DO:
        FIND ccbboldep WHERE ccbboldep.CodCia = S-CodCia 
                       AND  ccbboldep.CodDoc = "BD" 
                       AND  ccbboldep.CodCli = wcodcli
                       AND  ccbboldep.nrodoc = FILL-IN_Voucher5
                      EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL ccbboldep THEN DO:
          ASSIGN
            T-CcbCCaja.CodBco[5] = Ccbboldep.CodBco.    /* OJO */
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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodBco2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco2 D-Dialog
ON LEAVE OF FILL-IN_CodBco2 IN FRAME D-Dialog
DO:
  ASSIGN {&SELF-NAME}.
  FIND cb-tabl WHERE cb-tabl.Tabla = "04" AND cb-tabl.codigo = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE cb-tabl
  THEN FILL-IN-2:SCREEN-VALUE = cb-tabl.Nombre.
  ELSE FILL-IN-2:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco2 D-Dialog
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_CodBco2 IN FRAME D-Dialog
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


&Scoped-define SELF-NAME FILL-IN_CodBco3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco3 D-Dialog
ON LEAVE OF FILL-IN_CodBco3 IN FRAME D-Dialog
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco3 D-Dialog
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_CodBco3 IN FRAME D-Dialog
OR F8 OF FILL-IN_CodBco3
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco4 D-Dialog
ON LEAVE OF FILL-IN_CodBco4 IN FRAME D-Dialog
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco4 D-Dialog
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_CodBco4 IN FRAME D-Dialog
OR F8 OF FILL-IN_CodBco4
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


&Scoped-define SELF-NAME FILL-IN_Codcta5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Codcta5 D-Dialog
ON LEAVE OF FILL-IN_Codcta5 IN FRAME D-Dialog
DO:
  FIND cb-ctas WHERE cb-ctas.codcia = 0 
                AND  cb-ctas.codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE cb-ctas
  THEN FILL-IN-5:SCREEN-VALUE = cb-ctas.Nomcta.
  ELSE FILL-IN-5:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Codcta5 D-Dialog
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_Codcta5 IN FRAME D-Dialog
OR F8 OF FILL-IN_CodCta5
DO:
  ASSIGN
    input-var-1 = "104"
    input-var-2 = ""
    input-var-3 = ""
    output-var-1 = ?.
  RUN lkup/c-cuenta ("Cuentas bancarias").
  IF output-var-1 NE ?
  THEN DO:
    FIND cb-ctas WHERE ROWID(cb-ctas) = output-var-1 NO-LOCK NO-ERROR.
    IF AVAILABLE cb-ctas
    THEN SELF:SCREEN-VALUE = cb-ctas.Codcta.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_FchVto2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_FchVto2 D-Dialog
ON LEAVE OF FILL-IN_FchVto2 IN FRAME D-Dialog
DO:
  ASSIGN FILL-IN_FchVto2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpNac1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac1 D-Dialog
ON LEAVE OF FILL-IN_ImpNac1 IN FRAME D-Dialog
DO:
  RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpNac2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac2 D-Dialog
ON LEAVE OF FILL-IN_ImpNac2 IN FRAME D-Dialog
DO:
    ASSIGN FILL-IN_ImpNac2.
    RUN _habilita.
  RUN Calculo.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpNac3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac3 D-Dialog
ON LEAVE OF FILL-IN_ImpNac3 IN FRAME D-Dialog
DO:
    ASSIGN FILL-IN_ImpNac3.
    RUN _habilita.
  RUN Calculo.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpNac4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac4 D-Dialog
ON LEAVE OF FILL-IN_ImpNac4 IN FRAME D-Dialog
DO:
    ASSIGN FILL-IN_ImpNac4.
    RUN _habilita.
  RUN Calculo.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpNac5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac5 D-Dialog
ON LEAVE OF FILL-IN_ImpNac5 IN FRAME D-Dialog
DO:
    ASSIGN FILL-IN_ImpNac5.
    IF FILL-IN_ImpNac5 > FILL-IN_Saldo THEN DO:
       MESSAGE " Este monto es mayor al saldo " SKIP
               "   de la boleta de deposito   " VIEW-AS ALERT-BOX ERROR.
/*       RETURN NO-APPLY.*/
    END.   
   RUN _habilita.
  RUN Calculo.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpNac6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac6 D-Dialog
ON LEAVE OF FILL-IN_ImpNac6 IN FRAME D-Dialog
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac7 D-Dialog
ON LEAVE OF FILL-IN_ImpNac7 IN FRAME D-Dialog
DO:
    ASSIGN {&SELF-NAME}.
    RUN _habilita.
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
    ASSIGN FILL-IN_ImpUsa2.
    RUN _habilita.
  RUN Calculo.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpUsa3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpUsa3 D-Dialog
ON LEAVE OF FILL-IN_ImpUsa3 IN FRAME D-Dialog
DO:
    ASSIGN FILL-IN_ImpUsa3.
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
   IF FILL-IN_ImpUsa5 > FILL-IN_Saldo THEN DO:
      MESSAGE " ESTE MONTO ES MAYOR AL SALDO " SKIP
              "   DE LA BOLETA DE DEPOSITO   " VIEW-AS ALERT-BOX ERROR.
/*      RETURN NO-APPLY.*/
   END.   
   RUN _habilita.
  RUN Calculo.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_ImpUsa6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpUsa6 D-Dialog
ON LEAVE OF FILL-IN_ImpUsa6 IN FRAME D-Dialog
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpUsa7 D-Dialog
ON LEAVE OF FILL-IN_ImpUsa7 IN FRAME D-Dialog
DO:
    ASSIGN {&SELF-NAME}.
    RUN _habilita.
    RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Voucher2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher2 D-Dialog
ON LEAVE OF FILL-IN_Voucher2 IN FRAME D-Dialog
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher5 D-Dialog
ON LEAVE OF FILL-IN_Voucher5 IN FRAME D-Dialog
DO:
  IF SELF:SCREEN-VALUE = "" 
  THEN DO:
    ASSIGN
        FILL-IN-5 = ''
        FILL-IN_CodCta5 = ''
        FILL-IN_ImpNac5 = 0
        FILL-IN_ImpUsa5 = 0
        FILL-IN_Saldo   = 0.
    DISPLAY FILL-IN-5 FILL-IN_CodCta5
        FILL-IN_ImpNac5 FILL-IN_ImpUsa5 FILL-IN_Saldo 
        WITH FRAME {&FRAME-NAME}.
    RETURN.
  END.

  ASSIGN FILL-IN_Voucher5.
   FIND ccbboldep WHERE ccbboldep.CodCia = S-CodCia 
                  AND  ccbboldep.CodDoc = "BD" 
                  AND  ccbboldep.CodCli = wcodcli
                  AND  ccbboldep.nrodoc = FILL-IN_Voucher5
                  AND  ccbboldep.coddiv = s-coddiv
                  NO-LOCK NO-ERROR.
                  
   IF AVAILABLE ccbboldep THEN DO:
        IF CcbBolDep.FlgEst = "C" THEN DO:
            MESSAGE " Boleta Deposito Nro. " ccbboldep.nrodoc SKIP
                    "        esta Cancelado  " VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        IF CcbBolDep.FlgEst <> "P" THEN DO:
            MESSAGE " Boleta Deposito Nro. " ccbboldep.nrodoc SKIP
                    " NO está aprobada " VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        IF CcbBolDep.CodMon = 1 THEN DO:
           ASSIGN FILL-IN_ImpNac5 = CcbBolDep.SdoAct
                  FILL-IN_ImpUsa5 = 0
                  FILL-IN_ImpNac5:SENSITIVE = YES
                  FILL-IN_ImpUsa5:SENSITIVE = FALSE.
           APPLY "ENTRY" TO FILL-IN_ImpNac5.
        END.
        ELSE DO:
           ASSIGN FILL-IN_ImpUsa5 = CcbBolDep.SdoAct
                  FILL-IN_ImpNac5 = 0
                  FILL-IN_ImpUsa5:SENSITIVE = YES
                  FILL-IN_ImpNac5:SENSITIVE = FALSE. 
           APPLY "ENTRY" TO FILL-IN_ImpUsa5.
        END.
        ASSIGN FILL-IN_Saldo = CcbBolDep.SdoAct.
        DO WITH FRAME {&FRAME-NAME}:     
           DISPLAY FILL-IN_Saldo
                   FILL-IN_ImpUsa5
                   FILL-IN_ImpNac5.
        END.
        FIND cb-ctas WHERE cb-ctas.CodCia = 0
                      AND  cb-ctas.CodCta = CcbBolDep.CodCta
                     NO-LOCK NO-ERROR.
        IF AVAILABLE cb-ctas THEN 
            ASSIGN 
                FILL-IN_CodCta5:SCREEN-VALUE = cb-ctas.CodCta
                FILL-IN-5:SCREEN-VALUE = cb-ctas.Nomcta.
        ELSE 
            ASSIGN
                FILL-IN_CodCta5:SCREEN-VALUE = ""
                FILL-IN-5:SCREEN-VALUE = "".  
   END.
   ELSE DO:
    MESSAGE "Nro. de Documento no Registrado" skip
            "o no pertenece al Cliente Seleccionado" VIEW-AS ALERT-BOX ERROR.
   END.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Voucher6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher6 D-Dialog
ON LEAVE OF FILL-IN_Voucher6 IN FRAME D-Dialog
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
     IF CcbCDocu.Codcli <> wcodcli THEN DO:
        MESSAGE 'Nota de Credito no corresponde al cliente' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.
     IF CcbCDocu.FlgEst = 'C' THEN DO:
        MESSAGE 'Documento se encuentra asignado ' + CcbCDocu.CodRef + '-' + CcbCDocu.NroRef
                VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.
     IF CcbCDocu.Codmon = 1 THEN
        DO WITH FRAME {&FRAME-NAME}:
           DISPLAY      
           CcbCDocu.SdoAct @ FILL-IN_ImpNac6.
        END.   
     ELSE
        DO WITH FRAME {&FRAME-NAME}:
           DISPLAY
           CcbCDocu.SdoAct @ FILL-IN_ImpUsa6.
        END.  
     X-SdoNc  = CcbCDocu.SdoAct.      
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Voucher7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher7 D-Dialog
ON LEAVE OF FILL-IN_Voucher7 IN FRAME D-Dialog
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  ASSIGN
    SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE), '99999999')
    NO-ERROR.
  ASSIGN {&SELF-NAME}.
  FIND Cb-auxi WHERE Cb-auxi.codcia = 000
    AND Cb-auxi.clfaux = 'PE'
    AND Cb-auxi.codaux = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Cb-auxi THEN DO:
    MESSAGE 'Codigo del personal NO registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-Codmon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-Codmon D-Dialog
ON VALUE-CHANGED OF R-Codmon IN FRAME D-Dialog
DO:
  ASSIGN R-Codmon.
  RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME X-SdoAct
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-SdoAct D-Dialog
ON LEAVE OF X-SdoAct IN FRAME D-Dialog
DO:
  ASSIGN X-SdoAct.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME y-SdoAct
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL y-SdoAct D-Dialog
ON LEAVE OF y-SdoAct IN FRAME D-Dialog
DO:
  ASSIGN X-SdoAct.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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
        FILL-IN_ImpNac1 FILL-IN_ImpNac2 FILL-IN_ImpNac3 
        FILL-IN_ImpNac4 FILL-IN_ImpNac5 FILL-IN_ImpNac6 
        FILL-IN_ImpNac7
        FILL-IN_ImpUsa1 FILL-IN_ImpUsa2 FILL-IN_ImpUsa3 
        FILL-IN_ImpUsa4 FILL-IN_ImpUsa5 FILL-IN_ImpUsa6 
        FILL-IN_ImpUsa7
        FILL-IN_T_Compra FILL-IN_T_Venta R-Codmon.
        
   fSumSol = (FILL-IN_ImpNac1 + FILL-IN_ImpNac2 + 
              FILL-IN_ImpNac3 + FILL-IN_ImpNac4 + 
              FILL-IN_ImpNac5 + FILL-IN_ImpNac6 +
              FILL-IN_ImpNac7). 
              
   fSumDol = (FILL-IN_ImpUsa1 + FILL-IN_ImpUsa2 + 
              FILL-IN_ImpUsa3 + FILL-IN_ImpUsa4 + 
              FILL-IN_ImpUsa5 + FILL-IN_ImpUsa6 +
              FILL-IN_ImpUsa7).
              
   FILL-IN_VueNac = 0.
   FILL-IN_VueUsa = 0.
   IF R-Codmon = 1 THEN
      IF Moneda = 1 THEN FILL-IN_VueNac = ROUND(fSumSol + ROUND( fSumDol * FILL-IN_T_Compra, 2 ) - X-SdoNac, 2).
      IF Moneda = 2 THEN FILL-IN_VueNac = ROUND(fSumSol + ROUND( fSumDol * FILL-IN_T_Venta, 2 ) - X-SdoNac, 2).
 /*
   IF R-Codmon = 2 THEN
      IF Moneda = 1 THEN FILL-IN_VueUsa = ROUND(fSumDol + ROUND( fSumSol / FILL-IN_T_Compra, 2 ) - X-SdoUsa, 2).
      IF Moneda = 2 THEN FILL-IN_VueUsa = ROUND(fSumDol + ROUND( fSumSol / FILL-IN_T_Venta, 2 ) - X-SdoUsa, 2).
*/
   DISPLAY FILL-IN_VueNac FILL-IN_VueUsa WITH FRAME D-Dialog.
   
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  DISPLAY X-CodMon X-SdoAct y-CodMon y-SdoAct F-CLIECHE FILL-IN_ImpNac1 
          FILL-IN_ImpUsa1 FILL-IN_ImpNac2 FILL-IN_Voucher2 FILL-IN_CodBco2 
          FILL-IN-2 FILL-IN_FchVto2 FILL-IN_ImpUsa2 FILL-IN_ImpNac3 
          FILL-IN_ImpUsa3 FILL-IN_Voucher3 FILL-IN_CodBco3 FILL-IN-3 
          FILL-IN_FchVto3 FILL-IN_ImpNac4 FILL-IN_ImpUsa4 FILL-IN_Voucher4 
          FILL-IN_CodBco4 FILL-IN-4 FILL-IN_ImpNac5 FILL-IN_ImpUsa5 
          FILL-IN_Voucher5 FILL-IN_Codcta5 FILL-IN-5 FILL-IN_Saldo 
          FILL-IN_ImpNac6 FILL-IN_ImpUsa6 FILL-IN_Voucher6 FILL-IN_ImpNac7 
          FILL-IN_ImpUsa7 FILL-IN_Voucher7 FILL-IN_VueNac FILL-IN_VueUsa 
          R-Codmon FILL-IN_T_Venta FILL-IN_T_Compra 
      WITH FRAME D-Dialog.
  ENABLE RECT-6 RECT-7 RECT-8 RECT-10 RECT-5 F-CLIECHE FILL-IN_ImpNac1 
         FILL-IN_ImpUsa1 FILL-IN_ImpNac2 FILL-IN_Voucher2 FILL-IN_CodBco2 
         FILL-IN_FchVto2 FILL-IN_ImpUsa2 FILL-IN_Voucher3 FILL-IN_CodBco3 
         FILL-IN_FchVto3 FILL-IN_ImpNac4 FILL-IN_ImpUsa4 FILL-IN_Voucher4 
         FILL-IN_ImpNac5 FILL-IN_ImpUsa5 FILL-IN_Voucher5 FILL-IN_Codcta5 
         FILL-IN_ImpNac6 FILL-IN_ImpUsa6 FILL-IN_Voucher6 FILL-IN_ImpNac7 
         FILL-IN_ImpUsa7 Btn_OK Btn_Cancel 
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
  DO WITH FRAME D-Dialog:
     R-Codmon = 1.
     display R-CodMon.

    ASSIGN
        X-CodMon:SCREEN-VALUE = (IF Moneda = 1 THEN "S/." ELSE "US$")
        y-CodMon:SCREEN-VALUE = (IF Moneda = 1 THEN "US$" ELSE "S/.")
        X-SdoAct:SCREEN-VALUE = STRING(Importe).

    /* Tipo de Cambio */
    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.

    FIND LAST Gn-tccja WHERE Gn-tccja.Fecha <= TODAY AND
                             Gn-Tccja.CodDiv = S-CODDIV
                             NO-LOCK NO-ERROR.
                              
    /*IF AVAILABLE FacCfgGn THEN DO:    */
    IF AVAILABLE Gn-Tccja THEN DO:    
        /*
        FILL-IN_T_Compra:SCREEN-VALUE = STRING(FacCfgGn.Tpocmb[2]).
        FILL-IN_T_Venta:SCREEN-VALUE = STRING(FacCfgGn.Tpocmb[1]).
        */
        FILL-IN_T_Compra:SCREEN-VALUE = STRING(Gn-Tccja.Compra).
        FILL-IN_T_Venta:SCREEN-VALUE = STRING(Gn-Tccja.Venta).
        
        IF Moneda = 1
        THEN ASSIGN
                /*
                X-SdoNac = Importe
                X-SdoUsa = ROUND(Importe / ROUND(FacCfgGn.Tpocmb[2], 3), 2)
                Y-SdoAct:SCREEN-VALUE = STRING(ROUND(Importe / ROUND(FacCfgGn.Tpocmb[2], 3), 2)).
                */
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
               FILL-IN_FchVto2:SENSITIVE = FALSE
               F-ClieChe:SENSITIVE = FALSE
               FILL-IN_Voucher3:SENSITIVE = FALSE 
               FILL-IN_CodBco3:SENSITIVE = FALSE
               FILL-IN_FchVto3:SENSITIVE = FALSE
               FILL-IN_Voucher4:SENSITIVE = FALSE 
               FILL-IN_CodBco4:SENSITIVE = FALSE
               /* FILL-IN_Voucher5:SENSITIVE = FALSE 
               FILL-IN_CodBco5:SENSITIVE = FALSE. */        
               FILL-IN_Voucher7:SENSITIVE = FALSE 
               R-CODMON:SENSITIVE = FALSE.
   
     APPLY "ENTRY" TO FILL-IN_ImpNac1.

  END.
  
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
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.
    
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
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "FILL-IN_Voucher5" THEN 
             ASSIGN input-var-1 = wcodcli input-var-2 = "P" input-var-3 = "Autorizada".

        WHEN "FILL-IN_Voucher6" THEN 
            ASSIGN
                input-var-1 = 'N/C'
                input-var-2 = wcodcli
                input-var-3 = "P".             
        WHEN "FILL-IN_Voucher7" THEN 
            ASSIGN
                input-var-1 = 'PE'
                input-var-2 = ''
                input-var-3 = ''.             
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _Habilita D-Dialog 
PROCEDURE _Habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    IF FILL-IN_ImpNac2 <> 0 OR FILL-IN_ImpUsa2 <> 0 THEN
        ASSIGN FILL-IN_Voucher2:SENSITIVE = TRUE 
               FILL-IN_CodBco2:SENSITIVE = TRUE 
               FILL-IN_FchVto2:SENSITIVE = TRUE
               F-CLIECHE:SENSITIVE = TRUE.
    ELSE            
        ASSIGN FILL-IN_Voucher2:SCREEN-VALUE = "" 
               FILL-IN_CodBco2:SCREEN-VALUE = "" 
               FILL-IN_FchVto2:SCREEN-VALUE = ?
               F-CLIECHE:SCREEN-VALUE = ""
               FILL-IN-2:SCREEN-VALUE = ""
               FILL-IN_Voucher2:SENSITIVE = FALSE 
               FILL-IN_CodBco2:SENSITIVE = FALSE 
               FILL-IN_FchVto2:SENSITIVE = FALSE
               F-CLIECHE:SENSITIVE = FALSE.
 /*
    IF FILL-IN_ImpNac3 <> 0 OR FILL-IN_ImpUsa3 <> 0 THEN
        ASSIGN FILL-IN_Voucher3:SENSITIVE = TRUE 
               FILL-IN_CodBco3:SENSITIVE = TRUE 
               FILL-IN_FchVto3:SENSITIVE = TRUE.
    ELSE            
        ASSIGN FILL-IN_Voucher3:SCREEN-VALUE = "" 
               FILL-IN_CodBco3:SCREEN-VALUE = "" 
               FILL-IN_FchVto3:SCREEN-VALUE = ?
               FILL-IN-3:SCREEN-VALUE = ""
               FILL-IN_Voucher3:SENSITIVE = FALSE 
               FILL-IN_CodBco3:SENSITIVE = FALSE 
               FILL-IN_FchVto3:SENSITIVE = FALSE.
 */  
    IF FILL-IN_ImpNac4 <> 0 OR FILL-IN_ImpUsa4 <> 0 THEN
        ASSIGN FILL-IN_Voucher4:SENSITIVE = TRUE 
               FILL-IN_CodBco4:SENSITIVE = TRUE.
    ELSE
        ASSIGN FILL-IN_Voucher4:SCREEN-VALUE = "" 
               FILL-IN_CodBco4:SCREEN-VALUE = ""
               FILL-IN-4:SCREEN-VALUE = ""
               FILL-IN_Voucher4:SENSITIVE = FALSE 
               FILL-IN_CodBco4:SENSITIVE = FALSE.

 /* IF FILL-IN_ImpNac5 <> 0 OR FILL-IN_ImpUsa5 <> 0 THEN
        ASSIGN FILL-IN_Voucher5:SENSITIVE = TRUE 
               FILL-IN_CodBco5:SENSITIVE = TRUE.
    ELSE           
        ASSIGN FILL-IN_Voucher5:SCREEN-VALUE = "" 
               FILL-IN_CodBco5:SCREEN-VALUE = ""
               FILL-IN-5:SCREEN-VALUE = ""
               FILL-IN_Voucher5:SENSITIVE = FALSE 
               FILL-IN_CodBco5:SENSITIVE = FALSE. */

/*    /* CREDITO AL PERSONAL */
 *     IF FILL-IN_ImpNac7 <> 0 OR FILL-IN_ImpUsa7 <> 0 THEN
 *         ASSIGN FILL-IN_Voucher7:SENSITIVE = TRUE.
 *     ELSE
 *         ASSIGN FILL-IN_Voucher7:SCREEN-VALUE = "" 
 *                FILL-IN_Voucher4:SENSITIVE = FALSE.*/

END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


