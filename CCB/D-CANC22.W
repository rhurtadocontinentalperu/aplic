&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral          PROGRESS
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
DEF INPUT PARAMETER s-ImpNac AS DEC.
DEF INPUT PARAMETER s-ImpUsa AS DEC.
DEF INPUT PARAMETER s-TpoCmb AS DEC.
DEF INPUT  PARAMETER wcodcli AS CHAR.
DEF OUTPUT PARAMETER OK AS LOGICAL.

/* Local Variable Definitions ---                                       */
OK = NO.

DEF SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.
DEF SHARED VAR s-codcia AS INT.
/*
DEF NEW SHARED VAR input-var-1 AS CHAR.
DEF NEW SHARED VAR input-var-2 AS CHAR.
DEF NEW SHARED VAR input-var-3 AS CHAR.
DEF NEW SHARED VAR output-var-1 AS ROWID.
DEF NEW SHARED VAR output-var-2 AS CHAR.
DEF NEW SHARED VAR output-var-3 AS CHAR.
*/

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
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-5 RECT-6 RECT-7 RECT-8 ~
FILL-IN_ImpNac1 FILL-IN_ImpUsa1 FILL-IN_ImpNac2 FILL-IN_ImpUsa2 ~
FILL-IN_Voucher2 FILL-IN_CodBco2 FILL-IN_FchVto2 FILL-IN_ImpNac3 ~
FILL-IN_ImpUsa3 FILL-IN_Voucher3 FILL-IN_CodBco3 FILL-IN_FchVto3 ~
FILL-IN_ImpNac4 FILL-IN_ImpUsa4 FILL-IN_Voucher4 FILL-IN_CodBco4 ~
FILL-IN_ImpNac5 FILL-IN_ImpUsa5 FILL-IN_Voucher5 FILL-IN_Codcta5 ~
FILL-IN_VueNac FILL-IN_VueUsa Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS X-TotNac X-TotUsa FILL-IN_TpoCmb ~
FILL-IN_ImpNac1 FILL-IN_ImpUsa1 FILL-IN_ImpNac2 FILL-IN_ImpUsa2 ~
FILL-IN_Voucher2 FILL-IN_CodBco2 FILL-IN-2 FILL-IN_FchVto2 FILL-IN_ImpNac3 ~
FILL-IN_ImpUsa3 FILL-IN_Voucher3 FILL-IN_CodBco3 FILL-IN-3 FILL-IN_FchVto3 ~
FILL-IN_ImpNac4 FILL-IN_ImpUsa4 FILL-IN_Voucher4 FILL-IN_CodBco4 FILL-IN-4 ~
FILL-IN_ImpNac5 FILL-IN_ImpUsa5 FILL-IN_Voucher5 FILL-IN_Codcta5 FILL-IN-5 ~
FILL-IN_Saldo FILL-IN_VueNac FILL-IN_VueUsa 

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

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81 NO-UNDO.

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

DEFINE VARIABLE FILL-IN_FchVto2 AS DATE FORMAT "99/99/9999" INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81.

DEFINE VARIABLE FILL-IN_FchVto3 AS DATE FORMAT "99/99/9999" INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81.

DEFINE VARIABLE FILL-IN_ImpNac1 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81.

DEFINE VARIABLE FILL-IN_ImpNac2 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81.

DEFINE VARIABLE FILL-IN_ImpNac3 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81.

DEFINE VARIABLE FILL-IN_ImpNac4 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81.

DEFINE VARIABLE FILL-IN_ImpNac5 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81.

DEFINE VARIABLE FILL-IN_ImpUsa1 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81.

DEFINE VARIABLE FILL-IN_ImpUsa2 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81.

DEFINE VARIABLE FILL-IN_ImpUsa3 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81.

DEFINE VARIABLE FILL-IN_ImpUsa4 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81.

DEFINE VARIABLE FILL-IN_ImpUsa5 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .81.

DEFINE VARIABLE FILL-IN_Saldo AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .81
     BGCOLOR 7  NO-UNDO.

DEFINE VARIABLE FILL-IN_TpoCmb AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Tipo de cambio" 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .81
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

DEFINE VARIABLE FILL-IN_VueNac AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81.

DEFINE VARIABLE FILL-IN_VueUsa AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81.

DEFINE VARIABLE X-TotNac AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE X-TotUsa AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 16.57 BY 6.35.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY 4.23.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY .96.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 10.57 BY 6.35.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 10.57 BY 6.35.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      CcbCCaja SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     X-TotNac AT ROW 1.38 COL 13.57 COLON-ALIGNED NO-LABEL
     X-TotUsa AT ROW 1.38 COL 24.57 COLON-ALIGNED NO-LABEL
     FILL-IN_TpoCmb AT ROW 1.38 COL 54 COLON-ALIGNED
     FILL-IN_ImpNac1 AT ROW 3.69 COL 13.57 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpUsa1 AT ROW 3.69 COL 24.57 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpNac2 AT ROW 4.46 COL 13.57 COLON-ALIGNED NO-LABEL
     FILL-IN_ImpUsa2 AT ROW 4.5 COL 24.57 COLON-ALIGNED NO-LABEL
     FILL-IN_Voucher2 AT ROW 4.46 COL 34.57 COLON-ALIGNED NO-LABEL
     FILL-IN_CodBco2 AT ROW 4.46 COL 51 COLON-ALIGNED NO-LABEL
     FILL-IN-2 AT ROW 4.46 COL 56 COLON-ALIGNED NO-LABEL
     FILL-IN_FchVto2 AT ROW 4.46 COL 71 COLON-ALIGNED NO-LABEL
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
     FILL-IN_VueNac AT ROW 7.92 COL 13.57 COLON-ALIGNED NO-LABEL
     FILL-IN_VueUsa AT ROW 7.92 COL 24.57 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 9.27 COL 5
     Btn_Cancel AT ROW 9.27 COL 20
     RECT-10 AT ROW 2.54 COL 36.14
     RECT-5 AT ROW 3.5 COL 1
     RECT-6 AT ROW 2.54 COL 1
     RECT-7 AT ROW 2.54 COL 15
     RECT-8 AT ROW 2.54 COL 25.57
     "Efectivo" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.88 COL 2
     "Tarjeta de credito" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 6.19 COL 2
     "Vuelto" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 8.12 COL 2
     "En S/." VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 2.73 COL 18
     "En US$" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 2.77 COL 27.72
     "Numero de referencia" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 2.81 COL 37.14
     "Vencimiento" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 2.69 COL 73.43
     "Cheque diferido" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 5.42 COL 2
     "Deposito al banco" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 6.96 COL 2
     "Banco/Cuenta" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 2.77 COL 53.14
     "Cheque del dia" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 4.65 COL 2
     SPACE(77.71) SKIP(5.72)
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

/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Saldo IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_TpoCmb IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN X-TotNac IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN X-TotUsa IN FRAME D-Dialog
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
    FILL-IN_FchVto2 FILL-IN_FchVto3 FILL-IN_ImpNac1 FILL-IN_ImpNac2 
    FILL-IN_ImpNac3 FILL-IN_ImpNac4 FILL-IN_ImpNac5 FILL-IN_ImpUsa1 
    FILL-IN_ImpUsa2 FILL-IN_ImpUsa3 FILL-IN_ImpUsa4 FILL-IN_ImpUsa5 
    FILL-IN_TpoCmb FILL-IN_Voucher2 FILL-IN_Voucher3 FILL-IN_Voucher4 
    FILL-IN_Voucher5 FILL-IN_VueNac FILL-IN_VueUsa.
    
  DEFINE VAR x-vuenac AS DECIMAL NO-UNDO.
  x-vuenac = (FILL-IN_ImpNac1 + FILL-IN_ImpNac2 + FILL-IN_ImpNac3 + FILL-IN_ImpNac4 + FILL-IN_ImpNac5) +
             ((FILL-IN_ImpUsa1 + FILL-IN_ImpUsa2 + FILL-IN_ImpUsa3 + FILL-IN_ImpUsa4 + FILL-IN_ImpUsa5) * FILL-IN_TpoCmb) - 
             (FILL-IN_VueNac + FILL-IN_VueUsa * FILL-IN_TpoCmb).
     
/*IF FILL-IN_VueNac < 0 OR FILL-IN_VueUsa < 0*/

  IF ABS(s-impnac - x-vuenac) > .03
  THEN DO:
    MESSAGE "El pago no cubre el monto adeudado" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
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
    T-CcbCCaja.ImpUsa[1] = FILL-IN_ImpUsa1
    T-CcbCCaja.ImpUsa[2] = FILL-IN_ImpUsa2
    T-CcbCCaja.ImpUsa[3] = FILL-IN_ImpUsa3
    T-CcbCCaja.ImpUsa[4] = FILL-IN_ImpUsa4
    T-CcbCCaja.ImpUsa[5] = FILL-IN_ImpUsa5
    T-CcbCCaja.TpoCmb    = FILL-IN_TpoCmb
    T-CcbCCaja.Voucher[2]= FILL-IN_Voucher2
    T-CcbCCaja.Voucher[3]= FILL-IN_Voucher3
    T-CcbCCaja.Voucher[4]= FILL-IN_Voucher4
    T-CcbCCaja.VueNac    = FILL-IN_VueNac
    T-CcbCCaja.VueUsa    = FILL-IN_VueUsa.

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


&Scoped-define SELF-NAME FILL-IN_Voucher5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher5 D-Dialog
ON LEAVE OF FILL-IN_Voucher5 IN FRAME D-Dialog
DO:
     IF SELF:SCREEN-VALUE = "" THEN RETURN.
  ASSIGN FILL-IN_Voucher5.

   FIND ccbboldep WHERE ccbboldep.CodCia = S-CodCia 
                  AND  ccbboldep.CodDoc = "BD" 
                  AND  ccbboldep.CodCli = wcodcli
                  AND  ccbboldep.nrodoc = FILL-IN_Voucher5
                  NO-LOCK NO-ERROR.
                  
   IF AVAILABLE ccbboldep THEN DO:
        IF CcbBolDep.FlgEst = "C" THEN DO:
            MESSAGE " Boleta Deposito Nro. " ccbboldep.nrodoc SKIP
                    "        esta Cancelado  " VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
        IF CcbBolDep.CodMon = 1 THEN DO:
           ASSIGN FILL-IN_ImpNac5 = CcbBolDep.SdoAct
                  FILL-IN_ImpUsa5:SENSITIVE = FALSE.
        END.
        ELSE DO:
           ASSIGN FILL-IN_ImpUsa5 = CcbBolDep.SdoAct
                  FILL-IN_ImpNac5:SENSITIVE = FALSE. 
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
    RETURN NO-APPLY.
   END.
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
        FILL-IN_ImpNac4 FILL-IN_ImpNac5 FILL-IN_ImpUsa1 
        FILL-IN_ImpUsa2 FILL-IN_ImpUsa3 FILL-IN_ImpUsa4 
        FILL-IN_ImpUsa5 FILL-IN_TpoCmb.
    FILL-IN_VueNac = (FILL-IN_ImpNac1 + FILL-IN_ImpNac2 + 
                        FILL-IN_ImpNac3 + FILL-IN_ImpNac4 +
                        FILL-IN_ImpNac5) +
                    (FILL-IN_ImpUsa1 + FILL-IN_ImpUsa2 + 
                        FILL-IN_ImpUsa3 + FILL-IN_ImpUsa4 +
                        FILL-IN_ImpUsa5) * FILL-IN_TpoCmb -
                    s-ImpNac.
    FILL-IN_VueUsa = (FILL-IN_ImpUsa1 + FILL-IN_ImpUsa2 + 
                        FILL-IN_ImpUsa3 + FILL-IN_ImpUsa4 +
                        FILL-IN_ImpUsa5) +
                    (FILL-IN_ImpNac1 + FILL-IN_ImpNac2 + +
                        FILL-IN_ImpNac3 + FILL-IN_ImpNac4 +
                        FILL-IN_impNac5) / FILL-IN_TpoCmb - 
                    s-ImpUsa.
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
  DISPLAY X-TotNac X-TotUsa FILL-IN_TpoCmb FILL-IN_ImpNac1 FILL-IN_ImpUsa1 
          FILL-IN_ImpNac2 FILL-IN_ImpUsa2 FILL-IN_Voucher2 FILL-IN_CodBco2 
          FILL-IN-2 FILL-IN_FchVto2 FILL-IN_ImpNac3 FILL-IN_ImpUsa3 
          FILL-IN_Voucher3 FILL-IN_CodBco3 FILL-IN-3 FILL-IN_FchVto3 
          FILL-IN_ImpNac4 FILL-IN_ImpUsa4 FILL-IN_Voucher4 FILL-IN_CodBco4 
          FILL-IN-4 FILL-IN_ImpNac5 FILL-IN_ImpUsa5 FILL-IN_Voucher5 
          FILL-IN_Codcta5 FILL-IN-5 FILL-IN_Saldo FILL-IN_VueNac FILL-IN_VueUsa 
      WITH FRAME D-Dialog.
  ENABLE RECT-10 RECT-5 RECT-6 RECT-7 RECT-8 FILL-IN_ImpNac1 FILL-IN_ImpUsa1 
         FILL-IN_ImpNac2 FILL-IN_ImpUsa2 FILL-IN_Voucher2 FILL-IN_CodBco2 
         FILL-IN_FchVto2 FILL-IN_ImpNac3 FILL-IN_ImpUsa3 FILL-IN_Voucher3 
         FILL-IN_CodBco3 FILL-IN_FchVto3 FILL-IN_ImpNac4 FILL-IN_ImpUsa4 
         FILL-IN_Voucher4 FILL-IN_CodBco4 FILL-IN_ImpNac5 FILL-IN_ImpUsa5 
         FILL-IN_Voucher5 FILL-IN_Codcta5 FILL-IN_VueNac FILL-IN_VueUsa Btn_OK 
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
  DO WITH FRAME D-Dialog:
    ASSIGN
        X-TotNac:SCREEN-VALUE = STRING(s-ImpNac)
        X-TotUsa:SCREEN-VALUE = STRING(s-ImpUsa)
        FILL-IN_FchVto2:SCREEN-VALUE = STRING(TODAY)
        FILL-IN_TpoCmb:SCREEN-VALUE = STRING(s-TpoCmb).
        
        ASSIGN FILL-IN_Voucher2:SENSITIVE = FALSE 
               FILL-IN_CodBco2:SENSITIVE = FALSE 
               FILL-IN_FchVto2:SENSITIVE = FALSE
               FILL-IN_Voucher3:SENSITIVE = FALSE 
               FILL-IN_CodBco3:SENSITIVE = FALSE
               FILL-IN_FchVto3:SENSITIVE = FALSE
               FILL-IN_Voucher4:SENSITIVE = FALSE 
               FILL-IN_CodBco4:SENSITIVE = FALSE.
            /* FILL-IN_Voucher5:SENSITIVE = FALSE 
               FILL-IN_CodBco5:SENSITIVE = FALSE. */        
               
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
        WHEN "FILL-IN_Voucher5" THEN ASSIGN input-var-1 = wcodcli input-var-2 = "P" input-var-3 = "Autorizada".
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
               FILL-IN_FchVto2:SENSITIVE = TRUE.
    ELSE            
        ASSIGN FILL-IN_Voucher2:SCREEN-VALUE = "" 
               FILL-IN_CodBco2:SCREEN-VALUE = "" 
               FILL-IN_FchVto2:SCREEN-VALUE = ?
               FILL-IN-2:SCREEN-VALUE = ""
               FILL-IN_Voucher2:SENSITIVE = FALSE 
               FILL-IN_CodBco2:SENSITIVE = FALSE 
               FILL-IN_FchVto2:SENSITIVE = FALSE.
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
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


