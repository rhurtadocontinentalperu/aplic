&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE DCMP LIKE LG-DOCmp.
DEFINE TEMP-TABLE T-ALM-01 NO-UNDO LIKE Almacen.
DEFINE TEMP-TABLE T-ALM-02 NO-UNDO LIKE Almacen.
DEFINE TEMP-TABLE T-ALM-03 NO-UNDO LIKE Almacen.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR PV-CODCIA  AS INTEGER.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-codalm AS CHAR.

DEF VAR x-AlmEstadistica AS CHAR INIT '03,04,05' NO-UNDO.
DEF VAR x-Divisiones AS CHAR INIT '00001,00002,00003,00004,00013,00014' NO-UNDO.

DEF VAR x-Mensaje AS CHAR FORMAT 'x(60)' NO-UNDO.
DEF FRAME F-Mensaje
    x-Mensaje
    WITH NO-LABELS TITLE 'Procesando Informacion' VIEW-AS DIALOG-BOX CENTERED OVERLAY.

/* CONTROL DE BOTONES */
DEF VAR L-BUTTON-1 AS LOG INIT YES.

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
&Scoped-define INTERNAL-TABLES T-ALM-01 T-ALM-02 T-ALM-03

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 T-ALM-01.CodAlm ~
T-ALM-01.Descripcion 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH T-ALM-01 NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH T-ALM-01 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 T-ALM-01
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 T-ALM-01


/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 T-ALM-02.CodAlm ~
T-ALM-02.Descripcion 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH T-ALM-02 NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH T-ALM-02 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 T-ALM-02
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 T-ALM-02


/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 T-ALM-03.CodAlm ~
T-ALM-03.Descripcion 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH T-ALM-03 NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH T-ALM-03 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 T-ALM-03
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 T-ALM-03


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-3 BROWSE-1 BROWSE-2 BUTTON-1 ~
BUTTON-2 BROWSE-3 x-Dias s-CodMon x-CodFam x-SubFam x-CodPro BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS x-Dias s-CodMon s-TpoCmb x-CodFam x-SubFam ~
x-CodPro x-NomPro 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-docrep AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL ">>" 
     SIZE 5 BY .96
     FONT 1.

DEFINE BUTTON BUTTON-2 
     LABEL "<<" 
     SIZE 5 BY .96
     FONT 1.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img\proces":U
     LABEL "Button 3" 
     SIZE 11 BY 1.54.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img\climnu1":U
     IMAGE-INSENSITIVE FILE "img\ayuda":U
     LABEL "Button 5" 
     SIZE 11 BY 1.54.

DEFINE VARIABLE x-CodFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Familia" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 31 BY 1 NO-UNDO.

DEFINE VARIABLE x-SubFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Sub-Familia" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 31 BY 1 NO-UNDO.

DEFINE VARIABLE s-TpoCmb AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 1 
     LABEL "Tipo de Cambio" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-CodPro AS CHARACTER FORMAT "x(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-Dias AS INTEGER FORMAT ">>9":U INITIAL 1 
     LABEL "Dias de Reposicion" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE s-CodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 16 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 99 BY 5.38
     BGCOLOR 15 .

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 99 BY 6.73.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      T-ALM-01 SCROLLING.

DEFINE QUERY BROWSE-2 FOR 
      T-ALM-02 SCROLLING.

DEFINE QUERY BROWSE-3 FOR 
      T-ALM-03 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 DISPLAY
      T-ALM-01.CodAlm FORMAT "x(4)":U
      T-ALM-01.Descripcion FORMAT "X(50)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-LABELS NO-ROW-MARKERS SIZE 43 BY 4.5
         FONT 4
         TITLE "Seleccione los almacenes:".

DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 DISPLAY
      T-ALM-02.CodAlm FORMAT "x(4)":U
      T-ALM-02.Descripcion FORMAT "X(50)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-LABELS NO-ROW-MARKERS SIZE 43 BY 4.5
         FONT 4
         TITLE "Estadisticas de Ventas de los Almacenes:".

DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 DISPLAY
      T-ALM-03.CodAlm FORMAT "x(4)":U
      T-ALM-03.Descripcion FORMAT "X(50)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-LABELS NO-ROW-MARKERS MULTIPLE SIZE 43 BY 5.38
         FONT 4
         TITLE "Seleccione el stock de los siguientes almacenes".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-1 AT ROW 1.58 COL 6
     BROWSE-2 AT ROW 1.58 COL 56
     BUTTON-1 AT ROW 2.73 COL 50
     BUTTON-2 AT ROW 3.88 COL 50
     BROWSE-3 AT ROW 6.77 COL 56
     x-Dias AT ROW 7.35 COL 19 COLON-ALIGNED
     s-CodMon AT ROW 8.5 COL 21 NO-LABEL
     s-TpoCmb AT ROW 9.46 COL 19 COLON-ALIGNED
     x-CodFam AT ROW 10.42 COL 19 COLON-ALIGNED
     x-SubFam AT ROW 11.38 COL 19 COLON-ALIGNED
     x-CodPro AT ROW 12.35 COL 19 COLON-ALIGNED
     x-NomPro AT ROW 12.35 COL 30 COLON-ALIGNED NO-LABEL
     BUTTON-3 AT ROW 13.5 COL 3
     BUTTON-5 AT ROW 13.5 COL 15
     "Moneda de Compra:" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 8.5 COL 7
     RECT-1 AT ROW 1.19 COL 3
     RECT-3 AT ROW 6.58 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 102.29 BY 20.92
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: DCMP T "NEW SHARED" ? INTEGRAL LG-DOCmp
      TABLE: T-ALM-01 T "?" NO-UNDO INTEGRAL Almacen
      TABLE: T-ALM-02 T "?" NO-UNDO INTEGRAL Almacen
      TABLE: T-ALM-03 T "?" NO-UNDO INTEGRAL Almacen
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "COMPRAS POR REPOSICION DE MERCADERIA"
         HEIGHT             = 20.92
         WIDTH              = 102.29
         MAX-HEIGHT         = 20.92
         MAX-WIDTH          = 102.29
         VIRTUAL-HEIGHT     = 20.92
         VIRTUAL-WIDTH      = 102.29
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
/* BROWSE-TAB BROWSE-1 RECT-3 F-Main */
/* BROWSE-TAB BROWSE-2 BROWSE-1 F-Main */
/* BROWSE-TAB BROWSE-3 BUTTON-2 F-Main */
/* SETTINGS FOR BUTTON BUTTON-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN s-TpoCmb IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.T-ALM-01"
     _FldNameList[1]   > Temp-Tables.T-ALM-01.CodAlm
"T-ALM-01.CodAlm" ? "x(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-ALM-01.Descripcion
"T-ALM-01.Descripcion" ? "X(50)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.T-ALM-02"
     _FldNameList[1]   > Temp-Tables.T-ALM-02.CodAlm
"T-ALM-02.CodAlm" ? "x(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-ALM-02.Descripcion
"T-ALM-02.Descripcion" ? "X(50)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.T-ALM-03"
     _FldNameList[1]   > Temp-Tables.T-ALM-03.CodAlm
"T-ALM-03.CodAlm" ? "x(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-ALM-03.Descripcion
"T-ALM-03.Descripcion" ? "X(50)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* COMPRAS POR REPOSICION DE MERCADERIA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* COMPRAS POR REPOSICION DE MERCADERIA */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* >> */
DO:
  IF BROWSE-1:NUM-SELECTED-ROWS = 0 THEN RETURN.
  IF BROWSE-1:FETCH-SELECTED-ROW(1)
  THEN DO:
    CREATE T-ALM-02.
    BUFFER-COPY T-ALM-01 TO T-ALM-02.
    DELETE T-ALM-01.
    {&OPEN-QUERY-BROWSE-1}
    {&OPEN-QUERY-BROWSE-2}
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* << */
DO:
  IF BROWSE-2:NUM-SELECTED-ROWS = 0 THEN RETURN.
  IF BROWSE-2:FETCH-SELECTED-ROW(1)
  THEN DO:
    CREATE T-ALM-01.
    BUFFER-COPY T-ALM-02 TO T-ALM-01.
    DELETE T-ALM-02.
    {&OPEN-QUERY-BROWSE-1}
    {&OPEN-QUERY-BROWSE-2}
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  IF L-BUTTON-1 = YES
  THEN DO:
    ASSIGN
        s-CodMon s-TpoCmb x-Dias x-CodFam x-SubFam x-CodPro x-NomPro.
    ASSIGN
        BROWSE-1:SENSITIVE = NO
        BROWSE-2:SENSITIVE = NO
        BROWSE-3:SENSITIVE = NO
        BUTTON-1:SENSITIVE = NO
        BUTTON-2:SENSITIVE = NO
        BUTTON-5:SENSITIVE = YES
        s-CodMon:SENSITIVE = NO
        x-CodFam:SENSITIVE = NO
        x-Dias:SENSITIVE = NO
        x-SubFam:SENSITIVE = NO
        L-BUTTON-1 = NO.
    RUN Carga-Temporal.
    RUN dispatch IN h_b-docrep ('open-query':U).
    BUTTON-3:LOAD-IMAGE('img/b-cancel.bmp').
    BUTTON-5:TOOLTIP = "Generar O/Compra".
  END.
  ELSE DO:
    ASSIGN
        BROWSE-1:SENSITIVE = YES
        BROWSE-2:SENSITIVE = YES
        BROWSE-3:SENSITIVE = YES
        BUTTON-1:SENSITIVE = YES
        BUTTON-2:SENSITIVE = YES
        BUTTON-5:SENSITIVE = NO
        s-CodMon:SENSITIVE = YES
        x-CodFam:SENSITIVE = YES
        x-Dias:SENSITIVE = YES
        x-SubFam:SENSITIVE = YES
        L-BUTTON-1 = YES.
    BUTTON-3:LOAD-IMAGE('img/proces.bmp').
    BUTTON-5:TOOLTIP = "".
    /* BORRAMOS TEMPORAL */
    FOR EACH DCMP:
        DELETE DCMP.
    END.
    RUN dispatch IN h_b-docrep ('open-query':U).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
  MESSAGE "Generamos las Ordenes de Compra?" VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE RPTA-1 AS LOG.
  IF RPTA-1 = NO THEN RETURN NO-APPLY.
  RUN Genera-Compras.
  APPLY "CHOOSE":U TO BUTTON-3.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodFam W-Win
ON VALUE-CHANGED OF x-CodFam IN FRAME F-Main /* Familia */
DO:
  DEF VAR x-Lista AS CHAR INIT 'Todas' NO-UNDO.
  IF x-CodFam = SELF:SCREEN-VALUE THEN RETURN.
  ASSIGN x-CodFam.
  FOR EACH AlmSFami WHERE almsfami.codcia = s-codcia
        AND almsfami.codfam = SUBSTRING(x-codfam,1,3) NO-LOCK:
    x-Lista = x-Lista + '|' + almsfami.subfam + ' ' + AlmSFami.dessub.
  END.
  x-SubFam:DELIMITER  = '|'.
  x-SubFam:LIST-ITEMS = x-Lista.
  x-SubFam:SCREEN-VALUE = 'Todas'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodPro W-Win
ON LEAVE OF x-CodPro IN FRAME F-Main /* Proveedor */
DO:
  x-NomPro:SCREEN-VALUE = ''.
  FIND GN-PROV WHERE gn-prov.codcia = PV-CODCIA
    AND gn-prov.codpro = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE GN-PROV
  THEN x-NomPro:SCREEN-VALUE = gn-prov.NomPro.
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
             INPUT  'aplic/lgc/b-docrep.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-docrep ).
       RUN set-position IN h_b-docrep ( 15.23 , 1.00 ) NO-ERROR.
       RUN set-size IN h_b-docrep ( 6.69 , 102.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-docrep ,
             BUTTON-5:HANDLE IN FRAME F-Main , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-StkMin AS DEC NO-UNDO.
  DEF VAR x-StkAct AS DEC NO-UNDO.
  DEF VAR i AS INT NO-UNDO.
  DEF VAR f-Factor AS DEC NO-UNDO.
  
  FOR EACH DCMP:
    DELETE DCMP.
  END.
  
  /* BARREMOS LOS MATERIALES */
  FOR EACH Almmmatg WHERE almmmatg.codcia = s-codcia
        AND almmmatg.tpoart <> 'D' 
        AND ( x-CodFam = 'Todas' OR almmmatg.codfam = SUBSTRING(x-codfam,1,3) )
        AND ( x-SubFam = 'Todas' OR almmmatg.subfam = SUBSTRING(x-subfam,1,3) )
        AND Almmmatg.codpr1 BEGINS x-CodPro
        NO-LOCK:
    ASSIGN
        x-StkMin = 0
        x-StkAct = 0.
    x-Mensaje = "MATERIAL: " + almmmatg.codmat.
    IF almmmatg.codpr1 = '' THEN NEXT.
    DISPLAY x-Mensaje WITH FRAME F-MENSAJE.
    /* CALCULAMOS LAS VENTAS DIARIAS EN BASE AL STOCK MINIMO */
    FOR EACH T-ALM-02:
        FIND Almmmate WHERE almmmate.codcia = s-codcia
                AND almmmate.codalm = T-ALM-02.codalm
                AND almmmate.codmat = almmmatg.codmat
                NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN x-StkMin = x-StkMin + almmmate.stkmin.
    END.
    /* CALCULAMOS EL STOCK ACTUAL DE LOS ALMACENES SELECCIONADOS */
    DO i = 1 TO BROWSE-3:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF BROWSE-3:FETCH-SELECTED-ROW(i) IN FRAME {&FRAME-NAME}
        THEN DO:
            FIND Almmmate WHERE almmmate.codcia = s-codcia
                AND almmmate.codalm = T-ALM-03.codalm
                AND almmmate.codmat = almmmatg.codmat
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmate THEN x-StkAct = x-StkAct + almmmate.stkact.
        END.
    END.
    /* ¿COMPRAR? */
    IF (x-StkMin * x-Dias) <= x-StkAct THEN NEXT.       /* NO */
    
    /* MOVIMIENTO DE COMPRA */
    F-FACTOR = 1.
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
        AND  Almtconv.Codalter = Almmmatg.UndCmp
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN NEXT.
    F-FACTOR = Almtconv.Equival.
    /***** Se Usara con lista de Precios Proveedor Original *****/
    FIND FIRST LG-dmatpr WHERE LG-dmatpr.CodCia = Almmmatg.codcia
        AND  LG-dmatpr.codpro = Almmmatg.codpr1
        AND  LG-dmatpr.codmat = Almmmatg.codmat  
        AND  LG-dmatpr.FlgEst = "A" 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE LG-dmatpr THEN NEXT.
    CREATE DCMP. 
    ASSIGN
        DCMP.CodCia    = s-CodCia
        DCMP.CodMat    = Almmmatg.codmat
        DCMP.CanPedi   = (x-StkMin * x-Dias) - x-StkAct
        DCMP.Dsctos[1] = LG-dmatpr.Dsctos[1]
        DCMP.Dsctos[2] = LG-dmatpr.Dsctos[2]
        DCMP.Dsctos[3] = LG-dmatpr.Dsctos[3]
        DCMP.IgvMat    = LG-dmatpr.IgvMat
        DCMP.UndCmp    = Almmmatg.UndStk
        DCMP.ArtPro    = Almmmatg.ArtPro
        DCmp.CanAten   = S-Codmon.
    IF S-CODMON = 1 THEN DO:
        IF LG-dmatpr.CodMon = 1 
        THEN DCMP.PreUni = LG-dmatpr.PreAct.
        ELSE DCMP.PreUni = ROUND(LG-dmatpr.PreAct * S-TPOCMB,4).
    END.
    ELSE DO:
        IF LG-dmatpr.CodMon = 2 
        THEN DCMP.PreUni = LG-dmatpr.PreAct.
        ELSE DCMP.PreUni = ROUND(LG-dmatpr.PreAct / S-TPOCMB,4).
    END.
    ASSIGN
        DCMP.ImpTot    = ROUND(DCMP.CanPedi * ROUND(DCMP.PreUni * 
                                (1 - (DCMP.Dsctos[1] / 100)) *
                                (1 - (DCMP.Dsctos[2] / 100)) *
                                (1 - (DCMP.Dsctos[3] / 100)) *
                                (1 + (DCMP.IgvMat / 100)) , 4),2).
  END.
  HIDE FRAME F-MENSAJE.
  
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
  DISPLAY x-Dias s-CodMon s-TpoCmb x-CodFam x-SubFam x-CodPro x-NomPro 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-3 BROWSE-1 BROWSE-2 BUTTON-1 BUTTON-2 BROWSE-3 x-Dias 
         s-CodMon x-CodFam x-SubFam x-CodPro BUTTON-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Compras W-Win 
PROCEDURE Genera-Compras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*  MESSAGE 'EN CONSTRUCCION' VIEW-AS ALERT-BOX WARNING.
 *   RETURN.*/
  
  /* ORDENAMOS POR PROVEEDOR */
  FOR EACH DCMP,
        FIRST Almmmatg WHERE almmmatg.codcia = s-codcia
            AND almmmatg.codmat = DCMP.codmat NO-LOCK
        BREAK BY Almmmatg.CodPr1 ON ERROR UNDO, RETURN:
    IF FIRST-OF(Almmmatg.codpr1)
    THEN DO:
        /* CREAMOS ORDEN DE COMPRA */
        FIND LG-CORR WHERE LG-CORR.CodCia = S-CODCIA 
            AND LG-CORR.CodDoc = "O/C" 
            EXCLUSIVE-LOCK NO-ERROR.
        CREATE LG-COCmp.
        ASSIGN 
            LG-COCmp.CodCia = S-CODCIA
            LG-COCmp.TpoDoc = "N"
            LG-COCmp.NroDoc = LG-CORR.NroDoc
            LG-COCmp.COdPro = Almmmatg.CodPr1
            LG-COCmp.FlgSit = "R"               /* OJO En Revision */
            /*LG-COCmp.NroReq = I-NROREQ*/
            LG-COCmp.Userid-com = S-USER-ID
            LG-COCmp.FchDoc = TODAY
            LG-COCmp.TpoCmb = s-TpoCmb
            LG-COCmp.CodMon = s-CodMon
            LG-COCmp.CodAlm = s-CodAlm.
        ASSIGN
            LG-CORR.NroDoc  = LG-CORR.NroDoc + 1.
        RELEASE LG-CORR.
        FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA 
            AND  gn-prov.CodPro = LG-COCmp.CodPro 
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN LG-COCmp.NomPro = gn-prov.NomPro.
        ASSIGN 
            LG-COCmp.ImpTot = 0
            LG-COCmp.ImpExo = 0.
        FIND FIRST LG-cmatpr WHERE LG-cmatpr.CodCia = s-codcia
            AND LG-cmatpr.codpro = LG-COCmp.CodPro
            AND  LG-dmatpr.FlgEst = "A" 
            NO-LOCK NO-ERROR.
        ASSIGN
            LG-COCmp.CndCmp = LG-cmatpr.CndCmp.    
    END.
    /* DETALLE */
    CREATE LG-DOCmp.
    BUFFER-COPY DCMP TO LG-DOCmp
        ASSIGN
            LG-DOCmp.codcia = LG-COCmp.codcia
            LG-DOCmp.tpodoc = LG-COCmp.tpodoc
            LG-DOCmp.nrodoc = LG-COCmp.nrodoc.
    /* TOTALES */            
    ASSIGN
        LG-COCmp.ImpTot = LG-COCmp.ImpTot + DCMP.ImpTot
        LG-COCmp.ImpExo = LG-COCmp.ImpExo + ( IF DCMP.IgvMat = 0 THEN DCMP.ImpTot ELSE 0).
    IF LAST-OF(Almmmatg.CodPr1)
    THEN DO:
        FIND LAST LG-CFGIGV NO-LOCK NO-ERROR.
        ASSIGN 
            LG-COCmp.ImpIgv = (LG-COCmp.ImpTot - LG-COCmp.ImpExo) - 
                                 ROUND((LG-COCmp.ImpTot - LG-COCmp.ImpExo) / (1 + LG-CFGIGV.PorIgv / 100),2)
            LG-COCmp.ImpBrt = LG-COCmp.ImpTot - LG-COCmp.ImpExo - LG-COCmp.ImpIgv
            LG-COCmp.ImpDto = 0
            LG-COCmp.ImpNet = LG-COCmp.ImpBrt - LG-COCmp.ImpDto.
        RELEASE LG-COCmp.
    END.            
  END.
              
  
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
  FOR EACH Almacen WHERE Almacen.codcia = s-codcia 
        AND LOOKUP(TRIM(Almacen.codalm), x-AlmEstadistica) = 0
        /*AND (s-CodDiv = '00000' OR LOOKUP(TRIM(Almacen.coddiv), x-Divisiones) > 0)*/
        NO-LOCK:
    CREATE T-ALM-01.
    BUFFER-COPY Almacen TO T-ALM-01.
  END.
  FOR EACH Almacen WHERE Almacen.codcia = s-codcia 
        AND LOOKUP(TRIM(Almacen.codalm), x-AlmEstadistica) > 0
        NO-LOCK:
    CREATE T-ALM-02.
    BUFFER-COPY Almacen TO T-ALM-02.
  END.
  FOR EACH Almacen WHERE Almacen.codcia = s-codcia 
        /*AND (s-CodDiv = '00000' OR LOOKUP(TRIM(Almacen.coddiv), x-Divisiones) > 0)*/
        AND INDEX(Almacen.codalm, 'A') = 0 
        AND INDEX(Almacen.codalm, 'B') = 0 
        AND INDEX(Almacen.codalm, 'C') = 0 
        NO-LOCK:
    CREATE T-ALM-03.
    BUFFER-COPY Almacen TO T-ALM-03.
  END.
  
  FOR EACH Almtfami WHERE almtfami.codcia = s-codcia NO-LOCK:
    x-codfam:ADD-LAST(almtfami.codfam + ' ' + Almtfami.desfam) IN FRAME {&FRAME-NAME}.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  s-TpoCmb = 1.
  FIND LAST GN-TCMB WHERE GN-TCMB.Fecha <= TODAY NO-LOCK NO-ERROR.
  IF AVAILABLE GN-TCMB
  THEN DO:
    s-TpoCmb = GN-TCMB.Compra.
    DISPLAY s-TpoCmb WITH FRAME {&FRAME-NAME}.
  END.

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

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
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
  {src/adm/template/snd-list.i "T-ALM-02"}
  {src/adm/template/snd-list.i "T-ALM-01"}
  {src/adm/template/snd-list.i "T-ALM-03"}

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

