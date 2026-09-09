&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW GLOBAL SHARED TEMP-TABLE tmp-TabPerArea NO-UNDO LIKE TabPerArea.



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

DEFINE SHARED VAR s-codcia    AS INT.
DEFINE SHARED VAR s-user-id   AS CHAR.

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE tmp-tabla LIKE tmp-tabperarea.

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
&Scoped-define INTERNAL-TABLES tmp-TabPerArea

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tmp-TabPerArea.CodPer ~
tmp-TabPerArea.Libre_c01 tmp-TabPerArea.CodArea 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tmp-TabPerArea ~
      WHERE tmp-TabPerArea.Libre_c02 BEGINS cb-divi NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tmp-TabPerArea ~
      WHERE tmp-TabPerArea.Libre_c02 BEGINS cb-divi NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tmp-TabPerArea
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tmp-TabPerArea


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cb-divi BROWSE-2 BUTTON-3 txt-obs 
&Scoped-Define DISPLAYED-OBJECTS cb-divi txt-desdiv txt-obs txt-msje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     LABEL "CESAR PERSONAL" 
     SIZE 21 BY 1.12.

DEFINE VARIABLE cb-divi AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE txt-desdiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 77 BY 1
     BGCOLOR 7 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE txt-msje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 100 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE txt-obs AS CHARACTER FORMAT "X(256)":U 
     LABEL "OBSRV." 
     VIEW-AS FILL-IN 
     SIZE 73 BY 1
     BGCOLOR 8 FGCOLOR 4 FONT 5 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tmp-TabPerArea SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tmp-TabPerArea.CodPer FORMAT "X(6)":U
      tmp-TabPerArea.Libre_c01 COLUMN-LABEL "Apellidos y Nombres" FORMAT "x(50)":U
            WIDTH 45
      tmp-TabPerArea.CodArea COLUMN-LABEL "Area" FORMAT "x(40)":U
            WIDTH 52.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 108.29 BY 17.12 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cb-divi AT ROW 1.54 COL 10 COLON-ALIGNED WIDGET-ID 2
     txt-desdiv AT ROW 1.54 COL 21.57 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     BROWSE-2 AT ROW 2.73 COL 2.72 WIDGET-ID 200
     BUTTON-3 AT ROW 20.27 COL 87 WIDGET-ID 6
     txt-obs AT ROW 20.38 COL 8.72 COLON-ALIGNED WIDGET-ID 8
     txt-msje AT ROW 21.5 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 118.86 BY 22.5 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tmp-TabPerArea T "NEW GLOBAL SHARED" NO-UNDO INTEGRAL TabPerArea
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Cese de Personal"
         HEIGHT             = 22.5
         WIDTH              = 118.86
         MAX-HEIGHT         = 22.5
         MAX-WIDTH          = 137.14
         VIRTUAL-HEIGHT     = 22.5
         VIRTUAL-WIDTH      = 137.14
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
/* BROWSE-TAB BROWSE-2 txt-desdiv F-Main */
/* SETTINGS FOR FILL-IN txt-desdiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-msje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tmp-TabPerArea"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "Temp-Tables.tmp-TabPerArea.Libre_c02 BEGINS cb-divi"
     _FldNameList[1]   = Temp-Tables.tmp-TabPerArea.CodPer
     _FldNameList[2]   > Temp-Tables.tmp-TabPerArea.Libre_c01
"tmp-TabPerArea.Libre_c01" "Apellidos y Nombres" "x(50)" "character" ? ? ? ? ? ? no ? no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tmp-TabPerArea.CodArea
"tmp-TabPerArea.CodArea" "Area" "x(40)" "character" ? ? ? ? ? ? no ? no no "52.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Cese de Personal */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Cese de Personal */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* CESAR PERSONAL */
DO:
    ASSIGN 
        cb-divi
        txt-obs.
    IF cb-divi = "" THEN DO:
        MESSAGE "Seleccione una división"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN NO-APPLY.
    END.
    RUN Solicita_Cese.        

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-divi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-divi W-Win
ON VALUE-CHANGED OF cb-divi IN FRAME F-Main /* Division */
DO:
  
    ASSIGN cb-divi.

    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = cb-divi NO-LOCK NO-ERROR.
    IF AVAIL gn-divi THEN 
        DISPLAY gn-divi.desdiv @ txt-desdiv WITH FRAME {&FRAME-NAME}.
    ELSE 
        DISPLAY "" @ txt-desdiv WITH FRAME {&FRAME-NAME}.
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
  DISPLAY cb-divi txt-desdiv txt-obs txt-msje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE cb-divi BROWSE-2 BUTTON-3 txt-obs 
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
  
  EMPTY TEMP-TABLE tmp-TabPerArea.
  
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:
          cb-divi:ADD-LAST(STRING(gn-divi.coddiv,"99999")).
      END.
  END.

  /*Carga Data Inicial*/
  FOR EACH TabPerArea WHERE TabPerArea.CodCia = s-codcia NO-LOCK,
        FIRST Pl-Pers WHERE Pl-Pers.Codcia = s-codcia
            AND Pl-Pers.CodPer = TabPerArea.CodPer NO-LOCK: 

      FIND FIRST TabAreas WHERE TabAreas.CodCia = s-codcia
          AND TabAreas.CodArea = TabPerArea.CodArea NO-LOCK NO-ERROR.

      CREATE tmp-TabPerArea.
      BUFFER-COPY TabPerArea TO tmp-TabPerArea
          ASSIGN 
            tmp-TabPerArea.Libre_c01 = Pl-Pers.PatPer + " " + Pl-pers.MatPer + ", " + Pl-Pers.NomPer
            tmp-TabPerArea.Libre_c02 = TabAreas.CodDiv
            tmp-TabPerArea.CodArea   = TabAreas.CodArea.
      
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
  {src/adm/template/snd-list.i "tmp-TabPerArea"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Solicita_Cese W-Win 
PROCEDURE Solicita_Cese :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR i         AS INT  NO-UNDO.
  DEF VAR cNroDoc   AS CHAR NO-UNDO.
  DEF VAR lExist    AS LOG  NO-UNDO.
  DEF VAR cName     AS CHAR NO-UNDO.
  DEF VAR cObs      AS CHAR NO-UNDO.

  EMPTY TEMP-TABLE tmp-tabla.

  /*Busca Pendientes*/
  DO WITH FRAME {&FRAME-NAME}:
      browses:
      DO i = 1 TO BROWSE-2:NUM-SELECTED-ROWS:
        IF BROWSE-2:FETCH-SELECTED-ROW(i) THEN DO:
            FIND FIRST TabDMovPer WHERE TabDMovPer.CodCia = s-codcia
                /*AND TabDMovPer.CodDiv  = cb-divi*/
                AND TabDMovPer.CodPer  = Tmp-tabperarea.codper
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
                NEXT Browses.
            END.
            CREATE tmp-tabla.
            BUFFER-COPY tmp-tabperarea TO tmp-tabla.
            DISPLAY "PROCESANDO: " + tmp-TabPerArea.Libre_c01 @ txt-msje
                WITH FRAME {&FRAME-NAME}.

        END.
      END.
  END.

  FIND FIRST tmp-tabla WHERE tmp-tabla.codcia = s-codcia NO-LOCK NO-ERROR.
  IF NOT AVAIL tmp-tabla THEN DO: 
      MESSAGE "El listado de personal esta en LISTA DE PENDIENTES"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN NO-APPLY.
  END.
  
  /*Busca Nrodoc*/
  FIND LAST TabCMovPer WHERE TabCMovPer.codcia = s-codcia
      AND TabCMovPer.CodDiv = cb-divi NO-LOCK NO-ERROR.
  IF NOT AVAIL TabCMovPer THEN 
      cNroDoc = STRING(INT(cb-divi),"999") + STRING(1,"999999").
  ELSE cNroDoc = STRING(INT(cb-divi),"999") + STRING(INT(SUBSTRING(TabCMovPer.NroDoc,4)) + 1,"999999").

  FOR EACH tmp-tabla :
      FIND FIRST TabDMovPer WHERE TabDMovPer.CodCia = s-codcia
          AND TabDMovPer.CodDiv  = cb-divi
          AND TabDMovPer.CodPer  = tmp-tabla.codper
          AND TabDMovPer.Libre_c01 = "P" NO-LOCK NO-ERROR.
      IF AVAIL TabDMovPer THEN DELETE tmp-tabla.
      IF txt-obs <> '' THEN cObs = txt-obs.
      ELSE cObs = "Cese Personal".
      /*Crea Detalle*/
      CREATE TabDMovPer.
      ASSIGN
          TabDMovPer.CodCia           = s-codcia
          TabDMovPer.NroDoc           = cNroDoc
          TabDMovPer.CodDiv           = cb-divi
          TabDMovPer.CodPer           = tmp-Tabla.CodPer
          TabDMovPer.AreaDes          = "000"
          TabDMovPer.AreaOri          = tmp-Tabla.CodArea
          TabDMovPer.Libre_c01        = "P"
          TabDMovPer.Observaciones    = cObs
          TabDMovPer.TipMov           = "C".

      /*Crea Cabecera*/
      FIND FIRST TabCMovPer WHERE TabcMovPer.CodCia = s-codcia
          AND TabCMovPer.CodDiv = cb-divi
          AND TabCMovPer.NroDoc = cNroDoc NO-ERROR.
      IF AVAIL TabCMovPer THEN NEXT.
      CREATE TabCMovPer.
      ASSIGN  
          TabCMovPer.CodCia           = s-codcia 
          TabCMovPer.CodDiv           = cb-divi
          TabCMovPer.FchMov           = DATETIME(TODAY,MTIME)
          TabCMovPer.FlgEst           = "P"
          TabCMovPer.TipMov           = "C"
          TabCMovPer.NroDoc           = cNroDoc
          TabCMovPer.Observaciones    = ""                 
          TabCMovPer.UsrMov           = s-user-id.

      DISPLAY "GENERANDO SOLICITUD " @ txt-msje
          WITH FRAME {&FRAME-NAME}.

  END.

  DISPLAY "" @ txt-msje WITH FRAME {&FRAME-NAME}.

  MESSAGE "Proceso Terminado"
      VIEW-AS ALERT-BOX INFO BUTTONS OK.

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

