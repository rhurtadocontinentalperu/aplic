&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tGrupoAccesos NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE tUsuarioGrupos NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE tUsuarios NO-UNDO LIKE w-report.



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

DEFINE VAR x-filtro-menu AS CHAR INIT "<Todos>".

DEFINE BUFFER x-tGrupoAccesos FOR tGrupoAccesos.

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
&Scoped-define INTERNAL-TABLES tGrupoAccesos tUsuarios tUsuarioGrupos

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tGrupoAccesos.Campo-C[1] ~
tGrupoAccesos.Campo-C[2] tGrupoAccesos.Campo-C[3] tGrupoAccesos.Campo-C[4] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tGrupoAccesos ~
      WHERE x-filtro-menu = "<Todos>" or  ~
tGrupoAccesos.campo-c[1] = x-filtro-menu NO-LOCK ~
    BY tGrupoAccesos.Campo-C[1] ~
       BY tGrupoAccesos.Campo-C[2] ~
        BY tGrupoAccesos.Campo-C[3] INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tGrupoAccesos ~
      WHERE x-filtro-menu = "<Todos>" or  ~
tGrupoAccesos.campo-c[1] = x-filtro-menu NO-LOCK ~
    BY tGrupoAccesos.Campo-C[1] ~
       BY tGrupoAccesos.Campo-C[2] ~
        BY tGrupoAccesos.Campo-C[3] INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tGrupoAccesos
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tGrupoAccesos


/* Definitions for BROWSE BROWSE-6                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-6 tUsuarios.Campo-C[1] ~
tUsuarios.Campo-C[2] tUsuarios.Campo-C[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-6 
&Scoped-define QUERY-STRING-BROWSE-6 FOR EACH tUsuarios WHERE ~{&KEY-PHRASE} NO-LOCK ~
    BY tUsuarios.Campo-C[1] INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-6 OPEN QUERY BROWSE-6 FOR EACH tUsuarios WHERE ~{&KEY-PHRASE} NO-LOCK ~
    BY tUsuarios.Campo-C[1] INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-6 tUsuarios
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-6 tUsuarios


/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 tUsuarioGrupos.Campo-C[1] ~
tUsuarioGrupos.Campo-C[2] tUsuarioGrupos.Campo-C[3] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7 
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH tUsuarioGrupos NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY BROWSE-7 FOR EACH tUsuarioGrupos NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 tUsuarioGrupos
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 tUsuarioGrupos


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-6}~
    ~{&OPEN-QUERY-BROWSE-7}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-6 TOGGLE-usuarios-activos BROWSE-7 ~
COMBO-BOX-modulo BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-usuarios-activos COMBO-BOX-modulo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX-modulo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Modulos" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE TOGGLE-usuarios-activos AS LOGICAL INITIAL yes 
     LABEL "Mostrar solo usuarios activos" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.72 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tGrupoAccesos SCROLLING.

DEFINE QUERY BROWSE-6 FOR 
      tUsuarios SCROLLING.

DEFINE QUERY BROWSE-7 FOR 
      tUsuarioGrupos SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 wWin _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tGrupoAccesos.Campo-C[1] COLUMN-LABEL "Modulo" FORMAT "X(8)":U
            WIDTH 6.43
      tGrupoAccesos.Campo-C[2] COLUMN-LABEL "Descripcion Modulo" FORMAT "X(50)":U
            WIDTH 24.57
      tGrupoAccesos.Campo-C[3] COLUMN-LABEL "Cod.Menu" FORMAT "X(8)":U
      tGrupoAccesos.Campo-C[4] COLUMN-LABEL "Opcion del Menu" FORMAT "X(80)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 122 BY 12.38
         FONT 4
         TITLE "GRUPO DE ACCESOS DEL MODULO" ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-6 wWin _STRUCTURED
  QUERY BROWSE-6 NO-LOCK DISPLAY
      tUsuarios.Campo-C[1] COLUMN-LABEL "Usuario" FORMAT "X(15)":U
            WIDTH 10.43
      tUsuarios.Campo-C[2] COLUMN-LABEL "Nombre y Apellidos" FORMAT "X(120)":U
            WIDTH 34.43
      tUsuarios.Campo-C[3] COLUMN-LABEL "Estado" FORMAT "X(10)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 59 BY 11.27
         FONT 4
         TITLE "Usuarios" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 wWin _STRUCTURED
  QUERY BROWSE-7 NO-LOCK DISPLAY
      tUsuarioGrupos.Campo-C[1] COLUMN-LABEL "Grupo" FORMAT "X(80)":U
            WIDTH 25.43
      tUsuarioGrupos.Campo-C[2] COLUMN-LABEL "Modulo" FORMAT "X(6)":U
      tUsuarioGrupos.Campo-C[3] COLUMN-LABEL "Nombre del Modulo" FORMAT "X(80)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 61 BY 9.62
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BROWSE-6 AT ROW 2.04 COL 2 WIDGET-ID 400
     TOGGLE-usuarios-activos AT ROW 1.19 COL 10.29 WIDGET-ID 2
     BROWSE-7 AT ROW 2.12 COL 62.14 WIDGET-ID 500
     COMBO-BOX-modulo AT ROW 11.96 COL 74 COLON-ALIGNED WIDGET-ID 4
     BROWSE-2 AT ROW 13.42 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 125.72 BY 25.12 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: APPSERVER
   Temp-Tables and Buffers:
      TABLE: tGrupoAccesos T "?" NO-UNDO INTEGRAL w-report
      TABLE: tUsuarioGrupos T "?" NO-UNDO INTEGRAL w-report
      TABLE: tUsuarios T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Perfil de Usuario"
         HEIGHT             = 25.12
         WIDTH              = 125.57
         MAX-HEIGHT         = 29.58
         MAX-WIDTH          = 194.43
         VIRTUAL-HEIGHT     = 29.58
         VIRTUAL-WIDTH      = 194.43
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-6 1 fMain */
/* BROWSE-TAB BROWSE-7 TOGGLE-usuarios-activos fMain */
/* BROWSE-TAB BROWSE-2 COMBO-BOX-modulo fMain */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tGrupoAccesos"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tGrupoAccesos.Campo-C[1]|yes,Temp-Tables.tGrupoAccesos.Campo-C[2]|yes,Temp-Tables.tGrupoAccesos.Campo-C[3]|yes"
     _Where[1]         = "x-filtro-menu = ""<Todos>"" or 
tGrupoAccesos.campo-c[1] = x-filtro-menu"
     _FldNameList[1]   > Temp-Tables.tGrupoAccesos.Campo-C[1]
"tGrupoAccesos.Campo-C[1]" "Modulo" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tGrupoAccesos.Campo-C[2]
"tGrupoAccesos.Campo-C[2]" "Descripcion Modulo" "X(50)" "character" ? ? ? ? ? ? no ? no no "24.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tGrupoAccesos.Campo-C[3]
"tGrupoAccesos.Campo-C[3]" "Cod.Menu" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tGrupoAccesos.Campo-C[4]
"tGrupoAccesos.Campo-C[4]" "Opcion del Menu" "X(80)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-6
/* Query rebuild information for BROWSE BROWSE-6
     _TblList          = "Temp-Tables.tUsuarios"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE"
     _OrdList          = "Temp-Tables.tUsuarios.Campo-C[1]|yes"
     _FldNameList[1]   > Temp-Tables.tUsuarios.Campo-C[1]
"tUsuarios.Campo-C[1]" "Usuario" "X(15)" "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tUsuarios.Campo-C[2]
"tUsuarios.Campo-C[2]" "Nombre y Apellidos" "X(120)" "character" ? ? ? ? ? ? no ? no no "34.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tUsuarios.Campo-C[3]
"tUsuarios.Campo-C[3]" "Estado" "X(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-6 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _TblList          = "Temp-Tables.tUsuarioGrupos"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tUsuarioGrupos.Campo-C[1]
"tUsuarioGrupos.Campo-C[1]" "Grupo" "X(80)" "character" ? ? ? ? ? ? no ? no no "25.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tUsuarioGrupos.Campo-C[2]
"tUsuarioGrupos.Campo-C[2]" "Modulo" "X(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tUsuarioGrupos.Campo-C[3]
"tUsuarioGrupos.Campo-C[3]" "Nombre del Modulo" "X(80)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Perfil de Usuario */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Perfil de Usuario */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-6
&Scoped-define SELF-NAME BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-6 wWin
ON ENTRY OF BROWSE-6 IN FRAME fMain /* Usuarios */
DO:
    SESSION:SET-WAIT-STATE("GENERAL").
    RUN carga-grupos.
    SESSION:SET-WAIT-STATE("").
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-6 wWin
ON VALUE-CHANGED OF BROWSE-6 IN FRAME fMain /* Usuarios */
DO:
  SESSION:SET-WAIT-STATE("").
  SESSION:SET-WAIT-STATE("GENERAL").
  RUN carga-grupos.
  SESSION:SET-WAIT-STATE("").
  /*MESSAGE "OK".*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-modulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-modulo wWin
ON VALUE-CHANGED OF COMBO-BOX-modulo IN FRAME fMain /* Modulos */
DO:
  ASSIGN combo-box-modulo.

  x-filtro-menu = combo-box-modulo.

  {&open-query-browse-2}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-usuarios-activos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-usuarios-activos wWin
ON VALUE-CHANGED OF TOGGLE-usuarios-activos IN FRAME fMain /* Mostrar solo usuarios activos */
DO:
  RUN carga-usuarios.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

    DEF VAR celda_br AS WIDGET-HANDLE EXTENT 150 NO-UNDO.
     DEF VAR cual_celda AS WIDGET-HANDLE NO-UNDO.
     DEF VAR n_cols_browse AS INT NO-UNDO.
     DEF VAR col_act AS INT NO-UNDO.
     DEF VAR t_col_br AS INT NO-UNDO INITIAL 7.             /* Color del background de la celda ( 2 : Verde, 4:Rojo)*/
     DEF VAR vg_col_eti_b AS INT NO-UNDO INITIAL 0. /* Color del la letra de la celda (15 : Blanco) */      

    ON ROW-DISPLAY OF browse-2 DO:
       IF tGrupoAccesos.campo-c[5] = 'PROCESO' THEN return.

        DO col_act = 1 TO n_cols_browse.

             cual_celda = celda_br[col_act].
             cual_celda:BGCOLOR = t_col_br.
             /**/
             cual_celda:BGCOLOR = 8.
             cual_celda:FGCOLOR = 0.

        END.
    END.

    DO n_cols_browse = 1 TO browse-2:NUM-COLUMNS.
       celda_br[n_cols_browse] = browse-2:GET-BROWSE-COLUMN(n_cols_browse).
       cual_celda = celda_br[n_cols_browse].

       IF vg_col_eti_b <> 0 THEN cual_celda:LABEL-BGCOLOR = vg_col_eti_b.
       /*IF n_cols_browse = 15 THEN LEAVE.*/
    END.

    n_cols_browse = browse-2:NUM-COLUMNS.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-grupos wWin 
PROCEDURE carga-grupos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tUsuarioGrupos.
EMPTY TEMP-TABLE tGrupoAccesos.

/*RUN emptyTree IN h_pure4gltv.*/
                                  
IF AVAILABLE tUsuarios THEN DO:

    DEFINE VAR x-grupos AS CHAR.
    DEFINE VAR x-sec AS INT.

    FOR EACH pf-g004 WHERE pf-g004.USER-ID = tUsuarios.campo-c[1] NO-LOCK :
        x-grupos = TRIM(pf-g004.seguridad).
        REPEAT x-sec = 1 TO NUM-ENTRIES(x-grupos,","):
            CREATE tUsuarioGrupos.
                ASSIGN tUsuarioGrupos.campo-c[1] = ENTRY(x-sec,x-grupos,",")
                        tUsuarioGrupos.campo-c[2] = pf-g004.aplic-id
                        .
            FIND FIRST pf-g003 WHERE pf-g003.aplic-id = pf-g004.aplic-id NO-LOCK NO-ERROR.
            IF AVAILABLE pf-g003 THEN DO:
                ASSIGN tUsuarioGrupos.campo-c[3] = pf-g003.detalle.
            END.
        END.

    END.

    DO WITH FRAME {&FRAME-NAME}:
        IF NOT (TRUE <> (COMBO-BOX-modulo:LIST-ITEM-PAIRS > "")) THEN 
            COMBO-BOX-modulo:DELETE(COMBO-BOX-modulo:LIST-ITEM-PAIRS) NO-ERROR.

        COMBO-BOX-modulo:ADD-LAST("<Todos>", "<Todos>").
        ASSIGN COMBO-BOX-modulo:SCREEN-VALUE = "<Todos>".
        x-filtro-menu = "<Todos>".

        FOR EACH pf-g004 WHERE pf-g004.USER-ID = tUsuarios.campo-c[1] NO-LOCK :

            FIND FIRST pf-g003 WHERE pf-g003.aplic-id = pf-g004.aplic-id NO-LOCK NO-ERROR.
            x-grupos = "<Inexistente>".     /* var prestadita */
            IF AVAILABLE pf-g003 THEN x-grupos = pf-g003.detalle.

            COMBO-BOX-modulo:ADD-LAST(x-grupos, pf-g004.aplic-id).
            IF TRUE <> (COMBO-BOX-modulo:SCREEN-VALUE > "") THEN DO:                    
                    ASSIGN COMBO-BOX-modulo:SCREEN-VALUE = x-grupos.
            END.
        END.
    END.

    DEFINE VARIABLE OpcMnu      AS CHAR EXTENT 300 NO-UNDO.
    DEFINE VARIABLE NumOpc      AS INTEGER INITIAL 1        NO-UNDO.
    DEFINE VARIABLE LenOpc      AS INTEGER                  NO-UNDO.

    DEFINE VARIABLE H-parent    AS CHAR EXTENT 4.
    DEFINE VARIABLE H-label     AS CHARACTER     EXTENT 4.
    DEFINE VARIABLE Nivel-Act   AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE Nivel-Ant   AS INTEGER                  NO-UNDO.

    DEFINE VAR s-seguridad AS CHAR.
    DEFINE VAR s-aplic-id AS CHAR.
    DEFINE VAR s-user-id AS CHAR.
    DEFINE VAR OK AS LOG.
    DEFINE VAR s-codmenu AS CHAR.
    DEFINE VAR s-label AS CHAR.
    DEFINE VAR s-programa AS CHAR.
    DEFINE VAR i AS INT.

    FOR EACH pf-g004 WHERE pf-g004.USER-ID = tUsuarios.campo-c[1] NO-LOCK :
        s-seguridad = TRIM(pf-g004.seguridad).
        s-aplic-id = pf-g004.aplic-id.
        S-USER-ID = tUsuarios.campo-c[1].

        /* Limpiamos variables */
        DO i = 1 TO 300:
            OpcMnu[i] = "".
        END.
        DO i = 1 TO 4:
            H-parent[i] = "".
            H-label[i] = "".
        END.
        ASSIGN
            H-parent[1] = "MAIN"
            H-Label[1]  = ""
            NumOpc = 1.

        FIND FIRST pf-g003 WHERE pf-g003.aplic-id = pf-g004.aplic-id NO-LOCK NO-ERROR.

        FOR EACH PF-G002 NO-LOCK WHERE PF-G002.aplic-id = s-aplic-id BY PF-G002.CodMnu:
            LenOpc     = LENGTH( PF-G002.CodMnu ).
            Nivel-Ant  = ( LenOpc / 2 ) - 1.
            Nivel-Act  = Nivel-Ant + 1.

            s-programa = "".
            s-codmenu = "".
            s-label = "".

            OK = SUBSTR( PF-G002.CodMnu, 1, Nivel-Ant * 2 ) = H-label[ Nivel-Act ]
                    AND H-parent[ Nivel-Act ] <> ?.
            /* VERIFICAMOS SU NIVEL DE SEGURIDAD */
            IF PF-G002.Seguridad-Grupos <> "" THEN
            Seguridad:
            DO:
                DO i = 1 TO NUM-ENTRIES( s-seguridad ):
                    IF CAN-DO( PF-G002.Seguridad-Grupos, ENTRY( i, s-seguridad ))
                    THEN LEAVE Seguridad.
                END.
                OK = NO.
            END.

            IF S-USER-ID = "ADMIN" THEN OK = YES.

            IF NOT OK THEN NEXT.

            s-label = "NO CREAR NADA".
            
            CASE PF-G002.Tipo:
                WHEN "SUB-MENU" THEN DO:
                    s-codmenu = PF-G002.CodMnu.
                    s-label = PF-G002.Etiqueta.
                END.
                    /*
                    CREATE SUB-MENU OpcMnu[ NumOpc ]
                        ASSIGN PARENT = H-parent[ Nivel-Act ]
                               LABEL  = PF-G002.Etiqueta*/

                WHEN "PROCESO" THEN DO: 
                    s-codmenu = PF-G002.CodMnu.
                    s-label = PF-G002.Etiqueta.
                    s-programa = PF-G002.Programa.
                    /*
                    CREATE MENU-ITEM OpcMnu[ NumOpc ]
                         ASSIGN PARENT       = H-parent[ Nivel-Act ]
                                LABEL        = PF-G002.Etiqueta
                                PRIVATE-DATA = PF-G002.Programa + "&" + PF-G002.aplic-id + "&" + PF-G002.codmnu
                                ACCELERATOR  = PF-G002.TECLA-ACELERADORA 
                                NAME         = STRING(PF-G002.PERSISTENTE)
                                TRIGGERS:
                                    ON CHOOSE
                                    DO: 
                                        RUN PROCESA( SELF:PRIVATE-DATA, SELF:NAME ).
                                    END.
                                END TRIGGERS*/ 

                END.

                WHEN "LINEA" THEN 
                    IF Nivel-act > 1 THEN DO:
                        s-codmenu = PF-G002.CodMnu.
                        s-label = FILL("-",120).
                    END.
                    /*
                    THEN CREATE MENU-ITEM OpcMnu[ NumOpc ]
                             ASSIGN PARENT  = H-parent[ Nivel-Act ]
                                    SUBTYPE = "RULE"*/
                WHEN "SEPARADOR" THEN
                    IF Nivel-act > 1 THEN DO:
                        s-codmenu = PF-G002.CodMnu.
                        s-label = "                   ".
                    END.
                    /*
                    CREATE MENU-ITEM OpcMnu[ NumOpc ]
                             ASSIGN PARENT  = H-parent[ Nivel-Act ]
                                    SUBTYPE = "SKIP"*/
                WHEN "CAJA-MARCADOR" THEN
                    IF Nivel-act > 1 THEN DO:
                        s-codmenu = PF-G002.CodMnu.
                        s-label = FILL("*",120).
                    END.

                    /*
                     CREATE MENU-ITEM OpcMnu[ NumOpc ]
                             ASSIGN PARENT     = H-parent[ Nivel-Act ]
                                    LABEL      = PF-G002.Etiqueta
                                    TOGGLE-BOX = YES*/
                END CASE.

            IF s-label <> "NO CREAR NADA" THEN DO:
                CREATE tGrupoAccesos.
                    ASSIGN tGrupoAccesos.campo-c[1] = s-aplic-id
                            tGrupoAccesos.campo-c[2] = ""
                            tGrupoAccesos.campo-c[3] = s-codmenu
                            tGrupoAccesos.campo-c[4] = s-label
                            tGrupoAccesos.campo-c[5] = PF-G002.Tipo
                            tGrupoAccesos.campo-c[10] = s-aplic-id + s-codmenu.     /* Para el TV */

                IF AVAILABLE pf-g003 THEN tGrupoAccesos.campo-c[2] = pf-g003.detalle.
            END.

             ASSIGN H-parent[ Nivel-Act + 1 ] = OpcMnu[ NumOpc ]
                    H-label[ Nivel-Act + 1  ] = PF-G002.CodMnu
                    NumOpc = NumOpc + 1.
        END.

    END.
END.


{&open-query-browse-7}
{&open-query-browse-2}

   
RUN cargar-treeview(INPUT "").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-usuarios wWin 
PROCEDURE carga-usuarios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE tUsuarios.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN toggle-usuarios-activos.
END.


FOR EACH _user NO-LOCK:
    
    IF toggle-usuarios-activos = NO OR (_user._disabled = NO OR _user._disabled = ?) THEN DO:

        
        CREATE tUsuarios.
            ASSIGN  tUsuarios.campo-c[1] = _user._USERID
            tUsuarios.campo-c[2] = _user._user-name
             tUsuarios.campo-c[3] = "ACTIVO".
            IF _user._disabled = YES THEN DO:
                ASSIGN tUsuarios.campo-c[3] = "INACTIVO".
            END.

    END.
END.

RUN carga-grupos.

{&open-query-browse-6}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-treeview wWin 
PROCEDURE cargar-treeview :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pParent AS CHAR NO-UNDO.

IF pParent = "" THEN DO:
    /*
    FOR EACH tGrupoAccesos WHERE BREAK BY tGrupoAccesos.campo-c[1]:
        IF FIRST-OF(tGrupoAccesos.campo-c[1]) THEN DO:
            RUN addNode IN h_pure4gltv (tGrupoAccesos.campo-c[1]    /*"MODULO=" + */
                                       ,""
                                       ,tGrupoAccesos.campo-c[2]
                                       ,"tvpics/menumenubar.bmp"
                                       ,"addOnExpand").
        END.
    END.
    */
END.


/*DYNAMIC-FUNCTION('tvRefresh':U IN h_pure4gltv).*/

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
  DISPLAY TOGGLE-usuarios-activos COMBO-BOX-modulo 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE BROWSE-6 TOGGLE-usuarios-activos BROWSE-7 COMBO-BOX-modulo BROWSE-2 
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

  RUN carga-usuarios.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tvNodeAddOnExpand wWin 
PROCEDURE tvNodeAddOnExpand :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pcnodeKey AS CHARACTER  NO-UNDO.

DEFINE VAR x-aplic-id AS CHAR.
DEFINE VAR x-icon AS CHAR.
DEFINE VAR x-expanded AS CHAR.
DEFINE VAR x-label AS CHAR.

FOR EACH x-tGrupoAccesos WHERE x-tGrupoAccesos.campo-c[10] BEGINS pcNodeKey NO-LOCK BY x-tGrupoAccesos.campo-c[10]:
    /*        
    IF LENGTH(x-tGrupoAccesos.campo-c[10]) = LENGTH(pcNodeKey) THEN NEXT.
    IF LENGTH(pcNodeKey) + 2 <> LENGTH(x-tGrupoAccesos.campo-c[10])  THEN NEXT.

    x-icon = "tvpics/separator.bmp".
    x-expanded = "".
    x-label = "".
    
    IF x-tGrupoAccesos.campo-c[5] = "PROCESO" THEN x-expanded = "".
    IF x-tGrupoAccesos.campo-c[5] = "PROCESO" THEN x-icon = "tvpics/table.bmp".
    IF x-tGrupoAccesos.campo-c[5] = "PROCESO" THEN x-label = x-tGrupoAccesos.campo-c[4].
    IF x-tGrupoAccesos.campo-c[5] = "SUB-MENU" THEN x-expanded = "addOnExpand".
    IF x-tGrupoAccesos.campo-c[5] = "SUB-MENU" THEN x-icon = "tvpics/menusubmenu.bmp".
    IF x-tGrupoAccesos.campo-c[5] = "SUB-MENU" THEN x-label = x-tGrupoAccesos.campo-c[4].

    RUN addNode IN h_pure4gltv (x-tGrupoAccesos.campo-c[10]
                               ,pcnodeKey
                               ,x-label
                               ,x-icon
                               ,x-expanded).
   */ 
END.


/* DYNAMIC-FUNCTION('tvRefresh':U IN h_pure4gltv).*/


DEFINE VARIABLE nCust     AS INTEGER    NO-UNDO.
DEFINE VARIABLE norder    AS INTEGER    NO-UNDO.

DEFINE VARIABLE cSalesrep AS CHARACTER  NO-UNDO.
DEFINE VARIABLE icustnum  AS INTEGER    NO-UNDO.
DEFINE VARIABLE iorder    AS INTEGER    NO-UNDO.
DEFINE VARIABLE cFullPath AS CHARACTER  NO-UNDO.


/*========= For text treview sample, nodeKey beings 'n' ================
  for n221   I do not add a node, this one is actually a dummy
            addOnExpand node to show that pure4glTv does not panic
      
      n222   I add two nodes n2221 and n2222
      
      n2222  I add a node n22221*/
IF pcNodeKey = "n222" THEN DO:
    /*
    RUN addNode IN h_pure4gltv  ("n2221" ,"n222" ,"node 2221" ,"tvpics/books05.bmp"  ,"selected").
    RUN addNode IN h_pure4gltv  ("n2222" ,"n222" ,"node 2222" ,"tvpics/books05.bmp"  ,"addOnExpand").
    */
/* do by picLeftMouseEvent now    DYNAMIC-FUNCTION('tvRefresh':U IN h_pure4gltv).*/
END.
IF pcNodeKey = "n2222" THEN DO:
    /*RUN addNode IN h_pure4gltv  ("n22221" ,"n2222" ,"node 22221" ,"tvpics/user.bmp"  ,"").*/
/* do by picLeftMouseEvent now    DYNAMIC-FUNCTION('tvRefresh':U IN h_pure4gltv).*/
END.



/*======== For data treeview example on salesrep customer order orderline: ========*/


/*-------------- add customers to salesrep --------------*/
IF pcNodeKey BEGINS "sr=" THEN DO:
    /*
    cSalesrep = ENTRY(2,pcNodeKey,"=").
    FOR EACH customer NO-LOCK WHERE customer.salesrep = cSalesrep BY customer.name:
        nCust = nCust + 1.
        IF nCust > giRowsToBatch THEN DO:
            RUN addNode IN h_pure4gltv ("MoreCust=" + STRING(customer.custnum)
                                       ,pcNodeKey
                                       ,"More..."
                                       ,""
                                       ,"").
            LEAVE.
        END.
        RUN addNode IN h_pure4gltv ("cust=" + STRING(customer.custnum)
                                   ,pcNodeKey
                                   ,customer.name
                                   ,"tvpics/smile56.bmp"
                                   ,IF CAN-FIND(FIRST order OF customer) THEN "addOnExpand" ELSE "").
    END.  /* for each customer */
    */
END. /* add customers to salesrep node */


/*-------------- add orders to customer --------------*/
IF pcNodeKey BEGINS "cust=" THEN DO:
    /*
    icustnum = INT(ENTRY(2,pcNodeKey,"=")).
    FOR EACH order NO-LOCK WHERE order.custnum = icustnum BY order.ordernum:
        norder = nOrder + 1.
        IF norder > giRowsToBatch THEN DO:
            RUN addNode IN h_pure4gltv ("MoreOrder=" + STRING(order.ordernum)
                                       ,pcNodeKey
                                       ,"More..."
                                       ,""
                                       ,"").
            LEAVE.
        END.
        RUN addNode IN h_pure4gltv ("order=" + STRING(order.ordernum)
                                   ,pcNodeKey
                                   ,STRING(order.ordernum) + " (" + STRING(order.orderdate) + ")"
                                   ,"tvpics/book02.bmp"
                                   ,IF CAN-FIND(FIRST orderline OF order) THEN "addOnExpand" ELSE "").
    END.  /* for each customer */
    */
END. /* add customers to salesrep node */


/*-------------- add orderline to order --------------*/
IF pcNodeKey BEGINS "order=" THEN DO:
    /*
    iorder   = INT(ENTRY(2,pcNodeKey,"=")).
    FOR EACH orderline NO-LOCK WHERE orderline.ordernum = iorder BY orderline.linenum:
        FIND ITEM OF orderline NO-LOCK. 
        RUN addNode IN h_pure4gltv ("OL=" + STRING(iorder) + ";" + STRING(orderline.linenum)
                                   ,pcNodeKey
                                   ,STRING(orderline.linenum) + "  " + ITEM.itemname
                                   ,"tvpics/present1.bmp"
                                   ,"") NO-ERROR.
    END. /* FOR EACH orderline */
    IF ERROR-STATUS:ERROR THEN MESSAGE RETURN-VALUE VIEW-AS ALERT-BOX INFO BUTTONS OK.
    */
END.

/* example with directory tree */
IF pcNodeKey BEGINS "fileName=" THEN DO:
    cFullPath = ENTRY(2,pcNodeKey,"=").
    RUN loadDirectory (pcNodeKey, cFullPath).
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tvNodeCreatePopup wWin 
PROCEDURE tvNodeCreatePopup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pcnodeKey AS CHARACTER  NO-UNDO.

DEFINE VARIABLE nCust     AS INTEGER    NO-UNDO.
DEFINE VARIABLE norder    AS INTEGER    NO-UNDO.

DEFINE VARIABLE cSalesrep  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE icustnum   AS INTEGER    NO-UNDO.
DEFINE VARIABLE ccustname  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iorder     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cparentKey AS CHARACTER  NO-UNDO.

/*========= For text treview sample, nodeKey beings 'n' ================*/
IF pcNodeKey BEGINS "n"
 AND NUM-ENTRIES(pcNodeKey, "=") = 1
 THEN RETURN "Add a child node,MenuAddChildNode,RULE,,Hello World,MenuHelloWorld".


/*======== For data treeview example on salesrep customer order orderline: ========*/
/* popup menu addSalesRep and addCustomer */
IF pcNodeKey BEGINS "sr="
 THEN RETURN "Add Salesrep,MenuAddSR,Add Customer,MenuAddCustomer".

/*-------------- Popup menu addOrder  --------------*/
IF pcNodeKey BEGINS "cust="
 THEN RETURN "Add order,MenuAddOrder".

/*-------------- Popup menu addOrderline --------------*/
IF pcNodeKey BEGINS "order="
 THEN RETURN "Add order line,MenuAddOrderLine".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tvNodeDropEnd wWin 
PROCEDURE tvNodeDropEnd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcEvent   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcnodeKey AS CHARACTER  NO-UNDO.

DEFINE VARIABLE mouseX   AS INTEGER    NO-UNDO.
DEFINE VARIABLE mouseY   AS INTEGER    NO-UNDO.
DEFINE VARIABLE cWidgets AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hWidget  AS HANDLE     NO-UNDO.
DEFINE VARIABLE icount   AS INTEGER    NO-UNDO.

mouseX = INT(ENTRY(2,pcEvent)) NO-ERROR.
mouseY = INT(ENTRY(3,pcEvent)) NO-ERROR.

/* Example with the large tree (1000 node) and drag-drop used to move
 a node somewhere else (drop in the treeview itself */
IF pcnodeKey BEGINS "k" THEN DO:
    DEFINE VARIABLE targetKe AS CHARACTER  NO-UNDO.
    /*targetKe = DYNAMIC-FUNCTION('getNodeLocatedAtXY' IN h_pure4GlTv, mouseX, mouseY).*/
    /*
    IF lTraceEvents THEN DO:
        addToEdMsg("Drop end fired in MouseX: " + STRING(mouseX)
         + "  mouseY: " + STRING(mouseY) + "   nodeKey: " + pcnodeKey
         + "~n         => This falls in the following widgets:" + cWidgets
         + "~n         => Detected Target Nodekey: " + targetKe + "~n").
    END.
    
    IF targetKe <> "" AND targetKe <> pcnodeKey THEN
     RUN moveNode IN h_pure4gltv (pcnodeKey, targetKe, "after", "refresh") NO-ERROR.
    IF NOT ERROR-STATUS:ERROR THEN DYNAMIC-FUNCTION('selectNode' IN h_pure4gltv , pcnodeKey).
    ELSE MESSAGE "This node cannot be moved here!"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
    */
END.

/* other cases, the drop is done in this container */
ELSE DO:
    /* work out the name of drop target widgets from the handles passed in pcEvent*/
    DO iCount = 4 TO NUM-ENTRIES(pcEvent):
        hWidget = WIDGET-HANDLE(ENTRY(iCount,pcEvent)) NO-ERROR.
        cWidgets = cWidgets + " "
         + IF hWidget:NAME = ?
            THEN (IF CAN-QUERY(hWidget,"SCREEN-VALUE")
                   THEN "SCREEN-VALUE=" + hWidget:SCREEN-VALUE
                   ELSE "?")
            ELSE hWidget:NAME.
    END.
    /*
    /* if trace enable, then display info in the monitoring editor */
    IF lTraceEvents THEN DO:
        addToEdMsg("Drop end fired in at mouseX: " + STRING(mouseX)
         + "  mouseY: " + STRING(mouseY) + "   nodeKey: " + pcnodeKey + "~n").
        
        IF cWidgets = "" THEN addToEdMsg("         This (X,Y) does not falls in any widget~n").
        ELSE addToEdMsg("         This (X,Y) falls in the following widgets:" + cWidgets + "~n").
    END.
    */
    /* at last insert the label of the dragged node into the drop target widget */
    hWidget = ?.
    DO iCount = 4 TO NUM-ENTRIES(pcEvent):
        hWidget = WIDGET-HANDLE(ENTRY(iCount,pcEvent)) NO-ERROR.
        IF NOT CAN-QUERY(hWidget, "SCREEN-VALUE") THEN NEXT.
        IF NOT hWidget:SENSITIVE THEN NEXT. /* otherwise, we give the ability to change a label :o */
        
        DEFINE VARIABLE hNodeBuffer AS HANDLE     NO-UNDO.
        /*
        RUN getNodeDetails IN h_pure4gltv
        ( INPUT  pcnodeKey /* CHARACTER */,
          OUTPUT hNodeBuffer /* HANDLE */).
        */
        IF NOT VALID-HANDLE (hNodeBuffer) THEN LEAVE.
        
        CASE hWidget:TYPE:
          WHEN "EDITOR" THEN DO:
            hWidget:CURSOR-OFFSET = hWidget:LENGTH + 1.
            hWidget:INSERT-STRING(hNodeBuffer:BUFFER-FIELD("lab"):BUFFER-VALUE + "~n").
          END.
          WHEN "FILL-IN" THEN hWidget:SCREEN-VALUE = hWidget:SCREEN-VALUE + 
            hNodeBuffer:BUFFER-FIELD("lab"):BUFFER-VALUE NO-ERROR.
          OTHERWISE hWidget:SCREEN-VALUE = hNodeBuffer:BUFFER-FIELD("lab"):BUFFER-VALUE NO-ERROR.
        END CASE. /* CASE hWidget:TYPE: */
        APPLY 'VALUE-CHANGED'TO hWidget. /*very important if we want the change of the SCREEN-VALUE
                                          to result in the same as typing */

        DELETE OBJECT hNodeBuffer.
        
        LEAVE. /* one widget is enough ;) */
    END. /* DO iCount = 4 TO NUM-ENTRIES(cWidgets): */
END. /* other cases, the drop is done in this container */




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tvnodeEvent wWin 
PROCEDURE tvnodeEvent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pcEvent   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcnodeKey AS CHARACTER  NO-UNDO.

DEFINE VARIABLE nCust     AS INTEGER    NO-UNDO.
DEFINE VARIABLE norder    AS INTEGER    NO-UNDO.

DEFINE VARIABLE cSalesrep AS CHARACTER  NO-UNDO.
DEFINE VARIABLE icustnum  AS INTEGER    NO-UNDO.
DEFINE VARIABLE iorder AS INTEGER    NO-UNDO.


/*IF lTraceEvents THEN addToEdMsg(STRING(pcEvent,FILL("X",25)) + pcnodeKey + "~n").*/
 
CASE pcEvent:
  WHEN "addOnExpand" THEN RUN tvNodeaddOnExpand (pcnodeKey).
  WHEN "select"      THEN RUN tvNodeSelect (pcnodeKey).
  
  WHEN "rightClick"  THEN DO:
      RUN tvNodeCreatePopup (pcnodeKey) NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN RETURN RETURN-VALUE.
      ELSE MESSAGE "tvNodeCreatePopup failed with the following message:" RETURN-VALUE
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
  END.
  
  /* place to handle the Menu event */
  WHEN "MenuAddChildNode"
   OR WHEN "MenuAddSR"
   OR WHEN "MenuAddCustomer"
   OR WHEN "MenuAddOrder"
   OR WHEN "MenuAddOrderLine"
   THEN MESSAGE "addToEdMsg('Menu item event fired: ' + pcEvent + ' for key ' + pcnodeKey + '~n')".
   
   WHEN "MenuHelloWorld" THEN MESSAGE "Hello World!" SKIP
      "Node key parent of the popup menu item:" + pcNodeKey
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
   
   WHEN "DragBegin" THEN DO:
       /* sample with Large tree (1000 nodes), the node keys are of type "k<n>" 
         by returning "yourself" the treview will be the drop target to move a node
         to another location in the tree */
       IF pcnodeKey BEGINS "k" THEN RETURN "dropOnYourself".
       
       /* see node n4 in small TV */
       IF pcnodeKey = "n4" THEN RETURN "cancelDrag".
       
       /* drop target frame is in another window */
       IF pcnodeKey = "n1" THEN DO:
           /* to test that, use PRO*Tools/run to run C:\BabouSoft\tv4gl\OtherDropTargetWin.w
             with the persistent option before running this test container */
           DEFINE VARIABLE hTargetFrame AS HANDLE     NO-UNDO.
           PUBLISH "getOtherWinTargetFrame" (OUTPUT hTargetFrame).
           IF VALID-HANDLE(hTargetFrame) THEN RETURN STRING(hTargetFrame).
       END.

       /* for the other samle, the target is this container */
       RETURN STRING(FRAME fMain:HANDLE).
   END.
   
   OTHERWISE IF pcEvent BEGINS "DropEnd," THEN RUN tvNodeDropEnd (pcEvent, pcNodeKey).
END CASE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tvNodeSelect wWin 
PROCEDURE tvNodeSelect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pcnodeKey AS CHARACTER  NO-UNDO.

DEFINE VARIABLE nCust     AS INTEGER    NO-UNDO.
DEFINE VARIABLE norder    AS INTEGER    NO-UNDO.

DEFINE VARIABLE cSalesrep  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE icustnum   AS INTEGER    NO-UNDO.
DEFINE VARIABLE ccustname  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iorder     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cparentKey AS CHARACTER  NO-UNDO.
DEFINE VARIABLE optn       AS CHARACTER  NO-UNDO.



/*========= For text treview sample, nodeKey beings 'n' ================*/


/*======== For data treeview example on salesrep customer order orderline: ========*/



/*-------------- add more customers to salesrep --------------*/
IF pcNodeKey BEGINS "MoreCust=" THEN DO:
    /*
    ASSIGN
     icustnum = INT(ENTRY(2,pcNodeKey,"="))
     cparentKey = DYNAMIC-FUNCTION('getNodeParentKey' IN h_pure4glTv, pcNodeKey)
     cSalesrep = ENTRY(2,cparentKey,"=").
    FIND customer NO-LOCK WHERE customer.custnum = icustnum.
    cCustName = customer.name.
    
    FOR EACH customer NO-LOCK WHERE
     customer.salesrep = cSalesrep
     AND customer.name >= cCustName
     BY customer.name:
        nCust = nCust + 1.
        IF nCust > giRowsToBatch THEN DO:
            RUN addNode IN h_pure4gltv ("MoreCust=" + STRING(customer.custnum)
                                       ,cparentKey
                                       ,"More..."
                                       ,""
                                       ,"InViewPortIfPossible").
            LEAVE.
        END.
        optn = "InViewPortIfPossible".
        IF nCust = 1 THEN optn = optn + CHR(1) + "selected".
        IF CAN-FIND(FIRST order OF customer)
         THEN optn = optn + CHR(1) + "addOnExpand".
        
        RUN addNode IN h_pure4gltv ("cust=" + STRING(customer.custnum)
                                   ,cParentKey
                                   ,customer.name
                                   ,"tvpics/smile56.bmp"
                                   ,optn).
    END.  /* for each customer */
    
    RUN deleteNode IN h_Pure4glTv (pcNodeKey, "refresh").
    */
END. /* add more customers to salesrep node */


/*-------------- add more orders to customer --------------*/
IF pcNodeKey BEGINS "MoreOrder=" THEN DO:
    /*
    ASSIGN
     iorder = INT(ENTRY(2,pcNodeKey,"="))
     cparentKey = DYNAMIC-FUNCTION('getNodeParentKey' IN h_pure4glTv, pcNodeKey)
     icustnum = INT(ENTRY(2,cparentKey,"=")).
     
    FOR EACH order NO-LOCK WHERE
     order.custnum = icustnum
     AND order.ordernum >= iorder
     BY order.ordernum:
        norder = nOrder + 1.
        IF norder > giRowsToBatch THEN DO:
            RUN addNode IN h_pure4gltv ("MoreOrder=" + STRING(order.ordernum)
                                       ,cparentKey
                                       ,"More..."
                                       ,""
                                       ,"InViewPortIfPossible").
            LEAVE.
        END.
        optn = "InViewPortIfPossible".
        IF norder = 1 THEN optn = optn + CHR(1) + "selected".
        IF CAN-FIND(FIRST orderline OF order)
         THEN optn = optn + CHR(1) + "addOnExpand".
        
        RUN addNode IN h_pure4gltv ("order=" + STRING(order.ordernum)
                                   ,cparentKey
                                   ,STRING(order.ordernum) + " (" + STRING(order.orderdate) + ")"
                                   ,"tvpics/book02.bmp"
                                   ,optn).
    END.  /* for each customer */
    RUN deleteNode IN h_Pure4glTv (pcNodeKey, "refresh").
    */
END. /* add customers to salesrep node */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

