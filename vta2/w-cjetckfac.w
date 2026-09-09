&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDocu FOR CcbCDocu.
DEFINE BUFFER B-DDocu FOR CcbDDocu.



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

DEF SHARED VAR cl-codcia AS INT.

DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.

FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE TEMP-TABLE deta LIKE ccbddocu.
DEFINE BUFFER b-CcbCDocu FOR CcbCDocu.

  /* ********************************************* */
  /* Inicio de actividades facturación electrónica */
  /* ********************************************* */
  DEF VAR pStatus AS LOG.
  RUN sunat\p-inicio-actividades (INPUT TODAY, OUTPUT pStatus).
  IF pStatus = YES THEN DO:     /* Ya iniciaron las actividades */
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN ERROR.
  END.
  /* ********************************************* */

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
&Scoped-define BROWSE-NAME BROWSE-6

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbDDocu Almmmatg

/* Definitions for BROWSE BROWSE-6                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-6 CcbDDocu.codmat Almmmatg.DesMat ~
CcbDDocu.UndVta CcbDDocu.CanDes CcbDDocu.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-6 
&Scoped-define QUERY-STRING-BROWSE-6 FOR EACH CcbDDocu ~
      WHERE CcbDDocu.CodCia = s-codcia ~
 AND CcbDDocu.CodDoc = "TCK" ~
 AND CcbDDocu.NroDoc = FILL-IN-NroTck NO-LOCK, ~
      EACH Almmmatg OF CcbDDocu NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-6 OPEN QUERY BROWSE-6 FOR EACH CcbDDocu ~
      WHERE CcbDDocu.CodCia = s-codcia ~
 AND CcbDDocu.CodDoc = "TCK" ~
 AND CcbDDocu.NroDoc = FILL-IN-NroTck NO-LOCK, ~
      EACH Almmmatg OF CcbDDocu NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-6 CcbDDocu Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-6 CcbDDocu
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-6 Almmmatg


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-6}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-NroTck BROWSE-6 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NroTck COMBO-NroSer FILL-IN-NroDoc ~
FILL-IN_CodCli FILL-IN_NomCli FILL-IN_FchDoc FILL-IN_DirCli FILL-IN_FchVto ~
FILL-IN_RucCli RADIO-SET_CodMon FILL-IN-ImpTot 

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
     LABEL "&Done" 
     SIZE 7 BY 1.65 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-Grabar 
     IMAGE-UP FILE "img/tick.ico":U
     IMAGE-INSENSITIVE FILE "img/delete.ico":U
     LABEL "Button 9" 
     SIZE 7 BY 1.62 TOOLTIP "Generamos la Nueva Factura".

DEFINE BUTTON BUTTON-Modificar 
     IMAGE-UP FILE "img/plus.ico":U
     IMAGE-INSENSITIVE FILE "img/delete.ico":U
     LABEL "Button 10" 
     SIZE 7 BY 1.62 TOOLTIP "Nuevo Número de Ticket".

DEFINE VARIABLE COMBO-NroSer AS CHARACTER FORMAT "X(3)":U 
     LABEL "Serie" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpTot AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "IMPORTE TOTAL" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "XXX-XXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .92
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroTck AS CHARACTER FORMAT "x(9)":U 
     LABEL "Número de Ticket" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodCli AS CHARACTER FORMAT "x(11)" 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 11 FGCOLOR 9 .

DEFINE VARIABLE FILL-IN_DirCli AS CHARACTER FORMAT "x(60)" 
     LABEL "Direccion" 
     VIEW-AS FILL-IN 
     SIZE 70 BY .81
     BGCOLOR 11 FGCOLOR 9 .

DEFINE VARIABLE FILL-IN_FchDoc AS DATE FORMAT "99/99/9999" INITIAL 05/30/11 
     LABEL "F/ Emision" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81.

DEFINE VARIABLE FILL-IN_FchVto AS DATE FORMAT "99/99/9999" 
     LABEL "Vencimiento" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "x(50)" 
     VIEW-AS FILL-IN 
     SIZE 57 BY .81
     BGCOLOR 11 FGCOLOR 9 .

DEFINE VARIABLE FILL-IN_RucCli AS CHARACTER FORMAT "x(11)" 
     LABEL "Ruc" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 11 FGCOLOR 9 .

DEFINE VARIABLE RADIO-SET_CodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 10.72 BY .81.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-6 FOR 
      CcbDDocu, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-6 wWin _STRUCTURED
  QUERY BROWSE-6 NO-LOCK DISPLAY
      CcbDDocu.codmat COLUMN-LABEL "Producto" FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(60)":U
      CcbDDocu.UndVta FORMAT "XXXX":U
      CcbDDocu.CanDes FORMAT ">,>>>,>>9.9999":U
      CcbDDocu.ImpLin FORMAT "->>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 105 BY 10.23 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     FILL-IN-NroTck AT ROW 2.88 COL 19 COLON-ALIGNED WIDGET-ID 2
     COMBO-NroSer AT ROW 3.96 COL 5.57 WIDGET-ID 62
     FILL-IN-NroDoc AT ROW 3.96 COL 16 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     FILL-IN_CodCli AT ROW 5.04 COL 9 COLON-ALIGNED WIDGET-ID 18
     FILL-IN_NomCli AT ROW 5.04 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     FILL-IN_FchDoc AT ROW 4.23 COL 91 COLON-ALIGNED WIDGET-ID 34
     FILL-IN_DirCli AT ROW 5.85 COL 9 COLON-ALIGNED WIDGET-ID 26
     FILL-IN_FchVto AT ROW 5.04 COL 91 COLON-ALIGNED WIDGET-ID 36
     FILL-IN_RucCli AT ROW 6.65 COL 9 COLON-ALIGNED WIDGET-ID 52
     RADIO-SET_CodMon AT ROW 5.85 COL 93 NO-LABEL WIDGET-ID 20
     BROWSE-6 AT ROW 8 COL 3 WIDGET-ID 200
     FILL-IN-ImpTot AT ROW 18.5 COL 86 COLON-ALIGNED WIDGET-ID 60
     BUTTON-Modificar AT ROW 1 COL 2 WIDGET-ID 58
     BUTTON-Grabar AT ROW 1 COL 9 WIDGET-ID 56
     BtnDone AT ROW 1 COL 16 WIDGET-ID 50
     "Moneda:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 6.12 COL 84 WIDGET-ID 54
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 108.14 BY 18.69 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: B-CDocu B "?" ? INTEGRAL CcbCDocu
      TABLE: B-DDocu B "?" ? INTEGRAL CcbDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "CANJE DE TICKETS POR FACTURA"
         HEIGHT             = 18.69
         WIDTH              = 108.14
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.43
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.43
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

{src/adm-vm/method/vmviewer.i}
{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-6 RADIO-SET_CodMon fMain */
ASSIGN 
       FRAME fMain:HIDDEN           = TRUE
       FRAME fMain:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR BUTTON BUTTON-Grabar IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-Modificar IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-NroSer IN FRAME fMain
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-ImpTot IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodCli IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DirCli IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_FchDoc IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_FchVto IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_RucCli IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET RADIO-SET_CodMon IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-6
/* Query rebuild information for BROWSE BROWSE-6
     _TblList          = "INTEGRAL.CcbDDocu,INTEGRAL.Almmmatg OF INTEGRAL.CcbDDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "CcbDDocu.CodCia = s-codcia
 AND CcbDDocu.CodDoc = ""TCK""
 AND CcbDDocu.NroDoc = FILL-IN-NroTck"
     _FldNameList[1]   > INTEGRAL.CcbDDocu.codmat
"CcbDDocu.codmat" "Producto" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.CcbDDocu.UndVta
     _FldNameList[4]   = INTEGRAL.CcbDDocu.CanDes
     _FldNameList[5]   = INTEGRAL.CcbDDocu.ImpLin
     _Query            is OPENED
*/  /* BROWSE BROWSE-6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* CANJE DE TICKETS POR FACTURA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* CANJE DE TICKETS POR FACTURA */
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


&Scoped-define SELF-NAME BUTTON-Grabar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Grabar wWin
ON CHOOSE OF BUTTON-Grabar IN FRAME fMain /* Button 9 */
DO:
    MESSAGE 'Generamos la FACTURA?'
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
    ASSIGN
        COMBO-NroSer 
        FILL-IN_CodCli 
        FILL-IN_DirCli 
        FILL-IN_NomCli 
        FILL-IN_RucCli 
        FILL-IN-NroTck.
    RUN Valida.
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    RUN Genera-Factura02.
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    ASSIGN
        BUTTON-Grabar:SENSITIVE = NO
        BUTTON-Modificar:SENSITIVE = NO.
    RUN Habilita-Campos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Modificar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Modificar wWin
ON CHOOSE OF BUTTON-Modificar IN FRAME fMain /* Button 10 */
DO:
    ASSIGN
        BUTTON-Grabar:SENSITIVE = NO
        BUTTON-Modificar:SENSITIVE = NO.
    RUN Habilita-Campos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer wWin
ON RETURN OF COMBO-NroSer IN FRAME fMain /* Serie */
DO:
    APPLY 'Tab':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer wWin
ON VALUE-CHANGED OF COMBO-NroSer IN FRAME fMain /* Serie */
DO:
    /* Correlativo */
    FIND FacCorre WHERE
        FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDoc = "FAC" AND
        FacCorre.CodDiv = s-CodDiv AND
        FacCorre.NroSer = INTEGER(SELF:SCREEN-VALUE)
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCorre THEN
        FILL-IN-NroDoc =
            STRING(FacCorre.NroSer,"999") +
            STRING(FacCorre.Correlativo,"999999").
    ELSE FILL-IN-NroDoc = "".
    DISPLAY FILL-IN-NroDoc WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroTck
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroTck wWin
ON LEAVE OF FILL-IN-NroTck IN FRAME fMain /* Número de Ticket */
DO:
  ASSIGN {&self-name}.
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND ccbcdocu WHERE codcia = s-codcia
      AND coddoc = 'TCK'
      AND nrodoc = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Ccbcdocu THEN DO:
      MESSAGE 'Ticket NO registrado' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF Ccbcdocu.coddiv <> s-coddiv THEN DO:
      MESSAGE 'Ticket NO corresponde a esta sede' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF Ccbcdocu.flgest = 'A' THEN DO:
      MESSAGE 'Ticket está ANULADO' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF Ccbcdocu.flgest <> 'C' THEN DO:
      MESSAGE 'Ticket NO ha sido aún cancelado en caja' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF Ccbcdocu.fchdoc <> TODAY THEN DO:
      MESSAGE 'Ticket NO es del día' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  /* ********************************************* */
  /* Inicio de actividades facturación electrónica */
  /* ********************************************* */
  DEF VAR pStatus AS LOG.
  RUN sunat\p-inicio-actividades (INPUT Ccbcdocu.fchdoc, OUTPUT pStatus).
  IF pStatus = YES THEN DO:     /* Ya iniciaron las actividades */
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  /* ********************************************* */

  /* Pintamos información, antivamos campos y bloqueamos el ticket */
  DO WITH FRAME {&FRAME-NAME}:
      DISPLAY 
          ccbcdocu.codcli @ FILL-IN_CodCli 
          ccbcdocu.dircli @ FILL-IN_DirCli 
          ccbcdocu.fchdoc @ FILL-IN_FchDoc 
          ccbcdocu.fchvto @ FILL-IN_FchVto 
          ccbcdocu.nomcli @ FILL-IN_NomCli 
          ccbcdocu.ruccli @ FILL-IN_RucCli
          ccbcdocu.imptot @ FILL-IN-ImpTot.
      ASSIGN
          COMBO-NroSer:SENSITIVE = YES
          FILL-IN_CodCli:SENSITIVE = YES
          FILL-IN_DirCli:SENSITIVE = YES
          FILL-IN_NomCli:SENSITIVE = YES
          FILL-IN_RucCli:SENSITIVE = YES
          FILL-IN-NroTck:SENSITIVE = NO.
      ASSIGN
          BUTTON-Grabar:SENSITIVE = YES
          BUTTON-Modificar:SENSITIVE = YES.
      {&OPEN-QUERY-{&BROWSE-NAME}}
      APPLY 'ENTRY':U TO COMBO-NroSer.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodCli wWin
ON LEAVE OF FILL-IN_CodCli IN FRAME fMain /* Cliente */
DO:
    FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
        AND gn-clie.codcli = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie 
        THEN DISPLAY 
                gn-clie.NomCli @ FILL-IN_NomCli
                gn-clie.Ruc    @ FILL-IN_RucCli
                gn-clie.DirCli @ FILL-IN_DirCli
                WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodCli wWin
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_CodCli IN FRAME fMain /* Cliente */
OR f8 OF FILL-IN_CodCli
DO:
  ASSIGN
      input-var-1 = ''
      input-var-2 = ''
      input-var-3 = ''.
  RUN vtagn/c-gn-clie-01 ('Clientes').
  IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-6
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
  DISPLAY FILL-IN-NroTck COMBO-NroSer FILL-IN-NroDoc FILL-IN_CodCli 
          FILL-IN_NomCli FILL-IN_FchDoc FILL-IN_DirCli FILL-IN_FchVto 
          FILL-IN_RucCli RADIO-SET_CodMon FILL-IN-ImpTot 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE FILL-IN-NroTck BROWSE-6 BtnDone 
      WITH FRAME fMain IN WINDOW wWin.
  VIEW FRAME fMain IN WINDOW wWin.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Factura wWin 
PROCEDURE Genera-Factura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR cCodDoc        AS CHAR NO-UNDO.
DEF VAR x-Limite-Items AS INT  NO-UNDO.
DEF VAR N-ITMS         AS INT  NO-UNDO.

cCodDoc = 'FAC'.
CASE Ccbcdocu.coddoc:
    WHEN 'FAC' THEN x-Limite-Items = FacCfgGn.Items_Factura.
    WHEN 'BOL' THEN x-Limite-Items = FacCfgGn.Items_Boleta.
END CASE.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddoc = "TCK"
        AND Ccbcdocu.nrodoc = FILL-IN-NroTck
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu THEN DO:
        MESSAGE 'No se pudo bloquear el Ticket' FILL-IN-NroTck
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.

    /* Correlativo */
    {vtagn/i-faccorre-01.i &Codigo = cCodDoc &Serie = INTEGER(COMBO-NroSer) }

    /* Cabecera */
    CREATE B-CDocu.
    BUFFER-COPY Ccbcdocu 
        TO B-CDocu
        ASSIGN
            B-CDocu.coddoc = "FAC"
            B-CDocu.NroDoc = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999") 
            B-CDocu.codcli = FILL-IN_CodCli 
            B-CDocu.dircli = FILL-IN_DirCli 
            B-CDocu.nomcli = FILL-IN_NomCli 
            B-CDocu.ruccli = FILL-IN_RucCli.
    ASSIGN
        B-CDocu.HorCie = STRING(TIME,'hh:mm')
        B-CDocu.usuario = s-user-id
        FacCorre.Correlativo = FacCorre.Correlativo + 1.


    /**************************************************************/

/*     FOR EACH DETA:                                                          */
/*         IF (N-ITMS + 1) <= x-Limite-Items     /* Limitamos el # de items */ */
/*         THEN DO:                                                            */
/*             CREATE CcbDDocu.                                                */
/*             BUFFER-COPY DETA TO CcbDDocu                                    */
/*                 ASSIGN                                                      */
/*                     CcbDDocu.CodCia = CcbCDocu.CodCia                       */
/*                     CcbDDocu.CodDoc = CcbCDocu.CodDoc                       */
/*                     CcbDDocu.NroDoc = CcbCDocu.NroDoc                       */
/*                     CcbDDocu.FchDoc = TODAY                                 */
/*                     CcbDDocu.CodDiv = CcbCDocu.CodDiv.                      */
/*                     CcbDDocu.ImpCto = DETA.ImpCto.                          */
/*             N-ITMS = N-ITMS + 1.                                            */
/*             DELETE DETA.    /* Vamos borrando lo que pasa a la factura */   */
/*         END.                                                                */
/*     END.                                                                    */


    /*************************************************************/

    /* Detalle */
    FOR EACH Ccbddocu OF Ccbcdocu:
        IF (N-ITMS + 1) <= x-Limite-Items THEN DO:
            CREATE B-DDocu.
            BUFFER-COPY Ccbddocu 
                TO B-DDocu
                ASSIGN
                    B-DDocu.coddoc = B-CDocu.coddoc
                    B-DDocu.nrodoc = B-CDocu.nrodoc.
        END.
    END.
    /* Anulacion del TCK */
    ASSIGN
        CcbCDocu.FchAnu = TODAY
        CcbCDocu.FlgEst = "A"
        CcbCDocu.UsuAnu = s-user-id.
    /* Cancelación de la FAC */
    FOR EACH Ccbdcaja WHERE Ccbdcaja.codcia = s-codcia
        AND Ccbdcaja.codref = Ccbcdocu.coddoc
        AND Ccbdcaja.nroref = Ccbcdocu.nrodoc:
        ASSIGN
            Ccbdcaja.codref = B-CDocu.coddoc
            Ccbdcaja.nroref = B-CDocu.nrodoc.
    END.
    IF AVAILABLE(B-CDocu) THEN RELEASE B-CDocu.
    IF AVAILABLE(B-DDocu) THEN RELEASE B-DDocu.
    IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
    IF AVAILABLE(Ccbdcaja) THEN RELEASE Ccbdcaja.
    IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Factura02 wWin 
PROCEDURE Genera-Factura02 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cCodDoc         AS CHAR NO-UNDO.
DEFINE VARIABLE x-Limite-Items  AS INT  NO-UNDO.
DEFINE VARIABLE N-ITMS          AS INT  NO-UNDO.
DEFINE VARIABLE T-ITMS          AS INT  NO-UNDO.
DEFINE VARIABLE iCountGuide     AS INTEGER     NO-UNDO.

EMPTY TEMP-TABLE DETA.

cCodDoc = 'FAC'.
CASE cCodDoc:
    WHEN 'FAC' THEN x-Limite-Items = FacCfgGn.Items_Factura.
    WHEN 'BOL' THEN x-Limite-Items = FacCfgGn.Items_Boleta.
END CASE.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddoc = "TCK"
        AND Ccbcdocu.nrodoc = FILL-IN-NroTck
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu THEN DO:
        MESSAGE 'No se pudo bloquear el Ticket' FILL-IN-NroTck
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.

    /*Copia Detalle*/
    T-ITMS = 0.
    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
        CREATE DETA.
        BUFFER-COPY ccbddocu TO deta.
        T-ITMS = T-ITMS + 1.
    END.

    iCountGuide = 0.
    REPEAT:
        FIND FIRST DETA NO-LOCK NO-ERROR.
        IF NOT AVAILABLE DETA THEN LEAVE.        
        
        /* Correlativo */
        {vtagn/i-faccorre-01.i &Codigo = cCodDoc &Serie = INTEGER(COMBO-NroSer) }
        iCountGuide = iCountGuide + 1.

        /* Cabecera */
        CREATE B-CDocu.
        BUFFER-COPY Ccbcdocu 
            TO B-CDocu
            ASSIGN
                B-CDocu.coddoc = "FAC"
                B-CDocu.NroDoc = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999") 
                B-CDocu.codcli = FILL-IN_CodCli 
                B-CDocu.dircli = FILL-IN_DirCli 
                B-CDocu.nomcli = FILL-IN_NomCli 
                B-CDocu.ruccli = FILL-IN_RucCli.
        ASSIGN
            B-CDocu.HorCie = STRING(TIME,'hh:mm')
            B-CDocu.usuario = s-user-id
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
        
        N-ITMS = 0.
        /* Detalle */
        FOR EACH DETA OF Ccbcdocu:
            IF (N-ITMS + 1) <= x-Limite-Items THEN DO:
                CREATE B-DDocu.
                BUFFER-COPY DETA 
                    TO B-DDocu
                    ASSIGN
                        B-DDocu.coddoc = B-CDocu.coddoc
                        B-DDocu.nrodoc = B-CDocu.nrodoc.
                N-ITMS = N-ITMS + 1.
/*                 P-ITMS = P-ITMS + 1. */
                DELETE DETA.
            END.            
        END.
        /*****Graba Totales*****/
        RUN Graba-Totales (ROWID(b-cdocu)).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

        /* Cancelación de la FAC */
        FOR EACH Ccbdcaja WHERE Ccbdcaja.codcia = s-codcia
            AND Ccbdcaja.codref = Ccbcdocu.coddoc
            AND Ccbdcaja.nroref = Ccbcdocu.nrodoc:
            ASSIGN
                Ccbdcaja.codref = B-CDocu.coddoc
                Ccbdcaja.nroref = B-CDocu.nrodoc.
        END.
    END.

    /* Anulacion del TCK */
    ASSIGN
        CcbCDocu.FchAnu = TODAY
        CcbCDocu.FlgEst = "A"
        CcbCDocu.UsuAnu = s-user-id.

    IF AVAILABLE(B-CDocu) THEN RELEASE B-CDocu.
    IF AVAILABLE(B-DDocu) THEN RELEASE B-DDocu.
    IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
    IF AVAILABLE(Ccbdcaja) THEN RELEASE Ccbdcaja.
    IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.

END.

MESSAGE
    "Se ha(n) generado" iCountGuide "guía(s)"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales wWin 
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER x-rowid AS ROWID NO-UNDO.

    DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
    DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.

    DO ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR": 
        
        FIND FIRST b-CcbCDocu WHERE ROWID(b-CcbCDocu) = x-rowid 
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL b-CcbCDocu THEN RETURN "ADM-ERROR".
        ASSIGN
            b-CcbCDocu.ImpDto = 0
            b-CcbCDocu.ImpIgv = 0
            b-CcbCDocu.ImpIsc = 0
            b-CcbCDocu.ImpTot = 0
            b-CcbCDocu.ImpExo = 0.
        FOR EACH Ccbddocu OF b-CcbCDocu NO-LOCK:        
           F-Igv = F-Igv + Ccbddocu.ImpIgv.
           F-Isc = F-Isc + Ccbddocu.ImpIsc.
           b-CcbCDocu.ImpTot = b-CcbCDocu.ImpTot + Ccbddocu.ImpLin.
           IF NOT Ccbddocu.AftIgv THEN b-CcbCDocu.ImpExo = b-CcbCDocu.ImpExo + Ccbddocu.ImpLin.
           IF Ccbddocu.AftIgv = YES
           THEN b-CcbCDocu.ImpDto = b-CcbCDocu.ImpDto + ROUND(Ccbddocu.ImpDto / (1 + b-CcbCDocu.PorIgv / 100), 2).
           ELSE b-CcbCDocu.ImpDto = b-CcbCDocu.ImpDto + Ccbddocu.ImpDto.
        END.
        ASSIGN
            b-CcbCDocu.ImpIgv = ROUND(F-IGV,2)
            b-CcbCDocu.ImpIsc = ROUND(F-ISC,2)
            b-CcbCDocu.ImpVta = b-CcbCDocu.ImpTot - b-CcbCDocu.ImpExo - b-CcbCDocu.ImpIgv.
        /* RHC 22.12.06 */
        IF b-CcbCDocu.PorDto > 0 THEN DO:
            b-CcbCDocu.ImpDto = b-CcbCDocu.ImpDto + ROUND((b-CcbCDocu.ImpVta + b-CcbCDocu.ImpExo) * b-CcbCDocu.PorDto / 100, 2).
            b-CcbCDocu.ImpTot = ROUND(b-CcbCDocu.ImpTot * (1 - b-CcbCDocu.PorDto / 100),2).
            b-CcbCDocu.ImpVta = ROUND(b-CcbCDocu.ImpVta * (1 - b-CcbCDocu.PorDto / 100),2).
            b-CcbCDocu.ImpExo = ROUND(b-CcbCDocu.ImpExo * (1 - b-CcbCDocu.PorDto / 100),2).
            b-CcbCDocu.ImpIgv = b-CcbCDocu.ImpTot - b-CcbCDocu.ImpExo - b-CcbCDocu.ImpVta.
        END.
        ASSIGN
            b-CcbCDocu.ImpBrt = b-CcbCDocu.ImpVta + b-CcbCDocu.ImpIsc + b-CcbCDocu.ImpDto + b-CcbCDocu.ImpExo
            b-CcbCDocu.SdoAct  = b-CcbCDocu.ImpTot.
            /*b-CcbCDocu.FlgEst = "P".*/
    /*         b-CcbCDocu.Imptot2 = b-CcbCDocu.ImpTot. */

        /* APLICAMOS EL IMPORTE POR FACTURA POR ADELANTOS */
        ASSIGN
            b-CcbCDocu.SdoAct = b-CcbCDocu.SdoAct - b-CcbCDocu.ImpTot2.

        /*RDP 31.01.11 - Parche Tarjetas*/
        ASSIGN 
            b-CcbCDocu.Imptot = b-CcbCDocu.ImpTot - b-CcbCDocu.ImpDto2.

        RELEASE b-CcbCDocu.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Habilita-Campos wWin 
PROCEDURE Habilita-Campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
      FILL-IN-NroTck = ''.
      ASSIGN
          FILL-IN_CodCli:SCREEN-VALUE = ''
          FILL-IN_DirCli:SCREEN-VALUE = ''
          FILL-IN_NomCli:SCREEN-VALUE = ''
          FILL-IN_RucCli:SCREEN-VALUE = ''
          FILL-IN-NroTck:SCREEN-VALUE = ''.
      ASSIGN
          COMBO-NroSer:SENSITIVE = NO
          FILL-IN_CodCli:SENSITIVE = NO
          FILL-IN_DirCli:SENSITIVE = NO
          FILL-IN_NomCli:SENSITIVE = NO
          FILL-IN_RucCli:SENSITIVE = NO
          FILL-IN-NroTck:SENSITIVE = YES.
      APPLY 'ENTRY':U TO FILL-IN-NroTck.
      {&OPEN-QUERY-{&BROWSE-NAME}}
  END.

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
  FOR EACH FacCorre NO-LOCK WHERE 
      FacCorre.CodCia = s-CodCia AND
      FacCorre.CodDiv = s-CodDiv AND 
      FacCorre.CodDoc = "FAC" AND
      FacCorre.FlgEst = YES:
      IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
      ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
  END.
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-NroSer:LIST-ITEMS = cListItems.
      COMBO-NroSer = ENTRY(1,COMBO-NroSer:LIST-ITEMS).
      /* Correlativo */
      FIND FacCorre WHERE
          FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDoc = "FAC" AND
          FacCorre.CodDiv = s-CodDiv AND
          FacCorre.NroSer = INTEGER(COMBO-NroSer)
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN
          FILL-IN-NroDoc =
              STRING(FacCorre.NroSer,"999") +
              STRING(FacCorre.Correlativo,"999999").
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida wWin 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    IF FILL-IN_CodCli = '' 
        OR FILL-IN_DirCli = ''
        OR FILL-IN_NomCli = ''
        OR FILL-IN_RucCli = '' THEN DO:
        MESSAGE 'Ingrese todos los datos' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.

    RUN vtagn/p-gn-clie-01 (FILL-IN_CodCli, "").
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN "ADM-ERROR".

    IF LENGTH(FILL-IN_RucCli) < 11 OR LOOKUP(SUBSTRING(FILL-IN_RucCli,1,2), '10,20,15') = 0 THEN DO:
        MESSAGE 'Debe tener 11 dígitos y comenzar con 20, 10 ó 15' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    /* dígito verificador */
    DEF VAR pResultado AS CHAR.
    RUN lib/_ValRuc (FILL-IN_RucCli, OUTPUT pResultado).
    IF pResultado = 'ERROR' THEN DO:
        MESSAGE 'RUC MAL registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

