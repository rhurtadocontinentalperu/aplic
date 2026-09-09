&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR xLlave-C AS CHAR INIT "IMPCAJA".

DEF NEW SHARED VAR s-Sunat-Activo AS LOG INIT NO.
FIND gn-divi WHERE GN-DIVI.CodCia = s-codcia 
    AND GN-DIVI.CodDiv = s-coddiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'NO está configurada la división' s-coddiv VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
s-Sunat-Activo = gn-divi.campo-log[10].

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME BROWSE-4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES w-report CcbCDocu

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 w-report.Campo-C[1] ~
w-report.Campo-C[2] CcbCDocu.NomCli CcbCDocu.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH w-report ~
      WHERE w-report.Llave-C = xLlave-C ~
 AND w-report.Task-No = INTEGER(s-coddiv) ~
 AND w-report.Llave-D = TODAY NO-LOCK, ~
      EACH CcbCDocu WHERE CcbCDocu.CodCia = w-report.Llave-I ~
  AND CcbCDocu.CodDoc = w-report.Campo-C[1] ~
  AND CcbCDocu.NroDoc = w-report.Campo-C[2] NO-LOCK ~
    BY w-report.Campo-C[1] ~
       BY w-report.Campo-C[2] INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH w-report ~
      WHERE w-report.Llave-C = xLlave-C ~
 AND w-report.Task-No = INTEGER(s-coddiv) ~
 AND w-report.Llave-D = TODAY NO-LOCK, ~
      EACH CcbCDocu WHERE CcbCDocu.CodCia = w-report.Llave-I ~
  AND CcbCDocu.CodDoc = w-report.Campo-C[1] ~
  AND CcbCDocu.NroDoc = w-report.Campo-C[2] NO-LOCK ~
    BY w-report.Campo-C[1] ~
       BY w-report.Campo-C[2] INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 w-report CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 w-report
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-4 CcbCDocu


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-4 BUTTON-5 BUTTON-6 BtnDone 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "IMG/exit.ico":U
     LABEL "&Done" 
     SIZE 8 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-5 
     LABEL "REFRESCAR" 
     SIZE 16 BY 1.12.

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "IMG/print.ico":U
     LABEL "Button 6" 
     SIZE 8 BY 1.62.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      w-report, 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 wWin _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      w-report.Campo-C[1] COLUMN-LABEL "Documento" FORMAT "X(8)":U
            WIDTH 11.43
      w-report.Campo-C[2] COLUMN-LABEL "Número" FORMAT "X(12)":U
            WIDTH 13.43
      CcbCDocu.NomCli FORMAT "x(50)":U
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 91 BY 16.42 ROW-HEIGHT-CHARS .65 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BROWSE-4 AT ROW 1.27 COL 3 WIDGET-ID 200
     BUTTON-5 AT ROW 1.81 COL 95 WIDGET-ID 2
     BUTTON-6 AT ROW 3.15 COL 95 WIDGET-ID 4
     BtnDone AT ROW 3.15 COL 103 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 110.72 BY 17 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "REIMPRESION DE COMPROBANTES"
         HEIGHT             = 17
         WIDTH              = 110.72
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-4 1 fMain */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "INTEGRAL.w-report,INTEGRAL.CcbCDocu WHERE INTEGRAL.w-report ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.w-report.Campo-C[1]|yes,INTEGRAL.w-report.Campo-C[2]|yes"
     _Where[1]         = "INTEGRAL.w-report.Llave-C = xLlave-C
 AND INTEGRAL.w-report.Task-No = INTEGER(s-coddiv)
 AND INTEGRAL.w-report.Llave-D = TODAY"
     _JoinCode[2]      = "INTEGRAL.CcbCDocu.CodCia = INTEGRAL.w-report.Llave-I
  AND INTEGRAL.CcbCDocu.CodDoc = INTEGRAL.w-report.Campo-C[1]
  AND INTEGRAL.CcbCDocu.NroDoc = INTEGRAL.w-report.Campo-C[2]"
     _FldNameList[1]   > INTEGRAL.w-report.Campo-C[1]
"w-report.Campo-C[1]" "Documento" ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.w-report.Campo-C[2]
"w-report.Campo-C[2]" "Número" "X(12)" "character" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.CcbCDocu.NomCli
     _FldNameList[4]   = INTEGRAL.CcbCDocu.ImpTot
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* REIMPRESION DE COMPROBANTES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* REIMPRESION DE COMPROBANTES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone wWin
ON CHOOSE OF BtnDone IN FRAME fMain /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 wWin
ON CHOOSE OF BUTTON-5 IN FRAME fMain /* REFRESCAR */
DO:
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 wWin
ON CHOOSE OF BUTTON-6 IN FRAME fMain /* Button 6 */
DO:
    /* control de cambios */
    DEF VAR x-Rowid AS ROWID NO-UNDO.
    DEF VAR x-Rpta AS LOG INIT YES NO-UNDO.

    x-Rowid = ROWID(w-report).
    IF CAN-FIND(w-report WHERE ROWID(w-report) = x-Rowid NO-LOCK) THEN DO:
        IF s-Sunat-Activo = YES THEN DO:
            RUN sunat\r-impresion-documentos-sunat ( ROWID(Ccbcdocu), "O", NO ).
        END.
        ELSE DO:
            IF Ccbcdocu.coddoc = "FAC" THEN RUN VTA\R-IMPFAC2-1 (ROWID(CcbCDocu)).
            IF Ccbcdocu.coddoc = "BOL" THEN RUN VTA\R-IMPBOL2-1 (ROWID(CcbCDocu)).
        END.
    END.
    MESSAGE 'Se imprimió correctamente el comprobante?' SKIP
        VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO
        UPDATE x-rpta.
    IF x-rpta = YES THEN DO:
        FIND CURRENT w-report EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE w-report THEN DELETE w-report.
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  ENABLE BROWSE-4 BUTTON-5 BUTTON-6 BtnDone 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

