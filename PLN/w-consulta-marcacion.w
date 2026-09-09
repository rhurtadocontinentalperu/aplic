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
DEFINE SHARED VAR s-codcia AS INT.

DEFINE VAR dDesde AS DATE.
DEFINE VAR dHasta AS DATE.
DEFINE VAR cCodPer AS CHAR.
DEFINE VAR X-relojName AS CHAR.
DEFINE VAR X-seccion AS CHAR.

cCodPer    = "".
dDesde      = TODAY - 15.
dHasta      = TODAY.

&SCOPED-DEFINE CONDICION (INTEGRAL.AS-MARC.CodCia = s-codcia  ~
             AND (INTEGRAL.AS-MARC.FchMar >= dDesde AND INTEGRAL.AS-MARC.FchMar <= dHasta ) ~
            AND INTEGRAL.AS-MARC.codper BEGINS cCodPer)

/*&SCOPED-DEFINE CONDICION faccpedi.codcia = s-codcia ~*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-5

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES INTEGRAL.AS-MARC INTEGRAL.PL-PERS

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 INTEGRAL.AS-MARC.CodPer ~
INTEGRAL.AS-MARC.FchMar INTEGRAL.AS-MARC.HorMar ~
fRelojName(INTEGRAL.AS-MARC.Id-Session) @ X-relojName ~
INTEGRAL.PL-PERS.patper INTEGRAL.PL-PERS.matper INTEGRAL.PL-PERS.nomper ~
fSeccion(INTEGRAL.AS-MARC.FchMar,INTEGRAL.AS-MARC.CodPer) @ X-seccion 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH INTEGRAL.AS-MARC ~
      WHERE {&CONDICION} NO-LOCK, ~
      FIRST INTEGRAL.PL-PERS WHERE PL-PERS.codcia = as-marc.codcia and PL-PERS.codper =  AS-MARC.CodPer NO-LOCK ~
    BY INTEGRAL.AS-MARC.CodPer ~
       BY INTEGRAL.AS-MARC.FchMar ~
        BY INTEGRAL.AS-MARC.HorMar
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH INTEGRAL.AS-MARC ~
      WHERE {&CONDICION} NO-LOCK, ~
      FIRST INTEGRAL.PL-PERS WHERE PL-PERS.codcia = as-marc.codcia and PL-PERS.codper =  AS-MARC.CodPer NO-LOCK ~
    BY INTEGRAL.AS-MARC.CodPer ~
       BY INTEGRAL.AS-MARC.FchMar ~
        BY INTEGRAL.AS-MARC.HorMar.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 INTEGRAL.AS-MARC INTEGRAL.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 INTEGRAL.AS-MARC
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-5 INTEGRAL.PL-PERS


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btnExcel btnAceptar txtDesde txtHasta ~
txtCodPer BROWSE-5 
&Scoped-Define DISPLAYED-OBJECTS txtDesde txtHasta txtCodPer txtNomPer 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fRelojName W-Win 
FUNCTION fRelojName RETURNS CHARACTER
  ( INPUT iNumPRCID AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSeccion W-Win 
FUNCTION fSeccion RETURNS CHARACTER
  ( INPUT fMarca AS DATE, INPUT cCodPer AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnAceptar 
     LABEL "Refrescar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON btnExcel 
     LABEL "Excel" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtCodPer AS CHARACTER FORMAT "X(256)":U 
     LABEL "Trabajador" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtNomPer AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.57 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      INTEGRAL.AS-MARC, 
      INTEGRAL.PL-PERS
    FIELDS(INTEGRAL.PL-PERS.patper
      INTEGRAL.PL-PERS.matper
      INTEGRAL.PL-PERS.nomper) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      INTEGRAL.AS-MARC.CodPer FORMAT "x(6)":U
      INTEGRAL.AS-MARC.FchMar FORMAT "99/99/9999":U WIDTH 10.57
      INTEGRAL.AS-MARC.HorMar FORMAT "x(5)":U WIDTH 7.86
      fRelojName(INTEGRAL.AS-MARC.Id-Session) @ X-relojName COLUMN-LABEL "Reloj"
            WIDTH 11
      INTEGRAL.PL-PERS.patper FORMAT "X(40)":U WIDTH 14.72
      INTEGRAL.PL-PERS.matper FORMAT "X(40)":U WIDTH 15.14
      INTEGRAL.PL-PERS.nomper FORMAT "X(40)":U WIDTH 15.43
      fSeccion(INTEGRAL.AS-MARC.FchMar,INTEGRAL.AS-MARC.CodPer) @ X-seccion COLUMN-LABEL "Seccion" FORMAT "X(50)":U
            WIDTH 24.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 113 BY 16.73 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     btnExcel AT ROW 1.58 COL 59 WIDGET-ID 12
     btnAceptar AT ROW 1.58 COL 76 WIDGET-ID 10
     txtDesde AT ROW 1.77 COL 11 COLON-ALIGNED WIDGET-ID 2
     txtHasta AT ROW 1.81 COL 34.29 COLON-ALIGNED WIDGET-ID 4
     txtCodPer AT ROW 3.12 COL 11 COLON-ALIGNED WIDGET-ID 6
     txtNomPer AT ROW 3.12 COL 25.14 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     BROWSE-5 AT ROW 4.65 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 114.43 BY 20.73 WIDGET-ID 100.


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
         TITLE              = "Consulta de Marcaciones"
         HEIGHT             = 20.81
         WIDTH              = 114.57
         MAX-HEIGHT         = 20.81
         MAX-WIDTH          = 114.57
         VIRTUAL-HEIGHT     = 20.81
         VIRTUAL-WIDTH      = 114.57
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-5 txtNomPer F-Main */
/* SETTINGS FOR FILL-IN txtNomPer IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "INTEGRAL.AS-MARC,INTEGRAL.PL-PERS WHERE INTEGRAL.AS-MARC    ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST USED"
     _OrdList          = "INTEGRAL.AS-MARC.CodPer|yes,INTEGRAL.AS-MARC.FchMar|yes,INTEGRAL.AS-MARC.HorMar|yes"
     _Where[1]         = "{&CONDICION}"
     _JoinCode[2]      = "PL-PERS.codcia = as-marc.codcia and PL-PERS.codper =  AS-MARC.CodPer"
     _FldNameList[1]   = INTEGRAL.AS-MARC.CodPer
     _FldNameList[2]   > INTEGRAL.AS-MARC.FchMar
"AS-MARC.FchMar" ? "99/99/9999" "date" ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.AS-MARC.HorMar
"AS-MARC.HorMar" ? ? "character" ? ? ? ? ? ? no ? no no "7.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fRelojName(INTEGRAL.AS-MARC.Id-Session) @ X-relojName" "Reloj" ? ? ? ? ? ? ? ? no ? no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.PL-PERS.patper
"PL-PERS.patper" ? ? "character" ? ? ? ? ? ? no ? no no "14.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.PL-PERS.matper
"PL-PERS.matper" ? ? "character" ? ? ? ? ? ? no ? no no "15.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.PL-PERS.nomper
"PL-PERS.nomper" ? ? "character" ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"fSeccion(INTEGRAL.AS-MARC.FchMar,INTEGRAL.AS-MARC.CodPer) @ X-seccion" "Seccion" "X(50)" ? ? ? ? ? ? ? no ? no no "24.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Consulta de Marcaciones */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Consulta de Marcaciones */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnAceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnAceptar W-Win
ON CHOOSE OF btnAceptar IN FRAME F-Main /* Refrescar */
DO:
  ASSIGN txtDesde txtHasta txtCodPer txtNomPer.

  IF txtDesde > txtHasta THEN DO:
      MESSAGE "Rango de Fechas erradas.." VIEW-AS ALERT-BOX.
      RETURN NO-APPLY.
  END.
  IF txtCodPer <> "" THEN DO:
      FIND FIRST pl-pers WHERE pl-pers.codcia = s-codcia AND pl-pers.codper = txtCodPer
          NO-LOCK NO-ERROR.
        IF NOT AVAILABLE pl-pers THEN DO:
            MESSAGE "Codigo no existe.." VIEW-AS ALERT-BOX.
            RETURN NO-APPLY.
        END.
  END.
  
    cCodPer    = txtCodPer.
    dDesde      = txtDesde.
    dHasta      = txtHasta.

  {&OPEN-QUERY-BROWSE-5}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnExcel W-Win
ON CHOOSE OF btnExcel IN FRAME F-Main /* Excel */
DO:
  ASSIGN txtDesde txtHasta txtCodPer txtNomPer.

  RUN ue-excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCodPer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCodPer W-Win
ON LEAVE OF txtCodPer IN FRAME F-Main /* Trabajador */
DO:
    txtNomPer:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

    IF txtCodPer:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN DO:
        FIND FIRST pl-pers WHERE pl-pers.codcia = s-codcia 
            AND pl-pers.codper = txtCodPer:SCREEN-VALUE IN FRAME {&FRAME-NAME}
            NO-LOCK NO-ERROR.
          IF AVAILABLE pl-pers THEN DO:
              txtNomPer:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pl-pers.patper + " " + 
                  pl-pers.matper + " " + pl-pers.nomper.
          END.
    END.
  
    ASSIGN txtCodPer.

    cCodPer = txtCodPer.

    ASSIGN {&self-name}.
      {&OPEN-QUERY-{&BROWSE-NAME}} 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtDesde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtDesde W-Win
ON LEAVE OF txtDesde IN FRAME F-Main /* Desde */
DO:
  ASSIGN txtDesde txtHasta txtCodPer txtNomPer.

    dDesde      = txtDesde.
    dHasta      = txtHasta.

    ASSIGN {&self-name}.
      {&OPEN-QUERY-{&BROWSE-NAME}}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtHasta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtHasta W-Win
ON LEAVE OF txtHasta IN FRAME F-Main /* Hasta */
DO:
    ASSIGN txtDesde txtHasta txtCodPer txtNomPer.

      dDesde      = txtDesde.
      dHasta      = txtHasta.
  
    ASSIGN {&self-name}.
      {&OPEN-QUERY-{&BROWSE-NAME}} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
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
  DISPLAY txtDesde txtHasta txtCodPer txtNomPer 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE btnExcel btnAceptar txtDesde txtHasta txtCodPer BROWSE-5 
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

  txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 15,"99/99/9999").
  txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").
  txtCodPer:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
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
        WHEN "" THEN .
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
  {src/adm/template/snd-list.i "INTEGRAL.AS-MARC"}
  {src/adm/template/snd-list.i "INTEGRAL.PL-PERS"}

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

        DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
        DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
        DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

        DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

        DEFINE VARIABLE iCount                  AS INTEGER init 1.
        DEFINE VARIABLE iIndex                  AS INTEGER.
        DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
        DEFINE VARIABLE cColumn                 AS CHARACTER.
        DEFINE VARIABLE cRange                  AS CHARACTER.
        DEFINE VARIABLE x-signo                 AS DECI.

        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = FALSE.

        /* Para crear a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

        /* set the column names for the Worksheet */

        chWorkSheet:Range("E1"):Font:Bold = TRUE.
        chWorkSheet:Range("E1"):Value = "MARCACIONES DESDE :" + STRING(txtDesde,"99/99/9999") + 
            "   HASTA :" + STRING(txtHasta,"99/99/9999").

        chWorkSheet:Range("A2:R2"):Font:Bold = TRUE.
        chWorkSheet:Range("A2"):Value = "CODIGO".
        chWorkSheet:Range("B2"):Value = "FECHA".
        chWorkSheet:Range("C2"):Value = "HORA".
        chWorkSheet:Range("D2"):Value = "RELOJ".
        chWorkSheet:Range("E2"):Value = "AP.PATERNO".
        chWorkSheet:Range("F2"):Value = "AP.MATERNO".
        chWorkSheet:Range("G2"):Value = "NOMBRES".
        chWorkSheet:Range("H2"):Value = "SECCION".

iColumn = 2.

GET FIRST {&BROWSE-NAME}.
DO WHILE AVAILABLE AS-marc:
     iColumn = iColumn + 1.
     cColumn = STRING(iColumn).

     cRange = "A" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + AS-marc.codper.
     cRange = "B" + cColumn.
     chWorkSheet:Range(cRange):Value = AS-marc.fchmar.
     cRange = "C" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + AS-marc.Hormar.
     cRange = "D" + cColumn.
     chWorkSheet:Range(cRange):Value = fRelojName(AS-marc.id-session).
     cRange = "E" + cColumn.
     chWorkSheet:Range(cRange):Value = pl-pers.patper.
     cRange = "F" + cColumn.
     chWorkSheet:Range(cRange):Value = pl-pers.matper.
     cRange = "G" + cColumn.
     chWorkSheet:Range(cRange):Value = pl-pers.nomper.
     cRange = "H" + cColumn.
     chWorkSheet:Range(cRange):Value = fSeccion(AS-marc.fchmar,AS-marc.codper).

    GET NEXT {&BROWSE-NAME}.
END.

/* release com-handles */

chExcelApplication:Visible = TRUE.

RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 

MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-procesar W-Win 
PROCEDURE ue-procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fRelojName W-Win 
FUNCTION fRelojName RETURNS CHARACTER
  ( INPUT iNumPRCID AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST AdmCtrlUsers WHERE AdmCtrlUsers.numid = iNumPRCID NO-LOCK NO-ERROR.
    IF AVAILABLE AdmCtrlUsers THEN DO:
        RETURN AdmCtrlUsers.PCusuario.
    END.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSeccion W-Win 
FUNCTION fSeccion RETURNS CHARACTER
  ( INPUT fMarca AS DATE, INPUT cCodPer AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR lPeriodo AS INT.
    DEFINE VAR lmes AS INT.

    lPeriodo = YEAR(fMarca).
    lMes = MONTH(fMarca).
    FIND LAST pl-flg-mes WHERE pl-flg-mes.codcia = s-codcia AND 
        pl-flg-mes.codper = cCodPer AND 
        (pl-flg-mes.periodo <= lPeriodo AND pl-flg-mes.nromes <= lMes)
        NO-LOCK NO-ERROR.
    IF AVAILABLE pl-flg-mes THEN DO:
        RETURN pl-flg-mes.seccion.
    END.


  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

