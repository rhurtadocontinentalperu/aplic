&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER tt-RatioDet FOR INTEGRAL.RatioDet.



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

/* 
    EL Parametro pDivision va depender de quien va a mirar los ratios
    XXXXX : Todo el consolidado
    00018 : Solo Provincias...
    Etc, etc
*/
DEFINE INPUT PARAMETER pDivision AS CHAR    NO-UNDO.

FIND FIRST RatioCab WHERE CodDiv = pDivision NO-LOCK NO-ERROR.

IF NOT AVAILABLE RatioCab THEN DO:
    MESSAGE "Division (" + pDivision + ") no procesada..." VIEW-AS ALERT-BOX.
    RETURN NO-APPLY.
END.

DEFINE VAR lSec AS INT INIT 0.
DEFINE VAR lSec1 AS INT INIT 0.

DEFINE VAR lQtyPendiente AS DEC.
DEFINE VAR lPeso AS DEC.
DEFINE VAR lVolumen AS DEC.

DEFINE SHARED VAR s-codcia AS INT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-7

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES INTEGRAL.VtaTabla INTEGRAL.Almmmatg

/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 INTEGRAL.VtaTabla.LLave_c3 ~
INTEGRAL.Almmmatg.DesMat INTEGRAL.VtaTabla.Valor[1] ~
INTEGRAL.VtaTabla.Valor[2] ~
(INTEGRAL.VtaTabla.Valor[1] - INTEGRAL.VtaTabla.Valor[2]) @ lQtyPendiente ~
INTEGRAL.Almmmatg.DesMar fpeso() @ lPeso 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7 
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH INTEGRAL.VtaTabla ~
      WHERE INTEGRAL.VtaTabla.CodCia = s-codcia and  ~
INTEGRAL.VtaTabla.Tabla = 'REPEXPO' and  ~
INTEGRAL.VtaTabla.Llave_c1 = 'DISTRIB' and  ~
INTEGRAL.VtaTabla.Llave_c2 = 'COTIZA' and  ~
(INTEGRAL.VtaTabla.valor[1] - INTEGRAL.VtaTabla.valor[2]) > 0 NO-LOCK, ~
      FIRST INTEGRAL.Almmmatg WHERE INTEGRAL.Almmmatg.CodCia =  INTEGRAL.VtaTabla.CodCia and ~
 INTEGRAL.Almmmatg.codmat =  INTEGRAL.VtaTabla.LLave_c3 NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY BROWSE-7 FOR EACH INTEGRAL.VtaTabla ~
      WHERE INTEGRAL.VtaTabla.CodCia = s-codcia and  ~
INTEGRAL.VtaTabla.Tabla = 'REPEXPO' and  ~
INTEGRAL.VtaTabla.Llave_c1 = 'DISTRIB' and  ~
INTEGRAL.VtaTabla.Llave_c2 = 'COTIZA' and  ~
(INTEGRAL.VtaTabla.valor[1] - INTEGRAL.VtaTabla.valor[2]) > 0 NO-LOCK, ~
      FIRST INTEGRAL.Almmmatg WHERE INTEGRAL.Almmmatg.CodCia =  INTEGRAL.VtaTabla.CodCia and ~
 INTEGRAL.Almmmatg.codmat =  INTEGRAL.VtaTabla.LLave_c3 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 INTEGRAL.VtaTabla INTEGRAL.Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 INTEGRAL.VtaTabla
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-7 INTEGRAL.Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-7}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btnExcel BROWSE-7 
&Scoped-Define DISPLAYED-OBJECTS txtCotizaciones txtDivision txtMetaDiaria ~
txtProcesado txtNroDias txtDesde txtHasta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPeso W-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnExcel 
     LABEL "Excel" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtCotizaciones AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total Cotizaciones" 
     VIEW-AS FILL-IN 
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Rango Fechas  -  Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtDivision AS CHARACTER FORMAT "X(50)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtMetaDiaria AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Meta diaria" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE txtNroDias AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Nro dias" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtProcesado AS DATE FORMAT "99/99/9999":U 
     LABEL "Procesado" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-7 FOR 
      INTEGRAL.VtaTabla, 
      INTEGRAL.Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 W-Win _STRUCTURED
  QUERY BROWSE-7 NO-LOCK DISPLAY
      INTEGRAL.VtaTabla.LLave_c3 COLUMN-LABEL "Articulo" FORMAT "x(8)":U
      INTEGRAL.Almmmatg.DesMat FORMAT "X(45)":U
      INTEGRAL.VtaTabla.Valor[1] COLUMN-LABEL "Pedido" FORMAT "->>>,>>>,>>9.9999":U
            WIDTH 12.43
      INTEGRAL.VtaTabla.Valor[2] COLUMN-LABEL "Despachada" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 11.43
      (INTEGRAL.VtaTabla.Valor[1] - INTEGRAL.VtaTabla.Valor[2]) @ lQtyPendiente COLUMN-LABEL "Pëndiente" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 11.43
      INTEGRAL.Almmmatg.DesMar FORMAT "X(30)":U WIDTH 15.43
      fpeso() @ lPeso COLUMN-LABEL "Peso" FORMAT ">>>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 146.43 BY 18.58 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txtCotizaciones AT ROW 1.58 COL 87 COLON-ALIGNED WIDGET-ID 26
     txtDivision AT ROW 1.77 COL 26 COLON-ALIGNED WIDGET-ID 18
     btnExcel AT ROW 2.73 COL 118 WIDGET-ID 32
     txtMetaDiaria AT ROW 2.85 COL 87 COLON-ALIGNED WIDGET-ID 28
     txtProcesado AT ROW 2.96 COL 26 COLON-ALIGNED WIDGET-ID 20
     txtNroDias AT ROW 4.12 COL 87 COLON-ALIGNED WIDGET-ID 30
     txtDesde AT ROW 4.19 COL 26 COLON-ALIGNED WIDGET-ID 22
     txtHasta AT ROW 4.19 COL 47.43 COLON-ALIGNED WIDGET-ID 24
     BROWSE-7 AT ROW 5.69 COL 1.57 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-RatioDet B "?" ? INTEGRAL RatioDet
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Ratios Programacion"
         HEIGHT             = 23.42
         WIDTH              = 147.72
         MAX-HEIGHT         = 23.92
         MAX-WIDTH          = 147.72
         VIRTUAL-HEIGHT     = 23.92
         VIRTUAL-WIDTH      = 147.72
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
   FRAME-NAME Size-to-Fit                                               */
/* BROWSE-TAB BROWSE-7 txtHasta F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN txtCotizaciones IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDesde IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtDivision IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtHasta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtMetaDiaria IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtNroDias IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtProcesado IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _TblList          = "INTEGRAL.VtaTabla,INTEGRAL.Almmmatg WHERE INTEGRAL.VtaTabla ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST"
     _Where[1]         = "INTEGRAL.VtaTabla.CodCia = s-codcia and 
INTEGRAL.VtaTabla.Tabla = 'REPEXPO' and 
INTEGRAL.VtaTabla.Llave_c1 = 'DISTRIB' and 
INTEGRAL.VtaTabla.Llave_c2 = 'COTIZA' and 
(INTEGRAL.VtaTabla.valor[1] - INTEGRAL.VtaTabla.valor[2]) > 0"
     _JoinCode[2]      = "INTEGRAL.Almmmatg.CodCia =  INTEGRAL.VtaTabla.CodCia and
 INTEGRAL.Almmmatg.codmat =  INTEGRAL.VtaTabla.LLave_c3"
     _FldNameList[1]   > INTEGRAL.VtaTabla.LLave_c3
"VtaTabla.LLave_c3" "Articulo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[3]   > INTEGRAL.VtaTabla.Valor[1]
"VtaTabla.Valor[1]" "Pedido" ? "decimal" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaTabla.Valor[2]
"VtaTabla.Valor[2]" "Despachada" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"(INTEGRAL.VtaTabla.Valor[1] - INTEGRAL.VtaTabla.Valor[2]) @ lQtyPendiente" "Pëndiente" "->>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" ? ? "character" ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fpeso() @ lPeso" "Peso" ">>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Ratios Programacion */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Ratios Programacion */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnExcel W-Win
ON CHOOSE OF btnExcel IN FRAME F-Main /* Excel */
DO:
  RUN ue-excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-7
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
  DISPLAY txtCotizaciones txtDivision txtMetaDiaria txtProcesado txtNroDias 
          txtDesde txtHasta 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE btnExcel BROWSE-7 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-objects W-Win 
PROCEDURE local-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-objects':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-edit-attribute-list W-Win 
PROCEDURE local-edit-attribute-list :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'edit-attribute-list':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /*ratiodet.div-imp[2]:COLUMN-LABEL IN BROWSE BROWSE-7 = "Peru".*/

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
  FIND FIRST RatioCab WHERE RatioCab.CodDiv = pDivision NO-LOCK NO-ERROR.

  ASSIGN txtDivision = RatioCab.coddiv
    txtProcesado = ratiocab.fproceso
    txtDesde = ratiocab.fdesde
    txtHasta = ratiocab.fhasta
    txtCotizaciones = ratiocab.totcotiz
    txtMetaDiaria = ratiocab.meta
    txtNroDias = ratiocab.ndias.
    
    /*pDivision = RatioCab.coddiv.*/
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  FIND FIRST RatioCab WHERE RatioCab.CodDiv = pDivision NO-LOCK NO-ERROR.
/*
  /* Code placed here will execute AFTER standard behavior.    */
  tt-RatioDet.div-imp[1]:LABEL IN BROWSE BROWSE-7 = "Div.!" + RatioCab.div-vtas[1].
  tt-RatioDet.div-imp[2]:LABEL IN BROWSE BROWSE-7 = "Div.!" + RatioCab.div-vtas[2].
  tt-RatioDet.div-imp[3]:LABEL IN BROWSE BROWSE-7 = "Div.!" + RatioCab.div-vtas[3].
  tt-RatioDet.div-imp[4]:LABEL IN BROWSE BROWSE-7 = "Div.!" + RatioCab.div-vtas[4].
  tt-RatioDet.div-imp[5]:LABEL IN BROWSE BROWSE-7 = "Div.!" + RatioCab.div-vtas[5].
  tt-RatioDet.div-imp[6]:LABEL IN BROWSE BROWSE-7 = "Div.!" + RatioCab.div-vtas[6].
  tt-RatioDet.div-imp[7]:LABEL IN BROWSE BROWSE-7 = "Div.!" + RatioCab.div-vtas[7].
  tt-RatioDet.div-imp[8]:LABEL IN BROWSE BROWSE-7 = "Div.!" + RatioCab.div-vtas[8].
  tt-RatioDet.div-imp[9]:LABEL IN BROWSE BROWSE-7 = "Div.!" + RatioCab.div-vtas[9].
  tt-RatioDet.div-imp[10]:LABEL IN BROWSE BROWSE-7 = "Div.!" + RatioCab.div-vtas[10].

  tt-RatioDet.div-imp[1]:VISIBLE = IF (ratiocab.nDivisiones >= 1) THEN YES ELSE NO.
  tt-RatioDet.div-imp[2]:VISIBLE = IF (ratiocab.nDivisiones >= 2) THEN YES ELSE NO.
  tt-RatioDet.div-imp[3]:VISIBLE = IF (ratiocab.nDivisiones >= 3) THEN YES ELSE NO.
  tt-RatioDet.div-imp[4]:VISIBLE = IF (ratiocab.nDivisiones >= 4) THEN YES ELSE NO.
  tt-RatioDet.div-imp[5]:VISIBLE = IF (ratiocab.nDivisiones >= 5) THEN YES ELSE NO.
  tt-RatioDet.div-imp[6]:VISIBLE = IF (ratiocab.nDivisiones >= 6) THEN YES ELSE NO.
  tt-RatioDet.div-imp[7]:VISIBLE = IF (ratiocab.nDivisiones >= 7) THEN YES ELSE NO.
  tt-RatioDet.div-imp[8]:VISIBLE = IF (ratiocab.nDivisiones >= 8) THEN YES ELSE NO.
  tt-RatioDet.div-imp[9]:VISIBLE = IF (ratiocab.nDivisiones >= 9) THEN YES ELSE NO.
  tt-RatioDet.div-imp[10]:VISIBLE = IF (ratiocab.nDivisiones >= 10) THEN YES ELSE NO.
  tt-RatioDet.div-imp[11]:VISIBLE = IF (ratiocab.nDivisiones >= 11) THEN YES ELSE NO.
  tt-RatioDet.div-imp[12]:VISIBLE = IF (ratiocab.nDivisiones >= 12) THEN YES ELSE NO.
  tt-RatioDet.div-imp[13]:VISIBLE = IF (ratiocab.nDivisiones >= 13) THEN YES ELSE NO.
  tt-RatioDet.div-imp[14]:VISIBLE = IF (ratiocab.nDivisiones >= 14) THEN YES ELSE NO.
  tt-RatioDet.div-imp[15]:VISIBLE = IF (ratiocab.nDivisiones >= 15) THEN YES ELSE NO.
  tt-RatioDet.div-imp[16]:VISIBLE = IF (ratiocab.nDivisiones >= 16) THEN YES ELSE NO.
  tt-RatioDet.div-imp[17]:VISIBLE = IF (ratiocab.nDivisiones >= 17) THEN YES ELSE NO.
  tt-RatioDet.div-imp[18]:VISIBLE = IF (ratiocab.nDivisiones >= 18) THEN YES ELSE NO.
  tt-RatioDet.div-imp[19]:VISIBLE = IF (ratiocab.nDivisiones >= 19) THEN YES ELSE NO.
  tt-RatioDet.div-imp[20]:VISIBLE = IF (ratiocab.nDivisiones >= 20) THEN YES ELSE NO.
  tt-RatioDet.div-imp[21]:VISIBLE = IF (ratiocab.nDivisiones >= 21) THEN YES ELSE NO.
  tt-RatioDet.div-imp[22]:VISIBLE = IF (ratiocab.nDivisiones >= 22) THEN YES ELSE NO.
  tt-RatioDet.div-imp[23]:VISIBLE = IF (ratiocab.nDivisiones >= 23) THEN YES ELSE NO.
  tt-RatioDet.div-imp[24]:VISIBLE = IF (ratiocab.nDivisiones >= 24) THEN YES ELSE NO.
  tt-RatioDet.div-imp[25]:VISIBLE = IF (ratiocab.nDivisiones >= 25) THEN YES ELSE NO.
  /*
  MESSAGE RatioCab.coddiv.
  MESSAGE pDivision.
  
  FIND FIRST RatioCab WHERE RatioCab.CodDiv = pDivision NO-LOCK NO-ERROR.
  */
  {&OPEN-QUERY-BROWSE-7}
*/

 END PROCEDURE.

 /*Temp-Tables.tt-RatioDet*/

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
  {src/adm/template/snd-list.i "INTEGRAL.VtaTabla"}
  {src/adm/template/snd-list.i "INTEGRAL.Almmmatg"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel W-Win 
PROCEDURE ue-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */

SESSION:SET-WAIT-STATE('GENERAL').

{lib\excel-open-file.i}

/*chWorkSheet = chExcelApplication:Sheets:Item(2).  */
DEFINE VAR lSec1 AS INT.
DEFINE VAR lAsc AS INT.
DEFINE VAR lCelda AS CHAR.

iColumn = 1.
cColumn = STRING(iColumn).

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN txtDivision txtProcesado txtDesde txtHasta.
    ASSIGN txtCotizaciones txtMetaDiaria txtnroDias.
END.

FIND FIRST RatioCab WHERE RatioCab.CodDiv = pDivision NO-LOCK NO-ERROR.

cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Division :".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = IF(txtDivision='XXXXX') THEN "RESUMEN GRAL" ELSE txtDivision.

iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Procesado :".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = txtProcesado.

iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Desde :".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = txtDesde.
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Hasta :".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = txtHasta.

iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Total Cotizaciones :".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = txtCotizaciones.

iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Meta Diara :".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = txtMetaDiaria.

iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Nro dias :".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = txtNroDias.

iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Sec".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Dia Sem".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Fecha".
lAsc = 67.
DO lSec1 = 1 TO RatioCab.ndivisiones:
    lCelda = CHR(lAsc + lSec1).
    cRange = lCelda + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + RatioCab.div-vtas[lSec1].
END.

lCelda = CHR(lAsc + lSec1).
cRange = lCelda + cColumn.
chWorkSheet:Range(cRange):Value = "Total Dia".
lSec1 = lSec1 + 1.
lCelda = CHR(lAsc + lSec1).
cRange = lCelda + cColumn.
chWorkSheet:Range(cRange):Value = "Acumulado".
lSec1 = lSec1 + 1.
lCelda = CHR(lAsc + lSec1).
cRange = lCelda + cColumn.
chWorkSheet:Range(cRange):Value = "Meta diaria".
lSec1 = lSec1 + 1.
lCelda = CHR(lAsc + lSec1).
cRange = lCelda + cColumn.
chWorkSheet:Range(cRange):Value = "% Avance".

GET FIRST {&BROWSE-NAME}.
DO  WHILE AVAILABLE tt-ratiodet :
/*FOR EACH tt-ratiodet NO-LOCK:*/
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-ratiodet.sec.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-ratiodet.dia-sem.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-ratiodet.fecha.

    lAsc = 67.
    DO lSec1 = 1 TO RatioCab.ndivisiones:
        lCelda = CHR(lAsc + lSec1).
        cRange = lCelda + cColumn.
        chWorkSheet:Range(cRange):Value = tt-ratiodet.div-imp[lSec1].
    END.    
    lCelda = CHR(lAsc + lSec1).
    cRange = lCelda + cColumn.
    chWorkSheet:Range(cRange):Value = tt-ratiodet.tot-dia.
    lSec1 = lSec1 + 1.
    lCelda = CHR(lAsc + lSec1).
    cRange = lCelda + cColumn.
    chWorkSheet:Range(cRange):Value = tt-ratiodet.tot-acu.
    lSec1 = lSec1 + 1.
    lCelda = CHR(lAsc + lSec1).
    cRange = lCelda + cColumn.
    chWorkSheet:Range(cRange):Value = tt-ratiodet.meta-dia.
    lSec1 = lSec1 + 1.
    lCelda = CHR(lAsc + lSec1).
    cRange = lCelda + cColumn.
    chWorkSheet:Range(cRange):Value = tt-ratiodet.por-ava.

    GET NEXT {&BROWSE-NAME}.
END.

FIND FIRST RatioCab WHERE RatioCab.CodDiv = pDivision NO-LOCK NO-ERROR.

SESSION:SET-WAIT-STATE('').

{lib\excel-close-file.i}

*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPeso W-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR lRet AS DEC.

lRet = ((INTEGRAL.VtaTabla.Valor[1] - INTEGRAL.VtaTabla.Valor[2] ) * almmmatg.pesmat ).

  RETURN lret.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

