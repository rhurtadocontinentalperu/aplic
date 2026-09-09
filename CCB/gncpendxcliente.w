&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
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

{src/adm2/widgetprto.i}

DEFINE SHARED VARIABLE s-codcia AS INTEGER.
DEFINE SHARED VARIABLE s-codcli LIKE gn-clie.codcli.
DEFINE SHARED VARIABLE cl-codcia AS INT.
DEFINE SHARED VARIABLE s-coddiv AS CHAR.
DEFINE SHARED VARIABLE s-flgsit AS CHAR.

DEFINE VARIABLE x-Moneda AS CHAR NO-UNDO.

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

DEFINE SHARED TEMP-TABLE wrk_dcaja NO-UNDO LIKE ccbdcaja.

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK.
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK.

/* RHC 28/04/2017 Se amplia 12 meses el vencimiento de la N/C solo para personal de CyC */
DEF VAR dIncremento AS INT NO-UNDO.
dIncremento = 0.
IF s-FlgSit = "NO" THEN dIncremento = 10.  /* años */

&SCOPED-DEFINE Condicion CcbCDocu.CodCia = s-codcia ~
    AND LOOKUP(CcbCDocu.CodDoc, "N/C,NCI") > 0 ~
    AND (s-FlgSit = "NO" OR (CcbCDocu.DivOri = s-coddiv OR CcbCDocu.coddiv = s-coddiv)) ~
    AND CcbCDocu.CodCli = s-codcli ~
    AND CcbCDocu.FlgEst = "P" ~
    AND CcbCDocu.FlgSit <> "X" ~
    AND ADD-INTERVAL(Ccbcdocu.FchVto, dIncremento, 'year') >= TODAY

    /*AND (CcbCDocu.DivOri = s-coddiv OR CcbCDocu.coddiv = s-coddiv) ~*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME gDialog
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCDocu GN-DIVI

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 CcbCDocu.FchDoc CcbCDocu.CodDoc ~
CcbCDocu.NroDoc ~
IF (CcbCDocu.CodMon = 1) THEN ("S/.") ELSE ("US$") @ x-Moneda ~
CcbCDocu.ImpTot CcbCDocu.SdoAct 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH CcbCDocu ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST GN-DIVI OF CcbCDocu ~
      WHERE GN-DIVI.CanalVenta <> "MIN" NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH CcbCDocu ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST GN-DIVI OF CcbCDocu ~
      WHERE GN-DIVI.CanalVenta <> "MIN" NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 CcbCDocu GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 CcbCDocu
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 GN-DIVI


/* Definitions for DIALOG-BOX gDialog                                   */
&Scoped-define OPEN-BROWSERS-IN-QUERY-gDialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 Btn_OK Btn_Cancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 15 BY 1.54.

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.54.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      CcbCDocu, 
      GN-DIVI SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 gDialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      CcbCDocu.FchDoc FORMAT "99/99/9999":U
      CcbCDocu.CodDoc FORMAT "x(3)":U
      CcbCDocu.NroDoc FORMAT "X(12)":U WIDTH 9.86
      IF (CcbCDocu.CodMon = 1) THEN ("S/.") ELSE ("US$") @ x-Moneda COLUMN-LABEL "Moneda" FORMAT "x(3)":U
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U
      CcbCDocu.SdoAct COLUMN-LABEL "Saldo Actual" FORMAT "->>,>>>,>>9.99":U
            WIDTH 11.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 62 BY 18.85
         FONT 4 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     BROWSE-2 AT ROW 1.19 COL 2 WIDGET-ID 200
     Btn_OK AT ROW 20.04 COL 2
     Btn_Cancel AT ROW 20.04 COL 17
     SPACE(33.13) SKIP(0.37)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "N/C PENDIENTES"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 1 gDialog */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.CcbCDocu,INTEGRAL.GN-DIVI OF INTEGRAL.CcbCDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _Where[1]         = "{&Condicion}"
     _Where[2]         = "GN-DIVI.CanalVenta <> ""MIN"""
     _FldNameList[1]   = INTEGRAL.CcbCDocu.FchDoc
     _FldNameList[2]   = INTEGRAL.CcbCDocu.CodDoc
     _FldNameList[3]   > INTEGRAL.CcbCDocu.NroDoc
"CcbCDocu.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"IF (CcbCDocu.CodMon = 1) THEN (""S/."") ELSE (""US$"") @ x-Moneda" "Moneda" "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.CcbCDocu.ImpTot
     _FldNameList[6]   > INTEGRAL.CcbCDocu.SdoAct
"CcbCDocu.SdoAct" "Saldo Actual" ? "decimal" ? ? ? ? ? ? no ? no no "11.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* N/C PENDIENTES */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* OK */
DO:
   RUN Carga-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal gDialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE dTpoCmb AS DECIMAL NO-UNDO.
DEF VAR k AS INT NO-UNDO.

/* ACTUALIZAMOS SIN BORRAR LO YA HECHO */
DO k = 1 TO {&browse-name}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&browse-name}:FETCH-SELECTED-ROW(k) THEN DO:
        FIND FIRST wrk_dcaja WHERE wrk_dcaja.codref = ccbcdocu.coddoc
            AND wrk_dcaja.nroref = ccbcdocu.nrodoc
            NO-ERROR.
        IF AVAILABLE wrk_dcaja THEN NEXT.
        CREATE wrk_dcaja.
        ASSIGN
            wrk_dcaja.CodCia = S-CODCIA
            wrk_dcaja.CodCli = S-CodCli
            wrk_dcaja.codref = ccbcdocu.coddoc
            wrk_dcaja.nroref = ccbcdocu.nrodoc
            wrk_dcaja.CodCli = ccbcdocu.codcli
            wrk_dcaja.CodMon = ccbcdocu.codmon
            wrk_dcaja.ImpTot = ccbcdocu.sdoact
            wrk_dcaja.CodDoc = IF ccbcdocu.codmon = 1 THEN "S/." ELSE "US$".
           /* 02/08/2022: SLM bloqueado por ahora hasta automatizar */
/*         FIND gn-clie WHERE gn-clie.codcia = cl-codcia                                      */
/*             AND gn-clie.codcli = wrk_dcaja.CodCli                                          */
/*             NO-LOCK NO-ERROR.                                                              */
/*         IF AVAILABLE gn-clie AND gn-clie.rucold = "Si" THEN DO:                            */
/*             dTpoCmb = 1.                                                                   */
/*             /* Verifica si Documento ya tiene aplicada la retencion */                     */
/*             FIND FIRST CcbCmov WHERE CCBCMOV.CodCia = ccbcdocu.codcia                      */
/*                 AND CCBCMOV.CodDoc = ccbcdocu.coddoc                                       */
/*                 AND CCBCMOV.NroDoc = ccbcdocu.nrodoc                                       */
/*                 NO-LOCK NO-ERROR.                                                          */
/*             IF NOT AVAILABLE CCBCMOV AND NOT CAN-FIND(FIRST wrk_ret WHERE                  */
/*                                                       wrk_ret.CodDoc = ccbcdocu.coddoc AND */
/*                                                       wrk_ret.NroDoc = ccbcdocu.nrodoc)    */
/*                 THEN DO:                                                                   */
/*                 FIND LAST Gn-tccja WHERE Gn-tccja.fecha <= TODAY NO-LOCK NO-ERROR.         */
/*                 IF AVAILABLE Gn-tccja THEN DO:                                             */
/*                     IF ccbcdocu.Codmon = 1 THEN dTpoCmb = Gn-tccja.Compra.                 */
/*                     ELSE dTpoCmb = Gn-tccja.Venta.                                         */
/*                 END.                                                                       */
/*                 CREATE wrk_ret.                                                            */
/*                 ASSIGN                                                                     */
/*                     wrk_ret.CodCia = ccbcdocu.codcia                                       */
/*                     wrk_ret.CodCli = ccbcdocu.codcli                                       */
/*                     wrk_ret.CodDoc = ccbcdocu.coddoc                                       */
/*                     wrk_ret.NroDoc = ccbcdocu.nrodoc                                       */
/*                     wrk_ret.FchDoc = ccbcdocu.fchdoc                                       */
/*                     wrk_ret.CodRef = "I/C"                                                 */
/*                     wrk_ret.NroRef = ""                                                    */
/*                     wrk_ret.CodMon = "S/.".                                                */
/*                 /* OJO: Cálculo de Retenciones Siempre en Soles */                         */
/*                 IF ccbcdocu.codmon = 1 THEN DO:                                            */
/*                     wrk_ret.ImpTot = ccbcdocu.ImpTot *                                     */
/*                         IF LOOKUP(ccbcdocu.coddoc, "N/C,NCI") > 0 THEN -1 ELSE 1.          */
/*                     wrk_ret.ImpRet = ROUND((wrk_ret.ImpTot * (6 / 100)),2).                */
/*                 END.                                                                       */
/*                 ELSE DO:                                                                   */
/*                     wrk_ret.ImpTot = ROUND((ccbcdocu.ImpTot * dTpoCmb),2) *                */
/*                         IF LOOKUP(ccbcdocu.coddoc, "N/C,NCI") > 0 THEN -1 ELSE 1.          */
/*                     wrk_ret.ImpRet = ROUND((wrk_ret.ImpTot * (6 / 100)),2).                */
/*                 END.                                                                       */
/*             END.                                                                           */
/*         END.                                                                               */
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  ENABLE BROWSE-2 Btn_OK Btn_Cancel 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

