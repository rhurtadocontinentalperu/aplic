&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE        VAR C-OP     AS CHAR.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE        VAR F-PESALM AS DECIMAL NO-UNDO.

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
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

/*******/
/*DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.*/

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE T-TITULO AS CHAR INIT "".
DEFINE VARIABLE T-TITUL1 AS CHAR INIT "".
DEFINE VARIABLE T-FAMILI AS CHAR INIT "".
DEFINE VARIABLE T-SUBFAM AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-DESMAR AS CHAR INIT "".
DEFINE VARIABLE X-DESFAM AS CHAR INIT "".
DEFINE VARIABLE X-DESSUB AS CHAR INIT "".
DEFINE VARIABLE X-CATCON AS CHAR INIT "".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-61 Btn_OK f-almacen l-catego C-Orden ~
C-Sortea Btn_Cancel R-Tipo 
&Scoped-Define DISPLAYED-OBJECTS f-almacen l-catego C-Orden C-Sortea R-Tipo 

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

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE C-Orden AS CHARACTER FORMAT "X(256)":U INITIAL "Codigo" 
     LABEL "Orden" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Codigo","Descripcion" 
     SIZE 13.29 BY 1 NO-UNDO.

DEFINE VARIABLE C-Sortea AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Tipo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Con-Stock","Sin-Stock" 
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE f-almacen AS CHARACTER FORMAT "X(3)":U 
     LABEL "Almacén" 
     VIEW-AS FILL-IN 
     SIZE 13.43 BY .81 NO-UNDO.

DEFINE VARIABLE l-catego AS CHARACTER FORMAT "X(2)":U 
     LABEL "Categ.Contable" 
     VIEW-AS FILL-IN 
     SIZE 13.43 BY .81 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Activados", "A",
"Desactivados", "D",
"Ambos", ""
     SIZE 12.14 BY 1.73 NO-UNDO.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 13.43 BY 3.23.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn_OK AT ROW 6.58 COL 8.57
     f-almacen AT ROW 1.5 COL 11.57 COLON-ALIGNED
     l-catego AT ROW 2.54 COL 11.72 COLON-ALIGNED
     C-Orden AT ROW 3.69 COL 11.86 COLON-ALIGNED
     C-Sortea AT ROW 4.85 COL 12 COLON-ALIGNED
     Btn_Cancel AT ROW 6.58 COL 27.57
     R-Tipo AT ROW 2.77 COL 32.86 NO-LABEL
     RECT-61 AT ROW 1.5 COL 32.29
     "Estado" VIEW-AS TEXT
          SIZE 6.86 BY .69 AT ROW 1.65 COL 33.14
          FONT 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 46.86 BY 7.42
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Articulos x Categoria Contable"
         HEIGHT             = 7.54
         WIDTH              = 46.86
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT W-Win:LOAD-ICON("img\climnu3":U) THEN
    MESSAGE "Unable to load icon: img\climnu3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Articulos x Categoria Contable */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Articulos x Categoria Contable */
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


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-almacen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-almacen W-Win
ON LEAVE OF f-almacen IN FRAME F-Main /* Almacén */
DO:
  ASSIGN F-ALMACEN.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables W-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN  C-Sortea L-CATEGO R-Tipo C-Orden.
END.
 
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
  DISPLAY f-almacen l-catego C-Orden C-Sortea R-Tipo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-61 Btn_OK f-almacen l-catego C-Orden C-Sortea Btn_Cancel R-Tipo 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
CASE C-SORTEA :
     WHEN "Todos"  THEN DO: 
          T-TITULO = "  ARTICULOS X CATEGORIA CONTABLE".
          RUN Formato-Todos.
     END.  
     WHEN "Con-Stock" THEN DO:    
          T-TITULO = " ARTICULOS CON STOCKS X CATEGORIA CONTABLE".
          RUN Formato-Con.
     END.     
     WHEN "Sin-Stock" THEN DO: 
          T-TITULO = "ARTICULOS SIN STOCKS X CATEGORIA CONTABLE".
          RUN Formato-Sin.
     END.    
END CASE.           
  
HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FORMATO-CON W-Win 
PROCEDURE FORMATO-CON :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE FRAME F-REPORTE
        Almmmate.CodMat    AT 2   FORMAT "X(6)"
        Almmmatg.DesMat    AT 10  FORMAT "X(50)"
        Almmmatg.DesMar    AT 61  FORMAT "X(15)"
        Almmmatg.UndBas    AT 78  FORMAT "X(4)"
        Almmmate.FacEqu    AT 84  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    AT 100 FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    AT 119 FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    AT 134 FORMAT "->,>>>,>>9.99"
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + F-ALMACEN + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        " CODIGO                                                                          F A C T O R                S    T    O    C    K    S           " SKIP
        "ARTICULO  D E S C R I P C I O N                            MARCA       UNIDAD    EQUIVALENCIA     A C T U A L       M I N I M O     M A X I M O  " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = F-ALMACEN AND
                         Almmmate.StkAct <> 0 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.Catcon[1]
           BY Almmmatg.Desmat: 

     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
     IF Almmmatg.Catcon[1] BEGINS l-catego THEN DO:

     VIEW STREAM REPORT FRAME F-HEADER.
     
      /***********  X Categoria  ***********/
      X-CATCON = "".
      IF FIRST-OF(Almmmatg.Catcon[1]) THEN DO:
       FIND FIRST Almtabla WHERE Almtabla.Tabla  = "CC"
                             AND Almtabla.Codigo = Almmmatg.Catcon[1]
                             NO-LOCK NO-ERROR.
         IF AVAILABLE AlmTabla THEN X-CATCON = AlmTabla.Nombre.                    
         DISPLAY STREAM REPORT
         Almmmatg.Catcon[1] + " - " + CAPS(AlmTabla.nombre) @ Almmmatg.desmat WITH FRAME F-REPORTE.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.     
     DISPLAY STREAM REPORT
        Almmmate.CodMat
        Almmmatg.Desmat
        Almmmatg.Desmar
        Almmmatg.UndBas
        Almmmate.FacEqu  WHEN Almmmate.FacEqu > 0
        Almmmate.StkAct
        Almmmate.StkMin
        Almmmate.StkMax
        WITH FRAME F-REPORTE.
     
     IF LAST-OF(Almmmatg.Catcon[1]) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.

 END.
 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FORMATO-SIN W-Win 
PROCEDURE FORMATO-SIN :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE FRAME F-REPORTE
        Almmmate.CodMat    AT 2   FORMAT "X(6)"
        Almmmatg.DesMat    AT 10  FORMAT "X(50)"
        Almmmatg.DesMar    AT 61  FORMAT "X(15)"
        Almmmatg.UndBas    AT 78  FORMAT "X(4)"
        Almmmate.FacEqu    AT 84  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    AT 100 FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    AT 119 FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    AT 134 FORMAT "->,>>>,>>9.99"
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + F-ALMACEN + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        " CODIGO                                                                          F A C T O R                S    T    O    C    K    S           " SKIP
        "ARTICULO  D E S C R I P C I O N                            MARCA       UNIDAD    EQUIVALENCIA     A C T U A L       M I N I M O     M A X I M O  " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = F-ALMACEN AND
                         Almmmate.StkAct = 0 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.TpoArt BEGINS R-Tipo NO-LOCK
     BREAK BY Almmmatg.Catcon[1]
           BY Almmmatg.Desmat: 

     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
    IF Almmmatg.Catcon[1] BEGINS l-catego THEN DO:

     VIEW STREAM REPORT FRAME F-HEADER.
     
      /***********  X Categoria  ***********/
      X-CATCON = "".
      IF FIRST-OF(Almmmatg.Catcon[1]) THEN DO:
       FIND FIRST Almtabla WHERE Almtabla.Tabla  = "CC"
                             AND Almtabla.Codigo = Almmmatg.Catcon[1]
                             NO-LOCK NO-ERROR.
         IF AVAILABLE AlmTabla THEN X-CATCON = AlmTabla.Nombre.                    
         DISPLAY STREAM REPORT
         Almmmatg.Catcon[1] + " - " + CAPS(AlmTabla.nombre) @ Almmmatg.desmat WITH FRAME F-REPORTE.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.     
     DISPLAY STREAM REPORT
        Almmmate.CodMat
        Almmmatg.Desmat
        Almmmatg.Desmar
        Almmmatg.UndBas
        Almmmate.FacEqu  WHEN Almmmate.FacEqu > 0
        Almmmate.StkAct
        Almmmate.StkMin
        Almmmate.StkMax
        WITH FRAME F-REPORTE.
     
     IF LAST-OF(Almmmatg.Catcon[1]) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.

 END.
 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FORMATO-TODOS W-Win 
PROCEDURE FORMATO-TODOS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE FRAME F-REPORTE
        Almmmate.CodMat    AT 2   FORMAT "X(6)"
        Almmmatg.DesMat    AT 10  FORMAT "X(50)"
        Almmmatg.DesMar    AT 61  FORMAT "X(15)"
        Almmmatg.UndBas    AT 78  FORMAT "X(4)"
        Almmmate.FacEqu    AT 84  FORMAT "->,>>>,>>9.99"
        Almmmate.StkAct    AT 100 FORMAT "->,>>>,>>9.99"
        Almmmate.StkMin    AT 119 FORMAT "->,>>>,>>9.99"
        Almmmate.StkMax    AT 134 FORMAT "->,>>>,>>9.99"
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
 
 DEFINE FRAME F-HEADER       
        HEADER
        S-NOMCIA FORMAT "X(45)" 
        "Pag.  : " AT 135 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "( " + F-ALMACEN + " )" AT 3 FORMAT "X(20)"  
        T-TITULO   AT 54 FORMAT "X(45)" 
        "Fecha : " AT 135 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "Hora  : " AT 135 STRING(TIME,"HH:MM:SS") SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        " CODIGO                                                                          F A C T O R                S    T    O    C    K    S           " SKIP
        "ARTICULO  D E S C R I P C I O N                            MARCA       UNIDAD    EQUIVALENCIA     A C T U A L       M I N I M O     M A X I M O  " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------" SKIP        
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                         Almmmate.CodAlm = F-ALMACEN 
                         NO-LOCK,
     EACH Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND 
                         Almmmatg.Codmat = Almmmate.codmat AND 
                         Almmmatg.TpoArt    BEGINS R-Tipo   NO-LOCK
     BREAK BY Almmmatg.Catcon[1]
           BY Almmmatg.Desmat: 

     DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
            
     IF Almmmatg.Catcon[1] BEGINS l-catego THEN DO:
     
     VIEW STREAM REPORT FRAME F-HEADER.
     
      /***********  X Categoria  ***********/
      X-CATCON = "".
      IF FIRST-OF(Almmmatg.Catcon[1]) THEN DO:
       FIND FIRST Almtabla WHERE Almtabla.Tabla  = "CC"
                             AND Almtabla.Codigo = Almmmatg.Catcon[1]
                             NO-LOCK NO-ERROR.
         IF AVAILABLE AlmTabla THEN X-CATCON = AlmTabla.Nombre.                    
         DISPLAY STREAM REPORT
         Almmmatg.Catcon[1] + " - " + CAPS(AlmTabla.nombre) @ Almmmatg.desmat WITH FRAME F-REPORTE.
         DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
      END.     
     DISPLAY STREAM REPORT
        Almmmate.CodMat
        Almmmatg.Desmat
        Almmmatg.Desmar
        Almmmatg.UndBas
        Almmmate.FacEqu  WHEN Almmmate.FacEqu > 0
        Almmmate.StkAct
        Almmmate.StkMin
        Almmmate.StkMax
        WITH FRAME F-REPORTE.
     
     IF LAST-OF(Almmmatg.Catcon[1]) THEN DO:
       DOWN STREAM REPORT 1 WITH FRAME F-REPORTE.
     END.

 END.
 END.
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
    ENABLE ALL EXCEPT .
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime W-Win 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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
  ASSIGN  L-CATEGO C-Sortea R-Tipo  C-orden.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /*Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "l-catego" THEN input-var-1 = "CC".
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
PROCEDURE recoge-parametros :
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
   
        WHEN "l-catego" THEN input-var-1 = "CC".

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


