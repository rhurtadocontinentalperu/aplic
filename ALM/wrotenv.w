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
DEF VAR s-coddoc AS CHAR INIT 'PED'.
DEF VAR s-task-no AS INT.

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
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacCPedi w-report

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 FacCPedi.NroPed FacCPedi.FchPed 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH FacCPedi WHERE TRUE /* Join to w-report incomplete */ ~
      AND FacCPedi.FlgEst = "C" ~
 AND FacCPedi.FlgSit = "C" ~
 AND FacCPedi.CodRef = "PED" ~
 AND FacCPedi.CodDoc = "O/D"  ~
 AND FacCPedi.NroRef = w-report.campo-c[2]:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH FacCPedi WHERE TRUE /* Join to w-report incomplete */ ~
      AND FacCPedi.FlgEst = "C" ~
 AND FacCPedi.FlgSit = "C" ~
 AND FacCPedi.CodRef = "PED" ~
 AND FacCPedi.CodDoc = "O/D"  ~
 AND FacCPedi.NroRef = w-report.campo-c[2]:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 FacCPedi


/* Definitions for FRAME fMain                                          */
&Scoped-define FIELDS-IN-QUERY-fMain w-report.Campo-C[2] ~
w-report.Campo-C[3] w-report.Campo-C[4] w-report.Campo-C[5] ~
w-report.Campo-C[6] w-report.Campo-C[7] w-report.Campo-D[1] ~
w-report.Campo-F[1] w-report.Campo-F[2] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-fMain w-report.Campo-C[2] ~
w-report.Campo-C[6] w-report.Campo-D[1] w-report.Campo-F[1] ~
w-report.Campo-F[2] 
&Scoped-define ENABLED-TABLES-IN-QUERY-fMain w-report
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-fMain w-report
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-2}
&Scoped-define QUERY-STRING-fMain FOR EACH w-report SHARE-LOCK
&Scoped-define OPEN-QUERY-fMain OPEN QUERY fMain FOR EACH w-report SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-fMain w-report
&Scoped-define FIRST-TABLE-IN-QUERY-fMain w-report


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS w-report.Campo-C[2] w-report.Campo-C[6] ~
w-report.Campo-D[1] w-report.Campo-F[1] w-report.Campo-F[2] 
&Scoped-define ENABLED-TABLES w-report
&Scoped-define FIRST-ENABLED-TABLE w-report
&Scoped-Define ENABLED-OBJECTS BROWSE-2 BUTTON-Print BtnDone 
&Scoped-Define DISPLAYED-FIELDS w-report.Campo-C[2] w-report.Campo-C[3] ~
w-report.Campo-C[4] w-report.Campo-C[5] w-report.Campo-C[6] ~
w-report.Campo-C[7] w-report.Campo-D[1] w-report.Campo-F[1] ~
w-report.Campo-F[2] 
&Scoped-define DISPLAYED-TABLES w-report
&Scoped-define FIRST-DISPLAYED-TABLE w-report
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NomChe 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Salir" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-Print 
     IMAGE-UP FILE "img\print (2).ico":U
     LABEL "Imprimir" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE FILL-IN-NomChe AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 67 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      FacCPedi SCROLLING.

DEFINE QUERY fMain FOR 
      w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 wWin _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      FacCPedi.NroPed COLUMN-LABEL "Orden de Despacho" FORMAT "X(9)":U
      FacCPedi.FchPed COLUMN-LABEL "Fecha de Emisión" FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 40 BY 3.23 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     w-report.Campo-C[2] AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 6
          LABEL "N° de Pedido" FORMAT "x(9)"
          VIEW-AS FILL-IN 
          SIZE 12.43 BY 1
     BROWSE-2 AT ROW 1.27 COL 36 WIDGET-ID 200
     w-report.Campo-C[3] AT ROW 4.5 COL 19 COLON-ALIGNED WIDGET-ID 8
          LABEL "RUC" FORMAT "X(11)"
          VIEW-AS FILL-IN 
          SIZE 12.43 BY 1
     w-report.Campo-C[4] AT ROW 5.58 COL 19 COLON-ALIGNED WIDGET-ID 10
          LABEL "Cliente" FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 57 BY 1
     w-report.Campo-C[5] AT ROW 6.65 COL 19 COLON-ALIGNED WIDGET-ID 42
          LABEL "Dirección" FORMAT "X(80)"
          VIEW-AS FILL-IN 
          SIZE 80 BY 1
     w-report.Campo-C[6] AT ROW 7.73 COL 19 COLON-ALIGNED WIDGET-ID 44
          LABEL "Lugar de entrega" FORMAT "X(80)"
          VIEW-AS FILL-IN 
          SIZE 80 BY 1
     w-report.Campo-C[7] AT ROW 8.81 COL 19 COLON-ALIGNED WIDGET-ID 16
          LABEL "Chequeador" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 12.43 BY 1
     FILL-IN-NomChe AT ROW 8.81 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     w-report.Campo-D[1] AT ROW 9.88 COL 19 COLON-ALIGNED WIDGET-ID 18
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 12.86 BY 1
     w-report.Campo-F[1] AT ROW 10.96 COL 19 COLON-ALIGNED WIDGET-ID 20
          LABEL "Bultos" FORMAT ">>9"
          VIEW-AS FILL-IN 
          SIZE 7 BY 1
     w-report.Campo-F[2] AT ROW 12.04 COL 19 COLON-ALIGNED WIDGET-ID 22
          LABEL "Peso" FORMAT ">,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12 BY 1
     BUTTON-Print AT ROW 13.92 COL 3 WIDGET-ID 38
     BtnDone AT ROW 13.92 COL 18 WIDGET-ID 36
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 108.72 BY 15.12 WIDGET-ID 100.


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
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 15.12
         WIDTH              = 108.72
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
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB BROWSE-2 Campo-C[2] fMain */
/* SETTINGS FOR FILL-IN w-report.Campo-C[2] IN FRAME fMain
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN w-report.Campo-C[3] IN FRAME fMain
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN w-report.Campo-C[4] IN FRAME fMain
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN w-report.Campo-C[5] IN FRAME fMain
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN w-report.Campo-C[6] IN FRAME fMain
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN w-report.Campo-C[7] IN FRAME fMain
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN w-report.Campo-D[1] IN FRAME fMain
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN w-report.Campo-F[1] IN FRAME fMain
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN w-report.Campo-F[2] IN FRAME fMain
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-NomChe IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.FacCPedi WHERE INTEGRAL.w-report <external> ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "INTEGRAL.FacCPedi.FlgEst = ""C""
 AND INTEGRAL.FacCPedi.FlgSit = ""C""
 AND INTEGRAL.FacCPedi.CodRef = ""PED""
 AND INTEGRAL.FacCPedi.CodDoc = ""O/D"" 
 AND INTEGRAL.FacCPedi.NroRef = w-report.campo-c[2]:SCREEN-VALUE IN FRAME {&FRAME-NAME}"
     _FldNameList[1]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Orden de Despacho" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Fecha de Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fMain
/* Query rebuild information for FRAME fMain
     _TblList          = "INTEGRAL.w-report"
     _Query            is OPENED
*/  /* FRAME fMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 wWin
ON ENTRY OF BROWSE-2 IN FRAME fMain
DO:
    IF AVAILABLE Faccpedi THEN DO:
        w-report.campo-c[7]:SCREEN-VALUE = Faccpedi.usrchq.
        FIND pl-pers WHERE pl-pers.codper = faccpedi.usrchq NO-LOCK NO-ERROR.
        IF AVAILABLE pl-pers THEN FILL-IN-NomChe:SCREEN-VALUE = TRIM(pl-pers.patper) +
            ' ' + TRIM(pl-pers.matper) + ', ' + pl-pers.nomper.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 wWin
ON VALUE-CHANGED OF BROWSE-2 IN FRAME fMain
DO:
  IF AVAILABLE Faccpedi THEN DO:
      w-report.campo-c[7]:SCREEN-VALUE = Faccpedi.usrchq.
      FIND pl-pers WHERE pl-pers.codper = faccpedi.usrchq NO-LOCK NO-ERROR.
      IF AVAILABLE pl-pers THEN FILL-IN-NomChe:SCREEN-VALUE = TRIM(pl-pers.patper) +
          ' ' + TRIM(pl-pers.matper) + ', ' + pl-pers.nomper.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone wWin
ON CHOOSE OF BtnDone IN FRAME fMain /* Salir */
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


&Scoped-define SELF-NAME BUTTON-Print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Print wWin
ON CHOOSE OF BUTTON-Print IN FRAME fMain /* Imprimir */
DO:
    /* Consistencias */
    IF INPUT w-report.Campo-F[1] <= 0 THEN DO:
        MESSAGE 'Ingrese el # de bultos' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO w-report.Campo-F[1].
        RETURN NO-APPLY.
    END.
    RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME w-report.Campo-C[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-report.Campo-C[2] wWin
ON LEAVE OF w-report.Campo-C[2] IN FRAME fMain /* N° de Pedido */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND Faccpedi WHERE codcia = s-codcia 
      AND coddoc = s-coddoc
      AND nroped = SELF:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccpedi THEN DO:
      MESSAGE 'Pedido no registrado' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF Faccpedi.flgest = 'A' THEN DO:
      MESSAGE 'Pedido anulado' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  DISPLAY
      Faccpedi.ruccli @ w-report.Campo-C[3]
      Faccpedi.nomcli @ w-report.Campo-C[4]
      Faccpedi.dircli @ w-report.Campo-C[5]
      Faccpedi.lugent @ w-report.Campo-C[6]
      WITH FRAME {&FRAME-NAME}.
  {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal wWin 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR k AS INT.

    REPEAT:
        s-task-no = RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE task-no = s-task-no NO-LOCK) THEN LEAVE.
    END.
    DO k = 1 TO DECIMAL(w-report.Campo-F[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME}) 
        WITH FRAME {&FRAME-NAME}:
        CREATE w-report.
        ASSIGN
            w-report.task-no    = s-task-no
            w-report.campo-c[2] = w-report.Campo-C[2]:SCREEN-VALUE
            w-report.campo-c[3] = w-report.Campo-C[3]:SCREEN-VALUE
            w-report.campo-c[4] = w-report.Campo-C[4]:SCREEN-VALUE
            w-report.campo-c[5] = w-report.Campo-C[5]:SCREEN-VALUE
            w-report.campo-c[6] = w-report.Campo-C[6]:SCREEN-VALUE
            w-report.campo-c[7] = w-report.Campo-C[7]:SCREEN-VALUE
            w-report.campo-c[8] = FILL-IN-NomChe:SCREEN-VALUE
            w-report.campo-d[1] = DATE(w-report.Campo-D[1]:SCREEN-VALUE)
            w-report.campo-f[1] = DECIMAL(w-report.campo-f[1]:SCREEN-VALUE)
            w-report.campo-f[2] = DECIMAL(w-report.campo-f[2]:SCREEN-VALUE).
        ASSIGN
            w-report.campo-c[1] = "*" + w-report.Campo-C[2]:SCREEN-VALUE + STRING(k, '999')
            w-report.campo-f[3] = k.
    END.

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

  {&OPEN-QUERY-fMain}
  GET FIRST fMain.
  DISPLAY FILL-IN-NomChe 
      WITH FRAME fMain IN WINDOW wWin.
  IF AVAILABLE w-report THEN 
    DISPLAY w-report.Campo-C[2] w-report.Campo-C[3] w-report.Campo-C[4] 
          w-report.Campo-C[5] w-report.Campo-C[6] w-report.Campo-C[7] 
          w-report.Campo-D[1] w-report.Campo-F[1] w-report.Campo-F[2] 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE w-report.Campo-C[2] BROWSE-2 w-report.Campo-C[6] w-report.Campo-D[1] 
         w-report.Campo-F[1] w-report.Campo-F[2] BUTTON-Print BtnDone 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir wWin 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN Carga-Temporal.

    DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
    DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
    DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
    DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
    DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

    GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'alm/rbalm.prl'
        RB-REPORT-NAME = 'Rotulo de envios'
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER = "w-report.task-no = " + STRING(s-task-no).

    RUN lib/_imprime2 ( RB-REPORT-LIBRARY,
                        RB-REPORT-NAME,
                        RB-INCLUDE-RECORDS,
                        RB-FILTER,
                        RB-OTHER-PARAMETERS).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      DISPLAY
          '' @ w-report.Campo-C[2] 
          '' @ w-report.Campo-C[3] 
          '' @ w-report.Campo-C[4] 
          '' @ w-report.Campo-C[7] 
          TODAY @ w-report.Campo-D[1] 
          1 @ w-report.Campo-F[1] 
          0 @ w-report.Campo-F[2].
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

