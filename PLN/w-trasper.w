&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW GLOBAL SHARED TEMP-TABLE tmp-TabPerArea NO-UNDO LIKE TabPerArea.
DEFINE NEW GLOBAL SHARED TEMP-TABLE tmp-TabPerArea-t NO-UNDO LIKE TabPerArea.



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
DEFINE SHARED VARIABLE s-codcia AS INT.
DEFINE SHARED VARIABLE s-user-id AS CHAR.
/* Local Variable Definitions ---                                       */

DEFINE VARIABLE cNomPer01 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNomPer02 AS CHARACTER   NO-UNDO.

DEFINE BUFFER b-tmp01 FOR tmp-tabperarea.
DEFINE BUFFER b-tmp02 FOR tmp-tabperarea-t.

DEFINE TEMP-TABLE tmp-02 LIKE tmp-tabperarea-t.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tmp-TabPerArea tmp-TabPerArea-t

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 tmp-TabPerArea.CodPer ~
tmp-TabPerArea.Libre_c01 tmp-TabPerArea.CodArea 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH tmp-TabPerArea ~
      WHERE tmp-TabPerArea.CodCia = s-codcia ~
 AND tmp-TabPerArea.Libre_c02 BEGINS cb-divi01 ~
 AND tmp-TabPerArea.FlgEst <> "P" NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH tmp-TabPerArea ~
      WHERE tmp-TabPerArea.CodCia = s-codcia ~
 AND tmp-TabPerArea.Libre_c02 BEGINS cb-divi01 ~
 AND tmp-TabPerArea.FlgEst <> "P" NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 tmp-TabPerArea
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 tmp-TabPerArea


/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 tmp-TabPerArea-t.CodPer ~
tmp-TabPerArea-t.Libre_c01 tmp-TabPerArea-t.Area_Destino 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH tmp-TabPerArea-t NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH tmp-TabPerArea-t NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 tmp-TabPerArea-t
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 tmp-TabPerArea-t


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cb-divi01 cb-divi02 BROWSE-3 cb-areas ~
BROWSE-4 btn-va btn-va-2 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS cb-divi01 txt-desdiv cb-divi02 ~
txt-desdiv-2 cb-areas 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-va 
     LABEL ">>" 
     SIZE 7 BY 1.88.

DEFINE BUTTON btn-va-2 
     LABEL "<<" 
     SIZE 7 BY 1.88.

DEFINE BUTTON BUTTON-2 
     LABEL "GRABAR" 
     SIZE 15 BY 1.35.

DEFINE VARIABLE cb-areas AS CHARACTER FORMAT "X(256)":U 
     LABEL "Areas" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 53.86 BY 1 NO-UNDO.

DEFINE VARIABLE cb-divi01 AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE cb-divi02 AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE txt-desdiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55.14 BY 1
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE txt-desdiv-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      tmp-TabPerArea SCROLLING.

DEFINE QUERY BROWSE-4 FOR 
      tmp-TabPerArea-t SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      tmp-TabPerArea.CodPer FORMAT "X(6)":U
      tmp-TabPerArea.Libre_c01 COLUMN-LABEL "Apellidos y Nombres" FORMAT "x(45)":U
      tmp-TabPerArea.CodArea COLUMN-LABEL "Área!Actual" FORMAT "x(8)":U
            WIDTH 14.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 71.57 BY 16.96 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      tmp-TabPerArea-t.CodPer FORMAT "X(6)":U
      tmp-TabPerArea-t.Libre_c01 COLUMN-LABEL "Apellidos y Nombres" FORMAT "x(45)":U
            WIDTH 40
      tmp-TabPerArea-t.Area_Destino FORMAT "x(8)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 65.43 BY 15.62 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cb-divi01 AT ROW 1.54 COL 8.43 COLON-ALIGNED WIDGET-ID 4
     txt-desdiv AT ROW 1.54 COL 17.86 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     cb-divi02 AT ROW 1.54 COL 92.72 COLON-ALIGNED WIDGET-ID 6
     txt-desdiv-2 AT ROW 1.54 COL 102 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     BROWSE-3 AT ROW 2.85 COL 2.43 WIDGET-ID 200
     cb-areas AT ROW 2.88 COL 92.72 COLON-ALIGNED WIDGET-ID 8
     BROWSE-4 AT ROW 4.23 COL 86.57 WIDGET-ID 300
     btn-va AT ROW 8.04 COL 77 WIDGET-ID 10
     btn-va-2 AT ROW 10.73 COL 77 WIDGET-ID 12
     BUTTON-2 AT ROW 20.12 COL 136 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 153.14 BY 20.88 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tmp-TabPerArea T "NEW GLOBAL SHARED" NO-UNDO INTEGRAL TabPerArea
      TABLE: tmp-TabPerArea-t T "NEW GLOBAL SHARED" NO-UNDO INTEGRAL TabPerArea
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Traslada Personal"
         HEIGHT             = 20.88
         WIDTH              = 153.14
         MAX-HEIGHT         = 21.27
         MAX-WIDTH          = 167.14
         VIRTUAL-HEIGHT     = 21.27
         VIRTUAL-WIDTH      = 167.14
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
/* BROWSE-TAB BROWSE-3 txt-desdiv-2 F-Main */
/* BROWSE-TAB BROWSE-4 cb-areas F-Main */
/* SETTINGS FOR FILL-IN txt-desdiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-desdiv-2 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.tmp-TabPerArea"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "Temp-Tables.tmp-TabPerArea.CodCia = s-codcia
 AND Temp-Tables.tmp-TabPerArea.Libre_c02 BEGINS cb-divi01
 AND Temp-Tables.tmp-TabPerArea.FlgEst <> ""P"""
     _FldNameList[1]   = Temp-Tables.tmp-TabPerArea.CodPer
     _FldNameList[2]   > Temp-Tables.tmp-TabPerArea.Libre_c01
"tmp-TabPerArea.Libre_c01" "Apellidos y Nombres" "x(45)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tmp-TabPerArea.CodArea
"tmp-TabPerArea.CodArea" "Área!Actual" ? "character" ? ? ? ? ? ? no ? no no "14.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.tmp-TabPerArea-t"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.tmp-TabPerArea-t.CodPer
     _FldNameList[2]   > Temp-Tables.tmp-TabPerArea-t.Libre_c01
"tmp-TabPerArea-t.Libre_c01" "Apellidos y Nombres" "x(45)" "character" ? ? ? ? ? ? no ? no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.tmp-TabPerArea-t.Area_Destino
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Traslada Personal */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Traslada Personal */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-va
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-va W-Win
ON CHOOSE OF btn-va IN FRAME F-Main /* >> */
DO:
    IF cb-areas = '' THEN DO:
        MESSAGE "Debe elegir al area que desea trasladar"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN NO-APPLY.
    END.
    RUN Tralada_Per.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-va-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-va-2 W-Win
ON CHOOSE OF btn-va-2 IN FRAME F-Main /* << */
DO:
    RUN Cancela_Tras.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* GRABAR */
DO:

    RUN Graba-Traslados.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-areas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-areas W-Win
ON VALUE-CHANGED OF cb-areas IN FRAME F-Main /* Areas */
DO:
  
    ASSIGN cb-areas.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-divi01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-divi01 W-Win
ON VALUE-CHANGED OF cb-divi01 IN FRAME F-Main /* Division */
DO:
    ASSIGN cb-divi01.
      
    {&OPEN-QUERY-BROWSE-3}
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-divi02
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-divi02 W-Win
ON VALUE-CHANGED OF cb-divi02 IN FRAME F-Main /* Division */
DO:
    ASSIGN cb-divi02.
    cb-areas:LIST-ITEMS = "".
    FOR EACH tabareas WHERE tabareas.codcia = s-codcia
        AND tabareas.coddiv = cb-divi02 NO-LOCK:
        cb-areas:ADD-LAST(tabareas.codarea + "-" + tabareas.desarea).
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancela_Tras W-Win 
PROCEDURE Cancela_Tras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR i         AS INT NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
      DO i = 1 TO BROWSE-4:NUM-SELECTED-ROWS:
        IF BROWSE-4:FETCH-SELECTED-ROW(i) THEN DO:
            MESSAGE tmp-tabperarea-t.codper SKIP
                tmp-tabperarea-t.libre_c03.
            /*Crea segundo Temporal*/
            FIND FIRST tmp-tabperarea WHERE tmp-tabperarea.codcia = tmp-tabperarea-t.codcia
                AND tmp-tabperarea.codper = tmp-tabperarea-t.codper NO-LOCK NO-ERROR.
            IF NOT AVAIL tmp-tabperarea THEN DO:
                CREATE tmp-tabperarea.
                BUFFER-COPY tmp-tabperarea-t TO tmp-tabperarea
                    ASSIGN
                        tmp-tabperarea.area_destino = ""
                        tmp-tabperarea.libre_c02    = tmp-tabperarea-t.libre_c03
                        tmp-tabperarea-t.libre_c03  = "". /*Division Origen*/
            END.
            FIND FIRST b-tmp02 WHERE ROWID(b-tmp02) = ROWID(tmp-tabperarea-t) NO-ERROR.
            IF AVAIL b-tmp02 THEN DELETE b-tmp02.
        END.
      END.
  END.

  {&OPEN-QUERY-BROWSE-3}
  {&OPEN-QUERY-BROWSE-4}

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
  DISPLAY cb-divi01 txt-desdiv cb-divi02 txt-desdiv-2 cb-areas 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE cb-divi01 cb-divi02 BROWSE-3 cb-areas BROWSE-4 btn-va btn-va-2 
         BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Traslados W-Win 
PROCEDURE Graba-Traslados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cNroDoc AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE i       AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cName   AS CHARACTER   NO-UNDO.

  /*Valida si hay registros*/
  FIND FIRST tmp-tabperarea-t NO-LOCK NO-ERROR.
  IF NOT AVAIL tmp-tabperarea-t THEN RETURN NO-APPLY.

  /*Busca Pendientes*/
  DO WITH FRAME {&FRAME-NAME}:
      Browsse:
      FOR EACH tmp-tabperarea-t NO-LOCK:
          FIND FIRST TabDMovPer WHERE TabDMovPer.CodCia = s-codcia
              /*AND TabDMovPer.CodDiv  = cb-divi*/
              AND TabDMovPer.CodPer  = tmp-tabperarea-t.codper
              AND TabDMovPer.Libre_c01 = "P" NO-LOCK NO-ERROR.
          IF AVAIL TabDMovPer THEN DO: 
              CASE TabDMovPer.TipMov :
                  WHEN "T" THEN cName = "TRANSFERENCIA".
                  WHEN "P" THEN cName = "CAMBIO DE CARGO".
                  WHEN "C" THEN cName = "CESE".
              END CASE.
              MESSAGE "El Personal " + TabDMovPer.CodPer + " registra un(a) " SKIP
                  cName + " Pendiente."
                  VIEW-AS ALERT-BOX INFO BUTTONS OK.
              NEXT Browsse.
          END.
          CREATE tmp-02.
          BUFFER-COPY tmp-tabperarea-t TO tmp-02.
      END.
  END.

  /*Busca Nrodoc*/
  FIND LAST TabCMovPer WHERE TabCMovPer.codcia = s-codcia
      AND TabCMovPer.CodDiv = cb-divi02 NO-LOCK NO-ERROR.
  IF NOT AVAIL TabCMovPer THEN 
      cNroDoc = STRING(INT(cb-divi02),"999") + STRING(1,"999999").
  ELSE cNroDoc = STRING(INT(cb-divi02),"999") + STRING(INT(SUBSTRING(TabCMovPer.NroDoc,4)) + 1,"999999").

   
  /*Crea Cabecera*/
  FIND FIRST TabCMovPer WHERE TabcMovPer.CodCia = s-codcia
      AND TabCMovPer.CodDiv = cb-divi02
      AND TabCMovPer.NroDoc = cNroDoc NO-ERROR.
  IF NOT AVAIL TabCMovPer THEN DO:
      CREATE TabCMovPer.
      ASSIGN  
          TabCMovPer.CodCia           = s-codcia 
          TabCMovPer.CodDiv           = cb-divi02
          TabCMovPer.FchMov           = DATETIME(TODAY,MTIME)
          TabCMovPer.FlgEst           = "P"
          TabCMovPer.TipMov           = "T"
          TabCMovPer.NroDoc           = cNroDoc
          TabCMovPer.Observaciones    = ""                   
          TabCMovPer.UsrMov           = s-user-id.
  END.

  FOR EACH tmp-02 WHERE tmp-02.codcia = s-codcia NO-LOCK:
      /*Crea Detalle*/
      CREATE TabDMovPer.
      ASSIGN
          TabDMovPer.CodCia           = s-codcia
          TabDMovPer.NroDoc           = cNroDoc
          TabDMovPer.CodDiv           = cb-divi02
          TabDMovPer.CodPer           = tmp-02.CodPer
          TabDMovPer.AreaDes          = tmp-02.Area_Destino
          TabDMovPer.AreaOri          = tmp-02.CodArea
          TabDMovPer.Libre_c01        = "P"
          TabDMovPer.Observaciones    = "Traslado al Área " + tmp-02.Area_Destino
          TabDMovPer.TipMov           = "T".

      FIND FIRST TabPerArea WHERE TabPerArea.CodCia = s-codcia
          AND TabPerArea.CodPer = tmp-02.CodPer NO-ERROR.
      IF AVAIL TabPerArea THEN ASSIGN TabPerArea.FlgEst = "P".            
  END.

  /*Borra Temporal*/
  EMPTY TEMP-TABLE tmp-tabperarea-t.

  {&OPEN-QUERY-BROWSE-3}
  {&OPEN-QUERY-BROWSE-4}


/*     FOR EACH tmp-tabperarea-t WHERE tmp-tabperarea-t.codcia = s-codcia NO-LOCK:     */
/*         FIND FIRST TabPerArea WHERE TabPerArea.CodCia = s-codcia                    */
/*             AND TabPerArea.CodPer = tmp-TabPerArea-t.CodPer NO-ERROR.               */
/*         IF AVAIL TabPerArea THEN DO:                                                */
/*             ASSIGN                                                                  */
/*                 TabPerArea.Area_Destino     = tmp-TabPerArea-t.Area_Destino         */
/*                 TabPerArea.FchDoc_Solicita  = DATETIME(TODAY,MTIME)                 */
/*                 TabPerArea.FlgEst           = "P"                                   */
/*                 TabPerArea.Usr_Solicita     = s-user-id.                            */
/*         END.                                                                        */
/*         /*Borra PEndientes*/                                                        */
/*         FIND FIRST b-tmp02 WHERE ROWID(b-tmp02) = ROWID(tmp-tabperarea-t) NO-ERROR. */
/*         IF AVAIL b-tmp02 THEN DELETE b-tmp02.                                       */
/*     END.                                                                            */


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
  
  EMPTY TEMP-TABLE tmp-tabperarea.
  EMPTY TEMP-TABLE tmp-tabperarea-t.
  
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:
          cb-divi01:ADD-LAST(STRING(gn-divi.coddiv,"99999")).
          cb-divi02:ADD-LAST(STRING(gn-divi.coddiv,"99999")).
      END.

      /*Carga-Temporal TabPerArea*/
      FOR EACH TabPerArea WHERE TabPerArea.CodCia = s-codcia NO-LOCK:
          CREATE tmp-TabPerArea.
          BUFFER-COPY TabPerArea TO tmp-TabPerArea. 
          /*Busca Datos Personal*/
          FIND FIRST Pl-Pers WHERE Pl-Pers.CodCia = s-codcia
              AND Pl-Pers.CodPer = TabPerArea.CodPer NO-LOCK NO-ERROR.
          IF AVAIL Pl-Pers THEN 
              tmp-TabPerArea.Libre_C01 = pl-pers.patper + ' ' + pl-pers.matper + ',' + pl-pers.nomper.

          /*Busca Area*/
          FIND FIRST TabAreas WHERE TabAreas.Codcia = s-codcia
              AND TabAreas.CodArea = TabPerArea.CodArea NO-LOCK NO-ERROR.
          IF AVAIL TabAreas THEN tmp-TabPerArea.Libre_c02 = TabAreas.CodDiv.

      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "tmp-TabPerArea-t"}
  {src/adm/template/snd-list.i "tmp-TabPerArea"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Tralada_Per W-Win 
PROCEDURE Tralada_Per :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR i         AS INT NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
      DO i = 1 TO BROWSE-3:NUM-SELECTED-ROWS:
        IF BROWSE-3:FETCH-SELECTED-ROW(i) THEN DO:
            /*Crea segundo Temporal*/
            FIND FIRST tmp-tabperarea-t WHERE tmp-tabperarea-t.codcia = tmp-tabperarea.codcia
                AND tmp-tabperarea-t.codper = tmp-tabperarea.codper NO-LOCK NO-ERROR.
            IF NOT AVAIL tmp-tabperarea-t THEN DO:
                CREATE tmp-tabperarea-t.
                BUFFER-COPY tmp-tabperarea TO tmp-tabperarea-t
                    ASSIGN
                        tmp-tabperarea-t.area_destino = SUBSTRING(cb-areas,1,3)
                        tmp-tabperarea-t.libre_c03    = tmp-tabperarea.libre_c02 /*Division Origen*/
                        tmp-tabperarea-t.libre_c02    = cb-divi02.  /*Division Destino*/
            END.
            FIND FIRST b-tmp01 WHERE ROWID(b-tmp01) = ROWID(tmp-tabperarea) NO-ERROR.
            IF AVAIL b-tmp01 THEN DELETE b-tmp01.
        END.
      END.
  END.

  {&OPEN-QUERY-BROWSE-3}
  {&OPEN-QUERY-BROWSE-4}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

