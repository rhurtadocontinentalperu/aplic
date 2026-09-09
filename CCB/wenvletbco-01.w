&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-CDocu-01 LIKE CcbCDocu.
DEFINE TEMP-TABLE T-CDocu-02 LIKE CcbCDocu.



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

DEF VAR c-Mon AS CHAR FORMAT 'x(3)' EXTENT 2.

ASSIGN
    c-Mon[1] = "S/."
    c-mon[2] = "US$".

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cb-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR x-coddiv AS CHAR NO-UNDO.
DEF VAR x-codmon AS INT NO-UNDO.

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
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-CDocu-01 T-CDocu-02

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 T-CDocu-01.NroDoc T-CDocu-01.FchDoc ~
T-CDocu-01.FchVto c-Mon[T-CDocu-01.CodMon] T-CDocu-01.ImpTot ~
T-CDocu-01.SdoAct 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH T-CDocu-01 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH T-CDocu-01 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 T-CDocu-01
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 T-CDocu-01


/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 T-CDocu-02.NroDoc T-CDocu-02.FchDoc ~
T-CDocu-02.FchVto c-Mon[T-CDocu-02.CodMon] T-CDocu-02.ImpTot ~
T-CDocu-02.SdoAct 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH T-CDocu-02 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH T-CDocu-02 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 T-CDocu-02
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 T-CDocu-02


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-3}~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Division FILL-IN-CodCta ~
FILL-IN-CodAge BUTTON-3 BtnDone BROWSE-3 BROWSE-4 BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Division FILL-IN-CodCta ~
FILL-IN_Banco FILL-IN-CodAge FILL-IN-Agencia RADIO-SET-CodMon 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "&Done" 
     SIZE 15 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/arrow-right.jpg":U
     LABEL "Button 1" 
     SIZE 11 BY 2.31.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/arrow-left.jpg":U
     LABEL "Button 2" 
     SIZE 11 BY 2.12.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 3" 
     SIZE 15 BY 1.54.

DEFINE VARIABLE COMBO-BOX-Division AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 56 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Agencia AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodAge AS CHARACTER FORMAT "X(256)":U 
     LABEL "Agencia" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Banco" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Banco AS CHARACTER FORMAT "x(50)" 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81.

DEFINE VARIABLE RADIO-SET-CodMon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "SOLES", 1,
"DOLARES", 2
     SIZE 19 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      T-CDocu-01 SCROLLING.

DEFINE QUERY BROWSE-4 FOR 
      T-CDocu-02 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 wWin _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      T-CDocu-01.NroDoc FORMAT "X(12)":U WIDTH 9.43
      T-CDocu-01.FchDoc COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
            WIDTH 7.43
      T-CDocu-01.FchVto COLUMN-LABEL "Vencimiento" FORMAT "99/99/9999":U
            WIDTH 9.43
      c-Mon[T-CDocu-01.CodMon] COLUMN-LABEL "Mon" FORMAT "x(3)":U
      T-CDocu-01.ImpTot FORMAT "->>>,>>9.99":U WIDTH 10.14
      T-CDocu-01.SdoAct COLUMN-LABEL "Saldo Actual" FORMAT "->>>,>>9.99":U
            WIDTH 10.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 57 BY 12.88
         FONT 4
         TITLE "LETRAS EN CARTERA" ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 wWin _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      T-CDocu-02.NroDoc FORMAT "X(12)":U WIDTH 10.43
      T-CDocu-02.FchDoc COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
            WIDTH 7.43
      T-CDocu-02.FchVto COLUMN-LABEL "Vencimiento" FORMAT "99/99/9999":U
            WIDTH 9.43
      c-Mon[T-CDocu-02.CodMon] COLUMN-LABEL "Mon" FORMAT "x(3)":U
      T-CDocu-02.ImpTot FORMAT "->>>,>>9.99":U WIDTH 10.14
      T-CDocu-02.SdoAct COLUMN-LABEL "Saldo Actual" FORMAT "->>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 58 BY 12.88
         FONT 4
         TITLE "LETRAS PARA ENVIAR AL BANCO" ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     COMBO-BOX-Division AT ROW 1.19 COL 14 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-CodCta AT ROW 2.15 COL 14 COLON-ALIGNED WIDGET-ID 14
     FILL-IN_Banco AT ROW 2.15 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     FILL-IN-CodAge AT ROW 3.12 COL 14 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-Agencia AT ROW 3.12 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     BUTTON-3 AT ROW 3.5 COL 105 WIDGET-ID 32
     BtnDone AT ROW 3.5 COL 120 WIDGET-ID 34
     RADIO-SET-CodMon AT ROW 4.08 COL 16 NO-LABEL WIDGET-ID 22
     BROWSE-3 AT ROW 5.23 COL 3 WIDGET-ID 200
     BROWSE-4 AT ROW 5.23 COL 77 WIDGET-ID 300
     BUTTON-1 AT ROW 7.15 COL 63 WIDGET-ID 28
     BUTTON-2 AT ROW 9.46 COL 63 WIDGET-ID 30
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 4.27 COL 9 WIDGET-ID 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 136.43 BY 17.69
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: T-CDocu-01 T "?" ? INTEGRAL CcbCDocu
      TABLE: T-CDocu-02 T "?" ? INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "ENVIO DE LETRAS AL BANCO - EN TRANSITO"
         HEIGHT             = 17.69
         WIDTH              = 136.43
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
/* BROWSE-TAB BROWSE-3 RADIO-SET-CodMon fMain */
/* BROWSE-TAB BROWSE-4 BROWSE-3 fMain */
/* SETTINGS FOR FILL-IN FILL-IN-Agencia IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Banco IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET RADIO-SET-CodMon IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.T-CDocu-01"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-CDocu-01.NroDoc
"T-CDocu-01.NroDoc" ? "X(12)" "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-CDocu-01.FchDoc
"T-CDocu-01.FchDoc" "Emisión" ? "date" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-CDocu-01.FchVto
"T-CDocu-01.FchVto" "Vencimiento" ? "date" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"c-Mon[T-CDocu-01.CodMon]" "Mon" "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-CDocu-01.ImpTot
"T-CDocu-01.ImpTot" ? "->>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-CDocu-01.SdoAct
"T-CDocu-01.SdoAct" "Saldo Actual" "->>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.T-CDocu-02"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-CDocu-02.NroDoc
"T-CDocu-02.NroDoc" ? "X(12)" "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-CDocu-02.FchDoc
"T-CDocu-02.FchDoc" "Emisión" ? "date" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-CDocu-02.FchVto
"T-CDocu-02.FchVto" "Vencimiento" ? "date" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"c-Mon[T-CDocu-02.CodMon]" "Mon" "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-CDocu-02.ImpTot
"T-CDocu-02.ImpTot" ? "->>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-CDocu-02.SdoAct
"T-CDocu-02.SdoAct" "Saldo Actual" "->>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* ENVIO DE LETRAS AL BANCO - EN TRANSITO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* ENVIO DE LETRAS AL BANCO - EN TRANSITO */
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



&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* Button 1 */
DO:
  IF FILL-IN-CodCta:SCREEN-VALUE = '' THEN DO:
      MESSAGE 'Debe ingresar primero el banco' VIEW-AS ALERT-BOX WARNING.
      APPLY 'ENTRY':U TO FILL-IN-CodCta.
      RETURN NO-APPLY.
  END.
  RUN Enviar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 wWin
ON CHOOSE OF BUTTON-2 IN FRAME fMain /* Button 2 */
DO:
    IF FILL-IN-CodCta:SCREEN-VALUE = '' THEN DO:
        MESSAGE 'Debe ingresar primero el banco' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO FILL-IN-CodCta.
        RETURN NO-APPLY.
    END.
    RUN Regresar.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Division wWin
ON VALUE-CHANGED OF COMBO-BOX-Division IN FRAME fMain /* División */
DO:
  x-CodDiv = ENTRY(1, SELF:SCREEN-VALUE, ' - ').
  RUN Carga-Temporales.
  {&OPEN-QUERY-BROWSE-3}
  {&OPEN-QUERY-BROWSE-4}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodAge
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodAge wWin
ON LEAVE OF FILL-IN-CodAge IN FRAME fMain /* Agencia */
DO:
    FIND gn-agbco WHERE gn-agbco.codcia = s-codcia 
        AND gn-agbco.codbco = FILL-IN-CodCta:SCREEN-VALUE IN FRAME {&FRAME-NAME}
        AND gn-agbco.codage = FILL-IN-CodAge:SCREEN-VALUE IN FRAME {&FRAME-NAME}
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-agbco THEN 
        DISPLAY gn-agbco.nomage @ FILL-IN-Agencia WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCta wWin
ON LEAVE OF FILL-IN-CodCta IN FRAME fMain /* Banco */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
         cb-ctas.Codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
       MESSAGE 'Cuenta contable no existe' VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    x-codmon = cb-ctas.Codmon.
    RADIO-SET-CodMon:SCREEN-VALUE = STRING(cb-ctas.Codmon, '9').
    DISPLAY cb-ctas.Nomcta @ FILL-IN_Banco WITH FRAME {&FRAME-NAME}.
    SELF:SENSITIVE = NO.
    RUN Carga-Temporales.
    {&OPEN-QUERY-BROWSE-3}
    {&OPEN-QUERY-BROWSE-4}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporales wWin 
PROCEDURE Carga-Temporales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-CDocu-01.
EMPTY TEMP-TABLE T-CDocu-02.

FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.coddiv = x-coddiv
    AND ccbcdocu.coddoc = "LET"
    AND ccbcdocu.codmon = x-codmon
    AND ccbcdocu.flgest = "P"        /* Pendientes */
    AND ccbcdocu.flgubi = "C"        /* En cartera */
    AND ccbcdocu.flgsit = "C":       /* Cobranza libre */
    CREATE T-CDocu-01.
    BUFFER-COPY Ccbcdocu TO T-CDocu-01.
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
  DISPLAY COMBO-BOX-Division FILL-IN-CodCta FILL-IN_Banco FILL-IN-CodAge 
          FILL-IN-Agencia RADIO-SET-CodMon 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE COMBO-BOX-Division FILL-IN-CodCta FILL-IN-CodAge BUTTON-3 BtnDone 
         BROWSE-3 BROWSE-4 BUTTON-1 BUTTON-2 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Enviar wWin 
PROCEDURE Enviar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE T-CDocu-01 THEN RETURN.
CREATE T-CDocu-02.
BUFFER-COPY T-CDocu-01 TO T-CDocu-02.
DELETE T-CDocu-01.
{&OPEN-QUERY-BROWSE-3}
{&OPEN-QUERY-BROWSE-4}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR cLista AS CHAR NO-UNDO.

  FOR EACH gn-divi NO-LOCK WHERE codcia = s-codcia:
      IF cLista = '' THEN cLista = gn-divi.coddiv + ' - ' + gn-divi.desdiv.
      ELSE cLista = cLista + ',' + gn-divi.coddiv + ' - ' + gn-divi.desdiv.
      IF gn-divi.coddiv = s-coddiv THEN
          COMBO-BOX-Division = gn-divi.coddiv + ' - ' + gn-divi.desdiv.
  END.
  COMBO-BOX-Division:ADD-LAST(cLista) IN FRAME {&FRAME-NAME}.
  x-coddiv = s-coddiv.
  RUN Carga-Temporales.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Regresar wWin 
PROCEDURE Regresar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE T-CDocu-02 THEN RETURN.
CREATE T-CDocu-01.
BUFFER-COPY T-CDocu-02 TO T-CDocu-01.
DELETE T-CDocu-02.
{&OPEN-QUERY-BROWSE-3}
{&OPEN-QUERY-BROWSE-4}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

