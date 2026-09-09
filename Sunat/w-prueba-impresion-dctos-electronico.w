&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCDocu

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 CcbCDocu.CodDoc CcbCDocu.NroDoc ~
CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.FchDoc CcbCDocu.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH CcbCDocu ~
      WHERE codcia = 1 and ~
((rdsDocs = '*' and lookup(coddoc,"FAC,BOL,N/C,N/D") > 0) or (coddoc = rdsDocs)) and ~
(fchdoc >= txtdesde and fchdoc <= txthasta) and ~
nrodoc begins txtSerie NO-LOCK ~
    BY CcbCDocu.CodDoc ~
       BY CcbCDocu.NroDoc INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH CcbCDocu ~
      WHERE codcia = 1 and ~
((rdsDocs = '*' and lookup(coddoc,"FAC,BOL,N/C,N/D") > 0) or (coddoc = rdsDocs)) and ~
(fchdoc >= txtdesde and fchdoc <= txthasta) and ~
nrodoc begins txtSerie NO-LOCK ~
    BY CcbCDocu.CodDoc ~
       BY CcbCDocu.NroDoc INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 CcbCDocu


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 rdsetOrigen chbxFormato chbxDirecto ~
cboimpresoras txtDesde txtHasta rdsDocs BUTTON-5 TxtSerie BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS rdsetOrigen chbxFormato chbxDirecto ~
cboimpresoras txtDesde txtHasta rdsDocs TxtSerie 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Imprimir" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-5 
     LABEL "Refrescar" 
     SIZE 13 BY 1.12.

DEFINE VARIABLE cboimpresoras AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Elija una impresora" 
     DROP-DOWN-LIST
     SIZE 56 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE TxtSerie AS CHARACTER FORMAT "X(4)":U 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE rdsDocs AS CHARACTER INITIAL "FAC" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "FACTURAS", "FAC",
"BOLETAS", "BOL",
"NOTAS DE CREDITO", "N/C",
"NOTAS DE DEBITO", "N/D",
"< TODOS >", "*"
     SIZE 92 BY 1.08 NO-UNDO.

DEFINE VARIABLE rdsetOrigen AS CHARACTER INITIAL "O" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cliente", "L",
"Control Administrativo", "A",
"Re-impresion", "R"
     SIZE 48 BY .96 NO-UNDO.

DEFINE VARIABLE chbxDirecto AS LOGICAL INITIAL yes 
     LABEL "Directo a impresora" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .77 NO-UNDO.

DEFINE VARIABLE chbxFormato AS LOGICAL INITIAL no 
     LABEL "Formato Ticket" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      CcbCDocu.CodDoc FORMAT "x(3)":U
      CcbCDocu.NroDoc FORMAT "X(12)":U
      CcbCDocu.CodCli FORMAT "x(11)":U
      CcbCDocu.NomCli FORMAT "x(50)":U WIDTH 45.43
      CcbCDocu.FchDoc FORMAT "99/99/9999":U
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 26.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 116 BY 16.38 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.35 COL 100 WIDGET-ID 10
     rdsetOrigen AT ROW 1.42 COL 3 NO-LABEL WIDGET-ID 2
     chbxFormato AT ROW 1.54 COL 52 WIDGET-ID 6
     chbxDirecto AT ROW 1.54 COL 72.43 WIDGET-ID 8
     cboimpresoras AT ROW 2.65 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     txtDesde AT ROW 2.65 COL 71 COLON-ALIGNED WIDGET-ID 16
     txtHasta AT ROW 2.65 COL 96 COLON-ALIGNED WIDGET-ID 18
     rdsDocs AT ROW 3.96 COL 3.14 NO-LABEL WIDGET-ID 20
     BUTTON-5 AT ROW 5.04 COL 101 WIDGET-ID 26
     TxtSerie AT ROW 5.23 COL 9 COLON-ALIGNED WIDGET-ID 28
     BROWSE-2 AT ROW 6.54 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 118 BY 22.5 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Prueba de impresion QR"
         HEIGHT             = 22.5
         WIDTH              = 118
         MAX-HEIGHT         = 22.5
         MAX-WIDTH          = 118
         VIRTUAL-HEIGHT     = 22.5
         VIRTUAL-WIDTH      = 118
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 TxtSerie F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.CcbCDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.CcbCDocu.CodDoc|yes,INTEGRAL.CcbCDocu.NroDoc|yes"
     _Where[1]         = "codcia = 1 and
((rdsDocs = '*' and lookup(coddoc,""FAC,BOL,N/C,N/D"") > 0) or (coddoc = rdsDocs)) and
(fchdoc >= txtdesde and fchdoc <= txthasta) and
nrodoc begins txtSerie"
     _FldNameList[1]   = INTEGRAL.CcbCDocu.CodDoc
     _FldNameList[2]   = INTEGRAL.CcbCDocu.NroDoc
     _FldNameList[3]   = INTEGRAL.CcbCDocu.CodCli
     _FldNameList[4]   > INTEGRAL.CcbCDocu.NomCli
"CcbCDocu.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "45.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.CcbCDocu.FchDoc
     _FldNameList[6]   > INTEGRAL.CcbCDocu.ImpTot
"CcbCDocu.ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "26.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Prueba de impresion QR */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Prueba de impresion QR */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Imprimir */
DO:
  
    ASSIGN rdSetOrigen chbxFormato chbxDirecto cboImpresoras txtDesde txtHasta rdsDocs txtSerie.

    IF AVAILABLE ccbcdocu THEN DO:
        RUN sunat\r-impresion-doc-electronico(INPUT ccbcdocu.coddiv, 
                                              INPUT ccbcdocu.coddoc, 
                                              INPUT ccbcdocu.nrodoc,
                                              INPUT rdSetOrigen,
                                              INPUT chbxFormato,
                                              INPUT chbxDirecto,
                                              INPUT cboImpresoras).
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Refrescar */
DO:
  ASSIGN rdSetOrigen chbxFormato chbxDirecto cboImpresoras txtDesde txtHasta rdsDocs txtSerie.

  {&OPEN-QUERY-BROWSE-2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY rdsetOrigen chbxFormato chbxDirecto cboimpresoras txtDesde txtHasta 
          rdsDocs TxtSerie 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 rdsetOrigen chbxFormato chbxDirecto cboimpresoras txtDesde 
         txtHasta rdsDocs BUTTON-5 TxtSerie BROWSE-2 
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
  
DEFINE VARIABLE s-pagina-final     AS INTEGER.
DEFINE VARIABLE s-pagina-inicial   AS INTEGER.
DEFINE VARIABLE s-salida-impresion AS INTEGER.
DEFINE VARIABLE s-printer-name     AS CHARACTER.
DEFINE VARIABLE s-printer-port     AS CHARACTER.
DEFINE VARIABLE s-print-file       AS CHARACTER.
DEFINE VARIABLE s-nro-copias       AS INTEGER.
DEFINE VARIABLE s-orientacion      AS INTEGER.

DEFINE VARIABLE cPrinter-list AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPort-list AS CHARACTER NO-UNDO.
DEFINE VARIABLE iPrinter-count AS INTEGER NO-UNDO.
DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.
DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.

DEFINE VAR x-sec AS INT.

ASSIGN
    s-printer-name = ""
    s-printer-port = ""
    s-print-file = ""
    s-nro-copias = 1.


    RUN aderb/_prlist(
        OUTPUT cPrinter-list,
        OUTPUT cPort-list,
        OUTPUT iPrinter-count).


    DO x-sec = 1 TO iPrinter-count :
        cboimpresoras:ADD-LAST(ENTRY(x-sec,cPrinter-list)) IN FRAME {&FRAME-NAME}.
    END.

/*

    MESSAGE cprinter-list SKIP
        cport-list SKIP
        iprinter-count.
   */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 2,"99/99/9999").
  txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "CcbCDocu"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

