&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE DEPO-1 NO-UNDO LIKE INTEGRAL.CcbBolDep.
DEFINE TEMP-TABLE DEPO-2 NO-UNDO LIKE INTEGRAL.CcbBolDep.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES DEPO-1 DEPO-2

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 DEPO-1.NroDoc DEPO-1.FchDoc ~
DEPO-1.NomCli DEPO-1.ImpTot DEPO-1.SdoAct 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-1
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH DEPO-1 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 DEPO-1
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 DEPO-1


/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 DEPO-2.NroDoc DEPO-2.FchDoc ~
DEPO-2.NomCli DEPO-2.ImpTot DEPO-2.SdoAct 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-2
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH DEPO-2 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 DEPO-2
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 DEPO-2


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-1 BUTTON-1 BUTTON-2 COMBO-BOX-1 ~
BROWSE-2 BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL ">>>" 
     SIZE 6 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "<<<" 
     SIZE 6 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL "PROCEDER A TRASLADAR LOS SALDOS" 
     SIZE 41 BY 1.12
     FONT 1.

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione una división de destino" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Seleccione una división de destino" 
     SIZE 55 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      DEPO-1 SCROLLING.

DEFINE QUERY BROWSE-2 FOR 
      DEPO-2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 DISPLAY
      DEPO-1.NroDoc COLUMN-LABEL "<<Numero>>"
      DEPO-1.FchDoc COLUMN-LABEL "<Emision>" FORMAT "99/99/99"
      DEPO-1.NomCli FORMAT "x(30)"
      DEPO-1.ImpTot COLUMN-LABEL "Importe" FORMAT ">>>,>>9.99"
      DEPO-1.SdoAct COLUMN-LABEL "Saldo" FORMAT "->>>,>>9.99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS MULTIPLE SIZE 58 BY 11.35
         FONT 4.

DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 DISPLAY
      DEPO-2.NroDoc COLUMN-LABEL "<<Numero>>"
      DEPO-2.FchDoc COLUMN-LABEL "<Emision>" FORMAT "99/99/99"
      DEPO-2.NomCli FORMAT "x(30)"
      DEPO-2.ImpTot COLUMN-LABEL "Importe" FORMAT ">>>,>>9.99"
      DEPO-2.SdoAct COLUMN-LABEL "Saldo" FORMAT ">>>,>>9.99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS MULTIPLE SIZE 58 BY 11.54
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-1 AT ROW 2.35 COL 2
     BUTTON-1 AT ROW 3.31 COL 62
     BUTTON-2 AT ROW 4.65 COL 62
     COMBO-BOX-1 AT ROW 1.19 COL 68 COLON-ALIGNED NO-LABEL
     BROWSE-2 AT ROW 2.35 COL 70
     BUTTON-3 AT ROW 14.27 COL 87
     "Marque los registros a trasladar" VIEW-AS TEXT
          SIZE 22 BY .5 AT ROW 1.58 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 128.72 BY 17
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: DEPO-1 T "?" NO-UNDO INTEGRAL CcbBolDep
      TABLE: DEPO-2 T "?" NO-UNDO INTEGRAL CcbBolDep
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "TRASLADO DE SALDOS"
         HEIGHT             = 14.81
         WIDTH              = 129.29
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 129.29
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 129.29
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* BROWSE-TAB BROWSE-1 TEXT-1 F-Main */
/* BROWSE-TAB BROWSE-2 COMBO-BOX-1 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.DEPO-1"
     _FldNameList[1]   > Temp-Tables.DEPO-1.NroDoc
"DEPO-1.NroDoc" "<<Numero>>" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > Temp-Tables.DEPO-1.FchDoc
"DEPO-1.FchDoc" "<Emision>" "99/99/99" "date" ? ? ? ? ? ? no ?
     _FldNameList[3]   > Temp-Tables.DEPO-1.NomCli
"DEPO-1.NomCli" ? "x(30)" "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   > Temp-Tables.DEPO-1.ImpTot
"DEPO-1.ImpTot" "Importe" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[5]   > Temp-Tables.DEPO-1.SdoAct
"DEPO-1.SdoAct" "Saldo" "->>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.DEPO-2"
     _FldNameList[1]   > Temp-Tables.DEPO-2.NroDoc
"DEPO-2.NroDoc" "<<Numero>>" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > Temp-Tables.DEPO-2.FchDoc
"DEPO-2.FchDoc" "<Emision>" "99/99/99" "date" ? ? ? ? ? ? no ?
     _FldNameList[3]   > Temp-Tables.DEPO-2.NomCli
"DEPO-2.NomCli" ? "x(30)" "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   > Temp-Tables.DEPO-2.ImpTot
"DEPO-2.ImpTot" "Importe" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[5]   > Temp-Tables.DEPO-2.SdoAct
"DEPO-2.SdoAct" "Saldo" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* TRASLADO DE SALDOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* TRASLADO DE SALDOS */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* >>> */
DO:
  RUN Carga-Tempo-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* <<< */
DO:
  RUN Carga-Tempo-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* PROCEDER A TRASLADAR LOS SALDOS */
DO:
  RUN Trasladar-Saldos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tempo-1 W-Win 
PROCEDURE Carga-Tempo-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR i AS INT NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    DO i = 1 TO BROWSE-2:NUM-SELECTED-ROWS:
        IF BROWSE-2:FETCH-SELECTED-ROW(i) THEN DO:
            CREATE DEPO-1.
            BUFFER-COPY DEPO-2 TO DEPO-1.
            DELETE DEPO-2.
        END.
    END.
  END.
  {&OPEN-QUERY-BROWSE-1}
  {&OPEN-QUERY-BROWSE-2}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tempo-2 W-Win 
PROCEDURE Carga-Tempo-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR i AS INT NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    DO i = 1 TO BROWSE-1:NUM-SELECTED-ROWS:
        IF BROWSE-1:FETCH-SELECTED-ROW(i) THEN DO:
            CREATE DEPO-2.
            BUFFER-COPY DEPO-1 TO DEPO-2.
            DELETE DEPO-1.
        END.
    END.
  END.
  {&OPEN-QUERY-BROWSE-1}
  {&OPEN-QUERY-BROWSE-2}
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  FOR EACH DEPO-1:
    DELETE DEPO-1.
  END.

  FOR EACH Ccbboldep NO-LOCK WHERE Ccbboldep.codcia = s-codcia
        AND Ccbboldep.coddoc = 'BD'
        AND Ccbboldep.coddiv = s-coddiv
        AND Ccbboldep.flgest = 'P':
    CREATE DEPO-1.
    BUFFER-COPY Ccbboldep TO DEPO-1.
  END.
          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  DISPLAY COMBO-BOX-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-1 BUTTON-1 BUTTON-2 COMBO-BOX-1 BROWSE-2 BUTTON-3 
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
  RUN Carga-Temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH Gn-divi NO-LOCK WHERE Gn-divi.codcia = s-codcia:
        COMBO-BOX-1:ADD-LAST(TRIM(Gn-divi.coddiv) + ' ' + Gn-divi.desdiv).
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "DEPO-1"}
  {src/adm/template/snd-list.i "DEPO-2"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Trasladar-Saldos W-Win 
PROCEDURE Trasladar-Saldos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  MESSAGE 'Trasladamos los saldo?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN.
  DO WITH FRAME {&FRAME-NAME}:
    IF COMBO-BOX-1:SCREEN-VALUE BEGINS 'Seleccione' THEN DO:
        MESSAGE 'No ha seleccionado una división de destino'
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    FOR EACH DEPO-2:
      FIND Ccbboldep OF DEPO-2 EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE DEPO-2 THEN DO:
        Ccbboldep.coddiv = SUBSTRING(COMBO-BOX-1:SCREEN-VALUE, 1, 5).
      END.
      DELETE DEPO-2.
    END.
    RUN Carga-Temporal.
    {&OPEN-QUERY-BROWSE-1}
    {&OPEN-QUERY-BROWSE-2}
  END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


