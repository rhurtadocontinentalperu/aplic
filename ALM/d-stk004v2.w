&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-MATG NO-UNDO LIKE Almmmatg.



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
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.

DEFINE VAR pv-codcia AS INT.

FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje FORMAT 'x(30)' NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

DEF TEMP-TABLE DETALLE NO-UNDO
    FIELD CodMat LIKE Almmmatg.codmat FORMAT 'x(6)' LABEL 'Codigo'
    FIELD DesMat LIKE Almmmatg.desmat FORMAT 'x(100)' LABEL 'Descripcion'
    FIELD DesMar LIKE Almmmatg.desmar FORMAT 'x(30)' LABEL 'Marca'
    FIELD DesFam LIKE Almtfami.desfam FORMAT 'x(30)' LABEL 'Familia'
    FIELD DesSub LIKE Almsfami.dessub FORMAT 'x(30)' LABEL 'Sub Familia'
    FIELD NomPro LIKE gn-prov.nompro  FORMAT 'x(100)' LABEL 'Proveedor'
    FIELD CC     AS CHAR              FORMAT 'x(10)' LABEL 'Cat.Contable'
    FIELD UndStk LIKE Almmmatg.undstk FORMAT 'x(10)' LABEL 'Unidad'
    FIELD CtoUni AS DEC               FORMAT '>>>,>>>,>>9.9999' LABEL 'Costo Unit. (S/IGV)'
    FIELD Almacen AS CHAR             FORMAT 'x(40)' LABEL 'Almacen'
    FIELD StkAct AS DEC               FORMAT '->>>,>>>,>>9.9999' LABEL 'Stock'
    FIELD Campagna AS CHAR            FORMAT 'x(5)' LABEL 'CAMPAÑA'
    FIELD NoCampagna AS CHAR          FORMAT 'x(5)' LABEL 'NO CAMPAÑA'
    FIELD Ubicacion AS CHAR           FORMAT 'x(20)' LABEL 'UBICACION'
    INDEX DETA01 AS PRIMARY CodMat Almacen.

DEF VAR s-SubTit AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-57 BUTTON-3 DFecha cCategoria DesdeC ~
HastaC RADIO-SET_TpoArt c-CodFam x-CodPro R-Costo BUTTON-Cargar ~
Btn_Cancel-2 Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-CodAlm DFecha cCategoria ~
FILL-IN-Nombre DesdeC HastaC RADIO-SET_TpoArt c-CodFam x-CodPro R-Costo ~
x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_Cancel-2 
     IMAGE-UP FILE "img\excel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5 TOOLTIP "Detallado por material y todos los almacenes"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-3 
     LABEL "..." 
     SIZE 4 BY .96 TOOLTIP "Seleccionar almacenes".

DEFINE BUTTON BUTTON-Cargar 
     IMAGE-UP FILE "IMG/balance.ico":U
     LABEL "Exportar a TEXTO" 
     SIZE 11 BY 1.5 TOOLTIP "Cargar la BD a exportar a texto".

DEFINE VARIABLE EDITOR-CodAlm AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 64 BY 4
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE c-CodFam AS CHARACTER FORMAT "x(3)":U 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69 NO-UNDO.

DEFINE VARIABLE cCategoria AS CHARACTER FORMAT "X(3)":U 
     LABEL "Categoria Contable" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(9)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE DFecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Al" 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-Nombre AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .81 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(9)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE x-CodPro AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .69 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 72.14 BY .81 NO-UNDO.

DEFINE VARIABLE R-Costo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Promedio", 1,
"Reposición", 2
     SIZE 20 BY .96 NO-UNDO.

DEFINE VARIABLE RADIO-SET_TpoArt AS CHARACTER INITIAL "A" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Solo Activos", "A",
"Solo Inactivos", "D"
     SIZE 25 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89 BY 1.92
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 11.12.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     EDITOR-CodAlm AT ROW 1.81 COL 20 NO-LABEL WIDGET-ID 42
     BUTTON-3 AT ROW 1.81 COL 85 WIDGET-ID 6
     DFecha AT ROW 6.12 COL 18 COLON-ALIGNED
     cCategoria AT ROW 6.88 COL 18 COLON-ALIGNED
     FILL-IN-Nombre AT ROW 6.88 COL 28 COLON-ALIGNED NO-LABEL
     DesdeC AT ROW 7.65 COL 18 COLON-ALIGNED
     HastaC AT ROW 7.65 COL 33 COLON-ALIGNED
     RADIO-SET_TpoArt AT ROW 7.73 COL 49 NO-LABEL WIDGET-ID 46
     c-CodFam AT ROW 8.42 COL 18 COLON-ALIGNED
     x-CodPro AT ROW 9.19 COL 18 COLON-ALIGNED
     R-Costo AT ROW 9.96 COL 20 NO-LABEL
     x-mensaje AT ROW 11.19 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     BUTTON-Cargar AT ROW 12.58 COL 55 WIDGET-ID 10
     Btn_Cancel-2 AT ROW 12.58 COL 66
     Btn_Cancel AT ROW 12.58 COL 77
     "Almacenes:" VIEW-AS TEXT
          SIZE 9 BY .62 AT ROW 1.81 COL 11 WIDGET-ID 44
     "Criterio de Selección" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     "Valorización:" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 10.15 COL 11
     RECT-57 AT ROW 1.19 COL 1.43
     RECT-46 AT ROW 12.31 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89.57 BY 13.42
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-MATG T "?" NO-UNDO INTEGRAL Almmmatg
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "VALORIZACION DEL STOCK LOGISTICO POR ALMACEN"
         HEIGHT             = 13.42
         WIDTH              = 89.57
         MAX-HEIGHT         = 16.5
         MAX-WIDTH          = 99
         VIRTUAL-HEIGHT     = 16.5
         VIRTUAL-WIDTH      = 99
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT W-Win:LOAD-ICON("img\climnu3":U) THEN
    MESSAGE "Unable to load icon: img\climnu3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
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
/* SETTINGS FOR EDITOR EDITOR-CodAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Nombre IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* VALORIZACION DEL STOCK LOGISTICO POR ALMACEN */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* VALORIZACION DEL STOCK LOGISTICO POR ALMACEN */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel-2 W-Win
ON CHOOSE OF Btn_Cancel-2 IN FRAME F-Main /* Cancelar */
DO:
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Excel.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* ... */
DO:
    DEFINE VARIABLE x-almacenes AS CHAR NO-UNDO.
    x-almacenes = EDITOR-CodAlm:SCREEN-VALUE.
    RUN alm/d-almacen (INPUT-OUTPUT x-almacenes).

    /* Verificar almacenes: tiene que cuadrar con el reporte RP38 alm/d-stk004v2 */
    DEF VAR x-Final AS CHAR NO-UNDO.
    DEF VAR k AS INTE NO-UNDO.

    IF x-Almacenes > '' THEN DO:
        DO k = 1 TO NUM-ENTRIES(x-Almacenes):
            FIND Almacen WHERE Almacen.codcia = s-codcia AND
                Almacen.codalm = ENTRY(k, x-Almacenes)
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almacen THEN NEXT.
            IF Almacen.almcsg = YES THEN NEXT.
            IF Almacen.flgrep = NO  THEN NEXT.
            x-Final = x-Final + 
                    (IF TRUE <> (x-Final > '') THEN '' ELSE ',') +
                    ENTRY(k, x-Almacenes).
        END.
    END.
    EDITOR-CodAlm:SCREEN-VALUE = x-Final.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Cargar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Cargar W-Win
ON CHOOSE OF BUTTON-Cargar IN FRAME F-Main /* Exportar a TEXTO */
DO:
    RUN Asigna-Variables.
    RUN Inhabilita.
    RUN Texto.
    RUN Habilita.
    RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-CodFam W-Win
ON LEFT-MOUSE-DBLCLICK OF c-CodFam IN FRAME F-Main /* Linea */
OR f8 OF c-CodFam DO:
    ASSIGN
        input-var-1 = ""
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?.
    RUN lkup/c-famili("Linea").
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cCategoria
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cCategoria W-Win
ON LEAVE OF cCategoria IN FRAME F-Main /* Categoria Contable */
DO:
  FILL-IN-Nombre:SCREEN-VALUE = ''.
  FIND Almtabla WHERE almtabla.tabla = 'CC'
    AND almtabla.codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Almtabla THEN FILL-IN-Nombre:SCREEN-VALUE = almtabla.nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cCategoria W-Win
ON LEFT-MOUSE-DBLCLICK OF cCategoria IN FRAME F-Main /* Categoria Contable */
OR f8 OF cCategoria DO:
    ASSIGN
        input-var-1 = "CC"
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?.
    RUN lkup/c-almtab("Categoría Contable").
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC W-Win
ON LEAVE OF DesdeC IN FRAME F-Main /* Articulo */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC W-Win
ON LEAVE OF HastaC IN FRAME F-Main /* A */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.  
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodPro W-Win
ON LEFT-MOUSE-DBLCLICK OF x-CodPro IN FRAME F-Main /* Proveedor */
OR f8 OF x-CodPro DO:
    ASSIGN
        input-var-1 = ""
        input-var-2 = ""
        input-var-3 = ""
        output-var-1 = ?.
    RUN lkup/c-provee("Proveedor").
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables W-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN 
          RADIO-SET_TpoArt
          DesdeC HastaC DFecha R-Costo 
          cCategoria c-CodFam EDITOR-CodAlm
          x-CodPro.
      IF TRUE <> (DesdeC > '') THEN DO:
          FIND FIRST Almmmatg USE-INDEX Matg01 WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat > '' NO-LOCK NO-ERROR.
          IF AVAILABLE Almmmatg THEN DesdeC = Almmmatg.CodMat.
      END.
      IF TRUE <> (HastaC > '') THEN DO:
          FIND LAST Almmmatg USE-INDEX Matg01 WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat > '' NO-LOCK NO-ERROR.
          IF AVAILABLE Almmmatg THEN HastaC = Almmmatg.CodMat.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Excel W-Win 
PROCEDURE Carga-Temporal-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR F-Saldo  AS DEC NO-UNDO.
  DEF VAR F-CtoUni AS DEC NO-UNDO.
  DEF VAR x-Total  AS DEC NO-UNDO.
  DEF VAR x-Almacen AS CHAR NO-UNDO.
  DEF VAR x-Item AS INT NO-UNDO.
  DEF VAR x-Cuenta AS INT NO-UNDO.

  /* Primero cargamos un temporal con la información filtrada */
  DEF VAR x-FiltroOK AS LOG NO-UNDO INIT NO.
  DEF VAR x-ItemOK   AS LOG NO-UNDO INIT NO.
  DEFINE VAR cFiler AS CHAR NO-UNDO.

  EMPTY TEMP-TABLE T-MATG.

  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND
      Almmmatg.TpoArt = RADIO-SET_TpoArt AND
      (TRUE <> (DesdeC > '') OR Almmmatg.codmat >= DesdeC) AND
      (TRUE <> (HastaC > '') OR Almmmatg.codmat <= HastaC) AND
      (TRUE <> (c-CodFam > '') OR Almmmatg.codfam = c-CodFam) AND
      (TRUE <> (x-CodPro > '') OR Almmmatg.codpr1 = x-CodPro) AND
      (TRUE <> (cCategoria > '') OR Almmmatg.catconta[1] = cCategoria):
      CREATE T-MATG.
      BUFFER-COPY Almmmatg TO T-MATG NO-ERROR.
      RELEASE T-MATG.
  END.

  x-Almacen = EDITOR-CodAlm. 

  EMPTY TEMP-TABLE Detalle.
  DO x-Item = 1 TO NUM-ENTRIES(x-Almacen):
      FIND Almacen WHERE Almacen.CodCia = s-codcia AND Almacen.CodAlm = ENTRY(x-Item, x-Almacen) NO-LOCK NO-ERROR.
      RUN Paso-1.
  END.

  DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

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
  DISPLAY EDITOR-CodAlm DFecha cCategoria FILL-IN-Nombre DesdeC HastaC 
          RADIO-SET_TpoArt c-CodFam x-CodPro R-Costo x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 BUTTON-3 DFecha cCategoria DesdeC HastaC RADIO-SET_TpoArt 
         c-CodFam x-CodPro R-Costo BUTTON-Cargar Btn_Cancel-2 Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Archivo de Salida */
DEF VAR c-csv-file AS CHAR NO-UNDO.
DEF VAR c-xls-file AS CHAR INIT 'Archivo_Excel' NO-UNDO.
DEF VAR rpta AS LOG INIT NO NO-UNDO.

SYSTEM-DIALOG GET-FILE c-xls-file
    FILTERS 'Libro de Excel' '*.xlsx'
    INITIAL-FILTER 1
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".xlsx"
    SAVE-AS
    TITLE "Guardar como"
    USE-FILENAME
    UPDATE rpta.
IF rpta = NO THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
/* Variable de memoria */
DEFINE VAR hProc AS HANDLE NO-UNDO.
/* Levantamos la libreria a memoria */
RUN lib\Tools-to-excel PERSISTENT SET hProc.

/* Cargamos la informacion al temporal */
EMPTY TEMP-TABLE Detalle.

RUN Carga-Temporal-Excel.

/* Programas que generan el Excel */
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER Detalle:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .

RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER Detalle:handle,
                                  INPUT  c-csv-file,
                                  OUTPUT c-xls-file) .

/* Borramos librerias de la memoria */
DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').

MESSAGE 'Reporte Terminado'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Habilita W-Win 
PROCEDURE Habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ENABLE ALL EXCEPT FILL-IN-Nombre x-mensaje.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inhabilita W-Win 
PROCEDURE Inhabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    DISABLE ALL.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa-Variables W-Win 
PROCEDURE Inicializa-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ASSIGN DesdeC HastaC DFecha cCategoria R-Costo c-CodFam EDITOR-CodAlm RADIO-SET_TpoArt.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE limpiar-texto W-Win 
PROCEDURE limpiar-texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER cadenaTexto AS CHAR.
DEF INPUT PARAMETER sustituirPor AS CHAR.
DEF OUTPUT PARAMETER cadenaResultado AS CHAR.

DEF VAR tamanoCadena AS INT NO-UNDO.
DEF VAR i AS INT NO-UNDO.
DEF VAR caracteresValidos AS CHAR NO-UNDO.
DEF VAR caracterActual AS CHAR NO-UNDO.
  
tamanoCadena = LENGTH(cadenaTexto).
If tamanoCadena > 0 THEN DO:
    caracteresValidos = ' 0123456789abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ-_.,'.
    caracteresValidos = caracteresValidos + "/()#*+-$&%áéíóúÁÉÍÓÚ:¿?!¡=@".
    /*caracteresValidos = caracteresValidos + "/()#*+-$&%'áéíóúÁÉÍÓÚüÜº°:´Øª¿?!¡=@".*/
    DO i = 1 TO tamanoCadena:
        caracterActual = SUBSTRING(cadenaTexto, i, 1).
        IF INDEX(caracteresValidos, caracterActual) > 0 THEN
            cadenaResultado = cadenaResultado + caracterActual.
        ELSE 
            cadenaResultado = cadenaResultado + sustituirPor.
    END.
END.

END PROCEDURE.

/*
DEF VAR tamanoCadena AS INT NO-UNDO.
DEF VAR i AS INT NO-UNDO.
DEF VAR caracteresValidos AS CHAR NO-UNDO.
DEF VAR caracterActual AS CHAR NO-UNDO.
  
tamanoCadena = LENGTH(cadenaTexto).
If tamanoCadena > 0 THEN DO:
    caracteresValidos = ' 0123456789abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ-.,"'.
    caracteresValidos = caracteresValidos + "/()#*+-$'áéíóúÁÉÍÓÚüÜ&%:´¿?!¡;=@".
    DO i = 1 TO tamanoCadena:
        caracterActual = SUBSTRING(cadenaTexto, i, 1).
        IF INDEX(caracteresValidos, caracterActual) > 0 THEN
            cadenaResultado = cadenaResultado + caracterActual.
        ELSE 
            cadenaResultado = cadenaResultado + sustituirPor.
    END.
END.
    */

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
  ASSIGN
    DFecha = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Paso-1 W-Win 
PROCEDURE Paso-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
      DEF VAR x-Cuenta AS INTE NO-UNDO.
      DEF VAR F-Saldo AS DECI NO-UNDO.
      DEF VAR F-CtoUni AS DECI NO-UNDO.
      DEF VAR x-Texto AS CHAR NO-UNDO.

      FOR EACH T-MATG NO-LOCK WHERE T-MATG.codcia = s-codcia,
          FIRST Almmmatg OF T-MATG NO-LOCK,
          FIRST Almmmate OF T-MATG NO-LOCK WHERE Almmmate.codcia = s-codcia 
          AND Almmmate.CodAlm = Almacen.CodAlm,
          FIRST Almtfami OF T-MATG NO-LOCK,
          FIRST Almsfami OF T-MATG NO-LOCK:
          x-Cuenta = x-Cuenta + 1.
          ASSIGN F-Saldo  = 0.
          IF DFecha = TODAY THEN F-Saldo = Almmmate.StkAct.
          ELSE DO:
              FIND LAST AlmStkAl WHERE almstkal.codcia = s-codcia
                  AND almstkal.codalm = Almmmate.codalm
                  AND almstkal.codmat = almmmatg.codmat
                  AND almstkal.fecha <= DFecha
                  NO-LOCK NO-ERROR.
              IF AVAILABLE Almstkal THEN F-Saldo = almstkal.stkact.
          END.
          IF F-Saldo = 0 THEN NEXT.
          IF x-Cuenta MODULO 100 = 0 THEN DISPLAY "Almacen : " + Almacen.codalm + "  " +
              "Codigo de Articulo: " +  Almmmatg.CodMat @ x-mensaje WITH FRAME {&FRAME-NAME}.
          PAUSE 0.
          /* CARGAMOS TEMPORAL */
          CREATE DETALLE.
          ASSIGN
              Detalle.CodMat = Almmmatg.codmat 
              Detalle.DesMat = Almmmatg.desmat 
              Detalle.DesMar = Almmmatg.desmar 
              Detalle.DesFam = Almmmatg.codfam + ' ' + Almtfami.desfam 
              Detalle.DesSub = Almmmatg.subfam + ' ' + Almsfami.dessub 
              Detalle.UndStk = Almmmatg.undstk 
              Detalle.CC = Almmmatg.catconta[1]
              Detalle.Almacen = Almacen.codalm + ' ' + Almacen.descripcion.
          FIND gn-prov WHERE gn-prov.codcia = pv-codcia AND gn-prov.codpro = Almmmatg.codpr1 NO-LOCK NO-ERROR.
          IF AVAILABLE gn-prov THEN ASSIGN Detalle.NomPro = gn-prov.CodPro + ' ' + gn-prov.NomPro.
          /* ***************** */
          /* Saldo Logistico */
          ASSIGN 
              Detalle.StkAct = F-Saldo.
          /* Costo Unitario */
          ASSIGN F-CtoUni = 0.
          CASE R-COSTO:
              WHEN 1 THEN DO:
                  FIND LAST AlmStkGe WHERE almstkge.codcia = s-codcia
                      AND almstkge.codmat = almmmatg.codmat
                      AND almstkge.fecha <= DFecha
                      NO-LOCK NO-ERROR.
                  IF AVAILABLE AlmStkGe THEN F-CtoUni = almstkge.ctouni.
              END.
              WHEN 2 THEN DO:
                  F-CtoUni = Almmmatg.CtoLis.
                  IF Almmmatg.MonVta = 2 THEN DO:
                      IF Almmmatg.TpoCmb = 0 OR Almmmatg.TpoCmb = ? THEN DO:
                          NEXT.
                      END.
                      F-CtoUni = F-CtoUni * Almmmatg.TpoCmb.
                  END.
              END.
          END CASE.
          ASSIGN DETALLE.CtoUni = F-CtoUni.
          /* 24/09/2024: Susana León, columnas de CLASIFICACION GENERAL */
          FIND FacTabla WHERE FacTabla.codcia = s-codcia AND
              FacTabla.tabla = 'RANKVTA' AND
              FacTabla.codigo = Detalle.codmat
              NO-LOCK NO-ERROR.
          IF AVAILABLE FacTabla THEN DO:
              Detalle.Campagna = FacTabla.Campo-C[1].
              Detalle.NoCampagna = FacTabla.Campo-C[4].
          END.
          /* 22/07/2026: Michael Poma */
          ASSIGN 
              Detalle.Ubicacion = Almmmate.CodUbi.

          /* 2/10/2024: Limpiamos texto */
          RUN lib/limpiar-texto-abc (Detalle.desmat,
                                     ' ',
                                     OUTPUT x-Texto).

          x-Texto = REPLACE(x-Texto,";"," ").
          Detalle.desmat = CODEPAGE-CONVERT(x-Texto,SESSION:CHARSET, "utf-8").

          RUN lib/limpiar-texto-abc (Detalle.desmar,
                                     ' ',
                                     OUTPUT x-Texto).

          x-Texto = REPLACE(x-Texto,";"," ").
          Detalle.desmar = CODEPAGE-CONVERT(x-Texto,SESSION:CHARSET, "utf-8").

          RUN lib/limpiar-texto-abc (Detalle.desfam,
                                     ' ',
                                     OUTPUT x-Texto).

          x-Texto = REPLACE(x-Texto,";"," ").
          Detalle.desfam = CODEPAGE-CONVERT(x-Texto,SESSION:CHARSET, "utf-8").

          RUN lib/limpiar-texto-abc (Detalle.dessub,
                                     ' ',
                                     OUTPUT x-Texto).

          x-Texto = REPLACE(x-Texto,";"," ").
          Detalle.dessub = CODEPAGE-CONVERT(x-Texto,SESSION:CHARSET, "utf-8").

          RUN lib/limpiar-texto-abc (Detalle.nompro,
                                     ' ',
                                     OUTPUT x-Texto).

          x-Texto = REPLACE(x-Texto,";"," ").
          Detalle.nompro = CODEPAGE-CONVERT(x-Texto,SESSION:CHARSET, "utf-8").

          RUN lib/limpiar-texto-abc (Detalle.almacen,
                                     ' ',
                                     OUTPUT x-Texto).

          x-Texto = REPLACE(x-Texto,";"," ").
          Detalle.almacen = CODEPAGE-CONVERT(x-Texto,SESSION:CHARSET, "utf-8").

      END.
      RELEASE Detalle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Paso-2 W-Win 
PROCEDURE Paso-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR F-CtoUni AS DECI NO-UNDO.

FOR EACH Detalle EXCLUSIVE-LOCK, FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = Detalle.codmat:
    /* Costo Unitario */
    ASSIGN F-CtoUni = 0.
    CASE R-COSTO:
        WHEN 1 THEN DO:
            FIND LAST AlmStkGe WHERE almstkge.codcia = s-codcia
                AND almstkge.codmat = almmmatg.codmat
                AND almstkge.fecha <= DFecha
                NO-LOCK NO-ERROR.
            IF AVAILABLE AlmStkGe THEN F-CtoUni = almstkge.ctouni.
        END.
        WHEN 2 THEN DO:
            F-CtoUni = Almmmatg.CtoLis.
            IF Almmmatg.MonVta = 2 THEN DO:
                IF Almmmatg.TpoCmb = 0 OR Almmmatg.TpoCmb = ? THEN DO:
                    NEXT.
                END.
                F-CtoUni = F-CtoUni * Almmmatg.TpoCmb. 
            END.
        END.
    END CASE.
    ASSIGN DETALLE.CtoUni = F-CtoUni.
END.
RELEASE Detalle.

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto W-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.

    RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').

    /* Cargamos la informacion al temporal */
    EMPTY TEMP-TABLE Detalle.

    RUN Carga-Temporal-Excel.

    SESSION:SET-WAIT-STATE('').

    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    
    cArchivo = LC(pArchivo).
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN lib/tt-filev2 (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _Header W-Win 
PROCEDURE _Header :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
titulo = "REPORTE DE MOVIMIENTOS POR DIA".

mens1 = "TIPO Y CODIGO DE MOVIMIENTO : " + C-TipMov + "-" + STRING(I-CodMov, "99") + " " + D-Movi:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
mens2 = "MATERIAL : " + DesdeC + " A: " + HastaC .
mens3 = "FECHA : " + STRING(F-FchDes, "99/99/9999") + " A: " + STRING(F-FchHas, "99/99/9999").

titulo = S-NomCia + fill(" ", (INT((90 - length(titulo)) / 2)) - length(S-NomCia)) + titulo.
mens1 = fill(" ", INT((90 - length(mens1)) / 2)) + mens1.
mens2 = fill(" ", INT((90 - length(mens2)) / 2)) + mens2.
mens3 = C-condicion:SCREEN-VALUE + fill(" ", INT((90 - length(mens3)) / 2) - LENGTH(C-condicion:SCREEN-VALUE)) + mens3.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

