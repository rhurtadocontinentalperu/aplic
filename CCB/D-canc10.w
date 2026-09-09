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
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-32 RECT-4 RECT-5 RECT-6 RECT-7 ~
RECT-8 RECT-9 R-Codmon FILL-IN_ImpNac1 FILL-IN_ImpNac2 FILL-IN_ImpNac4 ~
FILL-IN_ImpNac5 FILL-IN_ImpNac6 FILL-IN_VueNac FILL-IN_ImpUsa1 ~
FILL-IN_ImpUsa2 FILL-IN_ImpUsa4 FILL-IN_ImpUsa5 FILL-IN_ImpUsa6 ~
FILL-IN_VueUsa FILL-IN_Voucher2 C-tipdoc FILL-IN_Voucher5 FILL-IN_Voucher6 ~
FILL-IN_Voucher4 FILL-IN_CodBco2 F-Presen Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS X-CodMon X-SdoAct y-CodMon y-SdoAct ~
R-Codmon F-cliente FILL-IN_ImpNac1 FILL-IN_ImpNac2 FILL-IN_ImpNac4 ~
FILL-IN_ImpNac5 FILL-IN_ImpNac6 FILL-IN_VueNac FILL-IN_ImpUsa1 ~
FILL-IN_ImpUsa2 FILL-IN_ImpUsa4 FILL-IN_ImpUsa5 FILL-IN_ImpUsa6 ~
FILL-IN_VueUsa FILL-IN_Voucher2 C-tipdoc FILL-IN_Voucher5 FILL-IN_Voucher6 ~
FILL-IN_Voucher4 FILL-IN_TpoCmb FILL-IN_CodBco2 FILL-IN_CodBco4 ~
FILL-IN_CodBco5 FILL-IN-3 FILL-IN-4 FILL-IN-5 F-NroRec F-Presen ~
FILL-IN_Saldo F-TipCom F-Numfac 

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
     SIZE 12 BY 1.42
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.46
     BGCOLOR 8 .

DEFINE VARIABLE C-tipdoc AS CHARACTER FORMAT "X(256)":U INITIAL "BOL" 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "FAC","BOL" 
     SIZE 7.29 BY 1 NO-UNDO.

DEFINE VARIABLE F-cliente AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 69.29 BY .81
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
     SIZE 17 BY .69 NO-UNDO.

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

DEFINE VARIABLE FILL-IN_Saldo AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .69
     BGCOLOR 7  NO-UNDO.

DEFINE VARIABLE FILL-IN_TpoCmb AS DECIMAL FORMAT "->>,>>9.999" INITIAL 0 
     LABEL "Tipo de cambio" 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .69
     BGCOLOR 15 FGCOLOR 9 .

DEFINE VARIABLE FILL-IN_Voucher2 AS CHARACTER FORMAT "x(8)" 
     VIEW-AS FILL-IN 
     SIZE 15.72 BY .69.

DEFINE VARIABLE FILL-IN_Voucher4 AS CHARACTER FORMAT "xxx-xxxxxx" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .69.

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
     SIZE 18.14 BY 6.58.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.86 BY 1.62.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.86 BY 1.38.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.86 BY 1.54.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.86 BY .96.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 12 BY 6.58.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 12 BY 6.54.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 6.29 BY 6.58.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      CcbCCaja SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     X-CodMon AT ROW 3 COL 11 COLON-ALIGNED
     X-SdoAct AT ROW 3 COL 16 COLON-ALIGNED NO-LABEL
     y-CodMon AT ROW 3 COL 27 COLON-ALIGNED NO-LABEL
     y-SdoAct AT ROW 3 COL 32 COLON-ALIGNED NO-LABEL
     R-Codmon AT ROW 9.69 COL 8.72 NO-LABEL
     F-cliente AT ROW 1.38 COL 11 COLON-ALIGNED
     FILL-IN_ImpNac1 AT ROW 5.35 COL 14 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac2 AT ROW 6.12 COL 14 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac4 AT ROW 6.88 COL 14 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac5 AT ROW 7.73 COL 14 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac6 AT ROW 8.58 COL 14 COLON-ALIGNED NO-LABEL
     FILL-IN_VueNac AT ROW 9.77 COL 14 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpUsa1 AT ROW 5.35 COL 26 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpUsa2 AT ROW 6.12 COL 28 NO-LABEL
     FILL-IN_ImpUsa4 AT ROW 6.88 COL 26 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpUsa5 AT ROW 7.73 COL 26 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpUsa6 AT ROW 8.58 COL 26 COLON-ALIGNED NO-LABEL
     FILL-IN_VueUsa AT ROW 9.77 COL 26 COLON-ALIGNED NO-LABEL
     FILL-IN_Voucher2 AT ROW 6.12 COL 37.57 COLON-ALIGNED NO-LABEL
     C-tipdoc AT ROW 6.88 COL 37.57 COLON-ALIGNED
     FILL-IN_Voucher5 AT ROW 7.73 COL 37.57 COLON-ALIGNED NO-LABEL
     FILL-IN_Voucher6 AT ROW 8.58 COL 37.57 COLON-ALIGNED NO-LABEL
     FILL-IN_Voucher4 AT ROW 6.88 COL 45 COLON-ALIGNED NO-LABEL
     FILL-IN_TpoCmb AT ROW 3 COL 55.43 COLON-ALIGNED
     FILL-IN_CodBco2 AT ROW 6.12 COL 55.29 COLON-ALIGNED NO-LABEL
     FILL-IN_CodBco4 AT ROW 6.88 COL 55.29 COLON-ALIGNED NO-LABEL
     FILL-IN_CodBco5 AT ROW 7.73 COL 55.29 COLON-ALIGNED NO-LABEL
     FILL-IN-3 AT ROW 6.12 COL 61.72 COLON-ALIGNED NO-LABEL
     FILL-IN-4 AT ROW 6.88 COL 61.72 COLON-ALIGNED NO-LABEL
     FILL-IN-5 AT ROW 7.73 COL 61.72 COLON-ALIGNED NO-LABEL
     F-NroRec AT ROW 3 COL 74.86 COLON-ALIGNED
     F-Presen AT ROW 6.12 COL 78.29 COLON-ALIGNED NO-LABEL
     FILL-IN_Saldo AT ROW 7.73 COL 78.29 COLON-ALIGNED NO-LABEL
     F-TipCom AT ROW 11.08 COL 74.14 COLON-ALIGNED
     F-Numfac AT ROW 11.85 COL 74.14 COLON-ALIGNED
     Btn_OK AT ROW 11 COL 2
     Btn_Cancel AT ROW 11 COL 14.14
     RECT-10 AT ROW 4.19 COL 39
     RECT-32 AT ROW 1 COL 1
     RECT-4 AT ROW 9.46 COL 1
     RECT-5 AT ROW 2.65 COL 1
     RECT-6 AT ROW 4.19 COL 1
     RECT-7 AT ROW 4.19 COL 15
     RECT-8 AT ROW 4.19 COL 27
     RECT-9 AT ROW 4.19 COL 57
     "Cheque" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 6.31 COL 2
     "Boleta Deposito" VIEW-AS TEXT
          SIZE 13 BY .65 AT ROW 7.81 COL 2
     "Correccion" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 7.08 COL 2
     "Numero Documento" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 4.5 COL 39.86
     "En S/." VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 4.5 COL 18
     "Efectivo" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 5.54 COL 2
     "Nota de Credito" VIEW-AS TEXT
          SIZE 11.86 BY .65 AT ROW 8.65 COL 2
     "F.Presen" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 4.5 COL 81.86
     "Nro. Cta. Cte./Referencia" VIEW-AS TEXT
          SIZE 17.29 BY .5 AT ROW 4.5 COL 64
     "En US$" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 4.5 COL 29
     "Vuelto" VIEW-AS TEXT
          SIZE 6.14 BY .5 AT ROW 9.96 COL 1.86
     "Banco" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 4.5 COL 57.43
     SPACE(29.13) SKIP(7.84)
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
   Custom                                                               */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-cliente IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NroRec IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Numfac IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TipCom IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-4:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodBco4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN_CodBco4:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_CodBco5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpUsa2 IN FRAME D-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN_Saldo IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_TpoCmb IN FRAME D-Dialog
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
  
  IF FILL-IN_VueNac  <> DECI(FILL-IN_VueNac:SCREEN-VALUE)  OR 
     FILL-IN_VueUsa  <> DECI(FILL-IN_VueUsa:SCREEN-VALUE)  OR 
     FILL-IN_ImpNac1 <> DECI(FILL-IN_ImpNac1:SCREEN-VALUE) OR
     FILL-IN_ImpNac2 <> DECI(FILL-IN_ImpNac2:SCREEN-VALUE) OR
     FILL-IN_ImpNac4 <> DECI(FILL-IN_ImpNac4:SCREEN-VALUE) OR
     FILL-IN_ImpNac5 <> DECI(FILL-IN_ImpNac5:SCREEN-VALUE) OR
     FILL-IN_ImpNac6 <> DECI(FILL-IN_ImpNac6:SCREEN-VALUE) OR
     FILL-IN_ImpUsa1 <> DECI(FILL-IN_ImpUsa1:SCREEN-VALUE) OR
     FILL-IN_ImpUsa2 <> DECI(FILL-IN_ImpUsa2:SCREEN-VALUE) OR
     FILL-IN_ImpUsa4 <> DECI(FILL-IN_ImpUsa4:SCREEN-VALUE) OR
     FILL-IN_ImpUsa5 <> DECI(FILL-IN_ImpUsa5:SCREEN-VALUE) OR
     FILL-IN_ImpUsa6 <> DECI(FILL-IN_ImpUsa6:SCREEN-VALUE)  
    THEN DO:
    MESSAGE "Operacion Cancelada , Debe hacer Click sobre el Boton Aceptar" VIEW-AS ALERT-BOX ERROR.
    
    DO WITH FRAME {&FRAME-NAME}:
     DISPLAY FILL-IN_VueNac.  
     DISPLAY FILL-IN_VueUsa. 
    END.
    RETURN NO-APPLY.
  END.  
  IF (DECI(FILL-IN_VueUsa:SCREEN-VALUE) * FILL-IN_TpoCmb )  + DECI(FILL-IN_VueNac:SCREEN-VALUE) 
     > (DECI(FILL-IN_ImpUsa4:SCREEN-VALUE) * FILL-IN_TpoCmb ) + DECI(FILL-IN_ImpNac4:SCREEN-VALUE)  +
       (DECI(FILL-IN_ImpUsa1:SCREEN-VALUE) *  FILL-IN_TpoCmb ) + DECI(FILL-IN_ImpNac1:SCREEN-VALUE)  THEN DO:
    MESSAGE "El Vuelto no puede ser Mayor que el Efectivo recibido ..." VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.

  
  
  DEFINE VAR lok AS LOGICAL NO-UNDO.
  DEFINE VAR x-coddoc AS CHAR INIT "".
  ASSIGN
    FILL-IN_CodBco2 FILL-IN_CodBco4 FILL-IN_ImpNac1 FILL-IN_ImpNac2 FILL-IN_ImpNac5
    FILL-IN_ImpNac5 FILL-IN_ImpUsa1 FILL-IN_ImpUsa2 FILL-IN_ImpUsa4 FILL-IN_ImpUsa5
    FILL-IN_TpoCmb FILL-IN_Voucher2 FILL-IN_Voucher4 FILL-IN_VueNac FILL-IN_VueUsa
    FILL-IN_ImpNac6 FILL-IN_ImpUsa6 FILL-IN_Voucher6 F-Presen R-Codmon
    x-SdoAct c-tipdoc.
    fSumSol = FILL-IN_ImpNac1.
    fSumDol = FILL-IN_ImpUsa1.
    IF FILL-IN_Voucher4 <> "" AND
       (FILL-IN_ImpNac4 + FILL-IN_ImpUsa4) > 0 THEN DO:
        x-coddoc = c-tipdoc .
        
    END. 
  /*  
  IF Moneda = 1 THEN DO:   
     IF (fSumSol + ROUND(fSumDol * FILL-IN_TpoCmb, 2)) - x-SdoAct >= 0 /* .03 */
        THEN lok = FALSE.
     ELSE lok = TRUE.
  END.
  ELSE DO:
     IF (fSumDol + ROUND ( fSumSol / FILL-IN_TpoCmb,2 )) - x-SdoAct >= 0 /* .03 */
        THEN lok = FALSE.
     ELSE lok = TRUE.
  END.
  
  IF lok  THEN DO:
    MESSAGE "El pago no cubre el monto adeudado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  */

  /**** Add by C.Q. 15/04/2000  ****/
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
    T-CcbCCaja.ImpUsa[1] = FILL-IN_ImpUsa1 
    T-CcbCCaja.ImpUsa[4] = FILL-IN_ImpUsa4
    T-CcbCCaja.ImpUsa[5] = FILL-IN_ImpUsa5
    T-CcbCCaja.ImpUsa[6] = FILL-IN_ImpUsa6
    T-CcbCCaja.TpoCmb    = FILL-IN_TpoCmb 
    T-CcbCCaja.Voucher[4]= x-coddoc + FILL-IN_Voucher4 
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
            T-CcbCCaja.FchVto[2] = F-Presen.
        ELSE ASSIGN
            T-CcbCCaja.CodBco[3] = FILL-IN_CodBco2 
            T-CcbCCaja.ImpNac[3] = FILL-IN_ImpNac2
            T-CcbCCaja.ImpUsa[3] = FILL-IN_ImpUsa2
            T-CcbCCaja.Voucher[3]= FILL-IN_Voucher2
            T-CcbCCaja.FchVto[3] = F-Presen.
    END.        
    
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
              CcbBolDep.SdoAct = CcbBolDep.SdoAct - (FILL-IN_ImpNac5 + (FILL-IN_ImpUsa5 * FILL-IN_TpoCmb)).
          ELSE
              ASSIGN
              CcbBolDep.SdoAct = CcbBolDep.SdoAct - (FILL-IN_ImpUsa5 + (FILL-IN_ImpNac5 / FILL-IN_TpoCmb)).
          IF CcbBolDep.SdoAct <= 0 THEN CcbBolDep.FlgEst = "C".
        END.
        RELEASE ccbboldep.
    END.
    IF FILL-IN_Voucher4 <> "" AND
       (FILL-IN_ImpNac4 + FILL-IN_ImpUsa4) > 0 THEN DO:
        FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
                            CcbCDocu.CodDoc = c-tipdoc AND 
                            CcbCDocu.NroDoc = FILL-IN_Voucher4 EXCLUSIVE-LOCK NO-ERROR.
        
        IF AVAIL ccbcdocu THEN DO:
          FIND Faccpedm WHERE 
                 Faccpedm.CodCia = ccbcdocu.codcia AND
                 Faccpedm.CodDiv = ccbcdocu.codDiv AND
                 Faccpedm.CodDoc = ccbcdocu.codPed AND
                 Faccpedm.NroPed = ccbcdocu.NroPed EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE Faccpedm THEN Faccpedm.FlgEst = "A".
            RELEASE Faccpedm.
            RUN VTA/DES_ALM.p(ROWID(ccbcdocu)).
            FOR EACH ccbDdocu OF ccbcdocu:
                DELETE ccbDdocu.
            END.
            ASSIGN ccbcdocu.sdoact = 0
                   ccbcdocu.flgest = "A"
                   CcbCDocu.FchAnu = TODAY
                   CcbCDocu.UsuAnu = S-USER-ID
                   ccbcdocu.codPed = ""
                   ccbcdocu.NroPed = "".
        END.         
    END.

  OK = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Presen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Presen D-Dialog
ON LEAVE OF F-Presen IN FRAME D-Dialog
DO:
  ASSIGN F-Presen.

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
  THEN FILL-IN-3:SCREEN-VALUE = cb-tabl.Nombre.
  ELSE FILL-IN-3:SCREEN-VALUE = "".
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco5 D-Dialog
ON LEAVE OF FILL-IN_CodBco5 IN FRAME D-Dialog
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodBco5 D-Dialog
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_CodBco5 IN FRAME D-Dialog
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpNac4 D-Dialog
ON LEAVE OF FILL-IN_ImpNac4 IN FRAME D-Dialog
DO:
    ASSIGN FILL-IN_ImpNac4.
    IF FILL-IN_ImpNac4 <> X-Correc THEN DO:
       MESSAGE " Este monto no corresponde " SKIP
               "   con el importe del Documento " VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.   

    
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
       RETURN NO-APPLY.
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_ImpUsa4 D-Dialog
ON LEAVE OF FILL-IN_ImpUsa4 IN FRAME D-Dialog
DO:
    ASSIGN FILL-IN_ImpUsa4.
   IF FILL-IN_ImpUsa4 <> X-Correc THEN DO:
       MESSAGE " Este monto no corresponde " SKIP
               "   con el importe del Documento " VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.   

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
      RETURN NO-APPLY.
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


&Scoped-define SELF-NAME FILL-IN_Voucher4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher4 D-Dialog
ON LEAVE OF FILL-IN_Voucher4 IN FRAME D-Dialog
DO:
   ASSIGN
     c-tipdoc FILL-IN_Voucher4.
     
     IF FILL-IN_Voucher4 <> ' ' THEN DO:
     FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
          CcbCDocu.CodDoc = c-tipdoc AND CcbCDocu.NroDoc = FILL-IN_Voucher4 NO-LOCK NO-ERROR.
     IF NOT AVAILABLE CcbCDocu THEN DO:
        MESSAGE ' Documento no existe ' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.
     /*     
     IF CcbCDocu.Codcli <> wcodcli THEN DO:
        MESSAGE 'Documento no corresponde al cliente' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.
     */
     IF CcbCDocu.FlgEst = 'A' THEN DO:
        MESSAGE 'Documento se encuentra Anulado ' 
                VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.
     
     IF CcbCDocu.Fmapgo <> '000' THEN DO:
        MESSAGE 'Forma de Pago del documento no es valido ' SKIP
                'La aplicacion es para docuemntos al Contado' 
                VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.


     IF CcbCDocu.FchDoc <> TODAY THEN DO:
        MESSAGE 'Documento no es del dia ' 
                VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.
     
     
     FIND Ccbdcaja WHERE Ccbdcaja.Codcia = S-CODCIA AND
                         Ccbdcaja.CodRef = C-tipdoc AND
                         Ccbdcaja.Nroref = FILL-IN_Voucher4 NO-LOCK NO-ERROR.
     IF AVAILABLE Ccbdcaja THEN DO:
        FIND FIRST CcbCcaja OF Ccbdcaja NO-LOCK NO-ERROR.
        
        IF CcbCcaja.Flgcie = "C" THEN DO:
            MESSAGE 'Recibo del Documento esta cerrado ' 
                    VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        
        IF CcbCcaja.Usuario <> s-user-id THEN DO:
            MESSAGE 'Documento no fue emitido por el cajero ' SKIP
                    'Cajero Autorizado ' + CcbCcaja.Usuario 
                     VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        
        IF CcbCcaja.ImpNac[2] + CcbCcaja.ImpUsa[2] + CcbCcaja.ImpNac[3] + CcbCcaja.ImpUsa[3] > 0 THEN DO:
            MESSAGE 'Por el momento solo se puede aplicar documentos que fueron cancelados ' SKIP
                    'en Efectivo . El documento presenta Pagos en Cheque ' SKIP
                    'Se recomienda Anular el Ingreso en forma Total '  
                     VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.

        IF CcbCcaja.ImpNac[5] + CcbCcaja.ImpUsa[5]  > 0 THEN DO:
            MESSAGE 'Por el momento solo se puede aplicar documentos que fueron cancelados ' SKIP
                    'en Efectivo . El documento presenta Pagos con Boleta de Deposito ' SKIP
                    'Se recomienda Anular el Ingreso en forma Total '  
                     VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        
        IF CcbCcaja.ImpNac[6] + CcbCcaja.ImpUsa[6]  > 0 THEN DO:
            MESSAGE 'Por el momento solo se puede aplicar documentos que fueron cancelados ' SKIP
                    'en Efectivo . El documento presenta Pagos con N/C  ' SKIP
                    'Se recomienda Anular el Ingreso en forma Total '  
                     VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        

              
     END.
     
     

     MESSAGE 'Esta opcion anulará el Documento para que pueda utilizar ' SKIP
             'el ingreso respectivo Por Favor Verifique Importe del Documento ' VIEW-AS ALERT-BOX .
 
     IF CcbCDocu.Codmon = 1 THEN
        
        DO WITH FRAME {&FRAME-NAME}:
           DISPLAY CcbCDocu.Imptot @ FILL-IN_ImpNac4.
                      
        END.   
     ELSE
        DO WITH FRAME {&FRAME-NAME}:
           DISPLAY CcbCDocu.Imptot @ FILL-IN_ImpUsa4.
        END.  
     X-Correc  = CcbCDocu.Imptot.      
     FILL-IN_ImpNac4:SENSITIVE = FALSE.
     FILL-IN_ImpUsa4:SENSITIVE = FALSE.
     FILL-IN_Voucher4:SENSITIVE = FALSE.
     c-tipdoc:SENSITIVE = FALSE.

     FILL-IN_ImpUsa1 = 0.
     
     DO WITH FRAME {&FRAME-NAME}:
       DISPLAY FILL-IN_ImpUsa1.
     END.  
     FILL-IN_ImpUsa1:SENSITIVE = FALSE.
 
     RUN Calculo.


  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Voucher5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher5 D-Dialog
ON LEAVE OF FILL-IN_Voucher5 IN FRAME D-Dialog
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


&Scoped-define SELF-NAME FILL-IN_VueNac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_VueNac D-Dialog
ON LEAVE OF FILL-IN_VueNac IN FRAME D-Dialog
DO:
  DEF VAR X-CAL AS DECI INIT 0.
  
  IF DECI(FILL-IN_VueNac:SCREEN-VALUE) =  FILL-IN_VueNac THEN RETURN .
  

  IF DECI(FILL-IN_VueNac:SCREEN-VALUE) > FILL-IN_VueNac AND FILL-IN_VueUsa = 0 THEN DO: /*RETURN.*/
       MESSAGE "Operacion Incorrecta, Vuelva a intentar " VIEW-AS ALERT-BOX ERROR.
       DO WITH FRAME {&FRAME-NAME}:
           DISPLAY FILL-IN_VueNac.  
       END.   
       RETURN NO-APPLY.
  END.
  IF DECI(FILL-IN_VueNac:SCREEN-VALUE) < FILL-IN_VueNac AND FILL-IN_ImpUsa1 = 0 THEN DO: /*RETURN.*/
       MESSAGE "Operacion Incorrecta, Vuelva a intentar " VIEW-AS ALERT-BOX ERROR.
       DO WITH FRAME {&FRAME-NAME}:
           DISPLAY FILL-IN_VueNac.  
       END.   
       RETURN NO-APPLY.
  END.
  X-CAL = FILL-IN_VueNac - DECI(FILL-IN_VueNac:SCREEN-VALUE).
  X-CAL = ROUND( X-CAL / FILL-IN_TpoCmb, 2 ).
  X-CAL = X-CAL + DECI(FILL-IN_VueUsa:SCREEN-VALUE).
  
  IF DECI(FILL-IN_ImpUsa1:SCREEN-VALUE) < X-CAL OR X-CAL <0 THEN DO: /*RETURN.*/
       MESSAGE "Operacion Incorrecta, Vuelva a intentar " VIEW-AS ALERT-BOX ERROR.
       DO WITH FRAME {&FRAME-NAME}:
           DISPLAY FILL-IN_VueNac.  
       END.   
       RETURN NO-APPLY.
  END.
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN FILL-IN_VueNac 
            FILL-IN_VueUsa = X-CAL.
     DISPLAY FILL-IN_VueNac FILL-IN_VueUsa.  
     
  END.   

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_VueUsa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_VueUsa D-Dialog
ON LEAVE OF FILL-IN_VueUsa IN FRAME D-Dialog
DO:
  DEF VAR X-CAL AS DECI INIT 0.
  
  IF DECI(FILL-IN_VueUsa:SCREEN-VALUE) =  FILL-IN_VueUsa THEN RETURN .
  

  IF DECI(FILL-IN_VueUsa:SCREEN-VALUE) > FILL-IN_ImpUsa1 OR DECI(FILL-IN_VueUsa:SCREEN-VALUE) < 0 THEN DO: /*RETURN.*/
       MESSAGE "Operacion Incorrecta, Vuelva a intentar " VIEW-AS ALERT-BOX ERROR.
       DO WITH FRAME {&FRAME-NAME}:
           DISPLAY FILL-IN_VueUsa.  
       END.   
       RETURN NO-APPLY.
  END.

  X-CAL = FILL-IN_VueUsa - DECI(FILL-IN_VueUsa:SCREEN-VALUE).
  X-CAL = ROUND( X-CAL * FILL-IN_TpoCmb, 2 ).
  X-CAL = X-CAL + DECI(FILL-IN_VueNac:SCREEN-VALUE).
  
  IF  X-CAL < 0 THEN DO: /*RETURN.*/
       MESSAGE "Operacion Incorrecta, Vuelva a intentar " VIEW-AS ALERT-BOX ERROR.
       DO WITH FRAME {&FRAME-NAME}:
           DISPLAY FILL-IN_VueUsa.  
       END.   
       RETURN NO-APPLY.
  END.
  
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN FILL-IN_VueUsa 
            FILL-IN_VueNac = X-CAL.
     DISPLAY FILL-IN_VueNac FILL-IN_VueUsa.  
     
  END.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-Codmon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-Codmon D-Dialog
ON VALUE-CHANGED OF R-Codmon IN FRAME D-Dialog
DO:
  /*
  ASSIGN R-Codmon.
  IF SELF:SCREEN-VALUE = "1" THEN DO:
     FILL-IN_VueNac = fSumSol + ROUND( fSumDol * FILL-IN_TpoCmb, 2 ) - X-SdoNac.
     FILL-IN_VueUsa = 0.
  END.
  ELSE DO :
     FILL-IN_VueUsa = fSumDol + ROUND( fSumSol / FILL-IN_TpoCmb, 2 ) - X-SdoUsa.
     FILL-IN_VueNac = 0.
  END.
  DISPLAY FILL-IN_VueNac FILL-IN_VueUsa WITH FRAME D-Dialog.
 */
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
        FILL-IN_ImpNac1 FILL-IN_ImpNac2 FILL-IN_ImpNac4 FILL-IN_ImpNac5 
        FILL-IN_ImpNac6 
        FILL-IN_ImpUsa1 FILL-IN_ImpUsa2 FILL-IN_ImpUsa4 FILL-IN_ImpUsa5 
        FILL-IN_ImpUsa6 
        FILL-IN_CodBco2  FILL-IN_CodBco4
        FILL-IN_Voucher2 FILL-IN_Voucher4
        FILL-IN_TpoCmb  .
        
   fSumSol = (FILL-IN_ImpNac1 + FILL-IN_ImpNac2 + 
              FILL-IN_ImpNac4 + FILL-IN_ImpNac5 + 
              FILL-IN_ImpNac6 ). 
              
   fSumDol = (FILL-IN_ImpUsa1 + FILL-IN_ImpUsa2 + 
              FILL-IN_ImpUsa4 + FILL-IN_ImpUsa5 + 
              FILL-IN_ImpUsa6 ).
              
   FILL-IN_VueNac = 0.
   FILL-IN_VueUsa = 0.
   IF R-Codmon = 1 THEN
      FILL-IN_VueNac = ROUND(fSumSol + ROUND( fSumDol * FILL-IN_TpoCmb, 2 ) - X-SdoNac, 2).
   IF R-Codmon = 2 THEN
      FILL-IN_VueUsa = ROUND(fSumDol + ROUND( fSumSol / FILL-IN_TpoCmb, 2 ) - X-SdoUsa, 2).

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
  DISPLAY X-CodMon X-SdoAct y-CodMon y-SdoAct R-Codmon F-cliente FILL-IN_ImpNac1 
          FILL-IN_ImpNac2 FILL-IN_ImpNac4 FILL-IN_ImpNac5 FILL-IN_ImpNac6 
          FILL-IN_VueNac FILL-IN_ImpUsa1 FILL-IN_ImpUsa2 FILL-IN_ImpUsa4 
          FILL-IN_ImpUsa5 FILL-IN_ImpUsa6 FILL-IN_VueUsa FILL-IN_Voucher2 
          C-tipdoc FILL-IN_Voucher5 FILL-IN_Voucher6 FILL-IN_Voucher4 
          FILL-IN_TpoCmb FILL-IN_CodBco2 FILL-IN_CodBco4 FILL-IN_CodBco5 
          FILL-IN-3 FILL-IN-4 FILL-IN-5 F-NroRec F-Presen FILL-IN_Saldo F-TipCom 
          F-Numfac 
      WITH FRAME D-Dialog.
  ENABLE RECT-10 RECT-32 RECT-4 RECT-5 RECT-6 RECT-7 RECT-8 RECT-9 R-Codmon 
         FILL-IN_ImpNac1 FILL-IN_ImpNac2 FILL-IN_ImpNac4 FILL-IN_ImpNac5 
         FILL-IN_ImpNac6 FILL-IN_VueNac FILL-IN_ImpUsa1 FILL-IN_ImpUsa2 
         FILL-IN_ImpUsa4 FILL-IN_ImpUsa5 FILL-IN_ImpUsa6 FILL-IN_VueUsa 
         FILL-IN_Voucher2 C-tipdoc FILL-IN_Voucher5 FILL-IN_Voucher6 
         FILL-IN_Voucher4 FILL-IN_CodBco2 F-Presen Btn_OK Btn_Cancel 
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

  FIND FIRST ccbdterm WHERE CcbDTerm.CodCia = s-codcia 
                       AND  CcbDTerm.CodDiv = s-coddiv 
                       AND  CcbDTerm.CodDoc = wtipCom 
                       AND  CcbDTerm.CodTer = s-codter NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ccbdterm
  THEN DO:
      MESSAGE "La factura no esta configurada en este terminal" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.

  s-ptovta = ccbdterm.nroser.
  
  FIND faccorre WHERE faccorre.codcia = s-codcia AND faccorre.CodDiv = s-coddiv AND
       faccorre.coddoc = wtipCom AND faccorre.NroSer = s-ptovta /*EXCLUSIVE-LOCK */ .
  DO WITH FRAME D-Dialog:
     R-Codmon = Moneda.
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
    IF AVAILABLE FacCfgGn THEN DO:    
        ASSIGN
            FILL-IN_TpoCmb:SCREEN-VALUE = STRING(FacCfgGn.Tpocmb[2]).
        IF Moneda = 1
        THEN ASSIGN
                X-SdoNac = Importe
                X-SdoUsa = ROUND(Importe / ROUND(FacCfgGn.Tpocmb[2], 3), 2)
                Y-SdoAct:SCREEN-VALUE = STRING(ROUND(Importe / ROUND(FacCfgGn.Tpocmb[2], 3), 2)).

        ELSE ASSIGN
                X-SdoUsa = Importe
                X-SdoNac = ROUND(Importe * ROUND(FacCfgGn.Tpocmb[2], 3), 2)
                y-SdoAct:SCREEN-VALUE = STRING(ROUND(Importe * ROUND(FacCfgGn.Tpocmb[2], 3), 2)).

    END.
    ELSE DO:
        ASSIGN
            FILL-IN_TpoCmb:SCREEN-VALUE = "".
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
            ASSIGN 
                input-var-1 = wcodcli input-var-2 = "P" input-var-3 = "Autorizada".
        WHEN "FILL-IN_Voucher6" THEN 
            ASSIGN
                input-var-1 = 'N/C'
                input-var-2 = ""
                input-var-3 = "P".

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _habilita D-Dialog 
PROCEDURE _habilita :
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
        APPLY "ENTRY" TO FILL-IN_Voucher2.
        RETURN NO-APPLY.
    END.
    ELSE DO:
        ASSIGN FILL-IN_Voucher2:SCREEN-VALUE = "" 
               FILL-IN_CodBco2:SCREEN-VALUE = "" 
               F-Presen:SCREEN-VALUE = ""
               FILL-IN-3:SCREEN-VALUE = ""
               FILL-IN_Voucher2:SENSITIVE = FALSE 
               FILL-IN_CodBco2:SENSITIVE = FALSE 
               F-Presen:SENSITIVE = FALSE.
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


