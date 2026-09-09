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

DEFINE SHARED VAR s-codcia AS INT.
DEFINE VAR lTabla AS CHAR INIT "RACKS".

DEFINE VAR lCD AS CHAR.

&SCOPED-DEFINE CONDICION ( ~
            INTEGRAL.vtatabla.CodCia = s-codcia AND ~
            INTEGRAL.vtatabla.tabla = lTabla AND ~
            INTEGRAL.vtatabla.llave_c1 = lCD)

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
&Scoped-define INTERNAL-TABLES INTEGRAL.VtaTabla

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 INTEGRAL.VtaTabla.Llave_c2 ~
INTEGRAL.VtaTabla.Valor[1] INTEGRAL.VtaTabla.Valor[2] ~
INTEGRAL.VtaTabla.Libre_c01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH INTEGRAL.VtaTabla ~
      WHERE {&CONDICION} NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH INTEGRAL.VtaTabla ~
      WHERE {&CONDICION} NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 INTEGRAL.VtaTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 INTEGRAL.VtaTabla


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txtCD btnAceptar BROWSE-2 btnAdd txtCodRack ~
txtCapacidad Rbx_activo btnGrabar btnBorrar 
&Scoped-Define DISPLAYED-OBJECTS txtCD txtNomCD txtCodRack txtCapacidad ~
Rbx_activo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnAceptar 
     LABEL "Aceptar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON btnAdd 
     LABEL "Nuevo" 
     SIZE 15 BY 1.12.

DEFINE BUTTON btnBorrar 
     LABEL "Cancelar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON btnGrabar 
     LABEL "Grabar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtCapacidad AS INTEGER FORMAT ">>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE txtCD AS CHARACTER FORMAT "X(5)":U 
     LABEL "Centro de Distribucion" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE txtCodRack AS CHARACTER FORMAT "X(8)":U 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE txtNomCD AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE Rbx_activo AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Activo", "SI",
"Inactivo", "NO"
     SIZE 12 BY 1.62 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      INTEGRAL.VtaTabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 wWin _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      INTEGRAL.VtaTabla.Llave_c2 COLUMN-LABEL "Cod.Rack" FORMAT "x(8)":U
      INTEGRAL.VtaTabla.Valor[1] COLUMN-LABEL "Capacidad!Nro Paletas" FORMAT "->>>,>>>,>>9":U
      INTEGRAL.VtaTabla.Valor[2] COLUMN-LABEL "Capacidad!Usada" FORMAT "->>>,>>>,>>9.9999":U
      INTEGRAL.VtaTabla.Libre_c01 COLUMN-LABEL "Activo" FORMAT "x(8)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 49 BY 20.77
         TITLE "(Haga DOUBLECLICK en el registro para BORRAR RACK)" ROW-HEIGHT-CHARS .65 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtCD AT ROW 1.38 COL 20.14 COLON-ALIGNED WIDGET-ID 2
     txtNomCD AT ROW 1.38 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     btnAceptar AT ROW 2.73 COL 24.14 WIDGET-ID 24
     BROWSE-2 AT ROW 4.46 COL 3 WIDGET-ID 200
     btnAdd AT ROW 6.38 COL 55.86 WIDGET-ID 6
     txtCodRack AT ROW 26.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     txtCapacidad AT ROW 26.46 COL 14 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     Rbx_activo AT ROW 26.12 COL 37.14 NO-LABEL WIDGET-ID 14
     btnGrabar AT ROW 26.31 COL 55 WIDGET-ID 22
     btnBorrar AT ROW 24.77 COL 55 WIDGET-ID 8
     "Cod.Rack" VIEW-AS TEXT
          SIZE 9 BY .62 AT ROW 25.88 COL 4 WIDGET-ID 18
     "Capacidad (Paletas)" VIEW-AS TEXT
          SIZE 18 BY 1.15 AT ROW 25.23 COL 15 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 75.57 BY 27.42 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Design Page: 1
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Definicion de Racks"
         HEIGHT             = 27.42
         WIDTH              = 75.57
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-2 btnAceptar fMain */
/* SETTINGS FOR FILL-IN txtNomCD IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.VtaTabla"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "{&CONDICION}"
     _FldNameList[1]   > INTEGRAL.VtaTabla.Llave_c2
"Llave_c2" "Cod.Rack" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.VtaTabla.Valor[1]
"Valor[1]" "Capacidad!Nro Paletas" "->>>,>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.VtaTabla.Valor[2]
"Valor[2]" "Capacidad!Usada" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaTabla.Libre_c01
"Libre_c01" "Activo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Definicion de Racks */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Definicion de Racks */
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
ON MOUSE-SELECT-DBLCLICK OF BROWSE-2 IN FRAME fMain /* (Haga DOUBLECLICK en el registro para BORRAR RACK) */
DO:
    DEFINE VAR lCodRack AS CHAR.
    DEFINE VAR lRowId AS ROWID.

    IF AVAILABLE vtatabla THEN DO:
        lCodRack = vtatabla.llave_c2.

        FIND FIRST vtactabla WHERE vtactabla.codcia = s-codcia AND 
                            vtactabla.tabla = "MOV-RACK-HDR" AND 
                            vtactabla.libre_c01 = lCodRack NO-LOCK NO-ERROR.
        IF AVAILABLE vtactabla THEN DO:
            MESSAGE "Imposible ELIMINAR el RACK, existen movimientos" VIEW-AS ALERT-BOX.
            RETURN NO-APPLY.
        END.

        MESSAGE "Seguro de eliminar el RACK(" + lCodRack + ")" VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

        /* Lo eliminamos */
        DEF BUFFER b-vtatabla FOR vtatabla.
        
        lRowid = ROWID(vtatabla).

        FIND FIRST b-vtatabla WHERE ROWID(b-vtatabla) = lRowId EXCLUSIVE NO-ERROR.
        IF AVAILABLE b-vtatabla THEN DO:
            DELETE b-vtatabla.
        END.
        RELEASE b-vtatabla.

        {&OPEN-QUERY-BROWSE-2}
    
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnAceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnAceptar wWin
ON CHOOSE OF btnAceptar IN FRAME fMain /* Aceptar */
DO:
    DEFINE VAR lxCD AS CHAR.

    lxCD = txtCD:SCREEN-VALUE.
    txtNomCD:SCREEN-VALUE = "".

    IF lxCD = "" THEN DO:
        RETURN NO-APPLY.
    END.

    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
          gn-divi.coddiv = lxCD NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-divi THEN DO:
        MESSAGE "Centro de Distribucion ERRADA" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
    END.

    txtNomCD:SCREEN-VALUE = gn-divi.desdiv.
    /**/
    btnAdd:VISIBLE = TRUE.
    btnGrabar:VISIBLE = FALSE.
    btnBorrar:VISIBLE = FALSE.
    txtCodRack:VISIBLE = FALSE.
    txtCapacidad:VISIBLE = FALSE.
    Rbx_activo:VISIBLE = FALSE.
    BROWSE-2:VISIBLE = TRUE.

    lCD = lxCD.
    {&OPEN-QUERY-BROWSE-2}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnAdd wWin
ON CHOOSE OF btnAdd IN FRAME fMain /* Nuevo */
DO:
    btnAdd:VISIBLE = FALSE.
    btnGrabar:VISIBLE = TRUE.
    btnBorrar:VISIBLE = TRUE.
    txtCodRack:VISIBLE = TRUE.
    txtCapacidad:VISIBLE = TRUE.
    Rbx_activo:VISIBLE = TRUE.

    APPLY 'ENTRY':U TO txtCodRack.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnBorrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnBorrar wWin
ON CHOOSE OF btnBorrar IN FRAME fMain /* Cancelar */
DO:
    btnAdd:VISIBLE = TRUE.
    btnGrabar:VISIBLE = FALSE.
    btnBorrar:VISIBLE = FALSE.
    txtCodRack:VISIBLE = FALSE.
    txtCapacidad:VISIBLE = FALSE.
    Rbx_activo:VISIBLE = FALSE.

    {&OPEN-QUERY-BROWSE-2}

    APPLY 'ENTRY':U TO BROWSE-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnGrabar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnGrabar wWin
ON CHOOSE OF btnGrabar IN FRAME fMain /* Grabar */
DO:

  ASSIGN txtCodRack txtCapacidad Rbx_activo txtCD.
     
  IF txtCodRack = "" THEN DO:
      MESSAGE "Ingrese el Codigo de RACK".
      RETURN NO-APPLY.
  END.
  IF txtCapacidad <= 0 THEN DO:
      MESSAGE "Ingrese la capacidad".
      RETURN NO-APPLY.
  END.

  FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
      vtatabla.tabla = lTabla AND vtatabla.llave_c1 = txtCD AND
      vtatabla.llave_c2 = txtCodRack NO-LOCK NO-ERROR.
  
  IF AVAILABLE vtatabla THEN DO:
      MESSAGE "Cod Rack Ya existe" VIEW-AS ALERT-BOX.
      RETURN NO-APPLY.
  END.

  DISABLE TRIGGERS FOR LOAD OF vtatabla.

  CREATE vtatabla.
      ASSIGN vtatabla.codcia = s-codcia
        vtatabla.tabla = lTabla
        vtatabla.llave_c1 = txtCD
        vtatabla.llave_c2 = txtCodRack
        vtatabla.valor[1] = txtCapacidad
        vtatabla.valor[2] = 0
        vtatabla.libre_c02 = rbx_activo.

      {&OPEN-QUERY-BROWSE-2}

        txtCodRack:SCREEN-VALUE = "".
       APPLY 'ENTRY':U TO txtCodRack.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCD wWin
ON ENTRY OF txtCD IN FRAME fMain /* Centro de Distribucion */
DO:
  btnAdd:VISIBLE = FALSE.
  btnGrabar:VISIBLE = FALSE.
  btnBorrar:VISIBLE = FALSE.
  txtCodRack:VISIBLE = FALSE.
  txtCapacidad:VISIBLE = FALSE.
  Rbx_activo:VISIBLE = FALSE.
  BROWSE-2:VISIBLE = FALSE.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCD wWin
ON LEAVE OF txtCD IN FRAME fMain /* Centro de Distribucion */
DO:
  DEFINE VAR lxCD AS CHAR.

  lxCD = txtCD:SCREEN-VALUE.
  txtNomCD:SCREEN-VALUE = "".

  IF lxCD <> "" THEN DO:
      FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
            gn-divi.coddiv = lxCD NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-divi THEN DO:
          RETURN NO-APPLY.
      END.
    
      txtNomCD:SCREEN-VALUE = gn-divi.desdiv.
  END.    
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
  DISPLAY txtCD txtNomCD txtCodRack txtCapacidad Rbx_activo 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE txtCD btnAceptar BROWSE-2 btnAdd txtCodRack txtCapacidad Rbx_activo 
         btnGrabar btnBorrar 
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

