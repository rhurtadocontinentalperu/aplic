&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-dataprecios NO-UNDO LIKE Almmmatg.



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
DEFINE SHARED VAR s-coddiv AS CHAR.

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
&Scoped-define INTERNAL-TABLES tt-dataprecios

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 tt-dataprecios.codmat ~
tt-dataprecios.DesMat tt-dataprecios.DesMar tt-dataprecios.UndBas ~
tt-dataprecios.PreOfi tt-dataprecios.MonVta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH tt-dataprecios NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH tt-dataprecios NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 tt-dataprecios
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 tt-dataprecios


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 FILL-IN-1 COMBO-BOX-1 FILL-IN-3 ~
BUTTON-1 FILL-IN-2 BROWSE-3 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 COMBO-BOX-1 FILL-IN-3 FILL-IN-2 ~
FILL-IN-codmat FILL-IN-desmat FILL-IN-desmar FILL-IN-S FILL-IN-D 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "ô.ô" 
     SIZE 10 BY 1.12.

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Que comience con","B",
                     "Que contenga","C"
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(6)":U 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(13)":U 
     LABEL "EAN 13" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-codmat AS CHARACTER FORMAT "X(6)":U 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-D AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "USD $" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-desmar AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 37 BY 1
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN-desmat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descripcion" 
     VIEW-AS FILL-IN 
     SIZE 56 BY 1
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE FILL-IN-S AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "S/." 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 92.14 BY 19.5.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      tt-dataprecios SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      tt-dataprecios.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U
      tt-dataprecios.DesMat FORMAT "X(45)":U
      tt-dataprecios.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U
      tt-dataprecios.UndBas FORMAT "X(4)":U
      tt-dataprecios.PreOfi COLUMN-LABEL "Precio!Oficina" FORMAT ">,>>>,>>9.9999":U
      tt-dataprecios.MonVta FORMAT "9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 87 BY 7.81 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-1 AT ROW 2.08 COL 10 COLON-ALIGNED WIDGET-ID 2
     COMBO-BOX-1 AT ROW 3.15 COL 10 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     FILL-IN-3 AT ROW 3.15 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     BUTTON-1 AT ROW 3.15 COL 82 WIDGET-ID 16
     FILL-IN-2 AT ROW 4.23 COL 10 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-codmat AT ROW 6.65 COL 19 COLON-ALIGNED WIDGET-ID 26
     FILL-IN-desmat AT ROW 7.69 COL 19 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-desmar AT ROW 8.73 COL 19 COLON-ALIGNED WIDGET-ID 24
     FILL-IN-S AT ROW 10.12 COL 19 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-D AT ROW 10.12 COL 44 COLON-ALIGNED WIDGET-ID 18
     BROWSE-3 AT ROW 12.04 COL 5 WIDGET-ID 200
     "Detalle Producto:" VIEW-AS TEXT
          SIZE 16 BY .88 AT ROW 5.58 COL 7 WIDGET-ID 20
     RECT-1 AT ROW 1.15 COL 1.86 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 95.29 BY 20.31 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Temp-Tables and Buffers:
      TABLE: tt-dataprecios T "?" NO-UNDO INTEGRAL Almmmatg
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 20.31
         WIDTH              = 95.29
         MAX-HEIGHT         = 20.31
         MAX-WIDTH          = 134.72
         VIRTUAL-HEIGHT     = 20.31
         VIRTUAL-WIDTH      = 134.72
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
/* BROWSE-TAB BROWSE-3 FILL-IN-D F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-codmat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-D IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-desmar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-desmat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-S IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.tt-dataprecios"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-dataprecios.codmat
"codmat" "Codigo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.tt-dataprecios.DesMat
     _FldNameList[3]   > Temp-Tables.tt-dataprecios.DesMar
"DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.tt-dataprecios.UndBas
     _FldNameList[5]   > Temp-Tables.tt-dataprecios.PreOfi
"PreOfi" "Precio!Oficina" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = Temp-Tables.tt-dataprecios.MonVta
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ô.ô */
DO:
    ASSIGN                            
        FILL-IN-1 FILL-IN-2 FILL-IN-3 COMBO-BOX-1.

    RUN Detalla_Precios.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Detalla_Precios W-Win 
PROCEDURE Detalla_Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lAvail AS LOGICAL     NO-UNDO INIT YES.
    IF FILL-IN-1 <> '' THEN DO:
        FIND almmmatg WHERE almmmatg.codcia = s-codcia
            AND almmmatg.codmat = FILL-IN-1 NO-LOCK NO-ERROR.
        IF NOT AVAIL almmmatg THEN lAvail = NO.        
    END. 
    ELSE IF FILL-IN-2 <> '' THEN DO:
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
            AND almmmatg.codbrr = FILL-IN-2 NO-LOCK NO-ERROR.
        IF NOT AVAIL almmmatg THEN lAvail = NO.
    END.
    IF lAvail THEN DO:
        CREATE tt-dataprecios.
        BUFFER-COPY almmmatg TO tt-dataprecios.
        /*
        FIND FIRST vtalistamin WHERE vtalistamin.codcia = s-codcia
            AND vtalistamin.coddiv = s-coddiv
            AND vtalistamin.codmat = almmmatg.codmat NO-LOCK NO-ERROR.
        IF AVAIL vtalistamin THEN DO:
            IF vtalistamin.monvta = 1 THEN 
                DISPLAY
                    almmmatg.codmat @ fill-in-codmat
                    almmmatg.desmat @ fill-in-desmat
                    almmmatg.desmar @ fill-in-desmar
                    vtalistamin.preofi @ FILL-IN-S
                    (vtalistamin.preofi / vtalistamin.tpocmb) @ FILL-IN-D
                WITH FRAME {&FRAME-NAME}.
            IF vtalistamin.monvta = 2 THEN 
                DISPLAY
                    almmmatg.codmat @ fill-in-codmat
                    almmmatg.desmat @ fill-in-desmat
                    almmmatg.desmar @ fill-in-desmar
                    (vtalistamin.preofi * vtalistamin.tpocmb)  @ FILL-IN-S
                    vtalistamin.preofi @ FILL-IN-D
                WITH FRAME {&FRAME-NAME}.

        END.
        */
    END.
    ELSE DO:
        MESSAGE 'Codigo no registrado'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN 'adm-error'.
    END.

    ASSIGN 
        FILL-IN-1 = ''
        FILL-IN-2 = ''
        FILL-IN-3 = ''.
    DISPLAY
        FILL-IN-1 
        FILL-IN-2 
        FILL-IN-3 WITH FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Detalla_Precios_Desc W-Win 
PROCEDURE Detalla_Precios_Desc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    

    CASE COMBO-BOX-1:
        WHEN 'B' THEN DO:
            FOR EACH almmmatg WHERE almmmatg.codcia = s-codcia
                AND INDEX(FILL-IN-3,almmmatg.desmat) > 0 NO-LOCK:
                CREATE tt-dataprecios.
                BUFFER-COPY almmmatg TO tt-dataprecios.
            END.
        END.
        WHEN 'C' THEN DO:
            FOR EACH almmmatg WHERE almmmatg.codcia = s-codcia
                AND almmmatg.desmat BEGINS fill-in-3 NO-LOCK:
                CREATE tt-dataprecios.
                BUFFER-COPY almmmatg TO tt-dataprecios.
            END.
        END.
    END CASE.

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
  DISPLAY FILL-IN-1 COMBO-BOX-1 FILL-IN-3 FILL-IN-2 FILL-IN-codmat 
          FILL-IN-desmat FILL-IN-desmar FILL-IN-S FILL-IN-D 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 FILL-IN-1 COMBO-BOX-1 FILL-IN-3 BUTTON-1 FILL-IN-2 BROWSE-3 
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
  {src/adm/template/snd-list.i "tt-dataprecios"}

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

