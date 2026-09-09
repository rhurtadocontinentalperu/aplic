&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-tabla NO-UNDO LIKE almtabla.



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
DEFINE BUFFER T-MATE FOR Almmmate.

/*******/
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.

/* Local Variable Definitions ---                                       */
DEFINE VAR F-Ingreso AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-PreIng  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-TotIng  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-Salida  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-PreSal  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-TotSal  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-Saldo   AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-VALCTO  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-STKGEN  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-PRECIO  AS DECIMAL FORMAT "(>>>,>>9.99)" NO-UNDO.
DEFINE VAR S-SUBTIT  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VAR F-SPeso   AS DECIMAL FORMAT "(>,>>>,>>9.99)" NO-UNDO.

DEFINE BUFFER DMOV FOR Almdmov. 

DEFINE VAR I-NROITM  AS INTEGER.

DEFINE TEMP-TABLE  tmp-report LIKE w-report.


DEFINE VAR T-Ingreso AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.
DEFINE VAR T-Salida  AS DECIMAL FORMAT "(>>,>>>,>>9.99)" NO-UNDO.


DEFINE VARIABLE F-PREUSSA AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUSSB AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUSSC AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUSSD AS DECIMAL NO-UNDO.

DEFINE VARIABLE F-PRESOLA AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRESOLB AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRESOLC AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PRESOLD AS DECIMAL NO-UNDO.

DEFINE VARIABLE mensaje AS CHARACTER.

DEFINE VARIABLE f-Categorias AS CHAR.       /* Para la seleccion de rotacion */

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
&Scoped-define INTERNAL-TABLES t-tabla

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 t-tabla.Codigo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH t-tabla NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH t-tabla NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 t-tabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 t-tabla


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS F-CodFam F-SubFam F-prov1 DesdeC HastaC ~
nCodMon R-Tipo BROWSE-1 Btn_OK Btn_Cancel Btn_Help RECT-57 
&Scoped-Define DISPLAYED-OBJECTS F-CodFam F-DesFam F-SubFam F-DesSub ~
F-prov1 DesdeC HastaC nCodMon R-Tipo 

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

DEFINE BUTTON Btn_Help 
     IMAGE-UP FILE "img\b-ayuda":U
     LABEL "A&yuda" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.14 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.14 BY .69 NO-UNDO.

DEFINE VARIABLE F-prov1 AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-SubFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Sub-linea" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .69 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(6)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2,
"Ambos", 3
     SIZE 25.86 BY .46 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Activados", "A",
"Desactivados", "D",
"Ambos", ""
     SIZE 12.72 BY 1.73 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.54
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.86 BY 10.31.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      t-tabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 DISPLAY
      t-tabla.Codigo FORMAT "x(4)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-LABELS NO-ROW-MARKERS MULTIPLE SIZE 8 BY 2.88
         FONT 4 TOOLTIP "Seleccione las categorias que desee".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-CodFam AT ROW 1.85 COL 18 COLON-ALIGNED
     F-DesFam AT ROW 1.85 COL 24.29 COLON-ALIGNED NO-LABEL
     F-SubFam AT ROW 2.62 COL 18 COLON-ALIGNED
     F-DesSub AT ROW 2.62 COL 24.29 COLON-ALIGNED NO-LABEL
     F-prov1 AT ROW 3.35 COL 18.14 COLON-ALIGNED
     DesdeC AT ROW 4.12 COL 18 COLON-ALIGNED
     HastaC AT ROW 4.12 COL 47 COLON-ALIGNED
     nCodMon AT ROW 5.08 COL 19.72 NO-LABEL
     R-Tipo AT ROW 5.88 COL 19.72 NO-LABEL
     BROWSE-1 AT ROW 7.73 COL 20
     Btn_OK AT ROW 11.69 COL 46.29
     Btn_Cancel AT ROW 11.69 COL 57.57
     Btn_Help AT ROW 11.69 COL 69
     "Rotacion:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 7.92 COL 12
     "Moneda" VIEW-AS TEXT
          SIZE 6.86 BY .58 AT ROW 5.04 COL 12
          FONT 6
     "Criterio de Selección" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1.19 COL 3
          FONT 6
     "Estado" VIEW-AS TEXT
          SIZE 6.86 BY .69 AT ROW 5.96 COL 12
          FONT 1
     "Todos los materiales si no selecciona ninguna rotacion" VIEW-AS TEXT
          SIZE 38 BY .5 AT ROW 10.81 COL 20
     RECT-46 AT ROW 11.58 COL 1
     RECT-57 AT ROW 1.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 12.23
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-tabla T "?" NO-UNDO INTEGRAL almtabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Catalogo de Precios"
         HEIGHT             = 12.23
         WIDTH              = 80
         MAX-HEIGHT         = 12.23
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 12.23
         VIRTUAL-WIDTH      = 80
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-1 R-Tipo F-Main */
/* SETTINGS FOR FILL-IN F-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesSub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.t-tabla"
     _FldNameList[1]   > Temp-Tables.t-tabla.Codigo
"t-tabla.Codigo" ? "x(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Catalogo de Precios */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Catalogo de Precios */
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


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help W-Win
ON CHOOSE OF Btn_Help IN FRAME F-Main /* Ayuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
MESSAGE "Help for File: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
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


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC W-Win
ON LEAVE OF DesdeC IN FRAME F-Main /* Articulo */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
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


&Scoped-define SELF-NAME F-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodFam W-Win
ON LEAVE OF F-CodFam IN FRAME F-Main /* Linea */
DO:
   ASSIGN F-CodFam.
   FIND Almtfami WHERE Almtfami.CodCia = S-CODCIA 
                  AND  Almtfami.codfam = F-CodFam 
                 NO-LOCK NO-ERROR.
   IF AVAILABLE Almtfami THEN 
      DISPLAY Almtfami.desfam @ F-DesFam WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-SubFam W-Win
ON LEAVE OF F-SubFam IN FRAME F-Main /* Sub-linea */
DO:
   ASSIGN F-CodFam.
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   IF F-CodFam = "" THEN DO:
      SELF:SCREEN-VALUE = "".
      RETURN.
   END.
   FIND AlmSFami WHERE AlmSFami.CodCia = S-CODCIA 
                  AND  AlmSFami.codfam = F-CodFam 
                  AND  AlmSFami.subfam = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF AVAILABLE AlmSFami THEN DO:
      DISPLAY AlmSFami.dessub @ F-DesSub WITH FRAME {&FRAME-NAME}.
   END.
   ELSE DO:
      MESSAGE "Codigo de Sub-Familia no Existe" VIEW-AS ALERT-BOX ERROR.
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
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
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


&Scoped-define BROWSE-NAME BROWSE-1
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
  ASSIGN DesdeC F-CodFam F-SubFam F-DesFam HastaC nCodMon R-Tipo F-prov1 .

  IF HastaC <> "" THEN 
    S-SUBTIT = "Materiales del " + DesdeC + " al " + HastaC .
  ELSE
    S-SUBTIT = "".

  IF HastaC = "" THEN HastaC = "999999999".
/*    
  S-SUBTIT = "Periodo del " + STRING(DesdeF) + " al " + STRING(HastaF).
*/

  IF HastaC = "" THEN HastaC = "999999".
/*  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000.*/

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
  DISPLAY F-CodFam F-DesFam F-SubFam F-DesSub F-prov1 DesdeC HastaC nCodMon 
          R-Tipo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE F-CodFam F-SubFam F-prov1 DesdeC HastaC nCodMon R-Tipo BROWSE-1 Btn_OK 
         Btn_Cancel Btn_Help RECT-57 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-1 W-Win 
PROCEDURE Formato-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE1
               Almmmatg.codmat  FORMAT "X(6)"
               Almmmatg.DesMat  FORMAT "X(40)"
               Almmmatg.TipArt  FORMAT "X(1)"
               Almmmatg.DesMar  FORMAT "X(10)"
               Almmmatg.UndBas  FORMAT "X(8)"
               Almmmatg.MonVta  FORMAT "9"
               F-PRESOLA        FORMAT ">>>,>>9.9999"
               Almmmatg.UndA    FORMAT "X(8)"
               F-PRESOLB        FORMAT ">>>,>>9.9999"
               Almmmatg.UndB    FORMAT "X(8)"
               F-PRESOLC        FORMAT ">>>,>>9.9999"
               Almmmatg.UndC    FORMAT "X(8)"
               F-PRESOLD        FORMAT ">>>,>>9.9999"
               Almmmatg.Chr__01 FORMAT "X(8)"
              WITH WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         /*{&Prn2} + {&Prn7A} + {&Prn6A} +*/ S-NOMCIA /*+ {&Prn7B} + {&Prn6A} + {&Prn3}*/ FORMAT "X(50)" AT 1 SKIP
         "LISTADO DE PRECIOS" AT 62
         "Pagina :" TO 125 PAGE-NUMBER(REPORT) TO 137 FORMAT "ZZZZZ9" SKIP
         "Fecha  :" TO 125 TODAY TO 137 FORMAT "99/99/9999" SKIP
         "Hora   :" TO 125 STRING(TIME,"HH:MM") TO 137 SKIP
         mensaje FORMAT "X(28)" SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                          PREC. VTA. (A)        PREC. VTA. (B)         PREC. VTA. (C)      PREC. VTA. OFIC." SKIP
        "Codigo D  E  S  C  R  I  P  C  I  O  N          R MARCA      U.B.  MONEDA        S/. UM.              S/.  UM.              S/.   UM.             S/.  UM. " SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        
      WITH PAGE-TOP WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.Codcia = S-CODCIA  
                            AND  Almmmatg.codfam BEGINS F-CodFam 
                            AND  Almmmatg.subfam BEGINS F-SubFam 
                            AND  (Almmmatg.CodMat >= DesdeC  
                            AND   Almmmatg.CodMat <= HastaC)
                           AND  Almmmatg.CodPr1 BEGINS F-prov1
                            AND  Almmmatg.TpoArt BEGINS R-Tipo
                            AND ( f-Categorias = 'Todas' OR LOOKUP(TRIM(Almmmatg.TipArt), f-Categorias) > 0 )
                            BREAK BY Almmmatg.CodFam
                                    BY Almmmatg.SubFam
                                    BY Almmmatg.CodMar
                                    BY Almmmatg.TipArt
                                    BY Almmmatg.CodMat:
      DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(Almmmatg.CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = Almmmatg.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT "FAMILIA : " Almtfami.codfam '    ' Almtfami.desfam SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
      IF FIRST-OF(Almmmatg.SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = s-CodCia 
                        AND  Almsfami.codfam = Almmmatg.CodFam 
                        AND  Almsfami.subfam = Almmmatg.Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             PUT STREAM REPORT "SUB-FAMILIA : " Almsfami.subfam '   ' AlmSFami.dessub SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
  IF Almmmatg.MonVta = 1 THEN DO:
    F-PRESOLA = Almmmatg.Prevta[2].
    F-PRESOLB = Almmmatg.Prevta[3].
    F-PRESOLC = Almmmatg.Prevta[4].
    F-PRESOLD = Almmmatg.PreAlt[4].

    F-PREUSSA = Almmmatg.Prevta[2] / Almmmatg.TpoCmb.
    F-PREUSSB = Almmmatg.Prevta[3] / Almmmatg.TpoCmb.
    F-PREUSSC = Almmmatg.Prevta[4] / Almmmatg.TpoCmb.
    F-PREUSSD = Almmmatg.PreAlt[4] / Almmmatg.TpoCmb.
  END.
  ELSE DO:
    F-PREUSSA = Almmmatg.Prevta[2].
    F-PREUSSB = Almmmatg.Prevta[3].
    F-PREUSSC = Almmmatg.Prevta[4].
    F-PREUSSD = Almmmatg.PreAlt[4].

    F-PRESOLA = Almmmatg.Prevta[2] * Almmmatg.TpoCmb.
    F-PRESOLB = Almmmatg.Prevta[3] * Almmmatg.TpoCmb.
    F-PRESOLC = Almmmatg.Prevta[4] * Almmmatg.TpoCmb.
    F-PRESOLD = Almmmatg.PreAlt[4] * Almmmatg.TpoCmb.
  END.
         
      DISPLAY STREAM REPORT 
               Almmmatg.codmat
               Almmmatg.DesMat
               Almmmatg.TipArt
               Almmmatg.DesMar
               Almmmatg.UndBas
               Almmmatg.MonVta
               F-PRESOLA    WHEN F-PRESOLA <> 0
               Almmmatg.UndA    WHEN Almmmatg.UndA <> ""
               F-PRESOLB    WHEN F-PRESOLB <> 0 
               Almmmatg.UndB    WHEN Almmmatg.UndB <> "" 
               F-PRESOLC    WHEN F-PRESOLC <> 0
               Almmmatg.UndC    WHEN Almmmatg.UndC <> ""
               F-PRESOLD    WHEN F-PRESOLD <> 0
               Almmmatg.Chr__01 WHEN Almmmatg.Chr__01 <> ""
               WITH FRAME F-REPORTE1.
      DOWN STREAM REPORT WITH FRAME F-REPORTE1.
       
  END.
  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-2 W-Win 
PROCEDURE Formato-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-REPORTE2
               Almmmatg.codmat  FORMAT "X(6)"
               Almmmatg.DesMat  FORMAT "X(40)"
               Almmmatg.TipArt  FORMAT "X(1)"
               Almmmatg.DesMar  FORMAT "X(10)"
               Almmmatg.UndBas  FORMAT "X(8)"
               Almmmatg.MonVta  FORMAT "9"
               F-PREUSSA        FORMAT ">>>,>>9.9999"
               Almmmatg.UndA    FORMAT "X(8)"
               F-PREUSSB        FORMAT ">>>,>>9.9999"
               Almmmatg.UndB    FORMAT "X(8)"
               F-PREUSSC        FORMAT ">>>,>>9.9999"
               Almmmatg.UndC    FORMAT "X(8)"
               F-PREUSSD        FORMAT ">>>,>>9.9999"
               Almmmatg.Chr__01 FORMAT "X(8)"
              WITH WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         /*{&Prn2} + {&Prn7A} + {&Prn6A} +*/ S-NOMCIA /*+ {&Prn7B} + {&Prn6A} + {&Prn3}*/ FORMAT "X(50)" AT 1 SKIP
         "LISTADO DE PRECIOS" AT 62
         "Pagina :" TO 125 PAGE-NUMBER(REPORT) TO 137 FORMAT "ZZZZZ9" SKIP
         "Fecha  :" TO 125 TODAY TO 137 FORMAT "99/99/9999" SKIP
         "Hora   :" TO 125 STRING(TIME,"HH:MM") TO 137 SKIP
         mensaje FORMAT "X(28)" SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                          PREC. VTA. (A)        PREC. VTA. (B)         PREC. VTA. (C)      PREC. VTA. OFIC." SKIP
        "Codigo D  E  S  C  R  I  P  C  I  O  N          R MARCA      U.B.  MONEDA       USS. UM.             USS.  UM.             USS.   UM.            USS.  UM. " SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
      WITH PAGE-TOP WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.Codcia = S-CODCIA  
                            AND  Almmmatg.codfam BEGINS F-CodFam 
                            AND  Almmmatg.subfam BEGINS F-SubFam 
                            AND  (Almmmatg.CodMat >= DesdeC  
                            AND   Almmmatg.CodMat <= HastaC)
                           AND  Almmmatg.CodPr1 BEGINS F-prov1
                            AND  Almmmatg.TpoArt BEGINS R-Tipo
                            AND ( f-Categorias = 'Todas' OR LOOKUP(TRIM(Almmmatg.TipArt), f-Categorias) > 0 )
                            BREAK BY Almmmatg.CodFam
                                    BY Almmmatg.SubFam
                                    BY Almmmatg.CodMar
                                    BY Almmmatg.TipArt
                                    BY Almmmatg.CodMat:
      DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(Almmmatg.CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = Almmmatg.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT "FAMILIA : " Almtfami.codfam '    ' Almtfami.desfam SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
      IF FIRST-OF(Almmmatg.SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = s-CodCia 
                        AND  Almsfami.codfam = Almmmatg.CodFam 
                        AND  Almsfami.subfam = Almmmatg.Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             PUT STREAM REPORT "SUB-FAMILIA : " Almsfami.subfam '   ' AlmSFami.dessub SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
  IF Almmmatg.MonVta = 1 THEN DO:
    F-PRESOLA = Almmmatg.Prevta[2].
    F-PRESOLB = Almmmatg.Prevta[3].
    F-PRESOLC = Almmmatg.Prevta[4].
    F-PRESOLD = Almmmatg.PreAlt[4].

    F-PREUSSA = Almmmatg.Prevta[2] / Almmmatg.TpoCmb.
    F-PREUSSB = Almmmatg.Prevta[3] / Almmmatg.TpoCmb.
    F-PREUSSC = Almmmatg.Prevta[4] / Almmmatg.TpoCmb.
    F-PREUSSD = Almmmatg.PreAlt[4] / Almmmatg.TpoCmb.
  END.
  ELSE DO:
    F-PREUSSA = Almmmatg.Prevta[2].
    F-PREUSSB = Almmmatg.Prevta[3].
    F-PREUSSC = Almmmatg.Prevta[4].
    F-PREUSSD = Almmmatg.PreAlt[4].

    F-PRESOLA = Almmmatg.Prevta[2] * Almmmatg.TpoCmb.
    F-PRESOLB = Almmmatg.Prevta[3] * Almmmatg.TpoCmb.
    F-PRESOLC = Almmmatg.Prevta[4] * Almmmatg.TpoCmb.
    F-PRESOLD = Almmmatg.PreAlt[4] * Almmmatg.TpoCmb.
  END.
         
      DISPLAY STREAM REPORT 
               Almmmatg.codmat
               Almmmatg.DesMat
               Almmmatg.TipArt
               Almmmatg.DesMar
               Almmmatg.UndBas
               Almmmatg.MonVta
               F-PREUSSA    WHEN F-PREUSSA <> 0
               Almmmatg.UndA    WHEN Almmmatg.UndA <> ""
               F-PREUSSB    WHEN F-PREUSSB <> 0
               Almmmatg.UndB    WHEN Almmmatg.UndB <> "" 
               F-PREUSSC    WHEN F-PREUSSC <> 0
               Almmmatg.UndC    WHEN Almmmatg.UndC <> ""
               F-PREUSSD    WHEN F-PREUSSD <> 0
               Almmmatg.Chr__01 WHEN Almmmatg.Chr__01 <> ""
               WITH FRAME F-REPORTE2.
      DOWN STREAM REPORT WITH FRAME F-REPORTE2.
       
  END.
  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-3 W-Win 
PROCEDURE Formato-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE FRAME F-REPORTE
               Almmmatg.codmat  FORMAT "X(6)"
               Almmmatg.DesMat  FORMAT "X(40)"
               Almmmatg.TipArt  FORMAT "X(1)"
               Almmmatg.DesMar  FORMAT "X(10)"
               Almmmatg.UndBas  FORMAT "X(8)"
               Almmmatg.MonVta  FORMAT "9"
               F-PRESOLA        FORMAT ">>>,>>9.9999"
               F-PREUSSA        FORMAT ">>>,>>9.9999"
               Almmmatg.UndA    FORMAT "X(8)"
               F-PRESOLB        FORMAT ">>>,>>9.9999"
               F-PREUSSB        FORMAT ">>>,>>9.9999"
               Almmmatg.UndB    FORMAT "X(8)"
               F-PRESOLC        FORMAT ">>>,>>9.9999"
               F-PREUSSC        FORMAT ">>>,>>9.9999"
               Almmmatg.UndC    FORMAT "X(8)"
               F-PRESOLD        FORMAT ">>>,>>9.9999"
               F-PREUSSD        FORMAT ">>>,>>9.9999"
               Almmmatg.Chr__01 FORMAT "X(8)"
              WITH WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
         HEADER
         /*{&Prn2} + {&Prn7A} + {&Prn6A} +*/ S-NOMCIA /*+ {&Prn7B} + {&Prn6A} + {&Prn3}*/ FORMAT "X(50)" AT 1 SKIP
         "LISTADO DE PRECIOS" AT 62
         "Pagina :" TO 125 PAGE-NUMBER(REPORT) TO 137 FORMAT "ZZZZZ9" SKIP
         S-DESALM  FORMAT "X(30)" AT 56
         "Fecha  :" TO 125 TODAY TO 137 FORMAT "99/99/9999" SKIP
         "Hora   :" TO 125 STRING(TIME,"HH:MM") TO 137 SKIP
         mensaje FORMAT "X(28)" SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                 PRECIO DE VTA. (A)                PRECIO DE VTA. (B)                 PRECIO DE VTA. (C)                 PRECIO DE VTA. OFICINA" SKIP
        "Codigo D  E  S  C  R  I  P  C  I  O  N          R MARCA      U.B.  MONEDA        S/.        USS$. UM.              S/.         USS$. UM.              S/.         USS$.  UM.             S/.          US$.  UM." SKIP
        "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
      WITH PAGE-TOP WIDTH 255 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

 FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.Codcia = S-CODCIA  
                            AND  Almmmatg.codfam BEGINS F-CodFam 
                            AND  Almmmatg.subfam BEGINS F-SubFam 
                            AND  (Almmmatg.CodMat >= DesdeC  
                            AND   Almmmatg.CodMat <= HastaC)
                            AND  Almmmatg.CodPr1 BEGINS F-prov1
                            AND  Almmmatg.TpoArt BEGINS R-Tipo
                            AND ( f-Categorias = 'Todas' OR LOOKUP(TRIM(Almmmatg.TipArt), f-Categorias) > 0 )
                            BREAK BY Almmmatg.CodFam
                                    BY Almmmatg.SubFam
                                    BY Almmmatg.CodMar
                                    BY Almmmatg.TipArt
                                    BY Almmmatg.CodMat:
      DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" WITH FRAME F-Proceso.

      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(Almmmatg.CodFam) THEN DO:
         FIND Almtfami WHERE Almtfami.CodCia = s-CodCia 
                        AND  Almtfami.codfam = Almmmatg.CodFam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtfami THEN DO:
             PUT STREAM REPORT "FAMILIA : " Almtfami.codfam '    ' Almtfami.desfam SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
      IF FIRST-OF(Almmmatg.SubFam) THEN DO:
         FIND Almsfami WHERE Almsfami.CodCia = s-CodCia 
                        AND  Almsfami.codfam = Almmmatg.CodFam 
                        AND  Almsfami.subfam = Almmmatg.Subfam 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almsfami THEN DO:
             PUT STREAM REPORT "SUB-FAMILIA : " Almsfami.subfam '   ' AlmSFami.dessub SKIP.
             PUT STREAM REPORT '      ------------------------------------------' SKIP.
         END.
      END.
  IF Almmmatg.MonVta = 1 THEN DO:
    F-PRESOLA = Almmmatg.Prevta[2].
    F-PRESOLB = Almmmatg.Prevta[3].
    F-PRESOLC = Almmmatg.Prevta[4].
    F-PRESOLD = Almmmatg.PreAlt[4].

    F-PREUSSA = Almmmatg.Prevta[2] / Almmmatg.TpoCmb.
    F-PREUSSB = Almmmatg.Prevta[3] / Almmmatg.TpoCmb.
    F-PREUSSC = Almmmatg.Prevta[4] / Almmmatg.TpoCmb.
    F-PREUSSD = Almmmatg.PreAlt[4] / Almmmatg.TpoCmb.
  END.
  ELSE DO:
    F-PREUSSA = Almmmatg.Prevta[2].
    F-PREUSSB = Almmmatg.Prevta[3].
    F-PREUSSC = Almmmatg.Prevta[4].
    F-PREUSSD = Almmmatg.PreAlt[4].

    F-PRESOLA = Almmmatg.Prevta[2] * Almmmatg.TpoCmb.
    F-PRESOLB = Almmmatg.Prevta[3] * Almmmatg.TpoCmb.
    F-PRESOLC = Almmmatg.Prevta[4] * Almmmatg.TpoCmb.
    F-PRESOLD = Almmmatg.PreAlt[4] * Almmmatg.TpoCmb.
  END.
         
      DISPLAY STREAM REPORT 
               Almmmatg.codmat
               Almmmatg.DesMat
               Almmmatg.TipArt
               Almmmatg.DesMar
               Almmmatg.UndBas
               Almmmatg.MonVta
               F-PRESOLA    WHEN F-PRESOLA <> 0
               F-PREUSSA    WHEN F-PREUSSA <> 0
               Almmmatg.UndA    WHEN Almmmatg.UndA <> ""
               F-PRESOLB    WHEN F-PRESOLB <> 0
               F-PREUSSB    WHEN F-PREUSSB <> 0
               Almmmatg.UndB    WHEN Almmmatg.UndB <> "" 
               F-PRESOLC    WHEN F-PRESOLC <> 0
               F-PREUSSC    WHEN F-PREUSSC <> 0
               Almmmatg.UndC    WHEN Almmmatg.UndC <> ""
               F-PRESOLD    WHEN F-PRESOLD <> 0
               F-PREUSSD    WHEN F-PREUSSD <> 0
               Almmmatg.Chr__01 WHEN Almmmatg.Chr__01 <> ""
               WITH FRAME F-REPORTE.
      DOWN STREAM REPORT WITH FRAME F-REPORTE.
       
  END.
  HIDE FRAME F-PROCESO.

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
    ENABLE ALL EXCEPT F-DesFam F-DesSub.
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
    DEFINE VARIABLE i AS INTEGER NO-UNDO.
   
    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}= 0 THEN
        f-Categorias = 'Todas'.
    ELSE DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN IF i = 1 
            THEN f-Categorias = TRIM(T-TABLA.Codigo).
            ELSE f-Categorias = f-Categorias + ',' + TRIM(T-TABLA.Codigo).
    END.

    CASE nCodMon:
        WHEN 1 THEN mensaje = "EXPRESADO EN SOLES".
        WHEN 2 THEN mensaje = "EXPRESADO EN DOLARES".
        WHEN 3 THEN mensaje = "EXPRESADO EN SOLES/DOLARES".
    END CASE.

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        CASE nCodMon:
            WHEN 1 THEN RUN Formato-1.
            WHEN 2 THEN RUN Formato-2.
            WHEN 3 THEN RUN Formato-3.
        END CASE.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
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
  ASSIGN DesdeC F-CodFam F-DesFam HastaC nCodMon R-Tipo.
  
  IF HastaC <> "" THEN HastaC = "".
/*  IF DesdeF <> ?  THEN DesdeF = ?.
  IF HastaF <> ?  THEN HastaF = ?.*/

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
  DEF VAR x-Cat AS CHAR INIT 'A,B,C,D,E,F'.
  DEF VAR i AS INT.
  
  DO i = 1 TO NUM-ENTRIES(x-Cat):
    CREATE T-Tabla.
    T-Tabla.Codigo = ENTRY(i, x-Cat).
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN /*DesdeF = TODAY  + 1 - DAY(TODAY).
 *             HastaF = TODAY.*/
            R-Tipo = 'A'.
     DISPLAY /*DesdeF HastaF*/ R-Tipo.
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
        WHEN "F-Subfam" THEN ASSIGN input-var-1 = F-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        WHEN "F-marca1" OR WHEN "F-marca2" THEN ASSIGN input-var-1 = "MK".
        WHEN "" THEN ASSIGN input-var-1 = "".
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
  {src/adm/template/snd-list.i "t-tabla"}

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

