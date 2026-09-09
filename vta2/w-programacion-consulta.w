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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-5 RECT-6 RECT-7 RECT-8 RECT-9 RECT-10 ~
btnHistoria btnReposiciones btnDivisiones 
&Scoped-Define DISPLAYED-OBJECTS txtDivision txtProcesado txtDesde txtHasta ~
txtCotizaciones txtVentasAcumuladas txtVentasxAtender txtMetaDiaria ~
txtNuevaMetaDiaria txtNroDias txtNroDiasRestantes txtNroDiasFaltantes ~
txtPorAvance 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnDivisiones 
     LABEL "Divisiones" 
     SIZE 15 BY 1.12.

DEFINE BUTTON btnHistoria 
     LABEL "Ver  historial" 
     SIZE 15 BY 1.12.

DEFINE BUTTON btnReposiciones 
     LABEL "Reposiciones" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtCotizaciones AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 33.43 BY 1.35
     FGCOLOR 14 FONT 8 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Rango Fechas  -  Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtDivision AS CHARACTER FORMAT "X(50)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 43 BY 1
     FONT 8 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtMetaDiaria AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 33 BY 1.42
     FONT 8 NO-UNDO.

DEFINE VARIABLE txtNroDias AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1.5
     FGCOLOR 10 FONT 8 NO-UNDO.

DEFINE VARIABLE txtNroDiasFaltantes AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1.5
     FGCOLOR 10 FONT 8 NO-UNDO.

DEFINE VARIABLE txtNroDiasRestantes AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1.5
     FGCOLOR 10 FONT 8 NO-UNDO.

DEFINE VARIABLE txtNuevaMetaDiaria AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 32 BY 1.54
     FONT 8 NO-UNDO.

DEFINE VARIABLE txtPorAvance AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1.54
     FGCOLOR 6 FONT 8 NO-UNDO.

DEFINE VARIABLE txtProcesado AS DATE FORMAT "99/99/9999":U 
     LABEL "Proceso" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtVentasAcumuladas AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 32 BY 1.35
     FGCOLOR 9 FONT 8 NO-UNDO.

DEFINE VARIABLE txtVentasxAtender AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 31.72 BY 1.35
     FGCOLOR 9 FONT 8 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39 BY .15.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 144.86 BY 14.77.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 144.86 BY .15.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 1 BY 14.77.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE .86 BY 14.77.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 1 BY 14.77.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txtDivision AT ROW 1.77 COL 7.72 COLON-ALIGNED WIDGET-ID 18
     txtProcesado AT ROW 1.77 COL 62 COLON-ALIGNED WIDGET-ID 20
     txtDesde AT ROW 1.81 COL 99.72 COLON-ALIGNED WIDGET-ID 22
     txtHasta AT ROW 3.04 COL 100 COLON-ALIGNED WIDGET-ID 24
     txtCotizaciones AT ROW 8.5 COL 30.43 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     txtVentasAcumuladas AT ROW 8.5 COL 68.29 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     txtVentasxAtender AT ROW 8.5 COL 107 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     txtMetaDiaria AT ROW 11 COL 30.43 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     txtNuevaMetaDiaria AT ROW 11 COL 107.14 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     txtNroDias AT ROW 13.27 COL 30.14 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     txtNroDiasRestantes AT ROW 13.31 COL 68.29 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     txtNroDiasFaltantes AT ROW 13.31 COL 107.14 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     txtPorAvance AT ROW 17.46 COL 76.72 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     btnHistoria AT ROW 20.62 COL 14.14 WIDGET-ID 70
     btnReposiciones AT ROW 20.62 COL 46.57 WIDGET-ID 72
     btnDivisiones AT ROW 20.62 COL 112 WIDGET-ID 74
     "Por atender" VIEW-AS TEXT
          SIZE 29 BY 1.54 AT ROW 5.42 COL 109.29 WIDGET-ID 60
          BGCOLOR 10 FGCOLOR 15 FONT 30
     "Dias :" VIEW-AS TEXT
          SIZE 13.14 BY 1.54 AT ROW 13.23 COL 16.14 WIDGET-ID 40
          FGCOLOR 4 FONT 8
     "Facturacion" VIEW-AS TEXT
          SIZE 35.57 BY 1.54 AT ROW 5.46 COL 70.43 WIDGET-ID 42
          BGCOLOR 9 FGCOLOR 15 FONT 30
     "% Avance" VIEW-AS TEXT
          SIZE 23.86 BY 1.54 AT ROW 16 COL 75.57 WIDGET-ID 56
          FGCOLOR 14 FONT 8
     "Cotizaciones" VIEW-AS TEXT
          SIZE 29 BY 1.54 AT ROW 5.42 COL 32.43 WIDGET-ID 34
          BGCOLOR 15 FGCOLOR 9 FONT 30
     "Ventas :" VIEW-AS TEXT
          SIZE 18 BY 1.54 AT ROW 8.27 COL 11.72 WIDGET-ID 36
          FGCOLOR 4 FONT 8
     "Meta diaria :" VIEW-AS TEXT
          SIZE 27.86 BY 1.54 AT ROW 10.88 COL 2.14 WIDGET-ID 38
          FGCOLOR 4 FONT 8
     RECT-5 AT ROW 4.88 COL 1.14 WIDGET-ID 32
     RECT-6 AT ROW 7.42 COL 1.14 WIDGET-ID 76
     RECT-7 AT ROW 4.88 COL 30 WIDGET-ID 78
     RECT-8 AT ROW 4.88 COL 67.57 WIDGET-ID 80
     RECT-9 AT ROW 4.88 COL 107 WIDGET-ID 82
     RECT-10 AT ROW 15.31 COL 68.29 WIDGET-ID 84
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
         HEIGHT             = 21.54
         WIDTH              = 145
         MAX-HEIGHT         = 26.35
         MAX-WIDTH          = 145.14
         VIRTUAL-HEIGHT     = 26.35
         VIRTUAL-WIDTH      = 145.14
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
/* SETTINGS FOR FILL-IN txtNroDiasFaltantes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtNroDiasRestantes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtNuevaMetaDiaria IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtPorAvance IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtProcesado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtVentasAcumuladas IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtVentasxAtender IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
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


&Scoped-define SELF-NAME btnHistoria
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnHistoria W-Win
ON CHOOSE OF btnHistoria IN FRAME F-Main /* Ver  historial */
DO:
  RUN vta2/w-programacion-consulta-historia.r (INPUT pDivision).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnReposiciones
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnReposiciones W-Win
ON CHOOSE OF btnReposiciones IN FRAME F-Main /* Reposiciones */
DO:
  RUN vta2/w-programacion-consulta-articulos.r.
    /*RUN vta2/w-programacion-consulta-historia.r (INPUT pDivision).*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DISPLAY txtDivision txtProcesado txtDesde txtHasta txtCotizaciones 
          txtVentasAcumuladas txtVentasxAtender txtMetaDiaria txtNuevaMetaDiaria 
          txtNroDias txtNroDiasRestantes txtNroDiasFaltantes txtPorAvance 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-5 RECT-6 RECT-7 RECT-8 RECT-9 RECT-10 btnHistoria btnReposiciones 
         btnDivisiones 
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

  ASSIGN txtDivision = if(RatioCab.coddiv='XXXXX') THEN 'TOTAL GENERAL' ELSE ratiocab.coddiv
    txtProcesado = ratiocab.fproceso
    txtDesde = ratiocab.fdesde
    txtHasta = ratiocab.fhasta
    txtCotizaciones = ratiocab.totcotiz
    txtMetaDiaria = ratiocab.meta
    txtNroDias = ratiocab.ndias.

FIND FIRST RatioDet WHERE RatioDet.CodDiv = pDivision AND
        RatioDet.fecha = ratiocab.fproceso
        NO-LOCK NO-ERROR.
ASSIGN txtVentasAcumuladas = ratiodet.tot-acu        
        txtNroDiasRestantes = ratiodet.sec
        txtPorAvance = ratiodet.por-ava.
ASSIGN txtVentasxAtender = ratiocab.totcotiz - ratiodet.tot-acu
        txtNroDiasFaltantes = ratiocab.ndias - ratiodet.sec 
        txtNuevaMetaDiaria = ratiodet.meta-dia.
    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  


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

