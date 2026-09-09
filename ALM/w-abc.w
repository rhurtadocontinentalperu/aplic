&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-FAMI LIKE Almtfami
       FIELD Flag AS CHAR.
DEFINE NEW SHARED TEMP-TABLE T-MATG LIKE Almmmatg.



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

DEF VAR x-Mensaje AS CHAR FORMAT 'x(40)'.
DEF FRAME f-Mensaje
    x-Mensaje
    WITH CENTERED NO-LABELS OVERLAY TITLE 'Proceso' VIEW-AS DIALOG-BOX.

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
&Scoped-define INTERNAL-TABLES T-FAMI

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 flag T-FAMI.codfam T-FAMI.desfam 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH T-FAMI NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH T-FAMI NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 T-FAMI
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 T-FAMI


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-18 BROWSE-3 TOGGLE-1 BUTTON-3 BUTTON-2 ~
BUTTON-4 BUTTON-7 BUTTON-5 BUTTON-6 BUTTON-8 
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-abc AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-almcfg AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-abc AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     LABEL "Marca Todo" 
     SIZE 13 BY .96.

DEFINE BUTTON BUTTON-3 
     LABEL "Desmarca Todo" 
     SIZE 13 BY .96.

DEFINE BUTTON BUTTON-4 
     LABEL "Procesar Estadistica" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-5 
     LABEL "Exportar Texto" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-6 
     LABEL "Importar Texto" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-7 
     LABEL "Procesar Categorias" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-8 
     LABEL "Exportar a Excel" 
     SIZE 15 BY 1.12.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 10.58.

DEFINE VARIABLE TOGGLE-1 AS LOGICAL INITIAL no 
     LABEL "Marcar" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      T-FAMI SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 DISPLAY
      flag FORMAT "X":U
      T-FAMI.codfam FORMAT "X(5)":U
      T-FAMI.desfam FORMAT "X(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-LABELS NO-ROW-MARKERS SIZE 39 BY 8.08
         FONT 4
         TITLE "Seleccione las Familias a Procesar".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-3 AT ROW 1.19 COL 70
     TOGGLE-1 AT ROW 9.46 COL 73
     BUTTON-3 AT ROW 9.46 COL 94
     BUTTON-2 AT ROW 10.42 COL 94
     BUTTON-4 AT ROW 21.19 COL 3
     BUTTON-7 AT ROW 21.19 COL 19
     BUTTON-5 AT ROW 21.19 COL 35
     BUTTON-6 AT ROW 21.19 COL 51
     BUTTON-8 AT ROW 21.19 COL 67
     RECT-18 AT ROW 1 COL 69
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 113.43 BY 21.77
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-FAMI T "?" ? INTEGRAL Almtfami
      ADDITIONAL-FIELDS:
          FIELD Flag AS CHAR
      END-FIELDS.
      TABLE: T-MATG T "NEW SHARED" ? INTEGRAL Almmmatg
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CLASIFICACON ABC"
         HEIGHT             = 21.77
         WIDTH              = 113.43
         MAX-HEIGHT         = 21.77
         MAX-WIDTH          = 113.43
         VIRTUAL-HEIGHT     = 21.77
         VIRTUAL-WIDTH      = 113.43
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
/* BROWSE-TAB BROWSE-3 RECT-18 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.T-FAMI"
     _FldNameList[1]   > "_<CALC>"
"flag" ? "X" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-FAMI.codfam
"T-FAMI.codfam" ? "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-FAMI.desfam
"T-FAMI.desfam" ? "X(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CLASIFICACON ABC */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CLASIFICACON ABC */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&Scoped-define SELF-NAME BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 W-Win
ON LEFT-MOUSE-DBLCLICK OF BROWSE-3 IN FRAME F-Main /* Seleccione las Familias a Procesar */
DO:
  APPLY "VALUE-CHANGED" TO TOGGLE-1.
  APPLY "VALUE-CHANGED" TO {&BROWSE-NAME}.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 W-Win
ON VALUE-CHANGED OF BROWSE-3 IN FRAME F-Main /* Seleccione las Familias a Procesar */
DO:
  IF T-FAMI.Flag <> ''
  THEN TOGGLE-1 = YES.
  ELSE TOGGLE-1 = NO.
  DISPLAY TOGGLE-1 WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Marca Todo */
DO:
  FOR EACH T-FAMI:
    T-FAMI.Flag = '*'.
  END.
  TOGGLE-1 = YES.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  DISPLAY TOGGLE-1 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Desmarca Todo */
DO:
  FOR EACH T-FAMI:
    T-FAMI.Flag = ''.
  END.
  TOGGLE-1 = NO.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  DISPLAY TOGGLE-1 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Procesar Estadistica */
DO:
  RUN Carga-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Exportar Texto */
DO:
  RUN Exporta-Texto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Importar Texto */
DO:
  RUN Importar-Texto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Procesar Categorias */
DO:
  RUN Procesar-Categorias.
  RUN dispatch IN h_b-abc ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Exportar a Excel */
DO:
  RUN Excel IN h_b-abc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-1 W-Win
ON VALUE-CHANGED OF TOGGLE-1 IN FRAME F-Main /* Marcar */
DO:
  IF T-FAMI.Flag <> '' THEN T-FAMI.Flag = ''. ELSE T-FAMI.Flag = '*'.
  DISPLAY T-FAMI.Flag WITH BROWSE {&BROWSE-NAME}.
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
             INPUT  'aplic/alm/v-abc.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-abc ).
       RUN set-position IN h_v-abc ( 1.00 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 10.58 , 67.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 0,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96 ).
       RUN set-position IN h_p-updv96 ( 11.58 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv96 ( 1.54 , 26.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/b-abc.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-abc ).
       RUN set-position IN h_b-abc ( 12.92 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-abc ( 9.04 , 108.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/q-almcfg.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-almcfg ).
       RUN set-position IN h_q-almcfg ( 1.00 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.65 , 8.29 ) */

       /* Links to SmartViewer h_v-abc. */
       RUN add-link IN adm-broker-hdl ( h_p-updv96 , 'TableIO':U , h_v-abc ).
       RUN add-link IN adm-broker-hdl ( h_q-almcfg , 'Record':U , h_v-abc ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-abc ,
             BROWSE-3:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96 ,
             BUTTON-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-abc ,
             h_p-updv96 , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-temporal W-Win 
PROCEDURE Carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Fecha-1  AS DATE NO-UNDO.
  DEF VAR x-Fecha-2  AS DATE NO-UNDO.
  DEF VAR x-NroFch-1 AS INTE NO-UNDO.
  DEF VAR x-NroFch-2 AS INTE NO-UNDO.
  DEF VAR x-Lineas   AS CHAR NO-UNDO.
  DEF VAR x-Fecha    AS DATE NO-UNDO.
  DEF VAR x-NroFch   AS INTE NO-UNDO.
  DEF VAR x-Dia      AS INTE NO-UNDO.
  DEF VAR x-TpoCmb   AS DECI NO-UNDO.
  
  FIND FIRST AlmCfg WHERE almcfg.codcia = s-codcia NO-LOCK NO-ERROR.
  IF NOT AVAILABLE AlmCfg THEN RETURN.
  
  FOR EACH T-MATG:
    DELETE T-MATG.
  END.
  
  FOR EACH T-FAMI WHERE T-FAMI.Flag = '*' BREAK BY t-fami.flag:
    IF FIRST-OF(t-fami.flag) 
    THEN x-Lineas = t-fami.codfam.
    ELSE x-Lineas = x-Lineas + ',' + t-fami.codfam.
  END.
  IF x-Lineas = '' 
  THEN DO:
    MESSAGE 'No ha seleccionado ninguna LINEA'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
  END.
  
  /* SOLO PROCESAMOS LOS PRODUCTOS QUE TENGAN VENTA */
  /* VENTAS */
  ASSIGN
    x-Fecha-1  = AlmCfg.VentFecI
    x-Fecha-2  = AlmCfg.VentFecF
    x-NroFch-1 = INTEGER(STRING(YEAR(x-Fecha-1), '9999') + STRING(MONTH(x-Fecha-1), '99'))
    x-NroFch-2 = INTEGER(STRING(YEAR(x-Fecha-2), '9999') + STRING(MONTH(x-Fecha-2), '99')).
  FOR EACH GN-DIVI WHERE gn-divi.codcia = s-codcia NO-LOCK:
    DO x-NroFch = x-NroFch-1 TO x-NroFch-2:
        RUN bin/_dateif (INTEGER(SUBSTRING(STRING(x-NroFch, '999999'), 5,2)),
                        INTEGER(SUBSTRING(STRING(x-NroFch, '999999'), 1,4)),
                        OUTPUT x-Fecha-1,
                        OUTPUT x-Fecha-2).
        ASSIGN
            x-Fecha-1 = MAXIMUM(AlmCfg.VentFecI, x-Fecha-1)
            x-Fecha-2 = MINIMUM(AlmCfg.VentFecF, x-Fecha-2).
        FOR EACH EvtArti USE-INDEX LLAVE02 WHERE evtarti.codcia = s-codcia
                AND evtarti.coddiv = gn-divi.coddiv
                AND evtarti.nrofch = x-nrofch
                NO-LOCK,
                FIRST Almmmatg OF EvtArti NO-LOCK:
            IF LOOKUP(TRIM(Almmmatg.codfam), x-Lineas) = 0 THEN NEXT.
            x-Mensaje = 'VENTAS: ' + almmmatg.codmat.
            DISPLAY x-Mensaje WITH FRAME f-Mensaje.
            FIND T-MATG OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE T-MATG
            THEN DO:
                CREATE T-MATG.
                BUFFER-COPY Almmmatg TO T-MATG
                ASSIGN 
                    T-MATG.MrgAlt = 0
                    T-MATG.UndAlt = ''.
            END.
            DO x-Dia = DAY(x-Fecha-1) TO DAY(x-Fecha-2):
                x-Fecha = DATE(MONTH(x-Fecha-2), x-Dia, YEAR(x-Fecha-2)).
                FIND Gn-tcmb WHERE Gn-tcmb.Fecha = x-Fecha NO-LOCK NO-ERROR.
                ASSIGN
                    T-MATG.MrgAlt[1] = T-MATG.MrgAlt[1] + EvtArti.VtaxDiaMe[x-Dia] +
                                        (IF AVAILABLE GN-TCMB THEN EvtArti.VtaxDiaMn[x-Dia] / GN-TCMB.Compra ELSE 0).
            END.
        END.
    END.
  END.
  /* UTILIDAD */
  ASSIGN
    x-Fecha-1  = AlmCfg.UtilFecI
    x-Fecha-2  = AlmCfg.UtilFecF
    x-NroFch-1 = INTEGER(STRING(YEAR(x-Fecha-1), '9999') + STRING(MONTH(x-Fecha-1), '99'))
    x-NroFch-2 = INTEGER(STRING(YEAR(x-Fecha-2), '9999') + STRING(MONTH(x-Fecha-2), '99')).
  FOR EACH GN-DIVI WHERE gn-divi.codcia = s-codcia NO-LOCK:
    DO x-NroFch = x-NroFch-1 TO x-NroFch-2:
        RUN bin/_dateif (INTEGER(SUBSTRING(STRING(x-NroFch, '999999'), 5,2)),
                        INTEGER(SUBSTRING(STRING(x-NroFch, '999999'), 1,4)),
                        OUTPUT x-Fecha-1,
                        OUTPUT x-Fecha-2).
        ASSIGN
            x-Fecha-1 = MAXIMUM(AlmCfg.UtilFecI, x-Fecha-1)
            x-Fecha-2 = MINIMUM(AlmCfg.UtilFecF, x-Fecha-2).
        FOR EACH EvtArti USE-INDEX LLAVE02 WHERE evtarti.codcia = s-codcia
                AND evtarti.coddiv = gn-divi.coddiv
                AND evtarti.nrofch = x-nrofch
                NO-LOCK,
                FIRST Almmmatg OF EvtArti NO-LOCK:
            IF LOOKUP(TRIM(Almmmatg.codfam), x-Lineas) = 0 THEN NEXT.
            x-Mensaje = 'UTILIDAD: ' + almmmatg.codmat.
            DISPLAY x-Mensaje WITH FRAME f-Mensaje.
            FIND T-MATG OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE T-MATG
            THEN DO:
                CREATE T-MATG.
                BUFFER-COPY Almmmatg TO T-MATG
                ASSIGN 
                    T-MATG.MrgAlt = 0
                    T-MATG.UndAlt = ''.
            END.
            DO x-Dia = DAY(x-Fecha-1) TO DAY(x-Fecha-2):
                x-Fecha = DATE(MONTH(x-Fecha-2), x-Dia, YEAR(x-Fecha-2)).
                FIND Gn-tcmb WHERE Gn-tcmb.Fecha = x-Fecha NO-LOCK NO-ERROR.
                ASSIGN
                    T-MATG.MrgAlt[2] = T-MATG.MrgAlt[2] +
                            ( EvtArti.VtaxDiaMe[x-Dia] - EvtArti.CtoxDiaMe[x-Dia] ) +
                            (IF AVAILABLE GN-TCMB THEN (EvtArti.VtaxDiaMn[x-Dia] - EvtArti.CtoxDiaMn[x-Dia]) / GN-TCMB.Compra ELSE 0).
            END.
        END.
    END.
  END.
  /* CRECIMIENTO */
  ASSIGN
    x-Fecha-1  = AlmCfg.CrecFecI[2]
    x-Fecha-2  = AlmCfg.CrecFecF[2]
    x-NroFch-1 = INTEGER(STRING(YEAR(x-Fecha-1), '9999') + STRING(MONTH(x-Fecha-1), '99'))
    x-NroFch-2 = INTEGER(STRING(YEAR(x-Fecha-2), '9999') + STRING(MONTH(x-Fecha-2), '99')).
  FOR EACH GN-DIVI WHERE gn-divi.codcia = s-codcia NO-LOCK:
    DO x-NroFch = x-NroFch-1 TO x-NroFch-2:
        RUN bin/_dateif (INTEGER(SUBSTRING(STRING(x-NroFch, '999999'), 5,2)),
                        INTEGER(SUBSTRING(STRING(x-NroFch, '999999'), 1,4)),
                        OUTPUT x-Fecha-1,
                        OUTPUT x-Fecha-2).
        ASSIGN
            x-Fecha-1 = MAXIMUM(AlmCfg.CrecFecI[2], x-Fecha-1)
            x-Fecha-2 = MINIMUM(AlmCfg.CrecFecF[2], x-Fecha-2).
        FOR EACH EvtArti USE-INDEX LLAVE02 WHERE evtarti.codcia = s-codcia
                AND evtarti.coddiv = gn-divi.coddiv
                AND evtarti.nrofch = x-nrofch
                NO-LOCK,
                FIRST Almmmatg OF EvtArti NO-LOCK:
            IF LOOKUP(TRIM(Almmmatg.codfam), x-Lineas) = 0 THEN NEXT.
            x-Mensaje = 'CRECIMIENTO: ' + almmmatg.codmat.
            DISPLAY x-Mensaje WITH FRAME f-Mensaje.
            FIND T-MATG OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE T-MATG
            THEN DO:
                CREATE T-MATG.
                BUFFER-COPY Almmmatg TO T-MATG
                ASSIGN 
                    T-MATG.MrgAlt = 0
                    T-MATG.UndAlt = ''.
            END.
            DO x-Dia = DAY(x-Fecha-1) TO DAY(x-Fecha-2):
                ASSIGN
                    T-MATG.MrgAlt[5] = T-MATG.MrgAlt[5] + EvtArti.CanxDia[x-Dia].
            END.
        END.
    END.
  END.
  ASSIGN
    x-Fecha-1  = AlmCfg.CrecFecI[1]
    x-Fecha-2  = AlmCfg.CrecFecF[1]
    x-NroFch-1 = INTEGER(STRING(YEAR(x-Fecha-1), '9999') + STRING(MONTH(x-Fecha-1), '99'))
    x-NroFch-2 = INTEGER(STRING(YEAR(x-Fecha-2), '9999') + STRING(MONTH(x-Fecha-2), '99')).
  FOR EACH GN-DIVI WHERE gn-divi.codcia = s-codcia NO-LOCK:
    DO x-NroFch = x-NroFch-1 TO x-NroFch-2:
        RUN bin/_dateif (INTEGER(SUBSTRING(STRING(x-NroFch, '999999'), 5,2)),
                        INTEGER(SUBSTRING(STRING(x-NroFch, '999999'), 1,4)),
                        OUTPUT x-Fecha-1,
                        OUTPUT x-Fecha-2).
        ASSIGN
            x-Fecha-1 = MAXIMUM(AlmCfg.CrecFecI[1], x-Fecha-1)
            x-Fecha-2 = MINIMUM(AlmCfg.CrecFecF[1], x-Fecha-2).
        FOR EACH EvtArti USE-INDEX LLAVE02 WHERE evtarti.codcia = s-codcia
                AND evtarti.coddiv = gn-divi.coddiv
                AND evtarti.nrofch = x-nrofch
                NO-LOCK,
                FIRST Almmmatg OF EvtArti NO-LOCK:
            IF LOOKUP(TRIM(Almmmatg.codfam), x-Lineas) = 0 THEN NEXT.
            x-Mensaje = 'CRECIMIENTO: ' + almmmatg.codmat.
            DISPLAY x-Mensaje WITH FRAME f-Mensaje.
            FIND T-MATG OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE T-MATG
            THEN DO:
                CREATE T-MATG.
                BUFFER-COPY Almmmatg TO T-MATG
                ASSIGN 
                    T-MATG.MrgAlt = 0
                    T-MATG.UndAlt = ''.
            END.
            DO x-Dia = DAY(x-Fecha-1) TO DAY(x-Fecha-2):
                ASSIGN
                    T-MATG.MrgAlt[6] = T-MATG.MrgAlt[6] + EvtArti.CanxDia[x-Dia].
            END.
        END.
    END.
  END.
  FOR EACH T-MATG:
    IF T-MATG.MrgAlt[6] <> 0
    THEN T-MATG.MrgAlt[3] = ( T-MATG.MrgAlt[5] / T-MATG.MrgAlt[6] - 1 ) * 100.
    ELSE T-MATG.MrgAlt[3] = 0.
  END.
  
  /* DEPURAMOS INFORMACION */
  FOR EACH T-MATG:
    IF T-MATG.MrgAlt[1] = 0 AND T-MATG.MrgAlt[2] = 0 THEN DELETE T-MATG.
  END.
  HIDE FRAME f-Mensaje.
  
  RUN Procesar-Categorias.
  
  RUN dispatch IN h_b-abc ('open-query':U).
  
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
  DISPLAY TOGGLE-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-18 BROWSE-3 TOGGLE-1 BUTTON-3 BUTTON-2 BUTTON-4 BUTTON-7 BUTTON-5 
         BUTTON-6 BUTTON-8 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Texto W-Win 
PROCEDURE Exporta-Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Archivo AS CHAR.
  DEF VAR x-Ok      AS LOGI.
  
  SYSTEM-DIALOG GET-FILE x-Archivo
  FILTERS 'Archivo texto (txt)' '*.txt'
  ASK-OVERWRITE 
  DEFAULT-EXTENSION '.txt'
  RETURN-TO-START-DIR
  SAVE-AS
  TITLE 'Guardar texto archivo como'
  UPDATE x-Ok.

  IF x-Ok = NO THEN RETURN.
  
  OUTPUT TO VALUE(x-Archivo).
  FOR EACH T-MATG:
    EXPORT T-MATG.
  END.
  OUTPUT CLOSE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Texto W-Win 
PROCEDURE Importar-Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Archivo AS CHAR.
  DEF VAR x-Ok      AS LOGI.
  
  SYSTEM-DIALOG GET-FILE x-Archivo
  FILTERS 'Archivo texto (txt)' '*.txt'
  DEFAULT-EXTENSION '.txt'
  RETURN-TO-START-DIR
  TITLE 'Importar archivo texto'
  UPDATE x-Ok.

  IF x-Ok = NO THEN RETURN.
  
  FOR EACH T-MATG:
    DELETE T-MATG.
  END.
  INPUT FROM VALUE(x-Archivo).
  REPEAT:
    CREATE T-MATG.
    IMPORT T-MATG.
  END.
  INPUT CLOSE.
  FOR EACH T-MATG:
    IF T-MATG.codmat = '' THEN DELETE T-MATG.
  END.
  RUN dispatch IN h_b-abc ('open-query':U).

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
  FOR EACH AlmTFami WHERE codcia = s-codcia NO-LOCK:
    CREATE T-FAMI.
    BUFFER-COPY AlmTFami TO T-FAMI.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesar-Categorias W-Win 
PROCEDURE Procesar-Categorias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-TotItm  AS INT INIT 0 NO-UNDO.
  DEF VAR x-Items   AS INT INIT 0 NO-UNDO.
  DEF VAR x-Items-A AS INT INIT 0 NO-UNDO.
  DEF VAR x-Items-B AS INT INIT 0 NO-UNDO.
  DEF VAR x-Items-C AS INT INIT 0 NO-UNDO.
  DEF VAR x-Items-D AS INT INIT 0 NO-UNDO.
  DEF VAR x-Items-E AS INT INIT 0 NO-UNDO.

  FIND FIRST AlmCfg WHERE almcfg.codcia = s-codcia NO-LOCK NO-ERROR.
  IF NOT AVAILABLE AlmCfg THEN RETURN.

  FOR EACH T-MATG:
    ASSIGN
        T-MATG.UndAlt = ''
        x-TotItm = x-TotItm + 1.
  END.
    
  x-Mensaje = 'Un momento por favor...'.
  DISPLAY x-Mensaje WITH FRAME f-Mensaje.

  /* PRIMERO DETERMINAMOS LAS SUB-CATEGORIAS POR CADA RUBRO */
  /* POR VENTAS */
  ASSIGN
    x-Items-A = ROUND(x-TotItm * AlmCfg.Factor-A[1] / 100, 0)
    x-Items-B = x-Items-A + ROUND(x-TotItm * AlmCfg.Factor-B[1] / 100, 0)
    x-Items-C = x-Items-B + ROUND(x-TotItm * AlmCfg.Factor-C[1] / 100, 0)
    x-Items-D = x-Items-C + ROUND(x-TotItm * AlmCfg.Factor-D[1] / 100, 0)
    x-Items-E = x-Items-D + ROUND(x-TotItm * AlmCfg.Factor-E[1] / 100, 0).
  x-Items = 0.
  FOR EACH T-MATG BY T-MATG.MrgAlt[1] DESCENDING:
    x-Items = x-Items + 1.
    IF x-Items <= x-Items-A
    THEN T-MATG.UndAlt[1] = 'A'.
    ELSE IF x-Items <= x-Items-B
        THEN T-MATG.UndAlt[1] = 'B'.
        ELSE IF x-Items <= x-Items-C
            THEN T-MATG.UndAlt[1] = 'C'.
            ELSE IF x-Items <= x-Items-D
                THEN T-MATG.UndAlt[1] = 'D'.
                ELSE IF x-Items <= x-Items-E
                    THEN T-MATG.UndAlt[1] = 'E'.
                    ELSE T-MATG.UndAlt[1] = 'F'.
  END.
  /* POR UTILIDAD */
  ASSIGN
    x-Items-A = ROUND(x-TotItm * AlmCfg.Factor-A[2] / 100, 0)
    x-Items-B = x-Items-A + ROUND(x-TotItm * AlmCfg.Factor-B[2] / 100, 0)
    x-Items-C = x-Items-B + ROUND(x-TotItm * AlmCfg.Factor-C[2] / 100, 0)
    x-Items-D = x-Items-C + ROUND(x-TotItm * AlmCfg.Factor-D[2] / 100, 0)
    x-Items-E = x-Items-D + ROUND(x-TotItm * AlmCfg.Factor-E[2] / 100, 0).
  x-Items = 0.
  FOR EACH T-MATG BY T-MATG.MrgAlt[2] DESCENDING:
    x-Items = x-Items + 1.
    IF x-Items <= x-Items-A
    THEN T-MATG.UndAlt[2] = 'A'.
    ELSE IF x-Items <= x-Items-B
        THEN T-MATG.UndAlt[2] = 'B'.
        ELSE IF x-Items <= x-Items-C
            THEN T-MATG.UndAlt[2] = 'C'.
            ELSE IF x-Items <= x-Items-D
                THEN T-MATG.UndAlt[2] = 'D'.
                ELSE IF x-Items <= x-Items-E
                    THEN T-MATG.UndAlt[2] = 'E'.
                    ELSE T-MATG.UndAlt[2] = 'F'.
  END.
  /* POR CRECIMIENTO */
  FOR EACH T-MATG BY T-MATG.MrgAlt[3] DESCENDING:
    IF T-MATG.MrgAlt[3] >= AlmCfg.Factor-A[3]
    THEN T-MATG.UndAlt[3] = 'A'.
    ELSE IF T-MATG.MrgAlt[3] >= AlmCfg.Factor-B[3]
        THEN T-MATG.UndAlt[3] = 'B'.
        ELSE IF T-MATG.MrgAlt[3] >= AlmCfg.Factor-C[3]
            THEN T-MATG.UndAlt[3] = 'C'.
            ELSE IF T-MATG.MrgAlt[3] >= AlmCfg.Factor-D[3]
                THEN T-MATG.UndAlt[3] = 'D'.
                ELSE IF T-MATG.MrgAlt[3] >= AlmCfg.Factor-E[3]
                    THEN T-MATG.UndAlt[3] = 'E'.
                    ELSE T-MATG.UndAlt[3] = 'F'.
  END.

  /* DETERMINAMOS EL PESO POR TODOS LOS RUBROS */
  DEF VAR x-Factor-1 AS DEC NO-UNDO.
  DEF VAR x-Factor-2 AS DEC NO-UNDO.
  DEF VAR x-Factor-3 AS DEC NO-UNDO.
  FOR EACH T-MATG:
    CASE T-MATG.UndAlt[1]:      /* VENTAS */
        WHEN 'A' THEN x-Factor-1 = AlmCfg.CateA.
        WHEN 'B' THEN x-Factor-1 = AlmCfg.CateB.
        WHEN 'C' THEN x-Factor-1 = AlmCfg.CateC.
        WHEN 'D' THEN x-Factor-1 = AlmCfg.CateD.
        WHEN 'E' THEN x-Factor-1 = AlmCfg.CateE.
        WHEN 'F' THEN x-Factor-1 = AlmCfg.CateF.
        OTHERWISE x-Factor-1 = 0.
    END CASE.
    CASE T-MATG.UndAlt[2]:      /* UTILIDAD */
        WHEN 'A' THEN x-Factor-2 = AlmCfg.CateA.
        WHEN 'B' THEN x-Factor-2 = AlmCfg.CateB.
        WHEN 'C' THEN x-Factor-2 = AlmCfg.CateC.
        WHEN 'D' THEN x-Factor-2 = AlmCfg.CateD.
        WHEN 'E' THEN x-Factor-2 = AlmCfg.CateE.
        WHEN 'F' THEN x-Factor-2 = AlmCfg.CateF.
        OTHERWISE x-Factor-2 = 0.
    END CASE.
    CASE T-MATG.UndAlt[3]:      /* CRECIMIENTO */
        WHEN 'A' THEN x-Factor-3 = AlmCfg.CateA.
        WHEN 'B' THEN x-Factor-3 = AlmCfg.CateB.
        WHEN 'C' THEN x-Factor-3 = AlmCfg.CateC.
        WHEN 'D' THEN x-Factor-3 = AlmCfg.CateD.
        WHEN 'E' THEN x-Factor-3 = AlmCfg.CateE.
        WHEN 'F' THEN x-Factor-3 = AlmCfg.CateF.
        OTHERWISE x-Factor-3 = 0.
    END CASE.
    T-MATG.MrgAlt[4] = ((x-Factor-1 / 100) * (AlmCfg.VentPes / 100) * 100) +
                        ((x-Factor-2 / 100) * (AlmCfg.UtilPes / 100) * 100) +
                        ((x-Factor-3 / 100) * (AlmCfg.CrecPes / 100) * 100).
  END.

  HIDE FRAME f-Mensaje.  
  
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
  {src/adm/template/snd-list.i "T-FAMI"}

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

