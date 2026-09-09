&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE CREQ NO-UNDO LIKE LG-CRequ
       FIELD Flag AS CHAR FORMAT 'x'.
DEFINE NEW SHARED TEMP-TABLE DCMP LIKE LG-DOCmp.



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
DEF NEW SHARED VAR pv-codcia AS INT.
DEF NEW SHARED VAR S-PROVEE  AS CHAR.
DEF NEW SHARED VAR S-USER-ID AS CHAR.
DEF NEW SHARED VAR S-TPOCMB  AS DECIMAL INIT 1.
DEF NEW SHARED VAR S-CODMON  AS INTEGER INIT 1.

DEF VAR X-TIPO AS CHAR INIT "CC" NO-UNDO.

FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CREQ

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 Flag CREQ.FchReq CREQ.CodDiv ~
CREQ.Solicita CREQ.Userid-Sol CREQ.NroSer CREQ.NroReq CREQ.TpoReq 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH CREQ NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH CREQ NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 CREQ
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 CREQ


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-27 RECT-1 x-CodPro BROWSE-1 BUTTON-1 ~
BUTTON-2 BUTTON-4 BUTTON-5 x-ModAdq x-CndCmp x-FchEnt x-Observ x-FchVto ~
x-CodAlm x-CodMon BUTTON-6 
&Scoped-Define DISPLAYED-OBJECTS x-CodPro x-NomPro x-ModAdq F-modalidad ~
x-FchDoc x-CndCmp F-DesCnd x-FchEnt x-Observ x-FchVto x-CodAlm F-DirEnt ~
x-CodMon x-TpoCmb 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-updv95 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-genoc AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Marcar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "Marcar todo" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-4 
     LABEL "Desmarcar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-5 
     LABEL "Desmarcar todo" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-6 
     LABEL "GENERAR ORDEN DE COMPRA" 
     SIZE 32 BY 1.12
     FONT 1.

DEFINE VARIABLE F-DesCnd AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.29 BY .81 NO-UNDO.

DEFINE VARIABLE F-DirEnt AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.43 BY .81 NO-UNDO.

DEFINE VARIABLE F-modalidad AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 23.43 BY .81 NO-UNDO.

DEFINE VARIABLE x-CndCmp AS CHARACTER FORMAT "X(3)":U 
     LABEL "Forma de Pago" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodAlm AS CHARACTER FORMAT "X(3)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodPro AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc AS DATE FORMAT "99/99/99":U 
     LABEL "Emision" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchEnt AS DATE FORMAT "99/99/99":U 
     LABEL "Entrega" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchVto AS DATE FORMAT "99/99/99":U 
     LABEL "Maxima" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-ModAdq AS CHARACTER FORMAT "X(2)":U 
     LABEL "Modalidad" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81 NO-UNDO.

DEFINE VARIABLE x-Observ AS CHARACTER FORMAT "X(256)":U 
     LABEL "Observaciones" 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81 NO-UNDO.

DEFINE VARIABLE x-TpoCmb AS DECIMAL FORMAT "ZZ9.9999":U INITIAL 0 
     LABEL "Tipo de Cambio" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 12 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 109 BY 6.35.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 109 BY 5.19.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      CREQ SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 DISPLAY
      Flag
      CREQ.FchReq COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
      CREQ.CodDiv COLUMN-LABEL "Division" FORMAT "XXXXX":U
      CREQ.Solicita COLUMN-LABEL "Almacen" FORMAT "X(3)":U
      CREQ.Userid-Sol COLUMN-LABEL "Usuario" FORMAT "x(12)":U
      CREQ.NroSer COLUMN-LABEL "Serie" FORMAT "999":U
      CREQ.NroReq COLUMN-LABEL "Correlativo" FORMAT "999999":U
      CREQ.TpoReq COLUMN-LABEL "Tipo" FORMAT "X(1)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 70 BY 4.5
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodPro AT ROW 1.58 COL 15 COLON-ALIGNED
     x-NomPro AT ROW 1.58 COL 26 COLON-ALIGNED NO-LABEL
     BROWSE-1 AT ROW 2.73 COL 4
     BUTTON-1 AT ROW 2.73 COL 75
     BUTTON-2 AT ROW 3.88 COL 75
     BUTTON-4 AT ROW 5.04 COL 75
     BUTTON-5 AT ROW 6.19 COL 75
     x-ModAdq AT ROW 7.92 COL 12 COLON-ALIGNED
     F-modalidad AT ROW 7.92 COL 18 COLON-ALIGNED NO-LABEL
     x-FchDoc AT ROW 7.92 COL 95 COLON-ALIGNED
     x-CndCmp AT ROW 8.88 COL 12 COLON-ALIGNED
     F-DesCnd AT ROW 8.88 COL 22 COLON-ALIGNED NO-LABEL
     x-FchEnt AT ROW 8.88 COL 95 COLON-ALIGNED
     x-Observ AT ROW 9.85 COL 12 COLON-ALIGNED
     x-FchVto AT ROW 9.85 COL 95 COLON-ALIGNED
     x-CodAlm AT ROW 10.81 COL 12 COLON-ALIGNED
     F-DirEnt AT ROW 10.81 COL 18 COLON-ALIGNED NO-LABEL
     x-CodMon AT ROW 10.81 COL 97 NO-LABEL
     x-TpoCmb AT ROW 11.77 COL 95 COLON-ALIGNED
     BUTTON-6 AT ROW 21.77 COL 75
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 11 COL 91
     RECT-27 AT ROW 7.54 COL 2
     RECT-1 AT ROW 1.19 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 112.86 BY 22.5
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: CREQ T "?" NO-UNDO INTEGRAL LG-CRequ
      ADDITIONAL-FIELDS:
          FIELD Flag AS CHAR FORMAT 'x'
      END-FIELDS.
      TABLE: DCMP T "NEW SHARED" ? INTEGRAL LG-DOCmp
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "GENERACION DE O/C POR REQUERIMIENTO"
         HEIGHT             = 22.5
         WIDTH              = 113.14
         MAX-HEIGHT         = 27.62
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.62
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
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB BROWSE-1 x-NomPro F-Main */
/* SETTINGS FOR FILL-IN F-DesCnd IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DirEnt IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-modalidad IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-TpoCmb IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.CREQ"
     _FldNameList[1]   > "_<CALC>"
"Flag" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.CREQ.FchReq
"CREQ.FchReq" "Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.CREQ.CodDiv
"CREQ.CodDiv" "Division" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.CREQ.Solicita
"CREQ.Solicita" "Almacen" "X(3)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.CREQ.Userid-Sol
"CREQ.Userid-Sol" "Usuario" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.CREQ.NroSer
"CREQ.NroSer" "Serie" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.CREQ.NroReq
"CREQ.NroReq" "Correlativo" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.CREQ.TpoReq
"CREQ.TpoReq" "Tipo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* GENERACION DE O/C POR REQUERIMIENTO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* GENERACION DE O/C POR REQUERIMIENTO */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Marcar */
DO:
  IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(1) THEN DO:
    CREQ.Flag = '*'.
    {&BROWSE-NAME}:REFRESH().
    RUN Carga-Detalle.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Marcar todo */
DO:
  FOR EACH CREQ:
    CREQ.Flag = '*'.
  END.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  RUN Carga-Detalle.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Desmarcar */
DO:
  IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(1) THEN DO:
    CREQ.Flag = ''.
    {&BROWSE-NAME}:REFRESH().
    RUN Carga-Detalle.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Desmarcar todo */
DO:
  FOR EACH CREQ:
    CREQ.Flag = ''.
  END.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  RUN Carga-Detalle.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* GENERAR ORDEN DE COMPRA */
DO:
  RUN Valida.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  RUN Genera-Orden.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  ASSIGN
    x-CodPro = ''
    x-CodPro:SCREEN-VALUE = ''.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  RUN dispatch IN h_t-genoc ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CndCmp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CndCmp W-Win
ON LEAVE OF x-CndCmp IN FRAME F-Main /* Forma de Pago */
DO:
  F-DesCnd:SCREEN-VALUE = "".
  FIND gn-concp WHERE gn-concp.Codig = x-CndCmp:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-concp 
  THEN F-DesCnd:SCREEN-VALUE = gn-concp.Nombr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodAlm W-Win
ON LEAVE OF x-CodAlm IN FRAME F-Main /* Almacen */
DO:
  FIND Almacen WHERE Almacen.CodCia = S-CODCIA  
    AND Almacen.CodAlm = x-CodAlm:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN f-DirEnt:SCREEN-VALUE = Almacen.DirAlm.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodMon W-Win
ON VALUE-CHANGED OF x-CodMon IN FRAME F-Main
DO:
  ASSIGN {&SELF-NAME}.
  s-CodMon = x-CodMon.
  RUN Cambia-de-Moneda IN h_t-genoc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodPro W-Win
ON LEAVE OF x-CodPro IN FRAME F-Main /* Proveedor */
OR RETURN OF {&SELF-NAME}
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND gn-prov WHERE gn-prov.CodCia = pv-codcia
    AND gn-prov.CodPro = INPUT {&SELF-NAME}
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-prov THEN DO:
    MESSAGE 'Proveedor NO registrado' VIEW-AS ALERT-BOX ERROR.
    DISPLAY {&SELF-NAME} WITH FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
  END.
  x-NomPro:SCREEN-VALUE = gn-prov.NomPro.
  IF {&SELF-NAME} <> SELF:SCREEN-VALUE THEN DO:
    ASSIGN {&SELF-NAME}.
    RUN Carga-Temporal.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-ModAdq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-ModAdq W-Win
ON LEAVE OF x-ModAdq IN FRAME F-Main /* Modalidad */
DO:
  FIND almtabla WHERE almtabla.Tabla = X-TIPO 
    AND  almtabla.Codigo = x-ModAdq:SCREEN-VALUE 
    NO-LOCK NO-ERROR.
  IF AVAILABLE almtabla 
  THEN F-modalidad:SCREEN-VALUE = almtabla.nombre.
  ELSE F-modalidad:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-TpoCmb W-Win
ON LEAVE OF x-TpoCmb IN FRAME F-Main /* Tipo de Cambio */
DO:
  S-TPOCMB = DECIMAL(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/lgc/t-genoc.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-genoc ).
       RUN set-position IN h_t-genoc ( 12.92 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-genoc ( 8.62 , 109.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv95.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv95 ).
       RUN set-position IN h_p-updv95 ( 21.58 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv95 ( 1.54 , 26.14 ) NO-ERROR.

       /* Links to SmartBrowser h_t-genoc. */
       RUN add-link IN adm-broker-hdl ( h_p-updv95 , 'TableIO':U , h_t-genoc ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-genoc ,
             x-TpoCmb:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv95 ,
             h_t-genoc , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle W-Win 
PROCEDURE Carga-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR f-Factor LIKE Almtconv.Equival NO-UNDO.
  DEF VAR x-CanPedi AS DEC NO-UNDO.
  
  FOR EACH DCMP:
    DELETE DCMP.
  END.
  
  FOR EACH CREQ WHERE CREQ.Flag = '*' NO-LOCK WITH FRAME {&FRAME-NAME}:
    /* acumulamos el detalle */
    FOR EACH Lg-DRequ OF CREQ NO-LOCK, FIRST Almmmatg OF Lg-drequ NO-LOCK:
        F-FACTOR = 1.
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
            AND  Almtconv.Codalter = Almmmatg.UndCmp
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN NEXT.
        F-FACTOR = Almtconv.Equival.

        FIND DCMP WHERE DCMP.codmat = Lg-drequ.codmat EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE DCMP THEN CREATE DCMP.
        BUFFER-COPY Lg-drequ TO DCMP
            ASSIGN
                DCMP.CanPedi = DCMP.CanPedi + LG-DRequ.CanPedi.

    END.
  END.
  /* Redondeamos de acuerdo al empaque del proveedor */
  FOR EACH DCMP, FIRST Almmmatg OF DCMP WHERE Almmmatg.CanEmp > 0 NO-LOCK:
    x-CanPedi = DCMP.CanPedi.
    IF x-CanPedi < Almmmatg.CanEmp THEN x-CanPedi = Almmmatg.CanEmp.
    IF x-CanPedi MODULO Almmmatg.CanEmp <> 0 THEN DO:
        x-CanPedi = (TRUNCATE(x-CanPedi / Almmmatg.CanEmp, 0) + 1) * Almmmatg.CanEmp.
    END.
    DCMP.CanPedi = x-CanPedi.   /* OJO */
    FIND FIRST LG-dmatpr WHERE LG-dmatpr.CodCia = s-CodCia
        AND LG-dmatpr.codpro = x-CodPro:SCREEN-VALUE
        AND LG-dmatpr.codmat = DCMP.codmat
        AND LG-dmatpr.FlgEst = "A" 
        NO-LOCK NO-ERROR.
    IF AVAILABLE LG-dmatpr THEN DO:
        ASSIGN
            DCMP.Dsctos[1] = LG-dmatpr.Dsctos[1] 
            DCMP.Dsctos[2] = LG-dmatpr.Dsctos[2]
            DCMP.Dsctos[3] = LG-dmatpr.Dsctos[3]
            DCMP.IgvMat = LG-dmatpr.IgvMat.
       IF S-CODMON = 1 
       THEN DO:
          IF LG-dmatpr.CodMon = 1 
          THEN DCMP.PreUni = LG-dmatpr.PreAct.
          ELSE DCMP.PreUni = ROUND(LG-dmatpr.PreAct * S-TPOCMB,4).
       END.
       ELSE DO:
          IF LG-dmatpr.CodMon = 2 
          THEN DCMP.PreUni = LG-dmatpr.PreAct.     
          ELSE DCMP.PreUni = ROUND(LG-dmatpr.PreAct / S-TPOCMB,4).
       END.
    END.
    ASSIGN 
        DCMP.ArtPro = ""
        DCMP.UndCmp = Almmmatg.UndStk
        DCMP.ArtPro = Almmmatg.ArtPro
        DCmp.CanAten = S-Codmon
        DCMP.ImpTot = ROUND(DCMP.CanPedi * ROUND(DCMP.PreUni * 
                            (1 - (DCMP.Dsctos[1] / 100)) *
                            (1 - (DCMP.Dsctos[2] / 100)) *
                            (1 - (DCMP.Dsctos[3] / 100)) *
                            (1 + (DCMP.IgvMat / 100)) , 4),2).
  END.
  
  RUN dispatch IN h_t-genoc ('open-query':U).

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
  FOR EACH CREQ:
    DELETE CREQ.
  END.
  FOR EACH DCMP:
    DELETE DCMP.
  END.
  FOR EACH Lg-CRequ NO-LOCK WHERE Lg-CRequ.codcia = s-codcia
        AND lg-CRequ.FlgSit = 'S'
        AND lg-CRequ.CodPro = x-CodPro:
    CREATE CREQ.
    BUFFER-COPY Lg-CRequ TO CREQ.
  END.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  RUN dispatch IN h_t-genoc ('open-query':U).

  /* Información de la Orden de Compra */
  DO WITH FRAME {&FRAME-NAME}:
    x-CodMon = 1.
    s-CodMon = 1.
    DISPLAY 
        TODAY @ x-Fchdoc 
        TODAY + 1 @ x-FchEnt 
        TODAY + 7 @ x-FchVto
        x-CodMon.
    FIND LAST gn-tcmb WHERE gn-tcmb.FECHA <= TODAY NO-LOCK NO-ERROR.
    IF AVAILABLE gn-tcmb THEN DO:
        DISPLAY gn-tcmb.compra @ x-TpoCmb.
        S-TPOCMB = gn-tcmb.compra.
    END.
  END.
  
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
  DISPLAY x-CodPro x-NomPro x-ModAdq F-modalidad x-FchDoc x-CndCmp F-DesCnd 
          x-FchEnt x-Observ x-FchVto x-CodAlm F-DirEnt x-CodMon x-TpoCmb 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-27 RECT-1 x-CodPro BROWSE-1 BUTTON-1 BUTTON-2 BUTTON-4 BUTTON-5 
         x-ModAdq x-CndCmp x-FchEnt x-Observ x-FchVto x-CodAlm x-CodMon 
         BUTTON-6 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Orden W-Win 
PROCEDURE Genera-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  MESSAGE 'Generamos la Orden de Compra?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN 'ADM-ERROR'.

  /* Máximo 13 Items por Orden de Compra */
  DEF VAR x-Items AS INT NO-UNDO.
  DEF VAR x-CanPedi AS DEC NO-UNDO.
  DEF VAR x-CanAten AS DEC NO-UNDO.
  DEF VAR x-NroDoc-1 LIKE LG-COCmp.nrodoc.
  DEF VAR x-NroDoc-2 LIKE LG-COCmp.nrodoc.
  
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR':
    GENERACION:
    REPEAT WITH FRAME {&FRAME-NAME}:
        FIND FIRST DCMP WHERE DCMP.CanPedi > 0 NO-LOCK NO-ERROR.
        IF NOT AVAILABLE DCMP THEN LEAVE GENERACION.
        
        FIND LG-CORR WHERE LG-CORR.CodCia = S-CODCIA 
            AND LG-CORR.CodDiv = s-CodDiv
            AND  LG-CORR.CodDoc = "O/C" 
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE LG-CORR THEN DO:
            MESSAGE 'No se pudo bloquear el control de correlativos (lg-corr)'
                VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        CREATE LG-COCmp.
        ASSIGN 
            LG-COCmp.CodCia = S-CODCIA
            LG-COCmp.CodDiv = s-CodDiv
            LG-COCmp.TpoDoc = "N"
            LG-COCmp.NroDoc = LG-CORR.NroDoc 
            LG-COCmp.FlgSit = "G"
            LG-COCmp.Userid-com = S-USER-ID
            LG-COCmp.CodPro = x-CodPro
            LG-COCmp.ModAdq = INPUT x-ModAdq
            LG-COCmp.FchDoc = TODAY
            LG-COCmp.CndCmp = INPUT x-CndCmp
            LG-COCmp.FchEnt = INPUT x-FchEnt
            LG-COCmp.FchVto = INPUT x-FchVto
            LG-COCmp.Observaciones = INPUT x-Observ
            LG-COCmp.TpoCmb = INPUT x-TpoCmb
            LG-COCmp.CodAlm = INPUT x-CodAlm.
        ASSIGN 
            LG-CORR.NroDoc = LG-CORR.NroDoc + 1.
      
        IF x-NroDoc-1 = 0 THEN x-NroDoc-1 = LG-COCmp.NroDoc.
        x-NroDoc-2 = LG-COCmp.NroDoc.
        
        FIND gn-prov WHERE gn-prov.CodCia = pv-codcia
            AND  gn-prov.CodPro = LG-COCmp.CodPro 
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN LG-COCmp.NomPro = gn-prov.NomPro.
    
        /* Generamos el detalle de la orden de compra */
        ASSIGN 
            LG-COCmp.ImpTot = 0
            LG-COCmp.ImpExo = 0.
        x-Items = 1.
        FOR EACH DCMP WHERE DCMP.CanPedi > 0 AND x-Items <= 13:
            CREATE LG-DOCmp.
            BUFFER-COPY DCMP TO LG-DOCmp
                ASSIGN  
                    LG-DOCmp.CodCia = LG-COCmp.CodCia 
                    LG-DOCMP.CodDiv = LG-COCmp.CodDiv
                    LG-DOCmp.TpoDoc = LG-COCmp.TpoDoc 
                    LG-DOCmp.NroDoc = LG-COCmp.NroDoc.
            LG-COCmp.ImpTot = LG-COCmp.ImpTot + DCMP.ImpTot.
            IF DCMP.IgvMat = 0 THEN LG-COCmp.ImpExo = LG-COCmp.ImpExo + DCMP.ImpTot.
            x-Items = x-Items + 1.
            DELETE DCMP.    /* OJO */
        END.
        FIND LAST LG-CFGIGV NO-LOCK NO-ERROR.
        ASSIGN 
            LG-COCmp.ImpIgv = (LG-COCmp.ImpTot - LG-COCmp.ImpExo) - 
                               ROUND((LG-COCmp.ImpTot - LG-COCmp.ImpExo) / (1 + LG-CFGIGV.PorIgv / 100),2)
            LG-COCmp.ImpBrt = LG-COCmp.ImpTot - LG-COCmp.ImpExo - LG-COCmp.ImpIgv
            LG-COCmp.ImpDto = 0
            LG-COCmp.ImpNet = LG-COCmp.ImpBrt - LG-COCmp.ImpDto.
      
        /* ACTUALIZAMOS LOS REQUERIMIENTOS */
        FOR EACH LG-DOCmp OF Lg-COCmp NO-LOCK:
            x-CanPedi = LG-DOCmp.CanPedi.
            FOR EACH CREQ WHERE CREQ.Flag = '*', FIRST Lg-CRequ OF CREQ:
                FIND LG-DRequ OF Lg-CRequ WHERE LG-DRequ.Codmat = LG-DOCmp.CodMat EXCLUSIVE-LOCK NO-ERROR.
                IF AVAILABLE LG-DRequ THEN DO:
                    ASSIGN
                        x-CanAten = MINIMUM(LG-DRequ.CanPedi, x-CanPedi)
                        LG-DRequ.CanAten = LG-DRequ.CanAten + x-CanAten
                        LG-DRequ.NroO_C  = Lg-COCmp.NroDoc      /* OJO */
                        x-CanPedi = x-CanPedi - x-CanAten.
                    ASSIGN
                      LG-CRequ.FlgSit = 'C'     /* ATENDIDA */
                      LG-CRequ.NroO_C = Lg-COCmp.NroDoc
                      LG-CRequ.Userid-com = s-user-id.
                END.
            END.
        END.
    END.

    FOR EACH CREQ:
      DELETE CREQ.
    END.
    FOR EACH DCMP:
      DELETE DCMP.
    END.

  END.
  
  MESSAGE 'Se generó la(s) Orden(es) de Compra' x-NroDoc-1 'hasta la' x-NroDoc-2
        VIEW-AS ALERT-BOX INFORMATION.
  RETURN 'OK'.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
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
    input-var-1 = "".
    CASE HANDLE-CAMPO:name:
        WHEN "x-CndCmp" THEN ASSIGN input-var-1 = "" /*"20"*/.
        WHEN "x-ModAdq" THEN ASSIGN input-var-1 = X-TIPO.
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
  {src/adm/template/snd-list.i "CREQ"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida W-Win 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME} :
    IF x-CodPro:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de proveedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO x-CodPro.
      RETURN "ADM-ERROR".   
    END.
    IF x-CndCmp:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Condicion de Compra no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO x-CndCmp.
      RETURN "ADM-ERROR".         
    END.  
    FIND gn-prov WHERE gn-prov.CodCia = pv-codcia
        AND gn-prov.CodPro = x-CodPro:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-prov THEN DO:
      MESSAGE "Proveedor no Registrado" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO x-CodPro.
      RETURN "ADM-ERROR".
    END.
    FIND Almacen WHERE Almacen.CodCia = S-CODCIA
        AND Almacen.CodAlm = x-CodAlm:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN DO:
      MESSAGE "Almacen no Registrado" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO x-CodAlm.
      RETURN "ADM-ERROR".   
    END.
    FIND almtabla WHERE almtabla.Tabla = X-TIPO 
        AND almtabla.Codigo = x-ModAdq:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtabla THEN DO:
        MESSAGE "Modalidad de Compra no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO x-ModAdq.
        RETURN "ADM-ERROR".         
    END. 
  END.
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

