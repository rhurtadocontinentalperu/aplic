&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE MATE NO-UNDO LIKE INTEGRAL.Almmmate.


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

DEF VAR pr-codcia AS INT NO-UNDO.

FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodPro THEN pr-codcia = s-codcia.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES MATE Almmmatg

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 MATE.codmat Almmmatg.DesMat ~
Almmmatg.UndBas MATE.StkMin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-1
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH MATE NO-LOCK, ~
      EACH Almmmatg OF MATE NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 MATE Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 MATE


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-CodAlm x-CodPro x-FchDoc-1 x-FchDoc-2 ~
x-Dias x-Entrega x-Tramites BROWSE-1 BUTTON-3 Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS x-NomAlm x-CodAlm x-CodPro x-NomPro ~
x-FchDoc-1 x-FchDoc-2 x-FchDoc-3 x-FchDoc-4 x-Dias x-FchDoc-5 x-FchDoc-6 ~
x-Entrega x-Tramites 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\exit":U
     LABEL "&Done" 
     SIZE 15 BY 1.54 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img\proces":U
     LABEL "Button 3" 
     SIZE 15 BY 1.54 TOOLTIP "Procesar Stock Minimo".

DEFINE VARIABLE x-CodAlm AS CHARACTER FORMAT "x(3)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodPro AS CHARACTER FORMAT "x(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-Dias AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Dias a Proyectar" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE x-Entrega AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Tiempo de Entrega" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-3 AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-4 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-5 AS DATE FORMAT "99/99/99":U 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-6 AS DATE FORMAT "99/99/99":U 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE x-Tramites AS INTEGER FORMAT ">>9":U INITIAL 3 
     LABEL "Tramites" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      MATE, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      MATE.codmat COLUMN-LABEL "Codigo"
      Almmmatg.DesMat FORMAT "X(50)"
      Almmmatg.UndBas COLUMN-LABEL "Unidad"
      MATE.StkMin COLUMN-LABEL "Stock Minimo"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 90 BY 12.69
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-NomAlm AT ROW 1.19 COL 27 COLON-ALIGNED NO-LABEL
     x-CodAlm AT ROW 1.19 COL 20 COLON-ALIGNED
     x-CodPro AT ROW 2.15 COL 20 COLON-ALIGNED
     x-NomPro AT ROW 2.15 COL 32 COLON-ALIGNED NO-LABEL
     x-FchDoc-1 AT ROW 3.12 COL 20 COLON-ALIGNED
     x-FchDoc-2 AT ROW 3.12 COL 37 COLON-ALIGNED
     x-FchDoc-3 AT ROW 4.08 COL 20 COLON-ALIGNED
     x-FchDoc-4 AT ROW 4.08 COL 37 COLON-ALIGNED
     x-Dias AT ROW 5.04 COL 20 COLON-ALIGNED
     x-FchDoc-5 AT ROW 5.04 COL 26 COLON-ALIGNED NO-LABEL
     x-FchDoc-6 AT ROW 5.04 COL 37 COLON-ALIGNED NO-LABEL
     x-Entrega AT ROW 6 COL 20 COLON-ALIGNED
     x-Tramites AT ROW 6.96 COL 20 COLON-ALIGNED
     BROWSE-1 AT ROW 8.31 COL 3
     BUTTON-3 AT ROW 4.65 COL 78
     Btn_Done AT ROW 6.38 COL 78
     "Periodo a Evaluar" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 3.31 COL 3
     "Periodo Histórico" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 4.27 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 94.29 BY 20.38
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: MATE T "?" NO-UNDO INTEGRAL Almmmate
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CALCULO DEL STOCK MINIMO"
         HEIGHT             = 20.46
         WIDTH              = 94.14
         MAX-HEIGHT         = 20.46
         MAX-WIDTH          = 95.43
         VIRTUAL-HEIGHT     = 20.46
         VIRTUAL-WIDTH      = 95.43
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   Custom                                                               */
/* BROWSE-TAB BROWSE-1 x-Tramites F-Main */
/* SETTINGS FOR FILL-IN x-FchDoc-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-FchDoc-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-FchDoc-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-FchDoc-6 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomAlm IN FRAME F-Main
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
     _TblList          = "Temp-Tables.MATE,INTEGRAL.Almmmatg OF Temp-Tables.MATE"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.MATE.codmat
"MATE.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(50)" "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > INTEGRAL.Almmmatg.UndBas
"Almmmatg.UndBas" "Unidad" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   > Temp-Tables.MATE.StkMin
"MATE.StkMin" "Stock Minimo" ? "decimal" ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CALCULO DEL STOCK MINIMO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CALCULO DEL STOCK MINIMO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Done */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  ASSIGN {&DISPLAYED-OBJECTS}.
  RUN Valida.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  RUN Carga-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodAlm W-Win
ON LEAVE OF x-CodAlm IN FRAME F-Main /* Almacen */
DO:
  x-NomAlm:SCREEN-VALUE = ''.
  FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = INPUT {&SELF-NAME}
    NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN x-NomAlm:SCREEN-VALUE = Almacen.Descripcion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodPro W-Win
ON LEAVE OF x-CodPro IN FRAME F-Main /* Proveedor */
DO:
  x-NomPro:SCREEN-VALUE = ''.
  FIND Gn-prov WHERE Gn-prov.codcia = pr-codcia
    AND gn-prov.codpro = INPUT {&SELF-NAME}
    NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-prov THEN DO:
    DISPLAY 
        gn-prov.NomPro @ x-NomPro
        gn-prov.TpoEnt @ x-Entrega
        WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Dias
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Dias W-Win
ON LEAVE OF x-Dias IN FRAME F-Main /* Dias a Proyectar */
DO:
  RUN Carga-Campos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FchDoc-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FchDoc-1 W-Win
ON LEAVE OF x-FchDoc-1 IN FRAME F-Main /* Desde */
DO:
  RUN Carga-Campos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FchDoc-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FchDoc-2 W-Win
ON LEAVE OF x-FchDoc-2 IN FRAME F-Main /* Hasta */
DO:
  RUN Carga-Campos.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Campos W-Win 
PROCEDURE Carga-Campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN {&DISPLAYED-OBJECTS}.
    x-FchDoc-3 = x-FchDoc-1 - 365.
    x-FchDoc-4 = x-FchDoc-2 - 365.
    x-FchDoc-5 = TODAY + 1 - 365.
    x-FchDoc-6 = x-FchDoc-5 + x-Dias.
    DISPLAY  {&DISPLAYED-OBJECTS}.
  END.
  
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
  DEF VAR x-VtaEva AS DEC NO-UNDO.
  DEF VAR x-VtaHis AS DEC NO-UNDO.
  DEF VAR x-HisPro AS DEC NO-UNDO.
  DEF VAR x-Factor AS DEC DECIMALS 8 NO-UNDO.
  DEF VAR x-ProVta AS DEC NO-UNDO.
  DEF VAR x-StkMin AS DE NO-UNDO.
  
  FOR EACH MATE:
    DELETE MATE.
  END.
  
  FOR EACH Almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia
        AND Almmmate.codalm = x-codalm,
        FIRST Almmmatg OF Almmmate NO-LOCK WHERE Almmmatg.codpr1 = x-codpro:
    DISPLAY 
        'CODIGO:' Almmmate.codmat SKIP(1)
        WITH FRAME F-Mensaje VIEW-AS DIALOG-BOX CENTERED OVERLAY NO-LABELS
            TITLE 'Procesando Informacion'.
    {lgc/calc_stk_min.i}
    
/*    ASSIGN
 *         x-VtaEva = 0
 *         x-VtaHis = 0
 *         x-HisPro = 0.
 *     /* Salidas por Ventas Periodo a Evaluar */
 *     FOR EACH Almdmov USE-INDEX almd03 NO-LOCK WHERE Almdmov.codcia = s-codcia
 *             AND Almdmov.codalm = Almmmate.codalm
 *             AND Almdmov.codmat = Almmmate.codmat
 *             AND Almdmov.tipmov = 'S'
 *             AND Almdmov.codmov = 02
 *             AND Almdmov.fchdoc >= x-fchdoc-1
 *             AND Almdmov.fchdoc <= x-fchdoc-2:
 *         x-VtaEva = x-VtaEva + (Almdmov.candes * Almdmov.factor).
 *     END.            
 *     /* Salidas por Ventas Periodo Historico */
 *     FOR EACH Almdmov USE-INDEX almd03 NO-LOCK WHERE Almdmov.codcia = s-codcia
 *             AND Almdmov.codalm = Almmmate.codalm
 *             AND Almdmov.codmat = Almmmate.codmat
 *             AND Almdmov.tipmov = 'S'
 *             AND Almdmov.codmov = 02
 *             AND Almdmov.fchdoc >= x-fchdoc-3
 *             AND Almdmov.fchdoc <= x-fchdoc-4:
 *         x-VtaHis = x-VtaHis + (Almdmov.candes * Almdmov.factor).
 *     END.            
 *     /* Salidas por Ventas Historico Proyectadas*/
 *     FOR EACH Almdmov USE-INDEX almd03 NO-LOCK WHERE Almdmov.codcia = s-codcia
 *             AND Almdmov.codalm = Almmmate.codalm
 *             AND Almdmov.codmat = Almmmate.codmat
 *             AND Almdmov.tipmov = 'S'
 *             AND Almdmov.codmov = 02
 *             AND Almdmov.fchdoc >= x-fchdoc-5
 *             AND Almdmov.fchdoc <= x-fchdoc-6:
 *         x-HisPro = x-HisPro + (Almdmov.candes * Almdmov.factor).
 *     END.            
 *     /* Factor */
 *     IF x-VtaHis = 0 
 *     THEN x-Factor = 1.
 *     ELSE x-Factor = x-VtaEva / x-VtaHis.
 *     /* Proyeccion de Ventas */
 *     x-ProVta = x-HisPro * x-Factor.
 *     /* Stock Minimo */
 *     x-StkMin = ROUND(x-ProVta / x-Dias * (x-Entrega + x-Tramites), 0).*/

    CREATE MATE.
    BUFFER-COPY Almmmate TO MATE
        ASSIGN
            MATE.StkMin = x-StkMin.
  END.
  HIDE FRAME F-Mensaje.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  DISPLAY x-NomAlm x-CodAlm x-CodPro x-NomPro x-FchDoc-1 x-FchDoc-2 x-FchDoc-3 
          x-FchDoc-4 x-Dias x-FchDoc-5 x-FchDoc-6 x-Entrega x-Tramites 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-CodAlm x-CodPro x-FchDoc-1 x-FchDoc-2 x-Dias x-Entrega x-Tramites 
         BROWSE-1 BUTTON-3 Btn_Done 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Stock-Minimo W-Win 
PROCEDURE Graba-Stock-Minimo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  MESSAGE 'Procedemos a la actualización del Stock Mínimo?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN ERROR.
  
  FOR EACH MATE, FIRST Almmmate OF MATE:
    DISPLAY 'Procesando' MATE.codmat WITH FRAME F-Mensaje VIEW-AS DIALOG-BOX
        CENTERED OVERLAY NO-LABELS.
    Almmmate.StkMin = MATE.StkMin.
    DELETE MATE.
  END.
  HIDE FRAME F-Mensaje.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  
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
  ASSIGN
    x-FchDoc-1 = TODAY - DAY(TODAY) + 1
    x-FchDoc-2 = TODAY.
/*  FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia:
 *     x-CodAlm:ADD-LAST(Almacen.codalm) IN FRAME {&FRAME-NAME}.
 *   END.*/
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Carga-Campos.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "MATE"}
  {src/adm/template/snd-list.i "Almmmatg"}

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
  FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = x-CodAlm
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almacen THEN DO:
    MESSAGE 'Almacen no registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  FIND Gn-prov WHERE Gn-prov.codcia = pr-codcia
    AND gn-prov.codpro = x-CodPro
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Gn-prov THEN DO:
    MESSAGE 'Proveedor no registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  IF x-Dias = 0 THEN DO:
    MESSAGE 'Ingrese los dias a proyectar' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  IF x-Entrega = 0 THEN DO:
    MESSAGE 'Ingrese el Tiempo de Entrega' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


