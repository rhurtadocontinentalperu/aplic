&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w

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

/* Local Variable Definitions ---                                       */

DEFINE SHARED VAR s-CodCia  AS INTEGER.
DEFINE SHARED VAR s-NomCia  AS CHARACTER.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

/* Definimos Variables de impresoras */

DEFINE VARIABLE s-printer-list AS CHAR NO-UNDO.
DEFINE VARIABLE s-port-list AS CHAR NO-UNDO.
DEFINE VARIABLE s-port-name AS CHAR format "x(20)" NO-UNDO.
DEFINE VARIABLE s-printer-count AS INTEGER NO-UNDO.

DEFINE NEW SHARED VARIABLE s-pagina-final     AS INTEGER.
DEFINE NEW SHARED VARIABLE s-pagina-inicial   AS INTEGER.
DEFINE NEW SHARED VARIABLE s-salida-impresion AS INTEGER.
DEFINE NEW SHARED VARIABLE s-printer-name     AS CHARACTER.
DEFINE NEW SHARED VARIABLE s-print-file       AS CHARACTER.
DEFINE NEW SHARED VARIABLE s-nro-copias       AS INTEGER.
DEFINE NEW SHARED VARIABLE s-orientacion      AS INTEGER.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE L-FIN  AS LOGICAL NO-UNDO.

DEFINE VARIABLE C-FLGEST AS CHAR NO-UNDO.
DEFINE STREAM REPORT.

/* OTRAS VARIABLES */
DEFINE VAR x-DesMes  AS CHAR NO-UNDO.
DEFINE VAR cb-CodCia AS INTEGER INITIAL 0.
DEFINE VAR x-ctaigv  AS CHAR NO-UNDO.
DEFINE VAR x-ctaisc  AS CHAR NO-UNDO.
DEFINE VAR x-cta70   AS CHAR NO-UNDO.

DEFINE TEMP-TABLE t-CDocu LIKE CcbCDocu
.

SESSION:DATE-FORMAT = 'DMY'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-12 C-mes x-Div x-fecha1 Btn_OK ~
F-Periodo x-fecha2 Btn_Cancel RECT-41 C-CodMon 
&Scoped-Define DISPLAYED-OBJECTS F-proceso C-mes x-Div x-fecha1 F-Periodo ~
x-fecha2 C-CodMon 

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
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE C-mes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12" 
     SIZE 6.72 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-Periodo AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .81 NO-UNDO.

DEFINE VARIABLE F-proceso AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-Div AS CHARACTER FORMAT "X(5)":U 
     LABEL "Divisi¢n" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-fecha1 AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-fecha2 AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE C-CodMon AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles", 1,
"D¢lares", 2
     SIZE 9.43 BY 1.19 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 38.14 BY 3.92.

DEFINE RECTANGLE RECT-41
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 12.43 BY 1.81.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     F-proceso AT ROW 5.42 COL 1.86 COLON-ALIGNED NO-LABEL
     C-mes AT ROW 1.62 COL 12.14 COLON-ALIGNED
     x-Div AT ROW 2.73 COL 11.29 COLON-ALIGNED
     x-fecha1 AT ROW 3.85 COL 11.29 COLON-ALIGNED
     Btn_OK AT ROW 6.62 COL 16
     F-Periodo AT ROW 2.73 COL 27.57 COLON-ALIGNED
     x-fecha2 AT ROW 3.85 COL 28 COLON-ALIGNED
     Btn_Cancel AT ROW 6.62 COL 31
     C-CodMon AT ROW 2 COL 45.72 NO-LABEL
     RECT-12 AT ROW 1.31 COL 4.14
     " Moneda" VIEW-AS TEXT
          SIZE 6.14 BY .5 AT ROW 1.35 COL 45.86
     RECT-41 AT ROW 1.62 COL 44.29
     SPACE(2.41) SKIP(5.02)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Registro de Ventas".

 

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
   Default                                                              */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-proceso IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Registro de Ventas */
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
  L-FIN = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN C-CodMon x-Div C-mes F-Periodo x-fecha1 x-fecha2.
  IF C-mes = 0 THEN DO:
     MESSAGE 'El mes no ha sido seleccionado' VIEW-AS ALERT-BOX ERROR.
     APPLY 'ENTRY':U TO C-mes.
     RETURN NO-APPLY.
  END.
  RUN IMPRIMIR.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CAPTURA D-Dialog 
PROCEDURE CAPTURA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VAR i        AS DATE NO-UNDO.
   DEFINE VAR x-nrodo1 AS CHAR NO-UNDO.
   DEFINE VAR x-nrodo2 AS CHAR NO-UNDO.
   DEFINE VAR x-tpocm1 AS DECI NO-UNDO.
   DEFINE VAR x-tpocm2 AS DECI NO-UNDO.
   DEFINE VAR x-codcta AS CHAR NO-UNDO.

   FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia.
L-FIN = NO.
FOR EACH GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA AND
    GN-DIVI.CodDiv BEGINS x-Div AND NOT L-FIN :
/*   FOR EACH FacDocum WHERE FacDocum.CodCia = s-codcia AND 
       LOOKUP(FacDocum.CodDoc,'FAC,BOL,N/C,N/D') > 0 NO-LOCK:*/
       FOR EACH CcbCDocu NO-LOCK WHERE 
           CcbCDocu.codcia = s-codcia AND 
           CcbCDocu.CodDiv BEGINS GN-DIVI.CodDiv AND
           CcbCDocu.Fchdoc >= x-fecha1 AND
           CcbCDocu.Fchdoc <= x-fecha2 AND
           LOOKUP(CcbCDocu.Coddoc,'FAC,BOL,N/C,N/D') > 0 AND NOT L-FIN
           BREAK BY CcbCDocu.codcia
                 BY CcbCDocu.CodDiv 
                 BY CcbCDocu.Fchdoc
                 BY CcbCDocu.Coddoc 
                 BY CcbCDocu.Nrodoc: 
           IF x-Div <> '' THEN DO:
              IF CcbCDocu.coddiv <> x-Div THEN NEXT.
           END.
           F-proceso = 'Procesando : ' + CcbCDocu.CodDiv + '  ' + 
                       STRING(CcbCDocu.Fchdoc, '99/99/9999') + '  ' + 
                       CcbCDocu.Coddoc + '-' + 
                       CcbCDocu.Nrodoc .
           DISPLAY F-proceso WITH FRAME {&FRAME-NAME}.
           
           FIND FacDocum WHERE FacDocum.CodCia = s-codcia AND
                FacDocum.CodDoc = CcbCDocu.Coddoc NO-LOCK NO-ERROR.
           IF AVAILABLE FacDocum THEN
              IF CcbCDocu.codmon = 1 THEN x-codcta = FacDocum.CodCta[1].
              ELSE x-codcta = FacDocum.CodCta[2].
           x-codcta = IF x-codcta = '' THEN FacDocum.CodCta[1] ELSE x-codcta.
           x-tpocm1 = 1.
           x-tpocm2 = 1.
           FIND gn-tcmb WHERE gn-tcmb.fecha = CcbCDocu.Fchdoc NO-LOCK NO-ERROR.
           IF AVAILABLE gn-tcmb THEN 
              ASSIGN
                 x-tpocm2 = gn-tcmb.compra
                 x-tpocm1 = gn-tcmb.venta.
           FIND FacDocum WHERE FacDocum.CodCia = s-codcia AND 
                FacDocum.CodDoc = CcbCDocu.Coddoc NO-LOCK NO-ERROR.
           IF FIRST-OF(CcbCDocu.coddiv) OR FIRST-OF(CcbCDocu.Fchdoc)THEN DO:
              x-nrodo1 = ''.
              x-nrodo2 = ''.
           END.
           IF CcbCDocu.Coddoc =  'BOL' THEN DO:
              x-nrodo1 = IF x-nrodo1 = ' ' THEN CcbCDocu.NroDoc ELSE x-nrodo1.
              x-nrodo2 = CcbCDocu.NroDoc.
              FIND t-CDocu WHERE 
                   t-CDocu.codcia = 0 AND
                   t-CDocu.coddiv = CcbCDocu.coddiv AND
                   t-CDocu.fchdoc = CcbcDocu.fchdoc AND
                   t-CDocu.Coddoc = FacDocum.Codcbd NO-ERROR.
              IF NOT AVAILABLE t-CDocu THEN DO:
                 CREATE t-CDocu.
                 ASSIGN
                    t-CDocu.CodDiv = CcbCDocu.CodDiv
                    t-CDocu.FchDoc = CcbCDocu.FchDoc    
                    t-CDocu.CodDoc = FacDocum.CodCbd
                    t-CDocu.Ruc    = FacCfgGn.CliVar
                    t-CDocu.NomCli = 'CLIENTES VARIOS'
                    t-CDocu.CodMon = C-CodMon.
              END.
              ASSIGN t-CDocu.NroDoc = x-nrodo1 + '-' + x-nrodo2.
              IF CcbCDocu.FlgEst = "A" THEN NEXT.
              CASE C-CodMon:
                 WHEN 1 THEN DO:
                    IF CcbCDocu.Codmon = 1 THEN
                       ASSIGN
                          t-CDocu.ImpVta = t-CDocu.ImpVta + CcbCDocu.ImpVta
                          t-CDocu.ImpExo = t-CDocu.ImpExo + CcbCDocu.ImpExo
                          t-CDocu.ImpIsc = t-CDocu.ImpIsc + CcbCDocu.ImpIsc
                          t-CDocu.ImpBrt = t-CDocu.ImpBrt + (CcbCDocu.ImpBrt - CcbCDocu.ImpDto)
                          t-CDocu.ImpIgv = t-CDocu.ImpIgv + CcbCDocu.ImpIgv
                          t-CDocu.ImpTot = t-CDocu.ImpTot + CcbCDocu.ImpTot.
                    ELSE DO:
                       FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND 
                            cb-ctas.Codcta = x-cta70 NO-LOCK NO-ERROR.
                       IF AVAILABLE cb-ctas THEN
                          IF cb-ctas.Tpocmb = 1 THEN
                             ASSIGN
                                t-CDocu.ImpVta = t-CDocu.ImpVta + (CcbCDocu.ImpVta * x-tpocm2)
                                t-CDocu.ImpExo = t-CDocu.ImpExo + (CcbCDocu.ImpExo * x-tpocm2)
                                t-CDocu.ImpBrt = t-CDocu.ImpBrt + ((CcbCDocu.ImpBrt - CcbCDocu.ImpDto) * x-tpocm2).
                          ELSE
                             ASSIGN                                                  /* x-tpocm2  */
                                t-CDocu.ImpVta = t-CDocu.ImpVta + (CcbCDocu.ImpVta * x-tpocm1)
                                t-CDocu.ImpExo = t-CDocu.ImpExo + (CcbCDocu.ImpExo * x-tpocm1)
                                t-CDocu.ImpBrt = t-CDocu.ImpBrt + ((CcbCDocu.ImpBrt - CcbCDocu.ImpDto) * x-tpocm1).
                                
                       FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND 
                            cb-ctas.Codcta = x-ctaisc NO-LOCK NO-ERROR.
                       IF AVAILABLE cb-ctas THEN
                          IF cb-ctas.Tpocmb = 1 THEN
                             ASSIGN
                                t-CDocu.ImpIsc = t-CDocu.ImpIsc + (CcbCDocu.ImpIsc * x-tpocm1).
                          ELSE
                             ASSIGN
                                t-CDocu.ImpIsc = t-CDocu.ImpIsc + (CcbCDocu.ImpIsc * x-tpocm1).  /* x-tpocm2 */
                                
                       FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND 
                            cb-ctas.Codcta = x-ctaigv NO-LOCK NO-ERROR.
                       IF AVAILABLE cb-ctas THEN
                          IF cb-ctas.Tpocmb = 1 THEN
                             ASSIGN
                                t-CDocu.ImpIgv = t-CDocu.ImpIgv + (CcbCDocu.ImpIgv * x-tpocm1).
                          ELSE
                             ASSIGN
                                t-CDocu.ImpIgv = t-CDocu.ImpIgv + (CcbCDocu.ImpIgv * x-tpocm1).
                       ASSIGN
                          t-CDocu.ImpTot = t-CDocu.ImpExo + t-CDocu.ImpBrt + t-CDocu.ImpIgv.
                          /*MESSAGE t-CDocu.ImpTot t-CDocu.ImpIgv t-CDocu.ImpBrt.*/
                    END.
                 END.
                 WHEN 2 THEN DO:
                    IF CcbCDocu.Codmon = 2 THEN
                       ASSIGN
                          t-CDocu.ImpVta = t-CDocu.ImpVta + CcbCDocu.ImpVta
                          t-CDocu.ImpExo = t-CDocu.ImpExo + CcbCDocu.ImpExo
                          t-CDocu.ImpIsc = t-CDocu.ImpIsc + CcbCDocu.ImpIsc
                          t-CDocu.ImpBrt = t-CDocu.ImpBrt + (CcbCDocu.ImpBrt - CcbCDocu.ImpDto)
                          t-CDocu.ImpIgv = t-CDocu.ImpIgv + CcbCDocu.ImpIgv
                          t-CDocu.ImpTot = t-CDocu.ImpTot + CcbCDocu.ImpTot.
                    ELSE 
                       ASSIGN
                          t-CDocu.ImpVta = t-CDocu.ImpVta + (CcbCDocu.ImpVta / CcbCDocu.TpoCmb)
                          t-CDocu.ImpExo = t-CDocu.ImpExo + (CcbCDocu.ImpExo / CcbCDocu.TpoCmb)
                          t-CDocu.ImpIsc = t-CDocu.ImpIsc + (CcbCDocu.ImpIsc / CcbCDocu.TpoCmb)
                          t-CDocu.ImpBrt = t-CDocu.ImpBrt + ((CcbCDocu.ImpBrt - CcbCDocu.ImpDto) / CcbCDocu.TpoCmb)
                          t-CDocu.ImpIgv = t-CDocu.ImpIgv + (CcbCDocu.ImpIgv / CcbCDocu.TpoCmb)
                          t-CDocu.ImpTot = t-CDocu.ImpTot + (CcbCDocu.ImpTot / CcbCDocu.TpoCmb).
                 END.
              END CASE.
              END.
           ELSE DO:
              CREATE t-CDocu.
              ASSIGN
                  t-CDocu.CodDiv = CcbCDocu.CodDiv
                  t-CDocu.FchDoc = CcbCDocu.FchDoc    
                  t-CDocu.CodDoc = FacDocum.CodCbd
                  t-CDocu.NroDoc = CcbCDocu.NroDoc    
                  t-CDocu.Ruc    = CcbCDocu.Ruc       
                  t-CDocu.NomCli = CcbCDocu.NomCli    
                  t-CDocu.CodMon = C-CodMon
                  t-CDocu.Codref = CcbCDocu.Codref
                  t-CDocu.Nroref = CcbCDocu.Nroref.    
              IF LOOKUP(CcbCDocu.Coddoc,'N/C,N/D') = 0 THEN 
                 ASSIGN
                    t-CDocu.Codref = ''
                    t-CDocu.Nroref = ''.    
              IF CcbCDocu.codcli <> FacCfgGn.CliVar THEN DO:
                 FIND gn-clie WHERE gn-clie.CodCia = cb-codcia AND
                      gn-clie.CodCli = CcbCDocu.codcli NO-LOCK NO-ERROR.
                 IF AVAILABLE gn-clie THEN
                    ASSIGN 
                       t-CDocu.Ruc    = gn-clie.Ruc
                       t-CDocu.NomCli = gn-clie.NomCli.
              END.
              IF CcbCDocu.FlgEst = "A" THEN DO:
                 ASSIGN t-CDocu.NomCli = "A N U L A D O".
                 NEXT.
              END.
              CASE C-CodMon:
                 WHEN 1 THEN DO:
                    IF CcbCDocu.Codmon = 1 THEN
                       ASSIGN
                          t-CDocu.ImpVta = CcbCDocu.ImpVta
                          t-CDocu.ImpExo = CcbCDocu.ImpExo
                          t-CDocu.ImpIsc = CcbCDocu.ImpIsc
                          t-CDocu.ImpBrt = (CcbCDocu.ImpBrt - CcbCDocu.ImpDto)
                          t-CDocu.ImpIgv = CcbCDocu.ImpIgv
                          t-CDocu.ImpTot = CcbCDocu.ImpTot.
                    ELSE DO:
                       FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND 
                            cb-ctas.Codcta = x-cta70 NO-LOCK NO-ERROR.
                       IF AVAILABLE cb-ctas THEN
                          IF cb-ctas.Tpocmb = 1 THEN
                             ASSIGN
                                t-CDocu.ImpVta = (CcbCDocu.ImpVta * x-tpocm1)
                                t-CDocu.ImpExo = (CcbCDocu.ImpExo * x-tpocm1)
                                t-CDocu.ImpBrt = ((CcbCDocu.ImpBrt - CcbCDocu.ImpDto) * x-tpocm1).
                          ELSE
                             ASSIGN
                                t-CDocu.ImpVta = (CcbCDocu.ImpVta * x-tpocm2)
                                t-CDocu.ImpExo = (CcbCDocu.ImpExo * x-tpocm2)
                                t-CDocu.ImpBrt = ((CcbCDocu.ImpBrt - CcbCDocu.ImpDto) * x-tpocm2).
                                
                       FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND 
                            cb-ctas.Codcta = x-ctaisc NO-LOCK NO-ERROR.
                       IF AVAILABLE cb-ctas THEN
                          IF cb-ctas.Tpocmb = 1 THEN
                             ASSIGN
                                t-CDocu.ImpIsc = (CcbCDocu.ImpIsc * x-tpocm1).
                          ELSE
                             ASSIGN
                                t-CDocu.ImpIsc = (CcbCDocu.ImpIsc * x-tpocm2). /* x-tpocm2 */
                                
                       FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND 
                            cb-ctas.Codcta = x-ctaigv NO-LOCK NO-ERROR.
                       IF AVAILABLE cb-ctas THEN
                          IF cb-ctas.Tpocmb = 1 THEN
                             ASSIGN
                                t-CDocu.ImpIgv = (CcbCDocu.ImpIgv * x-tpocm1).
                          ELSE
                             ASSIGN
                                t-CDocu.ImpIgv = (CcbCDocu.ImpIgv * x-tpocm1).  /* x-tpocm2 */
                       ASSIGN
                          t-CDocu.ImpTot = t-CDocu.ImpExo + t-CDocu.ImpBrt + t-CDocu.ImpIgv.
                    END.
                 END.
                 WHEN 2 THEN DO:
                    IF CcbCDocu.Codmon = 2 THEN
                       ASSIGN
                          t-CDocu.ImpVta = CcbCDocu.ImpVta
                          t-CDocu.ImpExo = CcbCDocu.ImpExo
                          t-CDocu.ImpIsc = CcbCDocu.ImpIsc
                          t-CDocu.ImpBrt = (CcbCDocu.ImpBrt - CcbCDocu.ImpDto)
                          t-CDocu.ImpIgv = CcbCDocu.ImpIgv
                          t-CDocu.ImpTot = CcbCDocu.ImpTot.
                    ELSE 
                       ASSIGN
                          t-CDocu.ImpVta = (CcbCDocu.ImpVta / CcbCDocu.TpoCmb)
                          t-CDocu.ImpExo = (CcbCDocu.ImpExo / CcbCDocu.TpoCmb)
                          t-CDocu.ImpIsc = (CcbCDocu.ImpIsc / CcbCDocu.TpoCmb)
                          t-CDocu.ImpBrt = ((CcbCDocu.ImpBrt - CcbCDocu.ImpDto) / CcbCDocu.TpoCmb)
                          t-CDocu.ImpIgv = (CcbCDocu.ImpIgv / CcbCDocu.TpoCmb)
                          t-CDocu.ImpTot = (CcbCDocu.ImpTot / CcbCDocu.TpoCmb).
                 END.
              END CASE.
              IF CcbCDocu.Coddoc = 'N/C' THEN 
                 ASSIGN
                    t-CDocu.ImpVta = t-CDocu.ImpVta * -1
                    t-CDocu.ImpExo = t-CDocu.ImpExo * -1
                    t-CDocu.ImpIsc = t-CDocu.ImpIsc * -1
                    t-CDocu.ImpBrt = t-CDocu.ImpBrt * -1
                    t-CDocu.ImpIgv = t-CDocu.ImpIgv * -1
                    t-CDocu.ImpTot = t-CDocu.ImpTot * -1.
           END.
           PROCESS EVENT.
       END.
/*   END.*/
END.
F-Proceso = ' '.
DISPLAY F-proceso WITH FRAME {&FRAME-NAME}.
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
  DISPLAY F-proceso C-mes x-Div x-fecha1 F-Periodo x-fecha2 C-CodMon 
      WITH FRAME D-Dialog.
  ENABLE RECT-12 C-mes x-Div x-fecha1 Btn_OK F-Periodo x-fecha2 Btn_Cancel 
         RECT-41 C-CodMon 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FORMATO D-Dialog 
PROCEDURE FORMATO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR Titulo1   AS CHAR FORMAT "X(230)" NO-UNDO.
 DEFINE VAR Titulo2   AS CHAR FORMAT "X(230)" NO-UNDO.
 DEFINE VAR Titulo3   AS CHAR FORMAT "X(230)" NO-UNDO.
 DEFINE VAR x-viene   AS CHAR    NO-UNDO.
 DEFINE VAR TD-ImpBrt AS DECIMAL NO-UNDO.
 DEFINE VAR TD-ImpExo AS DECIMAL NO-UNDO.
 DEFINE VAR TD-ImpIsc AS DECIMAL NO-UNDO.
 DEFINE VAR TD-ImpVta AS DECIMAL NO-UNDO.
 DEFINE VAR TD-ImpIgv AS DECIMAL NO-UNDO.
 DEFINE VAR TD-ImpTot AS DECIMAL NO-UNDO.
 DEFINE VAR TP-ImpBrt AS DECIMAL NO-UNDO.
 DEFINE VAR TP-ImpExo AS DECIMAL NO-UNDO.
 DEFINE VAR TP-ImpIsc AS DECIMAL NO-UNDO.
 DEFINE VAR TP-ImpVta AS DECIMAL NO-UNDO.
 DEFINE VAR TP-ImpIgv AS DECIMAL NO-UNDO.
 DEFINE VAR TP-ImpTot AS DECIMAL NO-UNDO.
 
 RUN Captura.
 
 RUN bin/_mes.p ( INPUT c-mes  , 1, OUTPUT x-DesMes ).     
 
 Titulo1 = "R E G I S T R O  D E  V E N T A S".
 Titulo2 = "DEL MES DE " + x-DesMes.
 Titulo3 = "EXPRESADO EN " + IF C-CodMon = 1 THEN "NUEVOS SOLES" ELSE "DOLARES AMERICANOS".
 
 RUN BIN/_centrar.p ( INPUT Titulo1, 190, OUTPUT Titulo1).
 RUN BIN/_centrar.p ( INPUT Titulo2, 190, OUTPUT Titulo2).
 RUN BIN/_centrar.p ( INPUT Titulo3, 190, OUTPUT Titulo3).
 
 DEFINE FRAME f-top
       HEADER
       S-NOMCIA FORMAT "X(60)" 
       "FECHA  : " TO 200 TODAY 
       Titulo1 
       "PAGINA : " TO 205 PAGE-NUMBER FORMAT "ZZ9" SKIP       
       Titulo2 SKIP 
       Titulo3 SKIP(2)              
       FILL("-",220) FORMAT 'X(220)' SKIP
       "      Fecha      Cod Numero               Nro.                                                         Valor                       Base                Importe                            Importe      Cod  Numero    " SKIP
       "Divi. Emisi¢n    Doc Documento            R.U.C.      C l i e n t e                                    Venta         I.S.C.        Imponible           Exonerado           I.G.V.          Total       Ref  Referencia" SKIP
       FILL("-",220) FORMAT 'X(220)' SKIP
       x-viene FORMAT 'X(220)' SKIP(2)
       WITH PAGE-TOP WIDTH 230 NO-LABELS NO-BOX STREAM-IO DOWN.

 DEFINE FRAME f-cab
       t-CDocu.CodDiv    COLUMN-LABEL "Divi." FORMAT 'X(7)'
       t-CDocu.FchDoc    COLUMN-LABEL "Fecha !Emision"
       t-CDocu.CodDoc    COLUMN-LABEL "Cod.!Doc."
       t-CDocu.NroDoc    COLUMN-LABEL "Numero!Documento" FORMAT 'X(20)'
       t-CDocu.Ruc       COLUMN-LABEL "Nro.!R.U.C." FORMAT "X(9)"
       t-CDocu.NomCli    COLUMN-LABEL "C l i e n t e" FORMAT "X(40)"
       t-CDocu.ImpBrt    COLUMN-LABEL "Valor!Venta" FORMAT "(ZZZ,ZZZ,ZZ9.99)"
       t-CDocu.ImpIsc    COLUMN-LABEL "I.S.C" FORMAT "(ZZZ,ZZZ,ZZ9.99)"
       t-CDocu.ImpVta    COLUMN-LABEL "Base!Imponible" FORMAT "(ZZZ,ZZZ,ZZ9.99)"
       t-CDocu.ImpExo    COLUMN-LABEL "Importe!Exonerado" FORMAT "(ZZZ,ZZZ,ZZ9.99)"
       t-CDocu.ImpIgv    COLUMN-LABEL "I.G.V." FORMAT "(ZZZ,ZZZ,ZZ9.99)"
       t-CDocu.ImpTot    COLUMN-LABEL "Importe!Total" FORMAT "(ZZZ,ZZZ,ZZ9.99)"       
       t-CDocu.codref    COLUMN-LABEL "Cod!Ref" 
       t-CDocu.Nroref    COLUMN-LABEL "Numero!Referencia" FORMAT 'X(20)'
       WITH WIDTH 230 NO-LABELS NO-BOX NO-UNDERLINE STREAM-IO DOWN.

 DEFINE FRAME f-bottom
       HEADER
       ' ' SKIP(1)
       SPACE(76)
       "      V a n .....   "
       TP-ImpBrt  FORMAT "(>>>,>>>,>>9.99)"
       TP-ImpIsc  FORMAT "(>>>,>>>,>>9.99)"
       TP-ImpVta  FORMAT "(>>>,>>>,>>9.99)"
       TP-ImpExo  FORMAT "(>>>,>>>,>>9.99)"
       TP-ImpIgv  FORMAT "(>>>,>>>,>>9.99)"
       TP-ImpTot  FORMAT "(>>>,>>>,>>9.99)" SKIP
       WITH PAGE-BOTTOM WIDTH 230 NO-LABEL NO-BOX STREAM-IO DOWN.
    
 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
 
 PUT CONTROL CHR(27) "@".
 PUT CONTROL CHR(27) "C" CHR(66).
 PUT CONTROL CHR(27) CHR(120) 0.
 PUT CONTROL CHR(15).

 ASSIGN
   TP-ImpBrt = 0
   TP-ImpExo = 0
   TP-ImpIsc = 0
   TP-ImpVta = 0
   TP-ImpIgv = 0
   TP-ImpTot = 0
   x-viene = ' '.
 
 FOR EACH t-CDocu BREAK BY t-CDocu.codcia BY t-CDocu.CodDiv BY t-CDocu.Fchdoc BY t-CDocu.Coddoc BY t-CDocu.Nrodoc:
     VIEW FRAME f-top.
     VIEW FRAME f-bottom.
     DISPLAY 
             t-CDocu.CodDiv
             t-CDocu.FchDoc    
             t-CDocu.CodDoc    
             t-CDocu.NroDoc    
             t-CDocu.Ruc       
             t-CDocu.NomCli    
             t-CDocu.ImpBrt WHEN t-CDocu.ImpBrt <> 0
             t-CDocu.ImpExo WHEN t-CDocu.ImpExo <> 0
             t-CDocu.ImpIsc WHEN t-CDocu.ImpIsc <> 0
             t-CDocu.ImpVta WHEN t-CDocu.ImpVta <> 0
             t-CDocu.ImpIgv WHEN t-CDocu.ImpIgv <> 0
             t-CDocu.ImpTot WHEN t-CDocu.ImpTot <> 0 
             t-CDocu.Codref
             t-CDocu.Nroref WITH FRAME F-CAB.     
/*     TD-ImpBrt = TD-ImpBrt + IF t-CDocu.CodDoc = '07' THEN (t-CDocu.ImpBrt * -1) ELSE t-CDocu.ImpBrt.
     TD-ImpExo = TD-ImpExo + IF t-CDocu.CodDoc = '07' THEN (t-CDocu.ImpExo * -1) ELSE t-CDocu.ImpExo. 
     TD-ImpIsc = TD-ImpIsc + IF t-CDocu.CodDoc = '07' THEN (t-CDocu.ImpIsc * -1) ELSE t-CDocu.ImpIsc.
     TD-ImpVta = TD-ImpVta + IF t-CDocu.CodDoc = '07' THEN (t-CDocu.ImpVta * -1) ELSE t-CDocu.ImpVta. 
     TD-ImpIgv = TD-ImpIgv + IF t-CDocu.CodDoc = '07' THEN (t-CDocu.ImpIgv * -1) ELSE t-CDocu.ImpIgv. 
     TD-ImpTot = TD-ImpTot + IF t-CDocu.CodDoc = '07' THEN (t-CDocu.ImpTot * -1) ELSE t-CDocu.ImpTot.*/

     TP-ImpBrt = TP-ImpBrt + t-CDocu.ImpBrt.
     TP-ImpExo = TP-ImpExo + t-CDocu.ImpExo. 
     TP-ImpIsc = TP-ImpIsc + t-CDocu.ImpIsc.
     TP-ImpVta = TP-ImpVta + t-CDocu.ImpVta. 
     TP-ImpIgv = TP-ImpIgv + t-CDocu.ImpIgv. 
     TP-ImpTot = TP-ImpTot + t-CDocu.ImpTot.

     x-viene = FILL(' ',76) + "    V i e n e  ..... " + 
                STRING(TP-ImpBrt, "(>>>,>>>,>>9.99)") + ' ' +
                STRING(TP-ImpIsc, "(>>>,>>>,>>9.99)") + ' ' +
                STRING(TP-ImpVta, "(>>>,>>>,>>9.99)") + ' ' +
                STRING(TP-ImpExo, "(>>>,>>>,>>9.99)") + ' ' +
                STRING(TP-ImpIgv, "(>>>,>>>,>>9.99)") + ' ' +
                STRING(TP-ImpTot, "(>>>,>>>,>>9.99)").

     ACCUMULATE t-CDocu.ImpBrt ( SUB-TOTAL BY t-CDocu.CodDiv ).
     ACCUMULATE t-CDocu.ImpExo ( SUB-TOTAL BY t-CDocu.CodDiv ).
     ACCUMULATE t-CDocu.ImpIsc ( SUB-TOTAL BY t-CDocu.CodDiv ).
     ACCUMULATE t-CDocu.ImpVta ( SUB-TOTAL BY t-CDocu.CodDiv ).
     ACCUMULATE t-CDocu.ImpIgv ( SUB-TOTAL BY t-CDocu.CodDiv ).
     ACCUMULATE t-CDocu.ImpTot ( SUB-TOTAL BY t-CDocu.CodDiv ).

     IF LAST-OF (t-CDocu.CodDiv) THEN DO:
        UNDERLINE 
             t-CDocu.ImpBrt
             t-CDocu.ImpExo
             t-CDocu.ImpIsc
             t-CDocu.ImpVta 
             t-CDocu.ImpIgv
             t-CDocu.ImpTot WITH FRAME F-CAB. 
             
        DISPLAY 
                 "TOTAL POR DIVISION " + t-CDocu.CodDiv @ t-CDocu.NomCli    
/*                 TD-ImpBrt @ t-CDocu.ImpBrt
                 TD-ImpExo @ t-CDocu.ImpExo
                 TD-ImpIsc @ t-CDocu.ImpIsc
                 TD-ImpVta @ t-CDocu.ImpVta
                 TD-ImpIgv @ t-CDocu.ImpIgv
                 TD-ImpTot @ t-CDocu.ImpTot
                 WITH FRAME F-CAB.        
                 TD-ImpBrt = 0.
                 TD-ImpExo = 0.
                 TD-ImpIsc = 0.
                 TD-ImpVta = 0.
                 TD-ImpIgv = 0.
                 TD-ImpTot = 0.*/
                 ACCUM SUB-TOTAL BY t-CDocu.CodDiv t-CDocu.ImpBrt @ t-CDocu.ImpBrt
                 ACCUM SUB-TOTAL BY t-CDocu.CodDiv t-CDocu.ImpExo @ t-CDocu.ImpExo
                 ACCUM SUB-TOTAL BY t-CDocu.CodDiv t-CDocu.ImpIsc @ t-CDocu.ImpIsc
                 ACCUM SUB-TOTAL BY t-CDocu.CodDiv t-CDocu.ImpVta @ t-CDocu.ImpVta
                 ACCUM SUB-TOTAL BY t-CDocu.CodDiv t-CDocu.ImpIgv @ t-CDocu.ImpIgv
                 ACCUM SUB-TOTAL BY t-CDocu.CodDiv t-CDocu.ImpTot @ t-CDocu.ImpTot
                 WITH FRAME F-CAB.        
        DOWN(2) WITH FRAME F-CAB.
     END.
     IF LAST-OF (t-CDocu.Codcia) THEN DO:
        UNDERLINE 
             t-CDocu.ImpBrt
             t-CDocu.ImpExo
             t-CDocu.ImpIsc
             t-CDocu.ImpVta 
             t-CDocu.ImpIgv
             t-CDocu.ImpTot WITH FRAME F-CAB. 
             
        DISPLAY 
                 "TOTAL GENERAL  "  @ t-CDocu.NomCli    
                 TP-ImpBrt @ t-CDocu.ImpBrt
                 TP-ImpExo @ t-CDocu.ImpExo
                 TP-ImpIsc @ t-CDocu.ImpIsc
                 TP-ImpVta @ t-CDocu.ImpVta
                 TP-ImpIgv @ t-CDocu.ImpIgv
                 TP-ImpTot @ t-CDocu.ImpTot
                 WITH FRAME F-CAB.        
        DOWN(2).
     
     END.
 END.
 
 PAGE.
 OUTPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR D-Dialog 
PROCEDURE IMPRIMIR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.
   
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").
  
  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
  
  RUN Formato.
  
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN BIN/_VCAT.P(s-print-file). 
  END CASE. 
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
  FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
       cb-cfgg.Codcfg = 'R02' NO-LOCK NO-ERROR.
  IF AVAILABLE cb-Cfgg THEN DO:
     ASSIGN
        x-cta70  = cb-cfgg.codcta[1] 
        x-ctaisc = cb-cfgg.codcta[2] 
        x-ctaigv = cb-cfgg.codcta[3].
     END.
  ELSE DO:
     MESSAGE 'Configuracion de Registro de Ventas no existe' VIEW-AS ALERT-BOX ERROR.
     RETURN.
  END.
  
  DO WITH FRAME {&FRAME-NAME}.
     DISPLAY YEAR(TODAY) @ F-Periodo.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
PROCEDURE Procesa-Parametros :
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
PROCEDURE Recoge-Parametros :
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
        WHEN "" THEN ASSIGN input-var-1 = "".
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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


