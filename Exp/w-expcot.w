&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-CPED NO-UNDO LIKE INTEGRAL.FacCPedi.
DEFINE TEMP-TABLE T-DPED NO-UNDO LIKE INTEGRAL.FacDPedi.


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

DEF VAR s-coddoc AS CHAR INIT 'COT' NO-UNDO.
DEF VAR x-CodCia LIKE Faccpedi.CodCia.
DEF VAR x-CodDiv LIKE Faccpedi.CodDiv.
DEF VAR x-CodDoc LIKE Faccpedi.CodDoc.
DEF VAR x-NroPed LIKE Faccpedi.NroPed.

DEF STREAM S-CPED.
DEF STREAM S-DPED.

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
&Scoped-define INTERNAL-TABLES T-CPED T-DPED Almmmatg

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 T-CPED.NroPed T-CPED.FchPed ~
T-CPED.NomCli T-CPED.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-1
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH T-CPED NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 T-CPED
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 T-CPED


/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 T-DPED.NroItm T-DPED.codmat ~
Almmmatg.DesMat T-DPED.CanPed T-DPED.UndVta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-2
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH T-DPED ~
      WHERE T-DPED.CodCia = x-codcia ~
 AND T-DPED.CodDoc = x-coddoc ~
 AND T-DPED.NroPed = x-nroped NO-LOCK, ~
      EACH Almmmatg OF T-DPED NO-LOCK ~
    BY T-DPED.NroItm.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 T-DPED Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 T-DPED


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-6 BROWSE-1 BROWSE-2 BUTTON-5 Btn_Done ~
BUTTON-4 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "adeicon\exit-au":U
     LABEL "&Done" 
     SIZE 6 BY 1.35 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "adeicon\del-au":U
     IMAGE-DOWN FILE "adeicon\del-ad":U
     IMAGE-INSENSITIVE FILE "adeicon\del-ai":U
     LABEL "Button 4" 
     SIZE 5 BY 1.12 TOOLTIP "Borra registro".

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "adeicon\export-u":U
     IMAGE-DOWN FILE "adeicon\export-d":U
     IMAGE-INSENSITIVE FILE "adeicon\export-i":U
     LABEL "Button 5" 
     SIZE 6 BY 1.35 TOOLTIP "Exportar Cotizaciones".

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "adeicon\import-u":U
     IMAGE-DOWN FILE "adeicon\import-d":U
     IMAGE-INSENSITIVE FILE "adeicon\import-i":U
     LABEL "Button 6" 
     SIZE 6 BY 1.35 TOOLTIP "Recargar Cotizaciones".

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      T-CPED SCROLLING.

DEFINE QUERY BROWSE-2 FOR 
      T-DPED, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      T-CPED.NroPed COLUMN-LABEL "Cotizacion"
      T-CPED.FchPed COLUMN-LABEL "Fecha"
      T-CPED.NomCli COLUMN-LABEL "Cliente" FORMAT "x(35)"
      T-CPED.ImpTot COLUMN-LABEL "Importe" FORMAT ">>>,>>9.99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 71 BY 4.5
         FONT 2.

DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      T-DPED.NroItm COLUMN-LABEL "Item"
      T-DPED.codmat COLUMN-LABEL "Codigo"
      Almmmatg.DesMat
      T-DPED.CanPed
      T-DPED.UndVta
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 80 BY 7.5
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-6 AT ROW 1.19 COL 4
     BROWSE-1 AT ROW 2.92 COL 4
     BROWSE-2 AT ROW 7.92 COL 4
     BUTTON-5 AT ROW 1.19 COL 10
     Btn_Done AT ROW 1.19 COL 16
     BUTTON-4 AT ROW 4.27 COL 76
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 87.86 BY 17
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-CPED T "?" NO-UNDO INTEGRAL FacCPedi
      TABLE: T-DPED T "?" NO-UNDO INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "EXPORTAR COTIZACIONES"
         HEIGHT             = 15.81
         WIDTH              = 87.86
         MAX-HEIGHT         = 27.23
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.23
         VIRTUAL-WIDTH      = 146.29
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
/* BROWSE-TAB BROWSE-1 BUTTON-6 F-Main */
/* BROWSE-TAB BROWSE-2 BROWSE-1 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.T-CPED"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.T-CPED.NroPed
"T-CPED.NroPed" "Cotizacion" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > Temp-Tables.T-CPED.FchPed
"T-CPED.FchPed" "Fecha" ? "date" ? ? ? ? ? ? no ?
     _FldNameList[3]   > Temp-Tables.T-CPED.NomCli
"T-CPED.NomCli" "Cliente" "x(35)" "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   > Temp-Tables.T-CPED.ImpTot
"T-CPED.ImpTot" "Importe" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.T-DPED,INTEGRAL.Almmmatg OF Temp-Tables.T-DPED"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.T-DPED.NroItm|yes"
     _Where[1]         = "Temp-Tables.T-DPED.CodCia = x-codcia
 AND Temp-Tables.T-DPED.CodDoc = x-coddoc
 AND Temp-Tables.T-DPED.NroPed = x-nroped"
     _FldNameList[1]   > Temp-Tables.T-DPED.NroItm
"T-DPED.NroItm" "Item" ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[2]   > Temp-Tables.T-DPED.codmat
"T-DPED.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[4]   = Temp-Tables.T-DPED.CanPed
     _FldNameList[5]   = Temp-Tables.T-DPED.UndVta
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
ON END-ERROR OF W-Win /* EXPORTAR COTIZACIONES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* EXPORTAR COTIZACIONES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 W-Win
ON VALUE-CHANGED OF BROWSE-1 IN FRAME F-Main
DO:
  ASSIGN
    x-CodCia = T-CPED.CodCia
    x-CodDiv = T-CPED.CodDiv
    x-CodDoc = T-CPED.CodDoc
    x-NroPed = T-CPEd.NroPed.
  {&OPEN-QUERY-BROWSE-2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Done */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
  MESSAGE 'Borramos Cotización?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta-1 AS LOG.
  IF rpta-1 = NO THEN RETURN NO-APPLY.
  FOR EACH T-DPED OF T-CPED:
    DELETE T-DPED.
  END.
  DELETE T-CPED.
  ASSIGN
    x-CodCia = 0
    x-CodDiv = ''
    x-CodDoc = ''
    x-NroPed = ''.
  FIND FIRST T-CPED NO-LOCK NO-ERROR.
  IF AVAILABLE T-CPED
  THEN ASSIGN
            x-CodCia = T-CPED.CodCia
            x-CodDiv = T-CPED.CodDiv
            x-CodDoc = T-CPED.CodDoc
            x-NroPed = T-CPEd.NroPed.
  {&OPEN-QUERY-BROWSE-1}
  {&OPEN-QUERY-BROWSE-2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
  MESSAGE 'Exportamos Cotizaciones?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta-1 AS LOG.
  IF rpta-1 = NO THEN RETURN NO-APPLY.
  OUTPUT STREAM S-CPED TO c:\exportar\faccpedi.d.
  OUTPUT STREAM S-DPED TO c:\exportar\facdpedi.d.
  FOR EACH T-CPED, FIRST Faccpedi OF T-CPED ON ERROR UNDO, RETURN NO-APPLY:
    EXPORT STREAM S-CPED T-CPED.
    Faccpedi.FlgEst = 'T'.
    FOR EACH T-DPED OF T-CPED:
        EXPORT STREAM S-DPED T-DPED.
        DELETE T-DPED.
    END.
    DELETE T-CPED.
  END.
  OUTPUT STREAM S-CPED CLOSE.
  OUTPUT STREAM S-DPED CLOSE.
  {&OPEN-QUERY-BROWSE-1}
  {&OPEN-QUERY-BROWSE-2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Button 6 */
DO:
  MESSAGE 'Cargamos nuevamente la información?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta-1 AS LOG.
  IF rpta-1 = NO THEN RETURN NO-APPLY.
  RUN Carga-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
/*{src/adm/template/cntnrwin.i}*/

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH T-CPED:
    DELETE T-CPED.
  END.
  FOR EACH T-DPED:
    DELETE T-DPED.
  END.
  
  FOR EACH Faccpedi WHERE FAccpedi.codcia = s-codcia
        AND Faccpedi.coddoc = s-coddoc
        AND Faccpedi.coddiv = s-coddiv
        AND Faccpedi.flgest = 'P'
        NO-LOCK:
    CREATE T-CPED.
    BUFFER-COPY Faccpedi TO T-CPED.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK:
        CREATE T-DPED.
        BUFFER-COPY Facdpedi TO T-DPED.
    END.
  END.
  ASSIGN
    x-CodCia = 0
    x-CodDiv = ''
    x-CodDoc = ''
    x-NroPed = ''.
  FIND FIRST T-CPED NO-LOCK NO-ERROR.
  IF AVAILABLE T-CPED
  THEN ASSIGN
            x-CodCia = T-CPED.CodCia
            x-CodDiv = T-CPED.CodDiv
            x-CodDoc = T-CPED.CodDoc
            x-NroPed = T-CPEd.NroPed.
  {&OPEN-QUERY-BROWSE-1}
  {&OPEN-QUERY-BROWSE-2}

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
  ENABLE BUTTON-6 BROWSE-1 BROWSE-2 BUTTON-5 Btn_Done BUTTON-4 
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
  RUN Carga-Temporal.

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
  {src/adm/template/snd-list.i "T-DPED"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "T-CPED"}

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


